Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760315Ab2IHCH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 22:07:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41315 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab2IHCHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 22:07:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/13] tools lib traceevent: Get rid of die() from pretty_print()
Date: Fri,  7 Sep 2012 23:07:01 -0300
Message-Id: <1347070032-4161-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347070032-4161-1-git-send-email-acme@infradead.org>
References: <1347070032-4161-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
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

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1346986187-5170-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c |   43 +++++++++++++++++++++++++++---------
 1 file changed, 32 insertions(+), 11 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index b5b4d80..6d5e759 100644
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
1.7.9.2.358.g22243

