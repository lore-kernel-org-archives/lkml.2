Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754240Ab2IHLja (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 07:39:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39478 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2IHLjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 07:39:24 -0400
Date: Sat, 8 Sep 2012 04:38:59 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-245c5a18433090da0e1a799bdb0faa78552b5992@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, fweisbec@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
References: <1346986187-5170-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent: Get rid of die()
  from pretty_print()
Git-Commit-ID: 245c5a18433090da0e1a799bdb0faa78552b5992
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sat, 08 Sep 2012 04:39:05 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  245c5a18433090da0e1a799bdb0faa78552b5992
Gitweb:     http://git.kernel.org/tip/245c5a18433090da0e1a799bdb0faa78552b5992
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 7 Sep 2012 11:49:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Sep 2012 12:14:30 -0300

tools lib traceevent: Get rid of die() from pretty_print()

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
 tools/lib/traceevent/event-parse.c |   43 ++++++++++++++++++++++++++---------
 1 files changed, 32 insertions(+), 11 deletions(-)

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
