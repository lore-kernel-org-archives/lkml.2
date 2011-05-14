Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab1ENKHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:07:18 -0400
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:1621 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147Ab1ENKHN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:07:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH RFC] radio-sf16fmr2: convert to generic TEA575x interface
Date: Sat, 14 May 2011 12:06:51 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
References: <201105140017.26968.linux@rainbow-software.org>
In-Reply-To: <201105140017.26968.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105141206.51832.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 14, 2011 00:17:23 Ondrej Zary wrote:
> Hello,
> the SF16-FMR2 radio card is basically a TEA5757 tuner connected to ISA bus but
> the driver currently uses its own implementation. I converted the driver to
> use generic tea575x-tuner implementation (see patch below) and it works fine.

Good!

> But the tea575x-tuner module is located in /sound/i2c/other and the
> corresponding Kconfig in /sound/pci. Should it be moved
> to /drivers/media/radio or better leave it as is?

Good question. It's in a weird place, but moving it may be more trouble than
it is worth. It might be a good idea to just try it and see if that improves
things or not.

> The card can optionally be equipped with PT2254A volume control (equivalent of
> TC9154AP) so I need to extend tea575x-tuner to allow adding additional V4L2
> controls (and add one if the chip is present). Is this OK or should be
> something like v4l2_subdev used somehow?
> (My card does not have the PT2254A chip so that code is untested.)

No, this isn't the right approach. This should be done using the control
framework (see Documentation/video4linux/v4l2-controls.txt).

In order to use that the tea575x-tuner driver needs to be converted to that
framework, and so should any V4L driver that uses it. It's a fair amount of
work, although it is worth doing since it will ensure that these drivers
fully and correctly implement the V4L2 control API.

Thank you for looking into this, BTW! It's been on my TODO list for a long
time but I never had time to actually work on it.

Regards,

	Hans

