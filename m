Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab2EIObF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:31:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41037 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758108Ab2EIObC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:31:02 -0400
Date: Wed, 9 May 2012 07:30:45 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-fd0d000b2c34aa43d4e92dcf0dfaeda7e123008a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        robert.richter@amd.com, a.p.zijlstra@chello.nl, tglx@linutronix.de
In-Reply-To: <1333390758-10893-3-git-send-email-robert.richter@amd.com>
References: <1333390758-10893-3-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Pass last sampling period to perf_sample_data_init()
Git-Commit-ID: fd0d000b2c34aa43d4e92dcf0dfaeda7e123008a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:30:51 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd0d000b2c34aa43d4e92dcf0dfaeda7e123008a
Gitweb:     http://git.kernel.org/tip/fd0d000b2c34aa43d4e92dcf0dfaeda7e123008a
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Mon, 2 Apr 2012 20:19:08 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:23:12 +0200

perf: Pass last sampling period to perf_sample_data_init()

We always need to pass the last sample period to
perf_sample_data_init(), otherwise the event distribution will be
wrong. Thus, modifiyng the function interface with the required period
as argument. So basically a pattern like this:

        perf_sample_data_init(&data, ~0ULL);
        data.period = event->hw.last_period;

will now be like that:

        perf_sample_data_init(&data, ~0ULL, event->hw.last_period);

Avoids unininitialized data.period and simplifies code.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333390758-10893-3-git-send-email-robert.richter@amd.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/alpha/kernel/perf_event.c            |    3 +--
 arch/arm/kernel/perf_event_v6.c           |    4 +---
 arch/arm/kernel/perf_event_v7.c           |    4 +---
 arch/arm/kernel/perf_event_xscale.c       |    8 ++------
 arch/mips/kernel/perf_event_mipsxx.c      |    2 +-
 arch/powerpc/perf/core-book3s.c           |    3 +--
 arch/powerpc/perf/core-fsl-emb.c          |    3 +--
 arch/sparc/kernel/perf_event.c            |    4 +---
 arch/x86/kernel/cpu/perf_event.c          |    4 +---
 arch/x86/kernel/cpu/perf_event_amd_ibs.c  |    3 +--
 arch/x86/kernel/cpu/perf_event_intel.c    |    4 +---
 arch/x86/kernel/cpu/perf_event_intel_ds.c |    6 ++----
 arch/x86/kernel/cpu/perf_event_p4.c       |    6 +++---
 include/linux/perf_event.h                |    5 ++++-
 kernel/events/core.c                      |    9 ++++-----
 15 files changed, 25 insertions(+), 43 deletions(-)

