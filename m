Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754464Ab2IMKFr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:05:47 -0400
Received: from [205.233.59.134] ([205.233.59.134]:58306 "EHLO
	merlin.infradead.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab2IMKFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:05:46 -0400
Message-ID: <1347530696.15764.117.camel@twins>
Subject: Re: [PATCH] sched: unify the check on atomic sleeping in
 __might_sleep() and schedule_bug()
From: Peter Zijlstra <peterz@infradead.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, mingo@redhat.com
Date: Thu, 13 Sep 2012 12:04:56 +0200
In-Reply-To: <503446AA.2020004@linux.vnet.ibm.com>
References: <503446AA.2020004@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-08-22 at 10:40 +0800, Michael Wang wrote:
> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> 
> Fengguang Wu <wfg@linux.intel.com> has reported the bug:
> 
> [    0.043953] BUG: scheduling while atomic: swapper/0/1/0x10000002
> [    0.044017] no locks held by swapper/0/1.
> [    0.044692] Pid: 1, comm: swapper/0 Not tainted 3.6.0-rc1-00420-gb7aebb9 #34
> [    0.045861] Call Trace:
> [    0.048071]  [<c106361e>] __schedule_bug+0x5e/0x70
> [    0.048890]  [<c1b28701>] __schedule+0x91/0xb10
> [    0.049660]  [<c14472ea>] ? vsnprintf+0x33a/0x450
> [    0.050444]  [<c1060006>] ? lg_local_lock+0x6/0x70
> [    0.051256]  [<c14fb5b1>] ? wait_for_xmitr+0x31/0x90
> [    0.052019]  [<c144fd55>] ? do_raw_spin_unlock+0xa5/0xf0
> [    0.052903]  [<c1b2a532>] ? _raw_spin_unlock+0x22/0x30
> [    0.053759]  [<c105cdbb>] ? up+0x1b/0x70
> [    0.054421]  [<c1065d6b>] __cond_resched+0x1b/0x30
> [    0.055228]  [<c1b292d5>] _cond_resched+0x45/0x50
> [    0.056020]  [<c1b26c58>] mutex_lock_nested+0x28/0x370
> [    0.056884]  [<c1034222>] ? console_unlock+0x3a2/0x4e0
> [    0.057741]  [<c1ac8559>] __irq_alloc_descs+0x39/0x1c0
> [    0.058589]  [<c10223bc>] io_apic_setup_irq_pin+0x2c/0x310
> [    0.060042]  [<c20638df>] setup_IO_APIC+0x101/0x744
> [    0.060878]  [<c1021d51>] ? clear_IO_APIC+0x31/0x50
> [    0.061695]  [<c20600f4>] native_smp_prepare_cpus+0x538/0x680
> [    0.062644]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
> [    0.063517]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
> [    0.064016]  [<c2056adc>] kernel_init+0x4b/0x17f
> [    0.064790]  [<c2056a91>] ? do_one_initcall+0x12c/0x12c
> [    0.065660]  [<c1b2bbd6>] kernel_thread_helper+0x6/0x10
> 
> It was caused by that:
> 
> 	native_smp_prepare_cpus()
> 	preempt_disable()		//preempt_count++
> 	mutex_lock()			//in __irq_alloc_descs
> 	__might_sleep()			//system is booting, avoid check
> 	might_resched()
> 	__schedule()
> 	preempt_disable()		//preempt_count++
> 	schedule_bug()			//preempt_count > 1, report bug
> 
> The __might_sleep() avoid check on atomic sleeping until the system booted
> while the schedule_bug() doesn't, it's the reason for the bug.
> 
> This patch will add one additional check in schedule_bug() to avoid check
> until the system booted, so the check on atomic sleeping will be unified.
> 
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> Tested-by: Fengguang Wu <wfg@linux.intel.com>
> ---
>  kernel/sched/core.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4376c9f..3396c33 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3321,7 +3321,8 @@ static inline void schedule_debug(struct task_struct *prev)
>  	 * schedule() atomically, we ignore that path for now.
>  	 * Otherwise, whine if we are scheduling when we should not be.
>  	 */
> -	if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
> +	if (unlikely(in_atomic_preempt_off() && !prev->exit_state
> +					&& system_state == SYSTEM_RUNNING))
>  		__schedule_bug(prev);
>  	rcu_sleep_check();
>  


No this is very very wrong.. we avoid the might_sleep bug on !
SYSTEM_RUNNING because while we _might_ sleep, we should _never_
actually sleep under those conditions.

So hitting a schedule() here is an actual bug.
