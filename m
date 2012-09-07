Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699Ab2IGC5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 22:57:09 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57681 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932110Ab2IGC5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 22:57:07 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-f8-50496280cf75
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 1/3] tools lib traceevent: Get rid of die() from pretty_print()
Date: Fri,  7 Sep 2012 11:49:45 +0900
Message-Id: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.4
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

There are three cases that call die() in the pretty_print.

 1. insufficient number of argument: cannot proceed anymore.
 2. too long format conversion specifier: truncate and proceed.
 3. bad size specifier in format string: skip and proceed.

For all cases, convert die to do_warning, mark the event as
EVENT_FL_FAILED and print error message at the last.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/lib/traceevent/event-parse.c | 43 ++++++++++++++++++++++++++++----------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b5b4d806ffa2..6d5e75987a3d 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -3889,8 +3889,11 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 				goto cont_process;
 			case '*':
 				/* The argument is the length. */
-				if (!arg)
-					die("no argument match");
+				if (!arg) {
+					do_warning("no argument match");
+					event->flags |= EVENT_FL_FAILED;
+					goto out_failed;
+				}
 				len_arg = eval_num_arg(data, size, event, arg);
 				len_as_arg = 1;
 				arg = arg->next;
@@ -3923,15 +3926,21 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 			case 'x':
 			case 'X':
 			case 'u':
-				if (!arg)
-					die("no argument match");
+				if (!arg) {
+					do_warning("no argument match");
+					event->flags |= EVENT_FL_FAILED;
+					goto out_failed;
+				}
 
 				len = ((unsigned long)ptr + 1) -
 					(unsigned long)saveptr;
 
 				/* should never happen */
-				if (len > 31)
-					die("bad format!");
+				if (len > 31) {
+					do_warning("bad format!");
+					event->flags |= EVENT_FL_FAILED;
+					len = 31;
+				}
 
 				memcpy(format, saveptr, len);
 				format[len] = 0;
@@ -3995,19 +4004,26 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 						trace_seq_printf(s, format, (long long)val);
 					break;
 				default:
-					die("bad count (%d)", ls);
+					do_warning("bad count (%d)", ls);
+					event->flags |= EVENT_FL_FAILED;
 				}
 				break;
 			case 's':
-				if (!arg)
-					die("no matching argument");
+				if (!arg) {
+					do_warning("no matching argument");
+					event->flags |= EVENT_FL_FAILED;
+					goto out_failed;
+				}
 
 				len = ((unsigned long)ptr + 1) -
 					(unsigned long)saveptr;
 
 				/* should never happen */
-				if (len > 31)
-					die("bad format!");
+				if (len > 31) {
+					do_warning("bad format!");
+					event->flags |= EVENT_FL_FAILED;
+					len = 31;
+				}
 
 				memcpy(format, saveptr, len);
 				format[len] = 0;
@@ -4025,6 +4041,11 @@ static void pretty_print(struct trace_seq *s, void *data, int size, struct event
 			trace_seq_putc(s, *ptr);
 	}
 
+	if (event->flags & EVENT_FL_FAILED) {
+out_failed:
+		trace_seq_printf(s, "[FAILED TO PARSE]");
+	}
+
 	if (args) {
 		free_args(args);
 		free(bprint_fmt);
-- 
1.7.11.4

