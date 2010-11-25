Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab0KYR4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 12:56:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:44632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0KYR4v convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 12:56:51 -0500
Subject: Re: [RFC][PATCH 2/8] perf, arch: Use early_initcall() for all arch
 pmu implementations
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>, Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>, linux-kernel@vger.kernel.org,
        davem <davem@davemloft.net>, Michael Cree <mcree@orcon.net.nz>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
        Don Zickus <dzickus@redhat.com>,
        Jason Wessel <jason.wessel@windriver.com>
In-Reply-To: <1290680713.2145.18.camel@laptop>
References: <20101117221730.002627458@chello.nl>
	 <20101117222056.040309789@chello.nl>  <1290680713.2145.18.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 25 Nov 2010 18:55:59 +0100
Message-ID: <1290707759.2145.119.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 11:25 +0100, Peter Zijlstra wrote:
> 
> Right, so hw perf init happens from (after this patch):
> 
>  arch_initcall: powerpc, arm, sh, mips
>  early_initcall: x86, sparc, alpha
> 
> 
> Now the problem is that the generic watchdog code (kernel/watchdog.c)
> tries to create hw perf events, and that too runs from early_initcall.
> 
> So my question is, how do we go about curing this, because powerpc, arm,
> sh and mips are too late and the rest depends on link order to work, not
> really a nice situation.
> 
> There's two categories of solutions:
>  - move the watchdog later, and
>  - move the hw perf init earlier.
> 
> The former is undesired because we want the watchdog as early as
> possible, the later needs new infrastructure (also, I don't know if the
> arch implementations can actually run this early).
> 
> So do I create a perf_initcall() or is there another solution that
> avoids things like calling the watchdog code from all arch init code? 

So the perf_event_init() site is _waaay_ to early to init stuff.. I
guess I'll move it all to early_initcall() and I'll move the watchdog to
an explicit call right after it.

Something like the below,.. now I guess the question to all of you is,
can your arch pmu code cope with early_initcall() or does it need to be
some other place?

---
 arch/alpha/include/asm/perf_event.h  |    6 ------
 arch/alpha/kernel/irq_alpha.c        |    2 --
 arch/alpha/kernel/perf_event.c       |    9 ++++++---
 arch/arm/kernel/perf_event.c         |    2 +-
 arch/mips/kernel/perf_event_mipsxx.c |    2 +-
 arch/powerpc/kernel/e500-pmu.c       |    2 +-
 arch/powerpc/kernel/mpc7450-pmu.c    |    2 +-
 arch/powerpc/kernel/power4-pmu.c     |    2 +-
 arch/powerpc/kernel/power5+-pmu.c    |    2 +-
 arch/powerpc/kernel/power5-pmu.c     |    2 +-
 arch/powerpc/kernel/power6-pmu.c     |    2 +-
 arch/powerpc/kernel/power7-pmu.c     |    2 +-
 arch/powerpc/kernel/ppc970-pmu.c     |    2 +-
 arch/sh/kernel/cpu/sh4/perf_event.c  |    2 +-
 arch/sh/kernel/cpu/sh4a/perf_event.c |    2 +-
 arch/sparc/include/asm/perf_event.h  |    4 ----
 arch/sparc/kernel/nmi.c              |    2 --
 arch/sparc/kernel/perf_event.c       |    7 +++++--
 arch/x86/include/asm/perf_event.h    |    2 --
 arch/x86/kernel/cpu/common.c         |    1 -
 arch/x86/kernel/cpu/perf_event.c     |   11 +++++++----
 include/linux/sched.h                |    4 ++++
 init/main.c                          |    1 +
 kernel/watchdog.c                    |    7 +++----
 24 files changed, 38 insertions(+), 42 deletions(-)

