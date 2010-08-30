Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab0H3MOX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:14:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:39374 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755530Ab0H3MNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:13:51 -0400
From: Matt Fleming <matt@console-pimps.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
        Robert Richter <robert.richter@amd.com>,
        Lin Ming <ming.m.lin@intel.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Don Zickus <dzickus@redhat.com>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Len Brown <lenb@kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>
Subject: [RFC][PATCH 3/5] perf: Add hrtimer code for PMI-less hardware counters
Date: Mon, 30 Aug 2010 13:13:45 +0100
Message-Id: <38d993baf1328403d9a1c4a2f012c4aa0e19feab.1283123521.git.matt@console-pimps.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
In-Reply-To: <cover.1283123521.git.matt@console-pimps.org>
References: <cover.1283123521.git.matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, it's impossible to periodically sample hardware counters that
lack performance monitoring interrupt (PMI) support. In order to sample
these counters we can create an event group which is backed by a
hrtimer, thereby simulating a PMI.

When the hrtimer goes off we sample the values in the hardware
counters. Because we obviously can't rely on the hrtimer going off at
exactly the sample period (say, every 1000 cache misses) the values need
to be weighted by the variable period since the last hrtimer went
off. This is so that we can compensate for the variability in hrtimer
period.

If perf record tries to create a sampling counter and the hardware
doesn't support it then we'll fall back to creating an event group with
a hrtimer.

Signed-off-by: Matt Fleming <matt@console-pimps.org>
---
 include/linux/perf_event.h |    4 ++
 kernel/perf_event.c        |   93 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 97 insertions(+), 0 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 000610c..57d4aa0 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -755,6 +755,10 @@ struct perf_event {
 
 	perf_overflow_handler_t		overflow_handler;
 
+	/* timer for sampling event group */
+	struct hrtimer			group_hrtimer;
+	s64				group_remaining;
+
 #ifdef CONFIG_EVENT_TRACING
 	struct ftrace_event_call	*tp_event;
 	struct event_filter		*filter;
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 2cda375..10a054b 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -85,6 +85,11 @@ void __weak hw_perf_enable(void)		{ barrier(); }
 
 void __weak perf_event_print_debug(void)	{ }
 
+static int perf_exclude_event(struct perf_event *event, struct pt_regs *regs);
+static void perf_swevent_overflow(struct perf_event *event, u64 overflow,
+				  int nmi, struct perf_sample_data *data,
+				  struct pt_regs *regs);
+
 static DEFINE_PER_CPU(int, perf_disable_count);
 
 void perf_disable(void)
@@ -402,6 +407,89 @@ static void perf_group_detach(struct perf_event *event)
 	}
 }
 
+static enum hrtimer_restart perf_group_event_hrtimer(struct hrtimer *hrtimer)
+{
+	struct perf_sample_data data;
+	struct pt_regs *regs;
+	struct perf_event *leader, *event;
+	struct hw_perf_event *hwc;
+	u64 period, nr;
+
+	leader = container_of(hrtimer, struct perf_event, group_hrtimer);
+	hwc = &leader->hw;
+	leader->pmu->read(leader);
+	nr = local64_read(&leader->count);
+
+	perf_sample_data_init(&data, 0);
+	data.period = leader->hw.last_period;
+	regs = get_irq_regs();
+
+	if (!regs || perf_exclude_event(leader, regs))
+		goto restart_timer;
+
+	if (!local64_add_negative(nr, &hwc->period_left))
+		perf_swevent_overflow(leader, 0, 0, &data, regs);
+
+	list_for_each_entry(event, &leader->sibling_list, group_entry) {
+		if (perf_exclude_event(event, regs))
+			continue;
+
+		event->pmu->read(event);
+		hwc = &event->hw;
+		nr = local64_read(&event->count);
+
+		if (local64_add_negative(nr, &hwc->period_left))
+			continue;
+
+		perf_swevent_overflow(event, 0, 0, &data, regs);
+	}
+
+restart_timer:
+	period = max_t(u64, 10000, leader->hw.sample_period);
+	hrtimer_forward_now(hrtimer, ns_to_ktime(period));
+
+	return HRTIMER_RESTART;
+}
+
+static void perf_group_start_hrtimer(struct perf_event *group_event)
+{
+	struct hw_perf_event *hwc = &group_event->hw;
+	struct hrtimer *hrtimer = &group_event->group_hrtimer;
+
+	hrtimer_init(hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+
+	hrtimer->function = perf_group_event_hrtimer;
+	if (hwc->sample_period) {
+		u64 period;
+
+		if (group_event->group_remaining) {
+			if (group_event->group_remaining < 0)
+				period = 10000;
+			else
+				period = group_event->group_remaining;
+			group_event->group_remaining = 0;
+		} else {
+			period = max_t(u64, 10000, hwc->sample_period);
+		}
+		__hrtimer_start_range_ns(hrtimer,
+				ns_to_ktime(period), 0,
+				HRTIMER_MODE_REL, 0);
+	}
+}
+
+static void perf_group_cancel_hrtimer(struct perf_event *group_event)
+{
+	struct hw_perf_event *hwc = &group_event->hw;
+	struct hrtimer *hrtimer = &group_event->group_hrtimer;
+
+	if (hwc->sample_period) {
+		ktime_t remaining = hrtimer_get_remaining(hrtimer);
+		group_event->group_remaining = ktime_to_ns(remaining);
+
+		hrtimer_cancel(&group_event->group_hrtimer);
+	}
+}
+
 static void
 event_sched_out(struct perf_event *event,
 		  struct perf_cpu_context *cpuctx,
@@ -436,6 +524,8 @@ group_sched_out(struct perf_event *group_event,
 	if (group_event->state != PERF_EVENT_STATE_ACTIVE)
 		return;
 
+	perf_group_cancel_hrtimer(group_event);
+
 	event_sched_out(group_event, cpuctx, ctx);
 
 	/*
@@ -702,6 +792,9 @@ group_sched_in(struct perf_event *group_event,
 		}
 	}
 
+	/* Kick off the hrtimer that samples this group */
+	perf_group_start_hrtimer(group_event);
+
 	if (!txn || !pmu->commit_txn(pmu))
 		return 0;
 
-- 
1.7.1

