Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab2ISHHw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 03:07:52 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:47869 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab2ISHHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 03:07:23 -0400
X-AuditID: 9c93016f-b7c19ae000000e6d-5c-50596f29aaa9
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 2/4] tools lib traceevent: Make sure that arg->op.right is set properly
Date: Wed, 19 Sep 2012 15:58:42 +0900
Message-Id: <1348037924-17568-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1348037924-17568-1-git-send-email-namhyung@kernel.org>
References: <1348037924-17568-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When process_op failed, @arg will be freed on a caller with type of
PRINT_OP.  Thus free_arg() will try to free ->op.right field which can
have stale value if something bad happens in the middle.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 11f76a59711f..bc4e70e3ba29 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1772,6 +1772,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->op.left = left;
 		arg->op.prio = 0;
 
+		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
 
 	} else if (strcmp(token, ">>") == 0 ||
@@ -1802,6 +1803,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->type = PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
+		arg->op.right = NULL;
 
 		if (set_op_prio(arg) == -1) {
 			event->flags |= EVENT_FL_FAILED;
@@ -1859,6 +1861,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		arg->op.prio = 0;
 
+		/* it will set arg->op.right */
 		type = process_array(event, arg, tok);
 
 	} else {
-- 
1.7.11.4

