Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1GPDBe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 23:01:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:6862 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1GPDAy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 23:00:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=jyoI9fSMwh9MLgUIZ5i/S2IIuiqxJt3MWd1SLVHjRFSpLH8Jd9S+8CmcJi/hpmDs3
	COdRCk3W6NH9Idx3aR2kQ==
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org,
        Vaibhav Nagarnaik <vnagarnaik@google.com>
Subject: [PATCH 3/4] trace-cmd: Handle opcode parsing error
Date: Fri, 15 Jul 2011 20:00:40 -0700
Message-Id: <1310785241-3799-3-git-send-email-vnagarnaik@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
References: <1310785241-3799-1-git-send-email-vnagarnaik@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If an invalid opcode is encountered in parsing event print format, the
trace-cmd calls exit() without parsing any other events.

This patch adds handling for such an error where the get_op_prio() is
called. If the return value is -1, then the event print format parsing
is skipped and parsing continues.

Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
---
 parse-events.c |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/parse-events.c b/parse-events.c
index 58ffe51..068c77f 100644
--- a/parse-events.c
+++ b/parse-events.c
@@ -1588,7 +1588,7 @@ static int get_op_prio(char *op)
 		case '?':
 			return 16;
 		default:
-			die("unknown op '%c'", op[0]);
+			do_warning("unknown op '%c'", op[0]);
 			return -1;
 		}
 	} else {
@@ -1609,22 +1609,22 @@ static int get_op_prio(char *op)
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
@@ -1706,7 +1706,10 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->op.op = token;
 		arg->op.left = left;
 
-		set_op_prio(arg);
+		if (-1 == set_op_prio(arg)) {
+			event->flags |= EVENT_FL_FAILED;
+			goto out_free;
+		}
 
 		type = read_token_item(&token);
 		*tok = token;
-- 
1.7.3.1

