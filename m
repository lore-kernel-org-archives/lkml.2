Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab0EKOmT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:42:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615Ab0EKOmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:42:18 -0400
Subject: Re: [BUG] perf_event: when events are grouped, the time enabled /
 running values are incorrect
From: Peter Zijlstra <peterz@infradead.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Stephane Eranian <eranian@googlemail.com>
In-Reply-To: <4BE4C4BF.6020801@linux.vnet.ibm.com>
References: <4BE4C4BF.6020801@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 16:42:15 +0200
Message-ID: <1273588935.1810.6.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-07 at 18:56 -0700, Corey Ashford wrote:
> Hi,
> 
> There appears to be a bug in the kernel related to reading up the time 
> running and enabled values for events that are in a group.  The group 
> leader's time running and time enable values look correct, but all of 
> the other group members have a zero value for their time running and 
> time enabled fields.
> 
> This happens only when remote monitoring a process (perhaps only after 
> it has terminated)... when self monitoring, the time running/enabled 
> values come out non-zero, and the values are the same for all of the 
> counters (as one would expect since they can be enabled/disabled 
> simultaneously).
> 
> I've attached a test case which you can place in the tools/perf 
> subdirectory and compile with just:
> 
> gcc -o show_re_bug show_re_bug.c

The below seems to fix this for me.

---
Subject: perf: Fix exit() vs event-groups
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue May 11 16:19:10 CEST 2010

Corey reported that the value scale times of group siblings are not
updated when the monitored task dies.

The problem appears to be that we only update the group leader's
time values, fix it by updating the whole group.

Reported-by: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: stable@kernel.org
---
 kernel/perf_event.c |   44 +++++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 21 deletions(-)

Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -255,6 +255,18 @@ static void update_event_times(struct pe
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
@@ -320,7 +332,7 @@ list_del_event(struct perf_event *event,
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


