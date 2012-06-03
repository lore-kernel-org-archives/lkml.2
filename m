Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab2FCVR5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 17:17:57 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:59860 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753731Ab2FCVR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 17:17:56 -0400
Date: Sun, 3 Jun 2012 23:17:52 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, vapier@gentoo.org, konrad@gaisler.com,
        tkhai@yandex.ru, sparclinux@vger.kernel.org
Subject: [PATCH] sparc32: refactor smp boot
Message-ID: <20120603211752.GA7594@merkur.ravnborg.org>
References: <20120601.135612.699120609738854050.davem@davemloft.net> <20120601185448.GA19148@merkur.ravnborg.org> <4FC94693.5050707@linux.vnet.ibm.com> <20120602065249.GA19558@merkur.ravnborg.org> <20120602074424.GA19690@merkur.ravnborg.org> <4FC9C871.60902@linux.vnet.ibm.com> <20120602151348.GA17409@merkur.ravnborg.org> <4FCA382B.6050601@linux.vnet.ibm.com> <20120602162340.GA27530@merkur.ravnborg.org> <4FCA40A5.3060409@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCA40A5.3060409@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 531d9c538fc60c15363890768ea416897853d6af Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sun, 3 Jun 2012 23:08:18 +0200
Subject: [PATCH] sparc32: refactor smp boot

Introduce a common smp_callin() function to call
from trampoline_32.S.
Add platform specific functions to handle the
platform details.

This is in preparation for a patch that will
unify the smp boot stuff for all architectures.
sparc32 was significantly different to warrant
this patch in preparation.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---

Hi Srivatsa.

This should address all your comemnts (thanks!).
I assume you will include this patch in your serie.

@davem: please ack this patch (if it is OK that is)
Note: It has not seen much testing.
But I have tried to review it carefully.

	Sam

 arch/sparc/kernel/kernel.h        |   12 +++++
 arch/sparc/kernel/leon_smp.c      |   33 ++++----------
 arch/sparc/kernel/smp_32.c        |   86 +++++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/sun4d_smp.c     |   29 ++++---------
 arch/sparc/kernel/sun4m_smp.c     |   33 ++++----------
 arch/sparc/kernel/trampoline_32.S |   17 +++----
 6 files changed, 132 insertions(+), 78 deletions(-)

diff --git a/arch/sparc/kernel/kernel.h b/arch/sparc/kernel/kernel.h
index 291bb5d..a702d9a 100644
--- a/arch/sparc/kernel/kernel.h
+++ b/arch/sparc/kernel/kernel.h
@@ -48,6 +48,10 @@ extern void sun4m_init_IRQ(void);
 extern void sun4m_unmask_profile_irq(void);
 extern void sun4m_clear_profile_irq(int cpu);
 
+/* sun4m_smp.c */
+void sun4m_cpu_pre_starting(void *arg);
+void sun4m_cpu_pre_online(void *arg);
+
 /* sun4d_irq.c */
 extern spinlock_t sun4d_imsk_lock;
 
@@ -60,6 +64,14 @@ extern int show_sun4d_interrupts(struct seq_file *, void *);
 extern void sun4d_distribute_irqs(void);
 extern void sun4d_free_irq(unsigned int irq, void *dev_id);
 
+/* sun4d_smp.c */
+void sun4d_cpu_pre_starting(void *arg);
+void sun4d_cpu_pre_online(void *arg);
+
+/* leon_smp.c */
+void leon_cpu_pre_starting(void *arg);
+void leon_cpu_pre_online(void *arg);
+
 /* head_32.S */
 extern unsigned int t_nmi[];
 extern unsigned int linux_trap_ipi15_sun4d[];
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 0f3fb6d..9b40c9c 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -69,31 +69,19 @@ static inline unsigned long do_swap(volatile unsigned long *ptr,
 	return val;
 }
 
-void __cpuinit leon_callin(void)
+void __cpuinit leon_cpu_pre_starting(void *arg)
 {
-	int cpuid = hard_smp_processor_id();
-
-	local_ops->cache_all();
-	local_ops->tlb_all();
 	leon_configure_cache_smp();
+}
 
