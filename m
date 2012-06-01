Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606Ab2FAJ4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 05:56:36 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:42568 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932410Ab2FAJ4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 05:56:35 -0400
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 12/27] tile, smpboot: Use generic SMP booting infrastructure
To: tglx@linutronix.de, peterz@infradead.org, paulmck@linux.vnet.ibm.com
Cc: rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        srivatsa.bhat@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        Chris Metcalf <cmetcalf@tilera.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Yong Zhang <yong.zhang0@gmail.com>
Date: Fri, 01 Jun 2012 14:42:56 +0530
Message-ID: <20120601091248.31979.59256.stgit@srivatsabhat.in.ibm.com>
In-Reply-To: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
x-cbid: 12060100-3568-0000-0000-000001E9143C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert tile to use the generic framework to boot secondary CPUs.

Notes:
1. Don't enable interrupts in start_secondary().
2. Remove the unnecessary calls to local_irq_enable() in __cpu_up().
3. cpu_idle() was being called after doing a preempt_enable() instead
of a preempt_disable()! Fix it.

Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Yong Zhang <yong.zhang0@gmail.com>
Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
---

 arch/tile/kernel/smpboot.c |   22 ++++++++--------------
 1 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/arch/tile/kernel/smpboot.c b/arch/tile/kernel/smpboot.c
index 24a9c06..8558824 100644
--- a/arch/tile/kernel/smpboot.c
+++ b/arch/tile/kernel/smpboot.c
@@ -145,8 +145,6 @@ static void __cpuinit start_secondary(void)
 	/* Set our thread pointer appropriately. */
 	set_my_cpu_offset(__per_cpu_offset[cpuid]);
 
-	preempt_disable();
-
 	/*
 	 * In large machines even this will slow us down, since we
 	 * will be contending for for the printk spinlock.
@@ -165,7 +163,6 @@ static void __cpuinit start_secondary(void)
 
 	/* Allow hypervisor messages to be received */
 	init_messaging();
-	local_irq_enable();
 
 	/* Indicate that we're ready to come up. */
 	/* Must not do this before we're ready to receive messages */
@@ -183,6 +180,11 @@ static void __cpuinit start_secondary(void)
  */
 void __cpuinit online_secondary(void)
 {
+	smpboot_start_secondary(NULL);
+}
+
+void __cpuinit __cpu_pre_starting(void *unused)
+{
 	/*
 	 * low-memory mappings have been cleared, flush them from
 	 * the local TLBs too.
@@ -193,21 +195,15 @@ void __cpuinit online_secondary(void)
 
 	/* This must be done before setting cpu_online_mask */
 	wmb();
+}
 
-	notify_cpu_starting(smp_processor_id());
-
-	set_cpu_online(smp_processor_id(), 1);
-	__get_cpu_var(cpu_state) = CPU_ONLINE;
-
+void __cpuinit __cpu_post_online(void *unused)
+{
 	/* Set up tile-specific state for this cpu. */
 	setup_cpu(0);
 
 	/* Set up tile-timer clock-event device on this cpu */
 	setup_tile_timer();
-
-	preempt_enable();
-
-	cpu_idle();
 }
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
@@ -217,13 +213,11 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 	for (; !cpumask_test_cpu(cpu, &cpu_started); timeout++) {
 		if (timeout >= 50000) {
 			pr_info("skipping unresponsive cpu%d\n", cpu);
-			local_irq_enable();
 			return -EIO;
 		}
 		udelay(100);
 	}
 
-	local_irq_enable();
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 	/* Unleash the CPU! */

