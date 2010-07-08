Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758170Ab0GHRT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 13:19:58 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:40722 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756855Ab0GHRTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 13:19:55 -0400
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
Date: Thu, 08 Jul 2010 22:42:25 +0530
Message-Id: <20100708171225.29165.28806.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
References: <20100708171003.29165.57615.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv8 2.6.35-rc4-tip 12/12]  perf: Show Potential probe points.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf: Show Potential probe points.

Introduces an option to list potential probes to probe using perf probe
command. Also introduces an option to limit the dso to list the potential
probes. Listing of potential probes is sorted by dso and
alphabetical order.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Show all potential probes in the current running kernel.
# perf probe -S | tail
zone_reclaimable_pages
zone_spanned_pages_in_node
zone_statistics
zone_wait_table_init
zone_watermark_ok
zoneinfo_open
zoneinfo_show
zoneinfo_show_print
zoneref_set_zone
zp_probe

Show all potential probes in a process by pid 21106 across all dsos
# perf probe -S -p 21106 | tail
_nss_files_gethostbyname2_r
_nss_files_gethostbyname_r
_nss_files_gethostent_r
_nss_files_gethostton_r
_nss_files_getnetbyaddr_r
_nss_files_getnetbyname_r
_nss_files_getnetent_r
_nss_files_getnetgrent_r
_nss_files_getntohost_r
_nss_files_getpr

Show all potentail probes in a process by pid 21106 limit to libc.so dso.
# perf probe -S -p 21106 -D zsh | tail
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

 tools/perf/builtin-probe.c    |   40 +++++++++++++++++++
 tools/perf/util/map.h         |    2 +
 tools/perf/util/probe-event.c |   85 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-event.h |    1 
 tools/perf/util/symbol.c      |   38 ++++++++++++++++++
 tools/perf/util/symbol.h      |    1 
 6 files changed, 165 insertions(+), 2 deletions(-)


diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index cb915a5..6de3236 100644
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
 	pid_t upid;
@@ -134,6 +136,17 @@ static int opt_show_lines(const struct option *opt __used,
 }
 #endif
 
+static int opt_limit_dsos(const struct option *opt __used,
+			       const char *str, int unset __used)
+{
+	if (str) {
+		if (!params.limitlist)
+			params.limitlist = strlist__new(true, NULL);
+		strlist__add(params.limitlist, str);
+	}
+	return 0;
+}
+
 static const char * const probe_usage[] = {
 	"perf probe [<options>] 'PROBEDEF' ['PROBEDEF' ...]",
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
@@ -192,6 +205,10 @@ static const struct option options[] = {
 		 "Set how many probe points can be found for a probe."),
 	OPT_INTEGER('p', "pid", &params.upid,
 			"specify a pid for a uprobes based probe"),
+	OPT_BOOLEAN('S', "show_functions", &params.list_functions,
+				"Show potential probes."),
+	OPT_CALLBACK('D', "limit_dsos", NULL, "DSO",
+				"Limit Dsos.", opt_limit_dsos),
 	OPT_END()
 };
 
@@ -217,7 +234,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		params.max_probe_points = MAX_PROBES;
 
 	if ((!params.nevents && !params.dellist && !params.list_events &&
-	     !params.show_lines))
+	     !params.show_lines && !params.list_functions))
 		usage_with_options(probe_usage, options);
 
 	if (params.list_events) {
@@ -233,12 +250,33 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_warning("  Error: Don't use --list with --pid.\n");
 			usage_with_options(probe_usage, options);
 		}
