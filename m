Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab2DTNG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 09:06:27 -0400
Received: from www.linutronix.de ([62.245.132.108]:44824 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753010Ab2DTNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 09:06:04 -0400
Message-Id: <20120420124556.964170564@linutronix.de>
User-Agent: quilt/0.48-1
Date: Fri, 20 Apr 2012 13:05:42 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Matt Turner <mattst88@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mike Frysinger <vapier@gentoo.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Richard Kuo <rkuo@codeaurora.org>, Tony Luck <tony.luck@intel.com>,
        Hirokazu Takata <takata@linux-m32r.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        David Howells <dhowells@redhat.com>,
        "James E.J. Bottomley" <jejb@parisc-linux.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Richard Weinberger <richard@nod.at>, x86@kernel.org
Subject: [patch 02/18] smp: Add task_struct argument to __cpu_up()
References: <20120420122120.097464672@linutronix.de>
Content-Disposition: inline;
 filename=smp-add-task-struct-argument-to-cpu-up.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Preparatory patch to make the idle thread allocation for secondary
cpus generic.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Matt Turner <mattst88@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: Richard Kuo <rkuo@codeaurora.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Hirokazu Takata <takata@linux-m32r.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: David Howells <dhowells@redhat.com>
Cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Chris Metcalf <cmetcalf@tilera.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: x86@kernel.org

---
 arch/alpha/kernel/smp.c         |    2 +-
 arch/arm/kernel/smp.c           |    2 +-
 arch/blackfin/mach-common/smp.c |    2 +-
 arch/cris/arch-v32/kernel/smp.c |    2 +-
 arch/hexagon/kernel/smp.c       |    2 +-
 arch/ia64/kernel/smpboot.c      |    2 +-
 arch/m32r/kernel/smpboot.c      |    2 +-
 arch/mips/kernel/smp.c          |    2 +-
 arch/mn10300/kernel/smp.c       |    2 +-
 arch/parisc/kernel/smp.c        |    2 +-
 arch/powerpc/kernel/smp.c       |    2 +-
 arch/s390/include/asm/smp.h     |    2 +-
 arch/s390/kernel/smp.c          |    2 +-
 arch/sh/kernel/smp.c            |    2 +-
 arch/sparc/kernel/smp_32.c      |    2 +-
 arch/sparc/kernel/smp_64.c      |    2 +-
 arch/tile/kernel/smpboot.c      |    2 +-
 arch/um/kernel/smp.c            |    2 +-
 arch/x86/include/asm/smp.h      |    4 +++-
 include/linux/smp.h             |    2 +-
 kernel/cpu.c                    |    2 +-
 21 files changed, 23 insertions(+), 21 deletions(-)

Index: linux-2.6/arch/alpha/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/smp.c
+++ linux-2.6/arch/alpha/kernel/smp.c
@@ -487,7 +487,7 @@ smp_prepare_boot_cpu(void)
 }
 
 int __cpuinit
-__cpu_up(unsigned int cpu)
+__cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	smp_boot_one_cpu(cpu);
 
