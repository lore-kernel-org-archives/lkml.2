Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1A1UXn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 15:23:43 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:52180 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753530Ab1A1UXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 15:23:42 -0500
Date: Fri, 28 Jan 2011 15:23:41 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@novell.com>
cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] PM / Wakeup: Add missing memory barriers
In-Reply-To: <201101272219.54303.rjw@novell.com>
Message-ID: <Pine.LNX.4.44L0.1101281521190.2089-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Jan 2011, Rafael J. Wysocki wrote:

> Updated patch is appended.
> 
> Thanks,
> Rafael
> 
> ---
>  drivers/base/power/wakeup.c |   61 ++++++++++++++++++++++++++++----------------
>  1 file changed, 39 insertions(+), 22 deletions(-)
> 
> Index: linux-2.6/drivers/base/power/wakeup.c
> ===================================================================
> --- linux-2.6.orig/drivers/base/power/wakeup.c
> +++ linux-2.6/drivers/base/power/wakeup.c
> @@ -24,12 +24,26 @@
>   */
>  bool events_check_enabled;
>  
> -/* The counter of registered wakeup events. */
> -static atomic_t event_count = ATOMIC_INIT(0);
> -/* A preserved old value of event_count. */
> +/*
> + * Combined counters of registered wakeup events and wakeup events in progress.
> + * They need to be modified together atomically, so it's better to use one
> + * atomic variable to hold them both.
> + */
> +static atomic_t combined_event_count = ATOMIC_INIT(0);
> +
> +#define IN_PROGRESS_BITS	(sizeof(int) * 4)
> +#define MAX_IN_PROGRESS		((1 << IN_PROGRESS_BITS) - 1)
> +
> +static void split_counters(unsigned int *cnt, unsigned int *inpr)
> +{
> +	unsigned int comb = atomic_read(&combined_event_count);
> +
> +	*cnt = (comb >> IN_PROGRESS_BITS);
> +	*inpr = comb & MAX_IN_PROGRESS;
> +}
> +
> +/* A preserved old value of the events counter. */
>  static unsigned int saved_count;
> -/* The counter of wakeup events being processed. */
> -static atomic_t events_in_progress = ATOMIC_INIT(0);
>  
>  static DEFINE_SPINLOCK(events_lock);
>  
> @@ -333,7 +347,8 @@ static void wakeup_source_activate(struc
>  	ws->timer_expires = jiffies;
>  	ws->last_time = ktime_get();
>  
> -	atomic_inc(&events_in_progress);
> +	/* Increment the counter of events in progress. */
> +	atomic_inc(&combined_event_count);
>  }
>  
>  /**
> @@ -420,14 +435,10 @@ static void wakeup_source_deactivate(str
>  	del_timer(&ws->timer);
>  
>  	/*
> -	 * event_count has to be incremented before events_in_progress is
> -	 * modified, so that the callers of pm_check_wakeup_events() and
> -	 * pm_save_wakeup_count() don't see the old value of event_count and
> -	 * events_in_progress equal to zero at the same time.
> +	 * Increment the counter of registered wakeup events and decrement the
> +	 * couter of wakeup events in progress simultaneously.
>  	 */
> -	atomic_inc(&event_count);
> -	smp_mb__before_atomic_dec();
> -	atomic_dec(&events_in_progress);
> +	atomic_add(MAX_IN_PROGRESS, &combined_event_count);
>  }
>  
>  /**
> @@ -582,8 +593,10 @@ bool pm_wakeup_pending(void)
>  
>  	spin_lock_irqsave(&events_lock, flags);
>  	if (events_check_enabled) {
> -		ret = ((unsigned int)atomic_read(&event_count) != saved_count)
> -			|| atomic_read(&events_in_progress);
> +		unsigned int cnt, inpr;
> +
> +		split_counters(&cnt, &inpr);
> +		ret = (cnt != saved_count || inpr > 0);
>  		events_check_enabled = !ret;
>  	}
>  	spin_unlock_irqrestore(&events_lock, flags);
> @@ -605,19 +618,22 @@ bool pm_wakeup_pending(void)
>   */
>  bool pm_get_wakeup_count(unsigned int *count)
>  {
> -	bool ret;
> +	unsigned int cnt, inpr;
>  
>  	if (capable(CAP_SYS_ADMIN))
>  		events_check_enabled = false;
>  
> -	while (atomic_read(&events_in_progress) && !signal_pending(current)) {
> +	for (;;) {
> +		split_counters(&cnt, &inpr);
> +		if (inpr == 0 || signal_pending(current))
> +			break;
>  		pm_wakeup_update_hit_counts();
>  		schedule_timeout_interruptible(msecs_to_jiffies(TIMEOUT));
>  	}
>  
> -	ret = !atomic_read(&events_in_progress);
> -	*count = atomic_read(&event_count);
> -	return ret;
> +	split_counters(&cnt, &inpr);
> +	*count = cnt;
> +	return !inpr;
>  }
>  
>  /**
> @@ -631,11 +647,12 @@ bool pm_get_wakeup_count(unsigned int *c
>   */
>  bool pm_save_wakeup_count(unsigned int count)
>  {
> +	unsigned int cnt, inpr;
>  	bool ret = false;
>  
>  	spin_lock_irq(&events_lock);
> -	if (count == (unsigned int)atomic_read(&event_count)
> -	    && !atomic_read(&events_in_progress)) {
> +	split_counters(&cnt, &inpr);
> +	if (cnt == count && inpr == 0) {
>  		saved_count = count;
>  		events_check_enabled = true;
>  		ret = true;

This looks okay.  Sure, it's a little clunky, but it's better than the 
alternatives.

Alan Stern

