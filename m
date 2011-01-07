Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1AGCfl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 21:35:41 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:13410 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab1AGCff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 21:35:35 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Subject: [PATCH 5/6] MIPS: perf: Add support for 64-bit perf counters.
Date: Thu,  6 Jan 2011 18:35:06 -0800
Message-Id: <1294367707-2593-6-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
References: <1294367707-2593-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 07 Jan 2011 02:35:35.0188 (UTC) FILETIME=[8FE3E540:01CBAE13]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hard coded constants are moved to struct mips_pmu.  All counter
register access move to the read_counter and write_counter function
pointers, which are set to either 32-bit or 64-bit access methods at
initialization time.

Many of the function pointers in struct mips_pmu were not needed as
there was only a single implementation, these were removed.

I couldn't figure out what made struct cpu_hw_events.msbs[] at all
useful, so I removed it too.

Some functions and other declarations were reordered to reduce the
need for forward declarations.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
---
 arch/mips/kernel/perf_event_mipsxx.c |  838 ++++++++++++++++------------------
 1 files changed, 385 insertions(+), 453 deletions(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 498dd85..9bdac86 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -2,6 +2,7 @@
  * Linux performance counter support for MIPS.
  *
  * Copyright (C) 2010 MIPS Technologies, Inc.
+ * Copyright (C) 2011 Cavium Networks, Inc.
  * Author: Deng-Cheng Zhu
  *
  * This code is based on the implementation for ARM, which is in turn
@@ -26,12 +27,6 @@
 #include <asm/stacktrace.h>
 #include <asm/time.h> /* For perf_irq */
 
-/* These are for 32bit counters. For 64bit ones, define them accordingly. */
-#define MAX_PERIOD	((1ULL << 32) - 1)
-#define VALID_COUNT	0x7fffffff
-#define TOTAL_BITS	32
-#define HIGHEST_BIT	31
-
 #define MIPS_MAX_HWEVENTS 4
 
 struct cpu_hw_events {
@@ -45,15 +40,6 @@ struct cpu_hw_events {
 	unsigned long		used_mask[BITS_TO_LONGS(MIPS_MAX_HWEVENTS)];
 
 	/*
-	 * The borrowed MSB for the performance counter. A MIPS performance
-	 * counter uses its bit 31 (for 32bit counters) or bit 63 (for 64bit
-	 * counters) as a factor of determining whether a counter overflow
-	 * should be signaled. So here we use a separate MSB for each
-	 * counter to make things easy.
-	 */
-	unsigned long		msbs[BITS_TO_LONGS(MIPS_MAX_HWEVENTS)];
-
-	/*
 	 * Software copy of the control register for each performance counter.
 	 * MIPS CPUs vary in performance counters. They use this differently,
 	 * and even may not use it.
@@ -75,6 +61,7 @@ struct mips_perf_event {
 	unsigned int cntr_mask;
 	#define CNTR_EVEN	0x55555555
 	#define CNTR_ODD	0xaaaaaaaa
+	#define CNTR_ALL	0xffffffff
 #ifdef CONFIG_MIPS_MT_SMP
 	enum {
 		T  = 0,
@@ -95,18 +82,13 @@ static DEFINE_MUTEX(raw_event_mutex);
 #define C(x) PERF_COUNT_HW_CACHE_##x
 
 struct mips_pmu {
+	u64		max_period;
+	u64		valid_count;
+	u64		overflow;
 	const char	*name;
 	int		irq;
-	irqreturn_t	(*handle_irq)(int irq, void *dev);
-	int		(*handle_shared_irq)(void);
-	void		(*start)(void);
-	void		(*stop)(void);
-	int		(*alloc_counter)(struct cpu_hw_events *cpuc,
-					struct hw_perf_event *hwc);
 	u64		(*read_counter)(unsigned int idx);
 	void		(*write_counter)(unsigned int idx, u64 val);
-	void		(*enable_event)(struct hw_perf_event *evt, int idx);
-	void		(*disable_event)(int idx);
 	const struct mips_perf_event *(*map_raw_event)(u64 config);
 	const struct mips_perf_event (*general_event_map)[PERF_COUNT_HW_MAX];
 	const struct mips_perf_event (*cache_event_map)
@@ -116,43 +98,300 @@ struct mips_pmu {
 	unsigned int	num_counters;
 };
 
-static const struct mips_pmu *mipspmu;
+static struct mips_pmu mipspmu;
+
+#define M_CONFIG1_PC	(1 << 4)
+
+#define M_PERFCTL_EXL			(1      <<  0)
+#define M_PERFCTL_KERNEL		(1      <<  1)
+#define M_PERFCTL_SUPERVISOR		(1      <<  2)
+#define M_PERFCTL_USER			(1      <<  3)
+#define M_PERFCTL_INTERRUPT_ENABLE	(1      <<  4)
+#define M_PERFCTL_EVENT(event)		(((event) & 0x3ff)  << 5)
+#define M_PERFCTL_VPEID(vpe)		((vpe)    << 16)
+#define M_PERFCTL_MT_EN(filter)		((filter) << 20)
+#define    M_TC_EN_ALL			M_PERFCTL_MT_EN(0)
+#define    M_TC_EN_VPE			M_PERFCTL_MT_EN(1)
+#define    M_TC_EN_TC			M_PERFCTL_MT_EN(2)
+#define M_PERFCTL_TCID(tcid)		((tcid)   << 22)
+#define M_PERFCTL_WIDE			(1      << 30)
+#define M_PERFCTL_MORE			(1      << 31)
+
+#define M_PERFCTL_COUNT_EVENT_WHENEVER	(M_PERFCTL_EXL |		\
+					M_PERFCTL_KERNEL |		\
+					M_PERFCTL_USER |		\
+					M_PERFCTL_SUPERVISOR |		\
+					M_PERFCTL_INTERRUPT_ENABLE)
+
+#ifdef CONFIG_MIPS_MT_SMP
+#define M_PERFCTL_CONFIG_MASK		0x3fff801f
+#else
+#define M_PERFCTL_CONFIG_MASK		0x1f
+#endif
+#define M_PERFCTL_EVENT_MASK		0xfe0
+
+
+#ifdef CONFIG_MIPS_MT_SMP
+static int cpu_has_mipsmt_pertccounters;
+
+/*
+ * FIXME: For VSMP, vpe_id() is redefined for Perf-events, because
+ * cpu_data[cpuid].vpe_id reports 0 for _both_ CPUs.
+ */
+#if defined(CONFIG_HW_PERF_EVENTS)
+#define vpe_id()	(cpu_has_mipsmt_pertccounters ? \
+			0 : smp_processor_id())
+#else
+#define vpe_id()	(cpu_has_mipsmt_pertccounters ? \
+			0 : cpu_data[smp_processor_id()].vpe_id)
+#endif
+
+/* Copied from op_model_mipsxx.c */
+static unsigned int vpe_shift(void)
+{
+	if (num_possible_cpus() > 1)
+		return 1;
+
+	return 0;
+}
+
+static unsigned int counters_total_to_per_cpu(unsigned int counters)
+{
+	return counters >> vpe_shift();
+}
+
+static unsigned int counters_per_cpu_to_total(unsigned int counters)
+{
+	return counters << vpe_shift();
+}
+
+#else /* !CONFIG_MIPS_MT_SMP */
+#define vpe_id()	0
+
+#endif /* CONFIG_MIPS_MT_SMP */
+
+static void resume_local_counters(void);
+static void pause_local_counters(void);
+static irqreturn_t mipsxx_pmu_handle_irq(int, void *);
+static int mipsxx_pmu_handle_shared_irq(void);
+
+static unsigned int mipsxx_pmu_swizzle_perf_idx(unsigned int idx)
+{
+	if (vpe_id() == 1)
+		idx = (idx + 2) & 3;
+	return idx;
+}
+
+static u64 mipsxx_pmu_read_counter(unsigned int idx)
+{
+	idx = mipsxx_pmu_swizzle_perf_idx(idx);
+
+	switch (idx) {
+	case 0:
+		return read_c0_perfcntr0();
+	case 1:
+		return read_c0_perfcntr1();
+	case 2:
+		return read_c0_perfcntr2();
+	case 3:
+		return read_c0_perfcntr3();
+	default:
+		WARN_ONCE(1, "Invalid performance counter number (%d)\n", idx);
+		return 0;
+	}
+}
+
+static u64 mipsxx_pmu_read_counter_64(unsigned int idx)
+{
+	idx = mipsxx_pmu_swizzle_perf_idx(idx);
+
+	switch (idx) {
+	case 0:
+		return read_c0_perfcntr0_64();
+	case 1:
+		return read_c0_perfcntr1_64();
+	case 2:
+		return read_c0_perfcntr2_64();
+	case 3:
+		return read_c0_perfcntr3_64();
+	default:
+		WARN_ONCE(1, "Invalid performance counter number (%d)\n", idx);
+		return 0;
+	}
+}
+
+static void mipsxx_pmu_write_counter(unsigned int idx, u64 val)
+{
+	idx = mipsxx_pmu_swizzle_perf_idx(idx);
+
+	switch (idx) {
+	case 0:
+		write_c0_perfcntr0(val);
+		return;
+	case 1:
+		write_c0_perfcntr1(val);
+		return;
+	case 2:
+		write_c0_perfcntr2(val);
+		return;
+	case 3:
+		write_c0_perfcntr3(val);
+		return;
+	}
+}
+
+static void mipsxx_pmu_write_counter_64(unsigned int idx, u64 val)
+{
+	idx = mipsxx_pmu_swizzle_perf_idx(idx);
+
+	switch (idx) {
+	case 0:
+		write_c0_perfcntr0_64(val);
+		return;
+	case 1:
+		write_c0_perfcntr1_64(val);
+		return;
+	case 2:
+		write_c0_perfcntr2_64(val);
+		return;
+	case 3:
+		write_c0_perfcntr3_64(val);
+		return;
+	}
+}
+
+static unsigned int mipsxx_pmu_read_control(unsigned int idx)
+{
+	idx = mipsxx_pmu_swizzle_perf_idx(idx);
+
+	switch (idx) {
+	case 0:
+		return read_c0_perfctrl0();
+	case 1:
+		return read_c0_perfctrl1();
+	case 2:
+		return read_c0_perfctrl2();
+	case 3:
+		return read_c0_perfctrl3();
+	default:
+		WARN_ONCE(1, "Invalid performance counter number (%d)\n", idx);
+		return 0;
+	}
+}
+
+static void mipsxx_pmu_write_control(unsigned int idx, unsigned int val)
+{
+	idx = mipsxx_pmu_swizzle_perf_idx(idx);
+
+	switch (idx) {
+	case 0:
+		write_c0_perfctrl0(val);
+		return;
+	case 1:
+		write_c0_perfctrl1(val);
+		return;
+	case 2:
+		write_c0_perfctrl2(val);
+		return;
+	case 3:
+		write_c0_perfctrl3(val);
+		return;
+	}
+}
+
+static int mipsxx_pmu_alloc_counter(struct cpu_hw_events *cpuc,
+				    struct hw_perf_event *hwc)
+{
+	int i;
+
+	/*
+	 * We only need to care the counter mask. The range has been
+	 * checked definitely.
+	 */
+	unsigned long cntr_mask = (hwc->event_base >> 8) & 0xffff;
+
+	for (i = mipspmu.num_counters - 1; i >= 0; i--) {
+		/*
+		 * Note that some MIPS perf events can be counted by both
+		 * even and odd counters, wheresas many other are only by
+		 * even _or_ odd counters. This introduces an issue that
+		 * when the former kind of event takes the counter the
+		 * latter kind of event wants to use, then the "counter
+		 * allocation" for the latter event will fail. In fact if
+		 * they can be dynamically swapped, they both feel happy.
+		 * But here we leave this issue alone for now.
+		 */
+		if (test_bit(i, &cntr_mask) &&
+			!test_and_set_bit(i, cpuc->used_mask))
+			return i;
+	}
+
+	return -EAGAIN;
+}
+
+static void mipsxx_pmu_enable_event(struct hw_perf_event *evt, int idx)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	unsigned long flags;
+
+	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
+
+	local_irq_save(flags);
+	cpuc->saved_ctrl[idx] = M_PERFCTL_EVENT(evt->event_base & 0xff) |
+		(evt->config_base & M_PERFCTL_CONFIG_MASK) |
+		/* Make sure interrupt enabled. */
+		M_PERFCTL_INTERRUPT_ENABLE;
+	/*
+	 * We do not actually let the counter run. Leave it until start().
+	 */
+	local_irq_restore(flags);
+}
+
+static void mipsxx_pmu_disable_event(int idx)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	unsigned long flags;
+
+	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
+
+	local_irq_save(flags);
+	cpuc->saved_ctrl[idx] = mipsxx_pmu_read_control(idx) &
+		~M_PERFCTL_COUNT_EVENT_WHENEVER;
+	mipsxx_pmu_write_control(idx, cpuc->saved_ctrl[idx]);
+	local_irq_restore(flags);
+}
 
 static int mipspmu_event_set_period(struct perf_event *event,
 				    struct hw_perf_event *hwc,
 				    int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	s64 left = local64_read(&hwc->period_left);
-	s64 period = hwc->sample_period;
+	u64 left = local64_read(&hwc->period_left);
+	u64 period = hwc->sample_period;
 	int ret = 0;
-	u64 uleft;
 	unsigned long flags;
 
-	if (unlikely(left <= -period)) {
+	if (unlikely((left + period) & (1ULL << 63))) {
 		left = period;
 		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
 
-	if (unlikely(left <= 0)) {
+
+	if (unlikely((left + period) <= period)) {
 		left += period;
 		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
 
-	if (left > (s64)MAX_PERIOD)
-		left = MAX_PERIOD;
+	if (left > mipspmu.max_period)
+		left = mipspmu.max_period;
 
-	local64_set(&hwc->prev_count, (u64)-left);
+	local64_set(&hwc->prev_count, mipspmu.overflow - left);
 
 	local_irq_save(flags);
-	uleft = (u64)(-left) & MAX_PERIOD;
-	uleft > VALID_COUNT ?
-		set_bit(idx, cpuc->msbs) : clear_bit(idx, cpuc->msbs);
-	mipspmu->write_counter(idx, (u64)(-left) & VALID_COUNT);
+	mipspmu.write_counter(idx, mipspmu.overflow - left);
 	local_irq_restore(flags);
 
 	perf_event_update_userpage(event);
@@ -164,30 +403,22 @@ static void mipspmu_event_update(struct perf_event *event,
 				 struct hw_perf_event *hwc,
 				 int idx)
 {
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	unsigned long flags;
-	int shift = 64 - TOTAL_BITS;
-	s64 prev_raw_count, new_raw_count;
+	u64 prev_raw_count, new_raw_count;
 	u64 delta;
 
 again:
 	prev_raw_count = local64_read(&hwc->prev_count);
 	local_irq_save(flags);
 	/* Make the counter value be a "real" one. */
-	new_raw_count = mipspmu->read_counter(idx);
-	if (new_raw_count & (test_bit(idx, cpuc->msbs) << HIGHEST_BIT)) {
-		new_raw_count &= VALID_COUNT;
-		clear_bit(idx, cpuc->msbs);
-	} else
-		new_raw_count |= (test_bit(idx, cpuc->msbs) << HIGHEST_BIT);
+	new_raw_count = mipspmu.read_counter(idx);
 	local_irq_restore(flags);
 
 	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 				new_raw_count) != prev_raw_count)
 		goto again;
 
-	delta = (new_raw_count << shift) - (prev_raw_count << shift);
-	delta >>= shift;
+	delta = new_raw_count - prev_raw_count;
 
 	local64_add(delta, &event->count);
 	local64_sub(delta, &hwc->period_left);
@@ -199,9 +430,6 @@ static void mipspmu_start(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (!mipspmu)
-		return;
-
 	if (flags & PERF_EF_RELOAD)
 		WARN_ON_ONCE(!(hwc->state & PERF_HES_UPTODATE));
 
@@ -211,19 +439,16 @@ static void mipspmu_start(struct perf_event *event, int flags)
 	mipspmu_event_set_period(event, hwc, hwc->idx);
 
 	/* Enable the event. */
-	mipspmu->enable_event(hwc, hwc->idx);
+	mipsxx_pmu_enable_event(hwc, hwc->idx);
 }
 
 static void mipspmu_stop(struct perf_event *event, int flags)
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	if (!mipspmu)
-		return;
-
 	if (!(hwc->state & PERF_HES_STOPPED)) {
 		/* We are working on a local event. */
-		mipspmu->disable_event(hwc->idx);
+		mipsxx_pmu_disable_event(hwc->idx);
 		barrier();
 		mipspmu_event_update(event, hwc, hwc->idx);
 		hwc->state |= PERF_HES_STOPPED | PERF_HES_UPTODATE;
@@ -240,7 +465,7 @@ static int mipspmu_add(struct perf_event *event, int flags)
 	perf_pmu_disable(event->pmu);
 
 	/* To look for a free counter for this event. */
-	idx = mipspmu->alloc_counter(cpuc, hwc);
+	idx = mipsxx_pmu_alloc_counter(cpuc, hwc);
 	if (idx < 0) {
 		err = idx;
 		goto out;
@@ -251,7 +476,7 @@ static int mipspmu_add(struct perf_event *event, int flags)
 	 * make sure it is disabled.
 	 */
 	event->hw.idx = idx;
-	mipspmu->disable_event(idx);
+	mipsxx_pmu_disable_event(idx);
 	cpuc->events[idx] = event;
 
 	hwc->state = PERF_HES_STOPPED | PERF_HES_UPTODATE;
@@ -272,7 +497,7 @@ static void mipspmu_del(struct perf_event *event, int flags)
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
 
-	WARN_ON(idx < 0 || idx >= mipspmu->num_counters);
+	WARN_ON(idx < 0 || idx >= mipspmu.num_counters);
 
 	mipspmu_stop(event, PERF_EF_UPDATE);
 	cpuc->events[idx] = NULL;
@@ -294,14 +519,29 @@ static void mipspmu_read(struct perf_event *event)
 
 static void mipspmu_enable(struct pmu *pmu)
 {
-	if (mipspmu)
-		mipspmu->start();
+#ifdef CONFIG_MIPS_MT_SMP
+	write_unlock(&pmuint_rwlock);
+#endif
+	resume_local_counters();
 }
 
+/*
+ * MIPS performance counters can be per-TC. The control registers can
+ * not be directly accessed accross CPUs. Hence if we want to do global
+ * control, we need cross CPU calls. on_each_cpu() can help us, but we
+ * can not make sure this function is called with interrupts enabled. So
+ * here we pause local counters and then grab a rwlock and leave the
+ * counters on other CPUs alone. If any counter interrupt raises while
+ * we own the write lock, simply pause local counters on that CPU and
+ * spin in the handler. Also we know we won't be switched to another
+ * CPU after pausing local counters and before grabbing the lock.
+ */
 static void mipspmu_disable(struct pmu *pmu)
 {
-	if (mipspmu)
-		mipspmu->stop();
+	pause_local_counters();
+#ifdef CONFIG_MIPS_MT_SMP
+	write_lock(&pmuint_rwlock);
+#endif
 }
 
 static atomic_t active_events = ATOMIC_INIT(0);
@@ -312,21 +552,21 @@ static int mipspmu_get_irq(void)
 {
 	int err;
 
-	if (mipspmu->irq >= 0) {
+	if (mipspmu.irq >= 0) {
 		/* Request my own irq handler. */
-		err = request_irq(mipspmu->irq, mipspmu->handle_irq,
-			IRQF_DISABLED | IRQF_NOBALANCING,
+		err = request_irq(mipspmu.irq, mipsxx_pmu_handle_irq,
+			IRQF_PERCPU | IRQF_NOBALANCING,
 			"mips_perf_pmu", NULL);
 		if (err) {
 			pr_warning("Unable to request IRQ%d for MIPS "
-			   "performance counters!\n", mipspmu->irq);
+			   "performance counters!\n", mipspmu.irq);
 		}
 	} else if (cp0_perfcount_irq < 0) {
 		/*
 		 * We are sharing the irq number with the timer interrupt.
 		 */
 		save_perf_irq = perf_irq;
-		perf_irq = mipspmu->handle_shared_irq;
+		perf_irq = mipsxx_pmu_handle_shared_irq;
 		err = 0;
 	} else {
 		pr_warning("The platform hasn't properly defined its "
@@ -339,8 +579,8 @@ static int mipspmu_get_irq(void)
 
 static void mipspmu_free_irq(void)
 {
-	if (mipspmu->irq >= 0)
-		free_irq(mipspmu->irq, NULL);
+	if (mipspmu.irq >= 0)
+		free_irq(mipspmu.irq, NULL);
 	else if (cp0_perfcount_irq < 0)
 		perf_irq = save_perf_irq;
 }
@@ -361,7 +601,7 @@ static void hw_perf_event_destroy(struct perf_event *event)
 		 * disabled.
 		 */
 		on_each_cpu(reset_counters,
-			(void *)(long)mipspmu->num_counters, 1);
+			(void *)(long)mipspmu.num_counters, 1);
 		mipspmu_free_irq();
 		mutex_unlock(&pmu_reserve_mutex);
 	}
@@ -381,8 +621,8 @@ static int mipspmu_event_init(struct perf_event *event)
 		return -ENOENT;
 	}
 
-	if (!mipspmu || event->cpu >= nr_cpumask_bits ||
-		(event->cpu >= 0 && !cpu_online(event->cpu)))
+	if (event->cpu >= nr_cpumask_bits ||
+	    (event->cpu >= 0 && !cpu_online(event->cpu)))
 		return -ENODEV;
 
 	if (!atomic_inc_not_zero(&active_events)) {
@@ -441,9 +681,9 @@ static const struct mips_perf_event *mipspmu_map_general_event(int idx)
 {
 	const struct mips_perf_event *pev;
 
-	pev = ((*mipspmu->general_event_map)[idx].event_id ==
+	pev = ((*mipspmu.general_event_map)[idx].event_id ==
 		UNSUPPORTED_PERF_EVENT_ID ? ERR_PTR(-EOPNOTSUPP) :
-		&(*mipspmu->general_event_map)[idx]);
+		&(*mipspmu.general_event_map)[idx]);
 
 	return pev;
 }
@@ -465,7 +705,7 @@ static const struct mips_perf_event *mipspmu_map_cache_event(u64 config)
 	if (cache_result >= PERF_COUNT_HW_CACHE_RESULT_MAX)
 		return ERR_PTR(-EINVAL);
 
-	pev = &((*mipspmu->cache_event_map)
+	pev = &((*mipspmu.cache_event_map)
 					[cache_type]
 					[cache_op]
 					[cache_result]);
@@ -486,7 +726,7 @@ static int validate_event(struct cpu_hw_events *cpuc,
 	if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
 		return 1;
 
-	return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
+	return mipsxx_pmu_alloc_counter(cpuc, &fake_hwc) >= 0;
 }
 
 static int validate_group(struct perf_event *event)
@@ -524,123 +764,9 @@ static void handle_associated_event(struct cpu_hw_events *cpuc,
 		return;
 
 	if (perf_event_overflow(event, 0, data, regs))
-		mipspmu->disable_event(idx);
-}
-
-#define M_CONFIG1_PC	(1 << 4)
-
-#define M_PERFCTL_EXL			(1UL      <<  0)
-#define M_PERFCTL_KERNEL		(1UL      <<  1)
-#define M_PERFCTL_SUPERVISOR		(1UL      <<  2)
-#define M_PERFCTL_USER			(1UL      <<  3)
-#define M_PERFCTL_INTERRUPT_ENABLE	(1UL      <<  4)
-#define M_PERFCTL_EVENT(event)		(((event) & 0x3ff)  << 5)
-#define M_PERFCTL_VPEID(vpe)		((vpe)    << 16)
-#define M_PERFCTL_MT_EN(filter)		((filter) << 20)
-#define    M_TC_EN_ALL			M_PERFCTL_MT_EN(0)
-#define    M_TC_EN_VPE			M_PERFCTL_MT_EN(1)
-#define    M_TC_EN_TC			M_PERFCTL_MT_EN(2)
-#define M_PERFCTL_TCID(tcid)		((tcid)   << 22)
-#define M_PERFCTL_WIDE			(1UL      << 30)
-#define M_PERFCTL_MORE			(1UL      << 31)
-
-#define M_PERFCTL_COUNT_EVENT_WHENEVER	(M_PERFCTL_EXL |		\
-					M_PERFCTL_KERNEL |		\
-					M_PERFCTL_USER |		\
-					M_PERFCTL_SUPERVISOR |		\
-					M_PERFCTL_INTERRUPT_ENABLE)
-
-#ifdef CONFIG_MIPS_MT_SMP
-#define M_PERFCTL_CONFIG_MASK		0x3fff801f
-#else
-#define M_PERFCTL_CONFIG_MASK		0x1f
-#endif
-#define M_PERFCTL_EVENT_MASK		0xfe0
-
-#define M_COUNTER_OVERFLOW		(1UL      << 31)
-
-#ifdef CONFIG_MIPS_MT_SMP
-static int cpu_has_mipsmt_pertccounters;
-
-/*
- * FIXME: For VSMP, vpe_id() is redefined for Perf-events, because
- * cpu_data[cpuid].vpe_id reports 0 for _both_ CPUs.
- */
-#if defined(CONFIG_HW_PERF_EVENTS)
-#define vpe_id()	(cpu_has_mipsmt_pertccounters ? \
-			0 : smp_processor_id())
-#else
-#define vpe_id()	(cpu_has_mipsmt_pertccounters ? \
-			0 : cpu_data[smp_processor_id()].vpe_id)
-#endif
-
-/* Copied from op_model_mipsxx.c */
-static unsigned int vpe_shift(void)
-{
-	if (num_possible_cpus() > 1)
-		return 1;
-
-	return 0;
-}
-
-static unsigned int counters_total_to_per_cpu(unsigned int counters)
-{
-	return counters >> vpe_shift();
-}
-
-static unsigned int counters_per_cpu_to_total(unsigned int counters)
-{
-	return counters << vpe_shift();
+		mipsxx_pmu_disable_event(idx);
 }
 
-#else /* !CONFIG_MIPS_MT_SMP */
-#define vpe_id()	0
-
-#endif /* CONFIG_MIPS_MT_SMP */
-
-#define __define_perf_accessors(r, n, np)				\
-									\
-static unsigned int r_c0_ ## r ## n(void)				\
-{									\
-	unsigned int cpu = vpe_id();					\
-									\
-	switch (cpu) {							\
-	case 0:								\
-		return read_c0_ ## r ## n();				\
-	case 1:								\
-		return read_c0_ ## r ## np();				\
-	default:							\
-		BUG();							\
-	}								\
-	return 0;							\
-}									\
-									\
-static void w_c0_ ## r ## n(unsigned int value)				\
-{									\
-	unsigned int cpu = vpe_id();					\
-									\
-	switch (cpu) {							\
-	case 0:								\
-		write_c0_ ## r ## n(value);				\
-		return;							\
-	case 1:								\
-		write_c0_ ## r ## np(value);				\
-		return;							\
-	default:							\
-		BUG();							\
-	}								\
-	return;								\
-}									\
-
-__define_perf_accessors(perfcntr, 0, 2)
-__define_perf_accessors(perfcntr, 1, 3)
-__define_perf_accessors(perfcntr, 2, 0)
-__define_perf_accessors(perfcntr, 3, 1)
-
-__define_perf_accessors(perfctrl, 0, 2)
-__define_perf_accessors(perfctrl, 1, 3)
-__define_perf_accessors(perfctrl, 2, 0)
-__define_perf_accessors(perfctrl, 3, 1)
 
 static int __n_counters(void)
 {
@@ -682,87 +808,17 @@ static void reset_counters(void *arg)
 	int counters = (int)(long)arg;
 	switch (counters) {
 	case 4:
-		w_c0_perfctrl3(0);
-		w_c0_perfcntr3(0);
+		mipsxx_pmu_write_control(3, 0);
+		mipspmu.write_counter(3, 0);
 	case 3:
-		w_c0_perfctrl2(0);
-		w_c0_perfcntr2(0);
+		mipsxx_pmu_write_control(2, 0);
+		mipspmu.write_counter(2, 0);
 	case 2:
-		w_c0_perfctrl1(0);
-		w_c0_perfcntr1(0);
-	case 1:
-		w_c0_perfctrl0(0);
-		w_c0_perfcntr0(0);
-	}
-}
-
-static u64 mipsxx_pmu_read_counter(unsigned int idx)
-{
-	switch (idx) {
-	case 0:
-		return r_c0_perfcntr0();
+		mipsxx_pmu_write_control(1, 0);
+		mipspmu.write_counter(1, 0);
 	case 1:
-		return r_c0_perfcntr1();
-	case 2:
-		return r_c0_perfcntr2();
-	case 3:
-		return r_c0_perfcntr3();
-	default:
-		WARN_ONCE(1, "Invalid performance counter number (%d)\n", idx);
-		return 0;
-	}
-}
-
-static void mipsxx_pmu_write_counter(unsigned int idx, u64 val)
-{
-	switch (idx) {
-	case 0:
-		w_c0_perfcntr0(val);
-		return;
-	case 1:
-		w_c0_perfcntr1(val);
-		return;
-	case 2:
-		w_c0_perfcntr2(val);
-		return;
-	case 3:
-		w_c0_perfcntr3(val);
-		return;
-	}
-}
-
-static unsigned int mipsxx_pmu_read_control(unsigned int idx)
-{
-	switch (idx) {
-	case 0:
-		return r_c0_perfctrl0();
-	case 1:
-		return r_c0_perfctrl1();
-	case 2:
-		return r_c0_perfctrl2();
-	case 3:
-		return r_c0_perfctrl3();
-	default:
-		WARN_ONCE(1, "Invalid performance counter number (%d)\n", idx);
-		return 0;
-	}
-}
-
-static void mipsxx_pmu_write_control(unsigned int idx, unsigned int val)
-{
-	switch (idx) {
-	case 0:
-		w_c0_perfctrl0(val);
-		return;
-	case 1:
-		w_c0_perfctrl1(val);
-		return;
-	case 2:
-		w_c0_perfctrl2(val);
-		return;
-	case 3:
-		w_c0_perfctrl3(val);
-		return;
+		mipsxx_pmu_write_control(0, 0);
+		mipspmu.write_counter(0, 0);
 	}
 }
 
@@ -1047,7 +1103,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	} else if (PERF_TYPE_RAW == event->attr.type) {
 		/* We are working on the global raw event. */
 		mutex_lock(&raw_event_mutex);
-		pev = mipspmu->map_raw_event(event->attr.config);
+		pev = mipspmu.map_raw_event(event->attr.config);
 	} else {
 		/* The event type is not (yet) supported. */
 		return -EOPNOTSUPP;
@@ -1092,7 +1148,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	hwc->config = 0;
 
 	if (!hwc->sample_period) {
-		hwc->sample_period  = MAX_PERIOD;
+		hwc->sample_period  = mipspmu.max_period;
 		hwc->last_period    = hwc->sample_period;
 		local64_set(&hwc->period_left, hwc->sample_period);
 	}
@@ -1105,55 +1161,38 @@ static int __hw_perf_event_init(struct perf_event *event)
 	}
 
 	event->destroy = hw_perf_event_destroy;
-
 	return err;
 }
 
 static void pause_local_counters(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	int counters = mipspmu->num_counters;
+	int ctr = mipspmu.num_counters;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	switch (counters) {
-	case 4:
-		cpuc->saved_ctrl[3] = r_c0_perfctrl3();
-		w_c0_perfctrl3(cpuc->saved_ctrl[3] &
-			~M_PERFCTL_COUNT_EVENT_WHENEVER);
-	case 3:
-		cpuc->saved_ctrl[2] = r_c0_perfctrl2();
-		w_c0_perfctrl2(cpuc->saved_ctrl[2] &
-			~M_PERFCTL_COUNT_EVENT_WHENEVER);
-	case 2:
-		cpuc->saved_ctrl[1] = r_c0_perfctrl1();
-		w_c0_perfctrl1(cpuc->saved_ctrl[1] &
-			~M_PERFCTL_COUNT_EVENT_WHENEVER);
-	case 1:
-		cpuc->saved_ctrl[0] = r_c0_perfctrl0();
-		w_c0_perfctrl0(cpuc->saved_ctrl[0] &
-			~M_PERFCTL_COUNT_EVENT_WHENEVER);
-	}
+	do {
+		ctr--;
+		cpuc->saved_ctrl[ctr] = mipsxx_pmu_read_control(ctr);
+		mipsxx_pmu_write_control(ctr, cpuc->saved_ctrl[ctr] &
+					 ~M_PERFCTL_COUNT_EVENT_WHENEVER);
+	} while (ctr > 0);
 	local_irq_restore(flags);
 }
 
 static void resume_local_counters(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	int counters = mipspmu->num_counters;
+	int ctr = mipspmu.num_counters;
 	unsigned long flags;
 
 	local_irq_save(flags);
-	switch (counters) {
-	case 4:
-		w_c0_perfctrl3(cpuc->saved_ctrl[3]);
-	case 3:
-		w_c0_perfctrl2(cpuc->saved_ctrl[2]);
-	case 2:
-		w_c0_perfctrl1(cpuc->saved_ctrl[1]);
-	case 1:
-		w_c0_perfctrl0(cpuc->saved_ctrl[0]);
-	}
+
+	do {
+		ctr--;
+		mipsxx_pmu_write_control(ctr, cpuc->saved_ctrl[ctr]);
+	} while (ctr > 0);
+
 	local_irq_restore(flags);
 }
 
@@ -1161,14 +1200,13 @@ static int mipsxx_pmu_handle_shared_irq(void)
 {
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct perf_sample_data data;
-	unsigned int counters = mipspmu->num_counters;
-	unsigned int counter;
+	unsigned int counters = mipspmu.num_counters;
+	u64 counter;
 	int handled = IRQ_NONE;
 	struct pt_regs *regs;
 
 	if (cpu_has_mips_r2 && !(read_c0_cause() & (1 << 26)))
 		return handled;
-
 	/*
 	 * First we pause the local counters, so that when we are locked
 	 * here, the counters are all paused. When it gets locked due to
@@ -1189,13 +1227,9 @@ static int mipsxx_pmu_handle_shared_irq(void)
 #define HANDLE_COUNTER(n)						\
 	case n + 1:							\
 		if (test_bit(n, cpuc->used_mask)) {			\
-			counter = r_c0_perfcntr ## n();			\
-			if (counter & M_COUNTER_OVERFLOW) {		\
-				w_c0_perfcntr ## n(counter &		\
-						VALID_COUNT);		\
-				if (test_and_change_bit(n, cpuc->msbs))	\
-					handle_associated_event(cpuc,	\
-						n, &data, regs);	\
+			counter = mipspmu.read_counter(n);		\
+			if (counter & mipspmu.overflow) {		\
+				handle_associated_event(cpuc, n, &data, regs); \
 				handled = IRQ_HANDLED;			\
 			}						\
 		}
@@ -1225,95 +1259,6 @@ static irqreturn_t mipsxx_pmu_handle_irq(int irq, void *dev)
 	return mipsxx_pmu_handle_shared_irq();
 }
 
-static void mipsxx_pmu_start(void)
-{
-#ifdef CONFIG_MIPS_MT_SMP
-	write_unlock(&pmuint_rwlock);
-#endif
-	resume_local_counters();
-}
-
-/*
- * MIPS performance counters can be per-TC. The control registers can
- * not be directly accessed accross CPUs. Hence if we want to do global
- * control, we need cross CPU calls. on_each_cpu() can help us, but we
- * can not make sure this function is called with interrupts enabled. So
- * here we pause local counters and then grab a rwlock and leave the
- * counters on other CPUs alone. If any counter interrupt raises while
- * we own the write lock, simply pause local counters on that CPU and
- * spin in the handler. Also we know we won't be switched to another
- * CPU after pausing local counters and before grabbing the lock.
- */
-static void mipsxx_pmu_stop(void)
-{
-	pause_local_counters();
-#ifdef CONFIG_MIPS_MT_SMP
-	write_lock(&pmuint_rwlock);
-#endif
-}
-
-static int mipsxx_pmu_alloc_counter(struct cpu_hw_events *cpuc,
-				    struct hw_perf_event *hwc)
-{
-	int i;
-
-	/*
-	 * We only need to care the counter mask. The range has been
-	 * checked definitely.
-	 */
-	unsigned long cntr_mask = (hwc->event_base >> 8) & 0xffff;
-
-	for (i = mipspmu->num_counters - 1; i >= 0; i--) {
-		/*
-		 * Note that some MIPS perf events can be counted by both
-		 * even and odd counters, wheresas many other are only by
-		 * even _or_ odd counters. This introduces an issue that
-		 * when the former kind of event takes the counter the
-		 * latter kind of event wants to use, then the "counter
-		 * allocation" for the latter event will fail. In fact if
-		 * they can be dynamically swapped, they both feel happy.
-		 * But here we leave this issue alone for now.
-		 */
-		if (test_bit(i, &cntr_mask) &&
-			!test_and_set_bit(i, cpuc->used_mask))
-			return i;
-	}
-
-	return -EAGAIN;
-}
-
-static void mipsxx_pmu_enable_event(struct hw_perf_event *evt, int idx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	unsigned long flags;
-
-	WARN_ON(idx < 0 || idx >= mipspmu->num_counters);
-
-	local_irq_save(flags);
-	cpuc->saved_ctrl[idx] = M_PERFCTL_EVENT(evt->event_base & 0xff) |
-		(evt->config_base & M_PERFCTL_CONFIG_MASK) |
-		/* Make sure interrupt enabled. */
-		M_PERFCTL_INTERRUPT_ENABLE;
-	/*
-	 * We do not actually let the counter run. Leave it until start().
-	 */
-	local_irq_restore(flags);
-}
-
-static void mipsxx_pmu_disable_event(int idx)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	unsigned long flags;
-
-	WARN_ON(idx < 0 || idx >= mipspmu->num_counters);
-
-	local_irq_save(flags);
-	cpuc->saved_ctrl[idx] = mipsxx_pmu_read_control(idx) &
-		~M_PERFCTL_COUNT_EVENT_WHENEVER;
-	mipsxx_pmu_write_control(idx, cpuc->saved_ctrl[idx]);
-	local_irq_restore(flags);
-}
-
 /* 24K */
 #define IS_UNSUPPORTED_24K_EVENT(r, b)					\
 	((b) == 12 || (r) == 151 || (r) == 152 || (b) == 26 ||		\
@@ -1452,40 +1397,11 @@ static const struct mips_perf_event *mipsxx_pmu_map_raw_event(u64 config)
 	return &raw_event;
 }
 
-static struct mips_pmu mipsxxcore_pmu = {
-	.handle_irq = mipsxx_pmu_handle_irq,
-	.handle_shared_irq = mipsxx_pmu_handle_shared_irq,
-	.start = mipsxx_pmu_start,
-	.stop = mipsxx_pmu_stop,
-	.alloc_counter = mipsxx_pmu_alloc_counter,
-	.read_counter = mipsxx_pmu_read_counter,
-	.write_counter = mipsxx_pmu_write_counter,
-	.enable_event = mipsxx_pmu_enable_event,
-	.disable_event = mipsxx_pmu_disable_event,
-	.map_raw_event = mipsxx_pmu_map_raw_event,
-	.general_event_map = &mipsxxcore_event_map,
-	.cache_event_map = &mipsxxcore_cache_map,
-};
-
-static struct mips_pmu mipsxx74Kcore_pmu = {
-	.handle_irq = mipsxx_pmu_handle_irq,
-	.handle_shared_irq = mipsxx_pmu_handle_shared_irq,
-	.start = mipsxx_pmu_start,
-	.stop = mipsxx_pmu_stop,
-	.alloc_counter = mipsxx_pmu_alloc_counter,
-	.read_counter = mipsxx_pmu_read_counter,
-	.write_counter = mipsxx_pmu_write_counter,
-	.enable_event = mipsxx_pmu_enable_event,
-	.disable_event = mipsxx_pmu_disable_event,
-	.map_raw_event = mipsxx_pmu_map_raw_event,
-	.general_event_map = &mipsxx74Kcore_event_map,
-	.cache_event_map = &mipsxx74Kcore_cache_map,
-};
-
 static int __init
 init_hw_perf_events(void)
 {
 	int counters, irq;
+	int counter_bits;
 
 	pr_info("Performance counters: ");
 
@@ -1517,32 +1433,28 @@ init_hw_perf_events(void)
 	}
 #endif
 
-	on_each_cpu(reset_counters, (void *)(long)counters, 1);
+	mipspmu.map_raw_event = mipsxx_pmu_map_raw_event;
 
 	switch (current_cpu_type()) {
 	case CPU_24K:
-		mipsxxcore_pmu.name = "mips/24K";
-		mipsxxcore_pmu.num_counters = counters;
-		mipsxxcore_pmu.irq = irq;
-		mipspmu = &mipsxxcore_pmu;
+		mipspmu.name = "mips/24K";
+		mipspmu.general_event_map = &mipsxxcore_event_map;
+		mipspmu.cache_event_map = &mipsxxcore_cache_map;
 		break;
 	case CPU_34K:
-		mipsxxcore_pmu.name = "mips/34K";
-		mipsxxcore_pmu.num_counters = counters;
-		mipsxxcore_pmu.irq = irq;
-		mipspmu = &mipsxxcore_pmu;
+		mipspmu.name = "mips/34K";
+		mipspmu.general_event_map = &mipsxxcore_event_map;
+		mipspmu.cache_event_map = &mipsxxcore_cache_map;
 		break;
 	case CPU_74K:
-		mipsxx74Kcore_pmu.name = "mips/74K";
-		mipsxx74Kcore_pmu.num_counters = counters;
-		mipsxx74Kcore_pmu.irq = irq;
-		mipspmu = &mipsxx74Kcore_pmu;
+		mipspmu.name = "mips/74K";
+		mipspmu.general_event_map = &mipsxx74Kcore_event_map;
+		mipspmu.cache_event_map = &mipsxx74Kcore_cache_map;
 		break;
 	case CPU_1004K:
-		mipsxxcore_pmu.name = "mips/1004K";
-		mipsxxcore_pmu.num_counters = counters;
-		mipsxxcore_pmu.irq = irq;
-		mipspmu = &mipsxxcore_pmu;
+		mipspmu.name = "mips/1004K";
+		mipspmu.general_event_map = &mipsxxcore_event_map;
+		mipspmu.cache_event_map = &mipsxxcore_cache_map;
 		break;
 	default:
 		pr_cont("Either hardware does not support performance "
@@ -1550,10 +1462,30 @@ init_hw_perf_events(void)
 		return -ENODEV;
 	}
 
-	if (mipspmu)
-		pr_cont("%s PMU enabled, %d counters available to each "
-			"CPU, irq %d%s\n", mipspmu->name, counters, irq,
-			irq < 0 ? " (share with timer interrupt)" : "");
+	mipspmu.num_counters = counters;
+	mipspmu.irq = irq;
+
+	if (read_c0_perfctrl0() & M_PERFCTL_WIDE) {
+		mipspmu.max_period = (1ULL << 63) - 1;
+		mipspmu.valid_count = (1ULL << 63) - 1;
+		mipspmu.overflow = 1ULL << 63;
+		mipspmu.read_counter = mipsxx_pmu_read_counter_64;
+		mipspmu.write_counter = mipsxx_pmu_write_counter_64;
+		counter_bits = 64;
+	} else {
+		mipspmu.max_period = (1ULL << 32) - 1;
+		mipspmu.valid_count = (1ULL << 31) - 1;
+		mipspmu.overflow = 1ULL << 31;
+		mipspmu.read_counter = mipsxx_pmu_read_counter;
+		mipspmu.write_counter = mipsxx_pmu_write_counter;
+		counter_bits = 32;
+	}
+
+	on_each_cpu(reset_counters, (void *)(long)counters, 1);
+
+	pr_cont("%s PMU enabled, %d %d-bit counters available to each "
+		"CPU, irq %d%s\n", mipspmu.name, counters, counter_bits, irq,
+		irq < 0 ? " (share with timer interrupt)" : "");
 
 	perf_pmu_register(&pmu);
 
-- 
1.7.2.3

