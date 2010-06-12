Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab0FLJ2u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:28:50 -0400
Received: from mga01.intel.com ([192.55.52.88]:30757 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab0FLJ2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,407,1272870000"; 
   d="scan'208";a="807276937"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 2/3] Use unified NMI delayed call mechanism in MCE handler
Date: Sat, 12 Jun 2010 17:28:15 +0800
Message-Id: <1276334896-7075-2-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original self interrupt mechanism in MCE handler is replaced by
the unified delayed call mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/entry_arch.h  |    4 --
 arch/x86/include/asm/irq_vectors.h |    5 ---
 arch/x86/kernel/cpu/mcheck/mce.c   |   53 ++++++-------------------------------
 arch/x86/kernel/entry_64.S         |    5 ---
 arch/x86/kernel/irqinit.c          |    3 --
 5 files changed, 10 insertions(+), 60 deletions(-)

--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -61,9 +61,5 @@ BUILD_INTERRUPT(thermal_interrupt,THERMA
 BUILD_INTERRUPT(threshold_interrupt,THRESHOLD_APIC_VECTOR)
 #endif
 
-#ifdef CONFIG_X86_MCE
-BUILD_INTERRUPT(mce_self_interrupt,MCE_SELF_VECTOR)
-#endif
-
 BUILD_INTERRUPT(nmi_delayed_call_interrupt,NMI_DELAYED_CALL_VECTOR)
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
  * Self IPI vector for NMI delayed call
  */
 #define NMI_DELAYED_CALL_VECTOR		0xe9
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -480,60 +480,22 @@ static inline void mce_get_rip(struct mc
 		m->ip = mce_rdmsrl(rip_msr);
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-/*
- * Called after interrupts have been reenabled again
- * when a MCE happened during an interrupts off region
- * in the kernel.
- */
-asmlinkage void smp_mce_self_interrupt(struct pt_regs *regs)
+static int mce_delayed_call_id = NMI_DELAYED_CALL_ID_INVALID;
+
+static void __mce_report_event(void)
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
 	if (regs->flags & (X86_VM_MASK|X86_EFLAGS_IF)) {
-		mce_notify_irq();
-		/*
-		 * Triggering the work queue here is just an insurance
-		 * policy in case the syscall exit notify handler
-		 * doesn't run soon enough or ends up running on the
-		 * wrong CPU (can happen when audit sleeps)
-		 */
-		mce_schedule_work();
+		__mce_report_event();
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
+	nmi_delayed_call_schedule(mce_delayed_call_id);
 }
 
 DEFINE_PER_CPU(unsigned, mce_poll_count);
@@ -1731,6 +1693,11 @@ __setup("mce", mcheck_enable);
 
 int __init mcheck_init(void)
 {
+	mce_delayed_call_id = nmi_delayed_call_register(__mce_report_event);
+	if (mce_delayed_call_id == NMI_DELAYED_CALL_ID_INVALID)
+		pr_err(
+		"Failed to register mce delayed event reporting function!\n");
+
 	atomic_notifier_chain_register(&x86_mce_decoder_chain, &mce_dec_nb);
 
 	mcheck_intel_therm_init();
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
 apicinterrupt NMI_DELAYED_CALL_VECTOR \
 	nmi_delayed_call_interrupt smp_nmi_delayed_call_interrupt
 
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -209,9 +209,6 @@ static void __init apic_intr_init(void)
 #ifdef CONFIG_X86_MCE_THRESHOLD
 	alloc_intr_gate(THRESHOLD_APIC_VECTOR, threshold_interrupt);
 #endif
-#if defined(CONFIG_X86_MCE) && defined(CONFIG_X86_LOCAL_APIC)
-	alloc_intr_gate(MCE_SELF_VECTOR, mce_self_interrupt);
-#endif
 #if defined(CONFIG_X86_LOCAL_APIC)
 	alloc_intr_gate(NMI_DELAYED_CALL_VECTOR, nmi_delayed_call_interrupt);
 #endif
