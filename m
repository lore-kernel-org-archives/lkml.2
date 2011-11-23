Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab1KWBqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 20:46:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44900 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815Ab1KWBqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 20:46:09 -0500
Date: Tue, 22 Nov 2011 17:46:03 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
Message-ID: <20111123014603.GA19630@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftrace_event_call->filter is sched RCU protected but didn't use
rcu_assign_pointer().  Fix it.

TODO: Add proper __rcu annotation to call->filter and all its users.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/trace/trace_events_filter.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: work/kernel/trace/trace_events_filter.c
===================================================================
--- work.orig/kernel/trace/trace_events_filter.c
+++ work/kernel/trace/trace_events_filter.c
@@ -1686,7 +1686,7 @@ static int replace_system_preds(struct e
 		 * replace the filter for the call.
 		 */
 		filter = call->filter;
-		call->filter = filter_item->filter;
+		rcu_assign_pointer(call->filter, filter_item->filter);
 		filter_item->filter = filter;
 
 		fail = false;
@@ -1741,7 +1741,7 @@ int apply_event_filter(struct ftrace_eve
 		filter = call->filter;
 		if (!filter)
 			goto out_unlock;
-		call->filter = NULL;
+		rcu_assign_pointer(call->filter, NULL);
 		/* Make sure the filter is not being used */
 		synchronize_sched();
 		__free_filter(filter);
@@ -1782,7 +1782,7 @@ out:
 	 * string
 	 */
 	tmp = call->filter;
-	call->filter = filter;
+	rcu_assign_pointer(call->filter, filter);
 	if (tmp) {
 		/* Make sure the call is done with the filter */
 		synchronize_sched();
