Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab2EUJjn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:39:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38891 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab2EUJjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:39:42 -0400
Date: Mon, 21 May 2012 02:39:00 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-d69afed55be1016c2bcfcb3e00cd5365d2f557f6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, vnagarnaik@google.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, dhsharp@google.com,
        namhyung.kim@lge.com, bp@alien8.de, jolsa@redhat.com,
        fweisbec@gmail.com, acme@infradead.org, mrubin@google.com,
        rostedt@goodmis.org, tglx@linutronix.de, asharma@fb.com
Reply-To: mingo@kernel.org, hpa@zytor.com, vnagarnaik@google.com,
        linux-kernel@vger.kernel.org, dhsharp@google.com, peterz@infradead.org,
        namhyung.kim@lge.com, bp@alien8.de, jolsa@redhat.com,
        fweisbec@gmail.com, rostedt@goodmis.org, acme@infradead.org,
        mrubin@google.com, tglx@linutronix.de, asharma@fb.com
In-Reply-To: <1310785241-3799-2-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-2-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] parse-events:
  Handle invalid opcode parsing gracefully
Git-Commit-ID: d69afed55be1016c2bcfcb3e00cd5365d2f557f6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:39:07 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d69afed55be1016c2bcfcb3e00cd5365d2f557f6
Gitweb:     http://git.kernel.org/tip/d69afed55be1016c2bcfcb3e00cd5365d2f557f6
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Fri, 6 Apr 2012 00:48:00 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 25 Apr 2012 13:35:28 +0200

parse-events: Handle invalid opcode parsing gracefully

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
