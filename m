Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab2EYUsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:48:35 -0400
Received: from www.linutronix.de ([62.245.132.108]:39899 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab2EYUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:48:33 -0400
Date: Fri, 25 May 2012 22:48:16 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Gilad Ben-Yossef <gilad@benyossef.com>
cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/6] timer: make __next_timer_interrupt explicit about
 no future event
In-Reply-To: <1336056962-10465-2-git-send-email-gilad@benyossef.com>
Message-ID: <alpine.LFD.2.02.1205251846520.3231@ionos>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-2-git-send-email-gilad@benyossef.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 May 2012, Gilad Ben-Yossef wrote:
> What is happening is that when __next_timer_interrupt() wishes
> to return a value that signifies "there is no future timer
> event", it returns (base->timer_jiffies + NEXT_TIMER_MAX_DELTA).
> 
> However, the code in tick_nohz_stop_sched_tick(), which called
> __next_timer_interrupt() via get_next_timer_interrupt(),
> compares the return value to (last_jiffies + NEXT_TIMER_MAX_DELTA)
> to see if the timer needs to be re-armed.

Yeah, that's nonsense.
 
> I've noticed a similar but slightly different fix to the
> same problem in the Tilera kernel tree from Chris M. (I've
> wrote this before seeing that one), so some variation of this
> fix is in use on real hardware for some time now.

Sigh, why can't people post their fixes instead of burying them in
their private trees?

> -static unsigned long __next_timer_interrupt(struct tvec_base *base)
> +static bool __next_timer_interrupt(struct tvec_base *base,
> +					unsigned long *next_timer)

....

> +out:
> +	if (found)
> +		*next_timer = expires;
> +	return found;

I'd really like to avoid that churn. That function is ugly enough
already. No need to make it even more so.

> @@ -1317,9 +1322,15 @@ unsigned long get_next_timer_interrupt(unsigned long now)
>  	if (cpu_is_offline(smp_processor_id()))
>  		return now + NEXT_TIMER_MAX_DELTA;
>  	spin_lock(&base->lock);
> -	if (time_before_eq(base->next_timer, base->timer_jiffies))
> -		base->next_timer = __next_timer_interrupt(base);
> -	expires = base->next_timer;
> +	if (time_before_eq(base->next_timer, base->timer_jiffies)) {
> +
> +		if (__next_timer_interrupt(base, &expires))
> +			base->next_timer = expires;
> +		else
> +			expires = now + NEXT_TIMER_MAX_DELTA;

Here you don't update base->next_timer which makes sure, that we run
through the scan function on every call. Not good.

> +	} else
> +		expires = base->next_timer;
> +

If the thing is empty or just contains deferrable timers then we
really want to avoid running through the whole cascade horror for
nothing.

Timer add and remove are protected by base->lock. So we simply should
count the non deferrable enqueued timers and avoid the whole
__next_timer_interrupt() completely in case there is nothing what
should wake us up.

I had a deeper look at that and will send out a repair set soon.

Thanks,

	tglx
