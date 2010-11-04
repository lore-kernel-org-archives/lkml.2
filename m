Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0KDOvA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 10:51:00 -0400
Received: from netrider.rowland.org ([192.131.102.5]:52187 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752121Ab0KDOu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 10:50:58 -0400
Date: Thu, 4 Nov 2010 10:50:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [GIT PULL] One more power management fix for 2.6.37
In-Reply-To: <201011041424.44215.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.1011041045350.2522-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Nov 2010, Rafael J. Wysocki wrote:

> OK, so I think we can relax the locking in dpm_[suspend/resume]_noirq() to
> avoid executing callbacks under dpm_list_mtx, like in the (untested) patch
> below.
> 
> Alan, do you see any immediate problem with that?
> 
> Rafael
> 
> ---
>  drivers/base/power/main.c |   17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> Index: linux-2.6/drivers/base/power/main.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/main.c
> +++ linux-2.6/drivers/base/power/main.c
> @@ -480,15 +480,23 @@ void dpm_resume_noirq(pm_message_t state
>  
>  	mutex_lock(&dpm_list_mtx);
>  	transition_started = false;
> -	list_for_each_entry(dev, &dpm_list, power.entry)
> +	list_for_each_entry(dev, &dpm_list, power.entry) {
> +		get_device(dev);
>  		if (dev->power.status > DPM_OFF) {
>  			int error;
>  
>  			dev->power.status = DPM_OFF;
> +
> +			mutex_unlock(&dpm_list_mtx);
> +
>  			error = device_resume_noirq(dev, state);
> +
> +			mutex_lock(&dpm_list_mtx);
>  			if (error)
>  				pm_dev_err(dev, state, " early", error);
>  		}
> +		put_device(dev);
> +	}
>  	mutex_unlock(&dpm_list_mtx);
>  	dpm_show_time(starttime, state, "early");
>  	resume_device_irqs();
> @@ -796,12 +804,19 @@ int dpm_suspend_noirq(pm_message_t state
>  	suspend_device_irqs();
>  	mutex_lock(&dpm_list_mtx);
>  	list_for_each_entry_reverse(dev, &dpm_list, power.entry) {
> +		get_device(dev);
> +		mutex_unlock(&dpm_list_mtx);
> +
>  		error = device_suspend_noirq(dev, state);
> +
> +		mutex_lock(&dpm_list_mtx);
>  		if (error) {
>  			pm_dev_err(dev, state, " late", error);
> +			put_device(dev);
>  			break;
>  		}
>  		dev->power.status = DPM_OFF_IRQ;
> +		put_device(dev);
>  	}
>  	mutex_unlock(&dpm_list_mtx);
>  	if (error)

This won't work if the callback tries to unregister the device, but of
course the old code wouldn't work in that case either.  We should
document this requirement.  It means that your get_device and
put_device calls aren't needed.

Aside from that I don't see any problems.  In principle there shouldn't 
be any other processes running at this time that would want to access 
either the device or the dpm_list.  Maybe this means the socket locking 
isn't needed in the pcmcia late-suspend and early-resume routines, 
which would be a simpler solution.

Alan Stern