-	notify_cpu_starting(cpuid);
-
-	/* Get our local ticker going. */
-	register_percpu_ce(cpuid);
-
-	calibrate_delay();
-	smp_store_cpu_info(cpuid);
-
-	local_ops->cache_all();
-	local_ops->tlb_all();
+void __cpuinit leon_cpu_pre_online(void *arg)
+{
+	int cpuid = hard_smp_processor_id();
 
-	/*
-	 * Unblock the master CPU _only_ when the scheduler state
-	 * of all secondary CPUs will be up-to-date, so after
-	 * the SMP initialization the master will be just allowed
-	 * to call the scheduler code.
-	 * Allow master to continue.
+	/* Allow master to continue. The master will then give us the
+	 * go-ahead by setting the smp_commenced_mask and will wait without
+	 * timeouts until our setup is completed fully (signified by
+	 * our bit being set in the cpu_online_mask).
 	 */
 	do_swap(&cpu_callin_map[cpuid], 1);
 
@@ -110,9 +98,6 @@ void __cpuinit leon_callin(void)
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		mb();
-
-	local_irq_enable();
-	set_cpu_online(cpuid, true);
 }
 
 /*
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 79db45e..9e7e6d7 100644
--- a/arch/sparc/kernel/smp_32.c
+++ b/arch/sparc/kernel/smp_32.c
@@ -20,6 +20,7 @@
 #include <linux/seq_file.h>
 #include <linux/cache.h>
 #include <linux/delay.h>
+#include <linux/cpu.h>
 
 #include <asm/ptrace.h>
 #include <linux/atomic.h>
@@ -32,8 +33,10 @@
 #include <asm/cacheflush.h>
 #include <asm/tlbflush.h>
 #include <asm/cpudata.h>
+#include <asm/timer.h>
 #include <asm/leon.h>
 
+#include "kernel.h"
 #include "irq.h"
 
 volatile unsigned long cpu_callin_map[NR_CPUS] __cpuinitdata = {0,};
@@ -294,6 +297,89 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *tidle)
 	return ret;
 }
 
+void __cpuinit arch_cpu_pre_starting(void *arg)
+{
+	local_ops->cache_all();
+	local_ops->tlb_all();
+
+	switch(sparc_cpu_model) {
+	case sun4m:
+		sun4m_cpu_pre_starting(arg);
+		break;
+	case sun4d:
+		sun4d_cpu_pre_starting(arg);
+		break;
+	case sparc_leon:
+		leon_cpu_pre_starting(arg);
+		break;
+	default:
+		BUG();
+	}
+}
+
+void __cpuinit arch_cpu_pre_online(void *arg)
+{
+	unsigned int cpuid = hard_smp_processor_id();
+
+	register_percpu_ce(cpuid);
+
+	calibrate_delay();
+	smp_store_cpu_info(cpuid);
+
+	local_ops->cache_all();
+	local_ops->tlb_all();
+
+	switch(sparc_cpu_model) {
+	case sun4m:
+		sun4m_cpu_pre_online(arg);
+		break;
+	case sun4d:
+		sun4d_cpu_pre_online(arg);
+		break;
+	case sparc_leon:
+		leon_cpu_pre_online(arg);
+		break;
+	default:
+		BUG();
+	}
+}
+
+void __cpuinit sparc_start_secondary(void *arg)
+{
+	unsigned int cpu;
+
+	/*
+	 * SMP booting is extremely fragile in some architectures. So run
+	 * the cpu initialization code first before anything else.
+	 */
+	arch_cpu_pre_starting(arg);
+
+	preempt_disable();
+	cpu = smp_processor_id();
+
+	/* Invoke the CPU_STARTING notifier callbacks */
+	notify_cpu_starting(cpu);
+
+	arch_cpu_pre_online(arg);
+
+	/* Set the CPU in the cpu_online_mask */
+	set_cpu_online(cpu, true);
+
+	/* Enable local interrupts now */
+	local_irq_enable();
+
+	wmb();
+	cpu_idle();
+
+	/* We should never reach here! */
+	BUG();
+}
+
+void __cpuinit smp_callin(void)
+{
+	sparc_start_secondary(NULL);
+}
+
 void smp_bogo(struct seq_file *m)
 {
 	int i;
diff --git a/arch/sparc/kernel/sun4d_smp.c b/arch/sparc/kernel/sun4d_smp.c
index ddaea31..c9eb82f 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -50,10 +50,9 @@ static inline void show_leds(int cpuid)
 			      "i" (ASI_M_CTL));
 }
 
-void __cpuinit smp4d_callin(void)
+void __cpuinit sun4d_cpu_pre_starting(void *arg)
 {
 	int cpuid = hard_smp_processor_id();
-	unsigned long flags;
 
 	/* Show we are alive */
 	cpu_leds[cpuid] = 0x6;
@@ -61,26 +60,20 @@ void __cpuinit smp4d_callin(void)
 
 	/* Enable level15 interrupt, disable level14 interrupt for now */
 	cc_set_imsk((cc_get_imsk() & ~0x8000) | 0x4000);
+}
 
