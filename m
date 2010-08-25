Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0HYNsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 09:48:35 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:55558 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab0HYNsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 09:48:32 -0400
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Wed, 25 Aug 2010 19:13:43 +0530
Message-Id: <20100825134343.5447.44352.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
References: <20100825134117.5447.55209.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv11 2.6.36-rc2-tip 12/15] 12: perf: show possible probes in a given file.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduces -S/--show_functions option for perf-probe.
This lists function names in a File. If no file is specified, then lists
functions in the current running kernel.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog from V10: As suggested by Arnaldo, filtering is now
 based on sym.binding.

Changelog from V9: Filter labels, weak, and local binding functions
from listing as suggested by Christoph Hellwig.

Show last 10 functions in /bin/zsh.

# perf probe -S -D /bin/zsh | tail
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

# perf probe -S -D /lib/libc.so.6 | head
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

Show last 10 functions in kernel.

# perf probe -S | tail
zlib_inflateInit2
zlib_inflateReset
zlib_inflate_blob
zlib_inflate_table
zlib_inflate_workspacesize
zone_pcp_update
zone_reclaim
zone_reclaimable_pages
zone_statistics
zone_watermark_ok

 tools/perf/builtin-probe.c    |   43 ++++++++++++++++++++++++
 tools/perf/util/probe-event.c |   72 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-event.h |    1 +
 tools/perf/util/symbol.c      |    8 +++++
 tools/perf/util/symbol.h      |    1 +
 5 files changed, 124 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 199d5e1..fa63245 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -50,9 +50,11 @@ static struct {
 	bool list_events;
 	bool force_add;
 	bool show_lines;
+	bool list_functions;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
+	struct strlist *limitlist;
 	struct line_range line_range;
 	int max_probe_points;
 } params;
@@ -132,6 +134,19 @@ static int opt_show_lines(const struct option *opt __used,
 }
 #endif
 
+static int opt_limit_dsos(const struct option *opt __used,
+			       const char *str, int unset __used)
+{
+	if (str) {
+		if (!params.limitlist)
+			params.limitlist = strlist__new(true, NULL);
+		if (!params.limitlist)
+			return -1;
+		strlist__add(params.limitlist, str);
+	}
+	return 0;
+}
+
 static const char * const probe_usage[] = {
 	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
@@ -188,6 +203,10 @@ static const struct option options[] = {
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
 		 "Set how many probe points can be found for a probe."),
+	OPT_BOOLEAN('S', "show_functions", &params.list_functions,
+				"Show potential probes."),
+	OPT_CALLBACK('D', "limit_dsos", NULL, "DSO",
+				"Limit Dsos.", opt_limit_dsos),
 	OPT_END()
 };
 
@@ -213,7 +232,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		params.max_probe_points = MAX_PROBES;
 
 	if ((!params.nevents && !params.dellist && !params.list_events &&
-	     !params.show_lines))
+	     !params.show_lines && !params.list_functions))
 		usage_with_options(probe_usage, options);
 
 	if (params.list_events) {
@@ -225,12 +244,34 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_err("  Error: Don't use --list with --line.\n");
 			usage_with_options(probe_usage, options);
 		}
+		if (params.list_functions) {
+			pr_warning("  Error: Don't use --list with"
+						" --show_functions.\n");
+			usage_with_options(probe_usage, options);
+		}
 		ret = show_perf_probe_events();
 		if (ret < 0)
 			pr_err("  Error: Failed to show event list. (%d)\n",
 			       ret);
 		return ret;
 	}
+	if (params.list_functions) {
+		if (params.nevents != 0 || params.dellist) {
+			pr_err("  Error: Don't use --show_functions with"
+					" --add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
+		if (params.show_lines) {
+			pr_err("  Error: Don't use --show_functions with"
+					" --line.\n");
+			usage_with_options(probe_usage, options);
+		}
+		ret = show_possible_probes(params.limitlist);
+		if (ret < 0)
+			pr_err("  Error: Failed to show possible"
+					" probes (%d).\n", ret);
+		return ret;
+	}
 
 #ifdef DWARF_SUPPORT
 	if (params.show_lines) {
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e72f05c..2efbe4b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -31,6 +31,7 @@
 #include <string.h>
 #include <stdarg.h>
 #include <limits.h>
+#include <gelf.h>
 
 #undef _GNU_SOURCE
 #include "util.h"
@@ -46,6 +47,7 @@
 #include "trace-event.h"	/* For __unused */
 #include "probe-event.h"
 #include "probe-finder.h"
+#include "session.h"
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -1752,3 +1754,73 @@ int del_perf_probe_events(struct strlist *dellist)
 	return ret;
 }
 
+/*
+ * If a symbol corresponds to a function with global binding return 0.
+ * For all others return 1.
+ */
+static int filter_non_global_functions(struct map *map __unused,
+						struct symbol *sym)
+{
+	if (sym->binding != STB_GLOBAL)
+		return 1;
+
+	return 0;
+}
+
+static int print_list_available_symbols(struct map *map,
+					const char *name __unused)
+{
+	if (map__load(map, filter_non_global_functions) < 0)
+		return -EINVAL;
+	if (!dso__sorted_by_name(map->dso, map->type))
+		dso__sort_by_name(map->dso, map->type);
+
+	dso__fprintf_symbols(map->dso, map->type, stdout);
+	return 0;
+}
+
+int show_possible_probes(struct strlist *limitlist)
+{
+	struct str_node *ent;
+	struct map *map = NULL;
+	char *str;
+	int ret = -EINVAL;
+
+	if (!limitlist) { /* Show functions in kernel */
+		ret = init_vmlinux();
+		if (ret < 0)
+			return ret;
+		return print_list_available_symbols(
+				machine.vmlinux_maps[MAP__FUNCTION], NULL);
+	}
+
+	symbol_conf.try_vmlinux_path = false;
+	symbol_conf.sort_by_name = true;
+	ret = symbol__init();
+	if (ret < 0) {
+		pr_debug("Failed to init symbol map.\n");
+		return ret;
+	}
+
+	strlist__for_each(ent, limitlist) {
+		str = strdup(ent->s);
+		if (!str) {
+			ret = -ENOMEM;
+			goto out_delete;
+		}
+
+		map = dso__new_map(str);
+		ret = print_list_available_symbols(map, NULL);
+		if (ret)
+			pr_warning("No Symbols in dso %s.\n", str);
+
+		dso__delete(map->dso);
+		map__delete(map);
+		free(str);
+	}
+
+out_delete:
+	if (ret)
+		pr_warning("Failed to list available probes.\n");
+	return ret;
+}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 5af3924..fcd0f08 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -115,6 +115,7 @@ extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
+extern int show_possible_probes(struct strlist *availlist);
 
 
 /* Maximum index number of event-name postfix */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index ca22032..385f0a4 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -2464,3 +2464,11 @@ int machine__load_vmlinux_path(struct machine *self, enum map_type type,
 
 	return ret;
 }
+
+struct map *dso__new_map(char *name)
+{
+	struct dso *dso = dso__new(name);
+	struct map *map = map__new2(0, dso, MAP__FUNCTION);
+
+	return map;
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 72ef973..52a8126 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -202,6 +202,7 @@ char dso__symtab_origin(const struct dso *self);
 void dso__set_long_name(struct dso *self, char *name);
 void dso__set_build_id(struct dso *self, void *build_id);
 void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
+struct map *dso__new_map(char *name);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 					const char *name);
