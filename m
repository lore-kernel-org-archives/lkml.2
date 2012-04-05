Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab2DEWuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:50:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583Ab2DEWsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:48:32 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Vaibhav Nagarnaik <vnagarnaik@google.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Arun Sharma <asharma@fb.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 09/15] parse-events: Handle invalid opcode parsing gracefully
Date: Fri,  6 Apr 2012 00:48:00 +0200
Message-Id: <1333666086-6517-10-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

If an invalid opcode is encountered, trace-cmd exits with an error.
Instead it can be treated as a soft error where the event's print format
is not parsed and its binary data is dumped out.

This patch adds a return value to arg_num_eval() function to indicate if
the parsing was successful. If not, then the error is considered soft
and the parsing of the offending event fails.

Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Link: http://lkml.kernel.org/r/1310785241-3799-2-git-send-email-vnagarnaik@google.com
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arun Sharma <asharma@fb.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/lib/traceevent/event-parse.c |  125 ++++++++++++++++++++++++------------
 1 files changed, 83 insertions(+), 42 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 16da20c..ef2c65f 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1915,90 +1915,120 @@ eval_type(unsigned long long val, struct print_arg *arg, int pointer)
 	return eval_type_str(val, arg->typecast.type, pointer);
 }
 
-static long long arg_num_eval(struct print_arg *arg)
+static int arg_num_eval(struct print_arg *arg, long long *val)
 {
 	long long left, right;
-	long long val = 0;
+	int ret = 1;
 
 	switch (arg->type) {
 	case PRINT_ATOM:
-		val = strtoll(arg->atom.atom, NULL, 0);
+		*val = strtoll(arg->atom.atom, NULL, 0);
 		break;
 	case PRINT_TYPE:
-		val = arg_num_eval(arg->typecast.item);
-		val = eval_type(val, arg, 0);
+		ret = arg_num_eval(arg->typecast.item, val);
+		if (!ret)
+			break;
+		*val = eval_type(*val, arg, 0);
 		break;
 	case PRINT_OP:
 		switch (arg->op.op[0]) {
 		case '|':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
+			ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
 			if (arg->op.op[1])
-				val = left || right;
+				*val = left || right;
 			else
-				val = left | right;
+				*val = left | right;
 			break;
 		case '&':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
+			ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
 			if (arg->op.op[1])
-				val = left && right;
+				*val = left && right;
 			else
-				val = left & right;
+				*val = left & right;
 			break;
 		case '<':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
+			ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
 			switch (arg->op.op[1]) {
 			case 0:
-				val = left < right;
+				*val = left < right;
 				break;
 			case '<':
-				val = left << right;
+				*val = left << right;
 				break;
 			case '=':
-				val = left <= right;
+				*val = left <= right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				do_warning("unknown op '%s'", arg->op.op);
+				ret = 0;
 			}
 			break;
 		case '>':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
+			ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
 			switch (arg->op.op[1]) {
 			case 0:
-				val = left > right;
+				*val = left > right;
 				break;
 			case '>':
-				val = left >> right;
+				*val = left >> right;
 				break;
 			case '=':
-				val = left >= right;
+				*val = left >= right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				do_warning("unknown op '%s'", arg->op.op);
+				ret = 0;
 			}
 			break;
 		case '=':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-
-			if (arg->op.op[1] != '=')
-				die("unknown op '%s'", arg->op.op);
+			ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
 
-			val = left == right;
+			if (arg->op.op[1] != '=') {
+				do_warning("unknown op '%s'", arg->op.op);
+				ret = 0;
+			} else
+				*val = left == right;
 			break;
 		case '!':
-			left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
+			ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
 
 			switch (arg->op.op[1]) {
 			case '=':
-				val = left != right;
+				*val = left != right;
 				break;
 			default:
-				die("unknown op '%s'", arg->op.op);
+				do_warning("unknown op '%s'", arg->op.op);
+				ret = 0;
 			}
 			break;
 		case '-':
@@ -2006,12 +2036,17 @@ static long long arg_num_eval(struct print_arg *arg)
 			if (arg->op.left->type == PRINT_NULL)
 				left = 0;
 			else
-				left = arg_num_eval(arg->op.left);
-			right = arg_num_eval(arg->op.right);
-			val = left - right;
+				ret = arg_num_eval(arg->op.left, &left);
+			if (!ret)
+				break;
+			ret = arg_num_eval(arg->op.right, &right);
+			if (!ret)
+				break;
+			*val = left - right;
 			break;
 		default:
-			die("unknown op '%s'", arg->op.op);
+			do_warning("unknown op '%s'", arg->op.op);
+			ret = 0;
 		}
 		break;
 
@@ -2020,10 +2055,11 @@ static long long arg_num_eval(struct print_arg *arg)
 	case PRINT_STRING:
 	case PRINT_BSTRING:
 	default:
-		die("invalid eval type %d", arg->type);
+		do_warning("invalid eval type %d", arg->type);
+		ret = 0;
 
 	}
-	return val;
+	return ret;
 }
 
 static char *arg_eval (struct print_arg *arg)
@@ -2037,7 +2073,8 @@ static char *arg_eval (struct print_arg *arg)
 	case PRINT_TYPE:
 		return arg_eval(arg->typecast.item);
 	case PRINT_OP:
-		val = arg_num_eval(arg);
+		if (!arg_num_eval(arg, &val))
+			break;
 		sprintf(buf, "%lld", val);
 		return buf;
 
@@ -2079,6 +2116,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 		memset(field, 0, sizeof(*field));
 
 		value = arg_eval(arg);
+		if (value == NULL)
+			goto out_free;
 		field->value = strdup(value);
 
 		free_arg(arg);
@@ -2090,6 +2129,8 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 			goto out_free;
 
 		value = arg_eval(arg);
+		if (value == NULL)
+			goto out_free;
 		field->str = strdup(value);
 		free_arg(arg);
 		arg = NULL;
-- 
1.7.5.4

