Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab2EUJkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 05:40:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38919 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2EUJkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 05:40:20 -0400
Date: Mon, 21 May 2012 02:39:51 -0700
From: tip-bot for Vaibhav Nagarnaik <vnagarnaik@google.com>
Message-ID: <tip-14ffde0e966efab6724e2de3ab470b78d4e01109@git.kernel.org>
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
In-Reply-To: <1311619257-4970-1-git-send-email-vnagarnaik@google.com>
References: <1311619257-4970-1-git-send-email-vnagarnaik@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] parse-events: Handle opcode parsing error
Git-Commit-ID: 14ffde0e966efab6724e2de3ab470b78d4e01109
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 21 May 2012 02:39:57 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  14ffde0e966efab6724e2de3ab470b78d4e01109
Gitweb:     http://git.kernel.org/tip/14ffde0e966efab6724e2de3ab470b78d4e01109
Author:     Vaibhav Nagarnaik <vnagarnaik@google.com>
AuthorDate: Fri, 6 Apr 2012 00:48:01 +0200
Committer:  Frederic Weisbecker <fweisbec@gmail.com>
CommitDate: Wed, 25 Apr 2012 13:35:32 +0200

parse-events: Handle opcode parsing error

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
