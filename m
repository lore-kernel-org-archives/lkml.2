Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab1BHB7g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:59:36 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754425Ab1BHB7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:34 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=1c_AhfdlgdAA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=BOclaGDz0n5iUR0CXbwA:9 a=UmB0VJidCqf4SsKDzdAA:7 a=7sa5asj__8m2xKu2FIkkK5sqj2sA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=W1SUwlX49T1ioF66:21 a=H8q8FXgMhc9ZQ2bF:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015931.359788457@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 03/14] tracing/filter: Dynamically allocate preds
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0003-tracing-filter-Dynamically-allocate-preds.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

For every filter that is made, we create predicates to hold every
operation within the filter. We have a max of 32 predicates that we
can hold. Currently, we allocate all 32 even if we only need to
use one.

Part of the reason we do this is that the filter can be used at
any moment by any event. Fortunately, the filter is only used
with preemption disabled. By reseting the count of preds used "n_preds"
to zero, then performing a synchronize_sched(), we can safely
free and reallocate a new array of preds.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |    3 +-
 kernel/trace/trace_events_filter.c |  143 +++++++++++++++++++++++++++---------
 2 files changed, 110 insertions(+), 36 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 1597bc0..441fc1b 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -661,7 +661,8 @@ struct ftrace_event_field {
 };
 
 struct event_filter {
-	int			n_preds;
+	int			n_preds;	/* Number assigned */
+	int			a_preds;	/* allocated */
 	struct filter_pred	**preds;
 	char			*filter_string;
 };
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 5d719b3..aac6a61 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -362,6 +362,7 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 {
 	int match = -1, top = 0, val1 = 0, val2 = 0;
 	int stack[MAX_FILTER_PRED];
+	struct filter_pred **preds;
 	struct filter_pred *pred;
 	int n_preds = ACCESS_ONCE(filter->n_preds);
 	int i;
@@ -370,8 +371,13 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 	if (!n_preds)
 		return 1;
 
+	/*
+	 * n_preds and filter->preds is protect with preemption disabled.
+	 */
+	preds = rcu_dereference_sched(filter->preds);
+
 	for (i = 0; i < n_preds; i++) {
-		pred = filter->preds[i];
+		pred = preds[i];
 		if (!pred->pop_n) {
 			match = pred->fn(pred, rec);
 			stack[top++] = match;
@@ -548,46 +554,55 @@ static int filter_set_pred(struct filter_pred *dest,
 	return 0;
 }
 
+static void __free_preds(struct event_filter *filter)
+{
+	int i;
+
+	if (filter->preds) {
+		for (i = 0; i < filter->a_preds; i++) {
+			if (filter->preds[i])
+				filter_free_pred(filter->preds[i]);
+		}
+		kfree(filter->preds);
+		filter->preds = NULL;
+	}
+	filter->a_preds = 0;
+	filter->n_preds = 0;
+}
+
 static void filter_disable_preds(struct ftrace_event_call *call)
 {
 	struct event_filter *filter = call->filter;
 	int i;
 
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
+	if (filter->preds) {
+		for (i = 0; i < filter->n_preds; i++)
+			filter->preds[i]->fn = filter_pred_none;
+	}
 	filter->n_preds = 0;
-
-	for (i = 0; i < MAX_FILTER_PRED; i++)
-		filter->preds[i]->fn = filter_pred_none;
 }
 
-static void __free_preds(struct event_filter *filter)
+static void __free_filter(struct event_filter *filter)
 {
-	int i;
-
 	if (!filter)
 		return;
 
-	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		if (filter->preds[i])
-			filter_free_pred(filter->preds[i]);
-	}
-	kfree(filter->preds);
+	__free_preds(filter);
 	kfree(filter->filter_string);
 	kfree(filter);
 }
 
 void destroy_preds(struct ftrace_event_call *call)
 {
-	__free_preds(call->filter);
+	__free_filter(call->filter);
 	call->filter = NULL;
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 }
 
-static struct event_filter *__alloc_preds(void)
+static struct event_filter *__alloc_filter(void)
 {
 	struct event_filter *filter;
-	struct filter_pred *pred;
-	int i;
 
 	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
 	if (!filter)
@@ -595,32 +610,63 @@ static struct event_filter *__alloc_preds(void)
 
 	filter->n_preds = 0;
 
-	filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred), GFP_KERNEL);
+	return filter;
+}
+
+static int __alloc_preds(struct event_filter *filter, int n_preds)
+{
+	struct filter_pred *pred;
+	int i;
+
+	if (filter->preds) {
+		if (filter->a_preds < n_preds) {
+			/* We need to reallocate */
+			filter->n_preds = 0;
+			/*
+			 * It is possible that the filter is currently
+			 * being used. We need to zero out the number
+			 * of preds, wait on preemption and then free
+			 * the preds.
+			 */
+			synchronize_sched();
+			__free_preds(filter);
+		}
+	}
+
+	if (!filter->preds) {
+		filter->preds =
+			kzalloc(sizeof(*filter->preds) * n_preds, GFP_KERNEL);
+		filter->a_preds = n_preds;
+	}
 	if (!filter->preds)
-		goto oom;
+		return -ENOMEM;
+
+	if (WARN_ON(filter->a_preds < n_preds))
+		return -EINVAL;
 
-	for (i = 0; i < MAX_FILTER_PRED; i++) {
-		pred = kzalloc(sizeof(*pred), GFP_KERNEL);
+	for (i = 0; i < n_preds; i++) {
+		pred = filter->preds[i];
+		if (!pred)
+			pred = kzalloc(sizeof(*pred), GFP_KERNEL);
 		if (!pred)
 			goto oom;
 		pred->fn = filter_pred_none;
 		filter->preds[i] = pred;
 	}
 
-	return filter;
-
-oom:
+	return 0;
+ oom:
 	__free_preds(filter);
-	return ERR_PTR(-ENOMEM);
+	return -ENOMEM;
 }
 
-static int init_preds(struct ftrace_event_call *call)
+static int init_filter(struct ftrace_event_call *call)
 {
 	if (call->filter)
 		return 0;
 
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
-	call->filter = __alloc_preds();
+	call->filter = __alloc_filter();
 	if (IS_ERR(call->filter))
 		return PTR_ERR(call->filter);
 
@@ -636,7 +682,7 @@ static int init_subsystem_preds(struct event_subsystem *system)
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		err = init_preds(call);
+		err = init_filter(call);
 		if (err)
 			return err;
 	}
@@ -665,7 +711,7 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 {
 	int idx, err;
 
-	if (filter->n_preds == MAX_FILTER_PRED) {
+	if (WARN_ON(filter->n_preds == filter->a_preds)) {
 		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 		return -ENOSPC;
 	}
@@ -1179,6 +1225,20 @@ static int check_preds(struct filter_parse_state *ps)
 	return 0;
 }
 
+static int count_preds(struct filter_parse_state *ps)
+{
+	struct postfix_elt *elt;
+	int n_preds = 0;
+
+	list_for_each_entry(elt, &ps->postfix, list) {
+		if (elt->op == OP_NONE)
+			continue;
+		n_preds++;
+	}
+
+	return n_preds;
+}
+
 static int replace_preds(struct ftrace_event_call *call,
 			 struct event_filter *filter,
 			 struct filter_parse_state *ps,
@@ -1191,10 +1251,23 @@ static int replace_preds(struct ftrace_event_call *call,
 	int err;
 	int n_preds = 0;
 
+	n_preds = count_preds(ps);
+	if (n_preds >= MAX_FILTER_PRED) {
+		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
+		return -ENOSPC;
+	}
+
 	err = check_preds(ps);
 	if (err)
 		return err;
 
+	if (!dry_run) {
+		err = __alloc_preds(filter, n_preds);
+		if (err)
+			return err;
+	}
+
+	n_preds = 0;
 	list_for_each_entry(elt, &ps->postfix, list) {
 		if (elt->op == OP_NONE) {
 			if (!operand1)
@@ -1208,7 +1281,7 @@ static int replace_preds(struct ftrace_event_call *call,
 			continue;
 		}
 
-		if (n_preds++ == MAX_FILTER_PRED) {
+		if (WARN_ON(n_preds++ == MAX_FILTER_PRED)) {
 			parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 			return -ENOSPC;
 		}
@@ -1283,7 +1356,7 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 
 	mutex_lock(&event_mutex);
 
-	err = init_preds(call);
+	err = init_filter(call);
 	if (err)
 		goto out_unlock;
 
@@ -1376,7 +1449,7 @@ void ftrace_profile_free_filter(struct perf_event *event)
 	struct event_filter *filter = event->filter;
 
 	event->filter = NULL;
-	__free_preds(filter);
+	__free_filter(filter);
 }
 
 int ftrace_profile_set_filter(struct perf_event *event, int event_id,
@@ -1402,7 +1475,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	if (event->filter)
 		goto out_unlock;
 
-	filter = __alloc_preds();
+	filter = __alloc_filter();
 	if (IS_ERR(filter)) {
 		err = PTR_ERR(filter);
 		goto out_unlock;
@@ -1411,7 +1484,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	err = -ENOMEM;
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
 	if (!ps)
-		goto free_preds;
+		goto free_filter;
 
 	parse_init(ps, filter_ops, filter_str);
 	err = filter_parse(ps);
@@ -1427,9 +1500,9 @@ free_ps:
 	postfix_clear(ps);
 	kfree(ps);
 
-free_preds:
+free_filter:
 	if (err)
-		__free_preds(filter);
+		__free_filter(filter);
 
 out_unlock:
 	mutex_unlock(&event_mutex);
-- 
1.7.2.3


