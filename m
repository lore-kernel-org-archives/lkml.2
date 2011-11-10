Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934498Ab1KJM6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 07:58:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757658Ab1KJM6N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 07:58:13 -0500
From: Gleb Natapov <gleb@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, avi@redhat.com, mtosatti@redhat.com,
        mingo@elte.hu, a.p.zijlstra@chello.nl, acme@ghostprotocols.net
Subject: [PATCHv3 07/10] perf, x86: expose perf capability to other modules.
Date: Thu, 10 Nov 2011 14:57:27 +0200
Message-Id: <1320929850-10480-8-git-send-email-gleb@redhat.com>
In-Reply-To: <1320929850-10480-1-git-send-email-gleb@redhat.com>
References: <1320929850-10480-1-git-send-email-gleb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KVM needs to know perf capability to decide which PMU it can expose to a
guest.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
---
 arch/x86/include/asm/perf_event.h |   15 +++++++++++++++
 arch/x86/kernel/cpu/perf_event.c  |   11 +++++++++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/perf_event.h b/arch/x86/include/asm/perf_event.h
index c6998bc..5487ad6 100644
--- a/arch/x86/include/asm/perf_event.h
+++ b/arch/x86/include/asm/perf_event.h
@@ -95,6 +95,15 @@ union cpuid10_edx {
 	unsigned int full;
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
 
 /*
  * Fixed-purpose performance events:
@@ -216,6 +225,7 @@ struct perf_guest_switch_msr {
 };
 
 extern struct perf_guest_switch_msr *perf_guest_get_msrs(int *nr);
+extern void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap);
 #else
 static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 {
@@ -223,6 +233,11 @@ static inline perf_guest_switch_msr *perf_guest_get_msrs(int *nr)
 	return NULL;
 }
 
+static inline void perf_get_x86_pmu_capability(struct x86_pmu_capability *cap)
+{
+	memset(cap, 0, sizeof(*cap));
+}
+
 static inline void perf_events_lapic_init(void)	{ }
 #endif
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 6408910..5af5996 100644
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
+	cap->events_mask = (unsigned int)x86_pmu.events_maskl;
+	cap->events_mask_len = x86_pmu.events_mask_len;
+}
+EXPORT_SYMBOL_GPL(perf_get_x86_pmu_capability);
-- 
1.7.7.1