Index: linux-2.6/arch/arm/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/smp.c
+++ linux-2.6/arch/arm/kernel/smp.c
@@ -60,7 +60,7 @@ enum ipi_msg_type {
 
 static DECLARE_COMPLETION(cpu_running);
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct cpuinfo_arm *ci = &per_cpu(cpu_data, cpu);
 	struct task_struct *idle = ci->idle;
Index: linux-2.6/arch/blackfin/mach-common/smp.c
===================================================================
--- linux-2.6.orig/arch/blackfin/mach-common/smp.c
+++ linux-2.6/arch/blackfin/mach-common/smp.c
@@ -340,7 +340,7 @@ void smp_send_stop(void)
 	return;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 	struct blackfin_cpudata *ci = &per_cpu(cpu_data, cpu);
Index: linux-2.6/arch/cris/arch-v32/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/cris/arch-v32/kernel/smp.c
+++ linux-2.6/arch/cris/arch-v32/kernel/smp.c
@@ -207,7 +207,7 @@ int setup_profiling_timer(unsigned int m
  */
 unsigned long cache_decay_ticks = 1;
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	smp_boot_one_cpu(cpu);
 	return cpu_online(cpu) ? 0 : -ENOSYS;
Index: linux-2.6/arch/hexagon/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/hexagon/kernel/smp.c
+++ linux-2.6/arch/hexagon/kernel/smp.c
@@ -190,7 +190,7 @@ void __cpuinit start_secondary(void)
  * maintains control until "cpu_online(cpu)" is set.
  */
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *idle;
 	struct thread_info *thread;
Index: linux-2.6/arch/ia64/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/smpboot.c
+++ linux-2.6/arch/ia64/kernel/smpboot.c
@@ -793,7 +793,7 @@ set_cpu_sibling_map(int cpu)
 }
 
 int __cpuinit
-__cpu_up (unsigned int cpu)
+__cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret;
 	int sapicid;
Index: linux-2.6/arch/m32r/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/m32r/kernel/smpboot.c
+++ linux-2.6/arch/m32r/kernel/smpboot.c
@@ -343,7 +343,7 @@ static void __init do_boot_cpu(int phys_
 	}
 }
 
-int __cpuinit __cpu_up(unsigned int cpu_id)
+int __cpuinit __cpu_up(unsigned int cpu_id, struct task_struct *tidle)
 {
 	int timeout;
 
Index: linux-2.6/arch/mips/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/smp.c
+++ linux-2.6/arch/mips/kernel/smp.c
@@ -209,7 +209,7 @@ static void __cpuinit do_fork_idle(struc
 	complete(&c_idle->done);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *idle;
 
Index: linux-2.6/arch/mn10300/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/mn10300/kernel/smp.c
+++ linux-2.6/arch/mn10300/kernel/smp.c
@@ -921,7 +921,7 @@ void initialize_secondary(void)
  * __cpu_up - Set smp_commenced_mask for the nominated CPU
  * @cpu: The target CPU.
  */
-int __devinit __cpu_up(unsigned int cpu)
+int __devinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int timeout;
 
Index: linux-2.6/arch/parisc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/parisc/kernel/smp.c
+++ linux-2.6/arch/parisc/kernel/smp.c
@@ -449,7 +449,7 @@ void smp_cpus_done(unsigned int cpu_max)
 }
 
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	if (cpu != 0 && cpu < parisc_max_cpus)
 		smp_boot_one_cpu(cpu);
Index: linux-2.6/arch/powerpc/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/smp.c
+++ linux-2.6/arch/powerpc/kernel/smp.c
@@ -482,7 +482,7 @@ static int __cpuinit create_idle(unsigne
 	return 0;
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int rc, c;
 
Index: linux-2.6/arch/s390/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/s390/include/asm/smp.h
+++ linux-2.6/arch/s390/include/asm/smp.h
@@ -16,7 +16,7 @@
 extern struct mutex smp_cpu_state_mutex;
 extern struct save_area *zfcpdump_save_areas[NR_CPUS + 1];
 
-extern int __cpu_up(unsigned int cpu);
+extern int __cpu_up(unsigned int cpu, struct task_struct *tidle);
 
 extern void arch_send_call_function_single_ipi(int cpu);
 extern void arch_send_call_function_ipi_mask(const struct cpumask *mask);
Index: linux-2.6/arch/s390/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/s390/kernel/smp.c
+++ linux-2.6/arch/s390/kernel/smp.c
@@ -738,7 +738,7 @@ static void __cpuinit smp_fork_idle(stru
 }
 
 /* Upping and downing of CPUs */
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct create_idle c_idle;
 	struct pcpu *pcpu;
Index: linux-2.6/arch/sh/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/smp.c
+++ linux-2.6/arch/sh/kernel/smp.c
@@ -220,7 +220,7 @@ extern struct {
 	void *thread_info;
 } stack_start;
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	struct task_struct *tsk;
 	unsigned long timeout;
Index: linux-2.6/arch/sparc/kernel/smp_32.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/smp_32.c
+++ linux-2.6/arch/sparc/kernel/smp_32.c
@@ -411,7 +411,7 @@ void __init smp_prepare_boot_cpu(void)
 	set_cpu_possible(cpuid, true);
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	extern int __cpuinit smp4m_boot_one_cpu(int);
 	extern int __cpuinit smp4d_boot_one_cpu(int);
Index: linux-2.6/arch/sparc/kernel/smp_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/smp_64.c
+++ linux-2.6/arch/sparc/kernel/smp_64.c
@@ -1227,7 +1227,7 @@ void __devinit smp_fill_in_sib_core_maps
 	}
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	int ret = smp_boot_one_cpu(cpu);
 
Index: linux-2.6/arch/tile/kernel/smpboot.c
===================================================================
--- linux-2.6.orig/arch/tile/kernel/smpboot.c
+++ linux-2.6/arch/tile/kernel/smpboot.c
@@ -222,7 +222,7 @@ void __cpuinit online_secondary(void)
 	cpu_idle();
 }
 
