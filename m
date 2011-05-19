Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934787Ab1ESU5G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 16:57:06 -0400
Received: from smtp-vbr5.xs4all.nl ([194.109.24.25]:1975 "EHLO
	smtp-vbr5.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933993Ab1ESU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 16:57:04 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH v5] radio-sf16fmr2: convert to generic TEA575x interface
Date: Thu, 19 May 2011 22:56:44 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-tschai; KDE/4.6.1; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
References: <201105140017.26968.linux@rainbow-software.org> <201105190845.38194.hverkuil@xs4all.nl> <201105191815.46658.linux@rainbow-software.org>
In-Reply-To: <201105191815.46658.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105192256.44127.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, May 19, 2011 18:15:43 Ondrej Zary wrote:
> Convert radio-sf16fmr2 to use generic TEA575x implementation. Most of the
> driver code goes away as SF16-FMR2 is basically just a TEA5757 tuner
> connected to ISA bus.
> The card can optionally be equipped with PT2254A volume control (equivalent
> of TC9154AP) - the volume setting is completely reworked (with balance control
> added) and tested.
> 
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>

Acked-by: Hans Verkuil <hverkuil@xs4all.nl>

Except for one tiny little typo:

> --- linux-2.6.39-rc2-/drivers/media/radio/radio-sf16fmr2.c	2011-04-06 03:30:43.000000000 +0200
> +++ linux-2.6.39-rc2/drivers/media/radio/radio-sf16fmr2.c	2011-05-19 17:56:08.000000000 +0200
> +static int fmr2_tea_ext_init(struct snd_tea575x *tea)
>  {
> -	return a->index ? -EINVAL : 0;
> -}
> +	struct fmr2 *fmr2 = tea->private_data;
>  
> -static const struct v4l2_file_operations fmr2_fops = {
> -	.owner          = THIS_MODULE,
> -	.unlocked_ioctl = video_ioctl2,
> -};
> +	if (inb(fmr2->io) & FMR2_HASVOL) {
> +		fmr2->volume = v4l2_ctrl_new_std(&tea->ctrl_handler, &fmr2_ctrl_ops, V4L2_CID_AUDIO_VOLUME, 0, 68, 2, 56);
> +		fmr2->balance = v4l2_ctrl_new_std(&tea->ctrl_handler, &fmr2_ctrl_ops, V4L2_CID_AUDIO_BALANCE, -68, 68, 2, 0);
> +		if (tea->ctrl_handler.error) {
> +			printk(KERN_ERR "radio-sf16fmr2: can't initialize contrls\n");

contrls -> controls

> +			return tea->ctrl_handler.error;
> +		}
> +	}
