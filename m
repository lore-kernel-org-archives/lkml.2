Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757330Ab0ITUPg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 16:15:36 -0400
Received: from legolas.restena.lu ([158.64.1.34]:36407 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab0ITUPe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 16:15:34 -0400
Date: Mon, 20 Sep 2010 22:14:24 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
Message-ID: <20100920221424.04150239@neptune.home>
In-Reply-To: <Pine.LNX.4.64.1009202118110.19429@axis700.grange>
References: <20100919172833.14bf291e@neptune.home>
	<4C963E99.9080207@gmx.de>
	<20100919190240.65762511@neptune.home>
	<4C97B079.8050707@gmx.de>
	<Pine.LNX.4.64.1009202118110.19429@axis700.grange>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 September 2010 Guennadi Liakhovetski wrote:
> On Mon, 20 Sep 2010, Florian Tobias Schandinat wrote:
> > Bruno PrÃ©mont schrieb:
> > > On Sun, 19 September 2010 Florian Tobias Schandinat wrote:
> > > > Bruno PrÃ©mont schrieb:
> > > > > For USB-attached (or other hot-(un)pluggable) framebuffers the current
> > > > > fbdev infrastructure is not very helpful. Each such driver currently
> > > > > needs to perform the ref-counting on its own in .fbops.fb_open and
> > > > > .fbops.fb_release callbacks.
> > > > I agree. This is a great idea even for non-hot-(un)pluggable framebuffers.
> 
> Here's another custom fbdev refcounting example:
> 
> http://thread.gmane.org/gmane.linux.ports.sh.devel/8841

There you definitely count users of the framebuffer (not just references
to fb_info as also manipulated by fb infrastructure)

> > > Yes, things like drmfb and drivers of multi-head capable framebuffer
> > > drivers would certainly appreciate as well, but they will probably also
> > > want to care about users (of fb_info.screen_base).
> > 
> > I don't see any special users of fb_info.screen_base. It's only used for
> > software fallbacks of acceleration functions and fb_read/fb_write (which I'd
> > consider rare to fb_mmap). The bad thing of screen_base is that it can make
> > viafb try to map up to 512MB on 32 bit systems...
> > Much more painful IMHO are the mmaped areas in userspace which essentially
> > prevent moving around of the screen framebuffer inside the video ram.
> > 
> > > > > If you have concerns regarding the API changes, please let me know.
> > > > Uhm, I'm not really happy with what we count. With the old method you
> > > > mentioned we ref-counted framebuffer users, after your patch it's more
> > > > counting users + uses. This might be okay as we usually are interested
> > > > whether the ref_count is 0 or not but it doesn't look right if we modify
> > > > the refcount during nearly every framebuffer operation. Wouldn't it be
> > > > sufficient to do the refcounting in fb_open & fb_release operation + in
> > > > fbcon where open&release are done?
> > > 
> > > Well I'm more for counting the uses, (especially as the aim is to not
> > > force the driver to look exactly when it can free the fb_info struct).
> > > If the driver needs to know about active users (e.g. for handling memory
> > > reorganization on mode change or the like) that would remain driver's job.
> > 
> > I don't see how your counting would influence the time fb_info is freed. It is
> > freed when the last reference is gone but the last remaining reference is
> > always  a user reference either from the framebuffer itself or from any user.
> > But all users have to keep the framebuffer open to do anything with it
> > therfore the last thing they do is releasing the framebuffer. So I do not
> > really understand your reasoning, for me counting the users + uses is more
> > error prone than just the users. But that's not important for me as I'm only
> > interested in whether the count is 0, 1 or more (want to turn off the screen
> > if there are no active [=1] users) which is the same regardless on what you
> > count. So if you really want to stick to your way of counting, that's no
> > problem for me.
> 
> In the above mentioned patch I had to distinguish between fbcon and 
> user-space users. The reason is, that I can force fbcon to reconfigure by 
> sending a FB_EVENT_MODE_CHANGE(_ALL) notification, whereas userspace users 
> cannot be asynchronously notified, so, I have to wait until last of them 
> releases the framebuffer. Do I understand it right, that the proposed API 
> wouldn't provide such a distinction?

The proposed API would not help you as it's caring about struct fb_info
but not the ability to change framebuffer size or location.
You would need a second ref-count for the users, possibly counting fbcon
users separately from userspace users (but this should be a separate
patch).

> Of course, the optimal solution would be to design and implement a
> mechanism to notify framebuffer users about a changed fb configuration,
> but we're not that far yet...

This would include ABI change for userspace, hard to get it trough...
(except maybe if userspace has to opt-in for the notification and kernel
can thus differentiate the "old" and "new" users)
But how would you handle userspace apps that can't consume notifications right
away? Do you timeout or risk long stalls?

Thanks,
Bruno
