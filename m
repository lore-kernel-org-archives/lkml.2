Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030Ab1CVSkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 14:40:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:37806 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab1CVSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 14:40:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FVgaQqGkHlpI2awMVW6ZLkl8QwZ0fJ81+B9mB9mxDC0Fp4RtE0sp8Lq+QKDbXiM1is
         o2ds37pqEoFklAWBqDj4iwOQgRmsrRXYu21kTfnc/w1Szv+ht/FKtIcNCk/aeMkqdzU8
         4VcfbAiWMe6KOb18w5U9YibcJ9RucVEPmzqZA=
Message-ID: <4D88ECFD.9000706@gmail.com>
Date: Tue, 22 Mar 2011 15:39:57 -0300
From: Mauro Carvalho Chehab <maurochehab@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Ondrej Zary <linux@rainbow-software.org>,
        Hans Verkuil <hverkuil@xs4all.nl>, jirislaby@gmail.com,
        alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Subject: Re: [RFC PATCH 1/3] tea575x-tuner: various improvements
References: <201103121919.05657.linux@rainbow-software.org>	<201103141128.01259.linux@rainbow-software.org>	<33b29bfb135fbe2ddcba88d342d67526.squirrel@webmail.xs4all.nl>	<201103191632.58347.linux@rainbow-software.org> <s5htyewr8xg.wl%tiwai@suse.de>
In-Reply-To: <s5htyewr8xg.wl%tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 21-03-2011 08:48, Takashi Iwai escreveu:
> At Sat, 19 Mar 2011 16:32:53 +0100,
> Ondrej Zary wrote:
>>
>> Improve tea575x-tuner with various good things from radio-maestro:
>> - extend frequency range to 50-150MHz
>> - fix querycap(): card name, CAP_RADIO
>> - improve g_tuner(): CAP_STEREO, stereo and tuned indication
>> - improve g_frequency(): tuner index checking and reading frequency from HW
>> - improve s_frequency(): tuner index and type checking
>>
>> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> Applied these 3 patches now to topic/misc branch of sound git tree
> (i.e. for 2.6.40 kernel).

Patches look sane to me, you may add my ACK if you want.

Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>