Index: linux-2.6/include/linux/sched.h
===================================================================
--- linux-2.6.orig/include/linux/sched.h
+++ linux-2.6/include/linux/sched.h
@@ -316,6 +316,7 @@ extern int proc_dowatchdog_thresh(struct
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
+void lockup_detector_init(void);
 #else
 static inline void touch_softlockup_watchdog(void)
 {
@@ -326,6 +327,9 @@ static inline void touch_softlockup_watc
 static inline void touch_all_softlockup_watchdogs(void)
 {
 }
+static inline void lockup_detector_init(void)
+{
+}
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK
Index: linux-2.6/init/main.c
===================================================================
--- linux-2.6.orig/init/main.c
+++ linux-2.6/init/main.c
@@ -884,6 +884,7 @@ static int __init kernel_init(void * unu
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
+	lockup_detector_init();
 
 	smp_init();
 	sched_init_smp();
Index: linux-2.6/kernel/watchdog.c
===================================================================
--- linux-2.6.orig/kernel/watchdog.c
+++ linux-2.6/kernel/watchdog.c
@@ -547,13 +547,13 @@ static struct notifier_block __cpuinitda
 	.notifier_call = cpu_callback
 };
 
-static int __init spawn_watchdog_task(void)
+void __init lockup_detector_init(void)
 {
 	void *cpu = (void *)(long)smp_processor_id();
 	int err;
 
 	if (no_watchdog)
-		return 0;
+		return;
 
 	err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
 	WARN_ON(notifier_to_errno(err));
@@ -561,6 +561,5 @@ static int __init spawn_watchdog_task(vo
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
-	return 0;
+	return;
 }
-early_initcall(spawn_watchdog_task);
Index: linux-2.6/arch/alpha/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/alpha/include/asm/perf_event.h
+++ linux-2.6/arch/alpha/include/asm/perf_event.h
@@ -1,10 +1,4 @@
 #ifndef __ASM_ALPHA_PERF_EVENT_H
 #define __ASM_ALPHA_PERF_EVENT_H
 
-#ifdef CONFIG_PERF_EVENTS
-extern void init_hw_perf_events(void);
-#else
-static inline void init_hw_perf_events(void)    { }
-#endif
-
 #endif /* __ASM_ALPHA_PERF_EVENT_H */
Index: linux-2.6/arch/alpha/kernel/irq_alpha.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/irq_alpha.c
+++ linux-2.6/arch/alpha/kernel/irq_alpha.c
@@ -112,8 +112,6 @@ init_IRQ(void)
 	wrent(entInt, 0);
 
 	alpha_mv.init_irq();
-
-	init_hw_perf_events();
 }
 
 /*
Index: linux-2.6/arch/alpha/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/alpha/kernel/perf_event.c
+++ linux-2.6/arch/alpha/kernel/perf_event.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/kdebug.h>
 #include <linux/mutex.h>
+#include <linux/init.h>
 
 #include <asm/hwrpb.h>
 #include <asm/atomic.h>
@@ -863,13 +864,13 @@ static void alpha_perf_event_irq_handler
 /*
  * Init call to initialise performance events at kernel startup.
  */
-void __init init_hw_perf_events(void)
+int __init init_hw_perf_events(void)
 {
 	pr_info("Performance events: ");
 
 	if (!supported_cpu()) {
 		pr_cont("No support for your CPU.\n");
-		return;
+		return 0;
 	}
 
 	pr_cont("Supported CPU type!\n");
@@ -882,5 +883,7 @@ void __init init_hw_perf_events(void)
 	alpha_pmu = &ev67_pmu;
 
 	perf_pmu_register(&pmu);
-}
 
+	return 0;
+}
+early_initcall(init_hw_perf_events);
Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -3038,7 +3038,7 @@ init_hw_perf_events(void)
 
 	return 0;
 }
-arch_initcall(init_hw_perf_events);
+early_initcall(init_hw_perf_events);
 
 /*
  * Callchain handling code.
Index: linux-2.6/arch/mips/kernel/perf_event_mipsxx.c
===================================================================
--- linux-2.6.orig/arch/mips/kernel/perf_event_mipsxx.c
+++ linux-2.6/arch/mips/kernel/perf_event_mipsxx.c
@@ -1047,6 +1047,6 @@ init_hw_perf_events(void)
 
 	return 0;
 }
-arch_initcall(init_hw_perf_events);
+early_initcall(init_hw_perf_events);
 
 #endif /* defined(CONFIG_CPU_MIPS32)... */
