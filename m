Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab1BHCAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:00:43 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755039Ab1BHB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:35 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=pq8OE4eEtPgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=Z96kRMapst6j3PuDKLIA:9 a=zHzPK_B8aG8XLFaLjfIA:7 a=XyaxkC4DuJ0gmX8LeDmtPcJWP50A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015932.528580016@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:24 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 07/14] tracing/filter: Use a tree instead of stack for filter_match_preds()
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0007-tracing-filter-Use-a-tree-instead-of-stack-for-filte.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently the filter_match_preds() requires a stack to push
and pop the preds to determine if the filter matches the record or not.
This has two drawbacks:

1) It requires a stack to store state information. As this is done
   in fast paths we can't allocate the storage for this stack, and
   we can't use a global as it must be re-entrant. The stack is stored
   on the kernel stack and this greatly limits how many preds we
   may allow.

2) All conditions are calculated even when a short circuit exists.
   a || b  will always calculate a and b even though a was determined
   to be true.

Using a tree we can walk a constant structure that will save
the state as we go. The algorithm is simply:

  pred = root;
  do {
	switch (move) {
	case MOVE_DOWN:
		if (OR or AND) {
			pred = left;
			continue;
		}
		if (pred == root)
			break;
		match = pred->fn();
		pred = pred->parent;
		move = left child ? MOVE_UP_FROM_LEFT : MOVE_UP_FROM_RIGHT;
		continue;

	case MOVE_UP_FROM_LEFT:
		/* Only OR or AND can be a parent */
		if (match && OR || !match && AND) {
			/* short circuit */
			if (pred == root)
				break;
			pred = pred->parent;
			move = left child ?
				MOVE_UP_FROM_LEFT :
				MOVE_UP_FROM_RIGHT;
			continue;
		}
		pred = pred->right;
		move = MOVE_DOWN;
		continue;

	case MOVE_UP_FROM_RIGHT:
		if (pred == root)
			break;
		pred = pred->parent;
		move = left child ? MOVE_UP_FROM_LEFT : MOVE_UP_FROM_RIGHT;
		continue;
	}
	done = 1;
  } while (!done);

This way there's no strict limit to how many preds we allow
and it also will short circuit the logical operations when possible.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |    9 ++-
 kernel/trace/trace_events_filter.c |  231 +++++++++++++++++++++++++++++-------
 2 files changed, 194 insertions(+), 46 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 254d04a..bba34a7 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -664,6 +664,7 @@ struct event_filter {
 	int			n_preds;	/* Number assigned */
 	int			a_preds;	/* allocated */
 	struct filter_pred	*preds;
+	struct filter_pred	*root;
 	char			*filter_string;
 };
 
@@ -675,6 +676,9 @@ struct event_subsystem {
 	int			nr_events;
 };
 
+#define FILTER_PRED_INVALID	((unsigned short)-1)
+#define FILTER_PRED_IS_RIGHT	(1 << 15)
+
 struct filter_pred;
 struct regex;
 
@@ -704,7 +708,10 @@ struct filter_pred {
 	int 			offset;
 	int 			not;
 	int 			op;
-	int 			pop_n;
+	unsigned short		index;
+	unsigned short		parent;
+	unsigned short		left;
+	unsigned short		right;
 };
 
 extern struct list_head ftrace_common_fields;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 2f5458e..1039049 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -123,6 +123,11 @@ struct filter_parse_state {
 	} operand;
 };
 
+struct pred_stack {
+	struct filter_pred	**preds;
+	int			index;
+};
+
 #define DEFINE_COMPARISON_PRED(type)					\
 static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 {									\
@@ -357,52 +362,95 @@ static void filter_build_regex(struct filter_pred *pred)
 	pred->not ^= not;
 }
 
