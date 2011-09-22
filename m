Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab1IVWNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:13:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:33361 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab1IVWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:30 -0400
X-Authority-Analysis: v=1.1 cv=XWD5/VRj2HUJOhsR8cgmvPBlhMACpZXxseY1Kn/ehQI= c=1 sm=0 a=vhdKIqpQuCYA:10 a=tA-7VsIX8roA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=k6WyHbhKYv5p59E922cA:9 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221027.749894055@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 11/21] tracing/filter: Change fold_pred function to use walk_pred_tree
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0011-tracing-filter-Change-fold_pred-function-to-use-walk.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Changing fold_pred_tree function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-9-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.7.5.4


