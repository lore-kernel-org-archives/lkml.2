Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756403Ab0G0LNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 07:13:22 -0400
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:34619 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab0G0LNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 07:13:17 -0400
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
        Andrew Morton <akpm@linux-foundation.org>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 27 Jul 2010 16:41:33 +0530
Message-Id: <20100727111133.24690.9828.sendpatchset@localhost6.localdomain6>
In-Reply-To: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
References: <20100727110855.24690.26901.sendpatchset@localhost6.localdomain6>
Subject: [PATCHv10 2.6.35-rc6-tip 13/14]  [RFC] perf: Show Potential probe points.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Introduces an option to list potential probes to probe using perf probe
command. Also introduces an option to limit the dso to list the potential
probes. Listing of potential probes is sorted by dso and
alphabetical order.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

Changelog from V9:
	Filter labels, weak, and local binding functions from listing
as suggested by Christoph Hellwig.
	Incorporated comments from Arnaldo on Version 9 of patchset.

Show all potential probes in the current running kernel and limit to
the last 10 functions.
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

Show all potential probes in a process by pid 3104 across all dsos
and limit to the last 10 functions.
# perf probe -S -p 3104 | tail
_nss_files_setgrent
_nss_files_sethostent
_nss_files_setnetent
_nss_files_setnetgrent
_nss_files_setprotoent
_nss_files_setpwent
_nss_files_setrpcent
_nss_files_setservent
_nss_files_setspent
_nss_netgroup_parseline

Show all potentail probes in a process by pid 3104 limit to zsh dso
and limit to the last 10 functions.
# perf probe -S -p 3104 -D zsh | tail
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

 tools/perf/builtin-probe.c    |   45 ++++++++++++++++-
 tools/perf/util/map.h         |   27 ++++++++++
 tools/perf/util/probe-event.c |  109 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/probe-event.h |    1 
 tools/perf/util/symbol.c      |   14 +++++
 tools/perf/util/symbol.h      |    1 
 6 files changed, 194 insertions(+), 3 deletions(-)


diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index cb915a5..e8af545 100644
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
@@ -134,6 +136,19 @@ static int opt_show_lines(const struct option *opt __used,
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
@@ -192,6 +207,10 @@ static const struct option options[] = {
 		 "Set how many probe points can be found for a probe."),
 	OPT_INTEGER('p', "pid", &params.upid,
 			"specify a pid for a uprobes based probe"),
+	OPT_BOOLEAN('S', "show_functions", &params.list_functions,
+				"Show potential probes."),
+	OPT_CALLBACK('D', "limit_dsos", NULL, "DSO",
+				"Limit Dsos.", opt_limit_dsos),
 	OPT_END()
 };
 
