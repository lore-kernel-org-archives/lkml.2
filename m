Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2HTJ1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:27:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:24453 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977Ab2HTJ1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:27:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,796,1336374000"; 
   d="scan'208";a="206249454"
Date: Mon, 20 Aug 2012 17:27:44 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Yinghai Lu <yinghai@kernel.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: scheduling while atomic, under native_smp_prepare_cpus()
Message-ID: <20120820092744.GA3668@localhost>
References: <20120817134944.GA539@localhost>
 <50320163.5080703@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50320163.5080703@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Aug 20, 2012 at 05:20:35PM +0800, Michael Wang wrote:
> On 08/17/2012 09:49 PM, Fengguang Wu wrote:
> 
> Hi, FengGuang
> 
> native_smp_prepare_cpus has already disabled the preempt before
> reach __irq_alloc_descs(), and sleep in mutex_lock() cause the bug.
> 
> May be the follow patch could help to solve the issue(actually I
> think the true problem should be in _cond_resched...).

Is this a debug patch? Since what it does is to conditionally disable
the warning.

> I can't do test by my self since I can't reproduce the issue on my
> machine, the kernel_init thread never got a need sched flag set at
> that moment in my case...
 
I'll try it and report back :)

Thanks,
Fengguang

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 4376c9f..3396c33 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -3321,7 +3321,8 @@ static inline void schedule_debug(struct task_struct *prev)
>          * schedule() atomically, we ignore that path for now.
>          * Otherwise, whine if we are scheduling when we should not be.
>          */
> -       if (unlikely(in_atomic_preempt_off() && !prev->exit_state))
> +       if (unlikely(in_atomic_preempt_off() && !prev->exit_state
> +                                       && system_state == SYSTEM_RUNNING))
>                 __schedule_bug(prev);
>         rcu_sleep_check();
> 
> 
> > Trace one (full config/dmesg attached):
> > 
> > [    0.042794] init IO_APIC IRQs [    0.043305]  apic 2 pin 0 not 
> > connected [    0.043953] BUG: scheduling while atomic: 
> > swapper/0/1/0x10000002 [    0.044017] no locks held by swapper/0/1. [
> > 0.044692] Pid: 1, comm: swapper/0 Not tainted 
> > 3.6.0-rc1-00420-gb7aebb9 #34 [    0.045861] Call Trace: [ 0.048071] 
> > [<c106361e>] __schedule_bug+0x5e/0x70 [    0.048890] [<c1b28701>] 
> > __schedule+0x91/0xb10 [    0.049660]  [<c14472ea>] ? 
> > vsnprintf+0x33a/0x450 [    0.050444]  [<c1060006>] ? 
> > lg_local_lock+0x6/0x70 [    0.051256]  [<c14fb5b1>] ? 
> > wait_for_xmitr+0x31/0x90 [    0.052019]  [<c144fd55>] ? 
> > do_raw_spin_unlock+0xa5/0xf0 [    0.052903]  [<c1b2a532>] ? 
> > _raw_spin_unlock+0x22/0x30 [    0.053759]  [<c105cdbb>] ? 
> > up+0x1b/0x70 [    0.054421]  [<c1065d6b>] __cond_resched+0x1b/0x30 [
> >  0.055228]  [<c1b292d5>] _cond_resched+0x45/0x50 [    0.056020] 
> > [<c1b26c58>] mutex_lock_nested+0x28/0x370 [    0.056884]
> > [<c1034222>] ? console_unlock+0x3a2/0x4e0 [    0.057741]
> > [<c1ac8559>] __irq_alloc_descs+0x39/0x1c0 [    0.058589]
> > [<c10223bc>] io_apic_setup_irq_pin+0x2c/0x310 [    0.060042]
> > [<c20638df>] setup_IO_APIC+0x101/0x744 [    0.060878]  [<c1021d51>] ?
> >  clear_IO_APIC+0x31/0x50 [    0.061695]  [<c20600f4>] 
> > native_smp_prepare_cpus+0x538/0x680 [    0.062644]  [<c2056a91>] ? 
> > do_one_initcall+0x12c/0x12c [    0.063517]  [<c2056a91>] ? 
> > do_one_initcall+0x12c/0x12c [    0.064016]  [<c2056adc>] 
> > kernel_init+0x4b/0x17f [    0.064790]  [<c2056a91>] ? 
> > do_one_initcall+0x12c/0x12c [    0.065660]  [<c1b2bbd6>] 
> > kernel_thread_helper+0x6/0x10 [    0.066592] IOAPIC[0]: Set routing 
> > entry (2-1 -> 0x41 -> IRQ 1 Mode:0 Active:0 Dest:1) [    0.068045] 
> > IOAPIC[0]: Set routing entry (2-2 -> 0x51 -> IRQ 0 Mode:0 Active:0 
> > Dest:1)
> > 
> > Trace two (triggered by another config):
> > 
> > [    0.288018] tlb_flushall_shift is 0xffffffff [    0.316019] 
> > Freeing SMP alternatives: 20k freed [    0.364022] BUG: scheduling 
> > while atomic: swapper/0/1/0x10000002 [    0.364022] no locks held by
> >  swapper/0/1. [    0.368023] Pid: 1, comm: swapper/0 Not tainted 
> > 3.6.0-rc1 #1 [    0.368023] Call Trace: [    0.368023]  [<79812e23>]
> >  __schedule_bug+0x41/0x53 [    0.372023]  [<79820393>] 
> > __schedule+0x62/0x488 [    0.376023]  [<792d17ae>] ? 
> > radix_tree_lookup+0xa/0xc [    0.376023]  [<79071f4e>] ? 
> > rcu_irq_exit+0x61/0x66 [    0.376023]  [<79026be7>] ? 
> > irq_exit+0x60/0x6c [    0.376023]  [<790035df>] ? do_IRQ+0x6c/0x80 [
> >  0.380023]  [<7903d794>] __cond_resched+0x16/0x26 [    0.380023] 
> > [<79820888>] _cond_resched+0x13/0x1c [    0.380023]  [<7909f30a>] 
> > slab_pre_alloc_hook.isra.44+0x2e/0x33 [    0.380023]  [<790a09c6>] 
> > kmem_cache_alloc+0x1b/0xbb [    0.384024]  [<792ce416>] ? 
> > alloc_cpumask_var_node+0x1a/0x72 [    0.384024]  [<792ce416>] 
> > alloc_cpumask_var_node+0x1a/0x72 [    0.384024]  [<792ce486>] 
> > alloc_cpumask_var+0xb/0xd [    0.388024]  [<792ce493>] 
> > zalloc_cpumask_var+0xb/0xd [    0.388024]  [<79bfe1fd>] 
> > native_smp_prepare_cpus+0x93/0x380 [    0.388024]  [<79bf6a7e>] ? 
> > do_one_initcall+0x10c/0x10c [    0.388024]  [<79bf6ac6>] 
> > kernel_init+0x48/0x16e [    0.392024]  [<79bf6a7e>] ? 
> > do_one_initcall+0x10c/0x10c [    0.392024]  [<7982241e>] 
> > kernel_thread_helper+0x6/0xd [    0.400025] smpboot: SMP disabled [ 
> > 0.400025] Performance Events:
> > 
> > Thanks, Fengguang
> > 
