Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2FRCzj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 22:55:39 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:53084 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753794Ab2FRCyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 22:54:35 -0400
X-AuditID: 9c93016f-b7c35ae00000135b-b0-4fde9868a755
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v2 2/5] tools lib traceevent: Do not link broken field arg for an old ftrace event
Date: Mon, 18 Jun 2012 11:50:48 +0900
Message-Id: <1339987851-22491-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Defer linking a newly allocated arg to print_fmt.args until
all of its field is setup so that later access to ->field.name
cannot be NULL.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/n/tip-7zlkindw0qqqe5h117u59ood@git.kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 4f667fdc5fae..ae172e2ee958 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4658,20 +4658,20 @@ int pevent_parse_event(struct pevent *pevent,
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
-- 
1.7.10.2

