Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757289Ab0ITTeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 15:34:12 -0400
Received: from legolas.restena.lu ([158.64.1.34]:55414 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019Ab0ITTeK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 15:34:10 -0400
Date: Mon, 20 Sep 2010 21:32:58 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
Message-ID: <20100920213258.1218b284@neptune.home>
In-Reply-To: <4C97B079.8050707@gmx.de>
References: <20100919172833.14bf291e@neptune.home>
	<4C963E99.9080207@gmx.de>
	<20100919190240.65762511@neptune.home>
	<4C97B079.8050707@gmx.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Mon, 20 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> Bruno Prémont schrieb:
> > On Sun, 19 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> >> Bruno Prémont schrieb:
> >>> For USB-attached (or other hot-(un)pluggable) framebuffers the current
> >>> fbdev infrastructure is not very helpful. Each such driver currently
> >>> needs to perform the ref-counting on its own in .fbops.fb_open and
> >>> .fbops.fb_release callbacks.
> >> I agree. This is a great idea even for non-hot-(un)pluggable framebuffers.
> > 
> > Yes, things like drmfb and drivers of multi-head capable framebuffer
> > drivers would certainly appreciate as well, but they will probably also
> > want to care about users (of fb_info.screen_base).
> 
> I don't see any special users of fb_info.screen_base. It's only used for 
> software fallbacks of acceleration functions and fb_read/fb_write (which I'd 
> consider rare to fb_mmap). The bad thing of screen_base is that it can make 
> viafb try to map up to 512MB on 32 bit systems...
> Much more painful IMHO are the mmaped areas in userspace which essentially 
> prevent moving around of the screen framebuffer inside the video ram.

I think our understanding of "user" is probably not (exactly) the same.

> >>> If you have concerns regarding the API changes, please let me know.
> >> Uhm, I'm not really happy with what we count. With the old method you mentioned 
> >> we ref-counted framebuffer users, after your patch it's more counting users + 
> >> uses. This might be okay as we usually are interested whether the ref_count is 0 
> >> or not but it doesn't look right if we modify the refcount during nearly every 
> >> framebuffer operation. Wouldn't it be sufficient to do the refcounting in 
> >> fb_open & fb_release operation + in fbcon where open&release are done?
> > 
> > Well I'm more for counting the uses, (especially as the aim is to not
> > force the driver to look exactly when it can free the fb_info struct).
> > If the driver needs to know about active users (e.g. for handling memory
> > reorganization on mode change or the like) that would remain driver's job.
> 
> I don't see how your counting would influence the time fb_info is freed. It is 
> freed when the last reference is gone but the last remaining reference is always 
>   a user reference either from the framebuffer itself or from any user. But all 
> users have to keep the framebuffer open to do anything with it therfore the last 
> thing they do is releasing the framebuffer. So I do not really understand your 
> reasoning, for me counting the users + uses is more error prone than just the 
> users. But that's not important for me as I'm only interested in whether the 
> count is 0, 1 or more (want to turn off the screen if there are no active [=1] 
> users) which is the same regardless on what you count. So if you really want to 
> stick to your way of counting, that's no problem for me.

In case of picoLCD driver (which uses a shadow framebuffer in system RAM) the
last user can be a (userspace) process as on unplug driver unregisters that
framebuffer and hands back it's own reference, the fb_destroy callback being
in charge of freeing the shadow framebuffer when fb_info is being freed.

This is quite different from built-in GPU with its video-ram.

Thanks,
Bruno
