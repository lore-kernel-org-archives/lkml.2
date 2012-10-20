Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933222Ab2JTBAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:00:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36204 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755755Ab2JTBAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:00:47 -0400
Date: Fri, 19 Oct 2012 18:00:28 -0700
From: tip-bot for Steven Rostedt <rostedt@goodmis.org>
Message-ID: <tip-101782ea2c6984cf169631c59df76b8497899caf@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, rostedt@goodmis.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1349136831.22822.133.camel@gandalf.local.home>
References: <1349136831.22822.133.camel@gandalf.local.home>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] lib tools traceevent:
  Add back pevent assignment in __pevent_parse_format()
Git-Commit-ID: 101782ea2c6984cf169631c59df76b8497899caf
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 19 Oct 2012 18:00:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  101782ea2c6984cf169631c59df76b8497899caf
Gitweb:     http://git.kernel.org/tip/101782ea2c6984cf169631c59df76b8497899caf
Author:     Steven Rostedt <rostedt@goodmis.org>
AuthorDate: Mon, 1 Oct 2012 20:13:51 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 16 Oct 2012 13:06:36 -0300

lib tools traceevent: Add back pevent assignment in __pevent_parse_format()

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
