Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab1BHB7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 20:59:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:60035 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755064Ab1BHB7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:35 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=zInY9mqziGgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=H7L0gltVoDzjVvLsh0kA:9 a=waIr1n1K36Dt5UhBdiEA:7 a=HfQbqlD1EPiTgB0T1AyXdov1DHEA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015933.443728443@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 10/14] tracing/filter: Optimize filter by folding the tree
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-filter-Optimize-filter-by-folding-the-tree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

There are many cases that a filter will contain multiple ORs or
ANDs together near the leafs. Walking up and down the tree to get
to the next compare can be a waste.

If there are several ORs or ANDs together, fold them into a single
pred and allocate an array of the conditions that they check.
This will speed up the filter by linearly walking an array
and can still break out if a short circuit condition is met.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |   12 ++-
 kernel/trace/trace_events_filter.c |  233 ++++++++++++++++++++++++++++++++++--
 2 files changed, 235 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index bba34a7..d754330 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -678,6 +678,7 @@ struct event_subsystem {
 
 #define FILTER_PRED_INVALID	((unsigned short)-1)
 #define FILTER_PRED_IS_RIGHT	(1 << 15)
+#define FILTER_PRED_FOLD	(1 << 15)
 
 struct filter_pred;
 struct regex;
@@ -704,7 +705,16 @@ struct filter_pred {
 	filter_pred_fn_t 	fn;
 	u64 			val;
 	struct regex		regex;
-	char 			*field_name;
+	/*
+	 * Leaf nodes use field_name, ops is used by AND and OR
+	 * nodes. The field_name is always freed when freeing a pred.
+	 * We can overload field_name for ops and have it freed
+	 * as well.
+	 */
+	union {
+		char		*field_name;
+		unsigned short	*ops;
+	};
 	int 			offset;
 	int 			not;
 	int 			op;
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 91c9cdc..2403ce5 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -381,6 +381,42 @@ get_pred_parent(struct filter_pred *pred, struct filter_pred *preds,
 	return pred;
 }
 
+/*
+ * A series of AND or ORs where found together. Instead of
+ * climbing up and down the tree branches, an array of the
+ * ops were made in order of checks. We can just move across
+ * the array and short circuit if needed.
+ */
+static int process_ops(struct filter_pred *preds,
+		       struct filter_pred *op, void *rec)
+{
+	struct filter_pred *pred;
+	int type;
+	int match;
+	int i;
+
+	/*
+	 * Micro-optimization: We set type to true if op
+	 * is an OR and false otherwise (AND). Then we
+	 * just need to test if the match is equal to
+	 * the type, and if it is, we can short circuit the
+	 * rest of the checks:
+	 *
+	 * if ((match && op->op == OP_OR) ||
+	 *     (!match && op->op == OP_AND))
+	 *	  return match;
+	 */
+	type = op->op == OP_OR;
+
+	for (i = 0; i < op->val; i++) {
+		pred = &preds[op->ops[i]];
+		match = pred->fn(pred, rec);
+		if (!!match == type)
+			return match;
+	}
+	return match;
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct event_filter *filter, void *rec)
 {
@@ -414,11 +450,16 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 		case MOVE_DOWN:
 			/* only AND and OR have children */
 			if (pred->left != FILTER_PRED_INVALID) {
-				/* keep going to leaf node */
-				pred = &preds[pred->left];
-				continue;
-			}
-			match = pred->fn(pred, rec);
+				/* If ops is set, then it was folded. */
+				if (!pred->ops) {
+					/* keep going to down the left side */
+					pred = &preds[pred->left];
+					continue;
+				}
+				/* We can treat folded ops as a leaf node */
+				match = process_ops(preds, pred, rec);
+			} else
+				match = pred->fn(pred, rec);
 			/* If this pred is the only pred */
 			if (pred == root)
 				break;
@@ -659,17 +700,34 @@ static int filter_set_pred(struct event_filter *filter,
 		left = __pop_pred_stack(stack);
 		if (!left || !right)
 			return -EINVAL;
-		dest->left = left->index;
-		dest->right = right->index;
-		left->parent = dest->index;
+		/*
+		 * If both children can be folded
+		 * and they are the same op as this op or a leaf,
+		 * then this op can be folded.
+		 */
+		if (left->index & FILTER_PRED_FOLD &&
+		    (left->op == dest->op ||
+		     left->left == FILTER_PRED_INVALID) &&
+		    right->index & FILTER_PRED_FOLD &&
+		    (right->op == dest->op ||
+		     right->left == FILTER_PRED_INVALID))
+			dest->index |= FILTER_PRED_FOLD;
+
+		dest->left = left->index & ~FILTER_PRED_FOLD;
+		dest->right = right->index & ~FILTER_PRED_FOLD;
+		left->parent = dest->index & ~FILTER_PRED_FOLD;
 		right->parent = dest->index | FILTER_PRED_IS_RIGHT;
-	} else
+	} else {
 		/*
 		 * Make dest->left invalid to be used as a quick
 		 * way to know this is a leaf node.
 		 */
 		dest->left = FILTER_PRED_INVALID;
 
+		/* All leafs allow folding the parent ops. */
+		dest->index |= FILTER_PRED_FOLD;
+	}
+
 	return __push_pred_stack(stack, dest);
 }
 
