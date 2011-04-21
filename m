Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab1DUUEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 16:04:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42358 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753223Ab1DUUEx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 16:04:53 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        George Spelvin <linux@horizon.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/4] perf, nmi: Move LVT un-masking into irq handlers
Date: Thu, 21 Apr 2011 11:03:22 -0400
Message-Id: <1303398203-2918-4-git-send-email-dzickus@redhat.com>
In-Reply-To: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
References: <1303398203-2918-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It was noticed that P4 machines were generating double NMIs for each
perf event.  These extra NMIs lead to 'Dazed and confused' messages on
the screen.

I tracked this down to a P4 quirk that said the overflow bit had to be
cleared before re-enabling the apic LVT mask.  My first attempt was
to move the un-masking inside the perf nmi handler from before the
chipset NMI handler to after.

This broke Nehalem boxes that seem to like the unmasking before the
counters themselves are re-enabled.

In order to keep this change simple for 2.6.39, I decided to just
simply move the apic LVT un-masking to the beginning of all the
chipset NMI handlers, with the exeption of Pentium4's to fix the
double NMI issue.

Later on we can move the un-masking to later in the handlers to save
a number of 'extra' NMIs on those particular chipsets.

I tested this change on a P4 machine, an AMD machine, a Nehalem box,
and a core2quad box.  'perf top' worked correctly along with various
other small 'perf record' runs.  Anything high stress breaks all the
machines but that is a different problem.

Thanks to various people for testing different versions of this patch.

https://bugzilla.kernel.org/show_bug.cgi?id=33252

Reported-and-tested-by: Shaun Ruffell <sruffell@digium.com>
Acked-by: Cyrill Gorcunov <gorcunov@gmail.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: Robert Richter <robert.richter@amd.com>
CC: Maciej Rutecki <maciej.rutecki@gmail.com>
CC: George Spelvin <linux@horizon.com>
CC: Stephane Eranian <eranian@google.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 arch/x86/kernel/cpu/perf_event.c       |    5 +++--
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
 arch/x86/kernel/cpu/perf_event_p4.c    |   14 ++++++++++----
 3 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index eed3673a..97c6c44 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1284,6 +1284,9 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
+	/* chipsets have their own quirks when to unmask */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask)) {
 			/*
@@ -1370,8 +1373,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 	}
 
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
 	handled = x86_pmu.handle_irq(args->regs);
 	if (!handled)
 		return NOTIFY_DONE;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8fc2b2c..d2326e1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -933,6 +933,9 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
+	/* chipsets have their own quirks when to unmask */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 56ba449..2d0ac91 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -949,11 +949,17 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 			x86_pmu_stop(event, 0);
 	}
 
-	if (handled) {
-		/* p4 quirk: unmask it again */
-		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+	if (handled)
 		inc_irq_stat(apic_perf_irqs);
-	}
+
+        /*
+	 * P4 quirks:
+	 * - An overflown perfctr will assert its interrupt
+	 *   until the OVF flag in its CCCR is cleared.
+	 * - LVTPC is masked on interrupt and must be
+	 *   unmasked by the LVTPC handler.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	return handled;
 }
-- 
1.7.4.2