diff --git a/arch/alpha/kernel/perf_event.c b/arch/alpha/kernel/perf_event.c
index 0dae252..d821b17 100644
--- a/arch/alpha/kernel/perf_event.c
+++ b/arch/alpha/kernel/perf_event.c
@@ -824,7 +824,6 @@ static void alpha_perf_event_irq_handler(unsigned long la_ptr,
 
 	idx = la_ptr;
 
-	perf_sample_data_init(&data, 0);
 	for (j = 0; j < cpuc->n_events; j++) {
 		if (cpuc->current_idx[j] == idx)
 			break;
@@ -848,7 +847,7 @@ static void alpha_perf_event_irq_handler(unsigned long la_ptr,
 
 	hwc = &event->hw;
 	alpha_perf_event_update(event, hwc, idx, alpha_pmu->pmc_max_period[idx]+1);
-	data.period = event->hw.last_period;
+	perf_sample_data_init(&data, 0, hwc->last_period);
 
 	if (alpha_perf_event_set_period(event, hwc, idx)) {
 		if (perf_event_overflow(event, &data, regs)) {
diff --git a/arch/arm/kernel/perf_event_v6.c b/arch/arm/kernel/perf_event_v6.c
index b78af0c..ab627a7 100644
--- a/arch/arm/kernel/perf_event_v6.c
+++ b/arch/arm/kernel/perf_event_v6.c
@@ -489,8 +489,6 @@ armv6pmu_handle_irq(int irq_num,
 	 */
 	armv6_pmcr_write(pmcr);
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx < cpu_pmu->num_events; ++idx) {
 		struct perf_event *event = cpuc->events[idx];
@@ -509,7 +507,7 @@ armv6pmu_handle_irq(int irq_num,
 
 		hwc = &event->hw;
 		armpmu_event_update(event, hwc, idx);
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, hwc->last_period);
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 00755d8..d3c5360 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -1077,8 +1077,6 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 	 */
 	regs = get_irq_regs();
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx < cpu_pmu->num_events; ++idx) {
 		struct perf_event *event = cpuc->events[idx];
@@ -1097,7 +1095,7 @@ static irqreturn_t armv7pmu_handle_irq(int irq_num, void *dev)
 
 		hwc = &event->hw;
 		armpmu_event_update(event, hwc, idx);
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, hwc->last_period);
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
diff --git a/arch/arm/kernel/perf_event_xscale.c b/arch/arm/kernel/perf_event_xscale.c
index 71a21e6..e34e725 100644
--- a/arch/arm/kernel/perf_event_xscale.c
+++ b/arch/arm/kernel/perf_event_xscale.c
@@ -248,8 +248,6 @@ xscale1pmu_handle_irq(int irq_num, void *dev)
 
 	regs = get_irq_regs();
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx < cpu_pmu->num_events; ++idx) {
 		struct perf_event *event = cpuc->events[idx];
@@ -263,7 +261,7 @@ xscale1pmu_handle_irq(int irq_num, void *dev)
 
 		hwc = &event->hw;
 		armpmu_event_update(event, hwc, idx);
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, hwc->last_period);
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
@@ -588,8 +586,6 @@ xscale2pmu_handle_irq(int irq_num, void *dev)
 
 	regs = get_irq_regs();
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 	for (idx = 0; idx < cpu_pmu->num_events; ++idx) {
 		struct perf_event *event = cpuc->events[idx];
@@ -603,7 +599,7 @@ xscale2pmu_handle_irq(int irq_num, void *dev)
 
 		hwc = &event->hw;
 		armpmu_event_update(event, hwc, idx);
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, hwc->last_period);
 		if (!armpmu_event_set_period(event, hwc, idx))
 			continue;
 
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 811084f..ab73fa2 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -1325,7 +1325,7 @@ static int mipsxx_pmu_handle_shared_irq(void)
 
 	regs = get_irq_regs();
 
-	perf_sample_data_init(&data, 0);
+	perf_sample_data_init(&data, 0, 0);
 
 	switch (counters) {
 #define HANDLE_COUNTER(n)						\
diff --git a/arch/powerpc/perf/core-book3s.c b/arch/powerpc/perf/core-book3s.c
index 02aee03..8f84bcb 100644
--- a/arch/powerpc/perf/core-book3s.c
+++ b/arch/powerpc/perf/core-book3s.c
@@ -1299,8 +1299,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	if (record) {
 		struct perf_sample_data data;
 
-		perf_sample_data_init(&data, ~0ULL);
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, ~0ULL, event->hw.last_period);
 
 		if (event->attr.sample_type & PERF_SAMPLE_ADDR)
 			perf_get_data_addr(regs, &data.addr);
diff --git a/arch/powerpc/perf/core-fsl-emb.c b/arch/powerpc/perf/core-fsl-emb.c
index 0a6d2a9..106c533 100644
--- a/arch/powerpc/perf/core-fsl-emb.c
+++ b/arch/powerpc/perf/core-fsl-emb.c
@@ -613,8 +613,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	if (record) {
 		struct perf_sample_data data;
 
-		perf_sample_data_init(&data, 0);
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, event->hw.last_period);
 
 		if (perf_event_overflow(event, &data, regs))
 			fsl_emb_pmu_stop(event, 0);
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 28559ce..5713957 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -1296,8 +1296,6 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 
 	regs = args->regs;
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	/* If the PMU has the TOE IRQ enable bits, we need to do a
@@ -1321,7 +1319,7 @@ static int __kprobes perf_event_nmi_handler(struct notifier_block *self,
 		if (val & (1ULL << 31))
 			continue;
 
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, hwc->last_period);
 		if (!sparc_perf_event_set_period(event, hwc, idx))
 			continue;
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index e33e9cf..e049d6d 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1183,8 +1183,6 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	/*
@@ -1219,7 +1217,7 @@ int x86_pmu_handle_irq(struct pt_regs *regs)
 		 * event overflow
 		 */
 		handled++;
-		data.period	= event->hw.last_period;
+		perf_sample_data_init(&data, 0, event->hw.last_period);
 
 		if (!x86_perf_event_set_period(event))
 			continue;
diff --git a/arch/x86/kernel/cpu/perf_event_amd_ibs.c b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
index c8f69be..2317228 100644
--- a/arch/x86/kernel/cpu/perf_event_amd_ibs.c
+++ b/arch/x86/kernel/cpu/perf_event_amd_ibs.c
@@ -398,8 +398,7 @@ static int perf_ibs_handle_irq(struct perf_ibs *perf_ibs, struct pt_regs *iregs)
 	}
 
 	perf_ibs_event_update(perf_ibs, event, config);
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
+	perf_sample_data_init(&data, 0, hwc->last_period);
 
 	if (event->attr.sample_type & PERF_SAMPLE_RAW) {
 		ibs_data.caps = ibs_caps;
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 26b3e2f..166546e 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -1027,8 +1027,6 @@ static int intel_pmu_handle_irq(struct pt_regs *regs)
 	u64 status;
 	int handled;
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	/*
@@ -1082,7 +1080,7 @@ again:
 		if (!intel_pmu_save_and_restart(event))
 			continue;
 
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, event->hw.last_period);
 
 		if (has_branch_stack(event))
 			data.br_stack = &cpuc->lbr_stack;
diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 7f64df1..5a3edc2 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -316,8 +316,7 @@ int intel_pmu_drain_bts_buffer(void)
 
 	ds->bts_index = ds->bts_buffer_base;
 
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
+	perf_sample_data_init(&data, 0, event->hw.last_period);
 	regs.ip     = 0;
 
 	/*
@@ -564,8 +563,7 @@ static void __intel_pmu_pebs_event(struct perf_event *event,
 	if (!intel_pmu_save_and_restart(event))
 		return;
 
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
+	perf_sample_data_init(&data, 0, event->hw.last_period);
 
 	/*
 	 * We use the interrupt regs as a base because the PEBS record
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index a2dfacf..47124a7 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -1005,8 +1005,6 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 	int idx, handled = 0;
 	u64 val;
 
-	perf_sample_data_init(&data, 0);
-
 	cpuc = &__get_cpu_var(cpu_hw_events);
 
 	for (idx = 0; idx < x86_pmu.num_counters; idx++) {
@@ -1034,10 +1032,12 @@ static int p4_pmu_handle_irq(struct pt_regs *regs)
 		handled += overflow;
 
 		/* event overflow for sure */
-		data.period = event->hw.last_period;
+		perf_sample_data_init(&data, 0, hwc->last_period);
 
 		if (!x86_perf_event_set_period(event))
 			continue;
+
+
 		if (perf_event_overflow(event, &data, regs))
 			x86_pmu_stop(event, 0);
 	}
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ddbb6a9..f325786 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -1132,11 +1132,14 @@ struct perf_sample_data {
 	struct perf_branch_stack	*br_stack;
 };
 
-static inline void perf_sample_data_init(struct perf_sample_data *data, u64 addr)
+static inline void perf_sample_data_init(struct perf_sample_data *data,
+					 u64 addr, u64 period)
 {
+	/* remaining struct members initialized in perf_prepare_sample() */
 	data->addr = addr;
 	data->raw  = NULL;
 	data->br_stack = NULL;
+	data->period	= period;
 }
 
 extern void perf_output_sample(struct perf_output_handle *handle,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9789a56..00c58df 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4957,7 +4957,7 @@ void __perf_sw_event(u32 event_id, u64 nr, struct pt_regs *regs, u64 addr)
 	if (rctx < 0)
 		return;
 
-	perf_sample_data_init(&data, addr);
+	perf_sample_data_init(&data, addr, 0);
 
 	do_perf_sw_event(PERF_TYPE_SOFTWARE, event_id, nr, &data, regs);
 
@@ -5215,7 +5215,7 @@ void perf_tp_event(u64 addr, u64 count, void *record, int entry_size,
 		.data = record,
 	};
 
-	perf_sample_data_init(&data, addr);
+	perf_sample_data_init(&data, addr, 0);
 	data.raw = &raw;
 
 	hlist_for_each_entry_rcu(event, node, head, hlist_entry) {
@@ -5318,7 +5318,7 @@ void perf_bp_event(struct perf_event *bp, void *data)
 	struct perf_sample_data sample;
 	struct pt_regs *regs = data;
 
-	perf_sample_data_init(&sample, bp->attr.bp_addr);
+	perf_sample_data_init(&sample, bp->attr.bp_addr, 0);
 
 	if (!bp->hw.state && !perf_exclude_event(bp, regs))
 		perf_swevent_event(bp, 1, &sample, regs);
@@ -5344,8 +5344,7 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 
 	event->pmu->read(event);
 
-	perf_sample_data_init(&data, 0);
-	data.period = event->hw.last_period;
+	perf_sample_data_init(&data, 0, event->hw.last_period);
 	regs = get_irq_regs();
 
 	if (regs && !perf_exclude_event(event, regs)) {
