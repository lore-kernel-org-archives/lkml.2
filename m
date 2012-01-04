Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755721Ab2ADOX4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 09:23:56 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34579 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753267Ab2ADOXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 09:23:53 -0500
Date: Wed, 4 Jan 2012 15:23:49 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: perterz@infradead.org, mingo@elte.hu, gleb@redhat.com, asharma@fb.com,
        vince@deater.net, wcohen@redhat.com
Subject: [PATCH] perf_events: proposed fix for broken intr throttling
 mechanism
Message-ID: <20120104142349.GA4716@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In running some tests with 3.2.0-rc7-tip, I noticed unexpected throttling
notification samples. I was using fixed period with a long enough period
that I could not possibly hit the default limit of 100000 samples/sec/cpu.

I investigated the matter and discovered that the following commit
is the culprit:

commit 0f5a2601284237e2ba089389fd75d67f77626cef
Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date:   Wed Nov 16 14:38:16 2011 +0100

    perf: Avoid a useless pmu_disable() in the perf-tick


The throttling mechanism REQUIRES that the hwc->interrupt counter be reset
at EACH timer tick. This is regardless of the fact that the counter is in fixed
period or frequency mode. The optimization introduced in this patch breaks this
by avoiding calling perf_ctx_adjust_freq() at each timer tick. For events with
fixed period, it would not adjust any period at all BUT it would reset the
throttling counter.

Given the way the throttling mechanism is implemented we cannot avoid doing
some work at each timer tick. Otherwise we loose many samples for no good
reasons.

One may also question the motivation behind checking the interrupt rate at
each timer tick rather than every second, i.e., average it out over a longer
period.

I see two solutions short term:
   1 - revert the commit above
   2 - special case the situation with no frequency-based sampling event

I have implemented solution 2 with the draft fix below. It does not invoke
perf_pmu_enable()/perf_pmu_disable().  I am not clear on whether or not this
is really needed in this case. Please advise.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 91fb68a..d1fe81a 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2325,6 +2325,37 @@ static void perf_adjust_period(struct perf_event *event, u64 nsec, u64 count)
 	}
 }
 
+static void perf_ctx_adjust_throttle(struct perf_event_context *ctx)
+{
+	struct perf_event *event;
+	struct hw_perf_event *hwc;
+	u64 interrupts;
+
+	raw_spin_lock(&ctx->lock);
+
+	list_for_each_entry_rcu(event, &ctx->event_list, event_entry) {
+		if (event->state != PERF_EVENT_STATE_ACTIVE)
+			continue;
+
+		if (!event_filter_match(event))
+			continue;
+
+		hwc = &event->hw;
+
+		interrupts = hwc->interrupts;
+		hwc->interrupts = 0;
+
+		/*
+		 * unthrottle events on the tick
+		 */
+		if (interrupts == MAX_INTERRUPTS) {
+			perf_log_throttle(event, 1);
+			event->pmu->start(event, 0);
+		}
+	}
+	raw_spin_unlock(&ctx->lock);
+}
+
 static void perf_ctx_adjust_freq(struct perf_event_context *ctx, u64 period)
 {
 	struct perf_event *event;
@@ -2445,10 +2476,24 @@ void perf_event_task_tick(void)
 {
 	struct list_head *head = &__get_cpu_var(rotation_list);
 	struct perf_cpu_context *cpuctx, *tmp;
+	struct perf_event_context *ctx;
 
 	WARN_ON(!irqs_disabled());
 
 	list_for_each_entry_safe(cpuctx, tmp, head, rotation_list) {
+
+		/*
+		 * throttling counter must be reset at each tick
+		 * unthrottling must be done at each tick
+		 */
+		ctx = &cpuctx->ctx;
+		if (!ctx->nr_freq)
+			perf_ctx_adjust_throttle(&cpuctx->ctx);
+
+		ctx = cpuctx->task_ctx;
+		if (ctx && !ctx->nr_freq)
+			perf_ctx_adjust_throttle(ctx);
+
 		if (cpuctx->jiffies_interval == 1 ||
 				!(jiffies % cpuctx->jiffies_interval))
 			perf_rotate_context(cpuctx);
