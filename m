Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1HKO2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 10:28:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751509Ab1HKO0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 10:26:03 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCHv2 01/10] tracing/filter: Use static allocation for filter predicates
Date: Thu, 11 Aug 2011 16:25:45 +0200
Message-Id: <1313072754-4620-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1313072754-4620-1-git-send-email-jolsa@redhat.com>
References: <1313011535.18583.280.camel@gandalf.stny.rr.com>
 <1313072754-4620-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't dynamically allocate filter_pred struct, use static memory.
This way we can get rid of the code managing the dynamic filter_pred
struct object.

The create_pred function integrates create_logical_pred function.
This way the static predicate memory is returned only from
one place.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
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
1.7.1