> 
> 
> --- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-05-13 19:39:23.000000000 +0200
> +++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-05-14 00:14:23.000000000 +0200
> @@ -54,6 +54,11 @@ struct snd_tea575x {
>  	void *private_data;
>  	u8 card[32];
>  	u8 bus_info[32];
> +	/* card driver can provide additional controls (e.g. volume) */
> +	struct v4l2_queryctrl *extra_ctrls;	/* array of controls */
> +	int num_extra_ctrls;		/* number of additional controls */
> +	int (*g_extra_ctrl)(struct file *file, void *fh, struct v4l2_control *a);
> +	int (*s_extra_ctrl)(struct file *file, void *fh, struct v4l2_control *a);
>  };
>  
>  int snd_tea575x_init(struct snd_tea575x *tea);
> --- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-05-13 19:39:23.000000000 +0200
> +++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-05-13 21:35:57.000000000 +0200
> @@ -269,6 +269,7 @@ static int vidioc_s_audio(struct file *f
>  static int vidioc_queryctrl(struct file *file, void *priv,
>  					struct v4l2_queryctrl *qc)
>  {
> +	struct snd_tea575x *tea = video_drvdata(file);
>  	int i;
>  
>  	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
> @@ -278,6 +279,13 @@ static int vidioc_queryctrl(struct file
>  			return 0;
>  		}
>  	}
> +	for (i = 0; i < tea->num_extra_ctrls; i++) {
> +		if (qc->id && qc->id == tea->extra_ctrls[i].id) {
> +			memcpy(qc, &(tea->extra_ctrls[i]),
> +						sizeof(*qc));
> +			return 0;
> +		}
> +	}
>  	return -EINVAL;
>  }
>  
> @@ -291,6 +299,10 @@ static int vidioc_g_ctrl(struct file *fi
>  		ctrl->value = tea->mute;
>  		return 0;
>  	}
> +
> +	if (tea->g_extra_ctrl)
> +		return tea->g_extra_ctrl(file, priv, ctrl);
> +
>  	return -EINVAL;
>  }
>  
> @@ -307,6 +319,10 @@ static int vidioc_s_ctrl(struct file *fi
>  		}
>  		return 0;
>  	}
> +
> +	if (tea->s_extra_ctrl)
> +		return tea->s_extra_ctrl(file, priv, ctrl);
> +
>  	return -EINVAL;
>  }
>  
> --- linux-2.6.39-rc2-/drivers/media/radio/radio-sf16fmr2.c	2011-04-06 03:30:43.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/media/radio/radio-sf16fmr2.c	2011-05-14 00:15:05.000000000 +0200
> @@ -1,441 +1,206 @@
> -/* SF16FMR2 radio driver for Linux radio support
> - * heavily based on fmi driver...
> - * (c) 2000-2002 Ziglio Frediano, freddy77@angelfire.com
> +/* SF16-FMR2 radio driver for Linux
> + * Copyright (c) 2011 Ondrej Zary
>   *
> - * Notes on the hardware
> - *
> - *  Frequency control is done digitally -- ie out(port,encodefreq(95.8));
> - *  No volume control - only mute/unmute - you have to use line volume
> - *
> - *  For read stereo/mono you must wait 0.1 sec after set frequency and
> - *  card unmuted so I set frequency on unmute
> - *  Signal handling seem to work only on autoscanning (not implemented)
> - *
> - *  Converted to V4L2 API by Mauro Carvalho Chehab <mchehab@infradead.org>
> + * Original driver was (c) 2000-2002 Ziglio Frediano, freddy77@angelfire.com
> + * but almost nothing remained here after conversion to generic TEA575x
> + * interface
>   */
>  
> +#include <linux/delay.h>
>  #include <linux/module.h>	/* Modules 			*/
>  #include <linux/init.h>		/* Initdata			*/
>  #include <linux/ioport.h>	/* request_region		*/
> -#include <linux/delay.h>	/* udelay			*/
> -#include <linux/videodev2.h>	/* kernel radio structs		*/
> -#include <linux/mutex.h>
> -#include <linux/version.h>      /* for KERNEL_VERSION MACRO     */
>  #include <linux/io.h>		/* outb, outb_p			*/
> -#include <media/v4l2-device.h>
> -#include <media/v4l2-ioctl.h>
> +#include <sound/tea575x-tuner.h>
>  
> -MODULE_AUTHOR("Ziglio Frediano, freddy77@angelfire.com");
> -MODULE_DESCRIPTION("A driver for the SF16FMR2 radio.");
> +MODULE_AUTHOR("Ondrej Zary");
> +MODULE_DESCRIPTION("MediaForte SF16-FMR2 FM radio card driver");
>  MODULE_LICENSE("GPL");
>  
> -static int io = 0x384;
> -static int radio_nr = -1;
> -
> -module_param(io, int, 0);
> -MODULE_PARM_DESC(io, "I/O address of the SF16FMR2 card (should be 0x384, if do not work try 0x284)");
> -module_param(radio_nr, int, 0);
> -
> -#define RADIO_VERSION KERNEL_VERSION(0,0,2)
> -
> -#define AUD_VOL_INDEX 1
> -
> -#undef DEBUG
> -//#define DEBUG 1
> -
> -#ifdef DEBUG
> -# define  debug_print(s) printk s
> -#else
> -# define  debug_print(s)
> -#endif
> -
> -/* this should be static vars for module size */
> -struct fmr2
> -{
> -	struct v4l2_device v4l2_dev;
> -	struct video_device vdev;
> -	struct mutex lock;
> +struct fmr2 {
>  	int io;
> -	int curvol; /* 0-15 */
> -	int mute;
> -	int stereo; /* card is producing stereo audio */
> -	unsigned long curfreq; /* freq in kHz */
> -	int card_type;
> +	int volume;
> +	struct snd_tea575x tea;
>  };
>  
> +/* the port is hardwired so no need to support multiple cards */
> +#define FMR2_PORT	0x384
>  static struct fmr2 fmr2_card;
>  
> -/* hw precision is 12.5 kHz
> - * It is only useful to give freq in interval of 200 (=0.0125Mhz),
> - * other bits will be truncated
> - */
> -#define RSF16_ENCODE(x)	((x) / 200 + 856)
> -#define RSF16_MINFREQ (87 * 16000)
> -#define RSF16_MAXFREQ (108 * 16000)
> -
> -static inline void wait(int n, int io)
> -{
> -	for (; n; --n)
> -		inb(io);
> -}
> -
> -static void outbits(int bits, unsigned int data, int nWait, int io)
> -{
> -	int bit;
> -
> -	for (; --bits >= 0;) {
> -		bit = (data >> bits) & 1;
> -		outb(bit, io);
> -		wait(nWait, io);
> -		outb(bit | 2, io);
> -		wait(nWait, io);
> -		outb(bit, io);
> -		wait(nWait, io);
> -	}
> -}
> -
> -static inline void fmr2_mute(int io)
> -{
> -	outb(0x00, io);
> -	wait(4, io);
> -}
> -
> -static inline void fmr2_unmute(int io)
> -{
> -	outb(0x04, io);
> -	wait(4, io);
> -}
> -
> -static inline int fmr2_stereo_mode(int io)
> -{
> -	int n = inb(io);
> -
> -	outb(6, io);
> -	inb(io);
> -	n = ((n >> 3) & 1) ^ 1;
> -	debug_print((KERN_DEBUG "stereo: %d\n", n));
> -	return n;
> -}
> -
> -static int fmr2_product_info(struct fmr2 *dev)
> -{
> -	int n = inb(dev->io);
> -
> -	n &= 0xC1;
> -	if (n == 0) {
> -		/* this should support volume set */
> -		dev->card_type = 12;
> -		return 0;
> -	}
> -	/* not volume (mine is 11) */
> -	dev->card_type = (n == 128) ? 11 : 0;
> -	return n;
> -}
> -
> -static inline int fmr2_getsigstr(struct fmr2 *dev)
> -{
> -	/* !!! works only if scanning freq */
> -	int res = 0xffff;
> -
> -	outb(5, dev->io);
> -	wait(4, dev->io);
> -	if (!(inb(dev->io) & 1))
> -		res = 0;
> -	debug_print((KERN_DEBUG "signal: %d\n", res));
> -	return res;
> -}
> +/* TEA575x tuner pins */
> +#define STR_DATA	(1 << 0)
> +#define STR_CLK		(1 << 1)
> +#define STR_WREN	(1 << 2)
> +#define STR_MOST	(1 << 3)
> +/* PT2254A/TC9154A volume control pins */
> +#define PT_ST		(1 << 4)
> +#define PT_CK		(1 << 5)
> +#define PT_DATA		(1 << 6)
> +/* volume control presence pin */
> +#define FMR2_HASVOL	(1 << 7)
>  
> -/* set frequency and unmute card */
> -static int fmr2_setfreq(struct fmr2 *dev)
> +static void fmr2_tea575x_set_pins(struct snd_tea575x *tea, u8 pins)
>  {
> -	unsigned long freq = dev->curfreq;
> +	struct fmr2 *fmr2 = tea->private_data;
> +	u8 bits = 0;
>  
> -	fmr2_mute(dev->io);
> +	bits |= (pins & TEA575X_DATA) ? STR_DATA : 0;
> +	bits |= (pins & TEA575X_CLK)  ? STR_CLK  : 0;
> +	/* WRITE_ENABLE is inverted, DATA must be high during read */
> +	bits |= (pins & TEA575X_WREN) ? 0 : STR_WREN | STR_DATA;
>  
> -	/* 0x42 for mono output
> -	 * 0x102 forward scanning
> -	 * 0x182 scansione avanti
> -	 */
> -	outbits(9, 0x2, 3, dev->io);
> -	outbits(16, RSF16_ENCODE(freq), 2, dev->io);
> -
> -	fmr2_unmute(dev->io);
> -
> -	/* wait 0.11 sec */
> -	msleep(110);
> -
> -	/* NOTE if mute this stop radio
> -	   you must set freq on unmute */
> -	dev->stereo = fmr2_stereo_mode(dev->io);
> -	return 0;
> -}
> -
> -/* !!! not tested, in my card this does't work !!! */
> -static int fmr2_setvolume(struct fmr2 *dev)
> -{
> -	int vol[16] = { 0x021, 0x084, 0x090, 0x104,
> -			0x110, 0x204, 0x210, 0x402,
> -			0x404, 0x408, 0x410, 0x801,
> -			0x802, 0x804, 0x808, 0x810 };
> -	int i, a;
> -	int n = vol[dev->curvol & 0x0f];
> -
> -	if (dev->card_type != 11)
> -		return 1;
> -
> -	for (i = 12; --i >= 0; ) {
> -		a = ((n >> i) & 1) << 6; /* if (a==0) a = 0; else a = 0x40; */
> -		outb(a | 4, dev->io);
> -		wait(4, dev->io);
> -		outb(a | 0x24, dev->io);
> -		wait(4, dev->io);
> -		outb(a | 4, dev->io);
> -		wait(4, dev->io);
> -	}
> -	for (i = 6; --i >= 0; ) {
> -		a = ((0x18 >> i) & 1) << 6;
> -		outb(a | 4, dev->io);
> -		wait(4, dev->io);
> -		outb(a | 0x24, dev->io);
> -		wait(4, dev->io);
> -		outb(a | 4, dev->io);
> -		wait(4, dev->io);
> -	}
> -	wait(4, dev->io);
> -	outb(0x14, dev->io);
> -	return 0;
> -}
> -
> -static int vidioc_querycap(struct file *file, void  *priv,
> -					struct v4l2_capability *v)
> -{
> -	strlcpy(v->driver, "radio-sf16fmr2", sizeof(v->driver));
> -	strlcpy(v->card, "SF16-FMR2 radio", sizeof(v->card));
> -	strlcpy(v->bus_info, "ISA", sizeof(v->bus_info));
> -	v->version = RADIO_VERSION;
> -	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
> -	return 0;
> +	outb(bits, fmr2->io);
>  }
>  
> -static int vidioc_g_tuner(struct file *file, void *priv,
> -					struct v4l2_tuner *v)
> +static u8 fmr2_tea575x_get_pins(struct snd_tea575x *tea)
>  {
> -	struct fmr2 *fmr2 = video_drvdata(file);
> -
> -	if (v->index > 0)
> -		return -EINVAL;
> +	struct fmr2 *fmr2 = tea->private_data;
> +	u8 bits = inb(fmr2->io);
>  
> -	strlcpy(v->name, "FM", sizeof(v->name));
> -	v->type = V4L2_TUNER_RADIO;
> -
> -	v->rangelow = RSF16_MINFREQ;
> -	v->rangehigh = RSF16_MAXFREQ;
> -	v->rxsubchans = fmr2->stereo ? V4L2_TUNER_SUB_STEREO :
> -					V4L2_TUNER_SUB_MONO;
> -	v->capability = V4L2_TUNER_CAP_STEREO | V4L2_TUNER_CAP_LOW;
> -	v->audmode = V4L2_TUNER_MODE_STEREO;
> -	mutex_lock(&fmr2->lock);
> -	v->signal = fmr2_getsigstr(fmr2);
> -	mutex_unlock(&fmr2->lock);
> -	return 0;
> +	return  (bits & STR_DATA) ? TEA575X_DATA : 0 |
> +		(bits & STR_MOST) ? TEA575X_MOST : 0;
>  }
>  
> -static int vidioc_s_tuner(struct file *file, void *priv,
> -					struct v4l2_tuner *v)
> +static void fmr2_tea575x_set_direction(struct snd_tea575x *tea, bool output)
>  {
> -	return v->index ? -EINVAL : 0;
>  }
>  
> -static int vidioc_s_frequency(struct file *file, void *priv,
> -					struct v4l2_frequency *f)
> -{
> -	struct fmr2 *fmr2 = video_drvdata(file);
> -
> -	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
> -		return -EINVAL;
> -	if (f->frequency < RSF16_MINFREQ ||
> -			f->frequency > RSF16_MAXFREQ)
> -		return -EINVAL;
> -	/* rounding in steps of 200 to match the freq
> -	   that will be used */
> -	fmr2->curfreq = (f->frequency / 200) * 200;
> -
> -	/* set card freq (if not muted) */
> -	if (fmr2->curvol && !fmr2->mute) {
> -		mutex_lock(&fmr2->lock);
> -		fmr2_setfreq(fmr2);
> -		mutex_unlock(&fmr2->lock);
> -	}
> -	return 0;
> -}
> -
> -static int vidioc_g_frequency(struct file *file, void *priv,
> -					struct v4l2_frequency *f)
> -{
> -	struct fmr2 *fmr2 = video_drvdata(file);
> -
> -	if (f->tuner != 0)
> -		return -EINVAL;
> -	f->type = V4L2_TUNER_RADIO;
> -	f->frequency = fmr2->curfreq;
> -	return 0;
> -}
> +static struct snd_tea575x_ops fmr2_tea_ops = {
> +	.set_pins = fmr2_tea575x_set_pins,
> +	.get_pins = fmr2_tea575x_get_pins,
> +	.set_direction = fmr2_tea575x_set_direction,
> +};
>  
> -static int vidioc_queryctrl(struct file *file, void *priv,
> -					struct v4l2_queryctrl *qc)
> -{
> -	struct fmr2 *fmr2 = video_drvdata(file);
> +/* TC9154A/PT2254A volume control */
>  
> -	switch (qc->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 1);
> -	case V4L2_CID_AUDIO_VOLUME:
> -		/* Only card_type == 11 implements volume */
> -		if (fmr2->card_type == 11)
> -			return v4l2_ctrl_query_fill(qc, 0, 15, 1, 0);
> -		return v4l2_ctrl_query_fill(qc, 0, 1, 1, 0);
> +/* 18-bit shift register bit definitions */
> +#define TC9154A_ATT_MAJ_0DB	(1 << 0)
> +#define TC9154A_ATT_MAJ_10DB	(1 << 1)
> +#define TC9154A_ATT_MAJ_20DB	(1 << 2)
> +#define TC9154A_ATT_MAJ_30DB	(1 << 3)
> +#define TC9154A_ATT_MAJ_40DB	(1 << 4)
> +#define TC9154A_ATT_MAJ_50DB	(1 << 5)
> +#define TC9154A_ATT_MAJ_60DB	(1 << 6)
> +
> +#define TC9154A_ATT_MIN_0DB	(1 << 7)
> +#define TC9154A_ATT_MIN_2DB	(1 << 8)
> +#define TC9154A_ATT_MIN_4DB	(1 << 9)
> +#define TC9154A_ATT_MIN_6DB	(1 << 10)
> +#define TC9154A_ATT_MIN_8DB	(1 << 11)
> +/* bit 12 is ignored */
> +#define TC9154A_CHANNEL_LEFT	(1 << 13)
> +#define TC9154A_CHANNEL_RIGHT	(1 << 14)
> +/* bits 15, 16, 17 must be 0 */
> +
> +#define	TC9154A_ATT_MAJ(x)	(1 << x)
> +#define TC9154A_ATT_MIN(x)	(1 << (7 + x))
> +
> +static void tc9154a_set_pins(struct fmr2 *fmr2, u8 pins)
> +{
> +	if (!fmr2->tea.mute)
> +		pins |= STR_WREN;
> +
> +	outb(pins, fmr2->io);
> +}
> +
> +static void tc9154a_set_volume(struct fmr2 *fmr2, int volume)
> +{
> +	int i;
> +	u32 reg;
> +	u8 bit;
> +
> +	reg = TC9154A_ATT_MAJ(volume / 10) | TC9154A_ATT_MIN((volume % 10) / 2);
> +	reg |= TC9154A_CHANNEL_LEFT | TC9154A_CHANNEL_RIGHT;
> +	/* write 18-bit shift register, LSB first */
> +	for (i = 0; i < 18; i++) {
> +		bit = reg & (1 << i) ? PT_DATA : 0;
> +		tc9154a_set_pins(fmr2, bit);
> +		udelay(5);
> +		tc9154a_set_pins(fmr2, bit | PT_CK);
> +		udelay(5);
> +		tc9154a_set_pins(fmr2, bit);
> +	}
> +
> +	/* latch register data */
> +	udelay(5);
> +	tc9154a_set_pins(fmr2, PT_ST);
> +	udelay(5);
> +	tc9154a_set_pins(fmr2, 0);
> +}
> +
> +static struct v4l2_queryctrl fmr2_volume_qctrl[] = {
> +	{
> +		.id		= V4L2_CID_AUDIO_VOLUME,
> +		.name		= "Volume",
> +		.minimum	= -68,
> +		.maximum	= 0,
> +		.step		= 2,
> +		.default_value	= -68,
> +		.type		= V4L2_CTRL_TYPE_INTEGER,
>  	}
> -	return -EINVAL;
> -}
> +};
>  
> -static int vidioc_g_ctrl(struct file *file, void *priv,
> +static int fmr2_g_extra_ctrl(struct file *file, void *priv,
>  					struct v4l2_control *ctrl)
>  {
> -	struct fmr2 *fmr2 = video_drvdata(file);
> +	struct snd_tea575x *tea = video_drvdata(file);
> +	struct fmr2 *fmr2 = tea->private_data;
>  
>  	switch (ctrl->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		ctrl->value = fmr2->mute;
> -		return 0;
>  	case V4L2_CID_AUDIO_VOLUME:
> -		ctrl->value = fmr2->curvol;
> +		ctrl->value = fmr2->volume;
>  		return 0;
>  	}
> +
>  	return -EINVAL;
>  }
>  
> -static int vidioc_s_ctrl(struct file *file, void *priv,
> +static int fmr2_s_extra_ctrl(struct file *file, void *priv,
>  					struct v4l2_control *ctrl)
>  {
> -	struct fmr2 *fmr2 = video_drvdata(file);
> +	struct snd_tea575x *tea = video_drvdata(file);
> +	struct fmr2 *fmr2 = tea->private_data;
>  
>  	switch (ctrl->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		fmr2->mute = ctrl->value;
> -		break;
>  	case V4L2_CID_AUDIO_VOLUME:
> -		fmr2->curvol = ctrl->value;
> -		break;
> -	default:
> -		return -EINVAL;
> +		fmr2->volume = ctrl->value;
> +		tc9154a_set_volume(fmr2, fmr2->volume);
> +		return 0;
>  	}
>  
> -#ifdef DEBUG
> -	if (fmr2->curvol && !fmr2->mute)
> -		printk(KERN_DEBUG "unmute\n");
> -	else
> -		printk(KERN_DEBUG "mute\n");
> -#endif
> -
> -	mutex_lock(&fmr2->lock);
> -	if (fmr2->curvol && !fmr2->mute) {
> -		fmr2_setvolume(fmr2);
> -		/* Set frequency and unmute card */
> -		fmr2_setfreq(fmr2);
> -	} else
> -		fmr2_mute(fmr2->io);
> -	mutex_unlock(&fmr2->lock);
> -	return 0;
> -}
> -
> -static int vidioc_g_input(struct file *filp, void *priv, unsigned int *i)
> -{
> -	*i = 0;
> -	return 0;
> -}
> -
> -static int vidioc_s_input(struct file *filp, void *priv, unsigned int i)
> -{
> -	return i ? -EINVAL : 0;
> -}
> -
> -static int vidioc_g_audio(struct file *file, void *priv,
> -					struct v4l2_audio *a)
> -{
> -	a->index = 0;
> -	strlcpy(a->name, "Radio", sizeof(a->name));
> -	a->capability = V4L2_AUDCAP_STEREO;
> -	return 0;
> -}
> -
> -static int vidioc_s_audio(struct file *file, void *priv,
> -					struct v4l2_audio *a)
> -{
> -	return a->index ? -EINVAL : 0;
> +	return -EINVAL;
>  }
>  
> -static const struct v4l2_file_operations fmr2_fops = {
> -	.owner          = THIS_MODULE,
> -	.unlocked_ioctl = video_ioctl2,
> -};
> -
> -static const struct v4l2_ioctl_ops fmr2_ioctl_ops = {
> -	.vidioc_querycap    = vidioc_querycap,
> -	.vidioc_g_tuner     = vidioc_g_tuner,
> -	.vidioc_s_tuner     = vidioc_s_tuner,
> -	.vidioc_g_audio     = vidioc_g_audio,
> -	.vidioc_s_audio     = vidioc_s_audio,
> -	.vidioc_g_input     = vidioc_g_input,
> -	.vidioc_s_input     = vidioc_s_input,
> -	.vidioc_g_frequency = vidioc_g_frequency,
> -	.vidioc_s_frequency = vidioc_s_frequency,
> -	.vidioc_queryctrl   = vidioc_queryctrl,
> -	.vidioc_g_ctrl      = vidioc_g_ctrl,
> -	.vidioc_s_ctrl      = vidioc_s_ctrl,
> -};
> -
>  static int __init fmr2_init(void)
>  {
>  	struct fmr2 *fmr2 = &fmr2_card;
> -	struct v4l2_device *v4l2_dev = &fmr2->v4l2_dev;
> -	int res;
>  
> -	strlcpy(v4l2_dev->name, "sf16fmr2", sizeof(v4l2_dev->name));
> -	fmr2->io = io;
> -	fmr2->stereo = 1;
> -	mutex_init(&fmr2->lock);
> +	fmr2->io = FMR2_PORT;
>  
> -	if (!request_region(fmr2->io, 2, "sf16fmr2")) {
> -		v4l2_err(v4l2_dev, "request_region failed!\n");
> +	if (!request_region(fmr2->io, 2, "SF16-FMR2")) {
> +		printk(KERN_ERR "I/O port 0x%x already in use\n", fmr2->io);
>  		return -EBUSY;
>  	}
>  
> -	res = v4l2_device_register(NULL, v4l2_dev);
> -	if (res < 0) {
> +	fmr2->tea.private_data = fmr2;
> +	fmr2->tea.ops = &fmr2_tea_ops;
> +	strlcpy(fmr2->tea.card, "SF16-FMR2", sizeof(fmr2->tea.card));
> +	strcpy(fmr2->tea.bus_info, "ISA");
> +
> +	if (snd_tea575x_init(&fmr2->tea)) {
> +		printk(KERN_ERR "Unable to detect TEA575x tuner\n");
>  		release_region(fmr2->io, 2);
> -		v4l2_err(v4l2_dev, "Could not register v4l2_device\n");
> -		return res;
> +		return -ENODEV;
>  	}
>  
> -	strlcpy(fmr2->vdev.name, v4l2_dev->name, sizeof(fmr2->vdev.name));
> -	fmr2->vdev.v4l2_dev = v4l2_dev;
> -	fmr2->vdev.fops = &fmr2_fops;
> -	fmr2->vdev.ioctl_ops = &fmr2_ioctl_ops;
> -	fmr2->vdev.release = video_device_release_empty;
> -	video_set_drvdata(&fmr2->vdev, fmr2);
> -
> -	/* mute card - prevents noisy bootups */
> -	fmr2_mute(fmr2->io);
> -	fmr2_product_info(fmr2);
> -
> -	if (video_register_device(&fmr2->vdev, VFL_TYPE_RADIO, radio_nr) < 0) {
> -		v4l2_device_unregister(v4l2_dev);
> -		release_region(fmr2->io, 2);
> -		return -EINVAL;
> +	if (inb(fmr2->io) & FMR2_HASVOL) {
> +		fmr2->tea.extra_ctrls = fmr2_volume_qctrl;
> +		fmr2->tea.num_extra_ctrls = 1;
> +		fmr2->tea.g_extra_ctrl = fmr2_g_extra_ctrl;
> +		fmr2->tea.s_extra_ctrl = fmr2_s_extra_ctrl;
>  	}
>  
> -	v4l2_info(v4l2_dev, "SF16FMR2 radio card driver at 0x%x.\n", fmr2->io);
> -	debug_print((KERN_DEBUG "card_type %d\n", fmr2->card_type));
> +	printk(KERN_INFO "SF16-FMR2 radio card at 0x%x.\n", fmr2->io);
>  	return 0;
>  }
>  
> @@ -443,22 +208,9 @@ static void __exit fmr2_exit(void)
>  {
>  	struct fmr2 *fmr2 = &fmr2_card;
>  
> -	video_unregister_device(&fmr2->vdev);
> -	v4l2_device_unregister(&fmr2->v4l2_dev);
> +	snd_tea575x_exit(&fmr2->tea);
>  	release_region(fmr2->io, 2);
>  }
>  
>  module_init(fmr2_init);
>  module_exit(fmr2_exit);
> -
> -#ifndef MODULE
> -
> -static int __init fmr2_setup_io(char *str)
> -{
> -	get_option(&str, &io);
> -	return 1;
> -}
> -
> -__setup("sf16fmr2=", fmr2_setup_io);
> -
> -#endif
> 
> 
> 
