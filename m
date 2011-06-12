Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab1FLRtS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 13:49:18 -0400
Received: from smtp-vbr11.xs4all.nl ([194.109.24.31]:4448 "EHLO
	smtp-vbr11.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab1FLRtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 13:49:16 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Takashi Iwai <tiwai@suse.de>
Subject: Re: [alsa-devel] [PATCH] tea575x: allow multiple opens
Date: Sun, 12 Jun 2011 19:48:47 +0200
User-Agent: KMail/1.13.5 (Linux/3.0.0-rc1-tschai; KDE/4.6.2; x86_64; ; )
Cc: Ondrej Zary <linux@rainbow-software.org>, alsa-devel@alsa-project.org,
        Kernel development list <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>
References: <201106111529.04319.linux@rainbow-software.org> <201106111536.39174.hverkuil@xs4all.nl> <s5h62obf0uv.wl%tiwai@suse.de>
In-Reply-To: <s5h62obf0uv.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106121948.47598.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 12, 2011 18:52:56 Takashi Iwai wrote:
> At Sat, 11 Jun 2011 15:36:39 +0200,
> Hans Verkuil wrote:
> > 
> > On Saturday, June 11, 2011 15:28:59 Ondrej Zary wrote:
> > > Change locking to allow tea575x-radio device to be opened multiple times.
> > 
> > Very nice!
> > 
> > Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
> 
> Hans, would you apply this and another one via v4l tree or shall I
> apply them via sound tree?

This is all V4L related, so I think Mauro can apply this patch and the
other patch for v3.1. No need to go through an intermediate tree of mine.

Regards,

	Hans

> 
> 
> Takashi
> 
> > 
> > Regards,
> > 
> > 	Hans
> > 
> > > Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> > > 
> > > --- linux-2.6.39-rc2-/include/sound/tea575x-tuner.h	2011-06-11 15:21:50.000000000 +0200
> > > +++ linux-2.6.39-rc2/include/sound/tea575x-tuner.h	2011-06-11 14:50:55.000000000 +0200
> > > @@ -49,7 +49,7 @@ struct snd_tea575x {
> > >  	bool tuned;			/* tuned to a station */
> > >  	unsigned int val;		/* hw value */
> > >  	unsigned long freq;		/* frequency */
> > > -	unsigned long in_use;		/* set if the device is in use */
> > > +	struct mutex mutex;
> > >  	struct snd_tea575x_ops *ops;
> > >  	void *private_data;
> > >  	u8 card[32];
> > > --- linux-2.6.39-rc2-/sound/i2c/other/tea575x-tuner.c	2011-06-11 15:21:50.000000000 +0200
> > > +++ linux-2.6.39-rc2/sound/i2c/other/tea575x-tuner.c	2011-06-11 14:57:28.000000000 +0200
> > > @@ -282,26 +282,9 @@ static int vidioc_s_input(struct file *f
> > >  	return 0;
> > >  }
> > >  
> > > -static int snd_tea575x_exclusive_open(struct file *file)
> > > -{
> > > -	struct snd_tea575x *tea = video_drvdata(file);
> > > -
> > > -	return test_and_set_bit(0, &tea->in_use) ? -EBUSY : 0;
> > > -}
> > > -
> > > -static int snd_tea575x_exclusive_release(struct file *file)
> > > -{
> > > -	struct snd_tea575x *tea = video_drvdata(file);
> > > -
> > > -	clear_bit(0, &tea->in_use);
> > > -	return 0;
> > > -}
> > > -
> > >  static const struct v4l2_file_operations tea575x_fops = {
> > >  	.owner		= THIS_MODULE,
> > > -	.open           = snd_tea575x_exclusive_open,
> > > -	.release        = snd_tea575x_exclusive_release,
> > > -	.ioctl		= video_ioctl2,
> > > +	.unlocked_ioctl	= video_ioctl2,
> > >  };
> > >  
> > >  static const struct v4l2_ioctl_ops tea575x_ioctl_ops = {
> > > @@ -340,13 +323,14 @@ int snd_tea575x_init(struct snd_tea575x
> > >  	if (snd_tea575x_read(tea) != 0x55AA)
> > >  		return -ENODEV;
> > >  
> > > -	tea->in_use = 0;
> > >  	tea->val = TEA575X_BIT_BAND_FM | TEA575X_BIT_SEARCH_10_40;
> > >  	tea->freq = 90500 * 16;		/* 90.5Mhz default */
> > >  	snd_tea575x_set_freq(tea);
> > >  
> > >  	tea->vd = tea575x_radio;
> > >  	video_set_drvdata(&tea->vd, tea);
> > > +	mutex_init(&tea->mutex);
> > > +	tea->vd.lock = &tea->mutex;
> > >  
> > >  	v4l2_ctrl_handler_init(&tea->ctrl_handler, 1);
> > >  	tea->vd.ctrl_handler = &tea->ctrl_handler;
> > > 
> > > 
> > > 
> > _______________________________________________
> > Alsa-devel mailing list
> > Alsa-devel@alsa-project.org
> > http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
> > 
> 
