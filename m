Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab2D1JOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:14:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44492 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2D1JOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:14:36 -0400
Date: Sat, 28 Apr 2012 02:14:14 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-ea0588cb6b201c38b0120c4ad38bc548d5dde29a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org, lethal@linux-sh.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, lethal@linux-sh.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <20120420124557.855203626@linutronix.de>
References: <20120420124557.855203626@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] sh: Use generic idle thread allocation
Git-Commit-ID: ea0588cb6b201c38b0120c4ad38bc548d5dde29a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:14:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ea0588cb6b201c38b0120c4ad38bc548d5dde29a
Gitweb:     http://git.kernel.org/tip/ea0588cb6b201c38b0120c4ad38bc548d5dde29a
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:54 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:12 +0200

sh: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Link: http://lkml.kernel.org/r/20120420124557.855203626@linutronix.de
---
 arch/sh/Kconfig                 |    1 +
 arch/sh/include/asm/processor.h |    4 ----
 arch/sh/kernel/smp.c            |   14 +-------------
 3 files changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/sh/Kconfig b/arch/sh/Kconfig
index ff9e033..244cfd0 100644
--- a/arch/sh/Kconfig
+++ b/arch/sh/Kconfig
@@ -28,6 +28,7 @@ config SUPERH
 	select RTC_LIB
 	select GENERIC_ATOMIC64
 	select GENERIC_IRQ_SHOW
+	select GENERIC_SMP_IDLE_THREAD
 	help
 	  The SuperH is a RISC processor targeted for use in embedded systems
 	  and consumer electronics; it was also used in the Sega Dreamcast
diff --git a/arch/sh/include/asm/processor.h b/arch/sh/include/asm/processor.h
index a229c39..6d87912 100644
--- a/arch/sh/include/asm/processor.h
+++ b/arch/sh/include/asm/processor.h
@@ -85,10 +85,6 @@ struct sh_cpuinfo {
 	struct tlb_info itlb;
 	struct tlb_info dtlb;
 
-#ifdef CONFIG_SMP
-	struct task_struct *idle;
-#endif
-
 	unsigned int phys_bits;
 	unsigned long flags;
 } __attribute__ ((aligned(L1_CACHE_BYTES)));
diff --git a/arch/sh/kernel/smp.c b/arch/sh/kernel/smp.c
index ebb76e2..b86e9ca 100644
--- a/arch/sh/kernel/smp.c
+++ b/arch/sh/kernel/smp.c
@@ -220,22 +220,10 @@ extern struct {
 	void *thread_info;
 } stack_start;
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tsk)
 {
-	struct task_struct *tsk;
 	unsigned long timeout;
 
-	tsk = cpu_data[cpu].idle;
-	if (!tsk) {
-		tsk = fork_idle(cpu);
-		if (IS_ERR(tsk)) {
-			pr_err("Failed forking idle task for cpu %d\n", cpu);
-			return PTR_ERR(tsk);
-		}
-
-		cpu_data[cpu].idle = tsk;
-	}
-
 	per_cpu(cpu_state, cpu) = CPU_UP_PREPARE;
 
 	/* Fill in data in head.S for secondary cpus */
