Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1BHCAR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:00:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755060Ab1BHB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:35 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=fdfre6W0wL8A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=4nXLui6F4574PCC2VhcA:9 a=xlH-MX4oSH6v1ORjmcIA:7 a=bXuvb0LMyR_VOspCFsVRz53GyEgA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015934.334517926@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:30 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 13/14] tracing/filter: Swap entire filter of events
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0013-tracing-filter-Swap-entire-filter-of-events.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

When creating a new filter, instead of allocating the filter to the
event call first and then processing the filter, it is easier to
process a temporary filter and then just swap it with the call filter.
By doing this, it simplifies the code.

A filter is allocated and processed, when it is done, it is
swapped with the call filter, synchronize_sched() is called to make
sure all callers are done with the old filter (filters are called
with premption disabled), and then the old filter is freed.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |  251 +++++++++++++++++++++---------------
 1 files changed, 146 insertions(+), 105 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2403ce5..f5d335d 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -425,10 +425,15 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 	struct filter_pred *preds;
 	struct filter_pred *pred;
 	struct filter_pred *root;
-	int n_preds = ACCESS_ONCE(filter->n_preds);
+	int n_preds;
 	int done = 0;
 
 	/* no filter is considered a match */
+	if (!filter)
+		return 1;
+
+	n_preds = filter->n_preds;
+
 	if (!n_preds)
 		return 1;
 
@@ -509,6 +514,9 @@ static void parse_error(struct filter_parse_state *ps, int err, int pos)
 
 static void remove_filter_string(struct event_filter *filter)
 {
+	if (!filter)
+		return;
+
 	kfree(filter->filter_string);
 	filter->filter_string = NULL;
 }
@@ -568,9 +576,10 @@ static void append_filter_err(struct filter_parse_state *ps,
 
 void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 {
-	struct event_filter *filter = call->filter;
+	struct event_filter *filter;
 
 	mutex_lock(&event_mutex);
+	filter = call->filter;
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
@@ -581,9 +590,10 @@ void print_event_filter(struct ftrace_event_call *call, struct trace_seq *s)
 void print_subsystem_event_filter(struct event_subsystem *system,
 				  struct trace_seq *s)
 {
-	struct event_filter *filter = system->filter;
+	struct event_filter *filter;
 
 	mutex_lock(&event_mutex);
+	filter = system->filter;
 	if (filter && filter->filter_string)
 		trace_seq_printf(s, "%s\n", filter->filter_string);
 	else
@@ -745,26 +755,9 @@ static void __free_preds(struct event_filter *filter)
 	filter->n_preds = 0;
 }
 
-static void reset_preds(struct event_filter *filter)
-{
-	int n_preds = filter->n_preds;
-	int i;
-
-	filter->n_preds = 0;
-	filter->root = NULL;
-	if (!filter->preds)
-		return;
-
-	for (i = 0; i < n_preds; i++)
-		filter->preds[i].fn = filter_pred_none;
-}
-
-static void filter_disable_preds(struct ftrace_event_call *call)
+static void filter_disable(struct ftrace_event_call *call)
 {
-	struct event_filter *filter = call->filter;
-
 	call->flags &= ~TRACE_EVENT_FL_FILTERED;
-	reset_preds(filter);
 }
 
 static void __free_filter(struct event_filter *filter)
@@ -777,11 +770,16 @@ static void __free_filter(struct event_filter *filter)
 	kfree(filter);
 }
 
+/*
+ * Called when destroying the ftrace_event_call.
+ * The call is being freed, so we do not need to worry about
+ * the call being currently used. This is for module code removing
+ * the tracepoints from within it.
+ */
 void destroy_preds(struct ftrace_event_call *call)
 {
 	__free_filter(call->filter);
 	call->filter = NULL;
-	call->flags &= ~TRACE_EVENT_FL_FILTERED;
 }
 
 static struct event_filter *__alloc_filter(void)
@@ -789,11 +787,6 @@ static struct event_filter *__alloc_filter(void)
 	struct event_filter *filter;
 
 	filter = kzalloc(sizeof(*filter), GFP_KERNEL);
-	if (!filter)
-		return ERR_PTR(-ENOMEM);
-
-	filter->n_preds = 0;
-
 	return filter;
 }
 
@@ -838,46 +831,28 @@ static int __alloc_preds(struct event_filter *filter, int n_preds)
 	return 0;
 }
 
