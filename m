Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab2D1JP1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:15:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44515 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259Ab2D1JPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:15:24 -0400
Date: Sat, 28 Apr 2012 02:15:06 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-2ec9415c71a1ddad969602e690a9c848b81256b3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        mattst88@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        mattst88@gmail.com, tglx@linutronix.de
In-Reply-To: <20120420124557.914631081@linutronix.de>
References: <20120420124557.914631081@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] alpha: Use generic idle thread allocation
Git-Commit-ID: 2ec9415c71a1ddad969602e690a9c848b81256b3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:15:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2ec9415c71a1ddad969602e690a9c848b81256b3
Gitweb:     http://git.kernel.org/tip/2ec9415c71a1ddad969602e690a9c848b81256b3
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:55 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:12 +0200

alpha: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Matt Turner <mattst88@gmail.com>
Link: http://lkml.kernel.org/r/20120420124557.914631081@linutronix.de
---
 arch/alpha/Kconfig      |    1 +
 arch/alpha/kernel/smp.c |   18 ++----------------
 2 files changed, 3 insertions(+), 16 deletions(-)

diff --git a/arch/alpha/Kconfig b/arch/alpha/Kconfig
index 56a4df9..991b8bb 100644
--- a/arch/alpha/Kconfig
+++ b/arch/alpha/Kconfig
@@ -15,6 +15,7 @@ config ALPHA
 	select GENERIC_IRQ_SHOW
 	select ARCH_WANT_OPTIONAL_GPIOLIB
 	select ARCH_HAVE_NMI_SAFE_CMPXCHG
+	select GENERIC_SMP_IDLE_THREAD
 	help
 	  The Alpha is a 64-bit general-purpose processor designed and
 	  marketed by the Digital Equipment Corporation of blessed memory,
diff --git a/arch/alpha/kernel/smp.c b/arch/alpha/kernel/smp.c
index 68d3947..35ddc02 100644
--- a/arch/alpha/kernel/smp.c
+++ b/arch/alpha/kernel/smp.c
@@ -357,24 +357,10 @@ secondary_cpu_start(int cpuid, struct task_struct *idle)
  * Bring one cpu online.
  */
 static int __cpuinit
-smp_boot_one_cpu(int cpuid)
+smp_boot_one_cpu(int cpuid, struct task_struct *idle)
 {
-	struct task_struct *idle;
 	unsigned long timeout;
 
-	/* Cook up an idler for this guy.  Note that the address we
-	   give to kernel_thread is irrelevant -- it's going to start
-	   where HWRPB.CPU_restart says to start.  But this gets all
-	   the other task-y sort of data structures set up like we
-	   wish.  We can't use kernel_thread since we must avoid
-	   rescheduling the child.  */
-	idle = fork_idle(cpuid);
-	if (IS_ERR(idle))
-		panic("failed fork for CPU %d", cpuid);
-
-	DBGS(("smp_boot_one_cpu: CPU %d state 0x%lx flags 0x%lx\n",
-	      cpuid, idle->state, idle->flags));
-
 	/* Signal the secondary to wait a moment.  */
 	smp_secondary_alive = -1;
 
@@ -489,7 +475,7 @@ smp_prepare_boot_cpu(void)
 int __cpuinit
 __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	smp_boot_one_cpu(cpu);
+	smp_boot_one_cpu(cpu, tidle);
 
 	return cpu_online(cpu) ? 0 : -ENOSYS;
 }
