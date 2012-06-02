Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759029Ab2FBPNz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 11:13:55 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:37151 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757909Ab2FBPNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 11:13:51 -0400
Date: Sat, 2 Jun 2012 17:13:48 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: David Miller <davem@davemloft.net>, tglx@linutronix.de,
        peterz@infradead.org, paulmck@linux.vnet.ibm.com,
        rusty@rustcorp.com.au, mingo@kernel.org, yong.zhang0@gmail.com,
        akpm@linux-foundation.org, vatsa@linux.vnet.ibm.com, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        nikunj@linux.vnet.ibm.com, vapier@gentoo.org, konrad@gaisler.com,
        tkhai@yandex.ru, sparclinux@vger.kernel.org
Subject: Re: [UPDATED PATCH 21/27] sparc32, smpboot: Use generic SMP booting
	infrastructure
Message-ID: <20120602151348.GA17409@merkur.ravnborg.org>
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091503.31979.52537.stgit@srivatsabhat.in.ibm.com> <20120601.135612.699120609738854050.davem@davemloft.net> <20120601185448.GA19148@merkur.ravnborg.org> <4FC94693.5050707@linux.vnet.ibm.com> <20120602065249.GA19558@merkur.ravnborg.org> <20120602074424.GA19690@merkur.ravnborg.org> <4FC9C871.60902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC9C871.60902@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> > I will try to dive into this and see if I on the sparc32 side
> > can make leon behave like the other platforms, and then 
> > unify some of the smp cpu boot stuff such that we then
> > can introduce the generalization from your patch.

This is what I came up with.
I modelled this over your patch-set to make it
simpler to convert to the generic scheme.

I realised a bit more how CPU's are started up on sparc32.
So I think all of leon, sun4m and sun4d should work with this.

But my SUN box is defunct atm. so I have not tested it.
Comments appreciated!

PS. I used the ugly __names for now.
As soon as you have found a better set of names this should
be fixed here too.

	Sam

diff --git a/arch/sparc/kernel/kernel.h b/arch/sparc/kernel/kernel.h
index 291bb5d..2bc1c6d 100644
--- a/arch/sparc/kernel/kernel.h
+++ b/arch/sparc/kernel/kernel.h
@@ -48,6 +48,10 @@ extern void sun4m_init_IRQ(void);
 extern void sun4m_unmask_profile_irq(void);
 extern void sun4m_clear_profile_irq(int cpu);
 
+/* sun4m_smp.c */
+void sun4m_cpu_pre_starting(void);
+void sun4m_cpu_pre_online(void);
+
 /* sun4d_irq.c */
 extern spinlock_t sun4d_imsk_lock;
 
@@ -60,6 +64,14 @@ extern int show_sun4d_interrupts(struct seq_file *, void *);
 extern void sun4d_distribute_irqs(void);
 extern void sun4d_free_irq(unsigned int irq, void *dev_id);
 
+/* sun4d_smp.c */
+void sun4d_cpu_pre_starting(void);
+void sun4d_cpu_pre_online(void);
+
+/* leon_smp.c */
+void leon_cpu_pre_starting(void);
+void leon_cpu_pre_online(void);
+
 /* head_32.S */
 extern unsigned int t_nmi[];
 extern unsigned int linux_trap_ipi15_sun4d[];
diff --git a/arch/sparc/kernel/leon_smp.c b/arch/sparc/kernel/leon_smp.c
index 0f3fb6d..0b028b3 100644
--- a/arch/sparc/kernel/leon_smp.c
+++ b/arch/sparc/kernel/leon_smp.c
@@ -69,31 +69,20 @@ static inline unsigned long do_swap(volatile unsigned long *ptr,
 	return val;
 }
 
-void __cpuinit leon_callin(void)
+void __cpuinit leon_cpu_pre_starting(void)
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
 
-	local_ops->cache_all();
-	local_ops->tlb_all();
+void __cpuinit cpu_cpu_pre_starting(void *unused)
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
 
