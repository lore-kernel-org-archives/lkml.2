Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756779Ab2BGToY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 14:44:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40903 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab2BGToX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 14:44:23 -0500
Date: Tue, 7 Feb 2012 11:44:06 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-f39d47ff819ed52a2afbdbecbe35f23f7755f58d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, eric.dumazet@gmail.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, eric.dumazet@gmail.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20120207133956.GA4932@quad>
References: <20120207133956.GA4932@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Fix double start/stop in x86_pmu_start()
Git-Commit-ID: f39d47ff819ed52a2afbdbecbe35f23f7755f58d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 07 Feb 2012 11:44:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f39d47ff819ed52a2afbdbecbe35f23f7755f58d
Gitweb:     http://git.kernel.org/tip/f39d47ff819ed52a2afbdbecbe35f23f7755f58d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 7 Feb 2012 14:39:57 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 7 Feb 2012 16:58:56 +0100

perf: Fix double start/stop in x86_pmu_start()

The following patch fixes a bug introduced by the following
commit:

        e050e3f0a71b ("perf: Fix broken interrupt rate throttling")

The patch caused the following warning to pop up depending on
the sampling frequency adjustments:

  ------------[ cut here ]------------
  WARNING: at arch/x86/kernel/cpu/perf_event.c:995 x86_pmu_start+0x79/0xd4()

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

Which caused a double start and a double stop, thus triggering
the assert in x86_pmu_start().

The patch fixes the problem by avoiding the double calls. We
pass a new argument to perf_adjust_period() to indicate whether
or not the event is already stopped. We can't just remove the
start/stop from that function because it's called from
__perf_event_overflow where the event needs to be reloaded via a
stop/start back-toback call.

The patch reintroduces the assertion in x86_pmu_start() which
was removed by commit:

	84f2b9b ("perf: Remove deprecated WARN_ON_ONCE()")

In this second version, we've added calls to disable/enable PMU
during unthrottling or frequency adjustment based on bug report
of spurious NMI interrupts from Eric Dumazet.

Reported-and-tested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: markus@trippelsdorf.de
Cc: paulus@samba.org
Link: http://lkml.kernel.org/r/20120207133956.GA4932@quad
[ Minor edits to the changelog and to the code ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event.c |    3 +++
 kernel/events/core.c             |   19 ++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2a30e5a..5adce10 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -986,6 +986,9 @@ static void x86_pmu_start(struct perf_event *event, int flags)
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	int idx = event->hw.idx;
 
+	if (WARN_ON_ONCE(!(event->hw.state & PERF_HES_STOPPED)))
+		return;
+
 	if (WARN_ON_ONCE(idx == -1))
 		return;
 
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
