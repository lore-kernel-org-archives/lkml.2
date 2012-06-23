Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2FWRDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 13:03:17 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:38034 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab2FWRDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 13:03:16 -0400
Date: Sat, 23 Jun 2012 10:01:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: tracer_alloc_buffers returned with preemption imbalance
Message-ID: <20120623170147.GI2516@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120623101251.GA10162@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120623101251.GA10162@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12062317-5518-0000-0000-00000575CC1C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2012 at 06:12:51PM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> I got some boot hangs in the below branches and linux-next:
> 
>         rcu/dev.2012.06.21c-4f4a59a
>         rcu/fixes.2012.06.20a-b43145c
>         rcu/rcu.next-3f26dd3
> 
> They all start with an error
> 
> [    0.131005] initcall tracer_alloc_buffers+0x0/0x22e returned with preemption imbalance
> 
> Then followed by lots of scheduling while atomic bugs:
> 
> [    0.143206] Brought up 2 CPUs
> [    0.144996] ----------------
> [    0.145989] | NMI testsuite:
> [    0.147988] --------------------
> [    0.149238]   remote IPI:
> [    0.149239] BUG: scheduling while atomic: swapper/0/1/0x00000002
> [    0.151082] no locks held by swapper/0/1.
> [    0.152991] Modules linked in:
> [    0.153992] Pid: 1, comm: swapper/0 Not tainted 3.5.0-rc3+ #24
> [    0.155990] Call Trace:
> [    0.157056]  [<ffffffff81a21ee1>] __schedule_bug+0x67/0x75
> [    0.158999]  [<ffffffff81a3717c>] __schedule+0xb0/0x8b0
> [    0.160995]  [<ffffffff810b8fe2>] ? save_trace+0x3d/0xae
> [    0.162993]  [<ffffffff8105ad19>] ? pvclock_clocksource_read+0x4d/0xc3
> [    0.164992]  [<ffffffff810bbdff>] ? mark_lock+0x23c/0x502
> [    0.166993]  [<ffffffff8105a10b>] ? kvm_clock_read+0x2e/0x36
> [    0.168991]  [<ffffffff81a37c61>] schedule+0x65/0x67
> [    0.170992]  [<ffffffff81a35542>] schedule_timeout+0x2e/0x22a
> [    0.172991]  [<ffffffff810b8c1c>] ? trace_hardirqs_off+0xd/0xf
> [    0.174992]  [<ffffffff8109c890>] ? local_clock+0x41/0x5a
> [    0.176995]  [<ffffffff81a392f0>] ? _raw_spin_unlock_irq+0x2e/0x48
> [    0.178990]  [<ffffffff810bd647>] ? trace_hardirqs_on_caller+0x125/0x181
> [    0.180995]  [<ffffffff810bd6b0>] ? trace_hardirqs_on+0xd/0xf
> [    0.182989]  [<ffffffff81a37b06>] wait_for_common+0x10a/0x140
> [    0.184989]  [<ffffffff8109a2f2>] ? try_to_wake_up+0x2cb/0x2cb
> [    0.186990]  [<ffffffff810ea4c6>] ? call_rcu_bh+0x19/0x19
> [    0.188988]  [<ffffffff81a37bfa>] wait_for_completion+0x1d/0x1f
> [    0.190989]  [<ffffffff8108752d>] wait_rcu_gp+0x4d/0x54
> [    0.192988]  [<ffffffff81087534>] ? wait_rcu_gp+0x54/0x54
> [    0.194987]  [<ffffffff81a37a40>] ? wait_for_common+0x44/0x140
> [    0.196987]  [<ffffffff810e8713>] synchronize_sched+0x50/0x52
> [    0.198987]  [<ffffffff8103b272>] unregister_nmi_handler+0xc6/0xd5
> [    0.200989]  [<ffffffff8142fa79>] ? delay_tsc+0x49/0xa5
> [    0.202988]  [<ffffffff82259db7>] test_nmi_ipi.constprop.2+0x72/0x85
> [    0.204986]  [<ffffffff82259dca>] ? test_nmi_ipi.constprop.2+0x85/0x85
> [    0.206986]  [<ffffffff82259e27>] remote_ipi+0x5d/0x62
> [    0.208985]  [<ffffffff82259ce2>] dotest.constprop.1+0x6/0x69
> [    0.210985]  [<ffffffff82259ede>] nmi_selftest+0x60/0x16d
> [    0.212986]  [<ffffffff822558da>] native_smp_cpus_done+0x1c/0x111
> [    0.214989]  [<ffffffff8226198b>] smp_init+0xe2/0xeb
> [    0.216986]  [<ffffffff82248c0f>] kernel_init+0xa9/0x1c0
> [    0.218984]  [<ffffffff810bd538>] ? trace_hardirqs_on_caller+0x16/0x181
> [    0.220989]  [<ffffffff81a417b4>] kernel_thread_helper+0x4/0x10
> [    0.222989]  [<ffffffff81a396f0>] ? retint_restore_args+0x13/0x13
> [    0.224990]  [<ffffffff82248b66>] ? start_kernel+0x3a3/0x3a3
> [    0.226983]  [<ffffffff81a417b0>] ? gs_change+0x13/0x13
> [    0.231002]   ok  |
> [    0.231998]    local IPI:
> [    0.231998] BUG: scheduling while atomic: swapper/0/1/0x00000003
> ...
> 
> The first bad commit is
> 
> commit b43145c912b7dabd190ec45cc31c2b96d64715ee
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Tue Jun 19 11:58:27 2012 -0700
> 
>     rcu: Disable preemption in rcu_blocking_is_gp()
>     
>     It is time to optimize CONFIG_TREE_PREEMPT_RCU's synchronize_rcu()
>     for uniprocessor optimization, which means that rcu_blocking_is_gp()
>     can no longer rely on RCU read-side critical sections having disabled
>     preemption.  This commit therefore disables preemption across
>     rcu_blocking_is_gp()'s scan of the cpu_online_mask.
>     
>     Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index ce175b6..c0cc41f 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> ...
>  static inline int rcu_blocking_is_gp(void)
>  {
>         might_sleep();  /* Check for RCU read-side critical section. */
> +       preempt_disable();
>         return num_online_cpus() <= 1;
> +       preempt_enable();
>  }

Thank you!  I have no idea how a preempt_disable() causes that badness
to happen, but this commit is not yet critically important, so I will
drop it.

							Thanx, Paul

