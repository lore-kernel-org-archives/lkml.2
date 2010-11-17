Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935589Ab0KQWXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 17:23:47 -0500
Received: from canuck.infradead.org ([134.117.69.58]:45898 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935437Ab0KQWXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 17:23:45 -0500
Message-Id: <20101117222056.040309789@chello.nl>
User-Agent: quilt/0.47-1
Date: Wed, 17 Nov 2010 23:17:32 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
        Stephane Eranian <eranian@google.com>,
        "robert.richter" <robert.richter@amd.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        fweisbec <fweisbec@gmail.com>, paulus <paulus@samba.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Kay Sievers <kay.sievers@vrfy.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Kyle Moffett <kyle@moffetthome.net>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 2/8] perf, arch: Use early_initcall() for all arch pmu implementations
References: <20101117221730.002627458@chello.nl>
Content-Disposition: inline; filename=perf-fix-hw-init.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently architectures use various random locations to init the PMU
driver, for some this happens before the perf core code is
initialized.

In order to avoid calling perf_pmu_register() before the core code is
up and running and able to deal with it, move all arch init to at
least early_initcall (some archs use a later init, which is fine).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 arch/alpha/include/asm/perf_event.h |    6 ------
 arch/alpha/kernel/irq_alpha.c       |    2 --
 arch/alpha/kernel/perf_event.c      |    9 ++++++---
 arch/sparc/include/asm/perf_event.h |    4 ----
 arch/sparc/kernel/nmi.c             |    2 --
 arch/sparc/kernel/perf_event.c      |    7 +++++--
 arch/x86/include/asm/perf_event.h   |    2 --
 arch/x86/kernel/cpu/common.c        |    1 -
 arch/x86/kernel/cpu/perf_event.c    |    9 ++++++---
 9 files changed, 17 insertions(+), 25 deletions(-)

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
@@ -1348,7 +1348,7 @@ static void __init pmu_check_apic(void)
 	pr_info("no hardware sampling interrupt available.\n");
 }
 
-void __init init_hw_perf_events(void)
+int __init init_hw_perf_events(void)
 {
 	struct event_constraint *c;
 	int err;
@@ -1363,11 +1363,11 @@ void __init init_hw_perf_events(void)
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
@@ -1420,7 +1420,10 @@ void __init init_hw_perf_events(void)
 
 	perf_pmu_register(&pmu);
 	perf_cpu_notifier(x86_pmu_notifier);
+
+	return 0;
 }
+early_initcall(init_hw_perf_events);
 
 static inline void x86_pmu_read(struct perf_event *event)
 {


