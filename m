Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1EYQTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 12:19:37 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:54782 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666Ab1EYQTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 12:19:35 -0400
Date: Wed, 25 May 2011 18:19:17 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Fabio Erculiani <lxnay@sabayon.org>
Cc: linux-fbdev@vger.kernel.org, lethal@linux-sh.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fbmem: fix race condition between
 register_framebuffer() and fb_open()
Message-ID: <20110525181917.12cf97b8@neptune.home>
In-Reply-To: <20110524224545.08c53b1d@neptune.home>
References: <1306266871-12464-1-git-send-email-lxnay@sabayon.org>
	<20110524224545.08c53b1d@neptune.home>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 May 2011 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> On Tue, 24 May 2011 Fabio Erculiani <lxnay@sabayon.org> wrote:
> > register_framebuffer() acquires registration_lock, then calls
> > do_register_framebuffer() which calls fb_notifier_call_chain()
> > which calls fb_open() which calls get_fb_info() which tries
> > (at last) to acquire registration_lock again.
> > This is a workaround.
> 
> What calls fb_open() instead of just calling fb_info->fbops->fb_open
> when it is set?
> In other words what kernel handler of fb_notifier chain does file-based
> open of the framebuffer or is the event pushed out synchronously to
> userspace?

Note that fb_info->lock is also taken on both sides:
- per definition around all fb_notifier_call_chain() calls
- as well in fb_open() to protect fb_info->fb_ops->fb_open call.

Bruno


> > Signed-off-by: Fabio Erculiani <lxnay@sabayon.org>
> > ---
> >  drivers/video/fbmem.c |   13 ++++++++++++-
> >  1 files changed, 12 insertions(+), 1 deletions(-)
> > 
> > diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> > index 5aac00e..b9831a0 100644
> > --- a/drivers/video/fbmem.c
> > +++ b/drivers/video/fbmem.c
> > @@ -1628,6 +1628,11 @@ static int do_register_framebuffer(struct fb_info *fb_info)
> >  	event.info = fb_info;
> >  	if (!lock_fb_info(fb_info))
> >  		return -ENODEV;
> > +
> > +	/* FIXME: unlock registration mutex before registration
> > +	 * notification is sent, in order to avoid deadlock.
> > +	 */
> > +	mutex_unlock(&registration_lock);
> >  	fb_notifier_call_chain(FB_EVENT_FB_REGISTERED, &event);
> >  	unlock_fb_info(fb_info);
> >  	return 0;
> > @@ -1692,7 +1697,13 @@ register_framebuffer(struct fb_info *fb_info)
> >  
> >  	mutex_lock(&registration_lock);
> >  	ret = do_register_framebuffer(fb_info);
> > -	mutex_unlock(&registration_lock);
> > +	if (ret != 0)
> > +		/*
> > +		 * FIXME: mutex is unlocked only if ret == 0.
> > +		 * This is the second part of the workaround
> > +		 * that prevents deadlocking.
> > +		 */
> > +		mutex_unlock(&registration_lock);
> >  
> >  	return ret;
> >  }
