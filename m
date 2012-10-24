Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156Ab2JXKCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 06:02:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55117 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755504Ab2JXKCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 06:02:05 -0400
Date: Wed, 24 Oct 2012 03:00:37 -0700
From: tip-bot for Vince Weaver <vincent.weaver@maine.edu>
Message-ID: <tip-e09df47885d767e418902067ce1885aafa3b27db@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        vincent.weaver@maine.edu, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        vincent.weaver@maine.edu, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <alpine.DEB.2.02.1210191730080.14552@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.02.1210191730080.14552@vincent-weaver-1.um.maine.edu>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Update/fix generic events on P6 PMU
Git-Commit-ID: e09df47885d767e418902067ce1885aafa3b27db
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 24 Oct 2012 03:00:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e09df47885d767e418902067ce1885aafa3b27db
Gitweb:     http://git.kernel.org/tip/e09df47885d767e418902067ce1885aafa3b27db
Author:     Vince Weaver <vincent.weaver@maine.edu>
AuthorDate: Fri, 19 Oct 2012 17:31:54 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Oct 2012 10:31:58 +0200

perf/x86: Update/fix generic events on P6 PMU

This patch updates the generic events on p6, including some new
extended cache events.

Values for these events were taken from the equivelant PAPI
predefined events.

Tested on a Pentium II.

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1210191730080.14552@vincent-weaver-1.um.maine.edu
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_p6.c |  111 ++++++++++++++++++++++++++++++++--
 1 files changed, 104 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index 0ff5f7f..9582fcb 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -8,13 +8,106 @@
  */
 static const u64 p6_perfmon_event_map[] =
 {
-  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,
-  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,
-  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,
-  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,
-  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,
-  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,
-  [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,
+  [PERF_COUNT_HW_CPU_CYCLES]		= 0x0079,	/* CPU_CLK_UNHALTED */
+  [PERF_COUNT_HW_INSTRUCTIONS]		= 0x00c0,	/* INST_RETIRED     */
+  [PERF_COUNT_HW_CACHE_REFERENCES]	= 0x0f2e,	/* L2_RQSTS:M:E:S:I */
+  [PERF_COUNT_HW_CACHE_MISSES]		= 0x012e,	/* L2_RQSTS:I       */
+  [PERF_COUNT_HW_BRANCH_INSTRUCTIONS]	= 0x00c4,	/* BR_INST_RETIRED  */
+  [PERF_COUNT_HW_BRANCH_MISSES]		= 0x00c5,	/* BR_MISS_PRED_RETIRED */
+  [PERF_COUNT_HW_BUS_CYCLES]		= 0x0062,	/* BUS_DRDY_CLOCKS  */
+  [PERF_COUNT_HW_STALLED_CYCLES_FRONTEND] = 0x00a2,	/* RESOURCE_STALLS  */
+
+};
+
+static __initconst u64 p6_hw_cache_event_ids
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(L1D) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0043,	/* DATA_MEM_REFS       */
+                [ C(RESULT_MISS)   ] = 0x0045,	/* DCU_LINES_IN        */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0x0f29,	/* L2_LD:M:E:S:I       */
+	},
+        [ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+        },
+ },
+ [ C(L1I ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080,	/* IFU_IFETCH         */
+		[ C(RESULT_MISS)   ] = 0x0f28,	/* L2_IFETCH:M:E:S:I  */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0x0025,	/* L2_M_LINES_INM     */
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(DTLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0043,	/* DATA_MEM_REFS      */
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0,
+		[ C(RESULT_MISS)   ] = 0,
+	},
+ },
+ [ C(ITLB) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x0080,	/* IFU_IFETCH         */
+		[ C(RESULT_MISS)   ] = 0x0085,	/* ITLB_MISS          */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+ [ C(BPU ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x00c4,	/* BR_INST_RETIRED      */
+		[ C(RESULT_MISS)   ] = 0x00c5,	/* BR_MISS_PRED_RETIRED */
+        },
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
 };
 
 static u64 p6_pmu_event_map(int hw_event)
@@ -158,5 +251,9 @@ __init int p6_pmu_init(void)
 
 	x86_pmu = p6_pmu;
 
+	memcpy(hw_cache_event_ids, p6_hw_cache_event_ids,
+		sizeof(hw_cache_event_ids));
+
+
 	return 0;
 }
