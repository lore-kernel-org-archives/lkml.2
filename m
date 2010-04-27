Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab0D0M7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 08:59:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:41207 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753216Ab0D0M72 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 08:59:28 -0400
Date: Tue, 27 Apr 2010 12:59:01 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, peterz@infradead.org,
       efault@gmx.de, tglx@linutronix.de, mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100421195640.24664.62984.stgit@localhost6.localdomain6>
References: <20100421195640.24664.62984.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Add --max-probes option
Message-ID: <tip-ef4a356574426877d569f8b6579325537eb7909b@git.kernel.org>
Git-Commit-ID: ef4a356574426877d569f8b6579325537eb7909b
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 27 Apr 2010 12:59:02 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ef4a356574426877d569f8b6579325537eb7909b
Gitweb:     http://git.kernel.org/tip/ef4a356574426877d569f8b6579325537eb7909b
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 21 Apr 2010 15:56:40 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 26 Apr 2010 15:35:20 -0300

perf probe: Add --max-probes option

Add --max-probes option to change the maximum limit of
findable probe points per event, since inlined function can be
expanded into thousands of probe points. Default value is 128.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Suggested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20100421195640.24664.62984.stgit@localhost6.localdomain6>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    3 +++
 tools/perf/builtin-probe.c              |    9 ++++++++-
 tools/perf/util/probe-event.c           |   17 ++++++++++-------
 tools/perf/util/probe-event.h           |    4 ++--
 tools/perf/util/probe-finder.c          |   11 ++++++-----
 tools/perf/util/probe-finder.h          |    6 ++++--
 6 files changed, 33 insertions(+), 17 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 63c25d3..94a258c 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -62,6 +62,9 @@ OPTIONS
 	Dry run. With this option, --add and --del doesn't execute actual
 	adding and removal operations.
 
+--max-probes::
+	Set the maximum number of probe points for an event. Default is 128.
+
 PROBE SYNTAX
 ------------
 Probe points are defined by following syntax.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index c1e5403..61c6d70 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -54,6 +54,7 @@ static struct {
 	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
 	struct line_range line_range;
+	int max_probe_points;
 } params;
 
 
@@ -179,6 +180,8 @@ static const struct option options[] = {
 		   "file", "vmlinux pathname"),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
+	OPT_INTEGER('\0', "max-probes", &params.max_probe_points,
+		 "Set how many probe points can be found for a probe."),
 	OPT_END()
 };
 
@@ -200,6 +203,9 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		}
 	}
 
+	if (params.max_probe_points == 0)
+		params.max_probe_points = MAX_PROBES;
+
 	if ((!params.nevents && !params.dellist && !params.list_events &&
 	     !params.show_lines))
 		usage_with_options(probe_usage, options);
@@ -246,7 +252,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	if (params.nevents) {
 		ret = add_perf_probe_events(params.events, params.nevents,
-					    params.force_add);
+					    params.force_add,
+					    params.max_probe_points);
 		if (ret < 0) {
 			pr_err("  Error: Failed to add events. (%d)\n", ret);
 			return ret;
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 5d3baec..9ded38c 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -150,7 +150,8 @@ static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 
 /* Try to find perf_probe_event with debuginfo */
 static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
-					   struct kprobe_trace_event **tevs)
+					   struct kprobe_trace_event **tevs,
+					   int max_tevs)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
 	int fd, ntevs;
@@ -166,7 +167,7 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 	}
 
 	/* Searching trace events corresponding to probe event */
-	ntevs = find_kprobe_trace_events(fd, pev, tevs);
+	ntevs = find_kprobe_trace_events(fd, pev, tevs, max_tevs);
 	close(fd);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
@@ -318,7 +319,8 @@ static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 }
 
 static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
