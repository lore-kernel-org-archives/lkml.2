Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756640Ab2DEWsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 18:48:35 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545Ab2DEWsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 18:48:33 -0400
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
Subject: [PATCH 10/15] parse-events: Handle opcode parsing error
Date: Fri,  6 Apr 2012 00:48:01 +0200
Message-Id: <1333666086-6517-11-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
References: <1333666086-6517-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vaibhav Nagarnaik <vnagarnaik@google.com>

If an invalid opcode is encountered in parsing event print format, the
trace-cmd calls exit() without parsing any other events.

This patch adds handling for such an error where the get_op_prio() is
called. If the return value is -1, then the event print format parsing
is skipped and parsing continues.

Cc: Michael Rubin <mrubin@google.com>
Cc: David Sharp <dhsharp@google.com>
Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
Link: http://lkml.kernel.org/r/1311619257-4970-1-git-send-email-vnagarnaik@google.com
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
 tools/lib/traceevent/event-parse.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index ef2c65f..cdb32c7 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1592,7 +1592,7 @@ static int get_op_prio(char *op)
 		case '?':
 			return 16;
 		default:
-			die("unknown op '%c'", op[0]);
+			do_warning("unknown op '%c'", op[0]);
 			return -1;
 		}
 	} else {
@@ -1613,22 +1613,22 @@ static int get_op_prio(char *op)
 		} else if (strcmp(op, "||") == 0) {
 			return 15;
 		} else {
-			die("unknown op '%s'", op);
+			do_warning("unknown op '%s'", op);
 			return -1;
 		}
 	}
 }
 
-static void set_op_prio(struct print_arg *arg)
+static int set_op_prio(struct print_arg *arg)
 {
 
 	/* single ops are the greatest */
-	if (!arg->op.left || arg->op.left->type == PRINT_NULL) {
+	if (!arg->op.left || arg->op.left->type == PRINT_NULL)
 		arg->op.prio = 0;
-		return;
-	}
+	else
+		arg->op.prio = get_op_prio(arg->op.op);
 
-	arg->op.prio = get_op_prio(arg->op.op);
+	return arg->op.prio;
 }
 
 /* Note, *tok does not get freed, but will most likely be saved */
@@ -1710,7 +1710,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->op.op = token;
 		arg->op.left = left;
 
-		set_op_prio(arg);
+		if (set_op_prio(arg) == -1) {
+			event->flags |= EVENT_FL_FAILED;
+			goto out_free;
+		}
 
 		type = read_token_item(&token);
 		*tok = token;
-- 
1.7.5.4