-	local_ops->cache_all();
-	local_ops->tlb_all();
+void __cpuinit sun4d_cpu_pre_online(void *arg)
+{
+	unsigned long flags;
+	int cpuid;
 
-	notify_cpu_starting(cpuid);
-	/*
-	 * Unblock the master CPU _only_ when the scheduler state
+	cpuid = hard_smp_processor_id();
+
+	/* Unblock the master CPU _only_ when the scheduler state
 	 * of all secondary CPUs will be up-to-date, so after
 	 * the SMP initialization the master will be just allowed
 	 * to call the scheduler code.
 	 */
-	/* Get our local ticker going. */
-	register_percpu_ce(cpuid);
-
-	calibrate_delay();
-	smp_store_cpu_info(cpuid);
-	local_ops->cache_all();
-	local_ops->tlb_all();
-
-	/* Allow master to continue. */
 	sun4d_swap((unsigned long *)&cpu_callin_map[cpuid], 1);
 	local_ops->cache_all();
 	local_ops->tlb_all();
@@ -106,16 +99,12 @@ void __cpuinit smp4d_callin(void)
 	local_ops->cache_all();
 	local_ops->tlb_all();
 
-	local_irq_enable();	/* We don't allow PIL 14 yet */
-
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		barrier();
 
 	spin_lock_irqsave(&sun4d_imsk_lock, flags);
 	cc_set_imsk(cc_get_imsk() & ~0x4000); /* Allow PIL 14 as well */
 	spin_unlock_irqrestore(&sun4d_imsk_lock, flags);
-	set_cpu_online(cpuid, true);
-
 }
 
 /*
diff --git a/arch/sparc/kernel/sun4m_smp.c b/arch/sparc/kernel/sun4m_smp.c
index 128af73..8a65f15 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -34,30 +34,19 @@ swap_ulong(volatile unsigned long *ptr, unsigned long val)
 	return val;
 }
 
-void __cpuinit smp4m_callin(void)
+void __cpuinit sun4m_cpu_pre_starting(void *arg)
 {
-	int cpuid = hard_smp_processor_id();
-
-	local_ops->cache_all();
-	local_ops->tlb_all();
-
-	notify_cpu_starting(cpuid);
-
-	register_percpu_ce(cpuid);
-
-	calibrate_delay();
-	smp_store_cpu_info(cpuid);
+}
 
-	local_ops->cache_all();
-	local_ops->tlb_all();
+void __cpuinit sun4m_cpu_pre_online(void *arg)
+{
+	int cpuid = hard_smp_processor_id();
 
-	/*
-	 * Unblock the master CPU _only_ when the scheduler state
-	 * of all secondary CPUs will be up-to-date, so after
-	 * the SMP initialization the master will be just allowed
-	 * to call the scheduler code.
+	/* Allow master to continue. The master will then give us the
+	 * go-ahead by setting the smp_commenced_mask and will wait without
+	 * timeouts until our setup is completed fully (signified by
+	 * our bit being set in the cpu_online_mask).
 	 */
-	/* Allow master to continue. */
 	swap_ulong(&cpu_callin_map[cpuid], 1);
 
 	/* XXX: What's up with all the flushes? */
@@ -75,10 +64,6 @@ void __cpuinit smp4m_callin(void)
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		mb();
-
-	local_irq_enable();
-
-	set_cpu_online(cpuid, true);
 }
 
 /*
diff --git a/arch/sparc/kernel/trampoline_32.S b/arch/sparc/kernel/trampoline_32.S
index af27aca..6cdb08c 100644
--- a/arch/sparc/kernel/trampoline_32.S
+++ b/arch/sparc/kernel/trampoline_32.S
@@ -79,18 +79,15 @@ cpu3_startup:
 	 nop
 
 	/* Start this processor. */
-	call	smp4m_callin
+	call	smp_callin
 	 nop
 
-	b,a	smp_do_cpu_idle
+	b,a	smp_panic
 
 	.text
 	.align	4
 
-smp_do_cpu_idle:
-	call	cpu_idle
-	 mov	0, %o0
-
+smp_panic:
 	call	cpu_panic
 	 nop
 
@@ -144,10 +141,10 @@ sun4d_cpu_startup:
 	 nop
 
 	/* Start this processor. */
-	call	smp4d_callin
+	call	smp_callin
 	 nop
 
-	b,a	smp_do_cpu_idle
+	b,a	smp_panic
 
 	__CPUINIT
 	.align	4
@@ -201,7 +198,7 @@ leon_smp_cpu_startup:
 	 nop
 
 	/* Start this processor. */
-	call	leon_callin
+	call	smp_callin
 	 nop
 
-	b,a	smp_do_cpu_idle
+	b,a	smp_panic
-- 
1.6.0.6

