Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760170Ab1FXAh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 20:37:57 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64818 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab1FXAhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 20:37:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=mVHapMLLCzs9afILHGdjYMzvKvzRGTHFAfcUJLetEPteZolYDLo9aTlVhifr/mNE4a
         VGkK6P7Gwtbi6QOKWv5RQShLt3uM5Q33sbSCiM7ZLOaWTghUddoas3uFkrUluKucVYmr
         WZxO59FkJ2MbykOMtbNBw+zHZqrJ2qYZKKb00=
From: Will Drewry <wad@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, djm@mindrot.org, segoon@openwall.com,
        kees.cook@canonical.com, mingo@elte.hu, rostedt@goodmis.org,
        jmorris@namei.org, fweisbec@gmail.com, tglx@linutronix.de,
        scarybeasts@gmail.com, Will Drewry <wad@chromium.org>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Namhyung Kim <namhyung@gmail.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Ben Blum <bblum@andrew.cmu.edu>
Subject: [PATCH v9 01/13] tracing: split out filter initialization and clean up uses
Date: Thu, 23 Jun 2011 19:36:40 -0500
Message-Id: <1308875813-20122-1-git-send-email-wad@chromium.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moves the perf-specific profile event allocation and freeing code into
kernel/perf_event.c where it is called from and two symbols are exported
via ftrace_event.h for instantiating struct event_filters without
requiring a change to the core tracing code.

The change allows globally registered ftrace events to be used in
event_filter structs.  perf is the current consumer, but a possible
future consumer is a system call filtering using the secure computing
hooks (and the existing syscalls subsystem events).

v9: rebase on to bccaeafd7c117acee36e90d37c7e05c19be9e7bf

Signed-off-by: Will Drewry <wad@chromium.org>
---
 include/linux/ftrace_event.h       |    9 +++--
 kernel/events/core.c               |    7 +++-
 kernel/trace/trace_events_filter.c |   60 ++++++++++++++++++++++--------------
 3 files changed, 48 insertions(+), 28 deletions(-)

diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 59d3ef1..1d8daca 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -229,6 +229,12 @@ extern int filter_current_check_discard(struct ring_buffer *buffer,
 					void *rec,
 					struct ring_buffer_event *event);
 
+extern void ftrace_free_filter(struct event_filter *filter);
+extern int ftrace_parse_filter(struct event_filter **filter,
+			       int event_id,
+			       const char *filter_str);
+extern const char *ftrace_get_filter_string(const struct event_filter *filter);
+
 enum {
 	FILTER_OTHER = 0,
 	FILTER_STATIC_STRING,
@@ -279,9 +285,6 @@ extern int  perf_trace_init(struct perf_event *event);
 extern void perf_trace_destroy(struct perf_event *event);
 extern int  perf_trace_add(struct perf_event *event, int flags);
 extern void perf_trace_del(struct perf_event *event, int flags);
-extern int  ftrace_profile_set_filter(struct perf_event *event, int event_id,
-				     char *filter_str);
-extern void ftrace_profile_free_filter(struct perf_event *event);
 extern void *perf_trace_buf_prepare(int size, unsigned short type,
 				    struct pt_regs *regs, int *rctxp);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9efe710..a18af25 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5580,7 +5580,8 @@ static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 	if (IS_ERR(filter_str))
 		return PTR_ERR(filter_str);
 
-	ret = ftrace_profile_set_filter(event, event->attr.config, filter_str);
+	ret = ftrace_parse_filter(&event->filter, event->attr.config,
+				  filter_str);
 
 	kfree(filter_str);
 	return ret;
@@ -5588,7 +5589,9 @@ static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 
 static void perf_event_free_filter(struct perf_event *event)
 {
-	ftrace_profile_free_filter(event);
+	struct event_filter *filter = event->filter;
+	event->filter = NULL;
+	ftrace_free_filter(filter);
 }
 
 #else
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 8008ddc..787b174 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -522,7 +522,7 @@ static void remove_filter_string(struct event_filter *filter)
 }
 
 static int replace_filter_string(struct event_filter *filter,
-				 char *filter_string)
+				 const char *filter_string)
 {
 	kfree(filter->filter_string);
 	filter->filter_string = kstrdup(filter_string, GFP_KERNEL);
@@ -1936,21 +1936,27 @@ out_unlock:
 	return err;
 }
 
-#ifdef CONFIG_PERF_EVENTS
-
-void ftrace_profile_free_filter(struct perf_event *event)
+/* ftrace_free_filter - frees a parsed filter its internal structures.
+ *
+ * @filter: pointer to the event_filter to free.
+ */
+void ftrace_free_filter(struct event_filter *filter)
 {
-	struct event_filter *filter = event->filter;
-
-	event->filter = NULL;
-	__free_filter(filter);
+	if (filter)
+		__free_filter(filter);
 }
+EXPORT_SYMBOL_GPL(ftrace_free_filter);
 
-int ftrace_profile_set_filter(struct perf_event *event, int event_id,
-			      char *filter_str)
+/* ftrace_parse_filter - allocates and populates a new event_filter
+ *
+ * @event_id: may be something like syscalls::sys_event_tkill's id.
+ * @filter_str: pointer to the filter string. Ownership IS taken.
+ */
+int ftrace_parse_filter(struct event_filter **filter,
+			int event_id,
+			const char *filter_str)
 {
 	int err;
-	struct event_filter *filter;
 	struct filter_parse_state *ps;
 	struct ftrace_event_call *call = NULL;
 
@@ -1966,12 +1972,12 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 		goto out_unlock;
 
 	err = -EEXIST;
-	if (event->filter)
+	if (*filter)
 		goto out_unlock;
 
-	filter = __alloc_filter();
-	if (!filter) {
-		err = PTR_ERR(filter);
+	*filter = __alloc_filter();
+	if (IS_ERR_OR_NULL(*filter)) {
+		err = PTR_ERR(*filter);
 		goto out_unlock;
 	}
 
@@ -1980,14 +1986,14 @@ int ftrace_profile_set_filter(struct perf_event *event, int event_id,
 	if (!ps)
 		goto free_filter;
 
-	parse_init(ps, filter_ops, filter_str);
+	replace_filter_string(*filter, filter_str);
+
+	parse_init(ps, filter_ops, (*filter)->filter_string);
 	err = filter_parse(ps);
 	if (err)
 		goto free_ps;
 
-	err = replace_preds(call, filter, ps, filter_str, false);
-	if (!err)
-		event->filter = filter;
+	err = replace_preds(call, *filter, ps, (*filter)->filter_string, false);
 
 free_ps:
 	filter_opstack_clear(ps);
@@ -1995,14 +2001,22 @@ free_ps:
 	kfree(ps);
 
 free_filter:
-	if (err)
-		__free_filter(filter);
+	if (err) {
+		__free_filter(*filter);
+		*filter = NULL;
+	}
 
 out_unlock:
 	mutex_unlock(&event_mutex);
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(ftrace_parse_filter);
 
-#endif /* CONFIG_PERF_EVENTS */
-
+const char *ftrace_get_filter_string(const struct event_filter *filter)
+{
+	if (!filter)
+		return NULL;
+	return filter->filter_string;
+}
+EXPORT_SYMBOL_GPL(ftrace_get_filter_string);
-- 
1.7.0.4

