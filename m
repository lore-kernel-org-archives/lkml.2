Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2BFUx7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 15:53:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58970 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755287Ab2BFUx5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 15:53:57 -0500
Date: Mon, 6 Feb 2012 21:53:54 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, peterz@infradead.org, eric.dumazet@gmail.com,
        markus@trippelsdorf.de, paulus@samba.org
Subject: [PATCH] perf: fix assertion failure in x86_pmu_start()
Message-ID: <20120206205354.GA31186@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following patch fixes an issue introduced by the following
commit:
        e050e3f0a71b ("perf: Fix broken interrupt rate throttling")

The patch caused the following warning to pop up depending on
the sampling frequency adjustments:

[89214.962603] ------------[ cut here ]------------
[89214.967441] WARNING: at arch/x86/kernel/cpu/perf_event.c:995 x86_pmu_start+0x79/0xd4()
[89214.975825] Hardware name: X8DTN
[89214.979268] Modules linked in:
[89214.982560] Pid: 0, comm: swapper/6 Not tainted 3.3.0-rc2-tip+ #1
[89214.988865] Call Trace:
[89214.991533]  <IRQ>  [<ffffffff81065cc7>] warn_slowpath_common+0x7e/0x97
[89214.998379]  [<ffffffff81065cf5>] warn_slowpath_null+0x15/0x17
[89215.004428]  [<ffffffff8103f626>] x86_pmu_start+0x79/0xd4
[89215.010042]  [<ffffffff810e30d1>] perf_adjust_freq_unthr_context.part.63+0xef/0x123
[89215.018123]  [<ffffffff810e318c>] perf_event_task_tick+0x87/0x1c1
[89215.024463]  [<ffffffff810a2370>] ? tick_nohz_handler+0xda/0xda
[89215.030595]  [<ffffffff8108b819>] scheduler_tick+0xd1/0xf3
[89215.036296]  [<ffffffff810720b0>] update_process_times+0x5e/0x6f
[89215.042512]  [<ffffffff810a23e0>] tick_sched_timer+0x70/0x99
[89215.048387]  [<ffffffff810823f9>] __run_hrtimer+0x8c/0x148
[89215.054087]  [<ffffffff81082add>] hrtimer_interrupt+0xc1/0x18c

It was caused by the following call sequence:

perf_adjust_freq_unthr_context.part() {
     stop()
     if (delta > 0) {
          perf_adjust_period() {
              if (period > 8*...) {
                  stop()
                  ...
                  start()
              }
          }
      }
      start()
}

Which caused a double start and a double stop, thus triggering the assert
in x86_pmu_start().

The patch fixes the problem by avoiding the double calls. We pass a new
argument to perf_adjust_period() to indicate whether or not the event
is already stopped. We can't just remove the start/stop from that function
because it's called from __perf_event_overflow where the event needs to
be reloaded via a stop/start back-toback call.

The patch reintroduces the assertion in x86_pmu_start() which was removed
by commit:
	84f2b9b perf: Remove deprecated WARN_ON_ONCE()

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 3c44b71..f8bddb5 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -988,6 +988,9 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx = event->hw.idx;
 
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+		return;
+
 	if (WARN_ON_ONCE(idx == -1))
 		return;
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 7c3b9de..ee151f4 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2303,7 +2303,9 @@ do {					\
 static DEFINE_PER_CPU(int, perf_throttled_count);
 static DEFINE_PER_CPU(u64, perf_throttled_seq);
 
-static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
+static void perf_adjust_period(struct perf_event *event, u64 nsec,
+			       u64 count,
+			       bool dostop)
 {
 	struct hw_perf_event *hwc = &event->hw;
 	s64 period, sample_period;
@@ -2322,9 +2324,13 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	hwc->sample_period = sample_period;
 
 	if (local64_read(&hwc->period_left) > 8*sample_period) {
-		event->pmu->stop(event, PERF_EF_UPDATE);
+		if (dostop)
+			event->pmu->stop(event, PERF_EF_UPDATE);
+
 		local64_set(&hwc->period_left, 0);
-		event->pmu->start(event, PERF_EF_RELOAD);
+
+		if (dostop)
+			event->pmu->start(event, PERF_EF_RELOAD);
 	}
 }
 
@@ -2381,9 +2387,12 @@ static void perf_adjust_freq_unthr_context(struct perf_event_context *ctx,
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
@@ -4567,7 +4576,8 @@ static int __perf_event_overflow(struct perf_event *event,
 		hwc->freq_time_stamp = now;
 
 		if (delta > 0 && delta < 2*TICK_NSEC)
-			perf_adjust_period(event, delta, hwc->last_period);
+			perf_adjust_period(event, delta,
+					   hwc->last_period, true);
 	}
 
 	/*
