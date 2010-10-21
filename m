Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446Ab0JUKMs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:12:48 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:42057 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab0JUKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:12:13 -0400
X-AuditID: b753bd60-a74ceba000005dcc-fb-4cc011fa3942
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  7/7] perf probe: Add basic module support
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 21 Oct 2010 19:13:41 +0900
Message-ID: <20101021101341.3542.71638.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add basic module probe support on perf probe. This introduces
"--module <MODNAME>" option to perf probe for putting probes
and showing lines and variables in the given module.

Currently, this supports only probing on running modules.
Supporting off-line module probing is the next step.

e.g.)
[show lines]
 # ./perf probe --module drm -L drm_vblank_info
<drm_vblank_info:0>
      0  int drm_vblank_info(struct seq_file *m, void *data)
      1  {
                struct drm_info_node *node = (struct drm_info_node *) m->private
      3         struct drm_device *dev = node->minor->dev;
 ...
[show vars]
 # ./perf probe --module drm -V drm_vblank_info:3
Available variables at drm_vblank_info:3
        @<drm_vblank_info+20>
                (unknown_type)  data
                struct drm_info_node*   node
                struct seq_file*        m
[put a probe]
 # ./perf probe --module drm drm_vblank_info:3 node m
Add new event:
  probe:drm_vblank_info (on drm_vblank_info:3 with node m)

You can now use it on all perf tools, such as:

        perf record -e probe:drm_vblank_info -aR sleep 1
[list probes]
 # ./perf probe -l
probe:drm_vblank_info (on drm_vblank_info:3@drivers/gpu/drm/drm_info.c with ...

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Documentation/perf-probe.txt |    9 ++
 tools/perf/builtin-probe.c              |   11 ++
 tools/perf/util/map.h                   |   10 ++
 tools/perf/util/probe-event.c           |  123 +++++++++++++++++----------
 tools/perf/util/probe-event.h           |   10 ++
 tools/perf/util/probe-finder.c          |  142 ++++++++++++++++++++++++++++---
 tools/perf/util/probe-finder.h          |    3 -
 7 files changed, 239 insertions(+), 69 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 148c178..62de1b7 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -16,9 +16,9 @@ or
 or
 'perf probe' --list
 or
-'perf probe' --line='FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]'
+'perf probe' [options] --line='FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]'
 or
-'perf probe' [--externs] --vars='PROBEPOINT'
+'perf probe' [options] --vars='PROBEPOINT'
 
 DESCRIPTION
 -----------
@@ -33,6 +33,11 @@ OPTIONS
 --vmlinux=PATH::
 	Specify vmlinux path which has debuginfo (Dwarf binary).
 
+-m::
+--module=MODNAME::
+	Specify module name in which perf-probe searches probe points
+	or lines.
+
 -s::
 --source=PATH::
 	Specify path to kernel source.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index bdf60cf..2e000c0 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -57,6 +57,7 @@ static struct {
 	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
 	struct line_range line_range;
+	const char *target_module;
 	int max_probe_points;
 } params;
 
@@ -162,8 +163,8 @@ static const char * const probe_usage[] = {
 	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
 #ifdef DWARF_SUPPORT
-	"perf probe --line 'LINEDESC'",
-	"perf probe [--externs] --vars 'PROBEPOINT'",
+	"perf probe [<options>] --line 'LINEDESC'",
+	"perf probe [<options>] --vars 'PROBEPOINT'",
 #endif
 	NULL
 };
@@ -214,6 +215,8 @@ static const struct option options[] = {
 		   "file", "vmlinux pathname"),
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
 		   "directory", "path to kernel source"),
+	OPT_STRING('m', "module", &params.target_module,
+		   "modname", "target module name"),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
@@ -278,7 +281,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(probe_usage, options);
 		}
 
-		ret = show_line_range(&params.line_range);
+		ret = show_line_range(&params.line_range, params.target_module);
 		if (ret < 0)
 			pr_err("  Error: Failed to show lines. (%d)\n", ret);
 		return ret;
@@ -291,6 +294,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		}
 		ret = show_available_vars(params.events, params.nevents,
 					  params.max_probe_points,
+					  params.target_module,
 					  params.show_ext_vars);
 		if (ret < 0)
 			pr_err("  Error: Failed to show vars. (%d)\n", ret);
