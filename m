Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab1HLQaz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 12:30:55 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45365 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab1HLQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 12:29:19 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, yrl.pp-manager.tt@hitachi.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/12] perf probe: Fix to search local variables in appropriate scope
Date: Fri, 12 Aug 2011 13:29:01 -0300
Message-Id: <1313166544-6209-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1313166544-6209-1-git-send-email-acme@infradead.org>
References: <1313166544-6209-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix perf probe to search local variables in appropriate local inlined
function scope. For example, pre_schedule() has only 2 local variables,
as below;

$ perf probe -L pre_schedule
<pre_schedule@/home/mhiramat/ksrc/linux-2.6/kernel/sched.c:0>
      0  static inline void pre_schedule(struct rq *rq, struct task_struct *prev)
         {
      2         if (prev->sched_class->pre_schedule)
      3                 prev->sched_class->pre_schedule(rq, prev);
         }

However, current perf probe shows 4 local variables on pre_schedule(),
because it searches variables in the caller(schedule()) scope.

$ perf probe -V pre_schedule
Available variables at pre_schedule
        @<schedule+445>
                int     cpu
                long unsigned int*      switch_count
                struct rq*      rq
                struct task_struct*     prev

This patch fixes this issue by searching variables in the local scope of
the instance of inlined function. Here is the result.

$ perf probe -V pre_schedule
Available variables at pre_schedule
        @<schedule+445>
                struct rq*      rq
                struct task_struct*     prev

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110259.19900.85664.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dwarf-aux.c    |   33 ++++++++++
 tools/perf/util/dwarf-aux.h    |    4 +
 tools/perf/util/probe-finder.c |  132 ++++++++++++++++++++++++++++++++--------
 tools/perf/util/probe-finder.h |    2 +-
 4 files changed, 144 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index d9b8ad0..425703a 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -96,6 +96,39 @@ int cu_find_lineinfo(Dwarf_Die *cu_die, unsigned long addr,
 	return *lineno ?: -ENOENT;
 }
 
+static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data);
+
+/**
+ * cu_walk_functions_at - Walk on function DIEs at given address
+ * @cu_die: A CU DIE
+ * @addr: An address
+ * @callback: A callback which called with found DIEs
+ * @data: A user data
+ *
+ * Walk on function DIEs at given @addr in @cu_die. Passed DIEs
+ * should be subprogram or inlined-subroutines.
+ */
+int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
+		    int (*callback)(Dwarf_Die *, void *), void *data)
+{
+	Dwarf_Die die_mem;
+	Dwarf_Die *sc_die;
+	int ret = -ENOENT;
+
+	/* Inlined function could be recursive. Trace it until fail */
+	for (sc_die = die_find_realfunc(cu_die, addr, &die_mem);
+	     sc_die != NULL;
+	     sc_die = die_find_child(sc_die, __die_find_inline_cb, &addr,
+				     &die_mem)) {
+		ret = callback(sc_die, data);
+		if (ret)
+			break;
+	}
+
+	return ret;
+
+}
+
 /**
  * die_compare_name - Compare diename and tname
  * @dw_die: a DIE
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index c8e491b..6f46106 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -34,6 +34,10 @@ extern const char *cu_get_comp_dir(Dwarf_Die *cu_die);
 extern int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
 			    const char **fname, int *lineno);
 
+/* Walk on funcitons at given address */
+extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
+			int (*callback)(Dwarf_Die *, void *), void *data);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d6d5768..5c83b7d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -612,8 +612,8 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	return ret;
 }
 
-/* Find a variable in a subprogram die */
-static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
+/* Find a variable in a scope DIE */
+static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
 	Dwarf_Die vr_die, *scopes;
 	char buf[32], *ptr;
@@ -655,11 +655,11 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	pr_debug("Searching '%s' variable in context.\n",
 		 pf->pvar->var);
 	/* Search child die for local variables and parameters. */