Index: linux-2.6/arch/powerpc/kernel/e500-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/e500-pmu.c
+++ linux-2.6/arch/powerpc/kernel/e500-pmu.c
@@ -126,4 +126,4 @@ static int init_e500_pmu(void)
 	return register_fsl_emb_pmu(&e500_pmu);
 }
 
-arch_initcall(init_e500_pmu);
+early_initcall(init_e500_pmu);
Index: linux-2.6/arch/powerpc/kernel/mpc7450-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/mpc7450-pmu.c
+++ linux-2.6/arch/powerpc/kernel/mpc7450-pmu.c
@@ -414,4 +414,4 @@ static int init_mpc7450_pmu(void)
 	return register_power_pmu(&mpc7450_pmu);
 }
 
-arch_initcall(init_mpc7450_pmu);
+early_initcall(init_mpc7450_pmu);
Index: linux-2.6/arch/powerpc/kernel/power4-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/power4-pmu.c
+++ linux-2.6/arch/powerpc/kernel/power4-pmu.c
@@ -613,4 +613,4 @@ static int init_power4_pmu(void)
 	return register_power_pmu(&power4_pmu);
 }
 
-arch_initcall(init_power4_pmu);
+early_initcall(init_power4_pmu);
Index: linux-2.6/arch/powerpc/kernel/power5+-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/power5+-pmu.c
+++ linux-2.6/arch/powerpc/kernel/power5+-pmu.c
@@ -682,4 +682,4 @@ static int init_power5p_pmu(void)
 	return register_power_pmu(&power5p_pmu);
 }
 
-arch_initcall(init_power5p_pmu);
+early_initcall(init_power5p_pmu);
Index: linux-2.6/arch/powerpc/kernel/power5-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/power5-pmu.c
+++ linux-2.6/arch/powerpc/kernel/power5-pmu.c
@@ -621,4 +621,4 @@ static int init_power5_pmu(void)
 	return register_power_pmu(&power5_pmu);
 }
 
-arch_initcall(init_power5_pmu);
+early_initcall(init_power5_pmu);
Index: linux-2.6/arch/powerpc/kernel/power6-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/power6-pmu.c
+++ linux-2.6/arch/powerpc/kernel/power6-pmu.c
@@ -544,4 +544,4 @@ static int init_power6_pmu(void)
 	return register_power_pmu(&power6_pmu);
 }
 
-arch_initcall(init_power6_pmu);
+early_initcall(init_power6_pmu);
Index: linux-2.6/arch/powerpc/kernel/power7-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/power7-pmu.c
+++ linux-2.6/arch/powerpc/kernel/power7-pmu.c
@@ -369,4 +369,4 @@ static int init_power7_pmu(void)
 	return register_power_pmu(&power7_pmu);
 }
 
-arch_initcall(init_power7_pmu);
+early_initcall(init_power7_pmu);
Index: linux-2.6/arch/powerpc/kernel/ppc970-pmu.c
===================================================================
--- linux-2.6.orig/arch/powerpc/kernel/ppc970-pmu.c
+++ linux-2.6/arch/powerpc/kernel/ppc970-pmu.c
@@ -494,4 +494,4 @@ static int init_ppc970_pmu(void)
 	return register_power_pmu(&ppc970_pmu);
 }
 
-arch_initcall(init_ppc970_pmu);
+early_initcall(init_ppc970_pmu);
Index: linux-2.6/arch/sh/kernel/cpu/sh4/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/sh4/perf_event.c
+++ linux-2.6/arch/sh/kernel/cpu/sh4/perf_event.c
@@ -250,4 +250,4 @@ static int __init sh7750_pmu_init(void)
 
 	return register_sh_pmu(&sh7750_pmu);
 }
-arch_initcall(sh7750_pmu_init);
+early_initcall(sh7750_pmu_init);
Index: linux-2.6/arch/sh/kernel/cpu/sh4a/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/cpu/sh4a/perf_event.c
+++ linux-2.6/arch/sh/kernel/cpu/sh4a/perf_event.c
@@ -284,4 +284,4 @@ static int __init sh4a_pmu_init(void)
 
 	return register_sh_pmu(&sh4a_pmu);
 }
