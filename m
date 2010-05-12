Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757032Ab0ELRm6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:42:58 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:62905 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756940Ab0ELRmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:42:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=qztshKMTlK7MHP0gN1HRb6gdGwTCDMOy8pq5SLbM+caMk5MZ2NfIIjMrwwNIE/M+jn
         HJk3NOg1GNQRZ+Hh7RfwDI00sDkbt0fo0sOz+JIrZJ0qgS8oiX+QNWK0qhKuiH1LrDs8
         wFESR40e99TyU6syi5zD293va2Ehdqo1IxPsY=
Date: Wed, 12 May 2010 21:42:42 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH -tip] x86,perf: P4 PMU -- use hash for p4_get_escr_idx v2
Message-ID: <20100512174242.GA5190@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linear search over all p4 MSRs should be fine if only
we would not use it in events scheduling routine which
is pretty time crititcal. Lets use hashes. It should speed
scheduling up significantly.

v2: Steven proposed to use more gentle approach than issue
    BUG on error, so we use WARN_ONCE now

CC: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>
CC: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/cpu/perf_event_p4.c |  126 ++++++++++++++++++++----------------
 1 file changed, 71 insertions(+), 55 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -668,66 +668,80 @@ static void p4_pmu_swap_config_ts(struct
 	}
 }
 
