Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab2C1Mhy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 08:37:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758090Ab2C1Mhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 08:37:50 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, rostedt@goodmis.org, robert.richter@amd.com,
        fche@redhat.com, linux-kernel@vger.kernel.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 15/15] perf, tool: Support for dwarf mode callchain on perf record
Date: Wed, 28 Mar 2012 14:35:58 +0200
Message-Id: <1332938158-5244-16-git-send-email-jolsa@redhat.com>
In-Reply-To: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
References: <1332938158-5244-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables perf to use the dwarf unwind code.

It extends the perf record '-g' option with following arguments:
  'fp'           - provides framepointer based user
                   stack backtrace
  'dwarf[,size]' - provides dwarf (libunwind) based user stack
                   backtrace. The size specifies the size of the
                   user stack dump. If ommited it is 8192 by default.

If libunwind is found during the perf build, then the 'dwarf'
argument becomes the default option. If not, 'fp' stays as
default and 'dwarf' is not available. The '-g' usage help text
is updated accordingly.

Examples: (perf compiled with libunwind)

   perf record -g -- ls
   perf record -g dwarf ls
      - provide dwarf unwind with 8192 as stack dump size

   perf record -g dwarf,4096 ls
      - provides dwarf unwind with 4096 as stack dump size

   perf record -g fp ls
      - provides frame pointer unwind

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c |   86 ++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/perf.h           |    9 ++++-
 tools/perf/util/evsel.c     |   10 ++++-
 3 files changed, 101 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 7b98fa9..578d58b 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -27,11 +27,25 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 #include "util/vdso.h"
+#include "util/perf_regs.h"
 
 #include <unistd.h>
 #include <sched.h>
 #include <sys/mman.h>
 
+#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording "
+
+#ifdef NO_LIBUNWIND_SUPPORT
+static const char callchain_default_opt[] = "fp";
+static unsigned long default_stack_dump_size;
+static char callchain_help[] = CALLCHAIN_HELP "[fp]";
+#else
+static const char callchain_default_opt[] = "dwarf";
+static unsigned long default_stack_dump_size = 8192;
+static char callchain_help[] = CALLCHAIN_HELP "[dwarf]";
+#endif
+
+
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
@@ -727,6 +741,73 @@ error:
 	return ret;
 }
 
+static int
+parse_callchain_opt(const struct option *opt __used, const char *arg,
+		    int unset)
+{
+	struct perf_record *rec = (struct perf_record *)opt->value;
+	char *tok, *name, *saveptr = NULL;
+	char buf[20];
+	int ret = -1;
+
+	/* --no-call-graph */
+	if (unset)
+		return 0;
+
+	/* We specified default option if none is provided. */
+	BUG_ON(!arg);
+
+	/* We need buffer that we know we can write to. */
+	snprintf(buf, 20, "%s", arg);
+
+	tok = strtok_r((char *)buf, ",", &saveptr);
+	name = tok ? : (char *)buf;
+
+	do {
+		/* Framepointer style */
+		if (!strncmp(name, "fp", sizeof("fp"))) {
+			if (!strtok_r(NULL, ",", &saveptr)) {
+				rec->opts.call_graph = CALLCHAIN_FP;
+				ret = 0;
+			} else
+				pr_err("callchain: No more arguments "
+				       "needed for -g fp\n");
+			break;
+		}
+
+		/* Dwarf style */
+		if (strncmp(name, "dwarf", sizeof("dwarf"))) {
+			pr_err("callchain: Unknown -g option "
+			       "value: %s\n", name);
+			break;
+		}
+
+		ret = 0;
+		rec->opts.call_graph = CALLCHAIN_DWARF;
+		rec->opts.stack_dump_size = default_stack_dump_size;
+
+		tok = strtok_r(NULL, ",", &saveptr);
+		if (tok) {
+			char *endptr;
+
+			rec->opts.stack_dump_size = strtoul(tok, &endptr, 0);
+			if (*endptr) {
+				pr_err("callchain: Incorrect stack "
+				       "dump size: %s\n", tok);
+				ret = -1;
+			}
+		}
+
+	} while (0);
+
+	if (!ret)
+		pr_debug("callchain: type %d, size %lu\n",
+			rec->opts.call_graph,
+			rec->opts.stack_dump_size);
+
+	return ret;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -795,8 +876,9 @@ const struct option record_options[] = {
 		     "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_BOOLEAN('g', "call-graph", &record.opts.call_graph,
-		    "do call-graph (stack chain/backtrace) recording"),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &record, "mode,dump_size",
+			     callchain_help, &parse_callchain_opt,
+			     callchain_default_opt),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 89e3355..505f7ff 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -207,11 +207,17 @@ extern const char perf_version_string[];
 
 void pthread__unblock_sigwinch(void);
 
+enum perf_call_graph_mode {
+	CALLCHAIN_NONE,
+	CALLCHAIN_FP,
+	CALLCHAIN_DWARF
+};
+
 struct perf_record_opts {
 	const char   *target_pid;
 	const char   *target_tid;
 	uid_t	     uid;
-	bool	     call_graph;
+	int	      call_graph;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_delay;
@@ -232,6 +238,7 @@ struct perf_record_opts {
 	u64	     default_interval;
 	u64	     user_interval;
 	const char   *cpu_list;
+	unsigned long stack_dump_size;
 };
 
 #endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 656eaeb..81c5853 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -15,6 +15,7 @@
 #include "util.h"
 #include "cpumap.h"
 #include "thread_map.h"
+#include "perf_regs.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
@@ -104,9 +105,16 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph)
+	if (opts->call_graph) {
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+		if (opts->call_graph == CALLCHAIN_DWARF) {
+			attr->user_regs = PERF_REGS_MASK;
+			attr->ustack_dump_size = opts->stack_dump_size;
+			attr->exclude_user_callchain = 1;
+		}
+	}
+
 	if (opts->system_wide)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
-- 
1.7.1

