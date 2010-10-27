Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932467Ab0J0LC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 07:02:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:45603 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932286Ab0J0LCX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 07:02:23 -0400
Date: Wed, 27 Oct 2010 11:01:27 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf scripting: Shut up 'perf record' final status
Message-ID: <tip-b44308f54062a4c1dee2602946f481f03739b76d@git.kernel.org>
Git-Commit-ID: b44308f54062a4c1dee2602946f481f03739b76d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 27 Oct 2010 11:01:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b44308f54062a4c1dee2602946f481f03739b76d
Gitweb:     http://git.kernel.org/tip/b44308f54062a4c1dee2602946f481f03739b76d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 26 Oct 2010 15:20:09 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 26 Oct 2010 15:20:09 -0200

perf scripting: Shut up 'perf record' final status

We want just the script output, not internal details about the record phase.

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
 tools/perf/Documentation/perf-record.txt |    4 ++++
 tools/perf/builtin-record.c              |    4 ++++
 tools/perf/builtin-trace.c               |    9 +++++----
 tools/perf/util/debug.c                  |    4 ++--
 tools/perf/util/debug.h                  |    2 +-
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/tools/perf/Documentation/perf-record.txt b/tools/perf/Documentation/perf-record.txt
index 3ee27dc..a91f9f9 100644
--- a/tools/perf/Documentation/perf-record.txt
+++ b/tools/perf/Documentation/perf-record.txt
@@ -83,6 +83,10 @@ OPTIONS
 --call-graph::
 	Do call-graph (stack chain/backtrace) recording.
 
+-q::
+--quiet::
+	Don't print any message, useful for scripting.
+
 -v::
 --verbose::
 	Be more verbose (show counter open errors, etc).
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b530bee..4e75583 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -761,6 +761,9 @@ static int __cmd_record(int argc, const char **argv)
 		}
 	}
 
+	if (quiet)
+		return 0;
+
 	fprintf(stderr, "[ perf record: Woken up %ld times to write data ]\n", waking);
 
 	/*
@@ -820,6 +823,7 @@ static const struct option options[] = {
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
+	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
 	OPT_BOOLEAN('s', "stat", &inherit_stat,
 		    "per thread counts"),
 	OPT_BOOLEAN('d', "data", &sample_address,
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index deda1a9..2f8df45 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -625,12 +625,13 @@ int cmd_trace(int argc, const char **argv, const char *prefix __used)
 			dup2(live_pipe[1], 1);
 			close(live_pipe[0]);
 
-			__argv = malloc(5 * sizeof(const char *));
+			__argv = malloc(6 * sizeof(const char *));
 			__argv[0] = "/bin/sh";
 			__argv[1] = record_script_path;
-			__argv[2] = "-o";
-			__argv[3] = "-";
-			__argv[4] = NULL;
+			__argv[2] = "-q";
+			__argv[3] = "-o";
+			__argv[4] = "-";
+			__argv[5] = NULL;
 
 			execvp("/bin/sh", (char **)__argv);
 			exit(-1);
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index f9c7e3a..c8d81b0 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -12,8 +12,8 @@
 #include "debug.h"
 #include "util.h"
 
-int verbose = 0;
-bool dump_trace = false;
+int verbose;
+bool dump_trace = false, quiet = false;
 
 int eprintf(int level, const char *fmt, ...)
 {
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index 7a17ee0..7b51408 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -6,7 +6,7 @@
 #include "event.h"
 
 extern int verbose;
-extern bool dump_trace;
+extern bool quiet, dump_trace;
 
 int dump_printf(const char *fmt, ...) __attribute__((format(printf, 1, 2)));
 void trace_event(event_t *event);
