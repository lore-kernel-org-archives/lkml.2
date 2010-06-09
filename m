Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab0FIKR6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:17:58 -0400
Received: from hera.kernel.org ([140.211.167.34]:36397 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626Ab0FIKR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:17:56 -0400
Date: Wed, 9 Jun 2010 10:17:24 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, rostedt@goodmis.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Add perf_event_count()
Message-ID: <tip-b5e58793c7a8ec35e72ea6ec6c353499dd189809@git.kernel.org>
Git-Commit-ID: b5e58793c7a8ec35e72ea6ec6c353499dd189809
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:17:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b5e58793c7a8ec35e72ea6ec6c353499dd189809
Gitweb:     http://git.kernel.org/tip/b5e58793c7a8ec35e72ea6ec6c353499dd189809
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 14:43:12 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:36 +0200

perf: Add perf_event_count()

Create a helper function for those sites that want to read the event count.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index f75c9c9..ab4c0ff 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1736,6 +1736,11 @@ static void __perf_event_read(void *info)
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
@@ -1755,7 +1760,7 @@ static u64 perf_event_read(struct perf_event *event)
 		raw_spin_unlock_irqrestore(&ctx->lock, flags);
 	}
 
-	return atomic64_read(&event->count);
+	return perf_event_count(event);
 }
 
 /*
@@ -2352,7 +2357,7 @@ void perf_event_update_userpage(struct perf_event *event)
 	++userpg->lock;
 	barrier();
 	userpg->index = perf_event_index(event);
-	userpg->offset = atomic64_read(&event->count);
+	userpg->offset = perf_event_count(event);
 	if (event->state == PERF_EVENT_STATE_ACTIVE)
 		userpg->offset -= atomic64_read(&event->hw.prev_count);
 
@@ -3211,7 +3216,7 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	u64 values[4];
 	int n = 0;
 
-	values[n++] = atomic64_read(&event->count);
+	values[n++] = perf_event_count(event);
 	if (read_format & PERF_FORMAT_TOTAL_TIME_ENABLED) {
 		values[n++] = event->total_time_enabled +
 			atomic64_read(&event->child_total_time_enabled);
@@ -3248,7 +3253,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	if (leader != event)
 		leader->pmu->read(leader);
 
-	values[n++] = atomic64_read(&leader->count);
+	values[n++] = perf_event_count(leader);
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
 
@@ -3260,7 +3265,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		if (sub != event)
 			sub->pmu->read(sub);
 
-		values[n++] = atomic64_read(&sub->count);
+		values[n++] = perf_event_count(sub);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
@@ -5369,7 +5374,7 @@ static void sync_child_event(struct perf_event *child_event,
 	if (child_event->attr.inherit_stat)
 		perf_event_read_event(child_event, child);
 
-	child_val = atomic64_read(&child_event->count);
+	child_val = perf_event_count(child_event);
 
 	/*
 	 * Add back the child's count to the parent's count:
