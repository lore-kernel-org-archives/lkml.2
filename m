Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab2IXQAT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58910 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756726Ab2IXQAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 12:00:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 30/30] tools lib traceevent: Handle alloc_arg failure
Date: Mon, 24 Sep 2012 12:59:44 -0300
Message-Id: <1348502384-14442-31-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Now alloc_arg returns NULL if memory allocation failed, it should be
handled on callsites properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/87k3vpzbqo.fsf_-_@sejong.aot.lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   97 +++++++++++++++++++++++++++++++++++-
 1 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 1fa71ca..17c9221 100644
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
@@ -1725,10 +1739,16 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		/* make an empty left */
 		left = alloc_arg();
+		if (!left)
+			goto out_warn_free;
+
 		left->type = PRINT_NULL;
 		arg->op.left = left;
 
 		right = alloc_arg();
+		if (!right)
+			goto out_warn_free;
+
 		arg->op.right = right;
 
 		/* do not free the token, it belongs to an op */
@@ -1738,6 +1758,9 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 	} else if (strcmp(token, "?") == 0) {
 
 		left = alloc_arg();
+		if (!left)
+			goto out_warn_free;
+
 		/* copy the top arg to the left */
 		*left = *arg;
 
@@ -1766,6 +1789,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		   strcmp(token, "!=") == 0) {
 
 		left = alloc_arg();
+		if (!left)
+			goto out_warn_free;
 
 		/* copy the top arg to the left */
 		*left = *arg;
@@ -1797,7 +1822,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 			new_atom = realloc(left->atom.atom,
 					    strlen(left->atom.atom) + 3);
 			if (!new_atom)
-				goto out_free;
+				goto out_warn_free;
 
 			left->atom.atom = new_atom;
 			strcat(left->atom.atom, " *");
@@ -1809,12 +1834,18 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		}
 
 		right = alloc_arg();
+		if (!right)
+			goto out_warn_free;
+
 		type = process_arg_token(event, right, tok, type);
 		arg->op.right = right;
 
 	} else if (strcmp(token, "[") == 0) {
 
 		left = alloc_arg();
+		if (!left)
+			goto out_warn_free;
+
 		*left = *arg;
 
 		arg->type = PRINT_OP;
@@ -1847,7 +1878,9 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 	return type;
 
- out_free:
+out_warn_free:
+	do_warning("%s: not enough memory!", __func__);
+out_free:
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
@@ -2203,6 +2236,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 			break;
 
 		arg = alloc_arg();
+		if (!arg)
+			goto out_free;
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
@@ -2229,6 +2264,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
 		free_arg(arg);
 		arg = alloc_arg();
+		if (!arg)
+			goto out_free;
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
@@ -2275,6 +2312,10 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_FLAGS;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
 
 	type = process_arg(event, field, &token);
 
@@ -2324,6 +2365,10 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_SYMBOL;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
 
 	type = process_arg(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
@@ -2358,6 +2403,11 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_HEX;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
+
 	type = process_arg(event, field, &token);
 
 	if (test_type_token(type, token, EVENT_DELIM, ","))
@@ -2368,6 +2418,12 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -2425,6 +2481,12 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
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
@@ -2484,6 +2546,10 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 		}
 
 		item_arg = alloc_arg();
+		if (!item_arg) {
+			do_warning("%s: not enough memory!", __func__);
+			goto out_free;
+		}
 
 		arg->type = PRINT_TYPE;
 		arg->typecast.type = arg->atom.atom;
@@ -2579,6 +2645,11 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
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
@@ -2745,6 +2816,10 @@ static int event_read_print_args(struct event_format *event, struct print_arg **
 		}
 
 		arg = alloc_arg();
+		if (!arg) {
+			do_warning("%s: not enough memory!", __func__);
+			return -1;
+		}
 
 		type = process_arg(event, arg, &token);
 
@@ -3643,6 +3718,10 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -3705,6 +3784,11 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -3723,6 +3807,11 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -4878,6 +4967,10 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
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
1.7.1

