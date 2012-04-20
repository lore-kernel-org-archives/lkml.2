Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab2DTNGB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:06:01 -0400
Received: from www.linutronix.de ([62.245.132.108]:44749 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab2DTNFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:05:54 -0400
Message-Id: <20120420124557.176604405@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:47 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, x86@kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [patch 05/18] x86: Add task_struct argument to smp_ops.cpu_up
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline; filename=x86-expand-smp-ops-cpu-up.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch to use the generic idle thread allocation.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
---
 arch/x86/include/asm/smp.h |    6 +++---
 arch/x86/kernel/smpboot.c  |    2 +-
 arch/x86/xen/smp.c         |    6 +++---
 3 files changed, 7 insertions(+), 7 deletions(-)

Index: linux-2.6/arch/x86/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smp.h
+++ linux-2.6/arch/x86/include/asm/smp.h
@@ -72,7 +72,7 @@ struct smp_ops {
 	void (*stop_other_cpus)(int wait);
 	void (*smp_send_reschedule)(int cpu);
 
-	int (*cpu_up)(unsigned cpu);
+	int (*cpu_up)(unsigned cpu, struct task_struct *tidle);
 	int (*cpu_disable)(void);
 	void (*cpu_die)(unsigned int cpu);
 	void (*play_dead)(void);
@@ -117,7 +117,7 @@ static inline void smp_cpus_done(unsigne
 
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
Index: linux-2.6/arch/x86/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/smpboot.c
+++ linux-2.6/arch/x86/kernel/smpboot.c
@@ -818,7 +818,7 @@ do_rest:
 	return boot_error;
 }
 
-int __cpuinit native_cpu_up(unsigned int cpu)
+int __cpuinit native_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int apicid = apic->cpu_present_to_apicid(cpu);
 	unsigned long flags;
Index: linux-2.6/arch/x86/xen/smp.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/smp.c
+++ linux-2.6/arch/x86/xen/smp.c
@@ -331,7 +331,7 @@ cpu_initialize_context(unsigned int cpu,
 	return 0;
 }
 
-static int __cpuinit xen_cpu_up(unsigned int cpu)
+static int __cpuinit xen_cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *idle = idle_task(cpu);
 	int rc;
@@ -547,10 +547,10 @@ static void __init xen_hvm_smp_prepare_c
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


