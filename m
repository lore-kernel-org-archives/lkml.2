Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754Ab1FGNJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 09:09:26 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:42501 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733Ab1FGNJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 09:09:23 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Tue, 07 Jun 2011 18:32:31 +0530
Message-Id: <20110607130231.28590.73619.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
Subject: [PATCH v4 3.0-rc2-tip 21/22] 21: perf: show possible probes in a given executable file or library.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Enhances -F/--funcs option of "perf probe" to list possible probe points in
an executable file or library. A new option -e/--exe specifies the path of
the executable or library.


Show last 10 functions in /bin/zsh.

# perf probe -F -u -e /bin/zsh | tail
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

# perf probe -u -F -e /lib/libc.so.6 | head
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
 tools/perf/builtin-probe.c    |   63 +++++++++++++++++++++++++++++++++++++----
 tools/perf/util/probe-event.c |   56 ++++++++++++++++++++++++++++--------
 tools/perf/util/probe-event.h |    4 +--
 3 files changed, 102 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a90ee01..6aff85c 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -185,6 +185,55 @@ static int opt_set_filter(const struct option *opt __used,
 	return 0;
 }
 
+static int opt_set_executable(const struct option *opt __used,
+			  const char *str, int unset __used)
+{
+	if (params.target || !str)
+		return -EINVAL;
+
+	if (params.uprobes) {
+		pr_err("  Error: Don't use -m with --uprobes.\n");
+		return -EINVAL;
+	}
+
+	if (str) {
+		params.target = str;
+		params.uprobes = true;
+	}
+	return 0;
+}
+
+#ifdef DWARF_SUPPORT
+static int opt_set_module(const struct option *opt __used,
+			  const char *str, int unset __used)
+{
+	if (params.target || !str)
+		return -EINVAL;
+
+	if (params.uprobes) {
+		pr_err("  Error: Don't use -m with --uprobes.\n");
+		return -EINVAL;
+	}
+
+	if (str)
+		params.target = str;
+
+	return 0;
+}
+#endif
+
+static int opt_set_uprobes(const struct option *opt __used,
+			  const char *str __used, int unset __used)
+{
+	if (params.target) {
+		pr_err("  Error: Don't use --uprobes with -x/-m.\n");
+		return -EINVAL;
+	}
+
+	params.uprobes = true;
+	return 0;
+}
+
 static const char * const probe_usage[] = {
 	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
@@ -243,16 +292,18 @@ static const struct option options[] = {
 		   "file", "vmlinux pathname"),
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
 		   "directory", "path to kernel source"),
-	OPT_STRING('m', "module", &params.target,
-		   "modname", "target module name"),
+	OPT_CALLBACK('m', "module", NULL, "modname", "target module name",
+		   opt_set_module),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
 		 "Set how many probe points can be found for a probe."),
 	OPT_BOOLEAN('F', "funcs", &params.show_funcs,
 		    "Show potential probe-able functions."),
-	OPT_BOOLEAN('u', "uprobes", &params.uprobes,
-		    "user space probe events"),
+	OPT_CALLBACK_NOOPT('u', "uprobes", NULL, NULL,
+		    "user space probe events", opt_set_uprobes),
+	OPT_CALLBACK('x', "exe", NULL, "/path/to/absolute/relative/file",
+		    "target executable name", opt_set_executable),
 	OPT_CALLBACK('\0', "filter", NULL,
 		     "[!]FILTER", "Set a filter (with --vars/funcs only)\n"
 		     "\t\t\t(default: \"" DEFAULT_VAR_FILTER "\" for --vars,\n"
@@ -335,8 +386,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
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
index 30f9e2f..d45dfb1 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -47,6 +47,7 @@
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
+#include "session.h"
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -2094,6 +2095,7 @@ error:
 	}
 	return ret;
 }
+
 /* TODO: don't use a global variable for filter ... */
 static struct strfilter *available_func_filter;
 
@@ -2110,32 +2112,60 @@ static int filter_available_functions(struct map *map __unused,
 	return 1;
 }
 
-int show_available_funcs(const char *elfobject, struct strfilter *_filter)
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
 
-	map = kernel_get_module_map(elfobject);
+	map = kernel_get_module_map(module);
 	if (!map) {
-		pr_err("Failed to find %s map.\n", (elfobject) ? : "kernel");
+		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
 		return -EINVAL;
 	}
+	return __show_available_funcs(map);
+}
+
+int show_available_funcs(const char *elfobject, struct strfilter *_filter,
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
+		return available_kernel_funcs(elfobject);
+
+	symbol_conf.try_vmlinux_path = false;
+	symbol_conf.sort_by_name = true;
+	ret = symbol__init();
+	if (ret < 0) {
+		pr_err("Failed to init symbol map.\n");
+		return ret;
+	}
+	map = dso__new_map(elfobject);
+	ret = __show_available_funcs(map);
+	dso__delete(map->dso);
+	map__delete(map);
+	return ret;
 }
 
 #define DEFAULT_FUNC_FILTER "!_*"
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 365e016..5199df4 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -130,8 +130,8 @@ extern int show_line_range(struct line_range *lr, const char *module);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       int max_probe_points, const char *module,
 			       struct strfilter *filter, bool externs);
-extern int show_available_funcs(const char *module, struct strfilter *filter);
-
+extern int show_available_funcs(const char *module, struct strfilter *filter,
+				bool user);
 
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
