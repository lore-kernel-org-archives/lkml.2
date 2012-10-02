Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752232Ab2JBAOF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:14:05 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31307 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204Ab2JBANx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:13:53 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=xeowkCQj3JcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=8TvKTV2g7BAA:10 a=VwQbUJbxAAAA:8 a=LFh7HCCk25KrJYzcJ_EA:9 a=PUjeQqilurYA:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349136831.22822.133.camel@gandalf.local.home>
Subject: [PATCH v2] lib tools traceevent: Add back pevent assignment in
 __pevent_parse_format()
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>
Date: Mon, 01 Oct 2012 20:13:51 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even though with the change of commit commit 2b29175 "tools lib traceevent:
Carve out events format parsing routine", allowed __pevent_parse_format() to
parse an event without the need of a pevent handler, the event still needs to
assign the pevent handed to it.

There's no problem with assigning it if the pevent is NULL, as the event->pevent
would be NULL without the assignment. But function parsing handlers may be
assigned to the pevent handler to help in parsing the event. If there's no
pevent then there would not be any function handlers, but if the pevent
isn't assigned first before parsing the event, it wont honor the function
handlers that were assigned.

Worse yet, the current code crashes if an event has a function that it tries
to parse. For example:

 # perf record -e scsi:scsi_dispatch_cmd_timeout
 Segmentation fault (core dumped)

This happens because the scsi_dispatch_cmd_timeout event format has the following:

  scsi_trace_parse_cdb(p, __get_dynamic_array(cmnd), REC->cmd_len)

which hasn't been defined by the pevent code.

Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>


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




