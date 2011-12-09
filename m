Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1LIToR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 14:44:17 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44390 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1LIToQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 14:44:16 -0500
Date: Fri, 9 Dec 2011 11:43:59 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 UPDATED] trace_event_filter: factorize filter creation
Message-ID: <20111209194359.GG12108@google.com>
References: <20111123014603.GA19630@google.com>
 <20111123020016.GB19630@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123020016.GB19630@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are four places where new filter for a given filter string is
created, which involves several different steps.  This patch factors
those steps into create_[system_]filter() functions which in turn make
use of create_filter_{start|finish}() for common parts.

The only functional change is that if replace_filter_string() is
requested and fails, creation fails without any side effect instead of
being ignored.

Note that system filter is now installed after the processing is
complete which makes freeing before and then restoring filter string
on error unncessary.

-v2: Rebased to resolve conflict with 49aa29513e and updated both
     create_filter() functions to always set *filterp instead of
     requiring the caller to clear it to %NULL on entry.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/trace/trace_events_filter.c |  283 ++++++++++++++++++-------------------
 1 file changed, 142 insertions(+), 141 deletions(-)

Index: work/kernel/trace/trace_events_filter.c
===================================================================
--- work.orig/kernel/trace/trace_events_filter.c
+++ work/kernel/trace/trace_events_filter.c
@@ -1738,11 +1738,121 @@ static int replace_system_preds(struct e
 	return -ENOMEM;
 }
 
