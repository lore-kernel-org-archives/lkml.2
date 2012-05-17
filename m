Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab2EQECe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 00:02:34 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:54595 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab2EQECb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 00:02:31 -0400
Message-ID: <1337227263.24471.23.camel@ThinkPad-T420>
Subject: [PATCH powerpc] fix a lockdep complaint in start_secondary
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        PowerPC email list <linuxppc-dev@lists.ozlabs.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Thu, 17 May 2012 12:01:03 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12051617-5490-0000-0000-000001669E39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch tries to fix following lockdep complaints:

[   81.882506] =================================
[   81.882508] [ INFO: inconsistent lock state ]
[   81.882511] 3.4.0-rc4-autokern1 #1 Not tainted
[   81.882513] ---------------------------------
[   81.882516] inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
[   81.882519] swapper/5/0 [HC0[0]:SC0[0]:HE1:SE1] takes:
[   81.882522]  (call_function.lock){?.....}, at:
[<c0000000000fdaa0>] .ipi_call_lock+0x20/0x40
[   81.882536] {IN-HARDIRQ-W} state was registered at:
[   81.882538]   [<c0000000000f5a9c>] .__lock_acquire+0x44c/0x9e0
[   81.882543]   [<c0000000000f60f4>] .lock_acquire+0xc4/0x260
[   81.882548]   [<c00000000063f648>] ._raw_spin_lock+0x48/0x70
[   81.882554]
[<c0000000000fede4>] .generic_smp_call_function_interrupt+0x1d4/0x320
[   81.882559]   [<c000000000037020>] .smp_ipi_demux+0x90/0x100
[   81.882565]   [<c00000000004f98c>] .icp_hv_ipi_action+0x5c/0xc0
[   81.882571]   [<c00000000013420c>] .handle_irq_event_percpu
+0xec/0x570
[   81.882577]   [<c000000000138ab4>] .handle_percpu_irq+0x84/0xd0
[   81.882582]   [<c0000000000221b4>] .call_handle_irq+0x1c/0x2c
[   81.882588]   [<c0000000000103fc>] .do_IRQ+0x16c/0x500
[   81.882593]   [<c0000000000038d0>] hardware_interrupt_common
+0x150/0x180
[   81.882598]   [<c000000000010a38>] .arch_local_irq_restore+0x38/0x90
[   81.882603]   [<c000000000017450>] .cpu_idle+0x250/0x2d0
[   81.882607]   [<c000000000651ce0>] .start_secondary+0x378/0x384
[   81.882613]   [<c00000000000936c>] .start_secondary_prolog+0x10/0x14
[   81.882618] irq event stamp: 332475
[   81.882620] hardirqs last  enabled at (332475):
[<c000000000640414>] ._raw_spin_unlock_irqrestore+0x94/0xc0
[   81.882625] hardirqs last disabled at (332474):
[<c00000000063f7c0>] ._raw_spin_lock_irqsave+0x30/0x90
[   81.882631] softirqs last  enabled at (332288):
[<c0000000000873c4>] .irq_enter+0x94/0xd0
[   81.882636] softirqs last disabled at (332287):
[<c0000000000873b4>] .irq_enter+0x84/0xd0
[   81.882640] 
[   81.882641] other info that might help us debug this:
[   81.882644]  Possible unsafe locking scenario:
[   81.882645] 
[   81.882647]        CPU0
[   81.882649]        ----
[   81.882650]   lock(call_function.lock);
[   81.882654]   <Interrupt>
[   81.882656]     lock(call_function.lock);
[   81.882660] 
[   81.882661]  *** DEADLOCK ***
[   81.882662] 
[   81.882664] no locks held by swapper/5/0.
[   81.882666] 
[   81.882667] stack backtrace:
[   81.882669] Call Trace:
[   81.882672] [c0000003c07bf860] [c0000000000146f4] .show_stack
+0x74/0x1c0 (unreliable)
[   81.882678] [c0000003c07bf910] [c0000000000f1304] .print_usage_bug
+0x1e4/0x230
[   81.882683] [c0000003c07bf9d0] [c0000000000f150c] .mark_lock_irq
+0x1bc/0x3c0
[   81.882688] [c0000003c07bfa90] [c0000000000f18a0] .mark_lock
+0x190/0x4b0
[   81.882693] [c0000003c07bfb40] [c0000000000f1d10] .mark_irqflags
+0x150/0x240
[   81.882697] [c0000003c07bfbd0] [c0000000000f5a9c] .__lock_acquire
+0x44c/0x9e0
[   81.882702] [c0000003c07bfce0] [c0000000000f60f4] .lock_acquire
+0xc4/0x260
[   81.882707] [c0000003c07bfdc0] [c00000000063f648] ._raw_spin_lock
+0x48/0x70
[   81.882712] [c0000003c07bfe50] [c0000000000fdaa0] .ipi_call_lock
+0x20/0x40
[   81.882717] [c0000003c07bfed0] [c000000000651aa0] .start_secondary
+0x138/0x384
[   81.882722] [c0000003c07bff90]
[c00000000000936c] .start_secondary_prolog+0x10/0x14


>From the log, ipi_call_lock() is called in start_secondary() with irqs
enabled. The irqs are enabled by smp_ops->setup_cpu(), in following call
chain: 
start_secondary --> smp_ops->setup_cpu --> smp_xics_setup_cpu -->
pseries_notify_cpu_idle_add_cpu --> cpuidle_disable_device -->
cpuidle_remove_state_sysfs -->  cpuidle_free_state_kobj -->
wait_for_completion --> wait_for_common

>From my understanding of the codes, I think it's not necessary to call
pseries_notify_cpu_idle_add_cpu() in the early start_secondary()
function before irqs could be enabled. 

pseries_notify_cpu_idle_add_cpu() actually does
cpuidle_disable_device(), and then cpuidle_enable_device(), which
releases and allocates the resources respectively. ( Also, all the data
are cleared and reinitialized after this cycle). The problem here is:
something like kzalloc(GFP_KERNEL), wait_for_completion() would have
problems running here where irqs are still disabled. 

Actually, cpuidle_enable_device() is called for each possible cpu when
the driver is registered. So I don't think the resources needed to be
released and allocated each time cpu becomes online. Something like
cpuidle_reset_device() would be enough to clear and reinitialize the
data.

However, after some studying of the data to be cleared, I think it's
also reasonable to keep the previous data. For example: 

/sys/devices/system/cpu/cpu#/cpuidle/state#/usage 
        the number of times this idle state has been entered
/sys/devices/system/cpu/cpu#/cpuidle/state#/time
        the amount of time spent in this idle state

So I think we could just remove the function call doing the
disable/enable cycle:

Please correct me if I missed anything. 

Reported-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Li Zhong <zhong@linux.vnet.ibm.com>
Tested-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/powerpc/platforms/pseries/smp.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/smp.c
b/arch/powerpc/platforms/pseries/smp.c
index e16bb8d..71706bc 100644
--- a/arch/powerpc/platforms/pseries/smp.c
+++ b/arch/powerpc/platforms/pseries/smp.c
@@ -147,7 +147,6 @@ static void __devinit smp_xics_setup_cpu(int cpu)
 	set_cpu_current_state(cpu, CPU_STATE_ONLINE);
 	set_default_offline_state(cpu);
 #endif
-	pseries_notify_cpuidle_add_cpu(cpu);
 }
 
 static int __devinit smp_pSeries_kick_cpu(int nr)
-- 
1.7.5.4

