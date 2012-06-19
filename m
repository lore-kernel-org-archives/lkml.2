Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836Ab2FSPud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 11:50:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754781Ab2FSPuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 11:50:20 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: eranian@google.com, gorcunov@openvz.org, tzanussi@gmail.com,
        mhiramat@redhat.com, robert.richter@amd.com, fche@redhat.com,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        drepper@gmail.com, asharma@fb.com, benjamin.redelings@nescent.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 21/23] perf, tool: Support for dwarf mode callchain on perf record
Date: Tue, 19 Jun 2012 17:48:12 +0200
Message-Id: <1340120894-9465-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
References: <1340120894-9465-1-git-send-email-jolsa@redhat.com>
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
argument becomes available for record command. The 'fp' stays as
default option in any case.

Examples: (perf compiled with libunwind)

   perf record -g dwarf ls
      - provides dwarf unwind with 8192 as stack dump size

   perf record -g dwarf,4096 ls
      - provides dwarf unwind with 4096 as stack dump size

   perf record -g -- ls
   perf record -g fp ls
      - provides frame pointer unwind

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c |  106 ++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/perf.h           |    9 +++-
 tools/perf/util/evsel.c     |   12 +++++-
 3 files changed, 123 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f95840d..8bf3f5c 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -31,6 +31,15 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+#define CALLCHAIN_HELP "do call-graph (stack chain/backtrace) recording: "
+
+#ifdef NO_LIBUNWIND_SUPPORT
+static char callchain_help[] = CALLCHAIN_HELP "[fp]";
+#else
+static unsigned long default_stack_dump_size = 8192;
+static char callchain_help[] = CALLCHAIN_HELP "[fp] dwarf";
+#endif
+
 enum write_mode_t {
 	WRITE_FORCE,
 	WRITE_APPEND
@@ -732,6 +741,98 @@ error:
 	return ret;
 }
 
+static int get_stack_size(char *str, unsigned long *_size)
+{
+	char *endptr;
+	unsigned long size;
+	unsigned long max_size = round_down(USHRT_MAX, sizeof(u64));
+
+	size = strtoul(str, &endptr, 0);
+
+	do {
+		if (*endptr || !size)
+			break;
+
+		size = round_up(size, sizeof(u64));
+		if (size > max_size)
+			break;
+
+		*_size = size;
+		return 0;
+
+	} while (0);
+
+	pr_err("callchain: Incorrect stack dump size (max %ld): %s\n",
+	       max_size, str);
+	return -1;
+}
+
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
+
+#ifndef NO_LIBUNWIND_SUPPORT
+		/* Dwarf style */
+		} else if (!strncmp(name, "dwarf", sizeof("dwarf"))) {
+			ret = 0;
+			rec->opts.call_graph = CALLCHAIN_DWARF;
+			rec->opts.stack_dump_size = default_stack_dump_size;
+
+			tok = strtok_r(NULL, ",", &saveptr);
+			if (tok) {
+				unsigned long size = 0;
+
+				ret = get_stack_size(tok, &size);
+				rec->opts.stack_dump_size = size;
+			}
+
+			if (!ret)
+				pr_debug("callchain: stack dump size %d\n",
+					 rec->opts.stack_dump_size);
+#endif
+		} else {
+			pr_err("callchain: Unknown -g option "
+			       "value: %s\n", name);
+			break;
+		}
+
+	} while (0);
+
+	if (!ret)
+		pr_debug("callchain: type %d\n", rec->opts.call_graph);
+
+	return ret;
+}
+
 static const char * const record_usage[] = {
 	"perf record [<options>] [<command>]",
 	"perf record [<options>] -- <command> [<options>]",
@@ -803,8 +904,9 @@ const struct option record_options[] = {
 		     "number of mmap data pages"),
 	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_BOOLEAN('g', "call-graph", &record.opts.call_graph,
-		    "do call-graph (stack chain/backtrace) recording"),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &record, "mode,dump_size",
+			     callchain_help, &parse_callchain_opt,
+			     "fp"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f960ccb..87f4ec6 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -209,9 +209,15 @@ void pthread__unblock_sigwinch(void);
 
 #include "util/target.h"
 
+enum perf_call_graph_mode {
+	CALLCHAIN_NONE,
+	CALLCHAIN_FP,
+	CALLCHAIN_DWARF
+};
+
 struct perf_record_opts {
 	struct perf_target target;
-	bool	     call_graph;
+	int	     call_graph;
 	bool	     group;
 	bool	     inherit_stat;
 	bool	     no_delay;
@@ -230,6 +236,7 @@ struct perf_record_opts {
 	u64          branch_stack;
 	u64	     default_interval;
 	u64	     user_interval;
+	u16	     stack_dump_size;
 };
 
 #endif
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 6b90214..9ab6160 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -17,6 +17,7 @@
 #include "thread_map.h"
 #include "target.h"
 #include "../../include/linux/perf_event.h"
+#include "perf_regs.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
@@ -196,9 +197,18 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		attr->mmap_data = track;
 	}
 
-	if (opts->call_graph)
+	if (opts->call_graph) {
 		attr->sample_type	|= PERF_SAMPLE_CALLCHAIN;
 
+		if (opts->call_graph == CALLCHAIN_DWARF) {
+			attr->sample_type |= PERF_SAMPLE_REGS_USER |
+					     PERF_SAMPLE_STACK_USER;
+			attr->sample_regs_user = PERF_REGS_MASK;
+			attr->sample_stack_user = opts->stack_dump_size;
+			attr->exclude_callchain_user = 1;
+		}
+	}
+
 	if (perf_target__has_cpu(&opts->target))
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 
-- 
1.7.7.6

