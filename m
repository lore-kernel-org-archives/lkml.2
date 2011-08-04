Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab1HDKJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 06:09:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753416Ab1HDKIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 06:08:41 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 06/10] tracing/filter: Change count_leafs function to use walk_pred_tree
Date: Thu,  4 Aug 2011 12:08:22 +0200
Message-Id: <1312452506-5100-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
References: <1312452506-5100-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing count_leafs function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 kernel/trace/trace_events_filter.c |   45 +++++++++--------------------------
 1 files changed, 12 insertions(+), 33 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 5b889d4..14a9dad 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1418,43 +1418,22 @@ static int check_pred_tree(struct event_filter *filter,
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
 
+static int count_leafs(struct filter_pred *preds, struct filter_pred *root)
+{
+	int count = 0;
+	WARN_ON(walk_pred_tree(preds, root, count_leafs_cb, &count));
 	return count;
 }
 
-- 
1.7.1