+		if (params.list_functions) {
+			pr_warning("  Error: Don't use --list with --show_functions.\n");
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
+					"--add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
+		if (params.show_lines) {
+			pr_err("  Error: Don't use --show_functions with"
+					"--line.\n");
+			usage_with_options(probe_usage, options);
+		}
+		ret = show_possible_probes(params.limitlist, params.upid);
+		if (ret < 0)
+			pr_err("  Error: Failed to show possible"
+					"probes (%d).\n", ret);
+		return ret;
+	}
 
 #ifdef DWARF_SUPPORT
 	if (params.show_lines && !params.upid) {
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index f391345..b7dedcd 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -210,6 +210,8 @@ int map_groups__fixup_overlappings(struct map_groups *self, struct map *map,
 
 struct map *map_groups__find_by_name(struct map_groups *self,
 				     enum map_type type, const char *name);
+int map_groups__iterate_maps(struct map_groups *self, enum map_type type,
+		const char *name, int (*fn)(struct map*, const char *));
 struct map *machine__new_module(struct machine *self, u64 start, const char *filename);
 
 void map_groups__flush(struct map_groups *self);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index e9bff13..235858a 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1842,7 +1842,6 @@ int del_perf_probe_events(struct strlist *dellist, pid_t pid)
 	struct str_node *ent;
 	struct strlist *namelist = NULL, *unamelist = NULL;
 
-
 	/* Get current event names */
 	if (!pid) {
 		kfd = open_kprobe_events(true);
@@ -1907,3 +1906,87 @@ error:
 	}
 	return ret;
 }
+
+static int print_list_available_symbols(struct map *map,
+					const char *name __unused)
+{
+	if (map__load(map, NULL) < 0)
+		return -EINVAL;
+	if (!dso__sorted_by_name(map->dso, map->type))
+		dso__sort_by_name(map->dso, map->type);
+
+	dso__list_available_symbols(map->dso, map->type);
+	return 0;
+}
+
+int show_possible_probes(struct strlist *limitlist, pid_t pid)
+{
+	struct perf_session *session;
+	struct thread *thread;
+	struct str_node *ent;
+	struct map *map = NULL;
+	char *name, *str;
+	int ret = -EINVAL;
+
+	if (!pid) {
+		ret = init_vmlinux();
+		if (ret < 0)
+			return ret;
+		return print_list_available_symbols(
+				machine.vmlinux_maps[MAP__FUNCTION], NULL);
+	}
+
+	session = perf_session__new(NULL, O_WRONLY, false, false);
+	if (!session) {
+		ret = -ENOMEM;
+		goto out_delete;
+	}
+
+	symbol_conf.sort_by_name = true;
+	symbol_conf.try_vmlinux_path = false;
+	if (symbol__init() < 0)
+		semantic_error("Cannot initialize symbols.");
+
+	event__synthesize_thread(pid, event__process, session);
+
+	thread = perf_session__findnew(session, pid);
+	if (!thread)
+		goto out_delete;
+
+	if (!limitlist)
+		ret = map_groups__iterate_maps(&thread->mg,
+				MAP__FUNCTION, NULL,
+				print_list_available_symbols);
+	strlist__for_each(ent, limitlist) {
+		str = strdup(ent->s);
+		if (!str) {
+			ret = -ENOMEM;
+			goto out_delete;
+		}
+
+		name = basename(make_absolute_path(str));
+		if (!name) {
+			pr_warning("Skip probe listing in %s DSO.", str);
+			free(str);
+			continue;
+		}
+		map = map_groups__find_by_name(&thread->mg,
+						MAP__FUNCTION, name);
+		if (!map) {
+			pr_warning("Skip probe listing in %s DSO.", str);
+			free(str);
+			continue;
+		}
+		ret = print_list_available_symbols(map, NULL);
+		if (ret)
+			pr_warning("Unknown dso %s .\n", str);
+		free(str);
+	}
+
+out_delete:
+	if (ret)
+		pr_warning("Failed to list available probes.\n");
+	if (session)
+		perf_session__delete(session);
+	return ret;
+}
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index f69f98e..a7a6a86 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -116,6 +116,7 @@ extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 extern int del_perf_probe_events(struct strlist *dellist, pid_t pid);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
+extern int show_possible_probes(struct strlist *availlist, pid_t pid);
 
 
 /* Maximum index number of event-name postfix */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 971d0a0..18bb1d8 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1448,6 +1448,28 @@ struct map *map_groups__find_by_name(struct map_groups *self,
 	return NULL;
 }
 
+int map_groups__iterate_maps(struct map_groups *self, enum map_type type,
+			const char *name, int (*fn)(struct map*, const char *))
+{
+	struct rb_node *nd;
+	struct map *map;
+	int ret;
+
+	if (!fn)
+		return -EINVAL;
+
+	for (nd = rb_first(&self->maps[type]); nd; nd = rb_next(nd)) {
+		map = rb_entry(nd, struct map, rb_node);
+		if (!map)
+			return -EINVAL;
+
+		ret = fn(map, name);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 static int dso__kernel_module_get_build_id(struct dso *self,
 				const char *root_dir)
 {
@@ -2343,3 +2365,19 @@ int machine__load_vmlinux_path(struct machine *self, enum map_type type,
 
 	return ret;
 }
+
+void dso__list_available_symbols(struct dso *self, enum map_type type)
+{
+	struct rb_root *rb;
+	struct rb_node *nd;
+	struct symbol_name_rb_node *pos;
+
+	if (!self)
+		return;
+
+	rb = &self->symbol_names[type];
+	for (nd = rb_first(&self->symbol_names[type]); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
+		printf("%s\n", pos->sym.name);
+	}
+}
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 80e569b..04614b0 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -195,6 +195,7 @@ char dso__symtab_origin(const struct dso *self);
 void dso__set_long_name(struct dso *self, char *name);
 void dso__set_build_id(struct dso *self, void *build_id);
 void dso__read_running_kernel_build_id(struct dso *self, struct machine *machine);
+void dso__list_available_symbols(struct dso *self, enum map_type type);
 struct symbol *dso__find_symbol(struct dso *self, enum map_type type, u64 addr);
 struct symbol *dso__find_symbol_by_name(struct dso *self, enum map_type type,
 					const char *name);
