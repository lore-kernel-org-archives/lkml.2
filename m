Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411Ab1IVWOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:14:10 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab1IVWK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:29 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=4wCVTfF9HgQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=Ky0D2PmeofUsbvsnH_4A:9 a=jMk1RLzZTtfZIY6f-tAA:7 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221026.346037059@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/21] tracing/filter: Remove field_name from filter_pred struct
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0006-tracing-filter-Remove-field_name-from-filter_pred-st.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

The field_name was used just for finding event's fields. This way we
don't need to care about field_name allocation/free.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-4-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |   11 +-------
 kernel/trace/trace_events_filter.c |   53 ++++++++---------------------------
 2 files changed, 13 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 616846b..2eb3cf6 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -761,16 +761,7 @@ struct filter_pred {
 	filter_pred_fn_t 	fn;
 	u64 			val;
 	struct regex		regex;
-	/*
-	 * Leaf nodes use field_name, ops is used by AND and OR
-	 * nodes. The field_name is always freed when freeing a pred.
-	 * We can overload field_name for ops and have it freed
-	 * as well.
-	 */
-	union {
-		char		*field_name;
-		unsigned short	*ops;
-	};
+	unsigned short		*ops;
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 61c8dec..97b93f3 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -628,18 +628,6 @@ find_event_field(struct ftrace_event_call *call, char *name)
 	return __find_event_field(head, name);
 }
 
-static void filter_free_pred(struct filter_pred *pred)
-{
-	kfree(pred->field_name);
-}
-
-static void filter_clear_pred(struct filter_pred *pred)
-{
-	kfree(pred->field_name);
-	pred->field_name = NULL;
-	pred->regex.len = 0;
-}
-
 static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
 {
 	stack->preds = kzalloc(sizeof(*stack->preds)*(n_preds + 1), GFP_KERNEL);
@@ -692,11 +680,6 @@ static int filter_set_pred(struct event_filter *filter,
 	struct filter_pred *right;
 
 	*dest = *src;
-	if (src->field_name) {
-		dest->field_name = kstrdup(src->field_name, GFP_KERNEL);
-		if (!dest->field_name)
-			return -ENOMEM;
-	}
 	dest->index = idx;
 
 	if (dest->op == OP_OR || dest->op == OP_AND) {
@@ -737,11 +720,7 @@ static int filter_set_pred(struct event_filter *filter,
 
 static void __free_preds(struct event_filter *filter)
 {
-	int i;
-
 	if (filter->preds) {
-		for (i = 0; i < filter->a_preds; i++)
-			kfree(filter->preds[i].field_name);
 		kfree(filter->preds);
 		filter->preds = NULL;
 	}
@@ -839,16 +818,14 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			   struct filter_pred *pred,
 			   struct pred_stack *stack)
 {
-	int idx, err;
+	int err;
 
 	if (WARN_ON(filter->n_preds == filter->a_preds)) {
 		parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
 		return -ENOSPC;
 	}
 
-	idx = filter->n_preds;
-	filter_clear_pred(&filter->preds[idx]);
-	err = filter_set_pred(filter, idx, stack, pred);
+	err = filter_set_pred(filter, filter->n_preds, stack, pred);
 	if (err)
 		return err;
 
@@ -930,21 +907,14 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 }
 
 static int init_pred(struct filter_parse_state *ps,
-		     struct ftrace_event_call *call,
+		     struct ftrace_event_field *field,
 		     struct filter_pred *pred)
 
 {
-	struct ftrace_event_field *field;
 	filter_pred_fn_t fn = filter_pred_none;
 	unsigned long long val;
 	int ret;
 
-	field = find_event_field(call, pred->field_name);
-	if (!field) {
-		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
-		return -EINVAL;
-	}
-
 	pred->offset = field->offset;
 
 	if (!is_legal_op(field, pred->op)) {
@@ -1287,6 +1257,7 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 				       struct ftrace_event_call *call,
 				       int op, char *operand1, char *operand2)
 {
+	struct ftrace_event_field *field;
 	static struct filter_pred pred;
 
 	memset(&pred, 0, sizeof(pred));
@@ -1300,14 +1271,16 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 		return NULL;
 	}
 
-	pred.field_name = kstrdup(operand1, GFP_KERNEL);
-	if (!pred.field_name)
+	field = find_event_field(call, operand1);
+	if (!field) {
+		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
 		return NULL;
+	}
 
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len = strlen(pred.regex.pattern);
 
-	return init_pred(ps, call, &pred) ? NULL : &pred;
+	return init_pred(ps, field, &pred) ? NULL : &pred;
 }
 
 static int check_preds(struct filter_parse_state *ps)
@@ -1618,18 +1591,16 @@ static int replace_preds(struct ftrace_event_call *call,
 
 		pred = create_pred(ps, call, elt->op, operand1, operand2);
 		if (!pred) {
-			err = -ENOMEM;
+			err = -EINVAL;
 			goto fail;
 		}
+
 		if (!dry_run) {
 			err = filter_add_pred(ps, filter, pred, &stack);
-			if (err) {
-				filter_free_pred(pred);
+			if (err)
 				goto fail;
-			}
 		}
 
-		filter_free_pred(pred);
 		operand1 = operand2 = NULL;
 	}
 
-- 
1.7.5.4


