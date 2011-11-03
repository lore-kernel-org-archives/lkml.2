Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933528Ab1KCMe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 08:34:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755817Ab1KCMc1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 08:32:27 -0400
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: avi@redhat.com, mtosatti@redhat.com, linux-kernel@vger.kernel.org,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCH 6/9] perf: expose perf capability to other modules.
Date: Thu,  3 Nov 2011 14:31:35 +0200
Message-Id: <1320323498-10233-7-git-send-email-gleb@redhat.com>
In-Reply-To: <1320323498-10233-1-git-send-email-gleb@redhat.com>
References: <1320323498-10233-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM needs to know perf capability to decide which PMU it can expose to a
guest.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/perf_event.h      |   11 +++++++++++
 arch/x86/kernel/cpu/perf_event.c       |   11 +++++++++++
 arch/x86/kernel/cpu/perf_event.h       |    2 ++
 arch/x86/kernel/cpu/perf_event_intel.c |    3 +++
 4 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index f61c62f..7d7e57f 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -201,7 +201,18 @@ struct perf_guest_switch_msr {
 	u64 host, guest;
 };
 
+struct x86_pmu_capability {
+	int version;
+	int num_counters_gp;
+	int num_counters_fixed;
+	int bit_width_gp;
+	int bit_width_fixed;
+	unsigned int events_mask;
+	int events_mask_len;
+};
+
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 #else
 static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6408910..94ac9ca 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1570,3 +1570,14 @@ unsigned long perf_misc_flags(struct pt_regs *regs)
 
 	return misc;
 }
+
+void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
+{
+	cap->version = x86_pmu.version;
+	cap->num_counters_gp = x86_pmu.num_counters;
+	cap->num_counters_fixed = x86_pmu.num_counters_fixed;
+	cap->bit_width_gp = cap->bit_width_fixed = x86_pmu.cntval_bits;
+	cap->events_mask = x86_pmu.events_mask;
+	cap->events_mask_len = x86_pmu.events_mask_len;
+}
+EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
diff --git a/arch/x86/kernel/cpu/perf_event.h b/arch/x86/kernel/cpu/perf_event.h
index b9698d4..e9ed238 100644
--- a/arch/x86/kernel/cpu/perf_event.h
+++ b/arch/x86/kernel/cpu/perf_event.h
@@ -259,6 +259,8 @@ struct x86_pmu {
 	int		num_counters_fixed;
 	int		cntval_bits;
 	u64		cntval_mask;
+	u32		events_mask;
+	int		events_mask_len;
 	int		apic;
 	u64		max_period;
 	struct event_constraint *
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index e09ca20..64e5f35 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1580,6 +1580,8 @@ __init int intel_pmu_init(void)
 	x86_pmu.num_counters		= eax.split.num_counters;
 	x86_pmu.cntval_bits		= eax.split.bit_width;
 	x86_pmu.cntval_mask		= (1ULL << eax.split.bit_width) - 1;
+	x86_pmu.events_mask		= ebx;
+	x86_pmu.events_mask_len		= eax.split.mask_length;
 
 	/*
 	 * Quirk: v2 perfmon does not report fixed-purpose events, so
@@ -1651,6 +1653,7 @@ __init int intel_pmu_init(void)
 			 * architectural event which is often completely bogus:
 			 */
 			intel_perfmon_event_map[PERF_COUNT_HW_BRANCH_MISSES] = 0x7f89;
+			x86_pmu.events_mask &= ~0x40;
 
 			pr_cont("erratum AAJ80 worked around, ");
 		}
-- 
1.7.5.3

