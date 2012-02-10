Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759032Ab2BJMpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 07:45:51 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:48011 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758694Ab2BJMpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 07:45:50 -0500
Date: Fri, 10 Feb 2012 13:45:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20120210124531.GA6482@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
  0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: f39d47ff819ed52a2afbdbecbe35f23f7755f58d perf: Fix double start/stop in x86_pmu_start()

 Thanks,

	Ingo

------------------>
Jiri Olsa (2):
      perf tools: Fix perf stack to non executable on x86_64
      perf tools: Fix prefix matching for kernel maps

Naveen N. Rao (1):
      perf evsel: Fix an issue where perf report fails to show the proper percentage

Stephane Eranian (2):
      perf: Remove deprecated WARN_ON_ONCE()
      perf: Fix double start/stop in x86_pmu_start()


 arch/x86/kernel/cpu/perf_event_intel_ds.c  |    1 -
 arch/x86/kernel/cpu/perf_event_intel_lbr.c |    2 --
 kernel/events/core.c                       |   19 ++++++++++++++-----
 tools/perf/bench/mem-memcpy-x86-64-asm.S   |    6 ++++++
 tools/perf/util/event.c                    |    2 +-
 tools/perf/util/evsel.c                    |    1 +
 6 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 73da6b6..d6bd49f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -439,7 +439,6 @@ void intel_pmu_pebs_enable(struct perf_event *event)
 	hwc->config &= ~ARCH_PERFMON_EVENTSEL_INT;
 
 	cpuc->pebs_enabled |= 1ULL << hwc->idx;
-	WARN_ON_ONCE(cpuc->enabled);
 
 	if (x86_pmu.intel_cap.pebs_trap && event->attr.precise_ip > 1)
 		intel_pmu_lbr_enable(event);
diff --git a/arch/x86/kernel/cpu/perf_event_intel_lbr.c b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
index 3fab3de..47a7e63 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_lbr.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
@@ -72,8 +72,6 @@ void intel_pmu_lbr_enable(struct perf_event *event)
 	if (!x86_pmu.lbr_nr)
 		return;
 
-	WARN_ON_ONCE(cpuc->enabled);
-
 	/*
 	 * Reset the LBR stack if we changed task context to
 	 * avoid data leaks.
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba36013..1b5c081 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2303,7 +2303,7 @@ do {					\
 static DEFINE_PER_CPU(int, perf_throttled_count);
 static DEFINE_PER_CPU(u64, perf_throttled_seq);
 
-static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
+static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count, bool disable)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	s64 period, sample_period;
@@ -2322,9 +2322,13 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		event->pmu->stop(event, PERF_EF_UPDATE);
+		if (disable)
+			event->pmu->stop(event, PERF_EF_UPDATE);
+
 		local64_set(&hwc->period_left, 0);
-		event->pmu->start(event, PERF_EF_RELOAD);
+
+		if (disable)
+			event->pmu->start(event, PERF_EF_RELOAD);
 	}
 }
 
@@ -2350,6 +2354,7 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		return;
 
 	raw_spin_lock(&ctx->lock);
+	perf_pmu_disable(ctx->pmu);
 
 	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
 		if (event->state != PERF_EVENT_STATE_ACTIVE)
@@ -2381,13 +2386,17 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
 		/*
 		 * restart the event
 		 * reload only if value has changed
+		 * we have stopped the event so tell that
+		 * to perf_adjust_period() to avoid stopping it
+		 * twice.
 		 */
 		if (delta > 0)
-			perf_adjust_period(event, period, delta);
+			perf_adjust_period(event, period, delta, false);
 
 		event->pmu->start(event, delta > 0 ? PERF_EF_RELOAD : 0);
 	}
 
+	perf_pmu_enable(ctx->pmu);
 	raw_spin_unlock(&ctx->lock);
 }
 
@@ -4562,7 +4571,7 @@ static int __perf_event_overflow(struct perf_event *event,
 		hwc->freq_time_stamp = now;
 
 		if (delta > 0 && delta < 2*TICK_NSEC)
-			perf_adjust_period(event, delta, hwc->last_period);
+			perf_adjust_period(event, delta, hwc->last_period, true);
 	}
 
 	/*
diff --git a/tools/perf/bench/mem-memcpy-x86-64-asm.S b/tools/perf/bench/mem-memcpy-x86-64-asm.S
index a57b66e..185a96d 100644
--- a/tools/perf/bench/mem-memcpy-x86-64-asm.S
+++ b/tools/perf/bench/mem-memcpy-x86-64-asm.S
@@ -1,2 +1,8 @@
 
 #include "../../../arch/x86/lib/memcpy_64.S"
+/*
+ * We need to provide note.GNU-stack section, saying that we want
+ * NOT executable stack. Otherwise the final linking will assume that
+ * the ELF stack should not be restricted at all and set it RWX.
+ */
+.section .note.GNU-stack,"",@progbits
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 73ddaf0..2044324 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -554,7 +554,7 @@ static int perf_event__process_kernel_mmap(struct perf_tool *tool __used,
 
 	is_kernel_mmap = memcmp(event->mmap.filename,
 				kmmap_prefix,
-				strlen(kmmap_prefix)) == 0;
+				strlen(kmmap_prefix) - 1) == 0;
 	if (event->mmap.filename[0] == '/' ||
 	    (!is_kernel_mmap && event->mmap.filename[0] == '[')) {
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 667f3b7..7132ee8 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -463,6 +463,7 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
 	memset(data, 0, sizeof(*data));
 	data->cpu = data->pid = data->tid = -1;
 	data->stream_id = data->id = data->time = -1ULL;
+	data->period = 1;
 
 	if (event->header.type != PERF_RECORD_SAMPLE) {
 		if (!sample_id_all)
