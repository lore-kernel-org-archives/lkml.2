Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab2D1JMI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:12:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44451 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2D1JMF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:12:05 -0400
Date: Sat, 28 Apr 2012 02:11:44 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-e80e7813cd772cf30597024b371e73df9736de8d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, schwidefsky@de.ibm.com, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org, schwidefsky@de.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20120420124557.652574928@linutronix.de>
References: <20120420124557.652574928@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] s390: Use generic idle thread allocation
Git-Commit-ID: e80e7813cd772cf30597024b371e73df9736de8d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:11:50 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e80e7813cd772cf30597024b371e73df9736de8d
Gitweb:     http://git.kernel.org/tip/e80e7813cd772cf30597024b371e73df9736de8d
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:52 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:11 +0200

s390: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
Link: http://lkml.kernel.org/r/20120420124557.652574928@linutronix.de

---
 arch/s390/Kconfig      |    1 +
 arch/s390/kernel/smp.c |   33 ++-------------------------------
 2 files changed, 3 insertions(+), 31 deletions(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index 9015060..15cab3e 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -122,6 +122,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select GENERIC_SMP_IDLE_THREAD
 
 config SCHED_OMIT_FRAME_POINTER
 	def_bool y
diff --git a/arch/s390/kernel/smp.c b/arch/s390/kernel/smp.c
index fc827aa..992b7b9 100644
--- a/arch/s390/kernel/smp.c
+++ b/arch/s390/kernel/smp.c
@@ -85,7 +85,6 @@ enum {
 
 struct pcpu {
 	struct cpu cpu;
-	struct task_struct *idle;	/* idle process for the cpu */
 	struct _lowcore *lowcore;	/* lowcore page(s) for the cpu */
 	unsigned long async_stack;	/* async stack for the cpu */
 	unsigned long panic_stack;	/* panic stack for the cpu */
@@ -721,26 +720,9 @@ static void __cpuinit smp_start_secondary(void *cpuvoid)
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
 
@@ -750,22 +732,12 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
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
