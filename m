Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1HQPtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 11:49:07 -0400
Received: from www.linutronix.de ([62.245.132.108]:58684 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab1HQPtD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 11:49:03 -0400
Date: Wed, 17 Aug 2011 17:49:01 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, mingo@kernel.org
Subject: [GIT pull] perf fixes for 3.1
Message-ID: <alpine.LFD.2.02.1108171747530.2807@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

Thanks,

	tglx

------------------>
Arnaldo Carvalho de Melo (1):
      perf top browser: Remove spurious helpline update

Jiri Olsa (1):
      perf report: Use properly build_id kernel binaries

Masami Hiramatsu (9):
      perf probe: Fix a memory leak for scopes array
      perf probe: Fix line walker to check CU correctly
      perf probe: Fix to search nested inlined functions in CU
      perf probe: Fix to walk all inline instances
      perf probe: Warn when more than one line are given
      perf probe: Fix to search local variables in appropriate scope
      perf probe: Avoid searching variables in intermediate scopes
      perf probe: Search concrete out-of-line instances
      perf probe: Filter out redundant inline-instances

Vasiliy Kulikov (1):
      perf: fix temporary file ownership check


 tools/perf/builtin-probe.c        |   14 ++-
 tools/perf/util/dwarf-aux.c       |  210 +++++++++++++++++++++++++++++++---
 tools/perf/util/dwarf-aux.h       |   11 ++
 tools/perf/util/header.c          |   11 ++-
 tools/perf/util/probe-finder.c    |  231 +++++++++++++++++++++++--------------
 tools/perf/util/probe-finder.h    |    2 +-
 tools/perf/util/symbol.c          |   59 ++++++----
 tools/perf/util/symbol.h          |    1 -
 tools/perf/util/ui/browsers/top.c |    1 -
 9 files changed, 403 insertions(+), 137 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5f2a5c7..710ae3d 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -134,10 +134,18 @@ static int opt_show_lines(const struct option *opt __used,
 {
 	int ret = 0;
 
-	if (str)
-		ret = parse_line_range_desc(str, &params.line_range);
-	INIT_LIST_HEAD(&params.line_range.line_list);
+	if (!str)
+		return 0;
+
+	if (params.show_lines) {
+		pr_warning("Warning: more than one --line options are"
+			   " detected. Only the first one is valid.\n");
+		return 0;
+	}
+
 	params.show_lines = true;
+	ret = parse_line_range_desc(str, &params.line_range);
+	INIT_LIST_HEAD(&params.line_range.line_list);
 
 	return ret;
 }
diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index fddf40f..ee51e9b 100644
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
@@ -198,6 +231,19 @@ static int die_get_attr_udata(Dwarf_Die *tp_die, unsigned int attr_name,
 	return 0;
 }
 
+/* Get attribute and translate it as a sdata */
+static int die_get_attr_sdata(Dwarf_Die *tp_die, unsigned int attr_name,
+			      Dwarf_Sword *result)
+{
+	Dwarf_Attribute attr;
+
+	if (dwarf_attr(tp_die, attr_name, &attr) == NULL ||
+	    dwarf_formsdata(&attr, result) != 0)
+		return -ENOENT;
+
+	return 0;
+}
+
 /**
  * die_is_signed_type - Check whether a type DIE is signed or not
  * @tp_die: a DIE of a type
@@ -250,6 +296,50 @@ int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
 	return 0;
 }
 
+/* Get the call file index number in CU DIE */
+static int die_get_call_fileno(Dwarf_Die *in_die)
+{
+	Dwarf_Sword idx;
+
+	if (die_get_attr_sdata(in_die, DW_AT_call_file, &idx) == 0)
+		return (int)idx;
+	else
+		return -ENOENT;
+}
+
+/* Get the declared file index number in CU DIE */
+static int die_get_decl_fileno(Dwarf_Die *pdie)
+{
+	Dwarf_Sword idx;
+
+	if (die_get_attr_sdata(pdie, DW_AT_decl_file, &idx) == 0)
+		return (int)idx;
+	else
+		return -ENOENT;
+}
+
+/**
+ * die_get_call_file - Get callsite file name of inlined function instance
+ * @in_die: a DIE of an inlined function instance
+ *
+ * Get call-site file name of @in_die. This means from which file the inline
+ * function is called.
+ */
+const char *die_get_call_file(Dwarf_Die *in_die)
+{
+	Dwarf_Die cu_die;
+	Dwarf_Files *files;
+	int idx;
+
+	idx = die_get_call_fileno(in_die);
+	if (idx < 0 || !dwarf_diecu(in_die, &cu_die, NULL, NULL) ||
+	    dwarf_getsrcfiles(&cu_die, &files, NULL) != 0)
+		return NULL;
+
+	return dwarf_filesrc(files, idx, NULL, NULL);
+}
+
+
 /**
  * die_find_child - Generic DIE search function in DIE tree
  * @rt_die: a root DIE
@@ -374,9 +464,78 @@ Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 	return die_mem;
 }
 
+struct __instance_walk_param {
+	void    *addr;
+	int	(*callback)(Dwarf_Die *, void *);
+	void    *data;
+	int	retval;
+};
+
+static int __die_walk_instances_cb(Dwarf_Die *inst, void *data)
+{
+	struct __instance_walk_param *iwp = data;
+	Dwarf_Attribute attr_mem;
+	Dwarf_Die origin_mem;
+	Dwarf_Attribute *attr;
+	Dwarf_Die *origin;
+	int tmp;
+
+	attr = dwarf_attr(inst, DW_AT_abstract_origin, &attr_mem);
+	if (attr == NULL)
+		return DIE_FIND_CB_CONTINUE;
+
+	origin = dwarf_formref_die(attr, &origin_mem);
+	if (origin == NULL || origin->addr != iwp->addr)
+		return DIE_FIND_CB_CONTINUE;
+
+	/* Ignore redundant instances */
+	if (dwarf_tag(inst) == DW_TAG_inlined_subroutine) {
+		dwarf_decl_line(origin, &tmp);
+		if (die_get_call_lineno(inst) == tmp) {
+			tmp = die_get_decl_fileno(origin);
+			if (die_get_call_fileno(inst) == tmp)
+				return DIE_FIND_CB_CONTINUE;
+		}
+	}
+
+	iwp->retval = iwp->callback(inst, iwp->data);
+
+	return (iwp->retval) ? DIE_FIND_CB_END : DIE_FIND_CB_CONTINUE;
+}
+
+/**
+ * die_walk_instances - Walk on instances of given DIE
+ * @or_die: an abstract original DIE
+ * @callback: a callback function which is called with instance DIE
+ * @data: user data
+ *
+ * Walk on the instances of give @in_die. @in_die must be an inlined function
+ * declartion. This returns the return value of @callback if it returns
+ * non-zero value, or -ENOENT if there is no instance.
+ */
+int die_walk_instances(Dwarf_Die *or_die, int (*callback)(Dwarf_Die *, void *),
+		       void *data)
+{
+	Dwarf_Die cu_die;
+	Dwarf_Die die_mem;
+	struct __instance_walk_param iwp = {
+		.addr = or_die->addr,
+		.callback = callback,
+		.data = data,
+		.retval = -ENOENT,
+	};
+
+	if (dwarf_diecu(or_die, &cu_die, NULL, NULL) == NULL)
+		return -ENOENT;
+
+	die_find_child(&cu_die, __die_walk_instances_cb, &iwp, &die_mem);
+
+	return iwp.retval;
+}
+
 /* Line walker internal parameters */
 struct __line_walk_param {
-	const char *fname;
+	bool recursive;
 	line_walk_callback_t callback;
 	void *data;
 	int retval;
@@ -385,39 +544,56 @@ struct __line_walk_param {
 static int __die_walk_funclines_cb(Dwarf_Die *in_die, void *data)
 {
 	struct __line_walk_param *lw = data;
-	Dwarf_Addr addr;
+	Dwarf_Addr addr = 0;
+	const char *fname;
 	int lineno;
 
 	if (dwarf_tag(in_die) == DW_TAG_inlined_subroutine) {
+		fname = die_get_call_file(in_die);
 		lineno = die_get_call_lineno(in_die);
-		if (lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
-			lw->retval = lw->callback(lw->fname, lineno, addr,
-						  lw->data);
+		if (fname && lineno > 0 && dwarf_entrypc(in_die, &addr) == 0) {
+			lw->retval = lw->callback(fname, lineno, addr, lw->data);
 			if (lw->retval != 0)
 				return DIE_FIND_CB_END;
 		}
 	}
-	return DIE_FIND_CB_SIBLING;
+	if (!lw->recursive)
+		/* Don't need to search recursively */
+		return DIE_FIND_CB_SIBLING;
+
+	if (addr) {
+		fname = dwarf_decl_file(in_die);
+		if (fname && dwarf_decl_line(in_die, &lineno) == 0) {
+			lw->retval = lw->callback(fname, lineno, addr, lw->data);
+			if (lw->retval != 0)
+				return DIE_FIND_CB_END;
+		}
+	}
+
+	/* Continue to search nested inlined function call-sites */
+	return DIE_FIND_CB_CONTINUE;
 }
 
 /* Walk on lines of blocks included in given DIE */
-static int __die_walk_funclines(Dwarf_Die *sp_die,
+static int __die_walk_funclines(Dwarf_Die *sp_die, bool recursive,
 				line_walk_callback_t callback, void *data)
 {
 	struct __line_walk_param lw = {
+		.recursive = recursive,
 		.callback = callback,
 		.data = data,
 		.retval = 0,
 	};
 	Dwarf_Die die_mem;
 	Dwarf_Addr addr;
+	const char *fname;
 	int lineno;
 
 	/* Handle function declaration line */
-	lw.fname = dwarf_decl_file(sp_die);
-	if (lw.fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
+	fname = dwarf_decl_file(sp_die);
+	if (fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
 	    dwarf_entrypc(sp_die, &addr) == 0) {
-		lw.retval = callback(lw.fname, lineno, addr, data);
+		lw.retval = callback(fname, lineno, addr, data);
 		if (lw.retval != 0)
 			goto done;
 	}
@@ -430,7 +606,7 @@ static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct __line_walk_param *lw = data;
 
-	lw->retval = __die_walk_funclines(sp_die, lw->callback, lw->data);
+	lw->retval = __die_walk_funclines(sp_die, true, lw->callback, lw->data);
 	if (lw->retval != 0)
 		return DWARF_CB_ABORT;
 
@@ -439,7 +615,7 @@ static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
 
 /**
  * die_walk_lines - Walk on lines inside given DIE
- * @rt_die: a root DIE (CU or subprogram)
+ * @rt_die: a root DIE (CU, subprogram or inlined_subroutine)
  * @callback: callback routine
  * @data: user data
  *
@@ -460,12 +636,12 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 	size_t nlines, i;
 
 	/* Get the CU die */
-	if (dwarf_tag(rt_die) == DW_TAG_subprogram)
+	if (dwarf_tag(rt_die) != DW_TAG_compile_unit)
 		cu_die = dwarf_diecu(rt_die, &die_mem, NULL, NULL);
 	else
 		cu_die = rt_die;
 	if (!cu_die) {
-		pr_debug2("Failed to get CU from subprogram\n");
+		pr_debug2("Failed to get CU from given DIE.\n");
 		return -EINVAL;
 	}
 
@@ -509,7 +685,11 @@ int die_walk_lines(Dwarf_Die *rt_die, line_walk_callback_t callback, void *data)
 	 * subroutines. We have to check functions list or given function.
 	 */
 	if (rt_die != cu_die)
-		ret = __die_walk_funclines(rt_die, callback, data);
+		/*
+		 * Don't need walk functions recursively, because nested
+		 * inlined functions don't have lines of the specified DIE.
+		 */
+		ret = __die_walk_funclines(rt_die, false, callback, data);
 	else {
 		struct __line_walk_param param = {
 			.callback = callback,
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index bc3b211..6ce1717 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -34,12 +34,19 @@ extern const char *cu_get_comp_dir(Dwarf_Die *cu_die);
 extern int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
 			    const char **fname, int *lineno);
 
+/* Walk on funcitons at given address */
+extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
+			int (*callback)(Dwarf_Die *, void *), void *data);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
 /* Get callsite line number of inline-function instance */
 extern int die_get_call_lineno(Dwarf_Die *in_die);
 
+/* Get callsite file name of inlined function instance */
+extern const char *die_get_call_file(Dwarf_Die *in_die);
+
 /* Get type die */
 extern Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem);
 
@@ -73,6 +80,10 @@ extern Dwarf_Die *die_find_realfunc(Dwarf_Die *cu_die, Dwarf_Addr addr,
 extern Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 				      Dwarf_Die *die_mem);
 
+/* Walk on the instances of given DIE */
+extern int die_walk_instances(Dwarf_Die *in_die,
+			      int (*callback)(Dwarf_Die *, void *), void *data);
+
 /* Walker on lines (Note: line number will not be sorted) */
 typedef int (* line_walk_callback_t) (const char *fname, int lineno,
 				      Dwarf_Addr addr, void *data);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index d4f3101..b6c1ad1 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -726,7 +726,16 @@ static int perf_header__read_build_ids_abi_quirk(struct perf_header *header,
 			return -1;
 
 		bev.header = old_bev.header;
-		bev.pid	   = 0;
+
+		/*
+		 * As the pid is the missing value, we need to fill
+		 * it properly. The header.misc value give us nice hint.
+		 */
+		bev.pid	= HOST_KERNEL_ID;
+		if (bev.header.misc == PERF_RECORD_MISC_GUEST_USER ||
+		    bev.header.misc == PERF_RECORD_MISC_GUEST_KERNEL)
+			bev.pid	= DEFAULT_GUEST_KERNEL_ID;
+
 		memcpy(bev.build_id, old_bev.build_id, sizeof(bev.build_id));
 		__event_process_build_id(&bev, filename, session);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3e44a3e..555fc38 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -612,12 +612,12 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	return ret;
 }
 
-/* Find a variable in a subprogram die */
-static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
+/* Find a variable in a scope DIE */
+static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
-	Dwarf_Die vr_die, *scopes;
+	Dwarf_Die vr_die;
 	char buf[32], *ptr;
-	int ret, nscopes;
+	int ret = 0;
 
 	if (!is_c_varname(pf->pvar->var)) {
 		/* Copy raw parameters */
@@ -652,30 +652,16 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	if (pf->tvar->name == NULL)
 		return -ENOMEM;
 
-	pr_debug("Searching '%s' variable in context.\n",
-		 pf->pvar->var);
+	pr_debug("Searching '%s' variable in context.\n", pf->pvar->var);
 	/* Search child die for local variables and parameters. */
-	if (die_find_variable_at(sp_die, pf->pvar->var, pf->addr, &vr_die))
-		ret = convert_variable(&vr_die, pf);
-	else {
-		/* Search upper class */
-		nscopes = dwarf_getscopes_die(sp_die, &scopes);
-		while (nscopes-- > 1) {
-			pr_debug("Searching variables in %s\n",
-				 dwarf_diename(&scopes[nscopes]));
-			/* We should check this scope, so give dummy address */
-			if (die_find_variable_at(&scopes[nscopes],
-						 pf->pvar->var, 0,
-						 &vr_die)) {
-				ret = convert_variable(&vr_die, pf);
-				goto found;
-			}
-		}
-		if (scopes)
-			free(scopes);
-		ret = -ENOENT;
+	if (!die_find_variable_at(sc_die, pf->pvar->var, pf->addr, &vr_die)) {
+		/* Search again in global variables */
+		if (!die_find_variable_at(&pf->cu_die, pf->pvar->var, 0, &vr_die))
+			ret = -ENOENT;
 	}
-found:
+	if (ret == 0)
+		ret = convert_variable(&vr_die, pf);
+
 	if (ret < 0)
 		pr_warning("Failed to find '%s' in this function.\n",
 			   pf->pvar->var);
@@ -718,26 +704,30 @@ static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
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
@@ -755,7 +745,7 @@ static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
 	}
 
 	/* Call finder's callback handler */
-	ret = pf->callback(sp_die, pf);
+	ret = pf->callback(sc_die, pf);
 
 	/* *pf->fb_ops will be cached in libdw. Don't free it. */
 	pf->fb_ops = NULL;
@@ -763,17 +753,82 @@ static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
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
@@ -827,6 +882,7 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
 				   Dwarf_Addr addr, void *data)
 {
 	struct probe_finder *pf = data;
+	Dwarf_Die *sc_die, die_mem;
 	int ret;
 
 	if (!line_list__has_line(&pf->lcache, lineno) ||
@@ -836,7 +892,14 @@ static int probe_point_lazy_walker(const char *fname, int lineno,
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
@@ -861,42 +924,39 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 	return die_walk_lines(sp_die, probe_point_lazy_walker, pf);
 }
 
-/* Callback parameter with return value */
-struct dwarf_callback_param {
-	void *data;
-	int retval;
-};
-
 static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	struct dwarf_callback_param *param = data;
-	struct probe_finder *pf = param->data;
+	struct probe_finder *pf = data;
 	struct perf_probe_point *pp = &pf->pev->point;
 	Dwarf_Addr addr;
+	int ret;
 
 	if (pp->lazy_line)
-		param->retval = find_probe_point_lazy(in_die, pf);
+		ret = find_probe_point_lazy(in_die, pf);
 	else {
 		/* Get probe address */
 		if (dwarf_entrypc(in_die, &addr) != 0) {
 			pr_warning("Failed to get entry address of %s.\n",
 				   dwarf_diename(in_die));
-			param->retval = -ENOENT;
-			return DWARF_CB_ABORT;
+			return -ENOENT;
 		}
 		pf->addr = addr;
 		pf->addr += pp->offset;
 		pr_debug("found inline addr: 0x%jx\n",
 			 (uintmax_t)pf->addr);
 
-		param->retval = call_probe_finder(in_die, pf);
-		if (param->retval < 0)
-			return DWARF_CB_ABORT;
+		ret = call_probe_finder(in_die, pf);
 	}
 
-	return DWARF_CB_OK;
+	return ret;
 }
 
+/* Callback parameter with return value for libdw */
+struct dwarf_callback_param {
+	void *data;
+	int retval;
+};
+
 /* Search function from function name */
 static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 {
@@ -933,14 +993,10 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			/* TODO: Check the address in this function */
 			param->retval = call_probe_finder(sp_die, pf);
 		}
-	} else {
-		struct dwarf_callback_param _param = {.data = (void *)pf,
-						      .retval = 0};
+	} else
 		/* Inlined function: search instances */
-		dwarf_func_inline_instances(sp_die, probe_point_inline_cb,
-					    &_param);
-		param->retval = _param.retval;
-	}
+		param->retval = die_walk_instances(sp_die,
+					probe_point_inline_cb, (void *)pf);
 
 	return DWARF_CB_ABORT; /* Exit; no same symbol in this CU. */
 }
@@ -1060,7 +1116,7 @@ found:
 }
 
 /* Add a found probe point into trace event list */
-static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
+static int add_probe_trace_event(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
 	struct trace_event_finder *tf =
 			container_of(pf, struct trace_event_finder, pf);
@@ -1075,8 +1131,9 @@ static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
 	}
 	tev = &tf->tevs[tf->ntevs++];
 
-	ret = convert_to_trace_point(sp_die, pf->addr, pf->pev->point.retprobe,
-				     &tev->point);
+	/* Trace point should be converted from subprogram DIE */
+	ret = convert_to_trace_point(&pf->sp_die, pf->addr,
+				     pf->pev->point.retprobe, &tev->point);
 	if (ret < 0)
 		return ret;
 
@@ -1091,7 +1148,8 @@ static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
 	for (i = 0; i < pf->pev->nargs; i++) {
 		pf->pvar = &pf->pev->args[i];
 		pf->tvar = &tev->args[i];
-		ret = find_variable(sp_die, pf);
+		/* Variable should be found from scope DIE */
+		ret = find_variable(sc_die, pf);
 		if (ret != 0)
 			return ret;
 	}
@@ -1159,13 +1217,13 @@ static int collect_variables_cb(Dwarf_Die *die_mem, void *data)
 }
 
 /* Add a found vars into available variables list */
-static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
+static int add_available_vars(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
 	struct available_var_finder *af =
 			container_of(pf, struct available_var_finder, pf);
 	struct variable_list *vl;
-	Dwarf_Die die_mem, *scopes = NULL;
-	int ret, nscopes;
+	Dwarf_Die die_mem;
+	int ret;
 
 	/* Check number of tevs */
 	if (af->nvls == af->max_vls) {
@@ -1174,8 +1232,9 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 	}
 	vl = &af->vls[af->nvls++];
 
-	ret = convert_to_trace_point(sp_die, pf->addr, pf->pev->point.retprobe,
-				     &vl->point);
+	/* Trace point should be converted from subprogram DIE */
+	ret = convert_to_trace_point(&pf->sp_die, pf->addr,
+				     pf->pev->point.retprobe, &vl->point);
 	if (ret < 0)
 		return ret;
 
@@ -1187,19 +1246,14 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
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
-	while (nscopes-- > 1)
-		die_find_child(&scopes[nscopes], collect_variables_cb,
-			       (void *)af, &die_mem);
-	if (scopes)
-		free(scopes);
+	die_find_child(&pf->cu_die, collect_variables_cb, (void *)af, &die_mem);
 
 out:
 	if (strlist__empty(vl->vars)) {
@@ -1391,10 +1445,14 @@ static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
 static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	struct dwarf_callback_param *param = data;
+	find_line_range_by_line(in_die, data);
 
-	param->retval = find_line_range_by_line(in_die, param->data);
-	return DWARF_CB_ABORT;	/* No need to find other instances */
+	/*
+	 * We have to check all instances of inlined function, because
+	 * some execution paths can be optimized out depends on the
+	 * function argument of instances
+	 */
+	return 0;
 }
 
 /* Search function from function name */
@@ -1422,15 +1480,10 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 		pr_debug("New line range: %d to %d\n", lf->lno_s, lf->lno_e);
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
-		if (dwarf_func_inline(sp_die)) {
-			struct dwarf_callback_param _param;
-			_param.data = (void *)lf;
-			_param.retval = 0;
-			dwarf_func_inline_instances(sp_die,
-						    line_range_inline_cb,
-						    &_param);
-			param->retval = _param.retval;
-		} else
+		if (dwarf_func_inline(sp_die))
+			param->retval = die_walk_instances(sp_die,
+						line_range_inline_cb, lf);
+		else
 			param->retval = find_line_range_by_line(sp_die, lf);
 		return DWARF_CB_ABORT;
 	}
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
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a8b5371..469c026 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1506,7 +1506,7 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 	if (strncmp(dso->name, "/tmp/perf-", 10) == 0) {
 		struct stat st;
 
-		if (stat(dso->name, &st) < 0)
+		if (lstat(dso->name, &st) < 0)
 			return -1;
 
 		if (st.st_uid && (st.st_uid != geteuid())) {
@@ -2181,27 +2181,22 @@ size_t machines__fprintf_dsos_buildid(struct rb_root *machines,
 	return ret;
 }
 
-struct dso *dso__new_kernel(const char *name)
+static struct dso*
+dso__kernel_findnew(struct machine *machine, const char *name,
+		    const char *short_name, int dso_type)
 {
-	struct dso *dso = dso__new(name ?: "[kernel.kallsyms]");
-
-	if (dso != NULL) {
-		dso__set_short_name(dso, "[kernel]");
-		dso->kernel = DSO_TYPE_KERNEL;
-	}
-
-	return dso;
-}
+	/*
+	 * The kernel dso could be created by build_id processing.
+	 */
+	struct dso *dso = __dsos__findnew(&machine->kernel_dsos, name);
 
-static struct dso *dso__new_guest_kernel(struct machine *machine,
-					const char *name)
-{
-	char bf[PATH_MAX];
-	struct dso *dso = dso__new(name ?: machine__mmap_name(machine, bf,
-							      sizeof(bf)));
+	/*
+	 * We need to run this in all cases, since during the build_id
+	 * processing we had no idea this was the kernel dso.
+	 */
 	if (dso != NULL) {
-		dso__set_short_name(dso, "[guest.kernel]");
-		dso->kernel = DSO_TYPE_GUEST_KERNEL;
+		dso__set_short_name(dso, short_name);
+		dso->kernel = dso_type;
 	}
 
 	return dso;
@@ -2219,24 +2214,36 @@ void dso__read_running_kernel_build_id(struct dso *dso, struct machine *machine)
 		dso->has_build_id = true;
 }
 
-static struct dso *machine__create_kernel(struct machine *machine)
+static struct dso *machine__get_kernel(struct machine *machine)
 {
 	const char *vmlinux_name = NULL;
 	struct dso *kernel;
 
 	if (machine__is_host(machine)) {
 		vmlinux_name = symbol_conf.vmlinux_name;
-		kernel = dso__new_kernel(vmlinux_name);
+		if (!vmlinux_name)
+			vmlinux_name = "[kernel.kallsyms]";
+
+		kernel = dso__kernel_findnew(machine, vmlinux_name,
+					     "[kernel]",
+					     DSO_TYPE_KERNEL);
 	} else {
+		char bf[PATH_MAX];
+
 		if (machine__is_default_guest(machine))
 			vmlinux_name = symbol_conf.default_guest_vmlinux_name;
-		kernel = dso__new_guest_kernel(machine, vmlinux_name);
+		if (!vmlinux_name)
+			vmlinux_name = machine__mmap_name(machine, bf,
+							  sizeof(bf));
+
+		kernel = dso__kernel_findnew(machine, vmlinux_name,
+					     "[guest.kernel]",
+					     DSO_TYPE_GUEST_KERNEL);
 	}
 
-	if (kernel != NULL) {
+	if (kernel != NULL && (!kernel->has_build_id))
 		dso__read_running_kernel_build_id(kernel, machine);
-		dsos__add(&machine->kernel_dsos, kernel);
-	}
+
 	return kernel;
 }
 
@@ -2340,7 +2347,7 @@ void machine__destroy_kernel_maps(struct machine *machine)
 
 int machine__create_kernel_maps(struct machine *machine)
 {
-	struct dso *kernel = machine__create_kernel(machine);
+	struct dso *kernel = machine__get_kernel(machine);
 
 	if (kernel == NULL ||
 	    __machine__create_kernel_maps(machine, kernel) < 0)
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 325ee36..4f377d9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -155,7 +155,6 @@ struct dso {
 };
 
 struct dso *dso__new(const char *name);
-struct dso *dso__new_kernel(const char *name);
 void dso__delete(struct dso *dso);
 
 int dso__name_len(const struct dso *dso);
diff --git a/tools/perf/util/ui/browsers/top.c b/tools/perf/util/ui/browsers/top.c
index 5a06538..88403cf 100644
--- a/tools/perf/util/ui/browsers/top.c
+++ b/tools/perf/util/ui/browsers/top.c
@@ -208,6 +208,5 @@ int perf_top__tui_browser(struct perf_top *top)
 		},
 	};
 
-	ui_helpline__push("Press <- or ESC to exit");
 	return perf_top_browser__run(&browser);
 }
