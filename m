Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab2ITCSJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 22:18:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:59049 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753506Ab2ITCSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 22:18:06 -0400
X-AuditID: 9c930197-b7b6dae000000e70-5e-505a7cdbd291
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v2] tools lib traceevent: Handle alloc_arg failure
References: <87boh23epi.fsf@sejong.aot.lge.com>
	<1348037109-17252-1-git-send-email-namhyung@kernel.org>
	<20120919114258.GA16696@gmail.com> <1348057609.1644.9.camel@leonhard>
	<1348058460.13080.52.camel@gandalf.local.home>
	<1348061435.1470.4.camel@leonhard>
Date: Thu, 20 Sep 2012 11:09:19 +0900
In-Reply-To: <1348061435.1470.4.camel@leonhard> (Namhyung Kim's message of
	"Wed, 19 Sep 2012 22:30:35 +0900")
Message-ID: <87k3vpzbqo.fsf_-_@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now alloc_arg returns NULL if memory allocation failed, it should be
handled on callsites properly.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
Hmm.. how about this?  Do you want that the __func__ part also gets removed?

 tools/lib/traceevent/event-parse.c | 97 +++++++++++++++++++++++++++++++++++++-
 1 file changed, 95 insertions(+), 2 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index e8e0fe0443a4..2e3fc5ec9cc6 100644
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
@@ -1726,10 +1740,16 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
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
@@ -1739,6 +1759,9 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -1796,7 +1821,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 			new_atom = realloc(left->atom.atom,
 					    strlen(left->atom.atom) + 3);
 			if (!new_atom)
-				goto out_free;
+				goto out_warn_free;
 
 			left->atom.atom = new_atom;
 			strcat(left->atom.atom, " *");
@@ -1808,12 +1833,18 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -1845,7 +1876,9 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 	return type;
 
- out_free:
+out_warn_free:
+	do_warning("%s: not enough memory!", __func__);
+out_free:
 	free_token(token);
 	*tok = NULL;
 	return EVENT_ERROR;
@@ -2201,6 +2234,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 			break;
 
 		arg = alloc_arg();
+		if (!arg)
+			goto out_free;
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
@@ -2227,6 +2262,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 
 		free_arg(arg);
 		arg = alloc_arg();
+		if (!arg)
+			goto out_free;
 
 		free_token(token);
 		type = process_arg(event, arg, &token);
@@ -2271,6 +2308,10 @@ process_flags(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_FLAGS;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
 
 	type = process_arg(event, field, &token);
 
@@ -2318,6 +2359,10 @@ process_symbols(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_SYMBOL;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
 
 	type = process_arg(event, field, &token);
 	if (test_type_token(type, token, EVENT_DELIM, ","))
@@ -2350,6 +2395,11 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
 	arg->type = PRINT_HEX;
 
 	field = alloc_arg();
+	if (!field) {
+		do_warning("%s: not enough memory!", __func__);
+		goto out_free;
+	}
+
 	type = process_arg(event, field, &token);
 
 	if (test_type_token(type, token, EVENT_DELIM, ","))
@@ -2360,6 +2410,12 @@ process_hex(struct event_format *event, struct print_arg *arg, char **tok)
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
@@ -2417,6 +2473,12 @@ process_dynamic_array(struct event_format *event, struct print_arg *arg, char **
 
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
@@ -2476,6 +2538,10 @@ process_paren(struct event_format *event, struct print_arg *arg, char **tok)
 		}
 
 		item_arg = alloc_arg();
+		if (!item_arg) {
+			do_warning("%s: not enough memory!", __func__);
+			goto out_free;
+		}
 
 		arg->type = PRINT_TYPE;
 		arg->typecast.type = arg->atom.atom;
@@ -2571,6 +2637,11 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
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
@@ -2737,6 +2808,10 @@ static int event_read_print_args(struct event_format *event, struct print_arg **
 		}
 
 		arg = alloc_arg();
+		if (!arg) {
+			do_warning("%s: not enough memory!", __func__);
+			return -1;
+		}
 
 		type = process_arg(event, arg, &token);
 
@@ -3635,6 +3710,10 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -3697,6 +3776,11 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -3715,6 +3799,11 @@ static struct print_arg *make_bprint_args(char *fmt, void *data, int size, struc
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
@@ -4876,6 +4965,10 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
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

