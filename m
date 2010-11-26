Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755724Ab0KZPG2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 10:06:28 -0500
Received: from hera.kernel.org ([140.211.167.34]:43136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755423Ab0KZPGX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 10:06:23 -0500
Date: Fri, 26 Nov 2010 15:05:36 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@redhat.com, dengcheng.zhu@gmail.com, will.deacon@arm.com,
        a.p.zijlstra@chello.nl, lethal@linux-sh.org, davem@davemloft.net,
        tglx@linutronix.de, mingo@elte.hu, mcree@orcon.net.nz
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, dengcheng.zhu@gmail.com,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, lethal@linux-sh.org,
        davem@davemloft.net, tglx@linutronix.de, mcree@orcon.net.nz,
        mingo@elte.hu
In-Reply-To: <1290707759.2145.119.camel@laptop>
References: <1290707759.2145.119.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, arch: Cleanup perf-pmu init vs lockup-detector
Message-ID: <tip-004417a6d468e24399e383645c068b498eed84ad@git.kernel.org>
Git-Commit-ID: 004417a6d468e24399e383645c068b498eed84ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 15:05:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  004417a6d468e24399e383645c068b498eed84ad
Gitweb:     http://git.kernel.org/tip/004417a6d468e24399e383645c068b498eed84ad
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 25 Nov 2010 18:38:29 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 26 Nov 2010 15:14:56 +0100

perf, arch: Cleanup perf-pmu init vs lockup-detector

The perf hardware pmu got initialized at various points in the boot,
some before early_initcall() some after (notably arch_initcall).

The problem is that the NMI lockup detector is ran from early_initcall()
and expects the hardware pmu to be present.

Sanitize this by moving all architecture hardware pmu implementations to
initialize at early_initcall() and move the lockup detector to an explicit
initcall right after that.

Cc: paulus <paulus@samba.org>
Cc: davem <davem@davemloft.net>
Cc: Michael Cree <mcree@orcon.net.nz>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Acked-by: Paul Mundt <lethal@linux-sh.org>
Acked-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1290707759.2145.119.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
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

diff --git a/arch/alpha/include/asm/perf_event.h b/arch/alpha/include/asm/perf_event.h
index fe792ca..5996e7a 100644
--- a/arch/alpha/include/asm/perf_event.h
+++ b/arch/alpha/include/asm/perf_event.h
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
diff --git a/arch/alpha/kernel/irq_alpha.c b/arch/alpha/kernel/irq_alpha.c
index 5f77afb..4c8bb37 100644
--- a/arch/alpha/kernel/irq_alpha.c
+++ b/arch/alpha/kernel/irq_alpha.c
@@ -112,8 +112,6 @@ init_IRQ(void)
 	wrent(entInt, 0);
 
 	alpha_mv.init_irq();
-
-	init_hw_perf_events();
 }
 
 /*
diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 1cc4968..3283059 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -14,6 +14,7 @@
 #include <linux/kernel.h>
 #include <linux/kdebug.h>
 #include <linux/mutex.h>
+#include <linux/init.h>
 
 #include <asm/hwrpb.h>
 #include <asm/atomic.h>
@@ -863,13 +864,13 @@ static void alpha_perf_event_irq_handler(unsigned long la_ptr,
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
diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 07a5035..d45f70e 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -3038,7 +3038,7 @@ init_hw_perf_events(void)
 
 	return 0;
 }
-arch_initcall(init_hw_perf_events);
+early_initcall(init_hw_perf_events);
 
 /*
  * Callchain handling code.
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 5c7c6fc..183e0d2 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1047,6 +1047,6 @@ init_hw_perf_events(void)
 
 	return 0;
 }
-arch_initcall(init_hw_perf_events);
+early_initcall(init_hw_perf_events);
 
 #endif /* defined(CONFIG_CPU_MIPS32)... */
diff --git a/arch/powerpc/kernel/e500-pmu.c b/arch/powerpc/kernel/e500-pmu.c
index 7c07de0..b150b51 100644
--- a/arch/powerpc/kernel/e500-pmu.c
+++ b/arch/powerpc/kernel/e500-pmu.c
@@ -126,4 +126,4 @@ static int init_e500_pmu(void)
 	return register_fsl_emb_pmu(&e500_pmu);
 }
 
-arch_initcall(init_e500_pmu);
+early_initcall(init_e500_pmu);
diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/powerpc/kernel/mpc7450-pmu.c
index 09d7202..2cc5e03 100644
--- a/arch/powerpc/kernel/mpc7450-pmu.c
+++ b/arch/powerpc/kernel/mpc7450-pmu.c
@@ -414,4 +414,4 @@ static int init_mpc7450_pmu(void)
 	return register_power_pmu(&mpc7450_pmu);
 }
 
-arch_initcall(init_mpc7450_pmu);
+early_initcall(init_mpc7450_pmu);
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index 2a361cd..ead8b3c 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -613,4 +613,4 @@ static int init_power4_pmu(void)
 	return register_power_pmu(&power4_pmu);
 }
 
-arch_initcall(init_power4_pmu);
+early_initcall(init_power4_pmu);
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index 199de52..eca0ac5 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -682,4 +682,4 @@ static int init_power5p_pmu(void)
 	return register_power_pmu(&power5p_pmu);
 }
 
-arch_initcall(init_power5p_pmu);
+early_initcall(init_power5p_pmu);
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index 98b6a72..d5ff0f6 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -621,4 +621,4 @@ static int init_power5_pmu(void)
 	return register_power_pmu(&power5_pmu);
 }
 
-arch_initcall(init_power5_pmu);
+early_initcall(init_power5_pmu);
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 84a607b..3160392 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -544,4 +544,4 @@ static int init_power6_pmu(void)
 	return register_power_pmu(&power6_pmu);
 }
 