> 
> I leave the removal of radio-maestro to v4l guys, as this is fairly
> independent.
> 
> 
> thanks,
> 
> Takashi
> 
> 
>> --- linux-2.6.38-rc4-orig/sound/i2c/other/tea575x-tuner.c	2011-02-08 01:03:55.000000000 +0100
>> +++ linux-2.6.38-rc4/sound/i2c/other/tea575x-tuner.c	2011-03-19 15:40:14.000000000 +0100
>> @@ -37,8 +37,8 @@ static int radio_nr = -1;
>>  module_param(radio_nr, int, 0);
>>  
>>  #define RADIO_VERSION KERNEL_VERSION(0, 0, 2)
>> -#define FREQ_LO		 (87 * 16000)
>> -#define FREQ_HI		(108 * 16000)
>> +#define FREQ_LO		 (50UL * 16000)
>> +#define FREQ_HI		(150UL * 16000)
>>  
>>  /*
>>   * definitions
>> @@ -77,15 +77,29 @@ static struct v4l2_queryctrl radio_qctrl
>>   * lowlevel part
>>   */
>>  
>> +static void snd_tea575x_get_freq(struct snd_tea575x *tea)
>> +{
>> +	unsigned long freq;
>> +
>> +	freq = tea->ops->read(tea) & TEA575X_BIT_FREQ_MASK;
>> +	/* freq *= 12.5 */
>> +	freq *= 125;
>> +	freq /= 10;
>> +	/* crystal fixup */
>> +	if (tea->tea5759)
>> +		freq += tea->freq_fixup;
>> +	else
>> +		freq -= tea->freq_fixup;
>> +
>> +	tea->freq = freq * 16;		/* from kHz */
>> +}
>> +
>>  static void snd_tea575x_set_freq(struct snd_tea575x *tea)
>>  {
>>  	unsigned long freq;
>>  
>> -	freq = tea->freq / 16;		/* to kHz */
>> -	if (freq > 108000)
>> -		freq = 108000;
>> -	if (freq < 87000)
>> -		freq = 87000;
>> +	freq = clamp(tea->freq, FREQ_LO, FREQ_HI);
>> +	freq /= 16;		/* to kHz */
>>  	/* crystal fixup */
>>  	if (tea->tea5759)
>>  		freq -= tea->freq_fixup;
>> @@ -109,29 +123,33 @@ static int vidioc_querycap(struct file *
>>  {
>>  	struct snd_tea575x *tea = video_drvdata(file);
>>  
>> -	strcpy(v->card, tea->tea5759 ? "TEA5759" : "TEA5757");
>>  	strlcpy(v->driver, "tea575x-tuner", sizeof(v->driver));
>> -	strlcpy(v->card, "Maestro Radio", sizeof(v->card));
>> +	strlcpy(v->card, tea->tea5759 ? "TEA5759" : "TEA5757", sizeof(v->card));
>>  	sprintf(v->bus_info, "PCI");
>>  	v->version = RADIO_VERSION;
>> -	v->capabilities = V4L2_CAP_TUNER;
>> +	v->capabilities = V4L2_CAP_TUNER | V4L2_CAP_RADIO;
>>  	return 0;
>>  }
>>  
>>  static int vidioc_g_tuner(struct file *file, void *priv,
>>  					struct v4l2_tuner *v)
>>  {
>> +	struct snd_tea575x *tea = video_drvdata(file);
>> +
>>  	if (v->index > 0)
>>  		return -EINVAL;
>>  
>> +	tea->ops->read(tea);
>> +
>>  	strcpy(v->name, "FM");
>>  	v->type = V4L2_TUNER_RADIO;
>> +	v->capability = V4L2_TUNER_CAP_LOW | V4L2_TUNER_CAP_STEREO;
>>  	v->rangelow = FREQ_LO;
>>  	v->rangehigh = FREQ_HI;
>> -	v->rxsubchans = V4L2_TUNER_SUB_MONO|V4L2_TUNER_SUB_STEREO;
>> -	v->capability = V4L2_TUNER_CAP_LOW;
>> -	v->audmode = V4L2_TUNER_MODE_MONO;
>> -	v->signal = 0xffff;
>> +	v->rxsubchans = V4L2_TUNER_SUB_MONO | V4L2_TUNER_SUB_STEREO;
>> +	v->audmode = tea->stereo ? V4L2_TUNER_MODE_STEREO : V4L2_TUNER_MODE_MONO;
>> +	v->signal = tea->tuned ? 0xffff : 0;
>> +
>>  	return 0;
>>  }
>>  
>> @@ -148,7 +166,10 @@ static int vidioc_g_frequency(struct fil
>>  {
>>  	struct snd_tea575x *tea = video_drvdata(file);
>>  
>> +	if (f->tuner != 0)
>> +		return -EINVAL;
>>  	f->type = V4L2_TUNER_RADIO;
>> +	snd_tea575x_get_freq(tea);
>>  	f->frequency = tea->freq;
>>  	return 0;
>>  }
>> @@ -158,6 +179,9 @@ static int vidioc_s_frequency(struct fil
>>  {
>>  	struct snd_tea575x *tea = video_drvdata(file);
>>  
>> +	if (f->tuner != 0 || f->type != V4L2_TUNER_RADIO)
>> +		return -EINVAL;
>> +
>>  	if (f->frequency < FREQ_LO || f->frequency > FREQ_HI)
>>  		return -EINVAL;
>>  
>> --- linux-2.6.38-rc4-orig/include/sound/tea575x-tuner.h	2011-02-08 01:03:55.000000000 +0100
>> +++ linux-2.6.38-rc4/include/sound/tea575x-tuner.h	2011-03-19 14:18:06.000000000 +0100
>> @@ -38,8 +38,10 @@ struct snd_tea575x {
>>  	struct snd_card *card;
>>  	struct video_device *vd;	/* video device */
>>  	int dev_nr;			/* requested device number + 1 */
>> -	int tea5759;			/* 5759 chip is present */
>> -	int mute;			/* Device is muted? */
>> +	bool tea5759;			/* 5759 chip is present */
>> +	bool mute;			/* Device is muted? */
>> +	bool stereo;			/* receiving stereo */
>> +	bool tuned;			/* tuned to a station */
>>  	unsigned int freq_fixup;	/* crystal onboard */
>>  	unsigned int val;		/* hw value */
>>  	unsigned long freq;		/* frequency */
>>
>>
>> -- 
>> Ondrej Zary
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

