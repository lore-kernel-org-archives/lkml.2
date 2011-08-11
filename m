Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1HKO02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1HKO0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:24 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 09/10] tracing/filter: Change filter_match_preds function to use walk_pred_tree
Date: Thu, 11 Aug 2011 16:25:53 +0200
Message-Id: <1313072754-4620-10-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
 <1313072754-4620-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing filter_match_preds function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_events_filter.c |  124 +++++++++++++++++-------------------
 1 files changed, 58 insertions(+), 66 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index f44e68b..319c3ca 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -467,99 +467,91 @@ static int process_ops(struct filter_pred *preds,
 
 	for (i = 0; i < op->val; i++) {
 		pred = &preds[op->ops[i]];
-		match = pred->fn(pred, rec);
+		if (!WARN_ON_ONCE(!pred->fn))
+			match = pred->fn(pred, rec);
 		if (!!match == type)
 			return match;
 	}
 	return match;
 }
 
+struct filter_match_preds_data {
+	struct filter_pred *preds;
+	int match;
+	void *rec;
+};
+
+static int filter_match_preds_cb(enum move_type move, struct filter_pred *pred,
+				 int *err, void *data)
+{
+	struct filter_match_preds_data *d = data;
+
+	*err = 0;
+	switch (move) {
+	case MOVE_DOWN:
+		/* only AND and OR have children */
+		if (pred->left != FILTER_PRED_INVALID) {
+			/* If ops is set, then it was folded. */
+			if (!pred->ops)
+				return WALK_PRED_DEFAULT;
+			/* We can treat folded ops as a leaf node */
+			d->match = process_ops(d->preds, pred, d->rec);
+		} else {
+			if (!WARN_ON_ONCE(!pred->fn))
+				d->match = pred->fn(pred, d->rec);
+		}
+
+		return WALK_PRED_PARENT;
+	case MOVE_UP_FROM_LEFT:
+		/*
+		 * Check for short circuits.
+		 *
+		 * Optimization: !!match == (pred->op == OP_OR)
+		 *   is the same as:
+		 * if ((match && pred->op == OP_OR) ||
+		 *     (!match && pred->op == OP_AND))
+		 */
+		if (!!d->match == (pred->op == OP_OR))
+			return WALK_PRED_PARENT;
+		break;
+	case MOVE_UP_FROM_RIGHT:
+		break;
+	}
+
+	return WALK_PRED_DEFAULT;
+}
+
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct event_filter *filter, void *rec)
 {
-	int match = -1;
-	enum move_type move = MOVE_DOWN;
 	struct filter_pred *preds;
-	struct filter_pred *pred;
 	struct filter_pred *root;
-	int n_preds;
-	int done = 0;
+	struct filter_match_preds_data data = {
+		/* match is currently meaningless */
+		.match = -1,
+		.rec   = rec,
+	};
+	int n_preds, ret;
 
 	/* no filter is considered a match */
 	if (!filter)
 		return 1;
 
 	n_preds = filter->n_preds;
-
 	if (!n_preds)
 		return 1;
 
 	/*
 	 * n_preds, root and filter->preds are protect with preemption disabled.
 	 */
-	preds = rcu_dereference_sched(filter->preds);
 	root = rcu_dereference_sched(filter->root);
 	if (!root)
 		return 1;
 
-	pred = root;
-
-	/* match is currently meaningless */
-	match = -1;
-
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			/* only AND and OR have children */
-			if (pred->left != FILTER_PRED_INVALID) {
-				/* If ops is set, then it was folded. */
-				if (!pred->ops) {
-					/* keep going to down the left side */
-					pred = &preds[pred->left];
-					continue;
-				}
-				/* We can treat folded ops as a leaf node */
-				match = process_ops(preds, pred, rec);
-			} else
-				match = pred->fn(pred, rec);
-			/* If this pred is the only pred */
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			/*
-			 * Check for short circuits.
-			 *
-			 * Optimization: !!match == (pred->op == OP_OR)
-			 *   is the same as:
-			 * if ((match && pred->op == OP_OR) ||
-			 *     (!match && pred->op == OP_AND))
-			 */
-			if (!!match == (pred->op == OP_OR)) {
-				if (pred == root)
-					break;
-				pred = get_pred_parent(pred, preds,
-						       pred->parent, &move);
-				continue;
-			}
-			/* now go down the right side of the tree. */
-			pred = &preds[pred->right];
-			move = MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			/* We finished this equation. */
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done = 1;
-	} while (!done);
-
-	return match;
+	data.preds = preds = rcu_dereference_sched(filter->preds);
+	ret = walk_pred_tree(preds, root, filter_match_preds_cb, &data);
+	WARN_ON(ret);
+	return data.match;
 }
 EXPORT_SYMBOL_GPL(filter_match_preds);
 
-- 
1.7.1