@@ -310,6 +314,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	if (params.nevents) {
 		ret = add_perf_probe_events(params.events, params.nevents,
 					    params.max_probe_points,
+					    params.target_module,
 					    params.force_add);
 		if (ret < 0) {
 			pr_err("  Error: Failed to add events. (%d)\n", ret);
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 7857579..b397c03 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -215,6 +215,16 @@ struct symbol *map_groups__find_function_by_name(struct map_groups *self,
 	return map_groups__find_symbol_by_name(self, MAP__FUNCTION, name, mapp, filter);
 }
 
+static inline
+struct symbol *machine__find_kernel_function_by_name(struct machine *self,
+						     const char *name,
+						     struct map **mapp,
+						     symbol_filter_t filter)
+{
+	return map_groups__find_function_by_name(&self->kmaps, name, mapp,
+						 filter);
+}
+
 int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 				   int verbose, FILE *fp);
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 1b462cc..79ef201 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -74,10 +74,9 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
 static struct machine machine;
 
-/* Initialize symbol maps and path of vmlinux */
+/* Initialize symbol maps and path of vmlinux/modules */
 static int init_vmlinux(void)
 {
-	struct dso *kernel;
 	int ret;
 
 	symbol_conf.sort_by_name = true;
@@ -91,33 +90,61 @@ static int init_vmlinux(void)
 		goto out;
 	}
 
-	ret = machine__init(&machine, "/", 0);
+	ret = machine__init(&machine, "", HOST_KERNEL_ID);
 	if (ret < 0)
 		goto out;
 
-	kernel = dso__new_kernel(symbol_conf.vmlinux_name);
-	if (kernel == NULL)
-		die("Failed to create kernel dso.");
-
-	ret = __machine__create_kernel_maps(&machine, kernel);
-	if (ret < 0)
-		pr_debug("Failed to create kernel maps.\n");
-
+	if (machine__create_kernel_maps(&machine) < 0) {
+		pr_debug("machine__create_kernel_maps ");
+		goto out;
+	}
 out:
 	if (ret < 0)
 		pr_warning("Failed to init vmlinux path.\n");
 	return ret;
 }
 
+static struct symbol *__find_kernel_function_by_name(const char *name,
+						     struct map **mapp)
+{
+	return machine__find_kernel_function_by_name(&machine, name, mapp,
+						     NULL);
+}
+
+const char *kernel_get_module_path(const char *module)
+{
+	struct dso *dso;
+
+	if (module) {
+		list_for_each_entry(dso, &machine.kernel_dsos, node) {
+			if (strncmp(dso->short_name + 1, module,
+				    dso->short_name_len - 2) == 0)
+				goto found;
+		}
+		pr_debug("Failed to find module %s.\n", module);
+		return NULL;
+	} else {
+		dso = machine.vmlinux_maps[MAP__FUNCTION]->dso;
+		if (dso__load_vmlinux_path(dso,
+			 machine.vmlinux_maps[MAP__FUNCTION], NULL) < 0) {
+			pr_debug("Failed to load kernel map.\n");
+			return NULL;
+		}
+	}
+found:
+	return dso->long_name;
+}
+
 #ifdef DWARF_SUPPORT
