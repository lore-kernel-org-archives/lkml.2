Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759313Ab1D0Pdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:33:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751167Ab1D0Pdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:33:36 -0400
From: Don Zickus <dzickus@redhat.com>
To: <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Don Zickus <dzickus@redhat.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: [PATCH] perf, nmi: Move LVT un-masking into irq handlers
Date: Wed, 27 Apr 2011 06:32:33 -0400
Message-Id: <1303900353-10242-1-git-send-email-dzickus@redhat.com>
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
chipset NMI handlers, with the exception of Pentium4's to fix the
double NMI issue.

Later on we can move the un-masking to later in the handlers to save
a number of 'extra' NMIs on those particular chipsets.

I tested this change on a P4 machine, an AMD machine, a Nehalem box,
and a core2quad box.  'perf top' worked correctly along with various
other small 'perf record' runs.  Anything high stress breaks all the
machines but that is a different problem.

Thanks to various people for testing different versions of this patch.

Reported-and-tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>

---
Originally I was going to bundle this with Cyrill's P4 alias patch but that
may take awhile, so I am posting this stand alone for now.  Sorry for the
delay.

---
 arch/x86/kernel/cpu/perf_event.c       |   12 ++++++++++--
 arch/x86/kernel/cpu/perf_event_intel.c |   10 ++++++++++
 arch/x86/kernel/cpu/perf_event_p4.c    |   17 +++++++++++++----
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index eed3673a..9d1130d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1284,6 +1284,16 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
+	/*
+	 * Some chipsets need to unmask the LVTPC in a particular spot
+	 * inside the nmi handler.  As a result, the unmasking was pushed
+	 * into all the nmi handlers.
+	 *
+	 * This generic handler doesn't seem to have any issues where the
+	 * unmasking occurs so it was left at the top.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
 		if (!test_bit(idx, cpuc->active_mask)) {
 			/*
@@ -1370,8 +1380,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 	}
 
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
 	handled = x86_pmu.handle_irq(args->regs);
 	if (!handled)
 		return NOTIFY_DONE;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 8fc2b2c..9607953 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -933,6 +933,16 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
+	/*
+	 * Some chipsets need to unmask the LVTPC in a particular spot
+	 * inside the nmi handler.  As a result, the unmasking was pushed
+	 * into all the nmi handlers.
+	 *
+	 * This handler doesn't seem to have any issues with the unmasking
+	 * so it was left at the top.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
+
 	intel_pmu_disable_all();
 	handled = intel_pmu_drain_bts_buffer();
 	status = intel_pmu_get_status();
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index c2520e1..60da195 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -950,11 +950,20 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 			p4_pmu_disable_event(event);
 	}
 
-	if (handled) {
-		/* p4 quirk: unmask it again */
-		apic_write(APIC_LVTPC, apic_read(APIC_LVTPC) & ~APIC_LVT_MASKED);
+	if (handled)
 		inc_irq_stat(apic_perf_irqs);
-	}
+
+	/*
+	 * When dealing with the unmasking of the LVTPC on P4 perf hw, it has
+	 * been observed that the OVF bit flag has to be cleared first _before_
+	 * the LVTPC can be unmasked.
+	 *
+	 * The reason is the NMI line will continue to be asserted while the OVF
+	 * bit is set.  This causes a second NMI to generate if the LVTPC is
+	 * unmasked before the OVF bit is cleared, leading to unknown NMI
+	 * messages.
+	 */
+	apic_write(APIC_LVTPC, APIC_DM_NMI);
 
 	return handled;
 }
-- 
1.7.4.2

