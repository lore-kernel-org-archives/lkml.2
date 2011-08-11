Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657Ab1HKO0T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:26:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752566Ab1HKO0R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:17 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 06/10] tracing/filter: Change count_leafs function to use walk_pred_tree
Date: Thu, 11 Aug 2011 16:25:50 +0200
Message-Id: <1313072754-4620-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
 <1313072754-4620-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing count_leafs function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_events_filter.c |   47 ++++++++++-------------------------
 1 files changed, 14 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 5b889d4..ebbb261 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1418,43 +1418,24 @@ static int check_pred_tree(struct event_filter *filter,
 			      check_pred_tree_cb, &data);
 }
 
-static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
+static int count_leafs_cb(enum move_type move, struct filter_pred *pred,
+			  int *err, void *data)
 {
-	struct filter_pred *pred;
-	enum move_type move = MOVE_DOWN;
-	int count = 0;
-	int done = 0;
+	int *count = data;
 
-	pred = root;
+	if ((move == MOVE_DOWN) &&
+	    (pred->left == FILTER_PRED_INVALID))
+		(*count)++;
 
-	do {
-		switch (move) {
-		case MOVE_DOWN:
-			if (pred->left != FILTER_PRED_INVALID) {
-				pred = &preds[pred->left];
-				continue;
-			}
-			/* A leaf at the root is just a leaf in the tree */
-			if (pred == root)
-				return 1;
-			count++;
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
+	return WALK_PRED_DEFAULT;
+}
+
+static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
+{
+	int count = 0, ret;
 
+	ret = walk_pred_tree(preds, root, count_leafs_cb, &count);
+	WARN_ON(ret);
 	return count;
 }
 
-- 
1.7.1