-static int init_filter(struct ftrace_event_call *call)
-{
-	if (call->filter)
-		return 0;
-
-	call->flags &= ~TRACE_EVENT_FL_FILTERED;
-	call->filter = __alloc_filter();
-	if (IS_ERR(call->filter))
-		return PTR_ERR(call->filter);
-
-	return 0;
-}
-
-static int init_subsystem_preds(struct event_subsystem *system)
+static void filter_free_subsystem_preds(struct event_subsystem *system)
 {
 	struct ftrace_event_call *call;
-	int err;
 
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		err = init_filter(call);
-		if (err)
-			return err;
+		filter_disable(call);
+		remove_filter_string(call->filter);
 	}
-
-	return 0;
 }
 
-static void filter_free_subsystem_preds(struct event_subsystem *system)
+static void filter_free_subsystem_filters(struct event_subsystem *system)
 {
 	struct ftrace_event_call *call;
 
 	list_for_each_entry(call, &ftrace_events, list) {
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
-
-		filter_disable_preds(call);
-		remove_filter_string(call->filter);
+		__free_filter(call->filter);
+		call->filter = NULL;
 	}
 }
 
@@ -1743,88 +1718,129 @@ fail:
 	return err;
 }
 
+struct filter_list {
+	struct list_head	list;
+	struct event_filter	*filter;
+};
+
 static int replace_system_preds(struct event_subsystem *system,
 				struct filter_parse_state *ps,
 				char *filter_string)
 {
 	struct ftrace_event_call *call;
+	struct filter_list *filter_item;
+	struct filter_list *tmp;
+	LIST_HEAD(filter_list);
 	bool fail = true;
 	int err;
 
 	list_for_each_entry(call, &ftrace_events, list) {
-		struct event_filter *filter = call->filter;
 
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		/* try to see if the filter can be applied */
-		err = replace_preds(call, filter, ps, filter_string, true);
+		/*
+		 * Try to see if the filter can be applied
+		 *  (filter arg is ignored on dry_run)
+		 */
+		err = replace_preds(call, NULL, ps, filter_string, true);
 		if (err)
 			goto fail;
 	}
 
-	/* set all filter pred counts to zero */
 	list_for_each_entry(call, &ftrace_events, list) {
-		struct event_filter *filter = call->filter;
+		struct event_filter *filter;
 
 		if (strcmp(call->class->system, system->name) != 0)
 			continue;
 
-		reset_preds(filter);
-	}
+		filter_item = kzalloc(sizeof(*filter_item), GFP_KERNEL);
+		if (!filter_item)
+			goto fail_mem;
 
-	/*
-	 * Since some of the preds may be used under preemption
-	 * we need to wait for them to finish before we may
-	 * reallocate them.
-	 */
-	synchronize_sched();
+		list_add_tail(&filter_item->list, &filter_list);
 
-	list_for_each_entry(call, &ftrace_events, list) {
-		struct event_filter *filter = call->filter;
+		filter_item->filter = __alloc_filter();
+		if (!filter_item->filter)
+			goto fail_mem;
+		filter = filter_item->filter;
 
-		if (strcmp(call->class->system, system->name) != 0)
-			continue;
+		/* Can only fail on no memory */
+		err = replace_filter_string(filter, filter_string);
+		if (err)
+			goto fail_mem;
 
-		/* really apply the filter */
-		filter_disable_preds(call);
 		err = replace_preds(call, filter, ps, filter_string, false);
-		if (err)
-			filter_disable_preds(call);
-		else {
+		if (err) {
+			filter_disable(call);
+			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
+			append_filter_err(ps, filter);
+		} else
 			call->flags |= TRACE_EVENT_FL_FILTERED;
-			replace_filter_string(filter, filter_string);
-		}
+		/*
+		 * Regardless of if this returned an error, we still
+		 * replace the filter for the call.
+		 */
+		filter = call->filter;
+		call->filter = filter_item->filter;
+		filter_item->filter = filter;
+
 		fail = false;
 	}
 
 	if (fail)
 		goto fail;
 
+	/*
+	 * The calls can still be using the old filters.
+	 * Do a synchronize_sched() to ensure all calls are
+	 * done with them before we free them.
+	 */
+	synchronize_sched();
+	list_for_each_entry_safe(filter_item, tmp, &filter_list, list) {
+		__free_filter(filter_item->filter);
+		list_del(&filter_item->list);
+		kfree(filter_item);
+	}
 	return 0;
  fail:
+	/* No call succeeded */
+	list_for_each_entry_safe(filter_item, tmp, &filter_list, list) {
+		list_del(&filter_item->list);
+		kfree(filter_item);
+	}
 	parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
 	return -EINVAL;
+ fail_mem:
+	/* If any call succeeded, we still need to sync */
+	if (!fail)
+		synchronize_sched();
+	list_for_each_entry_safe(filter_item, tmp, &filter_list, list) {
+		__free_filter(filter_item->filter);
+		list_del(&filter_item->list);
+		kfree(filter_item);
+	}
+	return -ENOMEM;
 }
 
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
-	int err;
 	struct filter_parse_state *ps;