-				struct kprobe_trace_event **tevs __unused)
+				struct kprobe_trace_event **tevs __unused,
+				int max_tevs __unused)
 {
 	if (perf_probe_event_need_dwarf(pev)) {
 		pr_warning("Debuginfo-analysis is not supported.\n");
@@ -1408,14 +1410,15 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 }
 
 static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
-					  struct kprobe_trace_event **tevs)
+					  struct kprobe_trace_event **tevs,
+					  int max_tevs)
 {
 	struct symbol *sym;
 	int ret = 0, i;
 	struct kprobe_trace_event *tev;
 
 	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_kprobe_trace_events(pev, tevs);
+	ret = try_to_find_kprobe_trace_events(pev, tevs, max_tevs);
 	if (ret != 0)
 		return ret;
 
@@ -1487,7 +1490,7 @@ struct __event_package {
 };
 
 int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
-			  bool force_add)
+			  bool force_add, int max_tevs)
 {
 	int i, j, ret;
 	struct __event_package *pkgs;
@@ -1506,7 +1509,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 		pkgs[i].pev = &pevs[i];
 		/* Convert with or without debuginfo */
 		ret  = convert_to_kprobe_trace_events(pkgs[i].pev,
-						      &pkgs[i].tevs);
+						      &pkgs[i].tevs, max_tevs);
 		if (ret < 0)
 			goto end;
 		pkgs[i].ntevs = ret;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index e7ff0d0..e9db1a2 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -115,8 +115,8 @@ extern void clear_kprobe_trace_event(struct kprobe_trace_event *tev);
 extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
 
-extern int add_perf_probe_events(struct perf_probe_event *pevs, int ntevs,
-				 bool force_add);
+extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
+				 bool force_add, int max_probe_points);
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 0d795bc..562b144 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -626,8 +626,9 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	Dwarf_Attribute fb_attr;
 	size_t nops;
 
-	if (pf->ntevs == MAX_PROBES) {
-		pr_warning("Too many( > %d) probe point found.\n", MAX_PROBES);
+	if (pf->ntevs == pf->max_tevs) {
+		pr_warning("Too many( > %d) probe point found.\n",
+			   pf->max_tevs);
 		return -ERANGE;
 	}
 	tev = &pf->tevs[pf->ntevs++];
@@ -932,9 +933,9 @@ static int find_probe_point_by_func(struct probe_finder *pf)
 
 /* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
 int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
-			     struct kprobe_trace_event **tevs)
+			     struct kprobe_trace_event **tevs, int max_tevs)
 {
-	struct probe_finder pf = {.pev = pev};
+	struct probe_finder pf = {.pev = pev, .max_tevs = max_tevs};
 	struct perf_probe_point *pp = &pev->point;
 	Dwarf_Off off, noff;
 	size_t cuhl;
@@ -942,7 +943,7 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	Dwarf *dbg;
 	int ret = 0;
 
-	pf.tevs = zalloc(sizeof(struct kprobe_trace_event) * MAX_PROBES);
+	pf.tevs = zalloc(sizeof(struct kprobe_trace_event) * max_tevs);
 	if (pf.tevs == NULL)
 		return -ENOMEM;
 	*tevs = pf.tevs;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 310ce89..66f1980 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -18,7 +18,8 @@ static inline int is_c_varname(const char *name)
 #ifdef DWARF_SUPPORT
 /* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
 extern int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
-				    struct kprobe_trace_event **tevs);
+				    struct kprobe_trace_event **tevs,
+				    int max_tevs);
 
 /* Find a perf_probe_point from debuginfo */
 extern int find_perf_probe_point(int fd, unsigned long addr,
@@ -32,7 +33,8 @@ extern int find_line_range(int fd, struct line_range *lr);
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
 	struct kprobe_trace_event *tevs;	/* Result trace events */
-	int			ntevs;		/* number of trace events */
+	int			ntevs;		/* Number of trace events */
+	int			max_tevs;	/* Max number of trace events */
 
 	/* For function searching */
 	int			lno;		/* Line number */
