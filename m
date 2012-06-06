Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294Ab2FFA5G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 20:57:06 -0400
Received: from mga02.intel.com ([134.134.136.20]:2175 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753019Ab2FFA5C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 20:57:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="148674930"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: eranian@google.com, a.p.zijlstra@chello.nl,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/5] perf, x86: Don't assume there can be only 4 PEBS events
Date: Tue,  5 Jun 2012 17:56:48 -0700
Message-Id: <1338944211-28275-2-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On Sandy Bridge in non HT mode there are 8 counters available. Since every
counter can write a PEBS record assuming there are 4 max is incorrect. Use
the reported counter number -- with an upper limit for a static array -- instead.

Also I made the warning messages a bit more informational.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event.h          |    3 ++-
 arch/x86/kernel/cpu/perf_event_intel.c    |    2 ++
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    8 ++++----
 3 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index cdddcef..43cfed2 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -57,7 +57,7 @@ struct amd_nb {
 };
 
 /* The maximal number of PEBS events: */
-#define MAX_PEBS_EVENTS		4
+#define MAX_PEBS_EVENTS		8
 
 /*
  * A debug store configuration.
@@ -365,6 +365,7 @@ struct x86_pmu {
 	int		pebs_record_size;
 	void		(*drain_pebs)(struct pt_regs *regs);
 	struct event_constraint *pebs_constraints;
+	int 		max_pebs_events;
 
 	/*
 	 * Intel LBR
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2e40391..71b8de5 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1732,6 +1732,8 @@ __init int intel_pmu_init(void)
 	x86_pmu.events_maskl		= ebx.full;
 	x86_pmu.events_mask_len		= eax.split.mask_length;
 
+	x86_pmu.max_pebs_events		= min_t(unsigned, MAX_PEBS_EVENTS, x86_pmu.num_counters);
+
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
 	 * assume at least 3 events:
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 5a3edc2..0042942 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -627,7 +627,7 @@ static void intel_pmu_drain_pebs_core(struct pt_regs *iregs)
 	 * Should not happen, we program the threshold at 1 and do not
 	 * set a reset value.
 	 */
-	WARN_ON_ONCE(n > 1);
+	WARN_ONCE(n > 1, "bad leftover pebs %d\n", n);
 	at += n - 1;
 
 	__intel_pmu_pebs_event(event, iregs, at);
@@ -658,10 +658,10 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 	 * Should not happen, we program the threshold at 1 and do not
 	 * set a reset value.
 	 */
-	WARN_ON_ONCE(n > MAX_PEBS_EVENTS);
+	WARN_ONCE(n > x86_pmu.max_pebs_events, "Unexpected number of pebs records %d\n", n);
 
 	for ( ; at < top; at++) {
-		for_each_set_bit(bit, (unsigned long *)&at->status, MAX_PEBS_EVENTS) {
+		for_each_set_bit(bit, (unsigned long *)&at->status, x86_pmu.max_pebs_events) {
 			event = cpuc->events[bit];
 			if (!test_bit(bit, cpuc->active_mask))
 				continue;
@@ -677,7 +677,7 @@ static void intel_pmu_drain_pebs_nhm(struct pt_regs *iregs)
 			break;
 		}
 
-		if (!event || bit >= MAX_PEBS_EVENTS)
+		if (!event || bit >= x86_pmu.max_pebs_events)
 			continue;
 
 		__intel_pmu_pebs_event(event, iregs, at);
-- 
1.7.7.6

