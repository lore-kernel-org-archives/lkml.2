Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932615Ab2JBXyS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 19:54:18 -0400
Received: from mga14.intel.com ([143.182.124.37]:37543 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756812Ab2JBXtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 19:49:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,525,1344236400"; 
   d="scan'208";a="199832066"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, x86@vger.kernel.org, eranian@google.com, jolsa@redhat.com,
        a.p.zijlstra@chello.nl, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 05/31] perf, x86: Report PEBS event in a raw format
Date: Tue,  2 Oct 2012 16:48:25 -0700
Message-Id: <1349221731-15665-6-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
References: <1349221731-15665-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Add support for reporting PEBS records in a raw format that can
be then parsed by perf script.

We exposed most of the Haswell PEBS fields in a generic way
in this patchkit:
- Aborted cycles is in weight
- Memory latency is in weight
- DataLA is in address
- EventingRIP is used for precise ip
- tsx_tuning and some bits of the abort code in RAX are
mapped to transaction flags

Left over are the general registers. We need them for some analysis
too: for example for loop trip count and string instruction trip
count sampling.

There isn't really any good way to generalize general registers.
Obviously they are different for every architecture.

So patch exports the RAW PEBS record when requested.

With the new perf script infrastructure that was recently added
it is reasonably easy and clean to process with script.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 91c2ab7..5d3d6be 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -600,6 +600,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	struct pebs_record_core *pebs = __pebs;
 	struct perf_sample_data data;
 	struct pt_regs regs;
+	struct perf_raw_record raw;
 
 	if (!intel_pmu_save_and_restart(event))
 		return;
@@ -630,6 +631,12 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
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
1.7.7.6

