Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab1HKO0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54289 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752619Ab1HKO0T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:19 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 07/10] tracing/filter: Change fold_pred_tree function to use walk_pred_tree
Date: Thu, 11 Aug 2011 16:25:51 +0200
Message-Id: <1313072754-4620-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
 <1313072754-4620-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing fold_pred_tree function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.1

