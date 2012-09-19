Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab2ISGyH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:54:07 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59752 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2ISGyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:54:02 -0400
X-AuditID: 9c930197-b7b6dae000000e70-ce-50596c08c26c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH] tools lib traceevent: Handle alloc_arg failure
Date: Wed, 19 Sep 2012 15:45:09 +0900
Message-Id: <1348037109-17252-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <87boh23epi.fsf@sejong.aot.lge.com>
References: <87boh23epi.fsf@sejong.aot.lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Now alloc_arg returns NULL if memory allocation failed, it should be
handled on callsites properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 98 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 98 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index e8e0fe0443a4..ee4fa1912542 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1565,6 +1565,14 @@ process_cond(struct event_format *event, struct print_arg *top, char **tok)
 	left = alloc_arg();
 	right = alloc_arg();
 
+	if (!arg || !left || !right) {
+		do_warning("%s: not enough memory!", __func__);
+		/* arg will be freed at out_free */
+		free_arg(left);
+		free_arg(right);
+		goto out_free;
+	}
+
 	arg->type = PRINT_OP;
 	arg->op.left = left;
 	arg->op.right = right;
@@ -1607,6 +1615,12 @@ process_array(struct event_format *event, struct print_arg *top, char **tok)
 	char *token = NULL;
 
 	arg = alloc_arg();
+	if (!arg) {
+		do_warning("%s: not enough memory!", __func__);
+		/* '*tok' is set to top->op.op.  No need to free. */
+		*tok = NULL;
+		return EVENT_ERROR;
+	}
 
 	*tok = NULL;
 	type = process_arg(event, arg, &token);
@@ -1726,10 +1740,18 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		/* make an empty left */
 		left = alloc_arg();
+		if (!left) {
+			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+			goto out_free;
+		}
 		left->type = PRINT_NULL;
 		arg->op.left = left;
 
 		right = alloc_arg();
+		if (!right) {
+			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+			goto out_free;
+		}
 		arg->op.right = right;
 
 		/* do not free the token, it belongs to an op */
@@ -1739,6 +1761,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 	} else if (strcmp(token, "?") == 0) {
 
 		left = alloc_arg();
+		if (!left) {
+			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+			goto out_free;
+		}
 		/* copy the top arg to the left */
 		*left = *arg;
 
@@ -1766,6 +1792,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "!=") == 0) {
 
 		left = alloc_arg();
+		if (!left) {
+			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+			goto out_free;
+		}
 
 		/* copy the top arg to the left */
 		*left = *arg;
@@ -1808,12 +1838,20 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		}
 
 		right = alloc_arg();
+		if (!right) {
+			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+			goto out_free;
+		}
 		type = process_arg_token(event, right, tok, type);
 		arg->op.right = right;
 
 	} else if (strcmp(token, "[") == 0) {
 
 		left = alloc_arg();
+		if (!left) {
+			do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+			goto out_free;
+		}
 		*left = *arg;
 
 		arg->type = PRINT_OP;
@@ -2201,6 +2239,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 			break;
 
 		arg = alloc_arg();
+		if (!arg)
+			goto out_free;
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
@@ -2227,6 +2267,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
 		free_arg(arg);
 		arg = alloc_arg();
+		if (!arg)
+			goto out_free;
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
@@ -2271,6 +2313,10 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_FLAGS;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
 
 	type = process_arg(event, field, &token);
 
@@ -2318,6 +2364,10 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_SYMBOL;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
 
 	type = process_arg(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
@@ -2350,6 +2400,11 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_HEX;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
+
 	type = process_arg(event, field, &token);
 
 	if (test_type_token(type, token, EVENT_DELIM, ","))
@@ -2360,6 +2415,12 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 	free_token(token);
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		*tok = NULL;
+		return EVENT_ERROR;
+	}
+
 	type = process_arg(event, field, &token);
 
 	if (test_type_token(type, token, EVENT_DELIM, ")"))
@@ -2417,6 +2478,12 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
 	free_token(token);
 	arg = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		*tok = NULL;
+		return EVENT_ERROR;
+	}
+
 	type = process_arg(event, arg, &token);
 	if (type == EVENT_ERROR)
 		goto out_free_arg;
@@ -2476,6 +2543,10 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 		}
 
 		item_arg = alloc_arg();
+		if (!item_arg) {
+			do_warning("%s: not enough memory!", __func__);
+			goto out_free;
+		}
 
 		arg->type = PRINT_TYPE;
 		arg->typecast.type = arg->atom.atom;
@@ -2571,6 +2642,11 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
 	next_arg = &(arg->func.args);
 	for (i = 0; i < func->nr_args; i++) {
 		farg = alloc_arg();
+		if (!farg) {
+			do_warning("%s: not enough memory!", __func__);
+			return EVENT_ERROR;
+		}
+
 		type = process_arg(event, farg, &token);
 		if (i < (func->nr_args - 1))
 			test = ",";
@@ -2737,6 +2813,10 @@ static int event_read_print_args(struct event_format *event, struct print_arg **
 		}
 
 		arg = alloc_arg();
+		if (!arg) {
+			do_warning("%s: not enough memory!", __func__);
+			return -1;
+		}
 
 		type = process_arg(event, arg, &token);
 
@@ -3635,6 +3715,10 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 	 * The first arg is the IP pointer.
 	 */
 	args = alloc_arg();
+	if (!args) {
+		do_warning("%s(%d): not enough memory!", __func__, __LINE__);
+		return NULL;
+	}
 	arg = args;
 	arg->next = NULL;
 	next = &arg->next;
@@ -3697,6 +3781,11 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				val = pevent_read_number(pevent, bptr, vsize);
 				bptr += vsize;
 				arg = alloc_arg();
+				if (!arg) {
+					do_warning("%s(%d): not enough memory!",
+						   __func__, __LINE__);
+					goto out_free;
+				}
 				arg->next = NULL;
 				arg->type = PRINT_ATOM;
 				if (asprintf(&arg->atom.atom, "%lld", val) < 0) {
@@ -3715,6 +3804,11 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
 				break;
 			case 's':
 				arg = alloc_arg();
+				if (!arg) {
+					do_warning("%s(%d): not enough memory!",
+						   __func__, __LINE__);
+					goto out_free;
+				}
 				arg->next = NULL;
 				arg->type = PRINT_BSTRING;
 				arg->string.string = strdup(bptr);
@@ -4876,6 +4970,10 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 		list = &event->print_fmt.args;
 		for (field = event->format.fields; field; field = field->next) {
 			arg = alloc_arg();
+			if (!arg) {
+				event->flags |= EVENT_FL_FAILED;
+				return PEVENT_ERRNO__OLD_FTRACE_ARG_FAILED;
+			}
 			arg->type = PRINT_FIELD;
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
-- 
1.7.11.4

