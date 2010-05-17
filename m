Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab0EQTcn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:32:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32902 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753126Ab0EQTbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:31:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Stephane Eranian <eranian@google.com>, Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 2/4] perf options: Check v type in OPT_U?INTEGER
Date: Mon, 17 May 2010 16:31:16 -0300
Message-Id: <1274124678-24781-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1274124678-24781-1-git-send-email-acme@infradead.org>
References: <1274124678-24781-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To avoid problems like the one fixed by Stephane Eranian in 3de29ca, now
we'll got this instead:

	bench/sched-messaging.c:259: error: negative width in bit-field ‘<anonymous>’
	bench/sched-messaging.c:261: error: negative width in bit-field ‘<anonymous>’

Which is rather cryptic, but is how BUILD_BUG_ON_ZERO works, so kernel
hackers should be already used to this.

With it in place found some problems, fixed by changing the affected
variables to sensible types or changed some OPT_INTEGER to OPT_UINTEGER.

Next csets will go thru converting each of the remaining OPT_ so that
review can be made easier by grouping changes per type per patch.

Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/sched-messaging.c     |    6 ++----
 tools/perf/builtin-record.c            |    8 +++-----
 tools/perf/builtin-sched.c             |    6 +++---
 tools/perf/builtin-top.c               |    5 ++---
 tools/perf/util/include/linux/kernel.h |    2 ++
 tools/perf/util/parse-options.h        |    8 ++++++--
 6 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/tools/perf/bench/sched-messaging.c b/tools/perf/bench/sched-messaging.c
index da1b2e9..d1d1b30 100644
--- a/tools/perf/bench/sched-messaging.c
+++ b/tools/perf/bench/sched-messaging.c
@@ -256,10 +256,8 @@ static const struct option options[] = {
 		    "Use pipe() instead of socketpair()"),
 	OPT_BOOLEAN('t', "thread", &thread_mode,
 		    "Be multi thread instead of multi process"),
-	OPT_INTEGER('g', "group", &num_groups,
-		    "Specify number of groups"),
-	OPT_INTEGER('l', "loop", &loops,
-		    "Specify number of loops"),
+	OPT_UINTEGER('g', "group", &num_groups, "Specify number of groups"),
+	OPT_UINTEGER('l', "loop", &loops, "Specify number of loops"),
 	OPT_END()
 };
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b93573c..cb46c7d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -45,7 +45,7 @@ static int			output;
 static int			pipe_output			=      0;
 static const char		*output_name			= "perf.data";
 static int			group				=      0;
-static unsigned int		realtime_prio			=      0;
+static int			realtime_prio			=      0;
 static bool			raw_samples			=  false;
 static bool			system_wide			=  false;
 static int			profile_cpu			=     -1;
@@ -822,10 +822,8 @@ static const struct option options[] = {
 		    "output file name"),
 	OPT_BOOLEAN('i', "no-inherit", &no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_INTEGER('F', "freq", &user_freq,
-		    "profile at this frequency"),
-	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
-		    "number of mmap data pages"),
+	OPT_UINTEGER('F', "freq", &user_freq, "profile at this frequency"),
+	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
 	OPT_BOOLEAN('g', "call-graph", &call_graph,
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_INCR('v', "verbose", &verbose,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index be7bc92..c80acdf 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -105,7 +105,7 @@ static u64			sum_runtime;
 static u64			sum_fluct;
 static u64			run_avg;
 
-static unsigned long		replay_repeat = 10;
+static unsigned int		replay_repeat = 10;
 static unsigned long		nr_timestamps;
 static unsigned long		nr_unordered_timestamps;
 static unsigned long		nr_state_machine_bugs;
@@ -1816,8 +1816,8 @@ static const char * const replay_usage[] = {
 };
 
 static const struct option replay_options[] = {
-	OPT_INTEGER('r', "repeat", &replay_repeat,
-		    "repeat the workload replay N times (-1: infinite)"),
+	OPT_UINTEGER('r', "repeat", &replay_repeat,
+		     "repeat the workload replay N times (-1: infinite)"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show symbol address, etc)"),
 	OPT_BOOLEAN('D', "dump-raw-trace", &dump_trace,
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ed9b5b6..9f0cfa0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -71,7 +71,7 @@ static int			thread_num			=      0;
 static bool			inherit				=  false;
 static int			profile_cpu			=     -1;
 static int			nr_cpus				=      0;
-static unsigned int		realtime_prio			=      0;
+static int			realtime_prio			=      0;
 static bool			group				=  false;
 static unsigned int		page_size;
 static unsigned int		mmap_pages			=     16;
@@ -1357,8 +1357,7 @@ static const struct option options[] = {
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &hide_kernel_symbols,
 		    "hide kernel symbols"),
-	OPT_INTEGER('m', "mmap-pages", &mmap_pages,
-		    "number of mmap data pages"),
+	OPT_UINTEGER('m', "mmap-pages", &mmap_pages, "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_INTEGER('d', "delay", &delay_secs,
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index 388ab1b..1eb804f 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -28,6 +28,8 @@
 	(type *)((char *)__mptr - offsetof(type, member)); })
 #endif
 
+#define BUILD_BUG_ON_ZERO(e) (sizeof(struct { int:-!!(e); }))
+
 #ifndef max
 #define max(x, y) ({				\
 	typeof(x) _max1 = (x);			\
diff --git a/tools/perf/util/parse-options.h b/tools/perf/util/parse-options.h
index c6aa4ee..9ca348e 100644
--- a/tools/perf/util/parse-options.h
+++ b/tools/perf/util/parse-options.h
@@ -1,6 +1,8 @@
 #ifndef __PERF_PARSE_OPTIONS_H
 #define __PERF_PARSE_OPTIONS_H
 
+#include <linux/kernel.h>
+
 enum parse_opt_type {
 	/* special types */
 	OPTION_END,
@@ -93,6 +95,8 @@ struct option {
 	intptr_t defval;
 };
 
+#define check_vtype(v, type) ( BUILD_BUG_ON_ZERO(!__builtin_types_compatible_p(typeof(v), type)) + v )
+
 #define OPT_END()                   { .type = OPTION_END }
 #define OPT_ARGUMENT(l, h)          { .type = OPTION_ARGUMENT, .long_name = (l), .help = (h) }
 #define OPT_GROUP(h)                { .type = OPTION_GROUP, .help = (h) }
@@ -101,8 +105,8 @@ struct option {
 #define OPT_INCR(s, l, v, h)        { .type = OPTION_INCR, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_SET_INT(s, l, v, h, i)  { .type = OPTION_SET_INT, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (i) }
 #define OPT_SET_PTR(s, l, v, h, p)  { .type = OPTION_SET_PTR, .short_name = (s), .long_name = (l), .value = (v), .help = (h), .defval = (p) }
-#define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
-#define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
+#define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
+#define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h) }
 #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = (v), .help = (h) }
 #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = (v), (a), .help = (h) }
-- 
1.6.2.5

