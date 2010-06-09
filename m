Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452Ab0FIKSR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 06:18:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:36424 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757437Ab0FIKSP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 06:18:15 -0400
Date: Wed, 9 Jun 2010 10:17:42 GMT
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
Subject: [tip:perf/core] perf: Add perf_event::child_count
Message-ID: <tip-a6e6dea68c18f705957573ee5596097c7e82d0e5@git.kernel.org>
Git-Commit-ID: a6e6dea68c18f705957573ee5596097c7e82d0e5
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 09 Jun 2010 10:17:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a6e6dea68c18f705957573ee5596097c7e82d0e5
Gitweb:     http://git.kernel.org/tip/a6e6dea68c18f705957573ee5596097c7e82d0e5
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Fri, 21 May 2010 14:27:58 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 9 Jun 2010 11:12:37 +0200

perf: Add perf_event::child_count

Only child counters adding back their values into the parent counter
are responsible for cross-cpu updates to event->count.

So if we pull that out into a new child_count variable, we get an
event->count that is only modified locally.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/perf_event.h |    1 +
 kernel/perf_event.c        |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 441992a..f34dab9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -671,6 +671,7 @@ struct perf_event {
 	enum perf_event_active_state	state;
 	unsigned int			attach_state;
 	atomic64_t			count;
+	atomic64_t			child_count;
 
 	/*
 	 * These are the total time in nanoseconds that the event
diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index ab4c0ff..a395fda 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -1738,7 +1738,7 @@ static void __perf_event_read(void *info)
 
 static inline u64 perf_event_count(struct perf_event *event)
 {
-	return atomic64_read(&event->count);
+	return atomic64_read(&event->count) + atomic64_read(&event->child_count);
 }
 
 static u64 perf_event_read(struct perf_event *event)
@@ -5379,7 +5379,7 @@ static void sync_child_event(struct perf_event *child_event,
 	/*
 	 * Add back the child's count to the parent's count:
 	 */
-	atomic64_add(child_val, &parent_event->count);
+	atomic64_add(child_val, &parent_event->child_count);
 	atomic64_add(child_event->total_time_enabled,
 		     &parent_event->child_total_time_enabled);
 	atomic64_add(child_event->total_time_running,
