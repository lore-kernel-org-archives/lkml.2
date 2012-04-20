Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2DTNJo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:09:44 -0400
Received: from www.linutronix.de ([62.245.132.108]:44768 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.652574928@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:52 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 12/18] s390: Use generic idle thread allocation
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=s390-use-generic-idle-thread-allocation.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 arch/s390/Kconfig      |    1 +
 arch/s390/kernel/smp.c |   33 ++-------------------------------
 2 files changed, 3 insertions(+), 31 deletions(-)

Index: linux-2.6/arch/s390/Kconfig
===================================================================
--- linux-2.6.orig/arch/s390/Kconfig
+++ linux-2.6/arch/s390/Kconfig
@@ -122,6 +122,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select GENERIC_SMP_IDLE_THREAD
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
Index: linux-2.6/arch/s390/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/smp.c
+++ linux-2.6/arch/s390/kernel/smp.c
@@ -85,7 +85,6 @@ enum {
 
 struct pcpu {
 	struct cpu cpu;
-	struct task_struct *idle;	/* idle process for the cpu */
 	struct _lowcore *lowcore;	/* lowcore page(s) for the cpu */
 	unsigned long async_stack;	/* async stack for the cpu */
 	unsigned long panic_stack;	/* panic stack for the cpu */
@@ -721,26 +720,9 @@ static void __cpuinit smp_start_secondar
 	cpu_idle();
 }
 
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit smp_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle;
-
-	c_idle = container_of(work, struct create_idle, work);
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 /* Upping and downing of CPUs */
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	struct create_idle c_idle;
 	struct pcpu *pcpu;
 	int rc;
 
@@ -750,22 +732,12 @@ int __cpuinit __cpu_up(unsigned int cpu,
 	if (pcpu_sigp_retry(pcpu, sigp_initial_cpu_reset, 0) !=
 	    sigp_order_code_accepted)
 		return -EIO;
-	if (!pcpu->idle) {
-		c_idle.done = COMPLETION_INITIALIZER_ONSTACK(c_idle.done);
-		INIT_WORK_ONSTACK(&c_idle.work, smp_fork_idle);
-		c_idle.cpu = cpu;
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-		if (IS_ERR(c_idle.idle))
-			return PTR_ERR(c_idle.idle);
-		pcpu->idle = c_idle.idle;
-	}
-	init_idle(pcpu->idle, cpu);
+
 	rc = pcpu_alloc_lowcore(pcpu, cpu);
 	if (rc)
 		return rc;
 	pcpu_prepare_secondary(pcpu, cpu);
-	pcpu_attach_task(pcpu, pcpu->idle);
+	pcpu_attach_task(pcpu, tidle);
 	pcpu_start_fn(pcpu, smp_start_secondary, NULL);
 	while (!cpu_online(cpu))
 		cpu_relax();
@@ -852,7 +824,6 @@ void __init smp_prepare_boot_cpu(void)
 	struct pcpu *pcpu = pcpu_devices;
 
 	boot_cpu_address = stap();
-	pcpu->idle = current;
 	pcpu->state = CPU_STATE_CONFIGURED;
 	pcpu->address = boot_cpu_address;
 	pcpu->lowcore = (struct _lowcore *)(unsigned long) store_prefix();


