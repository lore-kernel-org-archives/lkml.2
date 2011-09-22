Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432Ab1IVWOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 18:14:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:58796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab1IVWK1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 18:10:27 -0400
X-Authority-Analysis: v=1.1 cv=cSzO76bR5tCkfUT9bEmBgR3d7VUusRLeq08eKGxa4EU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=d5zwq4yFBecA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=q_iu5iEAGgpD4jx2qzUA:9 a=dfp8IjMbZrS_kIwK43kA:7 a=DHQQ7jDAcw4A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110922221025.700688680@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 22 Sep 2011 18:09:39 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 04/21] tracing/filter: Use static allocation for filter predicates
References: <20110922220935.537134016@goodmis.org>
Content-Disposition: inline; filename=0004-tracing-filter-Use-static-allocation-for-filter-pred.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Don't dynamically allocate filter_pred struct, use static memory.
This way we can get rid of the code managing the dynamic filter_pred
struct object.

The create_pred function integrates create_logical_pred function.
This way the static predicate memory is returned only from
one place.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/1313072754-4620-2-git-send-email-jolsa@redhat.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events_filter.c |   57 ++++++++++--------------------------
 1 files changed, 16 insertions(+), 41 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index 256764e..cb295a1 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -630,11 +630,7 @@ find_event_field(struct ftrace_event_call *call, char *name)
 
 static void filter_free_pred(struct filter_pred *pred)
 {
-	if (!pred)
-		return;
-
 	kfree(pred->field_name);
-	kfree(pred);
 }
 
 static void filter_clear_pred(struct filter_pred *pred)
@@ -1302,39 +1298,30 @@ parse_operand:
 	return 0;
 }
 
-static struct filter_pred *create_pred(int op, char *operand1, char *operand2)
+static struct filter_pred *create_pred(struct filter_parse_state *ps,
+				       int op, char *operand1, char *operand2)
 {
-	struct filter_pred *pred;
+	static struct filter_pred pred;
 
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
-		return NULL;
+	memset(&pred, 0, sizeof(pred));
+	pred.op = op;
 
-	pred->field_name = kstrdup(operand1, GFP_KERNEL);
-	if (!pred->field_name) {
-		kfree(pred);
+	if (op == OP_AND || op == OP_OR)
+		return &pred;
+
+	if (!operand1 || !operand2) {
+		parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
 		return NULL;
 	}
 
-	strcpy(pred->regex.pattern, operand2);
-	pred->regex.len = strlen(pred->regex.pattern);
-
-	pred->op = op;
-
-	return pred;
-}
-
-static struct filter_pred *create_logical_pred(int op)
-{
-	struct filter_pred *pred;
-
-	pred = kzalloc(sizeof(*pred), GFP_KERNEL);
-	if (!pred)
+	pred.field_name = kstrdup(operand1, GFP_KERNEL);
+	if (!pred.field_name)
 		return NULL;
 
-	pred->op = op;
+	strcpy(pred.regex.pattern, operand2);
+	pred.regex.len = strlen(pred.regex.pattern);
 
-	return pred;
+	return &pred;
 }
 
 static int check_preds(struct filter_parse_state *ps)
@@ -1643,19 +1630,7 @@ static int replace_preds(struct ftrace_event_call *call,
 			goto fail;
 		}
 
-		if (elt->op == OP_AND || elt->op == OP_OR) {
-			pred = create_logical_pred(elt->op);
-			goto add_pred;
-		}
-
-		if (!operand1 || !operand2) {
-			parse_error(ps, FILT_ERR_MISSING_FIELD, 0);
-			err = -EINVAL;
-			goto fail;
-		}
-
-		pred = create_pred(elt->op, operand1, operand2);
-add_pred:
+		pred = create_pred(ps, elt->op, operand1, operand2);
 		if (!pred) {
 			err = -ENOMEM;
 			goto fail;
-- 
1.7.5.4


