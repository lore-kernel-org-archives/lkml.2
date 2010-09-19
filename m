Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab0ISRDw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 13:03:52 -0400
Received: from legolas.restena.lu ([158.64.1.34]:35170 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753358Ab0ISRDv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 13:03:51 -0400
Date: Sun, 19 Sep 2010 19:02:40 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bernie Thompson <bernie@plugable.com>
Subject: Re: [Patch, RFC] Make struct fb_info ref-counted with kref
Message-ID: <20100919190240.65762511@neptune.home>
In-Reply-To: <4C963E99.9080207@gmx.de>
References: <20100919172833.14bf291e@neptune.home>
	<4C963E99.9080207@gmx.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian,

On Sun, 19 September 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> Hi,
> 
> Bruno Prémont schrieb:
> > For USB-attached (or other hot-(un)pluggable) framebuffers the current
> > fbdev infrastructure is not very helpful. Each such driver currently
> > needs to perform the ref-counting on its own in .fbops.fb_open and
> > .fbops.fb_release callbacks.
> 
> I agree. This is a great idea even for non-hot-(un)pluggable framebuffers.

Yes, things like drmfb and drivers of multi-head capable framebuffer
drivers would certainly appreciate as well, but they will probably also
want to care about users (of fb_info.screen_base).

> > This patch moves the ref-counting in fbdev infrastructure.
> > (drivers have not been adjusted, all those releasing fb_info in
> >  .fbops.fb_destroy will not work -- patch for those will follow
> >  later on, all the others will continue to work fine)
> > 
> > API-wise the following changes are done:
> > - num_registered_fb and registered_fb variables are no more exported.
> >   New functions fb_get_registered() and fb_is_registered() replace
> >   them.
> >   The only know user of those was fbcon, thus the large diff on fbcon.c
> > 
> >   Note: the accesses to registered_fb and num_registered_fb look racy
> >   as there was not protection at all around them, potentially letting
> >   register_framebuffer() register two framebuffers on the same minor
> >   concurrently, fbcon access should have been safe by combination of
> >   its use of console_semaphore and reaction to events.
> >   In this patch I combined most of fbcon's accesses to registered_fb
> >   and num_registered_fb into fb_is_registered(), though I'm not sure
> >   if the num-check optimization is worth to keep or its check should
> >   be put into a separate function.
> > 
> > - framebuffer_release() is mapped to fb_put() but will go away
> >   when converting drivers
> > 
> > Reference count for fb_info can be increased with fb_get(fb_info) and
> > later released with fb_put(fb_info).
> > 
> > 
> > If you have concerns regarding the API changes, please let me know.
> 
> Uhm, I'm not really happy with what we count. With the old method you mentioned 
> we ref-counted framebuffer users, after your patch it's more counting users + 
> uses. This might be okay as we usually are interested whether the ref_count is 0 
> or not but it doesn't look right if we modify the refcount during nearly every 
> framebuffer operation. Wouldn't it be sufficient to do the refcounting in 
> fb_open & fb_release operation + in fbcon where open&release are done?

Well I'm more for counting the uses, (especially as the aim is to not
force the driver to look exactly when it can free the fb_info struct).
If the driver needs to know about active users (e.g. for handling memory
reorganization on mode change or the like) that would remain driver's job.

Though this reminds me to double-check the driver module ref-counting versus
fb_info refcounting as otherwise there is a race-window between late fb_release
and end of fb_destroy while.

> > diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
> > index 0a08f13..be5f342 100644
> > --- a/drivers/video/fbsysfs.c
> > +++ b/drivers/video/fbsysfs.c
> > @@ -58,6 +58,7 @@ struct fb_info *framebuffer_alloc(size_t size, struct device *dev)
> >  		info->par = p + fb_info_size;
> >  
> >  	info->device = dev;
> > +	kref_init(&info->refcount);
> 
> As far as I know there exist framebuffer drivers which do not call 
> framebuffer_alloc but contain their own fb_info. I guess these would be broken 
> as well.

For those it would be better to switch them to be using framebuffer_alloc.
I'm even wondering why the mutexes of fb_info are setup in register_framebuffer
instead of in framebuffer_alloc (probably exactly because some drivers don't
use framebuffer_alloc()) -- isn't there a comment somewhere in the code about
moving drivers to use framebuffer_alloc()?

Thanks,
Bruno

> Thanks,
> 
> Florian Tobias Schandinat
