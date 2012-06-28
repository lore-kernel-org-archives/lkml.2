Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab2F1QFD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 12:05:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:29549 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755414Ab2F1QFC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 12:05:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159287543"
From: Feng Tang <feng.tang@intel.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Feng Tang <feng.tang@intel.com>
Subject: [PATCH] perf, x86: Enabled PEBS event to be exported in a raw format
Date: Fri, 29 Jun 2012 00:00:50 +0800
Message-Id: <1340899250-26803-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for reporting PEBS records in a raw format that can
be then parsed by perf script.

This is roughly similar to the existing AMD IBS support.

This is mainly for advanced users and to experiment with
new usages. Widespread PEBS usages are expected to get higher
level interfaces over time, like the existing "precise ip" support.

[Small fix of adding "data.raw = &raw;", thanks to Andi, with this
patch I can test my perf script with pebs samples. - Feng]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 026373e..04d3ba9 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -552,6 +552,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	struct pebs_record_core *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
+	struct perf_raw_record raw;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
@@ -578,6 +579,12 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	else
 		regs.flags &= ~PERF_EFLAGS_EXACT;
 
+	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
+		raw.size = x86_pmu.pebs_record_size;
+		raw.data = __pebs;
+		data.raw = &raw;
+	}
+
 	if (has_branch_stack(event))
 		data.br_stack = &cpuc->lbr_stack;
 
-- 
1.7.1

