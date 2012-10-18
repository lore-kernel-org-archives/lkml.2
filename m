Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932515Ab2JRXUJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 19:20:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:3930 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756463Ab2JRXUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 19:20:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,609,1344236400"; 
   d="scan'208";a="207876589"
From: Andi Kleen <andi@firstfloor.org>
To: a.p.zijlstra@chello.nl
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, acme@redhat.com,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>, avi@redhat.com
Subject: [PATCH 06/34] perf, kvm: Support the intx/intx_cp modifiers in KVM arch perfmon emulation v2
Date: Thu, 18 Oct 2012 16:19:14 -0700
Message-Id: <1350602382-12771-7-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This is not arch perfmon, but older CPUs will just ignore it. This makes
it possible to do at least some TSX measurements from a KVM guest

Cc: avi@redhat.com
v2: Various fixes to address review feedback
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kvm/pmu.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index cfc258a..81c1632 100644
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
@@ -173,6 +173,11 @@ static void reprogram_counter(struct kvm_pmc *pmc, u32 type,
 		.exclude_kernel = exclude_kernel,
 		.config = config,
 	};
+	/* Will be ignored on CPUs that don't support this. */
+	if (intx)
+		attr.config |= HSW_INTX;
+	if (intx_cp)
+		attr.config |= HSW_INTX_CHECKPOINTED;
 
 	attr.sample_period = (-pmc->counter) & pmc_bitmask(pmc);
 
@@ -239,7 +244,9 @@ static void reprogram_gp_counter(struct kvm_pmc *pmc, u64 eventsel)
 	reprogram_counter(pmc, type, config,
 			!(eventsel & ARCH_PERFMON_EVENTSEL_USR),
 			!(eventsel & ARCH_PERFMON_EVENTSEL_OS),
-			eventsel & ARCH_PERFMON_EVENTSEL_INT);
+			eventsel & ARCH_PERFMON_EVENTSEL_INT,
+			(eventsel & HSW_INTX),
+			(eventsel & HSW_INTX_CHECKPOINTED));
 }
 
 static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
@@ -256,7 +263,7 @@ static void reprogram_fixed_counter(struct kvm_pmc *pmc, u8 en_pmi, int idx)
 			arch_events[fixed_pmc_events[idx]].event_type,
 			!(en & 0x2), /* exclude user */
 			!(en & 0x1), /* exclude kernel */
-			pmi);
+			pmi, false, false);
 }
 
 static inline u8 fixed_en_pmi(u64 ctrl, int idx)
@@ -400,7 +407,7 @@ int kvm_pmu_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data)
 		} else if ((pmc = get_gp_pmc(pmu, index, MSR_P6_EVNTSEL0))) {
 			if (data == pmc->eventsel)
 				return 0;
-			if (!(data & 0xffffffff00200000ull)) {
+			if (!(data & 0xfffffffc00200000ull)) {
 				reprogram_gp_counter(pmc, data);
 				return 0;
 			}
-- 
1.7.7.6

