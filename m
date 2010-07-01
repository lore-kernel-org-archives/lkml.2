Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759597Ab0GAWE4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:04:56 -0400
Received: from kroah.org ([198.145.64.141]:33693 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758793Ab0GAVMp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 17:12:45 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:42:47 2010
Message-Id: <20100701174246.947615321@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:41:36 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: [006/200] perf: Fix exit() vs event-groups
In-Reply-To: <20100701175201.GA2149@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.34-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 96c21a460a37880abfbc8445d5b098dbab958a29 upstream.

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
LKML-Reference: <1273588935.1810.6.camel@laptop>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/perf_event.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/perf_event.c
+++ b/kernel/perf_event.c
@@ -262,6 +262,18 @@ static void update_event_times(struct pe
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
@@ -327,7 +339,7 @@ list_del_event(struct perf_event *event,
 	if (event->group_leader != event)
 		event->group_leader->nr_siblings--;
 
-	update_event_times(event);
+	update_group_times(event);
 
 	/*
 	 * If event was in error state, then keep it
@@ -509,18 +521,6 @@ retry:
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