-int __cpuinit __cpu_up(unsigned int cpu)
+int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	/* Wait 5s total for all CPUs for them to come online */
 	static int timeout;
Index: linux-2.6/arch/um/kernel/smp.c
===================================================================
--- linux-2.6.orig/arch/um/kernel/smp.c
+++ linux-2.6/arch/um/kernel/smp.c
@@ -140,7 +140,7 @@ void smp_prepare_boot_cpu(void)
 	set_cpu_online(smp_processor_id(), true);
 }
 
-int __cpu_up(unsigned int cpu)
+int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	cpu_set(cpu, smp_commenced_mask);
 	while (!cpu_online(cpu))
Index: linux-2.6/arch/x86/include/asm/smp.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/smp.h
+++ linux-2.6/arch/x86/include/asm/smp.h
@@ -62,6 +62,8 @@ DECLARE_EARLY_PER_CPU(int, x86_cpu_to_lo
 /* Static state in head.S used to set up a CPU */
 extern unsigned long stack_start; /* Initial stack pointer address */
 
+struct task_struct;
+
 struct smp_ops {
 	void (*smp_prepare_boot_cpu)(void);
 	void (*smp_prepare_cpus)(unsigned max_cpus);
@@ -113,7 +115,7 @@ static inline void smp_cpus_done(unsigne
 	smp_ops.smp_cpus_done(max_cpus);
 }
 
-static inline int __cpu_up(unsigned int cpu)
+static inline int __cpu_up(unsigned int cpu, struct task_struct *tidle)
 {
 	return smp_ops.cpu_up(cpu);
 }
Index: linux-2.6/include/linux/smp.h
===================================================================
--- linux-2.6.orig/include/linux/smp.h
+++ linux-2.6/include/linux/smp.h
@@ -61,7 +61,7 @@ extern void smp_prepare_cpus(unsigned in
 /*
  * Bring a CPU up
  */
-extern int __cpu_up(unsigned int cpunum);
+extern int __cpu_up(unsigned int cpunum, struct task_struct *tidle);
 
 /*
  * Final polishing of CPUs
Index: linux-2.6/kernel/cpu.c
===================================================================
--- linux-2.6.orig/kernel/cpu.c
+++ linux-2.6/kernel/cpu.c
@@ -309,7 +309,7 @@ static int __cpuinit _cpu_up(unsigned in
 	}
 
 	/* Arch-specific enabling code. */
-	ret = __cpu_up(cpu);
+	ret = __cpu_up(cpu, NULL);
 	if (ret != 0)
 		goto out_notify;
 	BUG_ON(!cpu_online(cpu));