-static int open_vmlinux(void)
+static int open_vmlinux(const char *module)
 {
-	if (map__load(machine.vmlinux_maps[MAP__FUNCTION], NULL) < 0) {
-		pr_debug("Failed to load kernel map.\n");
-		return -EINVAL;
+	const char *path = kernel_get_module_path(module);
+	if (!path) {
+		pr_err("Failed to find path of %s module", module ?: "kernel");
+		return -ENOENT;
 	}
-	pr_debug("Try to open %s\n", machine.vmlinux_maps[MAP__FUNCTION]->dso->long_name);
-	return open(machine.vmlinux_maps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
+	pr_debug("Try to open %s\n", path);
+	return open(path, O_RDONLY);
 }
 
 /*
@@ -125,20 +152,19 @@ static int open_vmlinux(void)
  * Currently only handles kprobes.
  */
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-				       struct perf_probe_point *pp)
+					struct perf_probe_point *pp)
 {
 	struct symbol *sym;
-	int fd, ret = -ENOENT;
+	struct map *map;
+	u64 addr;
+	int ret = -ENOENT;
 
-	sym = map__find_symbol_by_name(machine.vmlinux_maps[MAP__FUNCTION],
-				       tp->symbol, NULL);
+	sym = __find_kernel_function_by_name(tp->symbol, &map);
 	if (sym) {
-		fd = open_vmlinux();
-		if (fd >= 0) {
-			ret = find_perf_probe_point(fd,
-						 sym->start + tp->offset, pp);
-			close(fd);
-		}
+		addr = map->unmap_ip(map, sym->start + tp->offset);
+		pr_debug("try to find %s+%ld@%llx\n", tp->symbol,
+			 tp->offset, addr);
+		ret = find_perf_probe_point((unsigned long)addr, pp);
 	}
 	if (ret <= 0) {
 		pr_debug("Failed to find corresponding probes from "
@@ -156,12 +182,12 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 /* Try to find perf_probe_event with debuginfo */
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 					   struct probe_trace_event **tevs,
-					   int max_tevs)
+					   int max_tevs, const char *module)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
 	int fd, ntevs;
 
-	fd = open_vmlinux();
+	fd = open_vmlinux(module);
 	if (fd < 0) {
 		if (need_dwarf) {
 			pr_warning("Failed to open debuginfo file.\n");
@@ -300,7 +326,7 @@ error:
  * Show line-range always requires debuginfo to find source file and
  * line number.
  */
-int show_line_range(struct line_range *lr)
+int show_line_range(struct line_range *lr, const char *module)
 {
 	int l = 1;
 	struct line_node *ln;
@@ -313,7 +339,7 @@ int show_line_range(struct line_range *lr)
 	if (ret < 0)
 		return ret;
 
-	fd = open_vmlinux();
+	fd = open_vmlinux(module);
 	if (fd < 0) {
 		pr_warning("Failed to open debuginfo file.\n");
 		return fd;
@@ -421,7 +447,7 @@ static int show_available_vars_at(int fd, struct perf_probe_event *pev,
 
 /* Show available variables on given probe point */
 int show_available_vars(struct perf_probe_event *pevs, int npevs,
-			int max_vls, bool externs)
+			int max_vls, const char *module, bool externs)
 {
 	int i, fd, ret = 0;
 
@@ -429,7 +455,7 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	if (ret < 0)
 		return ret;
 
-	fd = open_vmlinux();
+	fd = open_vmlinux(module);
 	if (fd < 0) {
 		pr_warning("Failed to open debuginfo file.\n");
 		return fd;
@@ -447,8 +473,15 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 #else	/* !DWARF_SUPPORT */
 
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
-				       struct perf_probe_point *pp)
+					struct perf_probe_point *pp)
 {
+	struct symbol *sym;
+
+	sym = __find_kernel_function_by_name(tp->symbol, NULL);
+	if (!sym) {
+		pr_err("Failed to find symbol %s in kernel.\n", tp->symbol);
+		return -ENOENT;
+	}
 	pp->function = strdup(tp->symbol);
 	if (pp->function == NULL)
 		return -ENOMEM;
@@ -460,7 +493,7 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 				struct probe_trace_event **tevs __unused,
-				int max_tevs __unused)
+				int max_tevs __unused, const char *mod __unused)
 {
 	if (perf_probe_event_need_dwarf(pev)) {
 		pr_warning("Debuginfo-analysis is not supported.\n");
@@ -469,14 +502,15 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 	return 0;
 }
 
-int show_line_range(struct line_range *lr __unused)
+int show_line_range(struct line_range *lr __unused, const char *module __unused)
 {
 	pr_warning("Debuginfo-analysis is not supported.\n");
 	return -ENOSYS;
 }
 
 int show_available_vars(struct perf_probe_event *pevs __unused,
-			int npevs __unused, int max_probe_points __unused)
+			int npevs __unused, int max_vls __unused,
+			const char *module __unused, bool externs __unused)
 {
 	pr_warning("Debuginfo-analysis is not supported.\n");
 	return -ENOSYS;
@@ -1159,7 +1193,7 @@ error:
 }
 
 static int convert_to_perf_probe_event(struct probe_trace_event *tev,
-				struct perf_probe_event *pev)
+				       struct perf_probe_event *pev)
 {
 	char buf[64] = "";
 	int i, ret;
@@ -1588,14 +1622,14 @@ static int __add_probe_trace_events(struct perf_probe_event *pev,
 
 static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 					  struct probe_trace_event **tevs,
-					  int max_tevs)
+					  int max_tevs, const char *module)
 {
 	struct symbol *sym;
 	int ret = 0, i;
 	struct probe_trace_event *tev;
 
 	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs);
+	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, module);
 	if (ret != 0)
 		return ret;
 
@@ -1644,8 +1678,7 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 	}
 
 	/* Currently just checking function name from symbol map */
-	sym = map__find_symbol_by_name(machine.vmlinux_maps[MAP__FUNCTION],
-				       tev->point.symbol, NULL);
+	sym = __find_kernel_function_by_name(tev->point.symbol, NULL);
 	if (!sym) {
 		pr_warning("Kernel symbol \'%s\' not found.\n",
 			   tev->point.symbol);
@@ -1668,7 +1701,7 @@ struct __event_package {
 };
 
 int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
-			  int max_tevs, bool force_add)
+			  int max_tevs, const char *module, bool force_add)
 {
 	int i, j, ret;
 	struct __event_package *pkgs;
@@ -1689,7 +1722,9 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 		pkgs[i].pev = &pevs[i];
 		/* Convert with or without debuginfo */
 		ret  = convert_to_probe_trace_events(pkgs[i].pev,
-						      &pkgs[i].tevs, max_tevs);
+						     &pkgs[i].tevs,
+						     max_tevs,
+						     module);
 		if (ret < 0)
 			goto end;
 		pkgs[i].ntevs = ret;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index c74b1fd..5accbed 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -115,14 +115,18 @@ extern void clear_perf_probe_event(struct perf_probe_event *pev);
 /* Command string to line-range */
 extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
