Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1IFQTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:19:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:54876 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab1IFQTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:19:02 -0400
Date: Tue, 6 Sep 2011 18:19:00 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] tick-broadcast: push down tick_broadcast_lock
In-Reply-To: <1314652136-11350-3-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.LFD.2.02.1109061652200.2723@ionos>
References: <1314652136-11350-1-git-send-email-andi@firstfloor.org> <1314652136-11350-3-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Aug 2011, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> For the oneshot case, only take the tick_broadcast_lock when the
> global device is actually changing. For the case when the new
> event is only setting the wakeup to a later time than it already
> is we don't need the lock.
> 
> This avoids lock contention for some special cases on systems
> that don't have an always running per cpu timer. It's not a full
> solution to the scalability problem there unfortunately, just
> the first step.

There is no full solution to that problem other than using sane
hardware.

> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  kernel/time/tick-broadcast.c |   18 ++++++++++++++----
>  1 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 54a5977..7e748fb 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -485,23 +485,33 @@ void tick_broadcast_oneshot_control(unsigned long reason)
>  
>  	bc = tick_broadcast_device.evtdev;
>  
> -	raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>  	if (reason == CLOCK_EVT_NOTIFY_BROADCAST_ENTER) {
>  		if (!__get_cpu_var(state).need_oneshot) {
>  			__get_cpu_var(state).need_oneshot = 1;
>  			clockevents_set_mode(dev, CLOCK_EVT_MODE_SHUTDOWN);
> -			if (dev->next_event.tv64 < bc->next_event.tv64)
> +		       
> +			/* Only take the lock if the events gets set earlier */
> +			if (dev->next_event.tv64 < bc->next_event.tv64) {

That's racy and broken.

CPU0                                 CPU1

tick_handle_oneshot_broadcast()

 raw_spin_lock(&tick_broadcast_lock);
 bc->next_event = KTIME_MAX;
 for_each_online_cpu() {
	next_event = ...;
 }
 ....                                if (dev->next_event < bc->next_event) {
                                       raw_spin_lock(&tick_broadcast_lock);

 tick_broadcast_set_event(next_event, 0);
   bc->next_event = next_event;

 raw_spin_unlock(&tick_broadcast_lock);
                                       tick_broadcast_set_event(dev->next_event, 1);

So you unconditionally set the broadcast device to dev->next_event of
CPU1 even if the current pending event which was evaluated on CPU0 is
_BEFORE_ the CPU1 event. That can cause stalls and other hard to debug
horror. We've been there before.

Further the unprotected comparison on 32bit is completely bogus.

> +				raw_spin_lock_irqsave(&tick_broadcast_lock, flags);
>  				tick_broadcast_set_event(dev->next_event, 1);
> +				raw_spin_unlock_irqrestore(&tick_broadcast_lock, 
> +							   flags);		
> +			}
>  		}
>  	} else {
>  		if (__get_cpu_var(state).need_oneshot) {
>  			__get_cpu_var(state).need_oneshot = 0;
>  			clockevents_set_mode(dev, CLOCK_EVT_MODE_ONESHOT);
> -			if (dev->next_event.tv64 != KTIME_MAX)
> +
> +			/* Only take the lock if the event changes */
> +			if (dev->next_event.tv64 != KTIME_MAX) {
> +				raw_spin_lock_irqsave(&tick_broadcast_lock, flags);

Why would you take the global lock to program the cpu local device?
Just because it happened to be under that lock before?

>  				tick_program_event(dev->next_event, 1);
> +				raw_spin_unlock_irqrestore(&tick_broadcast_lock, 
> +							   flags);

Thanks,

	tglx
