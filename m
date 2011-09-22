Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1IVWNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:13:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64760 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754224Ab1IVWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:30 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=KnzTBHU2GMQA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=U7k50tahjhb5x0etHIYA:9 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221027.487154021@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:45 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 10/21] tracing/filter: Change fold_pred_tree function to use walk_pred_tree
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0010-tracing-filter-Change-fold_pred_tree-function-to-use.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Changing fold_pred_tree function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-8-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   65 +++++++++++-------------------------
 1 files changed, 20 insertions(+), 45 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index ebbb261..d8aa100 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1496,6 +1496,24 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 	return 0;
 }
 
+static int fold_pred_tree_cb(enum move_type move, struct filter_pred *pred,
+			     int *err, void *data)
+{
+	struct filter_pred *preds = data;
+
+	if (move != MOVE_DOWN)
+		return WALK_PRED_DEFAULT;
+	if (!(pred->index & FILTER_PRED_FOLD))
+		return WALK_PRED_DEFAULT;
+
+	*err = fold_pred(preds, pred);
+	if (*err)
+		return WALK_PRED_ABORT;
+
+	/* eveyrhing below is folded, continue with parent */
+	return WALK_PRED_PARENT;
+}
+
 /*
  * To optimize the processing of the ops, if we have several "ors" or
  * "ands" together, we can put them in an array and process them all
@@ -1504,51 +1522,8 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 static int fold_pred_tree(struct event_filter *filter,
 			   struct filter_pred *root)
 {
-	struct filter_pred *preds;
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int done = 0;
-	int err;
-
-	preds = filter->preds;
-	if  (!preds)
-		return -EINVAL;
-	pred = root;
-
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->index & FILTER_PRED_FOLD) {
-				err = fold_pred(preds, pred);
-				if (err)
-					return err;
-				/* Folded nodes are like leafs */
-			} else if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-
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
-
-	return 0;
+	return walk_pred_tree(filter->preds, root, fold_pred_tree_cb,
+			      filter->preds);
 }
 
 static int replace_preds(struct ftrace_event_call *call,
-- 
1.7.5.4


