Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0EKPnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 11:43:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:37746 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753981Ab0EKPnt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 11:43:49 -0400
Date: Tue, 11 May 2010 15:43:19 GMT
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1273588935.1810.6.camel@laptop>
References: <1273588935.1810.6.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix exit() vs event-groups
Message-ID: <tip-96c21a460a37880abfbc8445d5b098dbab958a29@git.kernel.org>
Git-Commit-ID: 96c21a460a37880abfbc8445d5b098dbab958a29
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 May 2010 15:43:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  96c21a460a37880abfbc8445d5b098dbab958a29
Gitweb:     http://git.kernel.org/tip/96c21a460a37880abfbc8445d5b098dbab958a29
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 11 May 2010 16:19:10 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 11 May 2010 17:08:24 +0200

perf: Fix exit() vs event-groups

Corey reported that the value scale times of group siblings are not
updated when the monitored task dies.

The problem appears to be that we only update the group leader's
time values, fix it by updating the whole group.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: <stable@kernel.org> # .34.x
LKML-Reference: <1273588935.1810.6.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/perf_event.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/kernel/perf_event.c b/kernel/perf_event.c
index c97e825..a4fa381 100644
--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -255,6 +255,18 @@ static void update_event_times(struct perf_event *event)
 	event->total_time_running = run_end - event->tstamp_running;
 }
 
+/*
+ * Update total_time_enabled and total_time_running for all events in a group.
+ */
+static void update_group_times(struct perf_event *leader)
+{
+	struct perf_event *event;
+
+	update_event_times(leader);
+	list_for_each_entry(event, &leader->sibling_list, group_entry)
+		update_event_times(event);
+}
+
 static struct list_head *
 ctx_group_list(struct perf_event *event, struct perf_event_context *ctx)
 {
@@ -320,7 +332,7 @@ list_del_event(struct perf_event *event, struct perf_event_context *ctx)
 	if (event->group_leader != event)
 		event->group_leader->nr_siblings--;
 
-	update_event_times(event);
+	update_group_times(event);
 
 	/*
 	 * If event was in error state, then keep it
@@ -502,18 +514,6 @@ retry:
 }
 
 /*
- * Update total_time_enabled and total_time_running for all events in a group.
- */
-static void update_group_times(struct perf_event *leader)
-{
-	struct perf_event *event;
-
-	update_event_times(leader);
-	list_for_each_entry(event, &leader->sibling_list, group_entry)
-		update_event_times(event);
-}
-
-/*
  * Cross CPU call to disable a performance event
  */
 static void __perf_event_disable(void *info)
