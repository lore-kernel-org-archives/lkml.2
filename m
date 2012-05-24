Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758613Ab2EXRSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:18:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56240 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab2EXRSi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:18:38 -0400
Date: Thu, 24 May 2012 10:18:13 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-d1de10870909a27ce2ac380d0671feb308826491@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, bp@alien8.de,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, bp@alien8.de, namhyung@gmail.com,
        fweisbec@gmail.com, rostedt@goodmis.org, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1337740619-27925-13-git-send-email-namhyung.kim@lge.com>
References: <1337740619-27925-13-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] tools lib traceevent:
  Fix a possibly wrong memory dereference
Git-Commit-ID: d1de10870909a27ce2ac380d0671feb308826491
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 24 May 2012 10:18:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d1de10870909a27ce2ac380d0671feb308826491
Gitweb:     http://git.kernel.org/tip/d1de10870909a27ce2ac380d0671feb308826491
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 23 May 2012 11:36:49 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 May 2012 11:33:34 -0300

tools lib traceevent: Fix a possibly wrong memory dereference

If set_op_prio() failed, the token will be freed at out_free,
then arg->op.op would turn out to be a dangle pointer. After
returning EVENT_ERROR from process_op(), free_arg() will be
called and then it will finally see the dangling pointer.

Cc: Borislav Petkov <bp@alien8.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1337740619-27925-13-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index d598b37..445a43a 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -1715,6 +1715,8 @@ process_op(struct event_format *event, struct print_arg *arg, char **tok)
 
 		if (set_op_prio(arg) == -1) {
 			event->flags |= EVENT_FL_FAILED;
+			/* arg->op.op (= token) will be freed at out_free */
+			arg->op.op = NULL;
 			goto out_free;
 		}
 