+/* Internal use: Return kernel/module path */
+extern const char *kernel_get_module_path(const char *module);
 
 extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
-				 int max_probe_points, bool force_add);
+				 int max_probe_points, const char *module,
+				 bool force_add);
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
-extern int show_line_range(struct line_range *lr);
+extern int show_line_range(struct line_range *lr, const char *module);
 extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
-			       int max_probe_points, bool externs);
+			       int max_probe_points, const char *module,
+			       bool externs);
 
 
 /* Maximum index number of event-name postfix */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a274fd0..c20bd52 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -116,6 +116,101 @@ static void line_list__free(struct list_head *head)
 	}
 }
 
+/* Dwarf FL wrappers */
+
+static int __linux_kernel_find_elf(Dwfl_Module *mod,
+				   void **userdata,
+				   const char *module_name,
+				   Dwarf_Addr base,
+				   char **file_name, Elf **elfp)
+{
+	int fd;
+	const char *path = kernel_get_module_path(module_name);
+
+	if (path) {
+		fd = open(path, O_RDONLY);
+		if (fd >= 0) {
+			*file_name = strdup(path);
+			return fd;
+		}
+	}
+	/* If failed, try to call standard method */
+	return dwfl_linux_kernel_find_elf(mod, userdata, module_name, base,
+					  file_name, elfp);
+}
+
+static char *debuginfo_path;	/* Currently dummy */
+
+static const Dwfl_Callbacks offline_callbacks = {
+	.find_debuginfo = dwfl_standard_find_debuginfo,
+	.debuginfo_path = &debuginfo_path,
+
+	.section_address = dwfl_offline_section_address,
+
+	/* We use this table for core files too.  */
+	.find_elf = dwfl_build_id_find_elf,
+};
+
+static const Dwfl_Callbacks kernel_callbacks = {
+	.find_debuginfo = dwfl_standard_find_debuginfo,
+	.debuginfo_path = &debuginfo_path,
+
+	.find_elf = __linux_kernel_find_elf,
+	.section_address = dwfl_linux_kernel_module_section_address,
+};
+
+/* Get a Dwarf from offline image */
+static Dwarf *dwfl_init_offline_dwarf(int fd, Dwfl **dwflp, Dwarf_Addr *bias)
+{
+	Dwfl_Module *mod;
+	Dwarf *dbg = NULL;
+
+	if (!dwflp)
+		return NULL;
+
+	*dwflp = dwfl_begin(&offline_callbacks);
+	if (!*dwflp)
+		return NULL;
+
+	mod = dwfl_report_offline(*dwflp, "", "", fd);
+	if (!mod)
+		goto error;
+
+	dbg = dwfl_module_getdwarf(mod, bias);
+	if (!dbg) {
+error:
+		dwfl_end(*dwflp);
+		*dwflp = NULL;
+	}
+	return dbg;
+}
+
+/* Get a Dwarf from live kernel image */
+static Dwarf *dwfl_init_live_kernel_dwarf(Dwarf_Addr addr, Dwfl **dwflp,
+					  Dwarf_Addr *bias)
+{
+	Dwarf *dbg;
+
+	if (!dwflp)
+		return NULL;
+
+	*dwflp = dwfl_begin(&kernel_callbacks);
+	if (!*dwflp)
+		return NULL;
+
+	/* Load the kernel dwarves: Don't care the result here */
+	dwfl_linux_kernel_report_kernel(*dwflp);
+	dwfl_linux_kernel_report_modules(*dwflp);
+
+	dbg = dwfl_addrdwarf(*dwflp, addr, bias);
+	/* Here, check whether we could get a real dwarf */
+	if (!dbg) {
+		dwfl_end(*dwflp);
+		*dwflp = NULL;
+	}
+	return dbg;
+}
+
 /* Dwarf wrappers */
 
 /* Find the realpath of the target file. */
