Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab0KSV36 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 16:29:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:45778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab0KSV34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 16:29:56 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/4] perf scripting: Shut up 'perf record' final status
Date: Fri, 19 Nov 2010 19:29:42 -0200
Message-Id: <1290202186-25352-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1290202186-25352-1-git-send-email-acme@infradead.org>
References: <1290202186-25352-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
-- 
1.6.2.5

