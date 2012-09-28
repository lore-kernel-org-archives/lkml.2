Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756167Ab2I1Ee0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:34:26 -0400
Received: from mga11.intel.com ([192.55.52.93]:59149 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392Ab2I1Eb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="227581577"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 24/31] perf, x86: Add the Haswell implementation of the generic transaction events
Date: Thu, 27 Sep 2012 21:31:29 -0700
Message-Id: <1348806696-31170-25-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Straight forward table mapping from the generic transactional memory events
to the Haswell TSX events.

One special case is that the abort-all events force PEBS with precise level
two. Without using eventingrip abort IPs are generally useless (you get
something after the abort). So we really want PEBS here for any
sampling. Since it was very unintuitive for users to do this manually
I just made this default.

To do this the mapping table sets a magic flag, that is later checked in
the event setup and forces the precise event. For counting events
PEBS is not forced.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   47 ++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 2c4cbf3..be0d3c8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -820,6 +820,38 @@ static __initconst const u64 atom_hw_cache_event_ids
  },
 };
 
+#define FORCE_PEBS (1ULL << 63)
+
+static u64 __initdata hsw_transaction_event_ids
+				[PERF_COUNT_HW_TRANSACTION_MAX]
+				[PERF_COUNT_HW_ABORT_MAX] =
+{
+	/* RTM_RETIRED.START */
+	[ PERF_COUNT_HW_TRANSACTION_START ]  = { 0x1c9 },
+	/* RTM_RETIRED.COMMIT */
+	[ PERF_COUNT_HW_TRANSACTION_COMMIT ] = { 0x2c9 },
+	[ PERF_COUNT_HW_TRANSACTION_ABORT ]  = {
+		/* RTM_RETIRED.ABORTED with pebs */
+		[ PERF_COUNT_HW_ABORT_ALL ]      = 0x4c9|FORCE_PEBS,
+		/* TX_MEM.ABORT_CONFLICT */
+		[ PERF_COUNT_HW_ABORT_CONFLICT ] = 0x154,
+		/* TX_MEM.ABORT_CAPACITY */
+		[ PERF_COUNT_HW_ABORT_CAPACITY ] = 0x254,
+	},
+	/* HLE_RETIRED.START */
+	[ PERF_COUNT_HW_ELISION_START ]  =     { 0x1c8 },
+	/* HLE_RETIRED.COMMIT */
+	[ PERF_COUNT_HW_ELISION_COMMIT ] =     { 0x2c8 },
+	[ PERF_COUNT_HW_ELISION_ABORT ]  = {
+		/* HLE_RETIRED.ABORTED with pebs */
+		[ PERF_COUNT_HW_ABORT_ALL ]      = 0x4c8|FORCE_PEBS,
+		/* TX_MEM.ABORT_CONFLICT */
+		[ PERF_COUNT_HW_ABORT_CONFLICT ] = 0x154,
+		/* TX_MEM.ABORT_CAPACITY */
+		[ PERF_COUNT_HW_ABORT_CAPACITY ] = 0x254,
+	}
+};
+
 static inline bool intel_pmu_needs_lbr_smpl(struct perf_event *event)
 {
 	/* user explicitly requested branch sampling */
@@ -1655,6 +1687,18 @@ static int hsw_hw_config(struct perf_event *event)
 			return -EIO;
 		event->hw.config |= HSW_INTX_CHECKPOINTED;
 	}
+
+	/*
+	 * Sampling transaction abort events work very poorly without
+	 * PEBS. So force it.
+	 */
+	if (event->attr.type == PERF_TYPE_HW_TRANSACTION &&
+	    (event->hw.config & FORCE_PEBS)) {
+		event->hw.config &= ~FORCE_PEBS;
+		if (is_sampling_event(event))
+			event->attr.precise_ip = 2;
+	}
+
 	return 0;
 }
 
@@ -2165,6 +2209,9 @@ __init int intel_pmu_init(void)
 		x86_pmu.hw_config = hsw_hw_config;
 		x86_pmu.get_event_constraints = hsw_get_event_constraints;
 		x86_pmu.memory_lat_events = intel_hsw_memory_latency_events;
+		memcpy(hw_transaction_event_ids, hsw_transaction_event_ids,
+		       sizeof(hsw_transaction_event_ids));
+
 		pr_cont("Haswell events, ");
 		break;
 
-- 
1.7.7.6

