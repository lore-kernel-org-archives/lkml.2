Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206Ab1BPNua (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 08:50:30 -0500
Received: from hera.kernel.org ([140.211.167.34]:52705 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755072Ab1BPNu2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 08:50:28 -0500
Date: Wed, 16 Feb 2011 13:50:10 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1297448589.5226.47.camel@laptop>
References: <1297448589.5226.47.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Optimize hrtimer events
Message-ID: <tip-ba3dd36c6775264ee6e7354ba1aabcd6e86d7298@git.kernel.org>
Git-Commit-ID: ba3dd36c6775264ee6e7354ba1aabcd6e86d7298
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 16 Feb 2011 13:50:10 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ba3dd36c6775264ee6e7354ba1aabcd6e86d7298
Gitweb:     http://git.kernel.org/tip/ba3dd36c6775264ee6e7354ba1aabcd6e86d7298
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 15 Feb 2011 12:41:46 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 16 Feb 2011 13:30:57 +0100

perf: Optimize hrtimer events

There is no need to re-initialize the hrtimer every time we start it,
so don't do that (shaves a few cycles). Also, since we know hrtimers
run at a fixed rate (nanoseconds) we can pre-compute the desired
frequency at which they tick. This avoids us having to go through the
whole adaptive frequency feedback logic (shaves another few cycles).

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1297448589.5226.47.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   35 ++++++++++++++++++++++++++++++++---
 1 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index e03be08..a0a6987 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -5602,6 +5602,10 @@ static enum hrtimer_restart perf_swevent_hrtimer(struct hrtimer *hrtimer)
 	u64 period;
 
 	event = container_of(hrtimer, struct perf_event, hw.hrtimer);
+
+	if (event->state != PERF_EVENT_STATE_ACTIVE)
+		return HRTIMER_NORESTART;
+
 	event->pmu->read(event);
 
 	perf_sample_data_init(&data, 0);
@@ -5628,9 +5632,6 @@ static void perf_swevent_start_hrtimer(struct perf_event *event)
 	if (!is_sampling_event(event))
 		return;
 
-	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	hwc->hrtimer.function = perf_swevent_hrtimer;
-
 	period = local64_read(&hwc->period_left);
 	if (period) {
 		if (period < 0)
@@ -5657,6 +5658,30 @@ static void perf_swevent_cancel_hrtimer(struct perf_event *event)
 	}
 }
 
+static void perf_swevent_init_hrtimer(struct perf_event *event)
+{
+	struct hw_perf_event *hwc = &event->hw;
+
+	if (!is_sampling_event(event))
+		return;
+
+	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hwc->hrtimer.function = perf_swevent_hrtimer;
+
+	/*
+	 * Since hrtimers have a fixed rate, we can do a static freq->period
+	 * mapping and avoid the whole period adjust feedback stuff.
+	 */
+	if (event->attr.freq) {
+		long freq = event->attr.sample_freq;
+
+		event->attr.sample_period = NSEC_PER_SEC / freq;
+		hwc->sample_period = event->attr.sample_period;
+		local64_set(&hwc->period_left, hwc->sample_period);
+		event->attr.freq = 0;
+	}
+}
+
 /*
  * Software event: cpu wall time clock
  */
@@ -5709,6 +5734,8 @@ static int cpu_clock_event_init(struct perf_event *event)
 	if (event->attr.config != PERF_COUNT_SW_CPU_CLOCK)
 		return -ENOENT;
 
+	perf_swevent_init_hrtimer(event);
+
 	return 0;
 }
 
@@ -5787,6 +5814,8 @@ static int task_clock_event_init(struct perf_event *event)
 	if (event->attr.config != PERF_COUNT_SW_TASK_CLOCK)
 		return -ENOENT;
 
+	perf_swevent_init_hrtimer(event);
+
 	return 0;
 }
 
