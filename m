Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751455Ab2FLHpy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 03:45:54 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45976 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab2FLHpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 03:45:47 -0400
X-AuditID: 9c930179-b7bb9ae000000ea5-99-4fd6f3aa4e0e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/3] tools lib traceevent: Do not link broken field arg for an old ftrace event
Date: Tue, 12 Jun 2012 16:42:37 +0900
Message-Id: <1339486959-25241-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
References: <1339486959-25241-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Defer linking a newly allocated arg to print_fmt.args until
all of its field is setup so that later access to ->field.name
cannot be NULL.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index a6b5bcdc5580..7fcfdf9e2716 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -4665,20 +4665,20 @@ int pevent_parse_event(struct pevent *pevent,
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

