Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406Ab2KFBHS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 20:07:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:13399 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295Ab2KFBHQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 20:07:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,719,1344236400"; 
   d="scan'208";a="244556240"
Message-ID: <1352164047.17919.1.camel@ymzhang.sh.intel.com>
Subject: Re: [PATCH V2] hrtimer: Printing timer info when hitting BUG_ON()
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
Reply-To: yanmin_zhang@linux.intel.com
To: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: tglx@linutronix.de, mingo@kernel.org, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, fei.li@intel.com
Date: Tue, 06 Nov 2012 09:07:27 +0800
In-Reply-To: <1351592820.15558.1450.camel@cliu38-desktop-build>
References: <1351592820.15558.1450.camel@cliu38-desktop-build>
Organization: Intel.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-30 at 18:27 +0800, Chuansheng Liu wrote:
> We encounted one BUG_ON() issue at function __run_hrtimer(),
> but the panic info is not enough to find out which hrtimer
> users use the hrtimer wrongly.
> (in this BUG_ON case, it is callback running at the same time
> hrtimer_start() is executed on different context.)
> 
> We can print basic timer info before BUG(), it is easy to find
> out which hrtimer user has fault, the output info is like below:
> 
> <3>[   41.118552] timer info: state/3, func/test_timer_cb
> <3>[   41.118618] timer stats: pid/786(sh), site/hrtimer_start
> <0>[   41.118670] ------------[ cut here ]------------
> <2>[   41.118691] kernel BUG at /root/r4_code/hardware/intel/linux-2.6/kernel/hrtimer.c:1260!
> <0>[   41.118715] invalid opcode: 0000 [#1] PREEMPT SMP
> 
> The infos of callback/state are very helpful for debugging this BUG_ON().
It's a useful patch.

Thomas,

Could you merge it into your testing tree, so other developers could also
benefit from it?

Thanks all.
Yanmin

> 
> Signed-off-by: Li Fei <fei.li@intel.com>
> Signed-off-by: liu chuansheng <chuansheng.liu@intel.com>
> ---
>  kernel/hrtimer.c |   21 ++++++++++++++++++++-
>  1 files changed, 20 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
> index 6db7a5e..0618eaf 100644
> --- a/kernel/hrtimer.c
> +++ b/kernel/hrtimer.c
> @@ -1204,6 +1204,22 @@ int hrtimer_get_res(const clockid_t which_clock, struct timespec *tp)
>  }
>  EXPORT_SYMBOL_GPL(hrtimer_get_res);
>  
> +/*
> + * dump_hrtimer_callinfo - print hrtimer information including:
> + * state, callback function, pid and start_site.
> +*/
> +static void dump_hrtimer_callinfo(struct hrtimer *timer)
> +{
> +
> +	pr_err("timer info: state/%lx, func/%pf\n",
> +		timer->state, timer->function);
> +
> +#ifdef CONFIG_TIMER_STATS
> +	pr_err("timer stats: pid/%d(%s), site/%pf\n",
> +		timer->start_pid, timer->start_comm, timer->start_site);
> +#endif
> +}
> +
>  static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>  {
>  	struct hrtimer_clock_base *base = timer->base;
> @@ -1235,7 +1251,10 @@ static void __run_hrtimer(struct hrtimer *timer, ktime_t *now)
>  	 * hrtimer_start_range_ns() or in hrtimer_interrupt()
>  	 */
>  	if (restart != HRTIMER_NORESTART) {
> -		BUG_ON(timer->state != HRTIMER_STATE_CALLBACK);
> +		if (timer->state != HRTIMER_STATE_CALLBACK) {
> +			dump_hrtimer_callinfo(timer);
> +			BUG();
> +		}
>  		enqueue_hrtimer(timer, base);
>  	}
>  


