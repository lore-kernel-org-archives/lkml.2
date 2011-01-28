Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893Ab1A1EeO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:34:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754788Ab1A1Edr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:47 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=hmvib4FNHO4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=sqFdJYbxHO_ElygKPz0A:9 a=tdiBwGw4tEo29lwBVd8A:7 a=wOW82lm90AoO72dZ4rqE7RLsYvAA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043344.489199520@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:23 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 05/12] tracing/filter: Allocate the preds in an array
References: <20110128042118.561146147@goodmis.org>
Content-Disposition: inline; filename=0005-tracing-filter-Allocate-the-preds-in-an-array.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently we allocate an array of pointers to filter_preds, and then
allocate a separate filter_pred for each item in the array.
This adds slight overhead in the filters as it needs to derefernce
twice to get to the op condition.

Allocating the preds themselves in a single array removes a dereference
as well as helps on the cache footprint.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |    2 +-
 kernel/trace/trace_events_filter.c |   31 +++++++++----------------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 441fc1b..254d04a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -663,7 +663,7 @@ struct ftrace_event_field {
 struct event_filter {
 	int			n_preds;	/* Number assigned */
 	int			a_preds;	/* allocated */
-	struct filter_pred	**preds;
+	struct filter_pred	*preds;
 	char			*filter_string;
 };
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1c14cf2..8c560eb 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -362,7 +362,7 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 {
 	int match = -1, top = 0, val1 = 0, val2 = 0;
 	int stack[MAX_FILTER_PRED];
-	struct filter_pred **preds;
+	struct filter_pred *preds;
 	struct filter_pred *pred;
 	int n_preds = ACCESS_ONCE(filter->n_preds);
 	int i;
@@ -377,7 +377,7 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 	preds = rcu_dereference_sched(filter->preds);
 
 	for (i = 0; i < n_preds; i++) {
-		pred = preds[i];
+		pred = &preds[i];
 		if (!pred->pop_n) {
 			match = pred->fn(pred, rec);
 			stack[top++] = match;
@@ -559,10 +559,8 @@ static void __free_preds(struct event_filter *filter)
 	int i;
 
 	if (filter->preds) {
-		for (i = 0; i < filter->a_preds; i++) {
-			if (filter->preds[i])
-				filter_free_pred(filter->preds[i]);
-		}
+		for (i = 0; i < filter->a_preds; i++)
+			kfree(filter->preds[i].field_name);
 		kfree(filter->preds);
 		filter->preds = NULL;
 	}
@@ -572,7 +570,6 @@ static void __free_preds(struct event_filter *filter)
 
 static void reset_preds(struct event_filter *filter)
 {
-	struct filter_pred *pred;
 	int n_preds = filter->n_preds;
 	int i;
 
@@ -580,10 +577,8 @@ static void reset_preds(struct event_filter *filter)
 	if (!filter->preds)
 		return;
 
-	for (i = 0; i < n_preds; i++) {
-		pred = filter->preds[i];
-		pred->fn = filter_pred_none;
-	}
+	for (i = 0; i < n_preds; i++)
+		filter->preds[i].fn = filter_pred_none;
 }
 
 static void filter_disable_preds(struct ftrace_event_call *call)
@@ -659,19 +654,11 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 		return -EINVAL;
 
 	for (i = 0; i < n_preds; i++) {
-		pred = filter->preds[i];
-		if (!pred)
-			pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-		if (!pred)
-			goto oom;
+		pred = &filter->preds[i];
 		pred->fn = filter_pred_none;
-		filter->preds[i] = pred;
 	}
 
 	return 0;
- oom:
-	__free_preds(filter);
-	return -ENOMEM;
 }
 
 static int init_filter(struct ftrace_event_call *call)
@@ -731,8 +718,8 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 	}
 
 	idx = filter->n_preds;
-	filter_clear_pred(filter->preds[idx]);
-	err = filter_set_pred(filter->preds[idx], pred, fn);
+	filter_clear_pred(&filter->preds[idx]);
+	err = filter_set_pred(&filter->preds[idx], pred, fn);
 	if (err)
 		return err;
 
-- 
1.7.2.3


