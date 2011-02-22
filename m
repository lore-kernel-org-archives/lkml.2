Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab1BVWYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 17:24:53 -0500
Received: from kroah.org ([198.145.64.141]:33012 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755148Ab1BVWWh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 17:22:37 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 22 14:18:43 2011
Message-Id: <20110222221843.413069306@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 22 Feb 2011 14:17:43 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [64/70] perf: Fix throttle logic
In-Reply-To: <20110222222003.GA15831@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 4fe757dd48a9e95e1a071291f15dda5421dacb66 upstream.

It was possible to call pmu::start() on an already running event. In
particular this lead so some wreckage as the hrtimer events would
re-initialize active timers.

This was due to throttled events being activated again by scheduling.
Scheduling in a context would add and force start events, resulting in
running events with a possible throttle status. The next tick to hit
that task will then try to unthrottle the event and call ->start() on
an already running event.

Reported-by: Jeff Moyer <jmoyer@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -652,6 +652,10 @@ retry:
 	raw_spin_unlock_irq(&ctx->lock);
 }
 
+#define MAX_INTERRUPTS (~0ULL)
+
+static void perf_log_throttle(struct perf_event *event, int enable);
+
 static int
 event_sched_in(struct perf_event *event,
 		 struct perf_cpu_context *cpuctx,
@@ -662,6 +666,17 @@ event_sched_in(struct perf_event *event,
 
 	event->state = PERF_EVENT_STATE_ACTIVE;
 	event->oncpu = smp_processor_id();
+
+	/*
+	 * Unthrottle events, since we scheduled we might have missed several
+	 * ticks already, also for a heavily scheduling task there is little
+	 * guarantee it'll get a tick in a timely manner.
+	 */
+	if (unlikely(event->hw.interrupts == MAX_INTERRUPTS)) {
+		perf_log_throttle(event, 1);
+		event->hw.interrupts = 0;
+	}
+
 	/*
 	 * The new state must be visible before we turn it on in the hardware:
 	 */
@@ -1469,10 +1484,6 @@ void __perf_event_task_sched_in(struct t
 	}
 }
 
-#define MAX_INTERRUPTS (~0ULL)
-
-static void perf_log_throttle(struct perf_event *event, int enable);
-
 static u64 perf_calculate_period(struct perf_event *event, u64 nsec, u64 count)
 {
 	u64 frequency = event->attr.sample_freq;


