Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2H0Q7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 12:59:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34181 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753773Ab2H0Q7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 12:59:18 -0400
Date: Mon, 27 Aug 2012 09:58:55 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-fd34f0b26c9d0f3c3c5c5f83207efa6324cd19f7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1345618831-9148-2-git-send-email-namhyung@kernel.org>
References: <1345618831-9148-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Do not link broken field arg for an old ftrace event
Git-Commit-ID: fd34f0b26c9d0f3c3c5c5f83207efa6324cd19f7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 27 Aug 2012 09:59:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  fd34f0b26c9d0f3c3c5c5f83207efa6324cd19f7
Gitweb:     http://git.kernel.org/tip/fd34f0b26c9d0f3c3c5c5f83207efa6324cd19f7
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Wed, 22 Aug 2012 16:00:28 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 22 Aug 2012 16:02:36 -0300

tools lib traceevent: Do not link broken field arg for an old ftrace event

Defer linking a newly allocated arg to print_fmt.args until all of its
field is setup so that later access to ->field.name cannot be NULL.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1345618831-9148-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b7c2c49..33fcd94 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4754,20 +4754,20 @@ int pevent_parse_event(struct pevent *pevent,
 		struct print_arg *arg, **list;
 
 		/* old ftrace had no args */
-
 		list = &event->print_fmt.args;
 		for (field = event->format.fields; field; field = field->next) {
 			arg = alloc_arg();
-			*list = arg;
-			list = &arg->next;
 			arg->type = PRINT_FIELD;
 			arg->field.name = strdup(field->name);
 			if (!arg->field.name) {
 				do_warning("failed to allocate field name");
 				event->flags |= EVENT_FL_FAILED;
+				free_arg(arg);
 				return -1;
 			}
 			arg->field.field = field;
+			*list = arg;
+			list = &arg->next;
 		}
 		return 0;
 	}
