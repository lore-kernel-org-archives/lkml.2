Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab1A1EeK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:34:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1A1Edr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:47 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=uJy7hFXrkBQA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=T0OsvqmUa6F8bUltBJ8A:9 a=WC0TlUhZxC6kQp3cHuEA:7 a=z1D7PHnaO09d3KI2Jkx0Qhgr394A:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043345.224997318@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:26 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 08/12] tracing/filter: Optimize short ciruit check
References: <20110128042118.561146147@goodmis.org>
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
index 2677924..afe59ab 100644
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
+			if (!!match == (pred->op == OP_OR))
 				if (pred == root)
 					break;
 				pred = get_pred_parent(pred, preds,
-- 
1.7.2.3


