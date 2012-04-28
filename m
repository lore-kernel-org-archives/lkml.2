Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2D1JGQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 05:06:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44348 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753277Ab2D1JGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 05:06:14 -0400
Date: Sat, 28 Apr 2012 02:05:53 -0700
From: tip-bot for Thomas Gleixner <tglx@linutronix.de>
Message-ID: <tip-5cdaf1834f43b0edc4a3aa683aa4ec98f6bfe8a7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        jeremy@goop.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, peterz@infradead.org,
        srivatsa.bhat@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com,
        jeremy@goop.org, tglx@linutronix.de
In-Reply-To: <20120420124557.176604405@linutronix.de>
References: <20120420124557.176604405@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:smp/hotplug] x86: Add task_struct argument to smp_ops.cpu_up
Git-Commit-ID: 5cdaf1834f43b0edc4a3aa683aa4ec98f6bfe8a7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 28 Apr 2012 02:05:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5cdaf1834f43b0edc4a3aa683aa4ec98f6bfe8a7
Gitweb:     http://git.kernel.org/tip/5cdaf1834f43b0edc4a3aa683aa4ec98f6bfe8a7
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Fri, 20 Apr 2012 13:05:47 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 26 Apr 2012 12:06:10 +0200

x86: Add task_struct argument to smp_ops.cpu_up

Preparatory patch to use the generic idle thread allocation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: x86@kernel.org
Link: http://lkml.kernel.org/r/20120420124557.176604405@linutronix.de
---
 arch/x86/include/asm/smp.h |    6 +++---
 arch/x86/kernel/smpboot.c  |    2 +-
 arch/x86/xen/smp.c         |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/smp.h b/arch/x86/include/asm/smp.h
index 4eb3a74..f3ed338 100644
--- a/arch/x86/include/asm/smp.h
+++ b/arch/x86/include/asm/smp.h
@@ -72,7 +72,7 @@ struct smp_ops {
 	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
 
-	int (*cpu_up)(unsigned cpu);
+	int (*cpu_up)(unsigned cpu, struct task_struct *tidle);
 	int (*cpu_disable)(void);
 	void (*cpu_die)(unsigned int cpu);
 	void (*play_dead)(void);
@@ -117,7 +117,7 @@ static inline void smp_cpus_done(unsigned int max_cpus)
 
 static inline int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
-	return smp_ops.cpu_up(cpu);
+	return smp_ops.cpu_up(cpu, tidle);
 }
 
 static inline int __cpu_disable(void)
@@ -154,7 +154,7 @@ void cpu_disable_common(void);
 void native_smp_prepare_boot_cpu(void);
 void native_smp_prepare_cpus(unsigned int max_cpus);
 void native_smp_cpus_done(unsigned int max_cpus);
-int native_cpu_up(unsigned int cpunum);
+int native_cpu_up(unsigned int cpunum, struct task_struct *tidle);
 int native_cpu_disable(void);
 void native_cpu_die(unsigned int cpu);
 void native_play_dead(void);
diff --git a/arch/x86/kernel/smpboot.c b/arch/x86/kernel/smpboot.c
index 6e1e406..def235b 100644
--- a/arch/x86/kernel/smpboot.c
+++ b/arch/x86/kernel/smpboot.c
@@ -818,7 +818,7 @@ do_rest:
 	return boot_error;
 }
 
-int __cpuinit native_cpu_up(unsigned int cpu)
+int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int apicid = apic->cpu_present_to_apicid(cpu);
 	unsigned long flags;
diff --git a/arch/x86/xen/smp.c b/arch/x86/xen/smp.c
index 5fac691..64d3bbc 100644
--- a/arch/x86/xen/smp.c
+++ b/arch/x86/xen/smp.c
@@ -331,7 +331,7 @@ cpu_initialize_context(unsigned int cpu, struct task_struct *idle)
 	return 0;
 }
 
-static int __cpuinit xen_cpu_up(unsigned int cpu)
+static int __cpuinit xen_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
@@ -547,10 +547,10 @@ static void __init xen_hvm_smp_prepare_cpus(unsigned int max_cpus)
 	xen_init_lock_cpu(0);
 }
 
-static int __cpuinit xen_hvm_cpu_up(unsigned int cpu)
+static int __cpuinit xen_hvm_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int rc;
-	rc = native_cpu_up(cpu);
+	rc = native_cpu_up(cpu, tidle);
 	WARN_ON (xen_smp_intr_init(cpu));
 	return rc;
 }
