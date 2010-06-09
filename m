Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab0FIKSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:18:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:36437 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab0FIKSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:18:37 -0400
Date: Wed, 9 Jun 2010 10:18:01 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Convert perf_event to local_t
Message-ID: <tip-e78505958cf123048fb48cb56b79cebb8edd15fb@git.kernel.org>
Git-Commit-ID: e78505958cf123048fb48cb56b79cebb8edd15fb
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:18:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e78505958cf123048fb48cb56b79cebb8edd15fb
Gitweb:     http://git.kernel.org/tip/e78505958cf123048fb48cb56b79cebb8edd15fb
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 14:43:08 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:37 +0200

perf: Convert perf_event to local_t

Since now all modification to event->count (and ->prev_count
and ->period_left) are local to a cpu, change then to local64_t so we
avoid the LOCK'ed ops.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/perf_event.c     |   18 ++++++++--------
 arch/powerpc/kernel/perf_event.c |   34 +++++++++++++++---------------
 arch/sh/kernel/perf_event.c      |    6 ++--
 arch/sparc/kernel/perf_event.c   |   18 ++++++++--------
 arch/x86/kernel/cpu/perf_event.c |   18 ++++++++--------
 include/linux/perf_event.h       |    7 +++--
 kernel/perf_event.c              |   42 +++++++++++++++++++-------------------
 7 files changed, 72 insertions(+), 71 deletions(-)

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index c457686..5b7cfaf 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -164,20 +164,20 @@ armpmu_event_set_period(struct perf_event *event,
 			struct hw_perf_event *hwc,
 			int idx)
 {
-	s64 left = atomic64_read(&hwc->period_left);
+	s64 left = local64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
 	int ret = 0;
 
 	if (unlikely(left <= -period)) {
 		left = period;
-		atomic64_set(&hwc->period_left, left);
+		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
 
 	if (unlikely(left <= 0)) {
 		left += period;
-		atomic64_set(&hwc->period_left, left);
+		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
@@ -185,7 +185,7 @@ armpmu_event_set_period(struct perf_event *event,
 	if (left > (s64)armpmu->max_period)
 		left = armpmu->max_period;
 
-	atomic64_set(&hwc->prev_count, (u64)-left);
+	local64_set(&hwc->prev_count, (u64)-left);
 
 	armpmu->write_counter(idx, (u64)(-left) & 0xffffffff);
 
@@ -204,18 +204,18 @@ armpmu_event_update(struct perf_event *event,
 	s64 delta;
 
 again:
-	prev_raw_count = atomic64_read(&hwc->prev_count);
+	prev_raw_count = local64_read(&hwc->prev_count);
 	new_raw_count = armpmu->read_counter(idx);
 
-	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 			     new_raw_count) != prev_raw_count)
 		goto again;
 
 	delta = (new_raw_count << shift) - (prev_raw_count << shift);
 	delta >>= shift;
 
-	atomic64_add(delta, &event->count);
-	atomic64_sub(delta, &hwc->period_left);
+	local64_add(delta, &event->count);
+	local64_sub(delta, &hwc->period_left);
 
 	return new_raw_count;
 }
@@ -478,7 +478,7 @@ __hw_perf_event_init(struct perf_event *event)
 	if (!hwc->sample_period) {
 		hwc->sample_period  = armpmu->max_period;
 		hwc->last_period    = hwc->sample_period;
-		atomic64_set(&hwc->period_left, hwc->sample_period);
+		local64_set(&hwc->period_left, hwc->sample_period);
 	}
 
 	err = 0;
diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index ac2a8c2..af1d9a7 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -410,15 +410,15 @@ static void power_pmu_read(struct perf_event *event)
 	 * Therefore we treat them like NMIs.
 	 */
 	do {
-		prev = atomic64_read(&event->hw.prev_count);
+		prev = local64_read(&event->hw.prev_count);
 		barrier();
 		val = read_pmc(event->hw.idx);
-	} while (atomic64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
+	} while (local64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
 
 	/* The counters are only 32 bits wide */
 	delta = (val - prev) & 0xfffffffful;
-	atomic64_add(delta, &event->count);
-	atomic64_sub(delta, &event->hw.period_left);
+	local64_add(delta, &event->count);
+	local64_sub(delta, &event->hw.period_left);
 }
 
 /*
@@ -444,10 +444,10 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
 		if (!event->hw.idx)
 			continue;
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
-		prev = atomic64_read(&event->hw.prev_count);
+		prev = local64_read(&event->hw.prev_count);
 		event->hw.idx = 0;
 		delta = (val - prev) & 0xfffffffful;
-		atomic64_add(delta, &event->count);
+		local64_add(delta, &event->count);
 	}
 }
 
@@ -462,7 +462,7 @@ static void thaw_limited_counters(struct cpu_hw_events *cpuhw,
 		event = cpuhw->limited_counter[i];
 		event->hw.idx = cpuhw->limited_hwidx[i];
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
-		atomic64_set(&event->hw.prev_count, val);
+		local64_set(&event->hw.prev_count, val);
 		perf_event_update_userpage(event);
 	}
 }
@@ -666,11 +666,11 @@ void hw_perf_enable(void)
 		}
 		val = 0;
 		if (event->hw.sample_period) {
-			left = atomic64_read(&event->hw.period_left);
+			left = local64_read(&event->hw.period_left);
 			if (left < 0x80000000L)
 				val = 0x80000000L - left;
 		}
-		atomic64_set(&event->hw.prev_count, val);
+		local64_set(&event->hw.prev_count, val);
 		event->hw.idx = idx;
 		write_pmc(idx, val);
 		perf_event_update_userpage(event);
@@ -842,8 +842,8 @@ static void power_pmu_unthrottle(struct perf_event *event)
 	if (left < 0x80000000L)
 		val = 0x80000000L - left;
 	write_pmc(event->hw.idx, val);
-	atomic64_set(&event->hw.prev_count, val);
-	atomic64_set(&event->hw.period_left, left);
+	local64_set(&event->hw.prev_count, val);
+	local64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
 	perf_enable();
 	local_irq_restore(flags);
@@ -1109,7 +1109,7 @@ const struct pmu *hw_perf_event_init(struct perf_event *event)
 	event->hw.config = events[n];
 	event->hw.event_base = cflags[n];
 	event->hw.last_period = event->hw.sample_period;
-	atomic64_set(&event->hw.period_left, event->hw.last_period);
+	local64_set(&event->hw.period_left, event->hw.last_period);
 
 	/*
 	 * See if we need to reserve the PMU.
@@ -1147,16 +1147,16 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	int record = 0;
 
 	/* we don't have to worry about interrupts here */
-	prev = atomic64_read(&event->hw.prev_count);
+	prev = local64_read(&event->hw.prev_count);
 	delta = (val - prev) & 0xfffffffful;
-	atomic64_add(delta, &event->count);
+	local64_add(delta, &event->count);
 
 	/*
 	 * See if the total period for this event has expired,
 	 * and update for the next period.
 	 */
 	val = 0;
-	left = atomic64_read(&event->hw.period_left) - delta;
+	left = local64_read(&event->hw.period_left) - delta;
 	if (period) {
 		if (left <= 0) {
 			left += period;
@@ -1194,8 +1194,8 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 	}
 
 	write_pmc(event->hw.idx, val);
-	atomic64_set(&event->hw.prev_count, val);
-	atomic64_set(&event->hw.period_left, left);
+	local64_set(&event->hw.prev_count, val);
+	local64_set(&event->hw.period_left, left);
 	perf_event_update_userpage(event);
 }
 
diff --git a/arch/sh/kernel/perf_event.c b/arch/sh/kernel/perf_event.c
index 81b6de4..7a3dc35 100644
--- a/arch/sh/kernel/perf_event.c
+++ b/arch/sh/kernel/perf_event.c
@@ -185,10 +185,10 @@ static void sh_perf_event_update(struct perf_event *event,
 	 * this is the simplest approach for maintaining consistency.
 	 */
 again:
-	prev_raw_count = atomic64_read(&hwc->prev_count);
+	prev_raw_count = local64_read(&hwc->prev_count);
 	new_raw_count = sh_pmu->read(idx);
 
-	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 			     new_raw_count) != prev_raw_count)
 		goto again;
 
@@ -203,7 +203,7 @@ again:
 	delta = (new_raw_count << shift) - (prev_raw_count << shift);
 	delta >>= shift;
 
-	atomic64_add(delta, &event->count);
+	local64_add(delta, &event->count);
 }
 
 static void sh_pmu_disable(struct perf_event *event)
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index beeb92f..8a6660d 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -572,18 +572,18 @@ static u64 sparc_perf_event_update(struct perf_event *event,
 	s64 delta;
 
 again:
-	prev_raw_count = atomic64_read(&hwc->prev_count);
+	prev_raw_count = local64_read(&hwc->prev_count);
 	new_raw_count = read_pmc(idx);
 
-	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 			     new_raw_count) != prev_raw_count)
 		goto again;
 
 	delta = (new_raw_count << shift) - (prev_raw_count << shift);
 	delta >>= shift;
 
