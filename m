Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab1AYRYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:24:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:47005 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab1AYRWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:22:16 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp, Franck Bui-Huu <fbuihuu@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 24/29] perf probe: Add --funcs to show available functions in symtab
Date: Tue, 25 Jan 2011 15:21:47 -0200
Message-Id: <1295976112-2796-25-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295976112-2796-1-git-send-email-acme@infradead.org>
References: <1295976112-2796-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add --funcs to show available functions in symtab.

Originally this feature came from Srikar's uprobes patches
( http://lkml.org/lkml/2010/8/27/244 )

e.g.
...
__ablkcipher_walk_complete
__absent_pages_in_range
__account_scheduler_latency
__add_pages
__alloc_pages_nodemask
__alloc_percpu
__alloc_reserved_percpu
__alloc_skb
__alloc_workqueue_key
__any_online_cpu
__ata_ehi_push_desc
...

This also supports symbols in module, e.g.

...
cleanup_module
cpuid_maxphyaddr
emulate_clts
emulate_instruction
emulate_int_real
emulate_invlpg
emulator_get_dr
emulator_set_dr
emulator_task_switch
emulator_write_emulated
emulator_write_phys
fx_init
...

Original-patch-from: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Franck Bui-Huu <fbuihuu@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20110113124611.22426.10835.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
[ committer note: Add missing elf.h for STB_GLOBAL that broke a RHEL4 build ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    4 ++
 tools/perf/builtin-probe.c              |   29 +++++++++++++-
 tools/perf/util/probe-event.c           |   68 ++++++++++++++++++++++++++++++-
 tools/perf/util/probe-event.h           |    1 +
 4 files changed, 99 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 86b797a..fcc51fe 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -73,6 +73,10 @@ OPTIONS
 	(Only for --vars) Show external defined variables in addition to local
 	variables.
 
+-F::
+--funcs::
+	Show available functions in given module or kernel.
+
 -f::
 --force::
 	Forcibly add events with existing name.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index add163c..6cf708a 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -52,6 +52,7 @@ static struct {
 	bool show_lines;
 	bool show_vars;
 	bool show_ext_vars;
+	bool show_funcs;
 	bool mod_events;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
@@ -221,6 +222,8 @@ static const struct option options[] = {
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
 		 "Set how many probe points can be found for a probe."),
+	OPT_BOOLEAN('F', "funcs", &params.show_funcs,
+		    "Show potential probe-able functions."),
 	OPT_END()
 };
 
@@ -246,7 +249,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		params.max_probe_points = MAX_PROBES;
 
 	if ((!params.nevents && !params.dellist && !params.list_events &&
-	     !params.show_lines))
+	     !params.show_lines && !params.show_funcs))
 		usage_with_options(probe_usage, options);
 
 	/*
@@ -267,12 +270,36 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_err(" Error: Don't use --list with --vars.\n");
 			usage_with_options(probe_usage, options);
 		}
+		if (params.show_funcs) {
+			pr_err("  Error: Don't use --list with --funcs.\n");
+			usage_with_options(probe_usage, options);
+		}
 		ret = show_perf_probe_events();
 		if (ret < 0)
 			pr_err("  Error: Failed to show event list. (%d)\n",
 			       ret);
 		return ret;
 	}
+	if (params.show_funcs) {
+		if (params.nevents != 0 || params.dellist) {
+			pr_err("  Error: Don't use --funcs with"
+			       " --add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
+		if (params.show_lines) {
+			pr_err("  Error: Don't use --funcs with --line.\n");
+			usage_with_options(probe_usage, options);
+		}
+		if (params.show_vars) {
+			pr_err("  Error: Don't use --funcs with --vars.\n");
+			usage_with_options(probe_usage, options);
+		}
+		ret = show_available_funcs(params.target_module);
+		if (ret < 0)
+			pr_err("  Error: Failed to show functions."
+			       " (%d)\n", ret);
+		return ret;
+	}
 
 #ifdef DWARF_SUPPORT
 	if (params.show_lines) {
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 6e29d9c..859d377 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -31,6 +31,7 @@
 #include <string.h>
 #include <stdarg.h>
 #include <limits.h>
+#include <elf.h>
 
 #undef _GNU_SOURCE
 #include "util.h"
@@ -111,7 +112,25 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
 						     NULL);
 }
 
-const char *kernel_get_module_path(const char *module)
+static struct map *kernel_get_module_map(const char *module)
+{
+	struct rb_node *nd;
+	struct map_groups *grp = &machine.kmaps;
+
+	if (!module)
+		module = "kernel";
+
+	for (nd = rb_first(&grp->maps[MAP__FUNCTION]); nd; nd = rb_next(nd)) {
+		struct map *pos = rb_entry(nd, struct map, rb_node);
+		if (strncmp(pos->dso->short_name + 1, module,
+			    pos->dso->short_name_len - 2) == 0) {
+			return pos;
+		}
+	}
+	return NULL;
+}
+
+static struct dso *kernel_get_module_dso(const char *module)
 {
 	struct dso *dso;
 	struct map *map;
@@ -141,7 +160,13 @@ const char *kernel_get_module_path(const char *module)
 		}
 	}
 found:
-	return dso->long_name;
+	return dso;
+}
+
+const char *kernel_get_module_path(const char *module)
+{
+	struct dso *dso = kernel_get_module_dso(module);
+	return (dso) ? dso->long_name : NULL;
 }
 
 #ifdef DWARF_SUPPORT
@@ -1913,3 +1938,42 @@ int del_perf_probe_events(struct strlist *dellist)
 	return ret;
 }
 
+/*
+ * If a symbol corresponds to a function with global binding return 0.
+ * For all others return 1.
+ */
+static int filter_non_global_functions(struct map *map __unused,
+					struct symbol *sym)
+{
+	if (sym->binding != STB_GLOBAL)
+		return 1;
+
+	return 0;
+}
+
+int show_available_funcs(const char *module)
+{
+	struct map *map;
+	int ret;
+
+	setup_pager();
+
+	ret = init_vmlinux();
+	if (ret < 0)
+		return ret;
+
+	map = kernel_get_module_map(module);
+	if (!map) {
+		pr_err("Failed to find %s map.\n", (module) ? : "kernel");
+		return -EINVAL;
+	}
+	if (map__load(map, filter_non_global_functions)) {
+		pr_err("Failed to load map.\n");
+		return -EINVAL;
+	}
+	if (!dso__sorted_by_name(map->dso, map->type))
+		dso__sort_by_name(map->dso, map->type);
+
+	dso__fprintf_symbols_by_name(map->dso, map->type, stdout);
+	return 0;
+}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 5accbed..1fb4f18 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -127,6 +127,7 @@ extern int show_line_range(struct line_range *lr, const char *module);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
 			       int max_probe_points, const char *module,
 			       bool externs);
+extern int show_available_funcs(const char *module);
 
 
 /* Maximum index number of event-name postfix */
-- 
1.6.2.5