+static int create_filter_start(char *filter_str, bool set_str,
+			       struct filter_parse_state **psp,
+			       struct event_filter **filterp)
+{
+	struct event_filter *filter;
+	struct filter_parse_state *ps = NULL;
+	int err = 0;
+
+	WARN_ON_ONCE(*psp || *filterp);
+
+	/* allocate everything, and if any fails, free all and fail */
+	filter = __alloc_filter();
+	if (filter && set_str)
+		err = replace_filter_string(filter, filter_str);
+
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+
+	if (!filter || !ps || err) {
+		kfree(ps);
+		__free_filter(filter);
+		return -ENOMEM;
+	}
+
+	/* we're committed to creating a new filter */
+	*filterp = filter;
+	*psp = ps;
+
+	parse_init(ps, filter_ops, filter_str);
+	err = filter_parse(ps);
+	if (err && set_str)
+		append_filter_err(ps, filter);
+	return err;
+}
+
+static void create_filter_finish(struct filter_parse_state *ps)
+{
+	if (ps) {
+		filter_opstack_clear(ps);
+		postfix_clear(ps);
+		kfree(ps);
+	}
+}
+
+/**
+ * create_filter - create a filter for a ftrace_event_call
+ * @call: ftrace_event_call to create a filter for
+ * @filter_str: filter string
+ * @set_str: remember @filter_str and enable detailed error in filter
+ * @filterp: out param for created filter (always updated on return)
+ *
+ * Creates a filter for @call with @filter_str.  If @set_str is %true,
+ * @filter_str is copied and recorded in the new filter.
+ *
+ * On success, returns 0 and *@filterp points to the new filter.  On
+ * failure, returns -errno and *@filterp may point to %NULL or to a new
+ * filter.  In the latter case, the returned filter contains error
+ * information if @set_str is %true and the caller is responsible for
+ * freeing it.
+ */
+static int create_filter(struct ftrace_event_call *call,
+			 char *filter_str, bool set_str,
+			 struct event_filter **filterp)
+{
+	struct event_filter *filter = NULL;
+	struct filter_parse_state *ps = NULL;
+	int err;
+
+	err = create_filter_start(filter_str, set_str, &ps, &filter);
+	if (!err) {
+		err = replace_preds(call, filter, ps, filter_str, false);
+		if (err && set_str)
+			append_filter_err(ps, filter);
+	}
+	create_filter_finish(ps);
+
+	*filterp = filter;
+	return err;
+}
+
+/**
+ * create_system_filter - create a filter for an event_subsystem
+ * @system: event_subsystem to create a filter for
+ * @filter_str: filter string
+ * @filterp: out param for created filter (always updated on return)
+ *
+ * Identical to create_filter() except that it creates a subsystem filter
+ * and always remembers @filter_str.
+ */
+static int create_system_filter(struct event_subsystem *system,
+				char *filter_str, struct event_filter **filterp)
+{
+	struct event_filter *filter = NULL;
+	struct filter_parse_state *ps = NULL;
+	int err;
+
+	err = create_filter_start(filter_str, true, &ps, &filter);
+	if (!err) {
+		err = replace_system_preds(system, ps, filter_str);
+		if (!err) {
+			/* System filters just show a default message */
+			kfree(filter->filter_string);
+			filter->filter_string = NULL;
+		} else {
+			append_filter_err(ps, filter);
+		}
+	}
+	create_filter_finish(ps);
+
+	*filterp = filter;
+	return err;
+}
+
 int apply_event_filter(struct ftrace_event_call *call, char *filter_string)
 {
-	struct filter_parse_state *ps;
 	struct event_filter *filter;
-	struct event_filter *tmp;
 	int err = 0;
 
 	mutex_lock(&event_mutex);
@@ -1759,49 +1869,30 @@ int apply_event_filter(struct ftrace_eve
 		goto out_unlock;
 	}
 
-	err = -ENOMEM;
-	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto out_unlock;
+	err = create_filter(call, filter_string, true, &filter);
 
-	filter = __alloc_filter();
-	if (!filter) {
-		kfree(ps);
-		goto out_unlock;
-	}
-
-	replace_filter_string(filter, filter_string);
-
-	parse_init(ps, filter_ops, filter_string);
-	err = filter_parse(ps);
-	if (err) {
-		append_filter_err(ps, filter);
-		goto out;
-	}
-
-	err = replace_preds(call, filter, ps, filter_string, false);
-	if (err) {
-		filter_disable(call);
-		append_filter_err(ps, filter);
-	} else
-		call->flags |= TRACE_EVENT_FL_FILTERED;
-out:
 	/*
 	 * Always swap the call filter with the new filter
 	 * even if there was an error. If there was an error
 	 * in the filter, we disable the filter and show the error
 	 * string
 	 */
-	tmp = call->filter;
-	rcu_assign_pointer(call->filter, filter);
-	if (tmp) {
-		/* Make sure the call is done with the filter */
-		synchronize_sched();
-		__free_filter(tmp);
+	if (filter) {
+		struct event_filter *tmp = call->filter;
+
+		if (!err)
+			call->flags |= TRACE_EVENT_FL_FILTERED;
+		else
+			filter_disable(call);
+
+		rcu_assign_pointer(call->filter, filter);
+
+		if (tmp) {
+			/* Make sure the call is done with the filter */
+			synchronize_sched();
+			__free_filter(tmp);
+		}
 	}
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
 out_unlock:
 	mutex_unlock(&event_mutex);
 
@@ -1811,7 +1902,6 @@ out_unlock:
 int apply_subsystem_event_filter(struct event_subsystem *system,
 				 char *filter_string)
 {
-	struct filter_parse_state *ps;
 	struct event_filter *filter;
 	int err = 0;
 
@@ -1835,48 +1925,19 @@ int apply_subsystem_event_filter(struct 
 		goto out_unlock;
 	}
 
-	err = -ENOMEM;
-	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto out_unlock;
-
-	filter = __alloc_filter();
-	if (!filter)
-		goto out;
-
-	/* System filters just show a default message */
-	kfree(filter->filter_string);
-	filter->filter_string = NULL;
-
-	/*
-	 * No event actually uses the system filter
-	 * we can free it without synchronize_sched().
-	 */
-	__free_filter(system->filter);
-	system->filter = filter;
-
-	parse_init(ps, filter_ops, filter_string);
-	err = filter_parse(ps);
-	if (err)
-		goto err_filter;
-
-	err = replace_system_preds(system, ps, filter_string);
-	if (err)
-		goto err_filter;
-
-out:
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
+	err = create_system_filter(system, filter_string, &filter);
+	if (filter) {
+		/*
+		 * No event actually uses the system filter
+		 * we can free it without synchronize_sched().
+		 */
+		__free_filter(system->filter);
+		system->filter = filter;
+	}
 out_unlock:
 	mutex_unlock(&event_mutex);
 
 	return err;
-
-err_filter:
-	replace_filter_string(filter, filter_string);
-	append_filter_err(ps, system->filter);
-	goto out;
 }
 
 #ifdef CONFIG_PERF_EVENTS
@@ -1894,7 +1955,6 @@ int ftrace_profile_set_filter(struct per
 {
 	int err;
 	struct event_filter *filter;
-	struct filter_parse_state *ps;
 	struct ftrace_event_call *call;
 
 	mutex_lock(&event_mutex);
@@ -1909,33 +1969,10 @@ int ftrace_profile_set_filter(struct per
 	if (event->filter)
 		goto out_unlock;
 
-	filter = __alloc_filter();
-	if (!filter) {
-		err = PTR_ERR(filter);
-		goto out_unlock;
-	}
-
-	err = -ENOMEM;
-	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto free_filter;
-
-	parse_init(ps, filter_ops, filter_str);
-	err = filter_parse(ps);
-	if (err)
-		goto free_ps;
-
-	err = replace_preds(call, filter, ps, filter_str, false);
+	err = create_filter(call, filter_str, false, &filter);
 	if (!err)
 		event->filter = filter;
-
-free_ps:
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
-
-free_filter:
-	if (err)
+	else
 		__free_filter(filter);
 
 out_unlock:
@@ -1954,43 +1991,6 @@ out_unlock:
 #define CREATE_TRACE_POINTS
 #include "trace_events_filter_test.h"
 
-static int test_get_filter(char *filter_str, struct ftrace_event_call *call,
-			   struct event_filter **pfilter)
-{
-	struct event_filter *filter;
-	struct filter_parse_state *ps;
-	int err = -ENOMEM;
-
-	filter = __alloc_filter();
-	if (!filter)
-		goto out;
-
-	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
-	if (!ps)
-		goto free_filter;
-
-	parse_init(ps, filter_ops, filter_str);
-	err = filter_parse(ps);
-	if (err)
-		goto free_ps;
-
-	err = replace_preds(call, filter, ps, filter_str, false);
-	if (!err)
-		*pfilter = filter;
-
- free_ps:
-	filter_opstack_clear(ps);
-	postfix_clear(ps);
-	kfree(ps);
-
- free_filter:
-	if (err)
-		__free_filter(filter);
-
- out:
-	return err;
-}
-
 #define DATA_REC(m, va, vb, vc, vd, ve, vf, vg, vh, nvisit) \
 { \
 	.filter = FILTER, \
@@ -2109,12 +2109,13 @@ static __init int ftrace_test_event_filt
 		struct test_filter_data_t *d = &test_filter_data[i];
 		int err;
 
-		err = test_get_filter(d->filter, &event_ftrace_test_filter,
-				      &filter);
+		err = create_filter(&event_ftrace_test_filter, d->filter,
+				    false, &filter);
 		if (err) {
 			printk(KERN_INFO
 			       "Failed to get filter for '%s', err %d\n",
 			       d->filter, err);
+			__free_filter(filter);
 			break;
 		}
 
