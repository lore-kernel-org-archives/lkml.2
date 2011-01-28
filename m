Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754815Ab1A1Edr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:33:47 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:65481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1A1Edp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:45 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=tgpPXHRaFucA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=xDTOUkD8CWc6uH9sUDgA:9 a=Qo7xYTygUzUySyZRAh4A:7 a=u4Pp2iQZBCaVXkDdBbwUkwh86boA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043344.249936586@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:22 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 04/12] tracing/filter: Call synchronize_sched() just once for system filters
References: <20110128042118.561146147@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-filter-Call-synchronize_sched-just-once-for-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

By separating out the reseting of the filter->n_preds to zero from
the reallocation of preds for the filter, we can reset groups of
filters first, call synchronize_sched() just once, and then reallocate
each of the filters in the system group.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   80 ++++++++++++++++++++++++++++-------
 1 files changed, 64 insertions(+), 16 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 932f605..1c14cf2 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -570,17 +570,28 @@ static void __free_preds(struct event_filter *filter)
 	filter->n_preds = 0;
 }
 
+static void reset_preds(struct event_filter *filter)
+{
+	struct filter_pred *pred;
+	int n_preds = filter->n_preds;
+	int i;
+
+	filter->n_preds = 0;
+	if (!filter->preds)
+		return;
+
+	for (i = 0; i < n_preds; i++) {
+		pred = filter->preds[i];
+		pred->fn = filter_pred_none;
+	}
+}
+
 static void filter_disable_preds(struct ftrace_event_call *call)
 {
 	struct event_filter *filter = call->filter;
-	int i;
 
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
-	if (filter->preds) {
-		for (i = 0; i < filter->n_preds; i++)
-			filter->preds[i]->fn = filter_pred_none;
-	}
-	filter->n_preds = 0;
+	reset_preds(filter);
 }
 
 static void __free_filter(struct event_filter *filter)
@@ -620,15 +631,18 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 
 	if (filter->preds) {
 		if (filter->a_preds < n_preds) {
-			/* We need to reallocate */
-			filter->n_preds = 0;
 			/*
-			 * It is possible that the filter is currently
-			 * being used. We need to zero out the number
-			 * of preds, wait on preemption and then free
-			 * the preds.
+			 * We need to reallocate.
+			 * We should have already have zeroed out
+			 * the pred count and called synchronized_sched()
+			 * to make sure no one is using the preds.
 			 */
 			synchronize_sched();
+			if (WARN_ON_ONCE(filter->n_preds)) {
+				/* We need to reset it now */
+				filter->n_preds = 0;
+				synchronize_sched();
+			}
 			__free_preds(filter);
 		}
 	}
@@ -1267,6 +1281,7 @@ static int replace_preds(struct ftrace_event_call *call,
 			return err;
 	}
 
+	n_preds = 0;
 	list_for_each_entry(elt, &ps->postfix, list) {
 		if (elt->op == OP_NONE) {
 			if (!operand1)
@@ -1327,6 +1342,30 @@ static int replace_system_preds(struct event_subsystem *system,
 		/* try to see if the filter can be applied */
 		err = replace_preds(call, filter, ps, filter_string, true);
 		if (err)
+			goto fail;
+	}
+
+	/* set all filter pred counts to zero */
+	list_for_each_entry(call, &ftrace_events, list) {
+		struct event_filter *filter = call->filter;
+
+		if (strcmp(call->class->system, system->name) != 0)
+			continue;
+
+		reset_preds(filter);
+	}
+
+	/*
+	 * Since some of the preds may be used under preemption
+	 * we need to wait for them to finish before we may
+	 * reallocate them.
+	 */
+	synchronize_sched();
+
+	list_for_each_entry(call, &ftrace_events, list) {
+		struct event_filter *filter = call->filter;
+
+		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
 		/* really apply the filter */
@@ -1341,11 +1380,13 @@ static int replace_system_preds(struct event_subsystem *system,
 		fail = false;
 	}
 
-	if (fail) {
-		parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
-		return -EINVAL;
-	}
+	if (fail)
+		goto fail;
+
 	return 0;
+ fail:
+	parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
+	return -EINVAL;
 }
 
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
@@ -1380,6 +1421,13 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 		goto out;
 	}
 
+	/*
+	 * Make sure all the pred counts are zero so that
+	 * no task is using it when we reallocate the preds array.
+	 */
+	reset_preds(call->filter);
+	synchronize_sched();
+
 	err = replace_preds(call, call->filter, ps, filter_string, false);
 	if (err)
 		append_filter_err(ps, call->filter);
-- 
1.7.2.3


