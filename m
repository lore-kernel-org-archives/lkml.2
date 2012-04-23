Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491Ab2DWEBs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 00:01:48 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:46274 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2DWEBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 00:01:47 -0400
Date: Sun, 22 Apr 2012 21:01:43 -0700
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/8] PM / Sleep: Use wait queue to signal "no wakeup
 events in progress"
Message-ID: <20120423040143.GD13772@G62>
Reply-To: markgross@thegnar.org
References: <201202070200.55505.rjw@sisk.pl>
 <201202220031.46219.rjw@sisk.pl>
 <201204222319.02228.rjw@sisk.pl>
 <201204222320.39725.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201204222320.39725.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 11:20:39PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The current wakeup source deactivation code doesn't do anything when
> the counter of wakeup events in progress goes down to zero, which
> requires pm_get_wakeup_count() to poll that counter periodically.
> Although this reduces the average time it takes to deactivate a
> wakeup source, it also may lead to a substantial amount of unnecessary
> polling if there are extended periods of wakeup activity.  Thus it
> seems reasonable to use a wait queue for signaling the "no wakeup
> events in progress" condition and remove the polling.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/base/power/wakeup.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> Index: linux/drivers/base/power/wakeup.c
> ===================================================================
> --- linux.orig/drivers/base/power/wakeup.c
> +++ linux/drivers/base/power/wakeup.c
> @@ -17,8 +17,6 @@
>  
>  #include "power.h"
>  
> -#define TIMEOUT		100
> -
>  /*
>   * If set, the suspend/hibernate code will abort transitions to a sleep state
>   * if wakeup events are registered during or immediately before the transition.
> @@ -52,6 +50,8 @@ static void pm_wakeup_timer_fn(unsigned
>  
>  static LIST_HEAD(wakeup_sources);
>  
> +static DECLARE_WAIT_QUEUE_HEAD(wakeup_count_wait_queue);
> +
>  /**
>   * wakeup_source_prepare - Prepare a new wakeup source for initialization.
>   * @ws: Wakeup source to prepare.
> @@ -442,6 +442,7 @@ EXPORT_SYMBOL_GPL(pm_stay_awake);
>   */
>  static void wakeup_source_deactivate(struct wakeup_source *ws)
>  {
> +	unsigned int cnt, inpr;
>  	ktime_t duration;
>  	ktime_t now;
>  
> @@ -476,6 +477,10 @@ static void wakeup_source_deactivate(str
>  	 * couter of wakeup events in progress simultaneously.
>  	 */
>  	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
> +
> +	split_counters(&cnt, &inpr);
> +	if (!inpr && waitqueue_active(&wakeup_count_wait_queue))
> +		wake_up(&wakeup_count_wait_queue);
>  }
>  
>  /**
> @@ -667,14 +672,19 @@ bool pm_wakeup_pending(void)
>  bool pm_get_wakeup_count(unsigned int *count)
>  {
>  	unsigned int cnt, inpr;
> +	DEFINE_WAIT(wait);
>  
>  	for (;;) {
> +		prepare_to_wait(&wakeup_count_wait_queue, &wait,
> +				TASK_INTERRUPTIBLE);
>  		split_counters(&cnt, &inpr);
>  		if (inpr == 0 || signal_pending(current))
>  			break;
>  		pm_wakeup_update_hit_counts();
> -		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
> +
> +		schedule();
>  	}
> +	finish_wait(&wakeup_count_wait_queue, &wait);
>  
>  	split_counters(&cnt, &inpr);
>  	*count = cnt;

Acked-by: mark gross <markgross@thegnar.org>

