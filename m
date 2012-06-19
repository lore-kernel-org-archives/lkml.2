Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2FSGIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 02:08:40 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34136 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab2FSGIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 02:08:38 -0400
Date: Tue, 19 Jun 2012 14:08:24 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Charles Wang <muming.wq@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Tao Ma <tm@tao.ma>,
        =?utf-8?B?5ZCr6bub?= <handai.szj@taobao.com>,
        Doug Smythies <dsmythies@telus.net>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] sched: Folding nohz load accounting more accurate
Message-ID: <20120619060824.GA31684@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1339239295-18591-1-git-send-email-muming.wq@taobao.com>
 <1339429374.30462.54.camel@twins>
 <4FD70D12.5030404@gmail.com>
 <1339494970.31548.66.camel@twins>
 <4FDB4642.5070509@gmail.com>
 <1340035417.15222.95.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1340035417.15222.95.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 06:03:37PM +0200, Peter Zijlstra wrote:
> > Nohz exit is always caused
> > by processes woken up--non-idle model. It's not fair here, idle
> > calculated to non-idle.
> > 
> >      time-expect-sampling
> >                    |    time-do-sampling
> >                    |         |
> >                    V         V
> > -|-------------------------|--
> > start_nohz              stop_nohz
> 
> I don't think the delay in sampling is the biggest problem, I think the
> problem is the direct interaction between a cpu going idle and another
> cpu taking a sample.

IIUC, you hook into tick_nohz_idle_exit() will cure Charles's problem.

And comments below.

> ---
>  kernel/sched/core.c      |  290 ++++++++++++++++++++++++++++++++++------------
>  kernel/sched/idle_task.c |    1 -
>  kernel/sched/sched.h     |    2 -
>  kernel/time/tick-sched.c |    2 +
>  4 files changed, 220 insertions(+), 75 deletions(-)
> 
> + *  - When we go NO_HZ idle during the window, we can negate our sample
> + *    contribution, causing under-accounting.
> + *
> + *    We avoid this by keeping two idle-delta counters and flipping them
> + *    when the window starts, thus separating old and new NO_HZ load.
> + *
> + *    The only trick is the slight shift in index flip for read vs write.
> + *
> + *       0             5             10            15
> + *         +10           +10           +10           +10
> + *       |-|-----------|-|-----------|-|-----------|-|
> + *    r:001           110           001           110
> + *    w:011           100           011           100

I'm confused by this comments, looking at your code, index is increased by
1 for each samaple window.

> + *
> + *    This ensures we'll fold the old idle contribution in this window while
> + *    accumlating the new one.
> + *
> + *  - When we wake up from NO_HZ idle during the window, we push up our
> + *    contribution, since we effectively move our sample point to a known
> + *    busy state.
> + *
> + *    This is solved by pushing the window forward, and thus skipping the
> + *    sample, for this cpu (effectively using the idle-delta for this cpu which
> + *    was in effect at the time the window opened). This also solves the issue
> + *    of having to deal with a cpu having been in NOHZ idle for multiple
> + *    LOAD_FREQ intervals.
>   *
>   * When making the ILB scale, we should try to pull this in as well.
>   */
> -static long calc_load_fold_idle(void)
> +void calc_load_exit_idle(void)
>  {
> -	long delta = 0;
> +	struct rq *this_rq = this_rq();
>  
>  	/*
> -	 * Its got a race, we don't care...
> +	 * If we're still outside the sample window, we're done.
>  	 */
> -	if (atomic_long_read(&calc_load_tasks_idle))
> -		delta = atomic_long_xchg(&calc_load_tasks_idle, 0);
> +	if (time_before(jiffies, this_rq->calc_load_update))
> +		return;
	else if (time_before(jiffies, calc_load_update + 10)
		this_rq->calc_load_update = calc_load_update + LOAD_FREQ;
	else
		this_rq->calc_load_update = calc_load_update;

Otherwise if you woke after the sample window, we loose on sample?
And maybe we need local variable to cache calc_load_update.

Thanks,
Yong
