Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756601Ab2I1EiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 00:38:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:54227 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387Ab2I1Eby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 00:31:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,498,1344236400"; 
   d="scan'208";a="198218540"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, a.p.zijlstra@chello.nl, eranian@google.com,
        acme@redhat.com, Andi Kleen <ak@linux.intel.com>, avi@redhat.com
Subject: [PATCH 09/31] perf, kvm: Support :t and :c perf modifiers in KVM arch perfmon emulation
Date: Thu, 27 Sep 2012 21:31:14 -0700
Message-Id: <1348806696-31170-10-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is not arch perfmon, but older CPUs will just ignore it. This makes
it possible to do at least some TSX measurements from a KVM guest

Cc: avi@redhat.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/perf_event_intel.c |    3 ++-
 arch/x86/kvm/pmu.c                     |   10 +++++++---
 2 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 7dab353..cd48669 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1631,7 +1631,8 @@ static int hsw_hw_config(struct perf_event *event)
 	return 0;
 }
 
-static struct event_constraint counter2_constraint = EVENT_CONSTRAINT(0, 0x4, 0);
+static struct event_constraint counter2_constraint = 
+			EVENT_CONSTRAINT(0, 0x4, 0);
 
 static struct event_constraint *
 hsw_get_event_constraints(struct cpu_hw_events *cpuc, struct perf_event *event)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 9b7ec11..03ba87b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -160,7 +160,7 @@ static void stop_counter(struct kvm_pmc *pmc)
 
 static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		unsigned config, bool exclude_user, bool exclude_kernel,
-		bool intr)
+		bool intr, bool intx, bool intx_cp)
 {
 	struct perf_event *event;
 	struct perf_event_attr attr = {
@@ -172,6 +172,8 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_user = exclude_user,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
+		.intx = intx,
+		.intx_checkpointed = intx_cp
 	};
 
 	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
@@ -239,7 +241,9 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	reprogram_counter(pmc, type, config,
 			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			eventsel & ARCH_PERFMON_EVENTSEL_INT);
+			eventsel & ARCH_PERFMON_EVENTSEL_INT,
+			!!(eventsel & HSW_INTX),
+			!!(eventsel & HSW_INTX_CHECKPOINTED));
 }
 
 static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
@@ -256,7 +260,7 @@ static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
 			arch_events[fixed_pmc_events[idx]].event_type,
 			!(en & 0x2), /* exclude user */
 			!(en & 0x1), /* exclude kernel */
-			pmi);
+			pmi, false, false);
 }
 
 static inline u8 fixed_en_pmi(u64 ctrl, int idx)
-- 
1.7.7.6

