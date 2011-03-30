Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab1C3HQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 03:16:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:47564 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab1C3HQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 03:16:26 -0400
Date: Wed, 30 Mar 2011 07:15:55 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, daahern@cisco.com, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fixup exit path when not able to open events
Message-ID: <tip-c286c419c784c238cd699be37fec7a9acc30d89f@git.kernel.org>
Git-Commit-ID: c286c419c784c238cd699be37fec7a9acc30d89f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 30 Mar 2011 07:15:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c286c419c784c238cd699be37fec7a9acc30d89f
Gitweb:     http://git.kernel.org/tip/c286c419c784c238cd699be37fec7a9acc30d89f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Mon, 28 Mar 2011 09:50:11 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 29 Mar 2011 13:40:27 -0300

perf tools: Fixup exit path when not able to open events

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
index 93516cf4..fd53db4 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -36,5 +36,6 @@ int ui_helpline__show_help(const char *format, va_list ap);
 #endif
 
 void ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
+void ui__warning_paranoid(void);
 
 #endif	/* __PERF_DEBUG_H */
