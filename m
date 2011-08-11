Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab1HKO0K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096Ab1HKO0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:09 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 03/10] tracing/filter: Remove field_name from filter_pred struct
Date: Thu, 11 Aug 2011 16:25:47 +0200
Message-Id: <1313072754-4620-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
 <1313072754-4620-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The field_name was used just for finding event's fields. This way we
don't need to care about field_name allocation/free.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.1

