Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab1C3Cge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 22:36:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:59537 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab1C3Cfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 22:35:45 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <daahern@cisco.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 1/3] perf tools: Fixup exit path when not able to open events
Date: Tue, 29 Mar 2011 23:35:30 -0300
Message-Id: <1301452532-1260-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1301452532-1260-1-git-send-email-acme@infradead.org>
References: <1301452532-1260-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

We have to deal with the TUI mode in perf top, so that we don't end up
with a garbled screen when, say, a non root user on a machine with a
paranoid setting (the default) tries to use 'perf top'.

Introduce a ui__warning_paranoid() routine shared by top and record that
tells the user the valid values for /proc/sys/kernel/perf_event_paranoid.

Cc: David Ahern <daahern@cisco.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |    9 ++++-----
 tools/perf/builtin-top.c    |   38 ++++++++++++++++++++++++--------------
 tools/perf/util/debug.c     |   10 ++++++++++
 tools/perf/util/debug.h     |    1 +
 4 files changed, 39 insertions(+), 19 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 6febcc1..623695e 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -275,11 +275,10 @@ try_again:
 				     !no_inherit) < 0) {
 			int err = errno;
 
-			if (err == EPERM || err == EACCES)
-				die("Permission error - are you root?\n"
-					"\t Consider tweaking"
-					" /proc/sys/kernel/perf_event_paranoid.\n");
-			else if (err ==  ENODEV && cpu_list) {
+			if (err == EPERM || err == EACCES) {
+				ui__warning_paranoid();
+				exit(EXIT_FAILURE);
+			} else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
 			} else if (err == EINVAL && sample_id_all_avail) {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 676b4fb..935fc4f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -850,10 +850,10 @@ try_again:
 				     top.evlist->threads, group, inherit) < 0) {
 			int err = errno;
 
-			if (err == EPERM || err == EACCES)
-				die("Permission error - are you root?\n"
-					"\t Consider tweaking"
-					" /proc/sys/kernel/perf_event_paranoid.\n");
+			if (err == EPERM || err == EACCES) {
+				ui__warning_paranoid();
+				goto out_err;
+			}
 			/*
 			 * If it's cycles then fall back to hrtimer
 			 * based cpu-clock-tick sw counter, which
@@ -861,25 +861,35 @@ try_again:
 			 */
 			if (attr->type == PERF_TYPE_HARDWARE &&
 			    attr->config == PERF_COUNT_HW_CPU_CYCLES) {
-
 				if (verbose)
-					warning(" ... trying to fall back to cpu-clock-ticks\n");
+					ui__warning("Cycles event not supported,\n"
+						    "trying to fall back to cpu-clock-ticks\n");
 
 				attr->type = PERF_TYPE_SOFTWARE;
 				attr->config = PERF_COUNT_SW_CPU_CLOCK;
 				goto try_again;
 			}
-			printf("\n");
-			error("sys_perf_event_open() syscall returned with %d "
-			      "(%s).  /bin/dmesg may provide additional information.\n",
-			      err, strerror(err));
-			die("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
-			exit(-1);
+
+			ui__warning("The sys_perf_event_open() syscall "
+				    "returned with %d (%s).  /bin/dmesg "
+				    "may provide additional information.\n"
+				    "No CONFIG_PERF_EVENTS=y kernel support "
+				    "configured?\n", err, strerror(err));
+			goto out_err;
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0)
-		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
+	if (perf_evlist__mmap(evlist, mmap_pages, false) < 0) {
+		ui__warning("Failed to mmap with %d (%s)\n",
+			    errno, strerror(errno));
+		goto out_err;
+	}
+
+	return;
+
+out_err:
+	exit_browser(0);
+	exit(0);
 }
 
 static int __cmd_top(void)
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index d4536a9..155749d 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -57,6 +57,16 @@ void ui__warning(const char *format, ...)
 }
 #endif
 
+void ui__warning_paranoid(void)
+{
+	ui__warning("Permission error - are you root?\n"
+		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
+		    " -1 - Not paranoid at all\n"
+		    "  0 - Disallow raw tracepoint access for unpriv\n"
+		    "  1 - Disallow cpu events for unpriv\n"
+		    "  2 - Disallow kernel profiling for unpriv\n");
+}
+
 void trace_event(union perf_event *event)
 {
 	unsigned char *raw_event = (void *)event;
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 93516cf..fd53db4 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -36,5 +36,6 @@ int ui_helpline__show_help(const char *format, va_list ap);
 #endif
 
 void ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
+void ui__warning_paranoid(void);
 
 #endif	/* __PERF_DEBUG_H */
-- 
1.6.2.5

