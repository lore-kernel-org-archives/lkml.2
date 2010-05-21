Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab0EUOUt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 10:20:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:53602 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755897Ab0EUOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 10:20:46 -0400
Message-Id: <20100521135944.998322179@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 21 May 2010 15:42:08 +0200
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
Subject: [PATCH 3/4] perf: Add child_count
References: <20100521134205.781916350@chello.nl>
Content-Disposition: inline; filename=perf-event-child_count.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only child counters adding back their values into the parent counter
are responsible for cross-cpu updates to event->count.

So if we pull that out into a new child_count variable, we get an
event->count that is only modified locally.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -648,6 +648,7 @@ struct perf_event {
 
 	enum perf_event_active_state	state;
 	atomic64_t			count;
+	atomic64_t			child_count;
 
 	/*
 	 * These are the total time in nanoseconds that the event
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -1703,7 +1703,7 @@ static void __perf_event_read(void *info
 
 static inline u64 perf_event_count(struct perf_event *event)
 {
-	return atomic64_read(&event->count);
+	return atomic64_read(&event->count) + atomic64_read(&event->child_count);
 }
 
 static u64 perf_event_read(struct perf_event *event)
@@ -5282,7 +5282,7 @@ static void sync_child_event(struct perf
 	/*
 	 * Add back the child's count to the parent's count:
 	 */
-	atomic64_add(child_val, &parent_event->count);
+	atomic64_add(child_val, &parent_event->child_count);
 	atomic64_add(child_event->total_time_enabled,
 		     &parent_event->child_total_time_enabled);
 	atomic64_add(child_event->total_time_running,


