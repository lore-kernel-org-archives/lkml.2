Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752080Ab2JRXT5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:19:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:20461 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756594Ab2JRXTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:19:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="229462621"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/34] perf, x86: Support Haswell v4 LBR format
Date: Thu, 18 Oct 2012 16:19:16 -0700
Message-Id: <1350602382-12771-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Haswell has two additional LBR from flags for TSX: intx and abort, implemented
as a new v4 version of the PEBS record.

Handle those in and adjust the sign extension code to still correctly extend.
The flags are exported similarly in the LBR record to the existing misprediction
flag

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |   18 +++++++++++++++---
 include/linux/perf_event.h                 |    7 ++++++-
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index da02e9c..2af6695b 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -12,6 +12,7 @@ enum {
 	LBR_FORMAT_LIP		= 0x01,
 	LBR_FORMAT_EIP		= 0x02,
 	LBR_FORMAT_EIP_FLAGS	= 0x03,
+	LBR_FORMAT_EIP_FLAGS2	= 0x04,
 };
 
 /*
@@ -56,6 +57,8 @@ enum {
 	 LBR_FAR)
 
 #define LBR_FROM_FLAG_MISPRED  (1ULL << 63)
+#define LBR_FROM_FLAG_INTX     (1ULL << 62)
+#define LBR_FROM_FLAG_ABORT    (1ULL << 61)
 
 #define for_each_branch_sample_type(x) \
 	for ((x) = PERF_SAMPLE_BRANCH_USER; \
@@ -270,21 +273,30 @@ static void intel_pmu_lbr_read_64(struct cpu_hw_events *cpuc)
 
 	for (i = 0; i < x86_pmu.lbr_nr; i++) {
 		unsigned long lbr_idx = (tos - i) & mask;
-		u64 from, to, mis = 0, pred = 0;
+		u64 from, to, mis = 0, pred = 0, intx = 0, abort = 0;
 
 		rdmsrl(x86_pmu.lbr_from + lbr_idx, from);
 		rdmsrl(x86_pmu.lbr_to   + lbr_idx, to);
 
-		if (lbr_format == LBR_FORMAT_EIP_FLAGS) {
+		if (lbr_format == LBR_FORMAT_EIP_FLAGS ||
+		    lbr_format == LBR_FORMAT_EIP_FLAGS2) {
 			mis = !!(from & LBR_FROM_FLAG_MISPRED);
 			pred = !mis;
-			from = (u64)((((s64)from) << 1) >> 1);
+			if (lbr_format == LBR_FORMAT_EIP_FLAGS)
+				from = (u64)((((s64)from) << 1) >> 1);
+			else if (lbr_format == LBR_FORMAT_EIP_FLAGS2) {
+				intx = !!(from & LBR_FROM_FLAG_INTX);
+				abort = !!(from & LBR_FROM_FLAG_ABORT);
+				from = (u64)((((s64)from) << 3) >> 3);
+			}
 		}
 
 		cpuc->lbr_entries[i].from	= from;
 		cpuc->lbr_entries[i].to		= to;
 		cpuc->lbr_entries[i].mispred	= mis;
 		cpuc->lbr_entries[i].predicted	= pred;
+		cpuc->lbr_entries[i].intx	= intx;
+		cpuc->lbr_entries[i].abort	= abort;
 		cpuc->lbr_entries[i].reserved	= 0;
 	}
 	cpuc->lbr_stack.nr = i;
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 2e90235..0e528fc 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -74,13 +74,18 @@ struct perf_raw_record {
  *
  * support for mispred, predicted is optional. In case it
  * is not supported mispred = predicted = 0.
+ *
+ *     intx: running in a hardware transaction
+ *     abort: aborting a hardware transaction
  */
 struct perf_branch_entry {
 	__u64	from;
 	__u64	to;
 	__u64	mispred:1,  /* target mispredicted */
 		predicted:1,/* target predicted */
-		reserved:62;
+		intx:1,	    /* in transaction */
+		abort:1,    /* transaction abort */
+		reserved:60;
 };
 
 /*
-- 
1.7.7.6

