Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0JVNGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 09:06:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:41842 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751352Ab0JVNGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 09:06:10 -0400
Date: Fri, 22 Oct 2010 13:05:39 GMT
From: tip-bot for Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <4cbeeebc.8ee7d80a.5a28.0d5f@mx.google.com>
References: <4cbeeebc.8ee7d80a.5a28.0d5f@mx.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf_events: Fix for transaction recovery in group_sched_in()
Message-ID: <tip-d7842da470f244d258f21c5f72cd8388b3541d04@git.kernel.org>
Git-Commit-ID: d7842da470f244d258f21c5f72cd8388b3541d04
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 22 Oct 2010 13:05:40 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d7842da470f244d258f21c5f72cd8388b3541d04
Gitweb:     http://git.kernel.org/tip/d7842da470f244d258f21c5f72cd8388b3541d04
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 20 Oct 2010 15:25:01 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 22 Oct 2010 14:18:27 +0200

perf_events: Fix for transaction recovery in group_sched_in()

This new version (see commit 8e5fc1a) is much simpler and ensures that
in case of error in group_sched_in() during event_sched_in(), the
events up to the failed event go through regular event_sched_out().
But the failed event and the remaining events in the group have their
timings adjusted as if they had also gone through event_sched_in() and
event_sched_out(). This ensures timing uniformity across all events in
a group. This also takes care of the tstamp_stopped problem in case
the group could never be scheduled. The tstamp_stopped is updated as
if the event had actually run.

With this patch, the following now reports correct time_enabled,
in case the NMI watchdog is active:

$ task -e unhalted_core_cycles,instructions_retired,baclears,baclears
noploop 1
noploop for 1 seconds

0 unhalted_core_cycles (100.00% scaling, ena=997,552,872, run=0)
0 instructions_retired (100.00% scaling, ena=997,552,872, run=0)
0 baclears (100.00% scaling, ena=997,552,872, run=0)
0 baclears (100.00% scaling, ena=997,552,872, run=0)

And the older test case also works:

$ task -einstructions_retired,baclears,baclears -e
unhalted_core_cycles,baclears,baclears sleep 5

1680885 instructions_retired (69.39% scaling, ena=950756, run=291006)
  10735 baclears (69.39% scaling, ena=950756, run=291006)
  10735 baclears (69.39% scaling, ena=950756, run=291006)

      0 unhalted_core_cycles (100.00% scaling, ena=817932, run=0)
      0 baclears (100.00% scaling, ena=817932, run=0)
      0 baclears (100.00% scaling, ena=817932, run=0)

Signed-off-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <4cbeeebc.8ee7d80a.5a28.0d5f@mx.google.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   22 ++++++++++++++++++++--
 1 files changed, 20 insertions(+), 2 deletions(-)

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
 
