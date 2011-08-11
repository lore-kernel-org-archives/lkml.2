Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab1HKO0I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751347Ab1HKO0G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:06 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 02/10] tracing/filter: Separate predicate init and filter addition
Date: Thu, 11 Aug 2011 16:25:46 +0200
Message-Id: <1313072754-4620-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
 <1313072754-4620-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making the code cleaner by having one function to fully prepare
the predicate (create_pred), and another to add the predicate to
the filter (filter_add_pred).

As a benefit, this way the dry_run flag stays only inside the
replace_preds function and is not passed deeper.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_events_filter.c |   56 +++++++++++++++---------------------
 1 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index cb295a1..61c8dec 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -685,8 +685,7 @@ __pop_pred_stack(struct pred_stack *stack)
 static int filter_set_pred(struct event_filter *filter,
 			   int idx,
 			   struct pred_stack *stack,
-			   struct filter_pred *src,
-			   filter_pred_fn_t fn)
+			   struct filter_pred *src)
 {
 	struct filter_pred *dest = &filter->preds[idx];
 	struct filter_pred *left;
@@ -698,7 +697,6 @@ static int filter_set_pred(struct event_filter *filter,
 		if (!dest->field_name)
 			return -ENOMEM;
 	}
-	dest->fn = fn;
 	dest->index = idx;
 
 	if (dest->op == OP_OR || dest->op == OP_AND) {
@@ -836,12 +834,10 @@ static void filter_free_subsystem_filters(struct event_subsystem *system)
 	}
 }
 
-static int filter_add_pred_fn(struct filter_parse_state *ps,
-			      struct ftrace_event_call *call,
-			      struct event_filter *filter,
-			      struct filter_pred *pred,
-			      struct pred_stack *stack,
-			      filter_pred_fn_t fn)
+static int filter_add_pred(struct filter_parse_state *ps,
+			   struct event_filter *filter,
+			   struct filter_pred *pred,
+			   struct pred_stack *stack)
 {
 	int idx, err;
 
@@ -852,7 +848,7 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 
 	idx = filter->n_preds;
 	filter_clear_pred(&filter->preds[idx]);
-	err = filter_set_pred(filter, idx, stack, pred, fn);
+	err = filter_set_pred(filter, idx, stack, pred);
 	if (err)
 		return err;
 
@@ -933,25 +929,16 @@ static filter_pred_fn_t select_comparison_fn(int op, int field_size,
 	return fn;
 }
 
-static int filter_add_pred(struct filter_parse_state *ps,
-			   struct ftrace_event_call *call,
-			   struct event_filter *filter,
-			   struct filter_pred *pred,
-			   struct pred_stack *stack,
-			   bool dry_run)
+static int init_pred(struct filter_parse_state *ps,
+		     struct ftrace_event_call *call,
+		     struct filter_pred *pred)
+
 {
 	struct ftrace_event_field *field;
-	filter_pred_fn_t fn;
+	filter_pred_fn_t fn = filter_pred_none;
 	unsigned long long val;
 	int ret;
 
-	fn = pred->fn = filter_pred_none;
-
-	if (pred->op == OP_AND)
-		goto add_pred_fn;
-	else if (pred->op == OP_OR)
-		goto add_pred_fn;
-
 	field = find_event_field(call, pred->field_name);
 	if (!field) {
 		parse_error(ps, FILT_ERR_FIELD_NOT_FOUND, 0);
@@ -997,9 +984,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	if (pred->op == OP_NE)
 		pred->not = 1;
 
-add_pred_fn:
-	if (!dry_run)
-		return filter_add_pred_fn(ps, call, filter, pred, stack, fn);
+	pred->fn = fn;
 	return 0;
 }
 
@@ -1299,6 +1284,7 @@ parse_operand:
 }
 
 static struct filter_pred *create_pred(struct filter_parse_state *ps,
+				       struct ftrace_event_call *call,
 				       int op, char *operand1, char *operand2)
 {
 	static struct filter_pred pred;
@@ -1321,7 +1307,7 @@ static struct filter_pred *create_pred(struct filter_parse_state *ps,
 	strcpy(pred.regex.pattern, operand2);
 	pred.regex.len = strlen(pred.regex.pattern);
 
-	return &pred;
+	return init_pred(ps, call, &pred) ? NULL : &pred;
 }
 
 static int check_preds(struct filter_parse_state *ps)
@@ -1630,16 +1616,20 @@ static int replace_preds(struct ftrace_event_call *call,
 			goto fail;
 		}
 
-		pred = create_pred(ps, elt->op, operand1, operand2);
+		pred = create_pred(ps, call, elt->op, operand1, operand2);
 		if (!pred) {
 			err = -ENOMEM;
 			goto fail;
 		}
-		err = filter_add_pred(ps, call, filter, pred, &stack, dry_run);
-		filter_free_pred(pred);
-		if (err)
-			goto fail;
+		if (!dry_run) {
+			err = filter_add_pred(ps, filter, pred, &stack);
+			if (err) {
+				filter_free_pred(pred);
+				goto fail;
+			}
+		}
 
+		filter_free_pred(pred);
 		operand1 = operand2 = NULL;
 	}
 
-- 
1.7.1

