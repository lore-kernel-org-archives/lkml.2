Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab0FLJ2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 05:28:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:30032 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753381Ab0FLJ2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 05:28:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,407,1272870000"; 
   d="scan'208";a="807276941"
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       Huang Ying <ying.huang@intel.com>
Subject: [RFC 3/3] Use unified NMI delayed call mechanism in perf event NMI handler
Date: Sat, 12 Jun 2010 17:28:16 +0800
Message-Id: <1276334896-7075-3-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
References: <1276334896-7075-1-git-send-email-ying.huang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original self interrupt mechanism in perf event NMI handler is
replaced by the unified delayed call mechanism.

Signed-off-by: Huang Ying <ying.huang@intel.com>
---
 arch/x86/include/asm/entry_arch.h  |    4 ----
 arch/x86/include/asm/irq_vectors.h |    5 -----
 arch/x86/kernel/cpu/perf_event.c   |   13 ++++++++-----
 arch/x86/kernel/entry_64.S         |    5 -----
 arch/x86/kernel/irqinit.c          |    6 ------
 5 files changed, 8 insertions(+), 25 deletions(-)

--- a/arch/x86/include/asm/entry_arch.h
+++ b/arch/x86/include/asm/entry_arch.h
@@ -49,10 +49,6 @@ BUILD_INTERRUPT(apic_timer_interrupt,LOC
 BUILD_INTERRUPT(error_interrupt,ERROR_APIC_VECTOR)
 BUILD_INTERRUPT(spurious_interrupt,SPURIOUS_APIC_VECTOR)
 
-#ifdef CONFIG_PERF_EVENTS
-BUILD_INTERRUPT(perf_pending_interrupt, LOCAL_PENDING_VECTOR)
-#endif
-
 #ifdef CONFIG_X86_THERMAL_VECTOR
 BUILD_INTERRUPT(thermal_interrupt,THERMAL_APIC_VECTOR)
 #endif
--- a/arch/x86/include/asm/irq_vectors.h
+++ b/arch/x86/include/asm/irq_vectors.h
@@ -113,11 +113,6 @@
  */
 #define X86_PLATFORM_IPI_VECTOR		0xed
 
-/*
- * Performance monitoring pending work vector:
- */
-#define LOCAL_PENDING_VECTOR		0xec
-
 #define UV_BAU_MESSAGE			0xea
 
 /*
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1160,13 +1160,12 @@ static int x86_pmu_handle_irq(struct pt_
 	return handled;
 }
 
-void smp_perf_pending_interrupt(struct pt_regs *regs)
+static int perf_delayed_call_id = NMI_DELAYED_CALL_ID_INVALID;
+
+void perf_do_pending(void)
 {
-	irq_enter();
-	ack_APIC_irq();
 	inc_irq_stat(apic_pending_irqs);
 	perf_event_do_pending();
-	irq_exit();
 }
 
 void set_perf_event_pending(void)
@@ -1175,7 +1174,7 @@ void set_perf_event_pending(void)
 	if (!x86_pmu.apic || !x86_pmu_initialized())
 		return;
 
-	apic->send_IPI_self(LOCAL_PENDING_VECTOR);
+	nmi_delayed_call_schedule(perf_delayed_call_id);
 #endif
 }
 
@@ -1363,6 +1362,10 @@ void __init init_hw_perf_events(void)
 		}
 	}
 
+	perf_delayed_call_id = nmi_delayed_call_register(perf_do_pending);
+	if (perf_delayed_call_id == NMI_DELAYED_CALL_ID_INVALID)
+		pr_err("Failed to register NMI delayed call for perf.\n");
+
 	pr_info("... version:                %d\n",     x86_pmu.version);
 	pr_info("... bit width:              %d\n",     x86_pmu.cntval_bits);
 	pr_info("... generic registers:      %d\n",     x86_pmu.num_counters);
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -1021,11 +1021,6 @@ apicinterrupt ERROR_APIC_VECTOR \
 apicinterrupt SPURIOUS_APIC_VECTOR \
 	spurious_interrupt smp_spurious_interrupt
 
-#ifdef CONFIG_PERF_EVENTS
-apicinterrupt LOCAL_PENDING_VECTOR \
-	perf_pending_interrupt smp_perf_pending_interrupt
-#endif
-
 /*
  * Exception entry points.
  */
--- a/arch/x86/kernel/irqinit.c
+++ b/arch/x86/kernel/irqinit.c
@@ -223,12 +223,6 @@ static void __init apic_intr_init(void)
 	/* IPI vectors for APIC spurious and error interrupts */
 	alloc_intr_gate(SPURIOUS_APIC_VECTOR, spurious_interrupt);
 	alloc_intr_gate(ERROR_APIC_VECTOR, error_interrupt);
-
-	/* Performance monitoring interrupts: */
-# ifdef CONFIG_PERF_EVENTS
-	alloc_intr_gate(LOCAL_PENDING_VECTOR, perf_pending_interrupt);
-# endif
-
 #endif
 }
 
