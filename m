Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab1FRIni (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 04:43:38 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:49113 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1FRIng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 04:43:36 -0400
Date: Sat, 18 Jun 2011 10:43:11 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: lethal@linux-sh.org, linux-fbdev@vger.kernel.org, francis.moro@gmail.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        Herton Ronaldo Krzesinski <herton@mandriva.com.br>, stable@kernel.org
Subject: Re: [PATCH] fb: avoid possible deadlock caused by fb_set_suspend
Message-ID: <20110618104311.6d80ba50@neptune.home>
In-Reply-To: <1308337359-3480-1-git-send-email-FlorianSchandinat@gmx.de>
References: <4DF7B0B4.4060002@gmx.de>
	<1308337359-3480-1-git-send-email-FlorianSchandinat@gmx.de>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 June 2011 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
> From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> 
> A lock ordering issue can cause deadlocks: in framebuffer/console code,
> all needed struct fb_info locks are taken before acquire_console_sem(),
> in places which need to take console semaphore.
> 
> But fb_set_suspend is always called with console semaphore held, and
> inside it we call lock_fb_info which gets the fb_info lock, inverse
> locking order of what the rest of the code does. This causes a real
> deadlock issue, when we write to state fb sysfs attribute (which calls
> fb_set_suspend) while a framebuffer is being unregistered by
> remove_conflicting_framebuffers, as can be shown by following show
> blocked state trace on a test program which loads i915 and runs another
> forked processes writing to state attribute:
> 
> Test process with semaphore held and trying to get fb_info lock:

...

> fb-test2 which reproduces above is available on kernel.org bug #26232.
> To solve this issue, avoid calling lock_fb_info inside fb_set_suspend,
> and move it out to where needed (callers of fb_set_suspend must call
> lock_fb_info before if needed). So far, the only place which needs to
> call lock_fb_info is store_fbstate, all other places which calls
> fb_set_suspend are suspend/resume hooks that should not need the lock as
> they should be run only when processes are already frozen in
> suspend/resume.

>From a quick look through FB drivers in 2.6.39 I've found one that would need
more work:
- drivers/video/sh_mobile_hdmi.c: sh_hdmi_edid_work_fn()
  Should get changed to
  a) right locking order in case (hdmi->hp_state == HDMI_HOTPLUG_CONNECTED)
  b) lock fb_info in the other case
  For this one fb_set_suspend() does get call in a hotplug worker,
  thus independently on suspend/resume process.

The rest does match the suspend/resume hook pattern mentioned.

Bruno


> References: https://bugzilla.kernel.org/show_bug.cgi?id=26232
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
> Signed-off-by: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: stable@kernel.org
> ---
>  drivers/video/fbmem.c   |    3 ---
>  drivers/video/fbsysfs.c |    3 +++
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
> index 5aac00e..ad93629 100644
> --- a/drivers/video/fbmem.c
> +++ b/drivers/video/fbmem.c
> @@ -1738,8 +1738,6 @@ void fb_set_suspend(struct fb_info *info, int state)
>  {
>  	struct fb_event event;
>  
> -	if (!lock_fb_info(info))
> -		return;
>  	event.info = info;
>  	if (state) {
>  		fb_notifier_call_chain(FB_EVENT_SUSPEND, &event);
> @@ -1748,7 +1746,6 @@ void fb_set_suspend(struct fb_info *info, int state)
>  		info->state = FBINFO_STATE_RUNNING;
>  		fb_notifier_call_chain(FB_EVENT_RESUME, &event);
>  	}
> -	unlock_fb_info(info);
>  }
>  
>  /**
> diff --git a/drivers/video/fbsysfs.c b/drivers/video/fbsysfs.c
> index 04251ce..67afa9c 100644
> --- a/drivers/video/fbsysfs.c
> +++ b/drivers/video/fbsysfs.c
> @@ -399,9 +399,12 @@ static ssize_t store_fbstate(struct device *device,
>  
>  	state = simple_strtoul(buf, &last, 0);
>  
> +	if (!lock_fb_info(fb_info))
> +		return -ENODEV;
>  	console_lock();
>  	fb_set_suspend(fb_info, (int)state);
>  	console_unlock();
> +	unlock_fb_info(fb_info);
>  
>  	return count;
>  }
