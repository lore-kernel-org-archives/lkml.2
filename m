Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1HDKKX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:10:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33026 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753430Ab1HDKIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:08:43 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 07/10] tracing/filter: Change fold_pred_tree function to use walk_pred_tree
Date: Thu,  4 Aug 2011 12:08:23 +0200
Message-Id: <1312452506-5100-8-git-send-email-jolsa@redhat.com>
In-Reply-To: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
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
index 14a9dad..ebe13cc 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1494,6 +1494,24 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
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
@@ -1502,51 +1520,8 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
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

