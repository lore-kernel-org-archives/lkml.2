Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab2D1JNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:13:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44479 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2D1JNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:13:48 -0400
Date: Sat, 28 Apr 2012 02:13:24 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-6bba2682c62e432eaf7b82f8ca182e8c73256e74@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        vapier@gentoo.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        vapier@gentoo.org, tglx@linutronix.de
In-Reply-To: <20120420124557.717064871@linutronix.de>
References: <20120420124557.717064871@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] blackfin: Use generic idle thread allocation
Git-Commit-ID: 6bba2682c62e432eaf7b82f8ca182e8c73256e74
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:13:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6bba2682c62e432eaf7b82f8ca182e8c73256e74
Gitweb:     http://git.kernel.org/tip/6bba2682c62e432eaf7b82f8ca182e8c73256e74
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:12 +0200

blackfin: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Mike Frysinger <vapier@gentoo.org>
Link: http://lkml.kernel.org/r/20120420124557.717064871@linutronix.de

---
 arch/blackfin/Kconfig           |    1 +
 arch/blackfin/mach-common/smp.c |   19 +------------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 373a690..779b9c8 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -37,6 +37,7 @@ config BLACKFIN
 	select GENERIC_IRQ_PROBE
 	select IRQ_PER_CPU if SMP
 	select HAVE_NMI_WATCHDOG if NMI_WATCHDOG
+	select GENERIC_SMP_IDLE_THREAD
 
 config GENERIC_CSUM
 	def_bool y
diff --git a/arch/blackfin/mach-common/smp.c b/arch/blackfin/mach-common/smp.c
index d0cddd9..00bbe67 100644
--- a/arch/blackfin/mach-common/smp.c
+++ b/arch/blackfin/mach-common/smp.c
@@ -340,27 +340,10 @@ void smp_send_stop(void)
 	return;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 {
 	int ret;
-	struct blackfin_cpudata *ci = &per_cpu(cpu_data, cpu);
-	struct task_struct *idle = ci->idle;
 
-	if (idle) {
-		free_task(idle);
-		idle = NULL;
-	}
-
-	if (!idle) {
-		idle = fork_idle(cpu);
-		if (IS_ERR(idle)) {
-			printk(KERN_ERR "CPU%u: fork() failed\n", cpu);
-			return PTR_ERR(idle);
-		}
-		ci->idle = idle;
-	} else {
-		init_idle(idle, cpu);
-	}
 	secondary_stack = task_stack_page(idle) + THREAD_SIZE;
 
 	ret = platform_boot_secondary(cpu, idle);
