Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab0DAT2w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:28:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58475 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756431Ab0DAT2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:28:49 -0400
Date: Thu, 1 Apr 2010 12:27:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [REGRESSION 2.6.30][PATCH 1/1] sched: defer idle accounting
 till after load update period
Message-Id: <20100401122740.a1ae80a7.akpm@linux-foundation.org>
In-Reply-To: <1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
References: <1269870072-22449-1-git-send-email-chase.douglas@canonical.com>
	<1269870072-22449-2-git-send-email-chase.douglas@canonical.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Mar 2010 09:41:12 -0400
Chase Douglas <chase.douglas@canonical.com> wrote:

> There's a period of 10 ticks where calc_load_tasks is updated by all the
> cpus for the load avg. Usually all the cpus do this during the first
> tick. If any cpus go idle, calc_load_tasks is decremented accordingly.
> However, if they wake up calc_load_tasks is not incremented. Thus, if
> cpus go idle during the 10 tick period, calc_load_tasks may be
> decremented to a non-representative value. This issue can lead to
> systems having a load avg of exactly 0, even though the real load avg
> could theoretically be up to NR_CPUS.
> 
> This change defers calc_load_tasks accounting after each cpu updates the
> count until after the 10 tick period.
> 
> BugLink: http://bugs.launchpad.net/bugs/513848
> 

There was useful information in the [patch 0/1] email, such as the
offending commit ID.  If possible, it's best to avoid the [patch 0/n]
thing altogether - that information either has to be moved into the
[patch 1/n] changelog by someone (ie: me), or it just gets ommitted and
lost.


> ---
>  kernel/sched.c |   16 ++++++++++++++--
>  1 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 9ab3cd7..c0aedac 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -3064,7 +3064,8 @@ void calc_global_load(void)
>   */
>  static void calc_load_account_active(struct rq *this_rq)
>  {
> -	long nr_active, delta;
> +	static atomic_long_t deferred;
> +	long nr_active, delta, deferred_delta;
>  
>  	nr_active = this_rq->nr_running;
>  	nr_active += (long) this_rq->nr_uninterruptible;
> @@ -3072,6 +3073,17 @@ static void calc_load_account_active(struct rq *this_rq)
>  	if (nr_active != this_rq->calc_load_active) {
>  		delta = nr_active - this_rq->calc_load_active;
>  		this_rq->calc_load_active = nr_active;
> +
> +		/* Need to defer idle accounting during load update period: */
> +		if (unlikely(time_before(jiffies, this_rq->calc_load_update) &&
> +			     time_after_eq(jiffies, calc_load_update))) {
> +			atomic_long_add(delta, &deferred);
> +			return;
> +		}

That seems a sensible way to avoid the gross-looking "10 ticks" thing.

What was the reason for "update the avenrun load estimates 10 ticks
after the CPUs have updated calc_load_tasks"?  Can we do something
smarter there to fix this?

> +		deferred_delta = atomic_long_xchg(&deferred, 0);
> +		delta += deferred_delta;
> +
>  		atomic_long_add(delta, &calc_load_tasks);
>  	}
>  }

The global `deferred' is unfortunate from a design and possibly
scalability POV.  Can it be moved into the `struct rq'?  That way it
can become a plain old `unsigned long', too.

