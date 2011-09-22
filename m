Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab1IVWOM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:14:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754192Ab1IVWK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:28 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=cWIduF2kIvQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=x6-7Sb3SakYLQiTwuisA:9 a=nWnCZfKfUOW5cm9nBjgA:7 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221026.938859110@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 08/21] tracing/filter: Unify predicate tree walking, change check_pred_tree
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-filter-Unify-predicate-tree-walking-change-c.patch
 function to use it
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding walk_pred_tree function to be used for walking throught
the filter predicates.

For each predicate the callback function is called, allowing
users to add their own functionality or customize their way
through the filter predicates.

Changing check_pred_tree function to use walk_pred_tree.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-6-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |  137 ++++++++++++++++++++++-------------
 1 files changed, 86 insertions(+), 51 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 0948905..5b889d4 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -381,6 +381,63 @@ get_pred_parent(struct filter_pred *pred, struct filter_pred *preds,
 	return pred;
 }
 
+enum walk_return {
+	WALK_PRED_ABORT,
+	WALK_PRED_PARENT,
+	WALK_PRED_DEFAULT,
+};
+
+typedef int (*filter_pred_walkcb_t) (enum move_type move,
+				     struct filter_pred *pred,
+				     int *err, void *data);
+
+static int walk_pred_tree(struct filter_pred *preds,
+			  struct filter_pred *root,
+			  filter_pred_walkcb_t cb, void *data)
+{
+	struct filter_pred *pred = root;
+	enum move_type move = MOVE_DOWN;
+	int done = 0;
+
+	if  (!preds)
+		return -EINVAL;
+
+	do {
+		int err = 0, ret;
+
+		ret = cb(move, pred, &err, data);
+		if (ret == WALK_PRED_ABORT)
+			return err;
+		if (ret == WALK_PRED_PARENT)
+			goto get_parent;
+
+		switch (move) {
+		case MOVE_DOWN:
+			if (pred->left != FILTER_PRED_INVALID) {
+				pred = &preds[pred->left];
+				continue;
+			}
+			goto get_parent;
+		case MOVE_UP_FROM_LEFT:
+			pred = &preds[pred->right];
+			move = MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+ get_parent:
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent,
+					       &move);
+			continue;
+		}
+		done = 1;
+	} while (!done);
+
+	/* We are fine. */
+	return 0;
+}
+
 /*
  * A series of AND or ORs where found together. Instead of
  * climbing up and down the tree branches, an array of the
@@ -1321,6 +1378,23 @@ static int count_preds(struct filter_parse_state *ps)
 	return n_preds;
 }
 
+struct check_pred_data {
+	int count;
+	int max;
+};
+
+static int check_pred_tree_cb(enum move_type move, struct filter_pred *pred,
+			      int *err, void *data)
+{
+	struct check_pred_data *d = data;
+
+	if (WARN_ON(d->count++ > d->max)) {
+		*err = -EINVAL;
+		return WALK_PRED_ABORT;
+	}
+	return WALK_PRED_DEFAULT;
+}
+
 /*
  * The tree is walked at filtering of an event. If the tree is not correctly
  * built, it may cause an infinite loop. Check here that the tree does
@@ -1329,58 +1403,19 @@ static int count_preds(struct filter_parse_state *ps)
 static int check_pred_tree(struct event_filter *filter,
 			   struct filter_pred *root)
 {
-	struct filter_pred *preds;
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int count = 0;
-	int done = 0;
-	int max;
-
-	/*
-	 * The max that we can hit a node is three times.
-	 * Once going down, once coming up from left, and
-	 * once coming up from right. This is more than enough
-	 * since leafs are only hit a single time.
-	 */
-	max = 3 * filter->n_preds;
-
-	preds = filter->preds;
-	if  (!preds)
-		return -EINVAL;
-	pred = root;
-
-	do {
-		if (WARN_ON(count++ > max))
-			return -EINVAL;
-
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-			/* A leaf at the root is just a leaf in the tree */
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		case MOVE_UP_FROM_LEFT:
-			pred = &preds[pred->right];
-			move = MOVE_DOWN;
-			continue;
-		case MOVE_UP_FROM_RIGHT:
-			if (pred == root)
-				break;
-			pred = get_pred_parent(pred, preds,
-					       pred->parent, &move);
-			continue;
-		}
-		done = 1;
-	} while (!done);
+	struct check_pred_data data = {
+		/*
+		 * The max that we can hit a node is three times.
+		 * Once going down, once coming up from left, and
+		 * once coming up from right. This is more than enough
+		 * since leafs are only hit a single time.
+		 */
+		.max   = 3 * filter->n_preds,
+		.count = 0,
+	};
 
-	/* We are fine. */
-	return 0;
+	return walk_pred_tree(filter->preds, root,
+			      check_pred_tree_cb, &data);
 }
 
 static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
-- 
1.7.5.4


