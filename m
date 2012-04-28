Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab2D1JK2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:10:28 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44428 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2D1JKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:10:23 -0400
Date: Sat, 28 Apr 2012 02:10:04 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-360014a36170464ebd9935514f0e0e3d558b0e56@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        ralf@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        ralf@linux-mips.org, tglx@linutronix.de
In-Reply-To: <20120420124557.512158271@linutronix.de>
References: <20120420124557.512158271@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] mips: Use generic idle thread allocation
Git-Commit-ID: 360014a36170464ebd9935514f0e0e3d558b0e56
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:10:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  360014a36170464ebd9935514f0e0e3d558b0e56
Gitweb:     http://git.kernel.org/tip/360014a36170464ebd9935514f0e0e3d558b0e56
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:51 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:11 +0200

mips: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Ralf Baechle <ralf@linux-mips.org>
Link: http://lkml.kernel.org/r/20120420124557.512158271@linutronix.de

---
 arch/mips/Kconfig      |    1 +
 arch/mips/kernel/smp.c |   54 +-----------------------------------------------
 2 files changed, 2 insertions(+), 53 deletions(-)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index ce30e2f..186fc8c 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -29,6 +29,7 @@ config MIPS
 	select HAVE_MEMBLOCK
 	select HAVE_MEMBLOCK_NODE_MAP
 	select ARCH_DISCARD_MEMBLOCK
+	select GENERIC_SMP_IDLE_THREAD
 
 menu "Machine selection"
 
diff --git a/arch/mips/kernel/smp.c b/arch/mips/kernel/smp.c
index 41079b2..71a95f5 100644
--- a/arch/mips/kernel/smp.c
+++ b/arch/mips/kernel/smp.c
@@ -186,61 +186,9 @@ void __devinit smp_prepare_boot_cpu(void)
 	cpu_set(0, cpu_callin_map);
 }
 
-/*
- * Called once for each "cpu_possible(cpu)".  Needs to spin up the cpu
- * and keep control until "cpu_online(cpu)" is set.  Note: cpu is
- * physical, not logical.
- */
-static struct task_struct *cpu_idle_thread[NR_CPUS];
-
-struct create_idle {
-	struct work_struct work;
-	struct task_struct *idle;
-	struct completion done;
-	int cpu;
-};
-
-static void __cpuinit do_fork_idle(struct work_struct *work)
-{
-	struct create_idle *c_idle =
-		container_of(work, struct create_idle, work);
-
-	c_idle->idle = fork_idle(c_idle->cpu);
-	complete(&c_idle->done);
-}
-
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	struct task_struct *idle;
-
-	/*
-	 * Processor goes to start_secondary(), sets online flag
-	 * The following code is purely to make sure
-	 * Linux can schedule processes on this slave.
-	 */
-	if (!cpu_idle_thread[cpu]) {
-		/*
-		 * Schedule work item to avoid forking user task
-		 * Ported from arch/x86/kernel/smpboot.c
-		 */
-		struct create_idle c_idle = {
-			.cpu    = cpu,
-			.done   = COMPLETION_INITIALIZER_ONSTACK(c_idle.done),
-		};
-
-		INIT_WORK_ONSTACK(&c_idle.work, do_fork_idle);
-		schedule_work(&c_idle.work);
-		wait_for_completion(&c_idle.done);
-		idle = cpu_idle_thread[cpu] = c_idle.idle;
-
-		if (IS_ERR(idle))
-			panic(KERN_ERR "Fork failed for CPU %d", cpu);
-	} else {
-		idle = cpu_idle_thread[cpu];
-		init_idle(idle, cpu);
-	}
-
-	mp_ops->boot_secondary(cpu, idle);
+	mp_ops->boot_secondary(cpu, tidle);
 
 	/*
 	 * Trust is futile.  We should really have timeouts ...
