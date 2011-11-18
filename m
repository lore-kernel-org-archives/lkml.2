Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab1KRLhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 06:37:41 -0500
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:34056 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757537Ab1KRLhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 06:37:38 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Date: Fri, 18 Nov 2011 16:41:24 +0530
Message-Id: <20111118111124.10512.86342.sendpatchset@srdronam.in.ibm.com>
In-Reply-To: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com>
Subject: [PATCH v7 3.2-rc2 24/30] perf: show possible probes in a given executable file or library.
x-cbid: 11111801-1396-0000-0000-000000438421
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Enhances -F/--funcs option of "perf probe" to list possible probe points in
an executable file or library.

Show last 10 functions in /bin/zsh.

# perf probe -F -x /bin/zsh | tail
zstrtol
ztrcmp
ztrdup
ztrduppfx
ztrftime
ztrlen
ztrncpy
ztrsub
zwarn
zwarnnam

Show first 10 functions in /lib/libc.so.6

# perf probe -F -x /lib/libc.so.6 | head
_IO_adjust_column
_IO_adjust_wcolumn
_IO_default_doallocate
_IO_default_finish
_IO_default_pbackfail
_IO_default_uflow
_IO_default_xsgetn
_IO_default_xsputn
_IO_do_write@@GLIBC_2.2.5
_IO_doallocbuf

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

(Changelog (since v5)
- Removed the separate documentation change patch and added the
  documentation changes as part of this patch.

 tools/perf/Documentation/perf-probe.txt |    4 ++
 tools/perf/builtin-probe.c              |    4 +-
 tools/perf/util/probe-event.c           |   55 ++++++++++++++++++++++++-------
 tools/perf/util/probe-event.h           |    4 +-
 4 files changed, 49 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 469ad6d..be88378 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -78,6 +78,8 @@ OPTIONS
 -F::
 --funcs::
 	Show available functions in given module or kernel.
+	With -x/--exec, can also list functions in a user space executable
+	/ shared library.
 
 --filter=FILTER::
 	(Only for --vars and --funcs) Set filter. FILTER is a combination of glob
@@ -101,7 +103,7 @@ OPTIONS
 -x::
 --exec=PATH::
 	Specify path to the executable or shared library file for user
-	space tracing.
+	space tracing. Can also be used with --funcs option.
 
 PROBE SYNTAX
 ------------
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 43e6321..5e7622c 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -365,8 +365,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		if (!params.filter)
 			params.filter = strfilter__new(DEFAULT_FUNC_FILTER,
 						       NULL);
-		ret = show_available_funcs(params.target,
-					   params.filter);
+		ret = show_available_funcs(params.target, params.filter,
+					params.uprobes);
 		strfilter__delete(params.filter);
 		if (ret < 0)
 			pr_err("  Error: Failed to show functions."
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index d4f4c2b..2c4ec61 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -47,6 +47,7 @@
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
+#include "session.h"
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -2179,32 +2180,60 @@ static int filter_available_functions(struct map *map __unused,
 	return 1;
 }
 
-int show_available_funcs(const char *target, struct strfilter *_filter)
+static int __show_available_funcs(struct map *map)
+{
+	if (map__load(map, filter_available_functions)) {
+		pr_err("Failed to load map.\n");
+		return -EINVAL;
+	}
+	if (!dso__sorted_by_name(map->dso, map->type))
+		dso__sort_by_name(map->dso, map->type);
+
+	dso__fprintf_symbols_by_name(map->dso, map->type, stdout);
+	return 0;
+}
+
+static int available_kernel_funcs(const char *module)
 {
 	struct map *map;
 	int ret;
 
-	setup_pager();
-
 	ret = init_vmlinux();
 	if (ret < 0)
 		return ret;
 
-	map = kernel_get_module_map(target);
+	map = kernel_get_module_map(module);
 	if (!map) {
-		pr_err("Failed to find %s map.\n", (target) ? : "kernel");
+		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
 		return -EINVAL;
 	}
+	return __show_available_funcs(map);
+}
+
+int show_available_funcs(const char *target, struct strfilter *_filter,
+					bool user)
+{
+	struct map *map;
+	int ret;
+
+	setup_pager();
 	available_func_filter = _filter;
-	if (map__load(map, filter_available_functions)) {
-		pr_err("Failed to load map.\n");
-		return -EINVAL;
-	}
-	if (!dso__sorted_by_name(map->dso, map->type))
-		dso__sort_by_name(map->dso, map->type);
 
-	dso__fprintf_symbols_by_name(map->dso, map->type, stdout);
-	return 0;
+	if (!user)
+		return available_kernel_funcs(target);
+
+	symbol_conf.try_vmlinux_path = false;
+	symbol_conf.sort_by_name = true;
+	ret = symbol__init();
+	if (ret < 0) {
+		pr_err("Failed to init symbol map.\n");
+		return ret;
+	}
+	map = dso__new_map(target);
+	ret = __show_available_funcs(map);
+	dso__delete(map->dso);
+	map__delete(map);
+	return ret;
 }
 
 #define DEFAULT_FUNC_FILTER "!_*"
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 9e8c846..f9f3de8 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -131,8 +131,8 @@ extern int show_line_range(struct line_range *lr, const char *module);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       int max_probe_points, const char *module,
 			       struct strfilter *filter, bool externs);
-extern int show_available_funcs(const char *module, struct strfilter *filter);
-
+extern int show_available_funcs(const char *module, struct strfilter *filter,
+				bool user);
 
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024