-arch_initcall(init_power6_pmu);
+early_initcall(init_power6_pmu);
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 852f7b7..593740f 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -369,4 +369,4 @@ static int init_power7_pmu(void)
 	return register_power_pmu(&power7_pmu);
 }
 
-arch_initcall(init_power7_pmu);
+early_initcall(init_power7_pmu);
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 3fee685..9a6e093 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -494,4 +494,4 @@ static int init_ppc970_pmu(void)
 	return register_power_pmu(&ppc970_pmu);
 }
 
-arch_initcall(init_ppc970_pmu);
+early_initcall(init_ppc970_pmu);
diff --git a/arch/sh/kernel/cpu/sh4/perf_event.c b/arch/sh/kernel/cpu/sh4/perf_event.c
index dbf3b4b..748955d 100644
--- a/arch/sh/kernel/cpu/sh4/perf_event.c
+++ b/arch/sh/kernel/cpu/sh4/perf_event.c
@@ -250,4 +250,4 @@ static int __init sh7750_pmu_init(void)
 
 	return register_sh_pmu(&sh7750_pmu);
 }
-arch_initcall(sh7750_pmu_init);
+early_initcall(sh7750_pmu_init);
diff --git a/arch/sh/kernel/cpu/sh4a/perf_event.c b/arch/sh/kernel/cpu/sh4a/perf_event.c
index 5802765..17e6beb 100644
--- a/arch/sh/kernel/cpu/sh4a/perf_event.c
+++ b/arch/sh/kernel/cpu/sh4a/perf_event.c
@@ -284,4 +284,4 @@ static int __init sh4a_pmu_init(void)
 
 	return register_sh_pmu(&sh4a_pmu);
 }
-arch_initcall(sh4a_pmu_init);
+early_initcall(sh4a_pmu_init);
diff --git a/arch/sparc/include/asm/perf_event.h b/arch/sparc/include/asm/perf_event.h
index 6e8bfa1..4d3dbe3 100644
--- a/arch/sparc/include/asm/perf_event.h
+++ b/arch/sparc/include/asm/perf_event.h
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
diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index a4bd7ba..300f810 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -270,8 +270,6 @@ int __init nmi_init(void)
 			atomic_set(&nmi_active, -1);
 		}
 	}
-	if (!err)
-		init_hw_perf_events();
 
 	return err;
 }
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 0d6deb5..75c5b12 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
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
diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index 550e26b..d9d4dae 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -125,7 +125,6 @@ union cpuid10_edx {
 #define IBS_OP_MAX_CNT_EXT	0x007FFFFFULL	/* not a register bit mask */
 
 #ifdef CONFIG_PERF_EVENTS
-extern void init_hw_perf_events(void);
 extern void perf_events_lapic_init(void);
 
 #define PERF_EVENT_INDEX_OFFSET			0
@@ -156,7 +155,6 @@ extern unsigned long perf_misc_flags(struct pt_regs *regs);
 }
 
 #else
-static inline void init_hw_perf_events(void)		{ }
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index 4b68bda..1d59834 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -894,7 +894,6 @@ void __init identify_boot_cpu(void)
 #else
 	vgetcpu_set_mode();
 #endif
-	init_hw_perf_events();
 }
 
 void __cpuinit identify_secondary_cpu(struct cpuinfo_x86 *c)
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index c01dfec..817d2b1 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1353,7 +1353,7 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
-void __init init_hw_perf_events(void)
+int __init init_hw_perf_events(void)
 {
 	struct event_constraint *c;
 	int err;
@@ -1368,11 +1368,11 @@ void __init init_hw_perf_events(void)
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
@@ -1380,7 +1380,7 @@ void __init init_hw_perf_events(void)
 	/* sanity check that the hardware exists or is emulated */
 	if (!check_hw_exists()) {
 		pr_cont("Broken PMU hardware detected, software events only.\n");
-		return;
+		return 0;
 	}
 
 	pr_cont("%s PMU driver.\n", x86_pmu.name);
@@ -1431,7 +1431,10 @@ void __init init_hw_perf_events(void)
 
 	perf_pmu_register(&pmu);
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	return 0;
 }
+early_initcall(init_hw_perf_events);
 
 static inline void x86_pmu_read(struct perf_event *event)
 {
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2c79e92..d2e63d1 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -316,6 +316,7 @@ extern int proc_dowatchdog_thresh(struct ctl_table *table, int write,
 				  size_t *lenp, loff_t *ppos);
 extern unsigned int  softlockup_panic;
 extern int softlockup_thresh;
+void lockup_detector_init(void);
 #else
 static inline void touch_softlockup_watchdog(void)
 {
@@ -326,6 +327,9 @@ static inline void touch_softlockup_watchdog_sync(void)
 static inline void touch_all_softlockup_watchdogs(void)
 {
 }
+static inline void lockup_detector_init(void)
+{
+}
 #endif
 
 #ifdef CONFIG_DETECT_HUNG_TASK
diff --git a/init/main.c b/init/main.c
index 8646401..261ad7b 100644
--- a/init/main.c
+++ b/init/main.c
@@ -882,6 +882,7 @@ static int __init kernel_init(void * unused)
 	smp_prepare_cpus(setup_max_cpus);
 
 	do_pre_smp_initcalls();
+	lockup_detector_init();
 
 	smp_init();
 	sched_init_smp();
diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 6e3c41a..cad4e42 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -547,13 +547,13 @@ static struct notifier_block __cpuinitdata cpu_nfb = {
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
@@ -561,6 +561,5 @@ static int __init spawn_watchdog_task(void)
 	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
 	register_cpu_notifier(&cpu_nfb);
 
-	return 0;
+	return;
 }
-early_initcall(spawn_watchdog_task);
