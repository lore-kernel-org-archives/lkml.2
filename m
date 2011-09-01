Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab1IAQ2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 12:28:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:65453 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757206Ab1IAQ2Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 12:28:16 -0400
Date: Thu, 1 Sep 2011 18:28:13 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
cc: =?UTF-8?B?QnJ1bm8gUHLDqW1vbnQ=?= <bonbons@linux-vserver.org>,
        lethal@linux-sh.org, linux-fbdev@vger.kernel.org,
        francis.moro@gmail.com, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>, stable@kernel.org
Subject: Re: [PATCH] fb: avoid possible deadlock caused by fb_set_suspend
In-Reply-To: <4E5FA7F9.9030802@gmx.de>
Message-ID: <Pine.LNX.4.64.1109011827090.6316@axis700.grange>
References: <4DF7B0B4.4060002@gmx.de> <1308337359-3480-1-git-send-email-FlorianSchandinat@gmx.de>
 <20110618104311.6d80ba50@neptune.home> <20110618111934.26203dbf@neptune.home>
 <4E5FA7F9.9030802@gmx.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:Xec5s0lWwFWmpkU1KzUZ/+TAnbS8kKUqr3RqecLcjFJ
 CzBKmj4hQXg+9OozYfycSNZ5cwV5iyRt3XqoflVcpyK1+nnSIW
 QR/79E26zoDMbpUo5jkGOqCfKlJN9MpIwh+tjK2sn5+sMXXaxB
 FWFdY9RukCSxYJl5/w0mC5nwQE/ekyEed5HWIsvXQF4keWhkP0
 lB9rREGGgh3gxblg7Ju6M2xx+MkNr1PzaTB7ecdYsP0Fb0+T1e
 CcVXxeXbCk71qCGWvgbrnQI4FRRTVV6XDM+pJBQpUz+Q4Mr4wB
 /2WfqvQzsMjvAd5dDiP0lF3rSZ6QIeO6vmUCK5+bpBKqokQ/Hv
 wbnO16UqwBAcq5qSAWdNKwtEPCbhv6p6LxVdLi7ZHLI+ZIpryt
 M/EY2HlaepYXA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Florian

On Thu, 1 Sep 2011, Florian Tobias Schandinat wrote:

> ping
> 
> Guennadi, I really want this issue fixed. Please have a look at Bruno's patch
> otherwise your driver might remain or get even more broken...

Sorry, somehow this patch excaped my attention. Will test tomorrow.

Thanks
Guennadi

