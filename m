Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752942Ab1HKO0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10645 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844Ab1HKO01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:27 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 10/10] tracing/filter: Add startup tests for events filter
Date: Thu, 11 Aug 2011 16:25:54 +0200
Message-Id: <1313072754-4620-11-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
 <1313072754-4620-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding automated tests running as late_initcall. Tests are
compiled in with CONFIG_FTRACE_STARTUP_TEST option.

Adding test event "ftrace_test_filter" used to simulate
filter processing during event occurance.

String filters are compiled and tested against several
test events with different values.

Also testing that evaluation of explicit predicates is ommited
due to the lazy filter evaluation.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/Makefile                   |    2 +
 kernel/trace/trace.h                    |    3 +
 kernel/trace/trace_events_filter.c      |  209 +++++++++++++++++++++++++++++++
 kernel/trace/trace_events_filter_test.h |   50 ++++++++
 4 files changed, 264 insertions(+), 0 deletions(-)
 create mode 100644 kernel/trace/trace_events_filter_test.h

diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 761c510..b384ed5 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -15,6 +15,8 @@ ifdef CONFIG_TRACING_BRANCHES
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 endif
 
+CFLAGS_trace_events_filter.o := -I$(src)
+
 #
 # Make the trace clocks available generally: it's infrastructure
 # relied on by ptrace for example:
diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 2eb3cf6..4c7540a 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -762,6 +762,9 @@ struct filter_pred {
 	u64 			val;
 	struct regex		regex;
 	unsigned short		*ops;
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+	struct ftrace_event_field *field;
+#endif
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 319c3ca..6a642e2 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1329,6 +1329,9 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len = strlen(pred.regex.pattern);
 
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+	pred.field = field;
+#endif
 	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
 
@@ -1926,3 +1929,209 @@ out_unlock:
 
 #endif /* CONFIG_PERF_EVENTS */
 
+#ifdef CONFIG_FTRACE_STARTUP_TEST
+
+#include <linux/types.h>
+#include <linux/tracepoint.h>
+
+#define CREATE_TRACE_POINTS
+#include "trace_events_filter_test.h"
+
+static int test_get_filter(char *filter_str, struct ftrace_event_call *call,
+			   struct event_filter **pfilter)
+{
+	struct event_filter *filter;
+	struct filter_parse_state *ps;
+	int err = -ENOMEM;
+
+	filter = __alloc_filter();
+	if (!filter)
+		goto out;
+
+	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
+	if (!ps)
+		goto free_filter;
+
+	parse_init(ps, filter_ops, filter_str);
+	err = filter_parse(ps);
+	if (err)
+		goto free_ps;
+
+	err = replace_preds(call, filter, ps, filter_str, false);
+	if (!err)
+		*pfilter = filter;
+
+ free_ps:
+	filter_opstack_clear(ps);
+	postfix_clear(ps);
+	kfree(ps);
+
+ free_filter:
+	if (err)
+		__free_filter(filter);
+
+ out:
+	return err;
+}
+
+#define DATA_REC(m, va, vb, vc, vd, ve, vf, vg, vh, nvisit) \
+{ \
+	.filter = FILTER, \
+	.rec    = { .a = va, .b = vb, .c = vc, .d = vd, \
+		    .e = ve, .f = vf, .g = vg, .h = vh }, \
+	.match  = m, \
+	.not_visited = nvisit, \
+}
+#define YES 1
+#define NO  0
+
+static struct test_filter_data_t {
+	char *filter;
+	struct ftrace_raw_ftrace_test_filter rec;
+	int match;
+	char *not_visited;
+} test_filter_data[] = {
+#define FILTER "a == 1 && b == 1 && c == 1 && d == 1 && " \
+	       "e == 1 && f == 1 && g == 1 && h == 1"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, ""),
+	DATA_REC(NO,  0, 1, 1, 1, 1, 1, 1, 1, "bcdefgh"),
+	DATA_REC(NO,  1, 1, 1, 1, 1, 1, 1, 0, ""),
+#undef FILTER
+#define FILTER "a == 1 || b == 1 || c == 1 || d == 1 || " \
+	       "e == 1 || f == 1 || g == 1 || h == 1"
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 0, ""),
+	DATA_REC(YES, 0, 0, 0, 0, 0, 0, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 0, 0, 0, 0, 0, 0, "bcdefgh"),
+#undef FILTER
+#define FILTER "(a == 1 || b == 1) && (c == 1 || d == 1) && " \
+	       "(e == 1 || f == 1) && (g == 1 || h == 1)"
+	DATA_REC(NO,  0, 0, 1, 1, 1, 1, 1, 1, "dfh"),
+	DATA_REC(YES, 0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 1, 0, 0, 1, 0, 1, "bd"),
+	DATA_REC(NO,  1, 0, 1, 0, 0, 1, 0, 0, "bd"),
+#undef FILTER
+#define FILTER "(a == 1 && b == 1) || (c == 1 && d == 1) || " \
+	       "(e == 1 && f == 1) || (g == 1 && h == 1)"
+	DATA_REC(YES, 1, 0, 1, 1, 1, 1, 1, 1, "efgh"),
+	DATA_REC(YES, 0, 0, 0, 0, 0, 0, 1, 1, ""),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 1, ""),
+#undef FILTER
+#define FILTER "(a == 1 && b == 1) && (c == 1 && d == 1) && " \
+	       "(e == 1 && f == 1) || (g == 1 && h == 1)"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 0, 0, "gh"),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 1, ""),
+	DATA_REC(YES, 1, 1, 1, 1, 1, 0, 1, 1, ""),
+#undef FILTER
+#define FILTER "((a == 1 || b == 1) || (c == 1 || d == 1) || " \
+	       "(e == 1 || f == 1)) && (g == 1 || h == 1)"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 0, 1, "bcdef"),
+	DATA_REC(NO,  0, 0, 0, 0, 0, 0, 0, 0, ""),
+	DATA_REC(YES, 1, 1, 1, 1, 1, 0, 1, 1, "h"),
+#undef FILTER
+#define FILTER "((((((((a == 1) && (b == 1)) || (c == 1)) && (d == 1)) || " \
+	       "(e == 1)) && (f == 1)) || (g == 1)) && (h == 1))"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, "ceg"),
+	DATA_REC(NO,  0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(NO,  1, 0, 1, 0, 1, 0, 1, 0, ""),
+#undef FILTER
+#define FILTER "((((((((a == 1) || (b == 1)) && (c == 1)) || (d == 1)) && " \
+	       "(e == 1)) || (f == 1)) && (g == 1)) || (h == 1))"
+	DATA_REC(YES, 1, 1, 1, 1, 1, 1, 1, 1, "bdfh"),
+	DATA_REC(YES, 0, 1, 0, 1, 0, 1, 0, 1, ""),
+	DATA_REC(YES, 1, 0, 1, 0, 1, 0, 1, 0, "bdfh"),
+};
+
+#undef DATA_REC
+#undef FILTER
+#undef YES
+#undef NO
+
+#define DATA_CNT (sizeof(test_filter_data)/sizeof(struct test_filter_data_t))
+
+static int test_pred_visited;
+
+static int test_pred_visited_fn(struct filter_pred *pred, void *event)
+{
+	struct ftrace_event_field *field = pred->field;
+
+	test_pred_visited = 1;
+	printk(KERN_INFO "\npred visited %s\n", field->name);
+	return 1;
+}
+
+static int test_walk_pred_cb(enum move_type move, struct filter_pred *pred,
+			     int *err, void *data)
+{
+	char *fields = data;
+
+	if ((move == MOVE_DOWN) &&
+	    (pred->left == FILTER_PRED_INVALID)) {
+		struct ftrace_event_field *field = pred->field;
+
+		if (!field) {
+			WARN(1, "all leafs should have field defined");
+			return WALK_PRED_DEFAULT;
+		}
+		if (!strchr(fields, *field->name))
+			return WALK_PRED_DEFAULT;
+
+		WARN_ON(!pred->fn);
+		pred->fn = test_pred_visited_fn;
+	}
+	return WALK_PRED_DEFAULT;
+}
+
+static __init int ftrace_test_event_filter(void)
+{
+	int i;
+
+	printk(KERN_INFO "Testing ftrace filter: ");
+
+	for (i = 0; i < DATA_CNT; i++) {
+		struct event_filter *filter = NULL;
+		struct test_filter_data_t *d = &test_filter_data[i];
+		int err;
+
+		err = test_get_filter(d->filter, &event_ftrace_test_filter,
+				      &filter);
+		if (err) {
+			printk(KERN_INFO
+			       "Failed to get filter for '%s', err %d\n",
+			       d->filter, err);
+			break;
+		}
+
+		if (*d->not_visited)
+			walk_pred_tree(filter->preds, filter->root,
+				       test_walk_pred_cb,
+				       d->not_visited);
+
+		test_pred_visited = 0;
+		err = filter_match_preds(filter, &d->rec);
+
+		__free_filter(filter);
+
+		if (test_pred_visited) {
+			printk(KERN_INFO
+			       "Failed, unwanted pred visited for filter %s\n",
+			       d->filter);
+			break;
+		}
+
+		if (err != d->match) {
+			printk(KERN_INFO
+			       "Failed to match filter '%s', expected %d\n",
+			       d->filter, d->match);
+			break;
+		}
+	}
+
+	if (i == DATA_CNT)
+		printk(KERN_CONT "OK\n");
+
+	return 0;
+}
+
+late_initcall(ftrace_test_event_filter);
+
+#endif /* CONFIG_FTRACE_STARTUP_TEST */
diff --git a/kernel/trace/trace_events_filter_test.h b/kernel/trace/trace_events_filter_test.h
new file mode 100644
index 0000000..bfd4dba
--- /dev/null
+++ b/kernel/trace/trace_events_filter_test.h
@@ -0,0 +1,50 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM test
+
+#if !defined(_TRACE_TEST_H) || defined(TRACE_HEADER_MULTI_READ)
+#define _TRACE_TEST_H
+
+#include <linux/tracepoint.h>
+
+TRACE_EVENT(ftrace_test_filter,
+
+	TP_PROTO(int a, int b, int c, int d, int e, int f, int g, int h),
+
+	TP_ARGS(a, b, c, d, e, f, g, h),
+
+	TP_STRUCT__entry(
+		__field(int, a)
+		__field(int, b)
+		__field(int, c)
+		__field(int, d)
+		__field(int, e)
+		__field(int, f)
+		__field(int, g)
+		__field(int, h)
+	),
+
+	TP_fast_assign(
+		__entry->a = a;
+		__entry->b = b;
+		__entry->c = c;
+		__entry->d = d;
+		__entry->e = e;
+		__entry->f = f;
+		__entry->g = g;
+		__entry->h = h;
+	),
+
+	TP_printk("a %d, b %d, c %d, d %d, e %d, f %d, g %d, h %d",
+		  __entry->a, __entry->b, __entry->c, __entry->d,
+		  __entry->e, __entry->f, __entry->g, __entry->h)
+);
+
+#endif /* _TRACE_TEST_H || TRACE_HEADER_MULTI_READ */
+
+#undef TRACE_INCLUDE_PATH
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_PATH .
+#define TRACE_INCLUDE_FILE trace_events_filter_test
+
+/* This part must be outside protection */
+#include <trace/define_trace.h>
-- 
1.7.1