-arch_initcall(sh4a_pmu_init);
+early_initcall(sh4a_pmu_init);
Index: linux-2.6/arch/sparc/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/perf_event.h
+++ linux-2.6/arch/sparc/include/asm/perf_event.h
@@ -4,8 +4,6 @@
 #ifdef CONFIG_PERF_EVENTS
 #include <asm/ptrace.h>
 
-extern void init_hw_perf_events(void);
-
 #define perf_arch_fetch_caller_regs(regs, ip)		\
 do {							\
 	unsigned long _pstate, _asi, _pil, _i7, _fp;	\
@@ -26,8 +24,6 @@ do {							\
 	(regs)->u_regs[UREG_I6] = _fp;			\
 	(regs)->u_regs[UREG_I7] = _i7;			\
 } while (0)
-#else
-static inline void init_hw_perf_events(void)	{ }
 #endif
 
 #endif
Index: linux-2.6/arch/sparc/kernel/nmi.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/nmi.c
+++ linux-2.6/arch/sparc/kernel/nmi.c
@@ -270,8 +270,6 @@ int __init nmi_init(void)
 			atomic_set(&nmi_active, -1);
 		}
 	}
-	if (!err)
-		init_hw_perf_events();
 
 	return err;
 }
Index: linux-2.6/arch/sparc/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/perf_event.c
+++ linux-2.6/arch/sparc/kernel/perf_event.c
@@ -1307,20 +1307,23 @@ static bool __init supported_pmu(void)
 	return false;
 }
 
-void __init init_hw_perf_events(void)
+int __init init_hw_perf_events(void)
 {
 	pr_info("Performance events: ");
 
 	if (!supported_pmu()) {
 		pr_cont("No support for PMU type '%s'\n", sparc_pmu_type);
-		return;
+		return 0;
 	}
 
 	pr_cont("Supported PMU type is '%s'\n", sparc_pmu_type);
 
 	perf_pmu_register(&pmu);
 	register_die_notifier(&perf_event_nmi_notifier);
+
+	return 0;
 }
+early_initcall(init_hw_perf_event);
 
 void perf_callchain_kernel(struct perf_callchain_entry *entry,
 			   struct pt_regs *regs)
Index: linux-2.6/arch/x86/include/asm/perf_event.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/perf_event.h
+++ linux-2.6/arch/x86/include/asm/perf_event.h
@@ -125,7 +125,6 @@ union cpuid10_edx {
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 
 #ifdef CONFIG_PERF_EVENTS
-extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
 
 #define PERF_EVENT_INDEX_OFFSET			0
@@ -156,7 +155,6 @@ extern unsigned long perf_misc_flags(str
 }
 
 #else
-static inline void init_hw_perf_events(void)		{ }
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
Index: linux-2.6/arch/x86/kernel/cpu/common.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/common.c
+++ linux-2.6/arch/x86/kernel/cpu/common.c
@@ -894,7 +894,6 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
-	init_hw_perf_events();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
Index: linux-2.6/arch/x86/kernel/cpu/perf_event.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/cpu/perf_event.c
+++ linux-2.6/arch/x86/kernel/cpu/perf_event.c
@@ -1423,7 +1423,7 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
-void __init init_hw_perf_events(void)
+int __init init_hw_perf_events(void)
 {
 	struct event_constraint *c;
 	int err;
@@ -1438,11 +1438,11 @@ void __init init_hw_perf_events(void)
 		err = amd_pmu_init();
 		break;
 	default:
-		return;
+		return 0;
 	}
 	if (err != 0) {
 		pr_cont("no PMU driver, software events only.\n");
-		return;
+		return 0;
 	}
 
 	pmu_check_apic();
@@ -1450,7 +1450,7 @@ void __init init_hw_perf_events(void)
 	/* sanity check that the hardware exists or is emulated */
 	if (!check_hw_exists()) {
 		pr_cont("Broken PMU hardware detected, software events only.\n");
-		return;
+		return 0;
 	}
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
@@ -1501,7 +1501,10 @@ void __init init_hw_perf_events(void)
 
 	perf_pmu_register(&pmu);
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	return 0;
 }
+early_initcall(init_hw_perf_events);
 
 static inline void x86_pmu_read(struct perf_event *event)
 {

