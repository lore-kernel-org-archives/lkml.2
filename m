Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2BLB1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 20:27:34 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41240 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752547Ab2BLB1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 20:27:32 -0500
Date: Sat, 11 Feb 2012 17:27:28 -0800
From: mark gross <markgross@thegnar.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, markgross@thegnar.org,
        Matthew Garrett <mjg@redhat.com>, Greg KH <greg@linuxfoundation.org>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 4/8] PM / Sleep: Use wait queue to signal "no wakeup
 events in progress"
Message-ID: <20120212012728.GB18742@gs62>
Reply-To: markgross@thegnar.org
References: <201202070200.55505.rjw@sisk.pl>
 <201202070204.19615.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201202070204.19615.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 02:04:19AM +0100, Rafael J. Wysocki wrote:
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
>  drivers/base/power/wakeup.c |   18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
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
>   * wakeup_source_create - Create a struct wakeup_source object.
>   * @name: Name of the new wakeup source.
> @@ -84,7 +84,7 @@ void wakeup_source_destroy(struct wakeup
>  	while (ws->active) {
>  		spin_unlock_irq(&ws->lock);
>  
> -		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
> +		schedule_timeout_interruptible(msecs_to_jiffies(100));
Nit/ style comment: how is replacing a TIMEOUT macro with a magic number
an improvement.  (maybe timeout is a un-helpful name but 100 isn't any
better. )
>  
>  		spin_lock_irq(&ws->lock);
>  	}
> @@ -411,6 +411,7 @@ EXPORT_SYMBOL_GPL(pm_stay_awake);
>   */
>  static void wakeup_source_deactivate(struct wakeup_source *ws)
>  {
> +	unsigned int cnt, inpr;
>  	ktime_t duration;
>  	ktime_t now;
>  
> @@ -444,6 +445,10 @@ static void wakeup_source_deactivate(str
>  	 * couter of wakeup events in progress simultaneously.
>  	 */
>  	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
> +
> +	split_counters(&cnt, &inpr);
> +	if (!inpr)
> +		wake_up_all(&wakeup_count_wait_queue);
>  }
>  
>  /**
> @@ -624,14 +629,19 @@ bool pm_wakeup_pending(void)
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
> 