@@ -217,7 +236,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		params.max_probe_points = MAX_PROBES;
 
 	if ((!params.nevents && !params.dellist && !params.list_events &&
-	     !params.show_lines))
+	     !params.show_lines && !params.list_functions))
 		usage_with_options(probe_usage, options);
 
 	if (params.list_events) {
@@ -233,18 +252,40 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_warning("  Error: Don't use --list with --pid.\n");
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
+		ret = show_possible_probes(params.limitlist, params.upid);
+		if (ret < 0)
+			pr_err("  Error: Failed to show possible"
+					" probes (%d).\n", ret);
+		return ret;
+	}
 
 #ifdef DWARF_SUPPORT
 	if (params.show_lines && !params.upid) {
 		if (params.nevents != 0 || params.dellist) {
 			pr_warning("  Error: Don't use --line with"
-				   " --add/--del.\n");
+						" --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
 
diff --git a/tools/perf/util/map.h b/tools/perf/util/map.h
index 1fcde24..6c6664a 100644
--- a/tools/perf/util/map.h
+++ b/tools/perf/util/map.h
@@ -54,6 +54,33 @@ struct map_groups {
 	struct machine	 *machine;
 };
 
+/* For map_groups iteration */
+static inline struct map *map__first(struct map_groups *self,
+						enum map_type type)
+{
+	struct rb_node *rn = rb_first(&self->maps[type]);
+	return rn ? rb_entry(rn, struct map, rb_node) : NULL;
+}
+
+static inline struct map *map__next(struct map *map)
+{
+	struct rb_node *rn;
+	if (!map)
+		return NULL;
+	rn = rb_next(&map->rb_node);
+	return rn ? rb_entry(rn, struct map, rb_node) : NULL;
+}
+
+/**
+ * map_groups__for_each_map      - iterate over a strlist
+ * @pos:	the &struct map to use as a loop cursor.
+ * @type:	the map type.
+ * @self:	the &struct map_groups for loop.
+ */
+#define map_groups__for_each_map(pos, type, self)	\
+	for (pos = map__first(self, type); pos;		\
+				pos = map__next(pos))
+
 /* Native host kernel uses -1 as pid index in machine */
 #define	HOST_KERNEL_ID			(-1)
 #define	DEFAULT_GUEST_KERNEL_ID		(0)
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 20aeb35..d0636e1 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -47,6 +47,7 @@
 #include "probe-event.h"
 #include "probe-finder.h"
 #include "session.h"
+#include <gelf.h>
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -1918,7 +1919,6 @@ int del_perf_probe_events(struct strlist *dellist, pid_t pid)
 	struct str_node *ent;
 	struct strlist *namelist = NULL, *unamelist = NULL;
 
-
 	/* Get current event names */
 	if (!pid) {
 		kfd = open_kprobe_events(true);
@@ -1983,3 +1983,110 @@ error:
 	}
 	return ret;
 }
+
+/*
+ * If a symbol corresponds to a function with global binding return 0.
+ * For all others return 1.
+ */
+static int filter_non_global_functions(struct map *map __unused,
+		struct symbol *sym __unused, GElf_Sym *gsym)
+{
+
+	if (!gsym || !gsym->st_value)
+		return 1;
+
+	if (GELF_ST_TYPE(gsym->st_info) != STT_FUNC)
+		return 1;
+
+	if (GELF_ST_BIND(gsym->st_info) != STB_GLOBAL)
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
+int show_possible_probes(struct strlist *limitlist, pid_t pid)
+{
+	struct perf_session *session;
+	struct thread *thread;
+	struct str_node *ent;
+	struct map *map = NULL;
+	char *name = NULL, *tmpname = NULL, *str;
+	int ret = -EINVAL;
+
+	if (!pid) {
+		ret = init_vmlinux();
+		if (ret < 0)
+			return ret;
+		return print_list_available_symbols(
+				machine.vmlinux_maps[MAP__FUNCTION], NULL);
+	} else {
+		ret = init_perf_uprobes();
+		if (ret < 0)
+			return ret;
+	}
+	session = perf_session__new(NULL, O_WRONLY, false, false);
+	if (!session) {
+		ret = -ENOMEM;
+		goto out_delete;
+	}
+	event__synthesize_thread(pid, event__process, session);
+
+	thread = perf_session__findnew(session, pid);
+	if (!thread)
+		goto out_delete;
+
+	if (!limitlist) {
+		map_groups__for_each_map(map, MAP__FUNCTION, &thread->mg) {
+			ret = print_list_available_symbols(map, NULL);
+			if (ret)
+				pr_warning("No Symbols in dso %s.\n",
+							map->dso->short_name);
+		}
+		goto out_delete;
+	}
+	strlist__for_each(ent, limitlist) {
+		str = strdup(ent->s);
+		if (!str) {
+			ret = -ENOMEM;
+			goto out_delete;
+		}
+
+		tmpname = realpath(str, NULL);
+		if (tmpname)
+			name = basename(tmpname);
+		if (!name)
+			name = str;
+		map = map_groups__find_by_name(&thread->mg,
+						MAP__FUNCTION, name);
+		if (tmpname)
+			free(tmpname);
+		if (!map) {
+			pr_warning("Skip probe listing in %s DSO.", str);
+			free(str);
+			continue;
+		}
+		ret = print_list_available_symbols(map, NULL);
+		if (ret)
+			pr_warning("No Symbols in dso %s.\n", str);
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
index 27f052c..0c0b0f8 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -117,6 +117,7 @@ extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 extern int del_perf_probe_events(struct strlist *dellist, pid_t pid);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
+extern int show_possible_probes(struct strlist *availlist, pid_t pid);
 
 
 /* Maximum index number of event-name postfix */
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 38ad5c9..674b95a 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -370,6 +370,20 @@ size_t dso__fprintf_buildid(struct dso *self, FILE *fp)
 	return fprintf(fp, "%s", sbuild_id);
 }
 
+size_t dso__fprintf_symbols(struct dso *self, enum map_type type, FILE *fp)
+{
+	size_t ret = 0;
+	struct rb_node *nd;
+	struct symbol_name_rb_node *pos;
+
+	for (nd = rb_first(&self->symbol_names[type]); nd; nd = rb_next(nd)) {
+		pos = rb_entry(nd, struct symbol_name_rb_node, rb_node);
+		fprintf(fp, "%s\n", pos->sym.name);
+	}
+
+	return ret;
+}
+
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp)
 {
 	struct rb_node *nd;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 80e569b..93f1058 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -175,6 +175,7 @@ size_t machines__fprintf_dsos(struct rb_root *self, FILE *fp);
 size_t machines__fprintf_dsos_buildid(struct rb_root *self, FILE *fp, bool with_hits);
 
 size_t dso__fprintf_buildid(struct dso *self, FILE *fp);
+size_t dso__fprintf_symbols(struct dso *self, enum map_type type, FILE *fp);
 size_t dso__fprintf(struct dso *self, enum map_type type, FILE *fp);
 
 enum dso_origin {
