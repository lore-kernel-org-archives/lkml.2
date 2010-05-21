Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345Ab0EUOU5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:20:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:53609 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0EUOUy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:20:54 -0400
Message-Id: <20100521135944.944346108@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 15:42:07 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       David Miller <davem@davemloft.net>, Paul Mundt <lethal@linux-sh.org>,
       Will Deacon <will.deacon@arm.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 2/4] perf: Add perf_event_count()
References: <20100521134205.781916350@chello.nl>
Content-Disposition: inline; filename=perf-event_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create a helper function for those sites that want to read the event count.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 kernel/perf_event.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1701,6 +1701,11 @@ static void __perf_event_read(void *info
 	event->pmu->read(event);
 }
 
+static inline u64 perf_event_count(struct perf_event *event)
+{
+	return atomic64_read(&event->count);
+}
+
 static u64 perf_event_read(struct perf_event *event)
 {
 	/*
@@ -1720,7 +1725,7 @@ static u64 perf_event_read(struct perf_e
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
-	return atomic64_read(&event->count);
+	return perf_event_count(event);
 }
 
 /*
@@ -2280,7 +2285,7 @@ void perf_event_update_userpage(struct p
 	++userpg->lock;
 	barrier();
 	userpg->index = perf_event_index(event);
-	userpg->offset = atomic64_read(&event->count);
+	userpg->offset = perf_event_count(event);
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&event->hw.prev_count);
 
@@ -3125,7 +3130,7 @@ static void perf_output_read_one(struct 
 	u64 values[4];
 	int n = 0;
 
-	values[n++] = atomic64_read(&event->count);
+	values[n++] = perf_event_count(event);
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
 		values[n++] = event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
@@ -3162,7 +3167,7 @@ static void perf_output_read_group(struc
 	if (leader != event)
 		leader->pmu->read(leader);
 
-	values[n++] = atomic64_read(&leader->count);
+	values[n++] = perf_event_count(leader);
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
 
@@ -3174,7 +3179,7 @@ static void perf_output_read_group(struc
 		if (sub != event)
 			sub->pmu->read(sub);
 
-		values[n++] = atomic64_read(&sub->count);
+		values[n++] = perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
@@ -5272,7 +5277,7 @@ static void sync_child_event(struct perf
 	if (child_event->attr.inherit_stat)
 		perf_event_read_event(child_event, child);
 
-	child_val = atomic64_read(&child_event->count);
+	child_val = perf_event_count(child_event);
 
 	/*
 	 * Add back the child's count to the parent's count:


