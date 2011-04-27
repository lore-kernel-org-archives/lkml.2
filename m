Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759222Ab1D0SeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 14:34:22 -0400
Received: from hera.kernel.org ([140.211.167.34]:57600 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756629Ab1D0SeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 14:34:20 -0400
Date: Wed, 27 Apr 2011 18:33:54 GMT
From: tip-bot for Don Zickus <dzickus@redhat.com>
Message-ID: <tip-2bce5daca28346f19c190dbdb5542c9fe3e8c6e6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        gorcunov@gmail.com, sruffell@digium.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sruffell@digium.com, gorcunov@gmail.com, tglx@linutronix.de,
        dzickus@redhat.com, mingo@elte.hu
In-Reply-To: <1303900353-10242-1-git-send-email-dzickus@redhat.com>
References: <1303900353-10242-1-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf, x86, nmi: Move LVT un-masking into irq handlers
Git-Commit-ID: 2bce5daca28346f19c190dbdb5542c9fe3e8c6e6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Apr 2011 18:33:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2bce5daca28346f19c190dbdb5542c9fe3e8c6e6
Gitweb:     http://git.kernel.org/tip/2bce5daca28346f19c190dbdb5542c9fe3e8c6e6
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Wed, 27 Apr 2011 06:32:33 -0400
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 27 Apr 2011 17:59:11 +0200

perf, x86, nmi: Move LVT un-masking into irq handlers

It was noticed that P4 machines were generating double NMIs for
each perf event.  These extra NMIs lead to 'Dazed and confused'
messages on the screen.

I tracked this down to a P4 quirk that said the overflow bit had
to be cleared before re-enabling the apic LVT mask.  My first
attempt was to move the un-masking inside the perf nmi handler
from before the chipset NMI handler to after.

This broke Nehalem boxes that seem to like the unmasking before
the counters themselves are re-enabled.

In order to keep this change simple for 2.6.39, I decided to
just simply move the apic LVT un-masking to the beginning of all
the chipset NMI handlers, with the exception of Pentium4's to
fix the double NMI issue.

Later on we can move the un-masking to later in the handlers to
save a number of 'extra' NMIs on those particular chipsets.

I tested this change on a P4 machine, an AMD machine, a Nehalem
box, and a core2quad box.  'perf top' worked correctly along
with various other small 'perf record' runs.  Anything high
stress breaks all the machines but that is a different problem.

Thanks to various people for testing different versions of this
patch.

Reported-and-tested-by: Shaun Ruffell <sruffell@digium.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Link: http://lkml.kernel.org/r/1303900353-10242-1-git-send-email-dzickus@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
CC: Cyrill Gorcunov <gorcunov@gmail.com>
---
 arch/x86/kernel/cpu/perf_event.c       |   12 ++++++++++--
 arch/x86/kernel/cpu/perf_event_intel.c |   10 ++++++++++
 arch/x86/kernel/cpu/perf_event_p4.c    |   17 +++++++++++++----
 3 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index fac0654..e638689 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1288,6 +1288,16 @@ static int x86_pmu_handle_irq(struct pt_regs *regs)
 
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
@@ -1374,8 +1384,6 @@ perf_event_nmi_handler(struct notifier_block *self,
 		return NOTIFY_DONE;
 	}
 
-	apic_write(APIC_LVTPC, APIC_DM_NMI);
-
 	handled = x86_pmu.handle_irq(args->regs);
 	if (!handled)
 		return NOTIFY_DONE;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 9ae4a2a..e61539b 100644
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
index d1f77e2..e93fcd5 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -950,11 +950,20 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 			x86_pmu_stop(event, 0);
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
