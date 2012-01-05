Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933077Ab2AEXne (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 18:43:34 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55912 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932717Ab2AEXnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 18:43:15 -0500
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk, mingo@redhat.com, rostedt@goodmis.org, fweisbec@gmail.com,
        teravest@google.com, slavapestov@google.com, ctalbott@google.com,
        dsharp@google.com
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 02/11] trace_event_filter: add trace_event_filter_*() interface
Date: Thu,  5 Jan 2012 15:42:45 -0800
Message-Id: <1325806974-23486-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1325806974-23486-1-git-send-email-tj@kernel.org>
References: <1325806974-23486-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trace event filter is generic enough to be useful in other use cases.
This patch makes update replace_preds such that it takes field lookup
function instead of struct ftrace_event_call and use it to implement
trace_event_filter_create() and friends.

The fields which can be used in filter are described by list of struct
ftrace_event_field's, trace_event_filter_string() can be used to
access the filter string and _destroy() frees the filter.

The currently planned external user is another tracer and this is good
enough but it might be a good idea to further generalize the interface
if it gets used more widely.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/trace/trace.h               |    6 ++
 kernel/trace/trace_events_filter.c |  100 +++++++++++++++++++++++++++++++----
 2 files changed, 94 insertions(+), 12 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2c26574..11c4754 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -811,6 +811,12 @@ filter_check_discard(struct ftrace_event_call *call, void *rec,
 
 extern void trace_event_enable_cmd_record(bool enable);
 
+extern int trace_event_filter_create(struct list_head *event_fields,
+				     char *filter_str,
+				     struct event_filter **filterp);
+extern const char *trace_event_filter_string(struct event_filter *filter);
+extern void trace_event_filter_destroy(struct event_filter *filter);
+
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 24aee71..e944b9f 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -656,9 +656,9 @@ void print_subsystem_event_filter(struct event_subsystem *system,
 	mutex_unlock(&event_mutex);
 }
 
-static struct ftrace_event_field *
-__find_event_field(struct list_head *head, char *name)
+static struct ftrace_event_field *__find_event_field(void *data, char *name)
 {
+	struct list_head *head = data;
 	struct ftrace_event_field *field;
 
 	list_for_each_entry(field, head, link) {
@@ -669,9 +669,9 @@ __find_event_field(struct list_head *head, char *name)
 	return NULL;
 }
 
-static struct ftrace_event_field *
-find_event_field(struct ftrace_event_call *call, char *name)
+static struct ftrace_event_field *find_event_field(void *data, char *name)
 {
+	struct ftrace_event_call *call = data;
 	struct ftrace_event_field *field;
 	struct list_head *head;
 
@@ -1308,8 +1308,10 @@ parse_operand:
 	return 0;
 }
 
+typedef struct ftrace_event_field *find_field_fn_t(void *data, char *name);
+
 static struct filter_pred *create_pred(struct filter_parse_state *ps,
-				       struct ftrace_event_call *call,
+				       find_field_fn_t ff_fn, void *ff_data,
 				       int op, char *operand1, char *operand2)
 {
 	struct ftrace_event_field *field;
@@ -1326,7 +1328,7 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 		return NULL;
 	}
 
-	field = find_event_field(call, operand1);
+	field = ff_fn(ff_data, operand1);
 	if (!field) {
 		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
 		return NULL;
@@ -1525,11 +1527,11 @@ static int fold_pred_tree(struct event_filter *filter,
 			      filter->preds);
 }
 
-static int replace_preds(struct ftrace_event_call *call,
-			 struct event_filter *filter,
-			 struct filter_parse_state *ps,
-			 char *filter_string,
-			 bool dry_run)
+static int __replace_preds(find_field_fn_t ff_fn, void *ff_data,
+			   struct event_filter *filter,
+			   struct filter_parse_state *ps,
+			   char *filter_string,
+			   bool dry_run)
 {
 	char *operand1 = NULL, *operand2 = NULL;
 	struct filter_pred *pred;
@@ -1579,7 +1581,8 @@ static int replace_preds(struct ftrace_event_call *call,
 			goto fail;
 		}
 
-		pred = create_pred(ps, call, elt->op, operand1, operand2);
+		pred = create_pred(ps, ff_fn, ff_data,
+				   elt->op, operand1, operand2);
 		if (!pred) {
 			err = -EINVAL;
 			goto fail;
@@ -1628,6 +1631,16 @@ fail:
 	return err;
 }
 
+static int replace_preds(struct ftrace_event_call *call,
+			 struct event_filter *filter,
+			 struct filter_parse_state *ps,
+			 char *filter_string,
+			 bool dry_run)
+{
+	return __replace_preds(find_event_field, call, filter, ps,
+			       filter_string, dry_run);
+}
+
 struct filter_list {
 	struct list_head	list;
 	struct event_filter	*filter;
@@ -1940,6 +1953,69 @@ out_unlock:
 	return err;
 }
 
+/**
+ * trace_event_filter_create - create an event filter for external user
+ * @event_fields: linked list of struct ftrace_event_field's
+ * @filter_str: filter string
+ * @filterp: out param for created filter (always updated on return)
+ *
+ * Creates a filter for an external user.  @event_fields lists struct
+ * ftrace_event_field's for all possible fields @filter_str may use.
+ *
+ * On success, returns 0 and *@filterp points to the new filter.  On
+ * failure, returns -errno and *@filterp may point to %NULL or to a new
+ * filter.  In the latter case, the returned filter contains error
+ * information if @set_str is %true and the caller is responsible for
+ * freeing it by calling trace_event_filter_destroy().
+ */
+int trace_event_filter_create(struct list_head *event_fields,
+			      char *filter_str, struct event_filter **filterp)
+{
+	struct event_filter *filter = NULL;
+	struct filter_parse_state *ps = NULL;
+	int err;
+
+	err = create_filter_start(filter_str, true, &ps, &filter);
+	if (!err) {
+		err = __replace_preds(__find_event_field, event_fields,
+				      filter, ps, filter_str, false);
+		if (err)
+			append_filter_err(ps, filter);
+	}
+	create_filter_finish(ps);
+
+	*filterp = filter;
+	return err;
+}
+EXPORT_SYMBOL_GPL(trace_event_filter_create);
+
+/**
+ * trace_event_filter_string - access filter string of an event filter
+ * @filter: target filter to access filter string for
+ *
+ * Returns pointer to filter string of @filter.  Note that the caller is
+ * responsible for ensuring @filter is not destroyed while the returned
+ * filter string is used.
+ */
+const char *trace_event_filter_string(struct event_filter *filter)
+{
+	return filter->filter_string;
+}
+EXPORT_SYMBOL_GPL(trace_event_filter_string);
+
+/**
+ * trace_event_filter_destroy - destroy an event filter
+ * @filter: filter to destroy
+ *
+ * Destroy @filter.  All filters returned by trace_event_filter_create()
+ * should be freed using this function.
+ */
+void trace_event_filter_destroy(struct event_filter *filter)
+{
+	__free_filter(filter);
+}
+EXPORT_SYMBOL_GPL(trace_event_filter_destroy);
+
 #ifdef CONFIG_PERF_EVENTS
 
 void ftrace_profile_free_filter(struct perf_event *event)
-- 
1.7.3.1