> 
> I am scheduling Herton's patch for the next merge window.
> 
> 
> Regards,
> 
> Florian Tobias Schandinat
> 
> 
> On 06/18/2011 09:19 AM, Bruno Prémont wrote:
> > Guennadi, could you have a look at (completely untested) patch which avoids
> > possible deadlock due to inverted lock taking order on hotplug as well
> > as "readding" lock_fb_info() for fb_set_suspend() call after Herton's
> > patch to fb_set_suspend().
> > 
> > Thanks,
> > Bruno
> > 
> > 
> > On Sat, 18 June 2011 Bruno Prémont <bonbons@linux-vserver.org> wrote:
> >> On Fri, 17 June 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> >>> From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> >>>
> >>> A lock ordering issue can cause deadlocks: in framebuffer/console code,
> >>> all needed struct fb_info locks are taken before acquire_console_sem(),
> >>> in places which need to take console semaphore.
> >>>
> >>> But fb_set_suspend is always called with console semaphore held, and
> >>> inside it we call lock_fb_info which gets the fb_info lock, inverse
> >>> locking order of what the rest of the code does. This causes a real
> >>> deadlock issue, when we write to state fb sysfs attribute (which calls
> >>> fb_set_suspend) while a framebuffer is being unregistered by
> >>> remove_conflicting_framebuffers, as can be shown by following show
> >>> blocked state trace on a test program which loads i915 and runs another
> >>> forked processes writing to state attribute:
> >>>
> >>> Test process with semaphore held and trying to get fb_info lock:
> >>
> >> ...
> >>
> >>> fb-test2 which reproduces above is available on kernel.org bug #26232.
> >>> To solve this issue, avoid calling lock_fb_info inside fb_set_suspend,
> >>> and move it out to where needed (callers of fb_set_suspend must call
> >>> lock_fb_info before if needed). So far, the only place which needs to
> >>> call lock_fb_info is store_fbstate, all other places which calls
> >>> fb_set_suspend are suspend/resume hooks that should not need the lock as
> >>> they should be run only when processes are already frozen in
> >>> suspend/resume.
> >>
> >> From a quick look through FB drivers in 2.6.39 I've found one that would need
> >> more work:
> >> - drivers/video/sh_mobile_hdmi.c: sh_hdmi_edid_work_fn()
> >>   Should get changed to
> >>   a) right locking order in case (hdmi->hp_state == HDMI_HOTPLUG_CONNECTED)
> >>   b) lock fb_info in the other case
> >>   For this one fb_set_suspend() does get call in a hotplug worker,
> >>   thus independently on suspend/resume process.
> >>
> >> The rest does match the suspend/resume hook pattern mentioned.
> >>
> >> Bruno
> >>
> >>
> >>> References: https://bugzilla.kernel.org/show_bug.cgi?id=26232
> >>> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> >>> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> >>> Cc: stable@kernel.org
> >>> ---
> >>>  drivers/video/fbmem.c   |    3 ---
> >>>  drivers/video/fbsysfs.c |    3 +++
> >>>  2 files changed, 3 insertions(+), 3 deletions(-)
> >>>
> >>> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> >>> index 5aac00e..ad93629 100644
> >>> --- a/drivers/video/fbmem.c
> >>> +++ b/drivers/video/fbmem.c
> >>> @@ -1738,8 +1738,6 @@ void fb_set_suspend(struct fb_info *info, int state)
> >>>  {
> >>>  	struct fb_event event;
> >>>  
> >>> -	if (!lock_fb_info(info))
> >>> -		return;
> >>>  	event.info = info;
> >>>  	if (state) {
> >>>  		fb_notifier_call_chain(FB_EVENT_SUSPEND, &event);
> >>> @@ -1748,7 +1746,6 @@ void fb_set_suspend(struct fb_info *info, int state)
> >>>  		info->state = FBINFO_STATE_RUNNING;
> >>>  		fb_notifier_call_chain(FB_EVENT_RESUME, &event);
> >>>  	}
> >>> -	unlock_fb_info(info);
> >>>  }
> >>>  
> >>>  /**
> >>> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
> >>> index 04251ce..67afa9c 100644
> >>> --- a/drivers/video/fbsysfs.c
> >>> +++ b/drivers/video/fbsysfs.c
> >>> @@ -399,9 +399,12 @@ static ssize_t store_fbstate(struct device *device,
> >>>  
> >>>  	state = simple_strtoul(buf, &last, 0);
> >>>  
> >>> +	if (!lock_fb_info(fb_info))
> >>> +		return -ENODEV;
> >>>  	console_lock();
> >>>  	fb_set_suspend(fb_info, (int)state);
> >>>  	console_unlock();
> >>> +	unlock_fb_info(fb_info);
> >>>  
> >>>  	return count;
> >>>  }
> > 
> > 
> > diff --git a/drivers/video/sh_mobile_hdmi.c b/drivers/video/sh_mobile_hdmi.c
> > index 2b9e56a..b1a13ab 100644
> > --- a/drivers/video/sh_mobile_hdmi.c
> > +++ b/drivers/video/sh_mobile_hdmi.c
> > @@ -1151,27 +1151,27 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
> >  
> >  		ch = info->par;
> >  
> > -		console_lock();
> > +		if (lock_fb_info(info)) {
> > +			console_lock();
> >  
> > -		/* HDMI plug in */
> > -		if (!sh_hdmi_must_reconfigure(hdmi) &&
> > -		    info->state == FBINFO_STATE_RUNNING) {
> > -			/*
> > -			 * First activation with the default monitor - just turn
> > -			 * on, if we run a resume here, the logo disappears
> > -			 */
> > -			if (lock_fb_info(info)) {
> > +			/* HDMI plug in */
> > +			if (!sh_hdmi_must_reconfigure(hdmi) &&
> > +			    info->state == FBINFO_STATE_RUNNING) {
> > +				/*
> > +				 * First activation with the default monitor - just turn
> > +				 * on, if we run a resume here, the logo disappears
> > +				 */
> >  				info->var.width = hdmi->var.width;
> >  				info->var.height = hdmi->var.height;
> >  				sh_hdmi_display_on(hdmi, info);
> > -				unlock_fb_info(info);
> > +			} else {
> > +				/* New monitor or have to wake up */
> > +				fb_set_suspend(info, 0);
> >  			}
> > -		} else {
> > -			/* New monitor or have to wake up */
> > -			fb_set_suspend(info, 0);
> > -		}
> >  
> > -		console_unlock();
> > +			console_unlock();
> > +			unlock_fb_info(info);
> > +		}
> >  	} else {
> >  		ret = 0;
> >  		if (!hdmi->info)
> > @@ -1181,12 +1181,15 @@ static void sh_hdmi_edid_work_fn(struct work_struct *work)
> >  		fb_destroy_modedb(hdmi->monspec.modedb);
> >  		hdmi->monspec.modedb = NULL;
> >  
> > -		console_lock();
> > +		if (lock_fb_info(info)) {
> > +			console_lock();
> >  
> > -		/* HDMI disconnect */
> > -		fb_set_suspend(hdmi->info, 1);
> > +			/* HDMI disconnect */
> > +			fb_set_suspend(hdmi->info, 1);
> >  
> > -		console_unlock();
> > +			console_unlock();
> > +			unlock_fb_info(info);
> > +		}
> >  		pm_runtime_put(hdmi->dev);
> >  	}
> >  
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fbdev" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
