Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab0JTN3h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:29:37 -0400
Received: from smtp-out.google.com ([216.239.44.51]:55929 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545Ab0JTN3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:29:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=jXo/aJgBheDaz09ymfWQNldrU5JjEpKmhAGX4UKc25BkhqIuD0xbdgzujKyVLIZ8sA
         VyeQjSbPqY/kCDyNlNwQ==
Message-ID: <4cbeeebc.8ee7d80a.5a28.0d5f@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Wed, 20 Oct 2010 15:25:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com
Subject: [PATCH 2/2] perf_events: fix the fix for transaction recovery in group_sched_in() (v2)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the new fix. It simply ensures that tstamp_running
and tstamp_stopped are updated for all the events in a group
which could not event_sched_in() and which would not go thru
event_sched_out().

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index 39afdb0..517d827 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -691,6 +691,8 @@ group_sched_in(struct perf_event *group_event,
 {
 	struct perf_event *event, *partial_group = NULL;
 	struct pmu *pmu = group_event->pmu;
+	u64 now = ctx->time;
+	bool simulate = false;
 
 	if (group_event->state == PERF_EVENT_STATE_OFF)
 		return 0;
@@ -719,11 +721,27 @@ group_error:
 	/*
 	 * Groups can be scheduled in as one unit only, so undo any
 	 * partial group before returning:
+	 * The events up to the failed event are scheduled out normally,
+	 * tstamp_stopped will be updated.
+	 *
+	 * The failed events and the remaining siblings need to have
+	 * their timings updated as if they had gone thru event_sched_in()
+	 * and event_sched_out(). This is required to get consistent timings
+	 * across the group. This also takes care of the case where the group
+	 * could never be scheduled by ensuring tstamp_stopped is set to mark
+	 * the time the event was actually stopped, such that time delta
+	 * calculation in update_event_times() is correct.
 	 */
 	list_for_each_entry(event, &group_event->sibling_list, group_entry) {
 		if (event == partial_group)
-			break;
-		event_sched_out(event, cpuctx, ctx);
+			simulate = true;
+
+		if (simulate) {
+			event->tstamp_running += now - event->tstamp_stopped;
+			event->tstamp_stopped = now;
+		} else {
+			event_sched_out(event, cpuctx, ctx);
+		}
 	}
 	event_sched_out(group_event, cpuctx, ctx);
 
