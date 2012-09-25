Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757080Ab2IYPIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 11:08:01 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58272 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920Ab2IYPH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 11:07:58 -0400
Date: Tue, 25 Sep 2012 08:07:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>,
        Christian Hoffmann <email@christianhoffmann.info>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected
 by 0, t=10002 jiffies)
Message-ID: <20120925150701.GA2502@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120925111938.GA4545@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120925111938.GA4545@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12092515-6078-0000-0000-00000FF904D3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 07:19:38PM +0800, Fengguang Wu wrote:
> Hi Paul,
> 
> I've just bisected down one RCU stall problem:
> 
> [   12.035785] pktgen: Packet Generator for packet performance testing. Version: 2.74
> [   12.435439] atkbd: probe of serio0 rejects match -19
> [  111.700160] INFO: rcu_preempt detected stalls on CPUs/tasks: { 1} (detected by 0, t=10002 jiffies)
> [  111.700171] Pid: 0, comm: swapper/0 Not tainted 3.6.0-rc5-00004-gda10491 #1
> [  111.700178] Call Trace:
> [  111.700475]  [<c10c3c84>] rcu_check_callbacks+0x544/0x570
> [  111.700538]  [<c1075e86>] update_process_times+0x36/0x70
> [  111.700547]  [<c10a6267>] tick_sched_timer+0x57/0xc0
> [  111.700552]  [<c108758a>] __run_hrtimer.isra.31+0x4a/0xc0
> [  111.700557]  [<c10a6210>] ? tick_nohz_handler+0xf0/0xf0
> [  111.700559]  [<c1088155>] hrtimer_interrupt+0xf5/0x290
> [  111.700562]  [<c1091cb8>] ? sched_clock_idle_wakeup_event+0x18/0x20
> [  111.700565]  [<c10a6399>] ? tick_nohz_stop_idle+0x39/0x40
> [  111.700572]  [<c104f56f>] smp_apic_timer_interrupt+0x4f/0x80
> [  111.700587]  [<c1753636>] apic_timer_interrupt+0x2a/0x30
> [  111.700593]  [<c10565b5>] ? native_safe_halt+0x5/0x10
> [  111.700599]  [<c1039f89>] default_idle+0x29/0x50
> [  111.700601]  [<c103a958>] cpu_idle+0x68/0xb0
> [  111.700609]  [<c16f2ff7>] rest_init+0x67/0x70
> [  111.700627]  [<c1af7929>] start_kernel+0x2ea/0x2f0
> [  111.700629]  [<c1af7474>] ? repair_env_string+0x51/0x51
> [  111.700631]  [<c1af72a2>] i386_start_kernel+0x78/0x7d
> [  127.040302] bus: 'serio': driver_probe_device: matched device serio0 with driver atkbd
> [  127.041308] CPA self-test:
> 
> to this commit:
> 
> commit 06ae115a1d551cd952d80df06eaf8b5153351875
> Author: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Date:   Sun Aug 14 15:56:54 2011 -0700
> 
>     rcu: Avoid having just-onlined CPU resched itself when RCU is idle

Interesting.  Of course the stack is from the CPU that detected the
problem rather than the problematic CPU.  ;-)

Could you please try the following patch?

							Thanx, Paul
------------------------------------------------------------------------

rcu: Fix day-one dyntick-idle stall-warning bug

Each grace period is supposed to have at least one callback waiting
for that grace period to complete.  However, if CONFIG_NO_HZ=n, an
extra callback-free grace period is no big problem -- it will chew up
a tiny bit of CPU time, but it will complete normally.  In contrast,
CONFIG_NO_HZ=y kernels have the potential for all the CPUs to go to
sleep indefinitely, in turn indefinitely delaying completion of the
callback-free grace period.  Given that nothing is waiting on this grace
period, this is also not a problem.

That is, unless RCU CPU stall warnings are also enabled, as they are
in recent kernels.  In this case, if a CPU wakes up after at least one
minute of inactivity, an RCU CPU stall warning will result.  The reason
that no one noticed until quite recently is that most systems have enough
OS noise that they will never remain absolutely idle for a full minute.
But there are some embedded systems with cut-down userspace configurations
that consistently get into this situation.

All this begs the question of exactly how a callback-free grace period
gets started in the first place.  This can happen due to the fact that
CPUs do not necessarily agree on which grace period is in progress.
If a CPU still believes that the grace period that just completed is
still ongoing, it will believe that it has callbacks that need to wait for
another grace period, never mind the fact that the grace period that they
were waiting for just completed.  This CPU can therefore erroneously
decide to start a new grace period.  Note that this can happen in
TREE_RCU and TREE_PREEMPT_RCU even on a single-CPU system:  Deadlock
considerations mean that the CPU that detected the end of the grace
period is not necessarily officially informed of this fact for some time.

Once this CPU notices that the earlier grace period completed, it will
invoke its callbacks.  It then won't have any callbacks left.  If no
other CPU has any callbacks, we now have a callback-free grace period.

This commit therefore makes CPUs check more carefully before starting a
new grace period.  This new check relies on an array of tail pointers
into each CPU's list of callbacks.  If the CPU is up to date on which
grace periods have completed, it checks to see if any callbacks follow
the RCU_DONE_TAIL segment, otherwise it checks to see if any callbacks
follow the RCU_WAIT_TAIL segment.  The reason that this works is that
the RCU_WAIT_TAIL segment will be promoted to the RCU_DONE_TAIL segment
as soon as the CPU is officially notified that the old grace period
has ended.

This change is to cpu_needs_another_gp(), which is called in a number
of places.  The only one that really matters is in rcu_start_gp(), where
the root rcu_node structure's ->lock is held, which prevents any
other CPU from starting or completing a grace period, so that the
comparison that determines whether the CPU is missing the completion
of a grace period is stable.

Reported-by: Becky Bruce <bgillbruce@gmail.com>
Reported-by: Subodh Nijsure <snijsure@grid-net.com>
Reported-by: Paul Walmsley <paul@pwsan.com>
Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Tested-by: Paul Walmsley <paul@pwsan.com>  # OMAP3730, OMAP4430
Cc: stable@vger.kernel.org

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index f280e54..f7bcd9e 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -305,7 +305,9 @@ cpu_has_callbacks_ready_to_invoke(struct rcu_data *rdp)
 static int
 cpu_needs_another_gp(struct rcu_state *rsp, struct rcu_data *rdp)
 {
-	return *rdp->nxttail[RCU_DONE_TAIL] && !rcu_gp_in_progress(rsp);
+	return *rdp->nxttail[RCU_DONE_TAIL +
+			     ACCESS_ONCE(rsp->completed) != rdp->completed] &&
+	       !rcu_gp_in_progress(rsp);
 }
 
 /*

