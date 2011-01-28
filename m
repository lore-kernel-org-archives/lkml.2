Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab1A1Efq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:35:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:39587 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759Ab1A1Edq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:46 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=_6aBUSDAFCUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=T95tj1QEYI_1pf1I49oA:9 a=_LEZHOjlcTPR13X2uNYA:7 a=_a41G6uayJ1s0w_soEKV4vqXWkIA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043345.498506954@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:27 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 09/12] tracing/filter: Check the created pred tree
References: <20110128042118.561146147@goodmis.org>
Content-Disposition: inline; filename=0009-tracing-filter-Check-the-created-pred-tree.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Since the filter walks a tree to determine if a match is made or not,
if the tree was incorrectly created, it could cause an infinite loop.

Add a check to walk the entire tree before assigning it as a filter
to make sure the tree is correct.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   72 +++++++++++++++++++++++++++++++++++-
 1 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index afe59ab..47e9430 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1359,6 +1359,68 @@ static int count_preds(struct filter_parse_state *ps)
 	return n_preds;
 }
 
+/*
+ * The tree is walked at filtering of an event. If the tree is not correctly
+ * built, it may cause an infinite loop. Check here that the tree does
+ * indeed terminate.
+ */
+static int check_pred_tree(struct event_filter *filter,
+			   struct filter_pred *root)
+{
+	struct filter_pred *preds;
+	struct filter_pred *pred;
+	enum move_type move = MOVE_DOWN;
+	int count = 0;
+	int done = 0;
+	int max;
+
+	/*
+	 * The max that we can hit a node is three times.
+	 * Once going down, once coming up from left, and
+	 * once coming up from right. This is more than enough
+	 * since leafs are only hit a single time.
+	 */
+	max = 3 * filter->n_preds;
+
+	preds = filter->preds;
+	if  (!preds)
+		return -EINVAL;
+	pred = root;
+
+	do {
+		if (WARN_ON(count++ > max))
+			return -EINVAL;
+
+		switch (move) {
+		case MOVE_DOWN:
+			if (pred->left != FILTER_PRED_INVALID) {
+				pred = &preds[pred->left];
+				continue;
+			}
+			/* A leaf at the root is just a leaf in the tree */
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		case MOVE_UP_FROM_LEFT:
+			pred = &preds[pred->right];
+			move = MOVE_DOWN;
+			continue;
+		case MOVE_UP_FROM_RIGHT:
+			if (pred == root)
+				break;
+			pred = get_pred_parent(pred, preds,
+					       pred->parent, &move);
+			continue;
+		}
+		done = 1;
+	} while (!done);
+
+	/* We are fine. */
+	return 0;
+}
+
 static int replace_preds(struct ftrace_event_call *call,
 			 struct event_filter *filter,
 			 struct filter_parse_state *ps,
@@ -1367,6 +1429,7 @@ static int replace_preds(struct ftrace_event_call *call,
 {
 	char *operand1 = NULL, *operand2 = NULL;
 	struct filter_pred *pred;
+	struct filter_pred *root;
 	struct postfix_elt *elt;
 	struct pred_stack stack = { }; /* init to NULL */
 	int err;
@@ -1443,7 +1506,7 @@ add_pred:
 		if (!pred)
 			return -EINVAL;
 		/* This item is where we start from in matching */
-		filter->root = pred;
+		root = pred;
 		/* Make sure the stack is empty */
 		pred = __pop_pred_stack(&stack);
 		if (WARN_ON(pred)) {
@@ -1451,6 +1514,13 @@ add_pred:
 			filter->root = NULL;
 			goto fail;
 		}
+		err = check_pred_tree(filter, root);
+		if (err)
+			goto fail;
+
+		/* We don't set root until we know it works */
+		barrier();
+		filter->root = root;
 	}
 
 	err = 0;
-- 
1.7.2.3


