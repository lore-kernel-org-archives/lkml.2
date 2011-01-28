Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1A1EeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 23:34:17 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33765 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754775Ab1A1Edq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 23:33:46 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=daZEj3UOcoAA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=TnT-oeF1a4GWkS7kZacA:9 a=U4fFQpU4h-oh_f-_NpQA:7 a=JXZ7xv6z4gqFeIDHvsF5vz9bpaMA:4 a=jEp0ucaQiEUA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=XDMctFE3c-7AwwtU:21 a=aXIHvb7uSaJogfFK:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110128043343.744263142@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 27 Jan 2011 23:21:20 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC][PATCH 02/12] tracing/filter: Move OR and AND logic out of fn() method
References: <20110128042118.561146147@goodmis.org>
Content-Disposition: inline; filename=0002-tracing-filter-Move-OR-and-AND-logic-out-of-fn-metho.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The ops OR and AND act different from the other ops, as they
are the only ones to take other ops as their arguements.
These ops als change the logic of the filter_match_preds.

By removing the OR and AND fn's we can also remove the val1 and val2
that is passed to all other fn's and are unused.

Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace.h               |    3 +-
 kernel/trace/trace_events_filter.c |   51 +++++++++++++----------------------
 2 files changed, 20 insertions(+), 34 deletions(-)

diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
index 9021f8c..1597bc0 100644
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -677,8 +677,7 @@ struct event_subsystem {
 struct filter_pred;
 struct regex;
 
-typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event,
-				 int val1, int val2);
+typedef int (*filter_pred_fn_t) (struct filter_pred *pred, void *event);
 
 typedef int (*regex_match_func)(char *str, struct regex *r, int len);
 
diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 7275f03..5d719b3 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -124,8 +124,7 @@ struct filter_parse_state {
 };
 
 #define DEFINE_COMPARISON_PRED(type)					\
-static int filter_pred_##type(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
+static int filter_pred_##type(struct filter_pred *pred, void *event)	\
 {									\
 	type *addr = (type *)(event + pred->offset);			\
 	type val = (type)pred->val;					\
@@ -152,8 +151,7 @@ static int filter_pred_##type(struct filter_pred *pred, void *event,	\
 }
 
 #define DEFINE_EQUALITY_PRED(size)					\
-static int filter_pred_##size(struct filter_pred *pred, void *event,	\
-			      int val1, int val2)			\
+static int filter_pred_##size(struct filter_pred *pred, void *event)	\
 {									\
 	u##size *addr = (u##size *)(event + pred->offset);		\
 	u##size val = (u##size)pred->val;				\
@@ -178,23 +176,8 @@ DEFINE_EQUALITY_PRED(32);
 DEFINE_EQUALITY_PRED(16);
 DEFINE_EQUALITY_PRED(8);
 
-static int filter_pred_and(struct filter_pred *pred __attribute((unused)),
-			   void *event __attribute((unused)),
-			   int val1, int val2)
-{
-	return val1 && val2;
-}
-
-static int filter_pred_or(struct filter_pred *pred __attribute((unused)),
-			  void *event __attribute((unused)),
-			  int val1, int val2)
-{
-	return val1 || val2;
-}
-
 /* Filter predicate for fixed sized arrays of characters */
-static int filter_pred_string(struct filter_pred *pred, void *event,
-			      int val1, int val2)
+static int filter_pred_string(struct filter_pred *pred, void *event)
 {
 	char *addr = (char *)(event + pred->offset);
 	int cmp, match;
@@ -207,8 +190,7 @@ static int filter_pred_string(struct filter_pred *pred, void *event,
 }
 
 /* Filter predicate for char * pointers */
-static int filter_pred_pchar(struct filter_pred *pred, void *event,
-			     int val1, int val2)
+static int filter_pred_pchar(struct filter_pred *pred, void *event)
 {
 	char **addr = (char **)(event + pred->offset);
 	int cmp, match;
@@ -231,8 +213,7 @@ static int filter_pred_pchar(struct filter_pred *pred, void *event,
  * and add it to the address of the entry, and at last we have
  * the address of the string.
  */
-static int filter_pred_strloc(struct filter_pred *pred, void *event,
-			      int val1, int val2)
+static int filter_pred_strloc(struct filter_pred *pred, void *event)
 {
 	u32 str_item = *(u32 *)(event + pred->offset);
 	int str_loc = str_item & 0xffff;
@@ -247,8 +228,7 @@ static int filter_pred_strloc(struct filter_pred *pred, void *event,
 	return match;
 }
 
-static int filter_pred_none(struct filter_pred *pred, void *event,
-			    int val1, int val2)
+static int filter_pred_none(struct filter_pred *pred, void *event)
 {
 	return 0;
 }
@@ -380,7 +360,7 @@ static void filter_build_regex(struct filter_pred *pred)
 /* return 1 if event matches, 0 otherwise (discard) */
 int filter_match_preds(struct event_filter *filter, void *rec)
 {
-	int match, top = 0, val1 = 0, val2 = 0;
+	int match = -1, top = 0, val1 = 0, val2 = 0;
 	int stack[MAX_FILTER_PRED];
 	struct filter_pred *pred;
 	int n_preds = ACCESS_ONCE(filter->n_preds);
@@ -393,7 +373,7 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 	for (i = 0; i < n_preds; i++) {
 		pred = filter->preds[i];
 		if (!pred->pop_n) {
-			match = pred->fn(pred, rec, val1, val2);
+			match = pred->fn(pred, rec);
 			stack[top++] = match;
 			continue;
 		}
@@ -403,7 +383,16 @@ int filter_match_preds(struct event_filter *filter, void *rec)
 		}
 		val1 = stack[--top];
 		val2 = stack[--top];
-		match = pred->fn(pred, rec, val1, val2);
+		switch (pred->op) {
+		case OP_AND:
+			match = val1 && val2;
+			break;
+		case OP_OR:
+			match = val1 || val2;
+			break;
+		default:
+			WARN_ONCE(1, "filter op is not AND or OR");
+		}
 		stack[top++] = match;
 	}
 
@@ -775,15 +764,13 @@ static int filter_add_pred(struct filter_parse_state *ps,
 	unsigned long long val;
 	int ret;
 
-	pred->fn = filter_pred_none;
+	fn = pred->fn = filter_pred_none;
 
 	if (pred->op == OP_AND) {
 		pred->pop_n = 2;
-		fn = filter_pred_and;
 		goto add_pred_fn;
 	} else if (pred->op == OP_OR) {
 		pred->pop_n = 2;
-		fn = filter_pred_or;
 		goto add_pred_fn;
 	}
 
-- 
1.7.2.3


