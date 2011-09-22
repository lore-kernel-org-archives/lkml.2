Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab1IVWMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:12:37 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64787 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab1IVWKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:32 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=qognQGKD0RAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=ZLtMC68xly990H2G1H4A:9 a=JL6kCci4qb1n2pGOnEYA:7 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221027.979316599@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 12/21] tracing/filter: Change filter_match_preds function to use
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0012-tracing-filter-Change-filter_match_preds-function-to.patch
 walk_pred_tree
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Changing filter_match_preds function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-10-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.7.5.4


