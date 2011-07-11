Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757517Ab1GKNXL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 09:23:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30221 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757333Ab1GKNXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 09:23:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, a.p.zijlstra@chello.nl
Cc: linux-kernel@vger.kernel.org
Subject: [RFC 2/4] perf, ftrace: Add filter support for ftrace:function tracepoint
Date: Mon, 11 Jul 2011 15:22:54 +0200
Message-Id: <1310390576-8289-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
References: <1310390576-8289-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support to specify perf filter for function trace.

Standard perf filter could be now used for ftrace:function tracepoint like:

 # ./perf stat -e ftrace:function --filter "ip == sys_open || ip == sys_close" sleep 1

 Performance counter stats for 'sleep 1':

                 9 ftrace:function                                             

       1.003097430 seconds time elapsed

Details:
- the value for ip and parent_ip fields gets translated to the
  function value (mcount return IP). The ip and parent_ip are then
  processed as integer values.

---
 include/linux/ftrace.h             |    2 ++
 kernel/trace/ftrace.c              |   23 +++++++++++++++++++++++
 kernel/trace/trace_events_filter.c |   32 ++++++++++++++++++++++++++------
 3 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
index ed0eb52..f858e97 100644
--- a/include/linux/ftrace.h
+++ b/include/linux/ftrace.h
@@ -157,6 +157,8 @@ extern void
 unregister_ftrace_function_probe_func(char *glob, struct ftrace_probe_ops *ops);
 extern void unregister_ftrace_function_probe_all(char *glob);
 
+extern int ftrace_function_rec_ip(char *func, unsigned long long *ip);
+
 extern int ftrace_text_reserved(void *start, void *end);
 
 enum {
diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 6d6e0d0..7325ae4 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2599,6 +2599,29 @@ register_ftrace_function_probe(char *glob, struct ftrace_probe_ops *ops,
 	return count;
 }
 
+int ftrace_function_rec_ip(char *func, unsigned long long *ip)
+{
+	struct ftrace_page *pg;
+	struct dyn_ftrace *rec;
+	int len = strlen(func);
+	int found = 0;
+
+	mutex_lock(&ftrace_lock);
+
+	do_for_each_ftrace_rec(pg, rec) {
+		if (!ftrace_match_record(rec, NULL, func, len, MATCH_FULL))
+			continue;
+
+		*ip = rec->ip;
+		found = 1;
+		break;
+	} while_for_each_ftrace_rec();
+
+	mutex_unlock(&ftrace_lock);
+
+	return found ? 0 : -EINVAL;
+}
+
 enum {
 	PROBE_TEST_FUNC		= 1,
 	PROBE_TEST_DATA		= 2
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 256764e..dd5c648 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -883,8 +883,12 @@ static bool is_string_field(struct ftrace_event_field *field)
 	       field->filter_type == FILTER_PTR_STRING;
 }
 
-static int is_legal_op(struct ftrace_event_field *field, int op)
+static int is_legal_op(struct ftrace_event_call *call,
+		       struct ftrace_event_field *field, int op)
 {
+	if ((call->event.type == TRACE_FN) &&
+	    (op != OP_EQ && op != OP_NE))
+		return 0;
 	if (is_string_field(field) &&
 	    (op != OP_EQ && op != OP_NE && op != OP_GLOB))
 		return 0;
@@ -937,6 +941,24 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 	return fn;
 }
 
+static int pred_get_val(struct ftrace_event_call *call,
+			struct filter_pred *pred,
+			struct ftrace_event_field *field,
+			unsigned long long *val)
+{
+	int ret;
+
+	if (call->event.type == TRACE_FN)
+		return ftrace_function_rec_ip(pred->regex.pattern, val);
+
+	if (field->is_signed)
+		ret = strict_strtoll(pred->regex.pattern, 0, val);
+	else
+		ret = strict_strtoull(pred->regex.pattern, 0, val);
+
+	return ret;
+}
+
 static int filter_add_pred(struct filter_parse_state *ps,
 			   struct ftrace_event_call *call,
 			   struct event_filter *filter,
@@ -964,7 +986,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 	pred->offset = field->offset;
 
-	if (!is_legal_op(field, pred->op)) {
+	if (!is_legal_op(call, field, pred->op)) {
 		parse_error(ps, FILT_ERR_ILLEGAL_FIELD_OP, 0);
 		return -EINVAL;
 	}
@@ -980,14 +1002,12 @@ static int filter_add_pred(struct filter_parse_state *ps,
 		else
 			fn = filter_pred_pchar;
 	} else {
-		if (field->is_signed)
-			ret = strict_strtoll(pred->regex.pattern, 0, &val);
-		else
-			ret = strict_strtoull(pred->regex.pattern, 0, &val);
+		ret = pred_get_val(call, pred, field, &val);
 		if (ret) {
 			parse_error(ps, FILT_ERR_ILLEGAL_INTVAL, 0);
 			return -EINVAL;
 		}
+
 		pred->val = val;
 
 		fn = select_comparison_fn(pred->op, field->size,
-- 
1.7.1

