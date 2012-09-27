Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503Ab2I0Fhr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 01:37:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54094 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab2I0Fho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 01:37:44 -0400
Date: Wed, 26 Sep 2012 22:37:26 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-41e51a289b3ca83e08395213f4488c9c7c6b2e29@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1348037924-17568-3-git-send-email-namhyung@kernel.org>
References: <1348037924-17568-3-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Make sure that arg->op.
 right is set properly
Git-Commit-ID: 41e51a289b3ca83e08395213f4488c9c7c6b2e29
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 26 Sep 2012 22:37:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  41e51a289b3ca83e08395213f4488c9c7c6b2e29
Gitweb:     http://git.kernel.org/tip/41e51a289b3ca83e08395213f4488c9c7c6b2e29
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 19 Sep 2012 15:58:42 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Sep 2012 12:01:21 -0300

tools lib traceevent: Make sure that arg->op.right is set properly

When process_op failed, @arg will be freed on a caller with type of
PRINT_OP.  Thus free_arg() will try to free ->op.right field which can
have stale value if something bad happens in the middle.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1348037924-17568-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 6270ee2..27088c5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1719,6 +1719,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->op.left = left;
 		arg->op.prio = 0;
 
+		/* it will set arg->op.right */
 		type = process_cond(event, arg, tok);
 
 	} else if (strcmp(token, ">>") == 0 ||
@@ -1745,6 +1746,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 		arg->type = PRINT_OP;
 		arg->op.op = token;
 		arg->op.left = left;
+		arg->op.right = NULL;
 
 		if (set_op_prio(arg) == -1) {
 			event->flags |= EVENT_FL_FAILED;
@@ -1792,6 +1794,7 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		arg->op.prio = 0;
 
+		/* it will set arg->op.right */
 		type = process_array(event, arg, tok);
 
 	} else {
