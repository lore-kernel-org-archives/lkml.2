Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1IVWNX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:13:23 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:64787 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213Ab1IVWKa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:30 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=vhdKIqpQuCYA:10 a=IS_28s36uuYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=FEx_p1iwbj3s_r-WGeIA:9 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221027.171311939@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 09/21] tracing/filter: Change count_leafs function to use walk_pred_tree
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-filter-Change-count_leafs-function-to-use-wa.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Changing count_leafs function to use unified predicates tree
processing.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-7-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
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
1.7.5.4


