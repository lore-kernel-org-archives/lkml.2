Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1ERG0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 02:26:45 -0400
Received: from smtp-vbr18.xs4all.nl ([194.109.24.38]:1321 "EHLO
	smtp-vbr18.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085Ab1ERG0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 02:26:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [PATCH RFC v2] radio-sf16fmr2: convert to generic TEA575x interface
Date: Wed, 18 May 2011 08:26:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38-tschai; KDE/4.6.1; x86_64; ; )
Cc: linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>
References: <201105140017.26968.linux@rainbow-software.org> <201105172133.14835.hverkuil@xs4all.nl> <201105172205.28899.linux@rainbow-software.org>
In-Reply-To: <201105172205.28899.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105180826.19361.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 17, 2011 22:05:26 Ondrej Zary wrote:
> On Tuesday 17 May 2011 21:33:14 Hans Verkuil wrote:
> > Hi Ondrej!
> >
> > On Sunday, May 15, 2011 23:26:33 Hans Verkuil wrote:
> > > On Sunday, May 15, 2011 22:18:21 Ondrej Zary wrote:
> > > > Thanks, it's much simpler with the new control framework.
> > > > Do the negative volume control values make sense? The TC9154A chip can
> > > > attenuate the volume from 0 to -68dB in 2dB steps.
> > >
> > > It does make sense, but I think I would offset the values so they start
> > > at 0. Mostly because there might be some old apps that set the volume to
> > > 0 when they want to mute, which in this case is full volume.
> > >
> > > I am not aware of any driver where a volume of 0 isn't the same as the
> > > lowest volume possible, so in this particular case I would apply an
> > > offset.
> > >
> > > I will have to do a closer review tomorrow or the day after. I think
> > > there are a few subtleties that I need to look at. Ping me if you haven't
> > > heard from me by Wednesday. I would really like to get these drivers up
> > > to spec now that I have someone who can test them, and once that's done I
> > > hope that I never have to look at them again :-) (Unlikely, but one can
> > > dream...)
> >
> > OK, I looked at it a bit more and it needs to be changed a little bit. The
> > problem is that the VOLUME control is added after snd_tea575x_init, i.e.
> > after the video_register_device call. The video_register_device call should
> > be the last thing done before the init sequence returns. There may be
> > applications (dbus/hal) that open devices as soon as they appear, so doing
> > more initialization after the video node is registered is not a good idea
> > (many older V4L drivers make this mistake).
> >
> > Perhaps creating a snd_tea575x_register function doing just the
> > registration may be a good idea. Or a callback before doing the
> > video_register_device.
> 
> OK, I'll reorder the lines in snd_tea575x_init function and add a callback 
> that radio-sf16fmr2 can use.
> 
> Also upgraded my card with TC9154AP chip so I can actually test the volume 
> control code (and it was broken in my previous patch...). The left and right 
> channels can be separately controlled - is there a way to provide separate 
> left and right volume controls? Or do I need to fake up a balance control?

A fake balance control would be the way to go. There are other drivers that
do it like that.

> > Another thing: the tea->mute field shouldn't be needed anymore. And the
> > 'mute on init' bit in snd_tea575x_init can be removed as well since that
> > is automatically performed by v4l2_ctrl_handler_setup.
> 
> Thought about this too but the snd_tea575x_write() and snd_tea575x_read() 
> functions need to know the mute status. And these functions are also used to 
> detect the tuner presence before initializing the controls. I don't see any 
> elegant solution.

What typically is done is that the mute v4l2_ctrl pointer is stored and
dereferenced to get the value. But in a simple case like this backing up
the value works just as well.

Regards,

	Hans

> > In addition, the .ioctl field in tea575x_fops can be replaced by
> > .unlocked_ioctl. The whole exclusive open stuff and the in_use field can be
> > removed. The only thing needed is a struct mutex in struct snd_tea575x,
> > initialize it and set tea575x_radio_inst->lock to the mutex. This will
> > serialize all access safely.
> 
> I'll do this as a separate patch later.
> 
> > To do this really right you should add struct v4l2_device to struct
> > snd_tea575x (the radio-sf16fmr2 driver has one, so you can use that as an
> > example). With that in place you can also add support for 'priority'
> > handling. I'd say see what you can do, and if it takes too much time then
> > mail me the tea575x code and the radio-sf16frm2 code and I'll finish it.
> >
> > Regards,
> >
> > 	Hans
> 
> 
> 
> 