-/* ESCRs are not sequential in memory so we need a map */
-static const unsigned int p4_escr_map[ARCH_P4_TOTAL_ESCR] = {
-	MSR_P4_ALF_ESCR0,	/*  0 */
-	MSR_P4_ALF_ESCR1,	/*  1 */
-	MSR_P4_BPU_ESCR0,	/*  2 */
-	MSR_P4_BPU_ESCR1,	/*  3 */
-	MSR_P4_BSU_ESCR0,	/*  4 */
-	MSR_P4_BSU_ESCR1,	/*  5 */
-	MSR_P4_CRU_ESCR0,	/*  6 */
-	MSR_P4_CRU_ESCR1,	/*  7 */
-	MSR_P4_CRU_ESCR2,	/*  8 */
-	MSR_P4_CRU_ESCR3,	/*  9 */
-	MSR_P4_CRU_ESCR4,	/* 10 */
-	MSR_P4_CRU_ESCR5,	/* 11 */
-	MSR_P4_DAC_ESCR0,	/* 12 */
-	MSR_P4_DAC_ESCR1,	/* 13 */
-	MSR_P4_FIRM_ESCR0,	/* 14 */
-	MSR_P4_FIRM_ESCR1,	/* 15 */
-	MSR_P4_FLAME_ESCR0,	/* 16 */
-	MSR_P4_FLAME_ESCR1,	/* 17 */
-	MSR_P4_FSB_ESCR0,	/* 18 */
-	MSR_P4_FSB_ESCR1,	/* 19 */
-	MSR_P4_IQ_ESCR0,	/* 20 */
-	MSR_P4_IQ_ESCR1,	/* 21 */
-	MSR_P4_IS_ESCR0,	/* 22 */
-	MSR_P4_IS_ESCR1,	/* 23 */
-	MSR_P4_ITLB_ESCR0,	/* 24 */
-	MSR_P4_ITLB_ESCR1,	/* 25 */
-	MSR_P4_IX_ESCR0,	/* 26 */
-	MSR_P4_IX_ESCR1,	/* 27 */
-	MSR_P4_MOB_ESCR0,	/* 28 */
-	MSR_P4_MOB_ESCR1,	/* 29 */
-	MSR_P4_MS_ESCR0,	/* 30 */
-	MSR_P4_MS_ESCR1,	/* 31 */
-	MSR_P4_PMH_ESCR0,	/* 32 */
-	MSR_P4_PMH_ESCR1,	/* 33 */
-	MSR_P4_RAT_ESCR0,	/* 34 */
-	MSR_P4_RAT_ESCR1,	/* 35 */
-	MSR_P4_SAAT_ESCR0,	/* 36 */
-	MSR_P4_SAAT_ESCR1,	/* 37 */
-	MSR_P4_SSU_ESCR0,	/* 38 */
-	MSR_P4_SSU_ESCR1,	/* 39 */
-	MSR_P4_TBPU_ESCR0,	/* 40 */
-	MSR_P4_TBPU_ESCR1,	/* 41 */
-	MSR_P4_TC_ESCR0,	/* 42 */
-	MSR_P4_TC_ESCR1,	/* 43 */
-	MSR_P4_U2L_ESCR0,	/* 44 */
-	MSR_P4_U2L_ESCR1,	/* 45 */
+/*
+ * ESCR address hashing is tricky, ESCRs are not sequential
+ * in memory but all starts from MSR_P4_BSU_ESCR0 (0x03e0) and
+ * the metric between any ESCRs is laid in range [0xa0,0xe1]
+ *
+ * so we make ~70% filled hashtable
+ */
+
+#define P4_ESCR_MSR_BASE		0x000003a0
+#define P4_ESCR_MSR_MAX			0x000003e1
+#define P4_ESCR_MSR_TABLE_SIZE		(P4_ESCR_MSR_MAX - P4_ESCR_MSR_BASE + 1)
+#define P4_ESCR_MSR_IDX(msr)		(msr - P4_ESCR_MSR_BASE)
+#define P4_ESCR_MSR_TABLE_ENTRY(msr)	[P4_ESCR_MSR_IDX(msr)] = msr
+
+static const unsigned int p4_escr_table[P4_ESCR_MSR_TABLE_SIZE] = {
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ALF_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ALF_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BPU_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BPU_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BSU_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_BSU_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR2),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR3),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR4),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_CRU_ESCR5),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_DAC_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_DAC_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FIRM_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FIRM_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FLAME_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FLAME_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FSB_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_FSB_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IQ_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IQ_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IS_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IS_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ITLB_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_ITLB_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IX_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_IX_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MOB_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MOB_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MS_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_MS_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_PMH_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_PMH_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_RAT_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_RAT_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SAAT_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SAAT_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SSU_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_SSU_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TBPU_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TBPU_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TC_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_TC_ESCR1),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_U2L_ESCR0),
+	P4_ESCR_MSR_TABLE_ENTRY(MSR_P4_U2L_ESCR1),
 };
 
 static int p4_get_escr_idx(unsigned int addr)
 {
-	unsigned int i;
+	unsigned int idx = P4_ESCR_MSR_IDX(addr);
 
-	for (i = 0; i < ARRAY_SIZE(p4_escr_map); i++) {
-		if (addr == p4_escr_map[i])
-			return i;
+	if (unlikely(idx >= P4_ESCR_MSR_TABLE_SIZE ||
+			!p4_escr_table[idx])) {
+		WARN_ONCE(1, "P4 PMU: Wrong address passed: %x\n", addr);
+		return -1;
 	}
 
-	return -1;
+	return idx;
 }
 
 static int p4_next_cntr(int thread, unsigned long *used_mask,
@@ -747,7 +761,7 @@ static int p4_next_cntr(int thread, unsi
 static int p4_pmu_schedule_events(struct cpu_hw_events *cpuc, int n, int *assign)
 {
 	unsigned long used_mask[BITS_TO_LONGS(X86_PMC_IDX_MAX)];
-	unsigned long escr_mask[BITS_TO_LONGS(ARCH_P4_TOTAL_ESCR)];
+	unsigned long escr_mask[BITS_TO_LONGS(P4_ESCR_MSR_TABLE_SIZE)];
 	int cpu = raw_smp_processor_id();
 	struct hw_perf_event *hwc;
 	struct p4_event_bind *bind;
@@ -755,7 +769,7 @@ static int p4_pmu_schedule_events(struct
 	int cntr_idx, escr_idx;
 
 	bitmap_zero(used_mask, X86_PMC_IDX_MAX);
-	bitmap_zero(escr_mask, ARCH_P4_TOTAL_ESCR);
+	bitmap_zero(escr_mask, P4_ESCR_MSR_TABLE_SIZE);
 
 	for (i = 0, num = n; i < n; i++, num--) {
 
@@ -763,6 +777,8 @@ static int p4_pmu_schedule_events(struct
 		thread = p4_ht_thread(cpu);
 		bind = p4_config_get_bind(hwc->config);
 		escr_idx = p4_get_escr_idx(bind->escr_msr[thread]);
+		if (unlikely(escr_idx == -1))
+			goto done;
 
 		if (hwc->idx != -1 && !p4_should_swap_ts(hwc->config, cpu)) {
 			cntr_idx = hwc->idx;