-	atomic64_add(delta, &event->count);
-	atomic64_sub(delta, &hwc->period_left);
+	local64_add(delta, &event->count);
+	local64_sub(delta, &hwc->period_left);
 
 	return new_raw_count;
 }
@@ -591,27 +591,27 @@ again:
 static int sparc_perf_event_set_period(struct perf_event *event,
 				       struct hw_perf_event *hwc, int idx)
 {
-	s64 left = atomic64_read(&hwc->period_left);
+	s64 left = local64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
 	int ret = 0;
 
 	if (unlikely(left <= -period)) {
 		left = period;
-		atomic64_set(&hwc->period_left, left);
+		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
 
 	if (unlikely(left <= 0)) {
 		left += period;
-		atomic64_set(&hwc->period_left, left);
+		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
 	if (left > MAX_PERIOD)
 		left = MAX_PERIOD;
 
-	atomic64_set(&hwc->prev_count, (u64)-left);
+	local64_set(&hwc->prev_count, (u64)-left);
 
 	write_pmc(idx, (u64)(-left) & 0xffffffff);
 
@@ -1087,7 +1087,7 @@ static int __hw_perf_event_init(struct perf_event *event)
 	if (!hwc->sample_period) {
 		hwc->sample_period = MAX_PERIOD;
 		hwc->last_period = hwc->sample_period;
-		atomic64_set(&hwc->period_left, hwc->sample_period);
+		local64_set(&hwc->period_left, hwc->sample_period);
 	}
 
 	return 0;
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 79e1998..2d0d290 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -296,10 +296,10 @@ x86_perf_event_update(struct perf_event *event)
 	 * count to the generic event atomically:
 	 */
 again:
-	prev_raw_count = atomic64_read(&hwc->prev_count);
+	prev_raw_count = local64_read(&hwc->prev_count);
 	rdmsrl(hwc->event_base + idx, new_raw_count);
 
-	if (atomic64_cmpxchg(&hwc->prev_count, prev_raw_count,
+	if (local64_cmpxchg(&hwc->prev_count, prev_raw_count,
 					new_raw_count) != prev_raw_count)
 		goto again;
 
@@ -314,8 +314,8 @@ again:
 	delta = (new_raw_count << shift) - (prev_raw_count << shift);
 	delta >>= shift;
 
-	atomic64_add(delta, &event->count);
-	atomic64_sub(delta, &hwc->period_left);
+	local64_add(delta, &event->count);
+	local64_sub(delta, &hwc->period_left);
 
 	return new_raw_count;
 }
@@ -439,7 +439,7 @@ static int x86_setup_perfctr(struct perf_event *event)
 	if (!hwc->sample_period) {
 		hwc->sample_period = x86_pmu.max_period;
 		hwc->last_period = hwc->sample_period;
-		atomic64_set(&hwc->period_left, hwc->sample_period);
+		local64_set(&hwc->period_left, hwc->sample_period);
 	} else {
 		/*
 		 * If we have a PMU initialized but no APIC
@@ -886,7 +886,7 @@ static int
 x86_perf_event_set_period(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
-	s64 left = atomic64_read(&hwc->period_left);
+	s64 left = local64_read(&hwc->period_left);
 	s64 period = hwc->sample_period;
 	int ret = 0, idx = hwc->idx;
 
@@ -898,14 +898,14 @@ x86_perf_event_set_period(struct perf_event *event)
 	 */
 	if (unlikely(left <= -period)) {
 		left = period;
-		atomic64_set(&hwc->period_left, left);
+		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
 
 	if (unlikely(left <= 0)) {
 		left += period;
-		atomic64_set(&hwc->period_left, left);
+		local64_set(&hwc->period_left, left);
 		hwc->last_period = period;
 		ret = 1;
 	}
@@ -924,7 +924,7 @@ x86_perf_event_set_period(struct perf_event *event)
 	 * The hw event starts counting from this event offset,
 	 * mark it to be able to extra future deltas:
 	 */
-	atomic64_set(&hwc->prev_count, (u64)-left);
+	local64_set(&hwc->prev_count, (u64)-left);
 
 	wrmsrl(hwc->event_base + idx, (u64)(-left) & x86_pmu.cntval_mask);
 
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index f34dab9..7342979 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -487,6 +487,7 @@ struct perf_guest_info_callbacks {
 #include <linux/cpu.h>
 #include <asm/atomic.h>
 #include <asm/local.h>
+#include <asm/local64.h>
 
 #define PERF_MAX_STACK_DEPTH		255
 
@@ -536,10 +537,10 @@ struct hw_perf_event {
 		struct arch_hw_breakpoint	info;
 #endif
 	};
-	atomic64_t			prev_count;
+	local64_t			prev_count;
 	u64				sample_period;
 	u64				last_period;
-	atomic64_t			period_left;
+	local64_t			period_left;
 	u64				interrupts;
 
 	u64				freq_time_stamp;
@@ -670,7 +671,7 @@ struct perf_event {
 
 	enum perf_event_active_state	state;
 	unsigned int			attach_state;
-	atomic64_t			count;
+	local64_t			count;
 	atomic64_t			child_count;
 
 	/*
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index a395fda..97c7301 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1148,9 +1148,9 @@ static void __perf_event_sync_stat(struct perf_event *event,
 	 * In order to keep per-task stats reliable we need to flip the event
 	 * values when we flip the contexts.
 	 */
-	value = atomic64_read(&next_event->count);
-	value = atomic64_xchg(&event->count, value);
-	atomic64_set(&next_event->count, value);
+	value = local64_read(&next_event->count);
+	value = local64_xchg(&event->count, value);
+	local64_set(&next_event->count, value);
 
 	swap(event->total_time_enabled, next_event->total_time_enabled);
 	swap(event->total_time_running, next_event->total_time_running);
@@ -1540,10 +1540,10 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 
 	hwc->sample_period = sample_period;
 
-	if (atomic64_read(&hwc->period_left) > 8*sample_period) {
+	if (local64_read(&hwc->period_left) > 8*sample_period) {
 		perf_disable();
 		perf_event_stop(event);
-		atomic64_set(&hwc->period_left, 0);
+		local64_set(&hwc->period_left, 0);
 		perf_event_start(event);
 		perf_enable();
 	}
@@ -1584,7 +1584,7 @@ static void perf_ctx_adjust_freq(struct perf_event_context *ctx)
 
 		perf_disable();
 		event->pmu->read(event);
-		now = atomic64_read(&event->count);
+		now = local64_read(&event->count);
 		delta = now - hwc->freq_count_stamp;
 		hwc->freq_count_stamp = now;
 
@@ -1738,7 +1738,7 @@ static void __perf_event_read(void *info)
 
 static inline u64 perf_event_count(struct perf_event *event)
 {
-	return atomic64_read(&event->count) + atomic64_read(&event->child_count);
+	return local64_read(&event->count) + atomic64_read(&event->child_count);
 }
 
 static u64 perf_event_read(struct perf_event *event)
@@ -2141,7 +2141,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 static void perf_event_reset(struct perf_event *event)
 {
 	(void)perf_event_read(event);
-	atomic64_set(&event->count, 0);
+	local64_set(&event->count, 0);
 	perf_event_update_userpage(event);
 }
 
@@ -2359,7 +2359,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	userpg->index = perf_event_index(event);
 	userpg->offset = perf_event_count(event);
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
-		userpg->offset -= atomic64_read(&event->hw.prev_count);
+		userpg->offset -= local64_read(&event->hw.prev_count);
 
 	userpg->time_enabled = event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
@@ -4035,14 +4035,14 @@ static u64 perf_swevent_set_period(struct perf_event *event)
 	hwc->last_period = hwc->sample_period;
 
 again:
-	old = val = atomic64_read(&hwc->period_left);
+	old = val = local64_read(&hwc->period_left);
 	if (val < 0)
 		return 0;
 
 	nr = div64_u64(period + val, period);
 	offset = nr * period;
 	val -= offset;
-	if (atomic64_cmpxchg(&hwc->period_left, old, val) != old)
+	if (local64_cmpxchg(&hwc->period_left, old, val) != old)
 		goto again;
 
 	return nr;
@@ -4081,7 +4081,7 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 {
 	struct hw_perf_event *hwc = &event->hw;
 
-	atomic64_add(nr, &event->count);
+	local64_add(nr, &event->count);
 
 	if (!regs)
 		return;
@@ -4092,7 +4092,7 @@ static void perf_swevent_add(struct perf_event *event, u64 nr,
 	if (nr == 1 && hwc->sample_period == 1 && !event->attr.freq)
 		return perf_swevent_overflow(event, 1, nmi, data, regs);
 
-	if (atomic64_add_negative(nr, &hwc->period_left))
+	if (local64_add_negative(nr, &hwc->period_left))
 		return;
 
 	perf_swevent_overflow(event, 0, nmi, data, regs);
@@ -4383,8 +4383,8 @@ static void cpu_clock_perf_event_update(struct perf_event *event)
 	u64 now;
 
 	now = cpu_clock(cpu);
-	prev = atomic64_xchg(&event->hw.prev_count, now);
-	atomic64_add(now - prev, &event->count);
+	prev = local64_xchg(&event->hw.prev_count, now);
+	local64_add(now - prev, &event->count);
 }
 
 static int cpu_clock_perf_event_enable(struct perf_event *event)
@@ -4392,7 +4392,7 @@ static int cpu_clock_perf_event_enable(struct perf_event *event)
 	struct hw_perf_event *hwc = &event->hw;
 	int cpu = raw_smp_processor_id();
 
-	atomic64_set(&hwc->prev_count, cpu_clock(cpu));
+	local64_set(&hwc->prev_count, cpu_clock(cpu));
 	perf_swevent_start_hrtimer(event);
 
 	return 0;
@@ -4424,9 +4424,9 @@ static void task_clock_perf_event_update(struct perf_event *event, u64 now)
 	u64 prev;
 	s64 delta;
 
-	prev = atomic64_xchg(&event->hw.prev_count, now);
+	prev = local64_xchg(&event->hw.prev_count, now);
 	delta = now - prev;
-	atomic64_add(delta, &event->count);
+	local64_add(delta, &event->count);
 }
 
 static int task_clock_perf_event_enable(struct perf_event *event)
@@ -4436,7 +4436,7 @@ static int task_clock_perf_event_enable(struct perf_event *event)
 
 	now = event->ctx->time;
 
-	atomic64_set(&hwc->prev_count, now);
+	local64_set(&hwc->prev_count, now);
 
 	perf_swevent_start_hrtimer(event);
 
@@ -4879,7 +4879,7 @@ perf_event_alloc(struct perf_event_attr *attr,
 		hwc->sample_period = 1;
 	hwc->last_period = hwc->sample_period;
 
-	atomic64_set(&hwc->period_left, hwc->sample_period);
+	local64_set(&hwc->period_left, hwc->sample_period);
 
 	/*
 	 * we currently do not support PERF_FORMAT_GROUP on inherited events
@@ -5313,7 +5313,7 @@ inherit_event(struct perf_event *parent_event,
 		hwc->sample_period = sample_period;
 		hwc->last_period   = sample_period;
 
-		atomic64_set(&hwc->period_left, sample_period);
+		local64_set(&hwc->period_left, sample_period);
 	}
 
 	child_event->overflow_handler = parent_event->overflow_handler;