+	struct event_filter *filter;
+	struct event_filter *tmp;
+	int err = 0;
 
 	mutex_lock(&event_mutex);
 
-	err = init_filter(call);
-	if (err)
-		goto out_unlock;
-
 	if (!strcmp(strstrip(filter_string), "0")) {
-		filter_disable_preds(call);
-		reset_preds(call->filter);
+		filter_disable(call);
+		filter = call->filter;
+		if (!filter)
+			goto out_unlock;
+		call->filter = NULL;
 		/* Make sure the filter is not being used */
 		synchronize_sched();
-		__free_preds(call->filter);
-		remove_filter_string(call->filter);
+		__free_filter(filter);
 		goto out_unlock;
 	}
 
@@ -1833,29 +1849,41 @@ int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 	if (!ps)
 		goto out_unlock;
 
-	filter_disable_preds(call);
-	replace_filter_string(call->filter, filter_string);
+	filter = __alloc_filter();
+	if (!filter) {
+		kfree(ps);
+		goto out_unlock;
+	}
+
+	replace_filter_string(filter, filter_string);
 
 	parse_init(ps, filter_ops, filter_string);
 	err = filter_parse(ps);
 	if (err) {
-		append_filter_err(ps, call->filter);
+		append_filter_err(ps, filter);
 		goto out;
 	}
 
-	/*
-	 * Make sure all the pred counts are zero so that
-	 * no task is using it when we reallocate the preds array.
-	 */
-	reset_preds(call->filter);
-	synchronize_sched();
-
-	err = replace_preds(call, call->filter, ps, filter_string, false);
-	if (err)
-		append_filter_err(ps, call->filter);
-	else
+	err = replace_preds(call, filter, ps, filter_string, false);
+	if (err) {
+		filter_disable(call);
+		append_filter_err(ps, filter);
+	} else
 		call->flags |= TRACE_EVENT_FL_FILTERED;
 out:
+	/*
+	 * Always swap the call filter with the new filter
+	 * even if there was an error. If there was an error
+	 * in the filter, we disable the filter and show the error
+	 * string
+	 */
+	tmp = call->filter;
+	call->filter = filter;
+	if (tmp) {
+		/* Make sure the call is done with the filter */
+		synchronize_sched();
+		__free_filter(tmp);
+	}
 	filter_opstack_clear(ps);
 	postfix_clear(ps);
 	kfree(ps);
@@ -1868,18 +1896,21 @@ out_unlock:
 int apply_subsystem_event_filter(struct event_subsystem *system,
 				 char *filter_string)
 {
-	int err;
 	struct filter_parse_state *ps;
+	struct event_filter *filter;
+	int err = 0;
 
 	mutex_lock(&event_mutex);
 
-	err = init_subsystem_preds(system);
-	if (err)
-		goto out_unlock;
-
 	if (!strcmp(strstrip(filter_string), "0")) {
 		filter_free_subsystem_preds(system);
 		remove_filter_string(system->filter);
+		filter = system->filter;
+		system->filter = NULL;
+		/* Ensure all filters are no longer used */
+		synchronize_sched();
+		filter_free_subsystem_filters(system);
+		__free_filter(filter);
 		goto out_unlock;
 	}
 
@@ -1888,7 +1919,17 @@ int apply_subsystem_event_filter(struct event_subsystem *system,
 	if (!ps)
 		goto out_unlock;
 
-	replace_filter_string(system->filter, filter_string);
+	filter = __alloc_filter();
+	if (!filter)
+		goto out;
+
+	replace_filter_string(filter, filter_string);
+	/*
+	 * No event actually uses the system filter
+	 * we can free it without synchronize_sched().
+	 */
+	__free_filter(system->filter);
+	system->filter = filter;
 
 	parse_init(ps, filter_ops, filter_string);
 	err = filter_parse(ps);
@@ -1945,7 +1986,7 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 		goto out_unlock;
 
 	filter = __alloc_filter();
-	if (IS_ERR(filter)) {
+	if (!filter) {
 		err = PTR_ERR(filter);
 		goto out_unlock;
 	}
-- 
1.7.2.3


