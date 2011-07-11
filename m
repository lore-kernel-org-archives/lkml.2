Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab1GKNXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:23:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757503Ab1GKNXK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:23:10 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 3/4] perf, ftrace: Add new perf ioctl for function trace filter
Date: Mon, 11 Jul 2011 15:22:55 +0200
Message-Id: <1310390576-8289-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As the amount of kernel functions obtained by the ftrace:function tracepoint
is quite big, it's desirable to be able to set the filter on the ftrace
level.

Added PERF_EVENT_IOC_SET_FTRACE ioctl to be able to specify function filter
for perf event. The interface is the same as for the set_ftrace_filter file.

Also the same string parser is used as for the set_ftrace_filter file.

---
 include/linux/ftrace.h          |    5 ++-
 include/linux/ftrace_event.h    |    3 ++
 include/linux/perf_event.h      |    1 +
 kernel/events/core.c            |   14 +++++++++++++
 kernel/trace/ftrace.c           |   11 +++++----
 kernel/trace/trace_event_perf.c |   42 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 69 insertions(+), 7 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index f858e97..b7368d0 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -182,7 +182,7 @@ struct dyn_ftrace {
 };
 
 int ftrace_force_update(void);
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset);
 void ftrace_set_notrace(struct ftrace_ops *ops, unsigned char *buf,
 			int len, int reset);
@@ -268,8 +268,9 @@ extern void ftrace_enable_daemon(void);
 #else
 static inline int skip_trace(unsigned long ip) { return 0; }
 static inline int ftrace_force_update(void) { return 0; }
-static inline void ftrace_set_filter(unsigned char *buf, int len, int reset)
+static inline int ftrace_set_filter(unsigned char *buf, int len, int reset)
 {
+	return -EINVAL;
 }
 static inline void ftrace_disable_daemon(void) { }
 static inline void ftrace_enable_daemon(void) { }
diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
index 061c267..df13bc6 100644
--- a/include/linux/ftrace_event.h
+++ b/include/linux/ftrace_event.h
@@ -291,6 +291,9 @@ extern void ftrace_profile_free_filter(struct perf_event *event);
 extern void *perf_trace_buf_prepare(int size, unsigned short type,
 				    struct pt_regs *regs, int *rctxp);
 
+extern int perf_ftrace_set_filter(struct perf_event *event,
+				  char __user *filter);
+
 static inline void
 perf_trace_buf_submit(void *raw_data, int size, int rctx, u64 addr,
 		       u64 count, struct pt_regs *regs, void *head)
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index bb708d1..20c216d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -248,6 +248,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_PERIOD		_IOW('$', 4, __u64)
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
+#define PERF_EVENT_IOC_SET_FTRACE	_IOW('$', 7, char *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0567e32..8564c74 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3255,6 +3255,7 @@ static struct perf_event *perf_fget_light(int fd, int *fput_needed)
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_event_set_ftrace(struct perf_event *event, void __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3301,6 +3302,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_SET_FTRACE:
+		return perf_event_set_ftrace(event, (void __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -5185,6 +5189,11 @@ static void perf_event_free_filter(struct perf_event *event)
 	ftrace_profile_free_filter(event);
 }
 
+static int perf_event_set_ftrace(struct perf_event *event, void __user *arg)
+{
+	return perf_ftrace_set_filter(event, arg);
+}
+
 #else
 
 static inline void perf_tp_register(void)
@@ -5196,6 +5205,11 @@ static int perf_event_set_filter(struct perf_event *event, void __user *arg)
 	return -ENOENT;
 }
 
+static int perf_event_set_ftrace(struct perf_event *event, void __user *arg)
+{
+	return -ENOENT;
+}
+
 static void perf_event_free_filter(struct perf_event *event)
 {
 }
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 7325ae4..477e050 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2837,7 +2837,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 {
 	struct ftrace_hash **orig_hash;
 	struct ftrace_hash *hash;
-	int ret;
+	int ret = -EINVAL;
 
 	/* All global ops uses the global ops filters */
 	if (ops->flags & FTRACE_OPS_FL_GLOBAL)
@@ -2858,13 +2858,14 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
 	mutex_lock(&ftrace_regex_lock);
 	if (reset)
 		ftrace_filter_reset(hash);
-	if (buf)
-		ftrace_match_records(hash, buf, len);
+	if (buf && !ftrace_match_records(hash, buf, len))
+		goto out_unlock;
 
 	mutex_lock(&ftrace_lock);
 	ret = ftrace_hash_move(orig_hash, hash);
 	mutex_unlock(&ftrace_lock);
 
+ out_unlock:
 	mutex_unlock(&ftrace_regex_lock);
 
 	free_ftrace_hash(hash);
@@ -2881,10 +2882,10 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
  * Filters denote which functions should be enabled when tracing is enabled.
  * If @buf is NULL and reset is set, all functions will be enabled for tracing.
  */
-void ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
+int ftrace_set_filter(struct ftrace_ops *ops, unsigned char *buf,
 		       int len, int reset)
 {
-	ftrace_set_regex(ops, buf, len, reset, 1);
+	return ftrace_set_regex(ops, buf, len, reset, 1);
 }
 EXPORT_SYMBOL_GPL(ftrace_set_filter);
 
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 2b56b81..7a1367d 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -315,3 +315,45 @@ int perf_ftrace_event_register(struct ftrace_event_call *call,
 
 	return -EINVAL;
 }
+
+static int __perf_ftrace_set_filter(struct perf_event *event,
+				   char __user *filter)
+{
+	struct trace_parser parser;
+	ssize_t cnt = strnlen_user(filter, PAGE_SIZE);
+	int reset = 1, ret = -EINVAL;
+	ssize_t read = 0;
+	loff_t pos = 0;
+
+	if (trace_parser_get_init(&parser, KSYM_SYMBOL_LEN + 4))
+		return -ENOMEM;
+
+	while (cnt) {
+		read = trace_get_user(&parser, filter, cnt, &pos);
+		if (!read || !trace_parser_loaded(&parser)) {
+			ret = -EINVAL;
+			break;
+		}
+
+		ret = ftrace_set_filter(&event->ftrace_ops,
+					parser.buffer, parser.idx,
+					reset);
+		if (ret)
+			break;
+
+		cnt    -= read;
+		filter += read;
+		reset = 0;
+	}
+
+	trace_parser_put(&parser);
+	return ret;
+}
+
+int perf_ftrace_set_filter(struct perf_event *event, char __user *filter)
+{
+	if (event->attr.config != TRACE_FN)
+		return -EINVAL;
+
+	return __perf_ftrace_set_filter(event, filter);
+}
-- 
1.7.1