-	if (die_find_variable_at(sp_die, pf->pvar->var, pf->addr, &vr_die))
+	if (die_find_variable_at(sc_die, pf->pvar->var, pf->addr, &vr_die))
 		ret = convert_variable(&vr_die, pf);
 	else {
 		/* Search upper class */
-		nscopes = dwarf_getscopes_die(sp_die, &scopes);
+		nscopes = dwarf_getscopes_die(sc_die, &scopes);
 		ret = -ENOENT;
 		while (nscopes-- > 1) {
 			pr_debug("Searching variables in %s\n",
@@ -717,26 +717,30 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
 	return 0;
 }
 
-/* Call probe_finder callback with real subprogram DIE */
-static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
+/* Call probe_finder callback with scope DIE */
+static int call_probe_finder(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
-	Dwarf_Die die_mem;
 	Dwarf_Attribute fb_attr;
 	size_t nops;
 	int ret;
 
-	/* If no real subprogram, find a real one */
-	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
-		sp_die = die_find_realfunc(&pf->cu_die, pf->addr, &die_mem);
-		if (!sp_die) {
+	if (!sc_die) {
+		pr_err("Caller must pass a scope DIE. Program error.\n");
+		return -EINVAL;
+	}
+
+	/* If not a real subprogram, find a real one */
+	if (dwarf_tag(sc_die) != DW_TAG_subprogram) {
+		if (!die_find_realfunc(&pf->cu_die, pf->addr, &pf->sp_die)) {
 			pr_warning("Failed to find probe point in any "
 				   "functions.\n");
 			return -ENOENT;
 		}
-	}
+	} else
+		memcpy(&pf->sp_die, sc_die, sizeof(Dwarf_Die));
 
-	/* Get the frame base attribute/ops */
-	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
+	/* Get the frame base attribute/ops from subprogram */
+	dwarf_attr(&pf->sp_die, DW_AT_frame_base, &fb_attr);
 	ret = dwarf_getlocation_addr(&fb_attr, pf->addr, &pf->fb_ops, &nops, 1);
 	if (ret <= 0 || nops == 0) {
 		pf->fb_ops = NULL;
@@ -754,7 +758,7 @@ static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
 	}
 
 	/* Call finder's callback handler */
-	ret = pf->callback(sp_die, pf);
+	ret = pf->callback(sc_die, pf);
 
 	/* *pf->fb_ops will be cached in libdw. Don't free it. */
 	pf->fb_ops = NULL;
@@ -762,17 +766,82 @@ static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
 	return ret;
 }
 
+struct find_scope_param {
+	const char *function;
+	const char *file;
+	int line;
+	int diff;
+	Dwarf_Die *die_mem;
+	bool found;
+};
+
+static int find_best_scope_cb(Dwarf_Die *fn_die, void *data)
+{
+	struct find_scope_param *fsp = data;
+	const char *file;
+	int lno;
+
+	/* Skip if declared file name does not match */
+	if (fsp->file) {
+		file = dwarf_decl_file(fn_die);
+		if (!file || strcmp(fsp->file, file) != 0)
+			return 0;
+	}
+	/* If the function name is given, that's what user expects */
+	if (fsp->function) {
+		if (die_compare_name(fn_die, fsp->function)) {
+			memcpy(fsp->die_mem, fn_die, sizeof(Dwarf_Die));
+			fsp->found = true;
+			return 1;
+		}
+	} else {
+		/* With the line number, find the nearest declared DIE */
+		dwarf_decl_line(fn_die, &lno);
+		if (lno < fsp->line && fsp->diff > fsp->line - lno) {
+			/* Keep a candidate and continue */
+			fsp->diff = fsp->line - lno;
+			memcpy(fsp->die_mem, fn_die, sizeof(Dwarf_Die));
+			fsp->found = true;
+		}
+	}
+	return 0;
+}
+
+/* Find an appropriate scope fits to given conditions */
+static Dwarf_Die *find_best_scope(struct probe_finder *pf, Dwarf_Die *die_mem)
+{
+	struct find_scope_param fsp = {
+		.function = pf->pev->point.function,
+		.file = pf->fname,
+		.line = pf->lno,
+		.diff = INT_MAX,
+		.die_mem = die_mem,
+		.found = false,
+	};
+
+	cu_walk_functions_at(&pf->cu_die, pf->addr, find_best_scope_cb, &fsp);
+
+	return fsp.found ? die_mem : NULL;
+}
+
 static int probe_point_line_walker(const char *fname, int lineno,
 				   Dwarf_Addr addr, void *data)
 {
 	struct probe_finder *pf = data;
+	Dwarf_Die *sc_die, die_mem;
 	int ret;
 
 	if (lineno != pf->lno || strtailcmp(fname, pf->fname) != 0)
 		return 0;
 
 	pf->addr = addr;
-	ret = call_probe_finder(NULL, pf);
+	sc_die = find_best_scope(pf, &die_mem);
+	if (!sc_die) {
+		pr_warning("Failed to find scope of probe point.\n");
+		return -ENOENT;
+	}
+
+	ret = call_probe_finder(sc_die, pf);
 
 	/* Continue if no error, because the line will be in inline function */
 	return ret < 0 ? ret : 0;
@@ -826,6 +895,7 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
 				   Dwarf_Addr addr, void *data)
 {
 	struct probe_finder *pf = data;
+	Dwarf_Die *sc_die, die_mem;
 	int ret;
 
 	if (!line_list__has_line(&pf->lcache, lineno) ||
@@ -835,7 +905,14 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
 	pr_debug("Probe line found: line:%d addr:0x%llx\n",
 		 lineno, (unsigned long long)addr);
 	pf->addr = addr;
-	ret = call_probe_finder(NULL, pf);
+	pf->lno = lineno;
+	sc_die = find_best_scope(pf, &die_mem);
+	if (!sc_die) {
+		pr_warning("Failed to find scope of probe point.\n");
+		return -ENOENT;
+	}
+
+	ret = call_probe_finder(sc_die, pf);
 
 	/*
 	 * Continue if no error, because the lazy pattern will match
@@ -1059,7 +1136,7 @@ found:
 }
 
 /* Add a found probe point into trace event list */
-static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
+static int add_probe_trace_event(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
 	struct trace_event_finder *tf =
 			container_of(pf, struct trace_event_finder, pf);
@@ -1074,8 +1151,9 @@ static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
 	}
 	tev = &tf->tevs[tf->ntevs++];
 
-	ret = convert_to_trace_point(sp_die, pf->addr, pf->pev->point.retprobe,
-				     &tev->point);
+	/* Trace point should be converted from subprogram DIE */
+	ret = convert_to_trace_point(&pf->sp_die, pf->addr,
+				     pf->pev->point.retprobe, &tev->point);
 	if (ret < 0)
 		return ret;
 
@@ -1090,7 +1168,8 @@ static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
 	for (i = 0; i < pf->pev->nargs; i++) {
 		pf->pvar = &pf->pev->args[i];
 		pf->tvar = &tev->args[i];
-		ret = find_variable(sp_die, pf);
+		/* Variable should be found from scope DIE */
+		ret = find_variable(sc_die, pf);
 		if (ret != 0)
 			return ret;
 	}
@@ -1158,7 +1237,7 @@ static int collect_variables_cb(Dwarf_Die *die_mem, void *data)
 }
 
 /* Add a found vars into available variables list */
-static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
+static int add_available_vars(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
 	struct available_var_finder *af =
 			container_of(pf, struct available_var_finder, pf);
@@ -1173,8 +1252,9 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 	}
 	vl = &af->vls[af->nvls++];
 
-	ret = convert_to_trace_point(sp_die, pf->addr, pf->pev->point.retprobe,
-				     &vl->point);
+	/* Trace point should be converted from subprogram DIE */
+	ret = convert_to_trace_point(&pf->sp_die, pf->addr,
+				     pf->pev->point.retprobe, &vl->point);
 	if (ret < 0)
 		return ret;
 
@@ -1186,14 +1266,14 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 	if (vl->vars == NULL)
 		return -ENOMEM;
 	af->child = true;
-	die_find_child(sp_die, collect_variables_cb, (void *)af, &die_mem);
+	die_find_child(sc_die, collect_variables_cb, (void *)af, &die_mem);
 
 	/* Find external variables */
 	if (!af->externs)
 		goto out;
 	/* Don't need to search child DIE for externs. */
 	af->child = false;
-	nscopes = dwarf_getscopes_die(sp_die, &scopes);
+	nscopes = dwarf_getscopes_die(sc_die, &scopes);
 	while (nscopes-- > 1)
 		die_find_child(&scopes[nscopes], collect_variables_cb,
 			       (void *)af, &die_mem);
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index c478b42..1132c8f 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -57,7 +57,7 @@ struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
 
 	/* Callback when a probe point is found */
-	int (*callback)(Dwarf_Die *sp_die, struct probe_finder *pf);
+	int (*callback)(Dwarf_Die *sc_die, struct probe_finder *pf);
 
 	/* For function searching */
 	int			lno;		/* Line number */
-- 
1.6.2.5