@@ -1177,10 +1272,12 @@ static int find_probes(int fd, struct probe_finder *pf)
 	Dwarf_Off off, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
-	Dwarf *dbg;
+	Dwarf *dbg = NULL;
+	Dwfl *dwfl;
+	Dwarf_Addr bias;	/* Currently ignored */
 	int ret = 0;
 
-	dbg = dwarf_begin(fd, DWARF_C_READ);
+	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
 	if (!dbg) {
 		pr_warning("No dwarf info found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
@@ -1221,7 +1318,8 @@ static int find_probes(int fd, struct probe_finder *pf)
 		off = noff;
 	}
 	line_list__free(&pf->lcache);
-	dwarf_end(dbg);
+	if (dwfl)
+		dwfl_end(dwfl);
 
 	return ret;
 }
@@ -1412,23 +1510,31 @@ int find_available_vars_at(int fd, struct perf_probe_event *pev,
 }
 
 /* Reverse search */
-int find_perf_probe_point(int fd, unsigned long addr,
-			  struct perf_probe_point *ppt)
+int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
 {
 	Dwarf_Die cudie, spdie, indie;
-	Dwarf *dbg;
+	Dwarf *dbg = NULL;
+	Dwfl *dwfl = NULL;
 	Dwarf_Line *line;
-	Dwarf_Addr laddr, eaddr;
+	Dwarf_Addr laddr, eaddr, bias = 0;
 	const char *tmp;
 	int lineno, ret = 0;
 	bool found = false;
 
-	dbg = dwarf_begin(fd, DWARF_C_READ);
-	if (!dbg)
-		return -EBADF;
+	/* Open the live linux kernel */
+	dbg = dwfl_init_live_kernel_dwarf(addr, &dwfl, &bias);
+	if (!dbg) {
+		pr_warning("No dwarf info found in the vmlinux - "
+			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		ret = -EINVAL;
+		goto end;
+	}
 
+	/* Adjust address with bias */
+	addr += bias;
 	/* Find cu die */
-	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr, &cudie)) {
+	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr - bias, &cudie)) {
+		pr_warning("No CU DIE is found at %lx\n", addr);
 		ret = -EINVAL;
 		goto end;
 	}
@@ -1491,7 +1597,8 @@ found:
 	}
 
 end:
-	dwarf_end(dbg);
+	if (dwfl)
+		dwfl_end(dwfl);
 	if (ret >= 0)
 		ret = found ? 1 : 0;
 	return ret;
@@ -1624,6 +1731,8 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	struct line_finder *lf = param->data;
 	struct line_range *lr = lf->lr;
 
+	pr_debug("find (%lx) %s\n", dwarf_dieoffset(sp_die),
+		 dwarf_diename(sp_die));
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
@@ -1667,10 +1776,12 @@ int find_line_range(int fd, struct line_range *lr)
 	Dwarf_Off off = 0, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
-	Dwarf *dbg;
+	Dwarf *dbg = NULL;
+	Dwfl *dwfl;
+	Dwarf_Addr bias;	/* Currently ignored */
 	const char *comp_dir;
 
-	dbg = dwarf_begin(fd, DWARF_C_READ);
+	dbg = dwfl_init_offline_dwarf(fd, &dwfl, &bias);
 	if (!dbg) {
 		pr_warning("No dwarf info found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
@@ -1716,8 +1827,7 @@ int find_line_range(int fd, struct line_range *lr)
 	}
 
 	pr_debug("path: %s\n", lr->path);
-	dwarf_end(dbg);
-
+	dwfl_end(dwfl);
 	return (ret < 0) ? ret : lf.found;
 }
 
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 516912a..bba69d4 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -22,7 +22,7 @@ extern int find_probe_trace_events(int fd, struct perf_probe_event *pev,
 				    int max_tevs);
 
 /* Find a perf_probe_point from debuginfo */
-extern int find_perf_probe_point(int fd, unsigned long addr,
+extern int find_perf_probe_point(unsigned long addr,
 				 struct perf_probe_point *ppt);
 
 /* Find a line range */
@@ -35,6 +35,7 @@ extern int find_available_vars_at(int fd, struct perf_probe_event *pev,
 
 #include <dwarf.h>
 #include <libdw.h>
+#include <libdwfl.h>
 #include <version.h>
 
 struct probe_finder {

