Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752402Ab1AMMvq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:51:46 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39132 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756717Ab1AMMvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:51:41 -0500
X-AuditID: b753bd60-a0361ba000000f65-e1-4d2ef5590559
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 3/6] perf probe: Add --funcs to show available
	functions in symtab
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 21:46:11 +0900
Message-ID: <20110113124611.22426.10835.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110113124548.22426.11201.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add --funcs to show available functions in symtab.
Originally this feature came from Srikar's uprobes patches
( http://lkml.org/lkml/2010/8/27/244 )

e.g.
# ./perf probe --funcs
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

# ./perf probe -m kvm --funcs
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

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Original-patch-from: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/builtin-probe.c    |   29 +++++++++++++++++-
 tools/perf/util/probe-event.c |   67 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/probe-event.h |    1 +
 3 files changed, 94 insertions(+), 3 deletions(-)

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
index 128aaab..1a93756 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -111,7 +111,25 @@ static struct symbol *__find_kernel_function_by_name(const char *name,
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
@@ -141,7 +159,13 @@ const char *kernel_get_module_path(const char *module)
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
@@ -1913,3 +1937,42 @@ int del_perf_probe_events(struct strlist *dellist)
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

