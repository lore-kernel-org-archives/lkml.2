Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462Ab2JQRWt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:22:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:46068 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757538Ab2JQRUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:07 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/11] lib tools traceevent: Add back pevent assignment in __pevent_parse_format()
Date: Wed, 17 Oct 2012 14:19:42 -0300
Message-Id: <1350494387-10987-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350494387-10987-1-git-send-email-acme@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

Even though with the change of commit commit 2b29175 "tools lib
traceevent: Carve out events format parsing routine", allowed
__pevent_parse_format() to parse an event without the need of a pevent
handler, the event still needs to assign the pevent handed to it.

There's no problem with assigning it if the pevent is NULL, as the
event->pevent would be NULL without the assignment. But function parsing
handlers may be assigned to the pevent handler to help in parsing the
event. If there's no pevent then there would not be any function
handlers, but if the pevent isn't assigned first before parsing the
event, it wont honor the function handlers that were assigned.

Worse yet, the current code crashes if an event has a function that it
tries to parse. For example:

 # perf record -e scsi:scsi_dispatch_cmd_timeout
 Segmentation fault (core dumped)

This happens because the scsi_dispatch_cmd_timeout event format has the following:

  scsi_trace_parse_cdb(p, __get_dynamic_array(cmnd), REC->cmd_len)

which hasn't been defined by the pevent code.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1349136831.22822.133.camel@gandalf.local.home
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 47264b4..f2989c5 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -2602,6 +2602,9 @@ find_func_handler(struct pevent *pevent, char *func_name)
 {
 	struct pevent_function_handler *func;
 
+	if (!pevent)
+		return NULL;
+
 	for (func = pevent->func_handlers; func; func = func->next) {
 		if (strcmp(func->name, func_name) == 0)
 			break;
@@ -4938,6 +4941,9 @@ enum pevent_errno __pevent_parse_format(struct event_format **eventp,
 		goto event_alloc_failed;
 	}
 
+	/* Add pevent to event so that it can be referenced */
+	event->pevent = pevent;
+
 	ret = event_read_format(event);
 	if (ret < 0) {
 		ret = PEVENT_ERRNO__READ_FORMAT_FAILED;
@@ -5041,9 +5047,6 @@ enum pevent_errno pevent_parse_event(struct pevent *pevent, const char *buf,
 	if (event == NULL)
 		return ret;
 
-	/* Add pevent to event so that it can be referenced */
-	event->pevent = pevent;
-
 	if (add_event(pevent, event)) {
 		ret = PEVENT_ERRNO__MEM_ALLOC_FAILED;
 		goto event_add_failed;
-- 
1.7.1

