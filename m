Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894Ab0FXDFW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 23:05:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:31949 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab0FXDFT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 23:05:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,471,1272870000"; 
   d="scan'208";a="810964582"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 4/5] x86, Use NMI return notifier in MCE
Date: Thu, 24 Jun 2010 11:04:57 +0800
Message-Id: <1277348698-17311-4-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
References: <1277348698-17311-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use general NMI return notifier mechanism to replace the self
interrupt used in MCE handler.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/entry_arch.h  |    4 --
 arch/x86/include/asm/irq_vectors.h |    5 ---
 arch/x86/kernel/cpu/mcheck/mce.c   |   50 +++++--------------------------------
 arch/x86/kernel/entry_64.S         |    5 ---
 arch/x86/kernel/irqinit.c          |    3 --
 5 files changed, 7 insertions(+), 60 deletions(-)

--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -61,8 +61,4 @@ BUILD_INTERRUPT(thermal_interrupt,THERMA
 BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
 #endif
 
-#ifdef CONFIG_X86_MCE
-BUILD_INTERRUPT(mce_self_interrupt,MCE_SELF_VECTOR)
-#endif
-
 #endif
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -121,11 +121,6 @@
 #define UV_BAU_MESSAGE			0xea
 
 /*
- * Self IPI vector for machine checks
- */
-#define MCE_SELF_VECTOR			0xeb
-
-/*
  * Self IPI vector for NMI return notifier
  */
 #define NMI_RETURN_NOTIFIER_VECTOR	0xe9
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -480,60 +480,24 @@ static inline void mce_get_rip(struct mc
 		m->ip = mce_rdmsrl(rip_msr);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-/*
- * Called after interrupts have been reenabled again
- * when a MCE happened during an interrupts off region
- * in the kernel.
- */
-asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
+static void __mce_report_event(struct nmi_return_notifier *nrn)
 {
-	ack_APIC_irq();
-	exit_idle();
-	irq_enter();
 	mce_notify_irq();
 	mce_schedule_work();
-	irq_exit();
 }
-#endif
+
+static DEFINE_PER_CPU(struct nmi_return_notifier, mce_nrn) = {
+	.on_nmi_return	= __mce_report_event,
+};
 
 static void mce_report_event(struct pt_regs *regs)
 {
 	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
-		mce_notify_irq();
-		/*
-		 * Triggering the work queue here is just an insurance
-		 * policy in case the syscall exit notify handler
-		 * doesn't run soon enough or ends up running on the
-		 * wrong CPU (can happen when audit sleeps)
-		 */
-		mce_schedule_work();
+		__mce_report_event(NULL);
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
+	nmi_return_notifier_schedule(&__get_cpu_var(mce_nrn));
 }
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1004,11 +1004,6 @@ apicinterrupt THRESHOLD_APIC_VECTOR \
 apicinterrupt THERMAL_APIC_VECTOR \
 	thermal_interrupt smp_thermal_interrupt
 
-#ifdef CONFIG_X86_MCE
-apicinterrupt MCE_SELF_VECTOR \
-	mce_self_interrupt smp_mce_self_interrupt
-#endif
-
 #ifdef CONFIG_X86_LOCAL_APIC
 apicinterrupt NMI_RETURN_NOTIFIER_VECTOR \
 	nmi_return_notifier_interrupt smp_nmi_return_notifier_interrupt
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -209,9 +209,6 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
-	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
-#endif
 #ifdef CONFIG_X86_LOCAL_APIC
 	alloc_intr_gate(NMI_RETURN_NOTIFIER_VECTOR, nmi_return_notifier_interrupt);
 #endif
