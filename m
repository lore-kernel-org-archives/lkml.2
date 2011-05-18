Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab1ERGWO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:22:14 -0400
Received: from smtp-vbr2.xs4all.nl ([194.109.24.22]:1096 "EHLO
	smtp-vbr2.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab1ERGWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:22:13 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH RFC v2] tea575x: convert to control framework
Date: Wed, 18 May 2011 08:21:54 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-tschai; KDE/4.6.1; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
References: <201105140017.26968.linux@rainbow-software.org> <201105172133.14835.hverkuil@xs4all.nl> <201105172345.10318.linux@rainbow-software.org>
In-Reply-To: <201105172345.10318.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180821.54511.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 17, 2011 23:45:07 Ondrej Zary wrote:
> Convert tea575x-tuner to use the new V4L2 control framework.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-05-13 19:39:23.000000000 +0200
> +++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-05-17 22:35:19.000000000 +0200
> @@ -23,8 +23,7 @@
>   */
>  
>  #include <linux/videodev2.h>
> -#include <media/v4l2-dev.h>
> -#include <media/v4l2-ioctl.h>
> +#include <media/v4l2-ctrls.h>
>  
>  #define TEA575X_FMIF	10700
>  
> @@ -54,6 +53,8 @@ struct snd_tea575x {
>  	void *private_data;
>  	u8 card[32];
>  	u8 bus_info[32];
> +	struct v4l2_ctrl_handler ctrl_handler;
> +	void (*ext_init)(struct snd_tea575x *tea);
>  };
>  
>  int snd_tea575x_init(struct snd_tea575x *tea);
> --- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-05-13 19:39:23.000000000 +0200
> +++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-05-17 23:32:07.000000000 +0200
> @@ -22,11 +22,11 @@
>  
>  #include <asm/io.h>
>  #include <linux/delay.h>
> -#include <linux/interrupt.h>
>  #include <linux/init.h>
>  #include <linux/slab.h>
>  #include <linux/version.h>
> -#include <sound/core.h>
> +#include <media/v4l2-dev.h>
> +#include <media/v4l2-ioctl.h>
>  #include <sound/tea575x-tuner.h>
>  
>  MODULE_AUTHOR("Jaroslav Kysela <perex@perex.cz>");
> @@ -62,17 +62,6 @@ module_param(radio_nr, int, 0);
>  #define TEA575X_BIT_DUMMY	(1<<15)		/* buffer */
>  #define TEA575X_BIT_FREQ_MASK	0x7fff
>  
> -static struct v4l2_queryctrl radio_qctrl[] = {
> -	{
> -		.id            = V4L2_CID_AUDIO_MUTE,
> -		.name          = "Mute",
> -		.minimum       = 0,
> -		.maximum       = 1,
> -		.default_value = 1,
> -		.type          = V4L2_CTRL_TYPE_BOOLEAN,
> -	}
> -};
> -
>  /*
>   * lowlevel part
>   */
> @@ -266,47 +255,19 @@ static int vidioc_s_audio(struct file *f
>  	return 0;
>  }
>  
> -static int vidioc_queryctrl(struct file *file, void *priv,
> -					struct v4l2_queryctrl *qc)
> -{
> -	int i;
> -
> -	for (i = 0; i < ARRAY_SIZE(radio_qctrl); i++) {
> -		if (qc->id && qc->id == radio_qctrl[i].id) {
> -			memcpy(qc, &(radio_qctrl[i]),
> -						sizeof(*qc));
> -			return 0;
> -		}
> -	}
> -	return -EINVAL;
> -}
> -
> -static int vidioc_g_ctrl(struct file *file, void *priv,
> -					struct v4l2_control *ctrl)
> -{
> -	struct snd_tea575x *tea = video_drvdata(file);
> -
> -	switch (ctrl->id) {
> -	case V4L2_CID_AUDIO_MUTE:
> -		ctrl->value = tea->mute;
> -		return 0;
> -	}
> -	return -EINVAL;
> -}
> -
> -static int vidioc_s_ctrl(struct file *file, void *priv,
> -					struct v4l2_control *ctrl)
> +static int tea575x_s_ctrl(struct v4l2_ctrl *ctrl)
>  {
> -	struct snd_tea575x *tea = video_drvdata(file);
> +	struct snd_tea575x *tea = container_of(ctrl->handler, struct snd_tea575x, ctrl_handler);
>  
>  	switch (ctrl->id) {
>  	case V4L2_CID_AUDIO_MUTE:
> -		if (tea->mute != ctrl->value) {
> -			tea->mute = ctrl->value;
> +		if (tea->mute != ctrl->val) {

This test should be removed. s_ctrl is only called when the value actually
changes, and also during handler_setup. With this test the setup call will
actually fail to mute the device.

> +			tea->mute = ctrl->val;
>  			snd_tea575x_set_freq(tea);
>  		}
>  		return 0;
>  	}
> +
>  	return -EINVAL;
>  }
>  
> @@ -355,9 +316,6 @@ static const struct v4l2_ioctl_ops tea57
>  	.vidioc_s_input     = vidioc_s_input,
>  	.vidioc_g_frequency = vidioc_g_frequency,
>  	.vidioc_s_frequency = vidioc_s_frequency,
> -	.vidioc_queryctrl   = vidioc_queryctrl,
> -	.vidioc_g_ctrl      = vidioc_g_ctrl,
> -	.vidioc_s_ctrl      = vidioc_s_ctrl,
>  };
>  
>  static struct video_device tea575x_radio = {
> @@ -367,6 +325,10 @@ static struct video_device tea575x_radio
>  	.release	= video_device_release,
>  };
>  
> +static const struct v4l2_ctrl_ops tea575x_ctrl_ops = {
> +	.s_ctrl = tea575x_s_ctrl,
> +};
> +
>  /*
>   * initialize all the tea575x chips
>   */
> @@ -384,29 +346,39 @@ int snd_tea575x_init(struct snd_tea575x
>  	tea->in_use = 0;
>  	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
>  	tea->freq = 90500 * 16;		/* 90.5Mhz default */
> +	snd_tea575x_set_freq(tea);
>  
>  	tea575x_radio_inst = video_device_alloc();
> -	if (tea575x_radio_inst == NULL) {
> +	if (!tea575x_radio_inst) {
>  		printk(KERN_ERR "tea575x-tuner: not enough memory\n");
>  		return -ENOMEM;
>  	}
>  
>  	memcpy(tea575x_radio_inst, &tea575x_radio, sizeof(tea575x_radio));
> +	video_set_drvdata(tea575x_radio_inst, tea);
>  
> -	strcpy(tea575x_radio.name, tea->tea5759 ?
> -				   "TEA5759 radio" : "TEA5757 radio");
> +	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
> +	tea575x_radio_inst->ctrl_handler = &tea->ctrl_handler;
> +	v4l2_ctrl_new_std(&tea->ctrl_handler, &tea575x_ctrl_ops, V4L2_CID_AUDIO_MUTE, 0, 1, 1, 1);
> +	retval = tea->ctrl_handler.error;
> +	if (retval) {
> +		v4l2_ctrl_handler_free(&tea->ctrl_handler);
> +		kfree(tea575x_radio_inst);
> +		return retval;
> +	}
> +	v4l2_ctrl_handler_setup(&tea->ctrl_handler);
>  
> -	video_set_drvdata(tea575x_radio_inst, tea);
> +	if (tea->ext_init)
> +		tea->ext_init(tea);
>  
> -	retval = video_register_device(tea575x_radio_inst,
> -				       VFL_TYPE_RADIO, radio_nr);
> +	retval = video_register_device(tea575x_radio_inst, VFL_TYPE_RADIO, radio_nr);
>  	if (retval) {
>  		printk(KERN_ERR "tea575x-tuner: can't register video device!\n");
> +		v4l2_ctrl_handler_free(&tea->ctrl_handler);
>  		kfree(tea575x_radio_inst);
>  		return retval;
>  	}

This device registration should be moved down to just before the return 0.

>  
> -	snd_tea575x_set_freq(tea);
>  	tea->vd = tea575x_radio_inst;
>  
>  	return 0;
> @@ -415,6 +387,7 @@ int snd_tea575x_init(struct snd_tea575x
>  void snd_tea575x_exit(struct snd_tea575x *tea)
>  {
>  	if (tea->vd) {
> +		v4l2_ctrl_handler_free(&tea->ctrl_handler);
>  		video_unregister_device(tea->vd);

Swap these lines: first unregister, then free the handler.

>  		tea->vd = NULL;
>  	}
> 
> 
> 

Thanks!

	Hans
