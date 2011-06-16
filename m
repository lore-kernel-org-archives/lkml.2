Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab1FPLR7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:17:59 -0400
Received: from hera.kernel.org ([140.211.167.34]:45171 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663Ab1FPLR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:17:56 -0400
Date: Thu, 16 Jun 2011 11:17:45 GMT
From: tip-bot for Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Message-ID: <tip-b77e70bf3535e0bd5472e0681f41cce4ae0598bb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        seto.hidetoshi@jp.fujitsu.com, tony.luck@intel.com, tglx@linutronix.de,
        borislav.petkov@amd.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        seto.hidetoshi@jp.fujitsu.com, tglx@linutronix.de, tony.luck@intel.com,
        borislav.petkov@amd.com
In-Reply-To: <4DEED6B2.6080005@jp.fujitsu.com>
References: <4DEED6B2.6080005@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:ras/core] x86, mce: Replace MCE_SELF_VECTOR by irq_work
Git-Commit-ID: b77e70bf3535e0bd5472e0681f41cce4ae0598bb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 16 Jun 2011 11:17:46 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b77e70bf3535e0bd5472e0681f41cce4ae0598bb
Gitweb:     http://git.kernel.org/tip/b77e70bf3535e0bd5472e0681f41cce4ae0598bb
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Wed, 8 Jun 2011 10:56:02 +0900
Committer:  Borislav Petkov <borislav.petkov@amd.com>
CommitDate: Thu, 16 Jun 2011 12:10:08 +0200

x86, mce: Replace MCE_SELF_VECTOR by irq_work

The MCE handler uses a special vector for self IPI to invoke
post-emergency processing in an interrupt context, e.g. call an
NMI-unsafe function, wakeup loggers, schedule time-consuming work for
recovery, etc.

This mechanism is now generalized by the following commit:

 > e360adbe29241a0194e10e20595360dd7b98a2b3
 > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
 > Date:   Thu Oct 14 14:01:34 2010 +0800
 >
 >  irq_work: Add generic hardirq context callbacks
 >
 >  Provide a mechanism that allows running code in IRQ context. It is
 >  most useful for NMI code that needs to interact with the rest of the
 >  system -- like wakeup a task to drain buffers.
 :

So change to use provided generic mechanism.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Link: http://lkml.kernel.org/r/4DEED6B2.6080005@jp.fujitsu.com
Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/entry_arch.h  |    4 ---
 arch/x86/include/asm/hw_irq.h      |    1 -
 arch/x86/include/asm/irq_vectors.h |    5 ----
 arch/x86/kernel/cpu/mcheck/mce.c   |   47 ++++-------------------------------
 arch/x86/kernel/entry_64.S         |    5 ----
 arch/x86/kernel/irqinit.c          |    3 --
 6 files changed, 6 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/entry_arch.h b/arch/x86/include/asm/entry_arch.h
index 1cd6d26..0baa628 100644
--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -53,8 +53,4 @@ BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
 #endif
 
-#ifdef CONFIG_X86_MCE
-BUILD_INTERRUPT(mce_self_interrupt,MCE_SELF_VECTOR)
-#endif
-
 #endif
diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index bb9efe8..13f5504 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -34,7 +34,6 @@ extern void irq_work_interrupt(void);
 extern void spurious_interrupt(void);
 extern void thermal_interrupt(void);
 extern void reschedule_interrupt(void);
-extern void mce_self_interrupt(void);
 
 extern void invalidate_interrupt(void);
 extern void invalidate_interrupt0(void);
diff --git a/arch/x86/include/asm/irq_vectors.h b/arch/x86/include/asm/irq_vectors.h
index 6e976ee..6665026 100644
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -109,11 +109,6 @@
 
 #define UV_BAU_MESSAGE			0xf5
 
-/*
- * Self IPI vector for machine checks
- */
-#define MCE_SELF_VECTOR			0xf4
-
 /* Xen vector callback to receive events in a HVM domain */
 #define XEN_HVM_EVTCHN_CALLBACK		0xf3
 
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index ff1ae9b..e81d48b 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -10,7 +10,6 @@
 #include <linux/thread_info.h>
 #include <linux/capability.h>
 #include <linux/miscdevice.h>
-#include <linux/interrupt.h>
 #include <linux/ratelimit.h>
 #include <linux/kallsyms.h>
 #include <linux/rcupdate.h>
@@ -38,12 +37,9 @@
 #include <linux/mm.h>
 #include <linux/debugfs.h>
 #include <linux/edac_mce.h>
+#include <linux/irq_work.h>
 
 #include <asm/processor.h>
-#include <asm/hw_irq.h>
-#include <asm/apic.h>
-#include <asm/idle.h>
-#include <asm/ipi.h>
 #include <asm/mce.h>
 #include <asm/msr.h>
 
@@ -461,22 +457,13 @@ static inline void mce_get_rip(struct mce *m, struct pt_regs *regs)
 		m->ip = mce_rdmsrl(rip_msr);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-/*
- * Called after interrupts have been reenabled again
- * when a MCE happened during an interrupts off region
- * in the kernel.
- */
-asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
+DEFINE_PER_CPU(struct irq_work, mce_irq_work);
+
+static void mce_irq_work_cb(struct irq_work *entry)
 {
-	ack_APIC_irq();
-	exit_idle();
-	irq_enter();
 	mce_notify_irq();
 	mce_schedule_work();
-	irq_exit();
 }
-#endif
 
 static void mce_report_event(struct pt_regs *regs)
 {
@@ -492,29 +479,7 @@ static void mce_report_event(struct pt_regs *regs)
 		return;
 	}
 
-#ifdef CONFIG_X86_LOCAL_APIC
-	/*
-	 * Without APIC do not notify. The event will be picked
-	 * up eventually.
-	 */
-	if (!cpu_has_apic)
-		return;
-
-	/*
-	 * When interrupts are disabled we cannot use
-	 * kernel services safely. Trigger an self interrupt
-	 * through the APIC to instead do the notification
-	 * after interrupts are reenabled again.
-	 */
-	apic->send_IPI_self(MCE_SELF_VECTOR);
-
-	/*
-	 * Wait for idle afterwards again so that we don't leave the
-	 * APIC in a non idle state because the normal APIC writes
-	 * cannot exclude us.
-	 */
-	apic_wait_icr_idle();
-#endif
+	irq_work_queue(&__get_cpu_var(mce_irq_work));
 }
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
@@ -1444,7 +1409,7 @@ void __cpuinit mcheck_cpu_init(struct cpuinfo_x86 *c)
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_timer();
 	INIT_WORK(&__get_cpu_var(mce_work), mce_process_work);
-
+	init_irq_work(&__get_cpu_var(mce_irq_work), &mce_irq_work_cb);
 }
 
 /*
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 8a445a0..9fa6546 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -991,11 +991,6 @@ apicinterrupt THRESHOLD_APIC_VECTOR \
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
 
-#ifdef CONFIG_X86_MCE
-apicinterrupt MCE_SELF_VECTOR \
-	mce_self_interrupt smp_mce_self_interrupt
-#endif
-
 #ifdef CONFIG_SMP
 apicinterrupt CALL_FUNCTION_SINGLE_VECTOR \
 	call_function_single_interrupt smp_call_function_single_interrupt
diff --git a/arch/x86/kernel/irqinit.c b/arch/x86/kernel/irqinit.c
index f470e4e..f09d4bb 100644
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -272,9 +272,6 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
-	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
-#endif
 
 #if defined(CONFIG_X86_64) || defined(CONFIG_X86_LOCAL_APIC)
 	/* self generated IPI for local APIC timer */
