Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468Ab2LKWy2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:54:28 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43863 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab2LKWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 35/37] perf record: Pass perf_record_opts to the callchain cmdline parsing callback
Date: Tue, 11 Dec 2012 19:48:21 -0300
Message-Id: <1355266103-17238-36-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Its all it uses and makes the parsing callback suitable for use by
'perf top', which will happen in a followup patch.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wb9eti78bk2jd7wpasro8hsz@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c |   24 +++++++++++-------------
 1 file changed, 11 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fc4f080..d035040 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -868,11 +868,9 @@ static int get_stack_size(char *str, unsigned long *_size)
 }
 #endif /* LIBUNWIND_SUPPORT */
 
-static int
-parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
-		    int unset)
+static int parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	struct perf_record *rec = (struct perf_record *)opt->value;
+	struct perf_record_opts *opts = opt->value;
 	char *tok, *name, *saveptr = NULL;
 	char *buf;
 	int ret = -1;
@@ -898,7 +896,7 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 		/* Framepointer style */
 		if (!strncmp(name, "fp", sizeof("fp"))) {
 			if (!strtok_r(NULL, ",", &saveptr)) {
-				rec->opts.call_graph = CALLCHAIN_FP;
+				opts->call_graph = CALLCHAIN_FP;
 				ret = 0;
 			} else
 				pr_err("callchain: No more arguments "
@@ -911,20 +909,20 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 			const unsigned long default_stack_dump_size = 8192;
 
 			ret = 0;
-			rec->opts.call_graph = CALLCHAIN_DWARF;
-			rec->opts.stack_dump_size = default_stack_dump_size;
+			opts->call_graph = CALLCHAIN_DWARF;
+			opts->stack_dump_size = default_stack_dump_size;
 
 			tok = strtok_r(NULL, ",", &saveptr);
 			if (tok) {
 				unsigned long size = 0;
 
 				ret = get_stack_size(tok, &size);
-				rec->opts.stack_dump_size = size;
+				opts->stack_dump_size = size;
 			}
 
 			if (!ret)
 				pr_debug("callchain: stack dump size %d\n",
-					 rec->opts.stack_dump_size);
+					 opts->stack_dump_size);
 #endif /* LIBUNWIND_SUPPORT */
 		} else {
 			pr_err("callchain: Unknown -g option "
@@ -937,7 +935,7 @@ parse_callchain_opt(const struct option *opt __maybe_unused, const char *arg,
 	free(buf);
 
 	if (!ret)
-		pr_debug("callchain: type %d\n", rec->opts.call_graph);
+		pr_debug("callchain: type %d\n", opts->call_graph);
 
 	return ret;
 }
@@ -1021,9 +1019,9 @@ const struct option record_options[] = {
 		     "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", &record, "mode[,dump_size]",
-			     callchain_help, &parse_callchain_opt,
-			     "fp"),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &record.opts,
+			     "mode[,dump_size]", callchain_help,
+			     &parse_callchain_opt, "fp"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
-- 
1.7.9.2.358.g22243

