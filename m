Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2D1JM5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:12:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44464 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751833Ab2D1JMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:12:54 -0400
Date: Sat, 28 Apr 2012 02:12:34 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-a4cfc31da34eacafd9f6b16e149448bf0ef6d0b2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jesper.nilsson@axis.com, rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jesper.nilsson@axis.com, rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        tglx@linutronix.de
In-Reply-To: <20120420124557.789657793@linutronix.de>
References: <20120420124557.789657793@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] cris: Use generic idle thread allocation
Git-Commit-ID: a4cfc31da34eacafd9f6b16e149448bf0ef6d0b2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:12:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a4cfc31da34eacafd9f6b16e149448bf0ef6d0b2
Gitweb:     http://git.kernel.org/tip/a4cfc31da34eacafd9f6b16e149448bf0ef6d0b2
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:53 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:11 +0200

cris: Use generic idle thread allocation

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>
Link: http://lkml.kernel.org/r/20120420124557.789657793@linutronix.de

---
 arch/cris/Kconfig               |    1 +
 arch/cris/arch-v32/kernel/smp.c |   12 ++----------
 2 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/arch/cris/Kconfig b/arch/cris/Kconfig
index b3abfb0..2995035 100644
--- a/arch/cris/Kconfig
+++ b/arch/cris/Kconfig
@@ -49,6 +49,7 @@ config CRIS
 	select HAVE_GENERIC_HARDIRQS
 	select GENERIC_IRQ_SHOW
 	select GENERIC_IOMAP
+	select GENERIC_SMP_IDLE_THREAD if ETRAX_ARCH_V32
 
 config HZ
 	int
diff --git a/arch/cris/arch-v32/kernel/smp.c b/arch/cris/arch-v32/kernel/smp.c
index 125ee2d..ebe2cb3 100644
--- a/arch/cris/arch-v32/kernel/smp.c
+++ b/arch/cris/arch-v32/kernel/smp.c
@@ -108,17 +108,12 @@ void __init smp_cpus_done(unsigned int max_cpus)
 
 /* Bring one cpu online.*/
 static int __init
-smp_boot_one_cpu(int cpuid)
+smp_boot_one_cpu(int cpuid, struct task_struct idle)
 {
 	unsigned timeout;
-	struct task_struct *idle;
 	cpumask_t cpu_mask;
 
 	cpumask_clear(&cpu_mask);
-	idle = fork_idle(cpuid);
-	if (IS_ERR(idle))
-		panic("SMP: fork failed for CPU:%d", cpuid);
-
 	task_thread_info(idle)->cpu = cpuid;
 
 	/* Information to the CPU that is about to boot */
@@ -142,9 +137,6 @@ smp_boot_one_cpu(int cpuid)
 		barrier();
 	}
 
-	put_task_struct(idle);
-	idle = NULL;
-
 	printk(KERN_CRIT "SMP: CPU:%d is stuck.\n", cpuid);
 	return -1;
 }
@@ -209,7 +201,7 @@ unsigned long cache_decay_ticks = 1;
 
 int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	smp_boot_one_cpu(cpu);
+	smp_boot_one_cpu(cpu, tidle);
 	return cpu_online(cpu) ? 0 : -ENOSYS;
 }
 