@@ -110,9 +99,6 @@ void __cpuinit leon_callin(void)
 
 	while (!cpumask_test_cpu(cpuid, &smp_commenced_mask))
 		mb();
-
-	local_irq_enable();
-	set_cpu_online(cpuid, true);
 }
 
 /*
diff --git a/arch/sparc/kernel/smp_32.c b/arch/sparc/kernel/smp_32.c
index 79db45e..2e2990f 100644
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
 
+void __cpuinit __cpu_pre_starting(void *unused)
+{
+	local_ops->cache_all();
+	local_ops->tlb_all();
+
+	switch(sparc_cpu_model) {
+	case sun4m:
+		sun4m_cpu_pre_starting();
+		break;
+	case sun4d:
+		sun4d_cpu_pre_starting();
+		break;
+	case sparc_leon:
+		leon_cpu_pre_starting();
+		break;
+	default:
+		BUG();
+	}
+}
+
+void __cpuinit __cpu_pre_online(void *unused)
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
+		sun4m_cpu_pre_online();
+		break;
+	case sun4d:
+		sun4d_cpu_pre_online();
+		break;
+	case sparc_leon:
+		leon_cpu_pre_starting();
+		break;
+	default:
+		BUG();
+	}
+}
+
+void __cpuinit sparc_start_secondary(void *unused)
+{
+	unsigned int cpu;
+
+	/*
+	 * SMP booting is extremely fragile in some architectures. So run
+	 * the cpu initialization code first before anything else.
+	 */
+	__cpu_pre_starting(NULL);
+
+	preempt_disable();
+	cpu = smp_processor_id();
+
+	/* Invoke the CPU_STARTING notifier callbacks */
+	notify_cpu_starting(cpu);
+
+	__cpu_pre_online(NULL);
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
index ddaea31..bfbbc46 100644
--- a/arch/sparc/kernel/sun4d_smp.c
+++ b/arch/sparc/kernel/sun4d_smp.c
@@ -50,10 +50,9 @@ static inline void show_leds(int cpuid)
 			      "i" (ASI_M_CTL));
 }
 
-void __cpuinit smp4d_callin(void)
+void __cpuinit sun4d_cpu_pre_starting(void)
 {
 	int cpuid = hard_smp_processor_id();
-	unsigned long flags;
 
 	/* Show we are alive */
 	cpu_leds[cpuid] = 0x6;
@@ -61,24 +60,14 @@ void __cpuinit smp4d_callin(void)
 
 	/* Enable level15 interrupt, disable level14 interrupt for now */
 	cc_set_imsk((cc_get_imsk() & ~0x8000) | 0x4000);
+}
 
-	local_ops->cache_all();
-	local_ops->tlb_all();
-
-	notify_cpu_starting(cpuid);
-	/*
-	 * Unblock the master CPU _only_ when the scheduler state
-	 * of all secondary CPUs will be up-to-date, so after
-	 * the SMP initialization the master will be just allowed
-	 * to call the scheduler code.
-	 */
-	/* Get our local ticker going. */
-	register_percpu_ce(cpuid);
+void __cpuinit sun4d_cpu_pre_online(void)
+{
+	unsigned long flags;
+	int cpuid;
 
-	calibrate_delay();
-	smp_store_cpu_info(cpuid);
-	local_ops->cache_all();
-	local_ops->tlb_all();
+	cpuid = hard_smp_processor_id();
 
 	/* Allow master to continue. */
 	sun4d_swap((unsigned long *)&cpu_callin_map[cpuid], 1);
@@ -106,16 +95,12 @@ void __cpuinit smp4d_callin(void)
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
index 128af73..0cf6b4f 100644
--- a/arch/sparc/kernel/sun4m_smp.c
+++ b/arch/sparc/kernel/sun4m_smp.c
@@ -34,30 +34,19 @@ swap_ulong(volatile unsigned long *ptr, unsigned long val)
 	return val;
 }
 
-void __cpuinit smp4m_callin(void)
+void __cpuinit sun4m_cpu_pre_starting(void)
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
+void __cpuinit sun4m_cpu_pre_online(void)
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
