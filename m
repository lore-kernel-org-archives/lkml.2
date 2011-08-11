Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1HKO00 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720Ab1HKO0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:21 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 08/10] tracing/filter: Change fold_pred function to use walk_pred_tree
Date: Thu, 11 Aug 2011 16:25:52 +0200
Message-Id: <1313072754-4620-9-git-send-email-jolsa@redhat.com>
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
 kernel/trace/trace_events_filter.c |   68 +++++++++++++++++------------------
 1 files changed, 33 insertions(+), 35 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index d8aa100..f44e68b 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1439,13 +1439,40 @@ static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
 	return count;
 }
 
+struct fold_pred_data {
+	struct filter_pred *root;
+	int count;
+	int children;
+};
+
+static int fold_pred_cb(enum move_type move, struct filter_pred *pred,
+			int *err, void *data)
+{
+	struct fold_pred_data *d = data;
+	struct filter_pred *root = d->root;
+
+	if (move != MOVE_DOWN)
+		return WALK_PRED_DEFAULT;
+	if (pred->left != FILTER_PRED_INVALID)
+		return WALK_PRED_DEFAULT;
+
+	if (WARN_ON(d->count == d->children)) {
+		*err = -EINVAL;
+		return WALK_PRED_ABORT;
+	}
+
+	pred->index &= ~FILTER_PRED_FOLD;
+	root->ops[d->count++] = pred->index;
+	return WALK_PRED_DEFAULT;
+}
+
 static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 {
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int count = 0;
+	struct fold_pred_data data = {
+		.root  = root,
+		.count = 0,
+	};
 	int children;
-	int done = 0;
 
 	/* No need to keep the fold flag */
 	root->index &= ~FILTER_PRED_FOLD;
@@ -1463,37 +1490,8 @@ static int fold_pred(struct filter_pred *preds, struct filter_pred *root)
 		return -ENOMEM;
 
 	root->val = children;
-
-	pred = root;
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-			if (WARN_ON(count == children))
-				return -EINVAL;
-			pred->index &= ~FILTER_PRED_FOLD;
-			root->ops[count++] = pred->index;
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
+	data.children = children;
+	return walk_pred_tree(preds, root, fold_pred_cb, &data);
 }
 
 static int fold_pred_tree_cb(enum move_type move, struct filter_pred *pred,
-- 
1.7.1

