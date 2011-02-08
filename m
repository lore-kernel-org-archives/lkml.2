Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1BHCCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 21:02:03 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:63135 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753396Ab1BHB7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 20:59:33 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=LC-rPN6VzX4A:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=T0OsvqmUa6F8bUltBJ8A:9 a=WC0TlUhZxC6kQp3cHuEA:7 a=z1D7PHnaO09d3KI2Jkx0Qhgr394A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110208015932.832496399@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 20:56:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 08/14] tracing/filter: Optimize short ciruit check
References: <20110208015617.902200587@goodmis.org>
Content-Disposition: inline; filename=0008-tracing-filter-Optimize-short-ciruit-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The test if we should break out early for OR and AND operations
can be optimized by comparing the current result with
  (pred->op == OP_OR)

That is if the result is true and the op is an OP_OR, or
if the result is false and the op is not an OP_OR (thus an OP_AND)
we can break out early in either case. Otherwise we continue
processing.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 1039049..0a3e050 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -426,9 +426,15 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 					       pred->parent, &move);
 			continue;
 		case MOVE_UP_FROM_LEFT:
-			/* Check for short circuits */
-			if ((match && pred->op == OP_OR) ||
-			    (!match && pred->op == OP_AND)) {
+			/*
+			 * Check for short circuits.
+			 *
+			 * Optimization: !!match == (pred->op == OP_OR)
+			 *   is the same as:
+			 * if ((match && pred->op == OP_OR) ||
+			 *     (!match && pred->op == OP_AND))
+			 */
+			if (!!match == (pred->op == OP_OR)) {
 				if (pred == root)
 					break;
 				pred = get_pred_parent(pred, preds,
-- 
1.7.2.3