@@ -1420,6 +1478,158 @@ static int check_pred_tree(struct event_filter *filter,
 	return 0;
 }
 
+static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
+{
+	struct filter_pred *pred;
+	enum move_type move = MOVE_DOWN;
+	int count = 0;
+	int done = 0;
+
+	pred = root;
+
+	do {
+		switch (move) {
+		case MOVE_DOWN:
+			if (pred->left != FILTER_PRED_INVALID) {
+				pred = &preds[pred->left];
+				continue;
+			}
+			/* A leaf at the root is just a leaf in the tree */
+			if (pred == root)
+				return 1;
+			count++;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		case MOVE_UP_FROM_LEFT:
+			pred = &preds[pred->right];
+			move = MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		}
+		done = 1;
+	} while (!done);
+
+	return count;
+}
+
+static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
+{
+	struct filter_pred *pred;
+	enum move_type move = MOVE_DOWN;
+	int count = 0;
+	int children;
+	int done = 0;
+
+	/* No need to keep the fold flag */
+	root->index &= ~FILTER_PRED_FOLD;
+
+	/* If the root is a leaf then do nothing */
+	if (root->left == FILTER_PRED_INVALID)
+		return 0;
+
+	/* count the children */
+	children = count_leafs(preds, &preds[root->left]);
+	children += count_leafs(preds, &preds[root->right]);
+
+	root->ops = kzalloc(sizeof(*root->ops) * children, GFP_KERNEL);
+	if (!root->ops)
+		return -ENOMEM;
+
+	root->val = children;
+
+	pred = root;
+	do {
+		switch (move) {
+		case MOVE_DOWN:
+			if (pred->left != FILTER_PRED_INVALID) {
+				pred = &preds[pred->left];
+				continue;
+			}
+			if (WARN_ON(count == children))
+				return -EINVAL;
+			pred->index &= ~FILTER_PRED_FOLD;
+			root->ops[count++] = pred->index;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		case MOVE_UP_FROM_LEFT:
+			pred = &preds[pred->right];
+			move = MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		}
+		done = 1;
+	} while (!done);
+
+	return 0;
+}
+
+/*
+ * To optimize the processing of the ops, if we have several "ors" or
+ * "ands" together, we can put them in an array and process them all
+ * together speeding up the filter logic.
+ */
+static int fold_pred_tree(struct event_filter *filter,
+			   struct filter_pred *root)
+{
+	struct filter_pred *preds;
+	struct filter_pred *pred;
+	enum move_type move = MOVE_DOWN;
+	int done = 0;
+	int err;
+
+	preds = filter->preds;
+	if  (!preds)
+		return -EINVAL;
+	pred = root;
+
+	do {
+		switch (move) {
+		case MOVE_DOWN:
+			if (pred->index & FILTER_PRED_FOLD) {
+				err = fold_pred(preds, pred);
+				if (err)
+					return err;
+				/* Folded nodes are like leafs */
+			} else if (pred->left != FILTER_PRED_INVALID) {
+				pred = &preds[pred->left];
+				continue;
+			}
+
+			/* A leaf at the root is just a leaf in the tree */
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		case MOVE_UP_FROM_LEFT:
+			pred = &preds[pred->right];
+			move = MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		}
+		done = 1;
+	} while (!done);
+
+	return 0;
+}
+
 static int replace_preds(struct ftrace_event_call *call,
 			 struct event_filter *filter,
 			 struct filter_parse_state *ps,
@@ -1517,6 +1727,11 @@ add_pred:
 		if (err)
 			goto fail;
 
+		/* Optimize the tree */
+		err = fold_pred_tree(filter, root);
+		if (err)
+			goto fail;
+
 		/* We don't set root until we know it works */
 		barrier();
 		filter->root = root;
-- 
1.7.2.3