+enum move_type {
+	MOVE_DOWN,
+	MOVE_UP_FROM_LEFT,
+	MOVE_UP_FROM_RIGHT
+};
+
+static struct filter_pred *
+get_pred_parent(struct filter_pred *pred, struct filter_pred *preds,
+		int index, enum move_type *move)
+{
+	if (pred->parent & FILTER_PRED_IS_RIGHT)
+		*move = MOVE_UP_FROM_RIGHT;
+	else
+		*move = MOVE_UP_FROM_LEFT;
+	pred = &preds[pred->parent & ~FILTER_PRED_IS_RIGHT];
+
+	return pred;
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct event_filter *filter, void *rec)
 {
-	int match = -1, top = 0, val1 = 0, val2 = 0;
-	int stack[MAX_FILTER_PRED];
+	int match = -1;
+	enum move_type move = MOVE_DOWN;
 	struct filter_pred *preds;
 	struct filter_pred *pred;
+	struct filter_pred *root;
 	int n_preds = ACCESS_ONCE(filter->n_preds);
-	int i;
+	int done = 0;
 
 	/* no filter is considered a match */
 	if (!n_preds)
 		return 1;
 
 	/*
-	 * n_preds and filter->preds is protect with preemption disabled.
+	 * n_preds, root and filter->preds are protect with preemption disabled.
 	 */
 	preds = rcu_dereference_sched(filter->preds);
+	root = rcu_dereference_sched(filter->root);
+	if (!root)
+		return 1;
 
-	for (i = 0; i < n_preds; i++) {
-		pred = &preds[i];
-		if (!pred->pop_n) {
+	pred = root;
+
+	/* match is currently meaningless */
+	match = -1;
+
+	do {
+		switch (move) {
+		case MOVE_DOWN:
+			/* only AND and OR have children */
+			if (pred->left != FILTER_PRED_INVALID) {
+				/* keep going to leaf node */
+				pred = &preds[pred->left];
+				continue;
+			}
 			match = pred->fn(pred, rec);
-			stack[top++] = match;
+			/* If this pred is the only pred */
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		case MOVE_UP_FROM_LEFT:
+			/* Check for short circuits */
+			if ((match && pred->op == OP_OR) ||
+			    (!match && pred->op == OP_AND)) {
+				if (pred == root)
+					break;
+				pred = get_pred_parent(pred, preds,
+						       pred->parent, &move);
+				continue;
+			}
+			/* now go down the right side of the tree. */
+			pred = &preds[pred->right];
+			move = MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+			/* We finished this equation. */
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
 			continue;
 		}
-		if (pred->pop_n > top) {
-			WARN_ON_ONCE(1);
-			return 0;
-		}
-		val1 = stack[--top];
-		val2 = stack[--top];
-		switch (pred->op) {
-		case OP_AND:
-			match = val1 && val2;
-			break;
-		case OP_OR:
-			match = val1 || val2;
-			break;
-		default:
-			WARN_ONCE(1, "filter op is not AND or OR");
-		}
-		stack[top++] = match;
-	}
+		done = 1;
+	} while (!done);
 
-	return stack[--top];
+	return match;
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
@@ -539,10 +587,58 @@ static void filter_clear_pred(struct filter_pred *pred)
 	pred->regex.len = 0;
 }
 
-static int filter_set_pred(struct filter_pred *dest,
+static int __alloc_pred_stack(struct pred_stack *stack, int n_preds)
+{
+	stack->preds = kzalloc(sizeof(*stack->preds)*(n_preds + 1), GFP_KERNEL);
+	if (!stack->preds)
+		return -ENOMEM;
+	stack->index = n_preds;
+	return 0;
+}
+
+static void __free_pred_stack(struct pred_stack *stack)
+{
+	kfree(stack->preds);
+	stack->index = 0;
+}
+
+static int __push_pred_stack(struct pred_stack *stack,
+			     struct filter_pred *pred)
+{
+	int index = stack->index;
+
+	if (WARN_ON(index == 0))
+		return -ENOSPC;
+
+	stack->preds[--index] = pred;
+	stack->index = index;
+	return 0;
+}
+
+static struct filter_pred *
+__pop_pred_stack(struct pred_stack *stack)
+{
+	struct filter_pred *pred;
+	int index = stack->index;
+
+	pred = stack->preds[index++];
+	if (!pred)
+		return NULL;
+
+	stack->index = index;
+	return pred;
+}
+
+static int filter_set_pred(struct event_filter *filter,
+			   int idx,
+			   struct pred_stack *stack,
 			   struct filter_pred *src,
 			   filter_pred_fn_t fn)
 {
+	struct filter_pred *dest = &filter->preds[idx];
+	struct filter_pred *left;
+	struct filter_pred *right;
+
 	*dest = *src;
 	if (src->field_name) {
 		dest->field_name = kstrdup(src->field_name, GFP_KERNEL);
@@ -550,8 +646,25 @@ static int filter_set_pred(struct filter_pred *dest,
 			return -ENOMEM;
 	}
 	dest->fn = fn;
+	dest->index = idx;
 
-	return 0;
+	if (dest->op == OP_OR || dest->op == OP_AND) {
+		right = __pop_pred_stack(stack);
+		left = __pop_pred_stack(stack);
+		if (!left || !right)
+			return -EINVAL;
+		dest->left = left->index;
+		dest->right = right->index;
+		left->parent = dest->index;
+		right->parent = dest->index | FILTER_PRED_IS_RIGHT;
+	} else
+		/*
+		 * Make dest->left invalid to be used as a quick
+		 * way to know this is a leaf node.
+		 */
+		dest->left = FILTER_PRED_INVALID;
+
+	return __push_pred_stack(stack, dest);
 }
 
 static void __free_preds(struct event_filter *filter)
@@ -574,6 +687,7 @@ static void reset_preds(struct event_filter *filter)
 	int i;
 
 	filter->n_preds = 0;
+	filter->root = NULL;
 	if (!filter->preds)
 		return;
 
@@ -707,6 +821,7 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 			      struct ftrace_event_call *call,
 			      struct event_filter *filter,
 			      struct filter_pred *pred,
+			      struct pred_stack *stack,
 			      filter_pred_fn_t fn)
 {
 	int idx, err;
@@ -718,7 +833,7 @@ static int filter_add_pred_fn(struct filter_parse_state *ps,
 
 	idx = filter->n_preds;
 	filter_clear_pred(&filter->preds[idx]);
-	err = filter_set_pred(&filter->preds[idx], pred, fn);
+	err = filter_set_pred(filter, idx, stack, pred, fn);
 	if (err)
 		return err;
 
@@ -803,6 +918,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 			   struct ftrace_event_call *call,
 			   struct event_filter *filter,
 			   struct filter_pred *pred,
+			   struct pred_stack *stack,
 			   bool dry_run)
 {
 	struct ftrace_event_field *field;
@@ -812,13 +928,10 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 	fn = pred->fn = filter_pred_none;
 
-	if (pred->op == OP_AND) {
-		pred->pop_n = 2;
+	if (pred->op == OP_AND)
 		goto add_pred_fn;
-	} else if (pred->op == OP_OR) {
-		pred->pop_n = 2;
+	else if (pred->op == OP_OR)
 		goto add_pred_fn;
-	}
 
 	field = find_event_field(call, pred->field_name);
 	if (!field) {
@@ -867,7 +980,7 @@ static int filter_add_pred(struct filter_parse_state *ps,
 
 add_pred_fn:
 	if (!dry_run)
-		return filter_add_pred_fn(ps, call, filter, pred, fn);
+		return filter_add_pred_fn(ps, call, filter, pred, stack, fn);
 	return 0;
 }
 
@@ -1248,6 +1361,7 @@ static int replace_preds(struct ftrace_event_call *call,
 	char *operand1 = NULL, *operand2 = NULL;
 	struct filter_pred *pred;
 	struct postfix_elt *elt;
+	struct pred_stack stack = { }; /* init to NULL */
 	int err;
 	int n_preds = 0;
 
@@ -1262,9 +1376,12 @@ static int replace_preds(struct ftrace_event_call *call,
 		return err;
 
 	if (!dry_run) {
-		err = __alloc_preds(filter, n_preds);
+		err = __alloc_pred_stack(&stack, n_preds);
 		if (err)
 			return err;
+		err = __alloc_preds(filter, n_preds);
+		if (err)
+			goto fail;
 	}
 
 	n_preds = 0;
@@ -1276,14 +1393,16 @@ static int replace_preds(struct ftrace_event_call *call,
 				operand2 = elt->operand;
 			else {
 				parse_error(ps, FILT_ERR_TOO_MANY_OPERANDS, 0);
-				return -EINVAL;
+				err = -EINVAL;
+				goto fail;
 			}
 			continue;
 		}
 
 		if (WARN_ON(n_preds++ == MAX_FILTER_PRED)) {
 			parse_error(ps, FILT_ERR_TOO_MANY_PREDS, 0);
-			return -ENOSPC;
+			err = -ENOSPC;
+			goto fail;
 		}
 
 		if (elt->op == OP_AND || elt->op == OP_OR) {
@@ -1293,22 +1412,44 @@ static int replace_preds(struct ftrace_event_call *call,
 
 		if (!operand1 || !operand2) {
 			parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
-			return -EINVAL;
+			err = -EINVAL;
+			goto fail;
 		}
 
 		pred = create_pred(elt->op, operand1, operand2);
 add_pred:
-		if (!pred)
-			return -ENOMEM;
-		err = filter_add_pred(ps, call, filter, pred, dry_run);
+		if (!pred) {
+			err = -ENOMEM;
+			goto fail;
+		}
+		err = filter_add_pred(ps, call, filter, pred, &stack, dry_run);
 		filter_free_pred(pred);
 		if (err)
-			return err;
+			goto fail;
 
 		operand1 = operand2 = NULL;
 	}
 
-	return 0;
+	if (!dry_run) {
+		/* We should have one item left on the stack */
+		pred = __pop_pred_stack(&stack);
+		if (!pred)
+			return -EINVAL;
+		/* This item is where we start from in matching */
+		filter->root = pred;
+		/* Make sure the stack is empty */
+		pred = __pop_pred_stack(&stack);
+		if (WARN_ON(pred)) {
+			err = -EINVAL;
+			filter->root = NULL;
+			goto fail;
+		}
+	}
+
+	err = 0;
+fail:
+	__free_pred_stack(&stack);
+	return err;
 }
 
 static int replace_system_preds(struct event_subsystem *system,
-- 
1.7.2.3


