Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab1AMMvf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 07:51:35 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39109 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab1AMMv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 07:51:28 -0500
X-AuditID: b753bd60-9d15cba000000f65-b1-4d2ef54cce31
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -perf/perf/core 1/6] perf probe: Introduce lines walker
	interface
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Franck Bui-Huu <fbuihuu@gmail.com>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel@vger.kernel.org
Date: Thu, 13 Jan 2011 21:45:58 +0900
Message-ID: <20110113124558.22426.48170.stgit@ltc236.sdl.hitachi.co.jp>
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

Introduce die_walk_lines() for walking on the line list
of given die, and use it in line_range finder and probe
point finder.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/util/probe-finder.c |  321 +++++++++++++++++++++-------------------
 1 files changed, 167 insertions(+), 154 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index ab83b6a..5926d25 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -458,6 +458,124 @@ static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
 }
 
+/* Walker on lines (Note: line number will not be sorted) */
+typedef int (* line_walk_handler_t) (const char *fname, int lineno,
+				     Dwarf_Addr addr, void *data);
+
+struct __line_walk_param {
+	line_walk_handler_t handler;
+	void *data;
+	int retval;
+};
+
+/* Walk on decl lines in given DIE */
+static int __die_walk_funclines(Dwarf_Die *sp_die,
+				line_walk_handler_t handler, void *data)
+{
+	const char *fname;
+	Dwarf_Addr addr;
+	int lineno, ret = 0;
+
+	/* Handle function declaration line */
+	fname = dwarf_decl_file(sp_die);
+	if (fname && dwarf_decl_line(sp_die, &lineno) == 0 &&
+	    dwarf_entrypc(sp_die, &addr) == 0) {
+		ret = handler(fname, lineno, addr, data);
+	}
+
+	return ret;
+}
+
+static int __die_walk_culines_cb(Dwarf_Die *sp_die, void *data)
+{
+	struct __line_walk_param *lw = data;
+
+	lw->retval = __die_walk_funclines(sp_die, lw->handler, lw->data);
+	if (lw->retval != 0)
+		return DWARF_CB_ABORT;
+
+	return DWARF_CB_OK;
+}
+
+/*
+ * Walk on lines inside given PDIE. If the PDIE is subprogram, walk only on
+ * the lines inside the subprogram, otherwise PDIE must be a CU DIE.
+ */
+static int die_walk_lines(Dwarf_Die *pdie, line_walk_handler_t handler,
+			  void *data)
+{
+	Dwarf_Lines *lines;
+	Dwarf_Line *line;
+	Dwarf_Addr addr;
+	const char *fname;
+	int lineno, ret = 0;
+	Dwarf_Die die_mem, *cu_die;
+	size_t nlines, i;
+
+	/* Get the CU die */
+	if (dwarf_tag(pdie) == DW_TAG_subprogram)
+		cu_die = dwarf_diecu(pdie, &die_mem, NULL, NULL);
+	else
+		cu_die = pdie;
+	if (!cu_die) {
+		pr_debug2("Failed to get CU from subprogram\n");
+		return -EINVAL;
+	}
+
+	/* Get lines list in the CU */
+	if (dwarf_getsrclines(cu_die, &lines, &nlines) != 0) {
+		pr_debug2("Failed to get source lines on this CU.\n");
+		return -ENOENT;
+	}
+	pr_debug2("Get %ld lines from this CU\n", nlines);
+
+	/* Walk on the lines on lines list */
+	for (i = 0; i < nlines; i++) {
+		line = dwarf_onesrcline(lines, i);
+		if (line == NULL ||
+		    dwarf_lineno(line, &lineno) != 0 ||
+		    dwarf_lineaddr(line, &addr) != 0) {
+			pr_debug2("Failed to get line info. "
+				  "Possible error in debuginfo.\n");
+			continue;
+		}
+		/* Filter lines based on address */
+		if (pdie != cu_die)
+			/*
+			 * Address filtering
+			 * The line is included in given function, and
+			 * no inline block includes it.
+			 */
+			if (!dwarf_haspc(pdie, addr) ||
+			    die_find_inlinefunc(pdie, addr, &die_mem))
+				continue;
+		/* Get source line */
+		fname = dwarf_linesrc(line, NULL, NULL);
+
+		ret = handler(fname, lineno, addr, data);
+		if (ret != 0)
+			return ret;
+	}
+
+	/*
+	 * Dwarf lines doesn't include function declarations and inlined
+	 * subroutines. We have to check functions list or given function.
+	 */
+	if (pdie != cu_die)
+		ret = __die_walk_funclines(pdie, handler, data);
+	else {
+		struct __line_walk_param param = {
+			.handler = handler,
+			.data = data,
+			.retval = 0,
+		};
+		dwarf_getfuncs(cu_die, __die_walk_culines_cb, &param, 0);
+		ret = param.retval;
+	}
+
+	return ret;
+}
+
 struct __find_variable_param {
 	const char *name;
 	Dwarf_Addr addr;
@@ -1050,43 +1168,26 @@ static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
 	return ret;
 }
 
-/* Find probe point from its line number */
-static int find_probe_point_by_line(struct probe_finder *pf)
+static int probe_point_line_walker(const char *fname, int lineno,
+				   Dwarf_Addr addr, void *data)
 {
-	Dwarf_Lines *lines;
-	Dwarf_Line *line;
-	size_t nlines, i;
-	Dwarf_Addr addr;
-	int lineno;
-	int ret = 0;
+	struct probe_finder *pf = data;
+	int ret;
 
-	if (dwarf_getsrclines(&pf->cu_die, &lines, &nlines) != 0) {
-		pr_warning("No source lines found.\n");
-		return -ENOENT;
-	}
+	if (lineno != pf->lno || strtailcmp(fname, pf->fname) != 0)
+		return 0;
 
-	for (i = 0; i < nlines && ret == 0; i++) {
-		line = dwarf_onesrcline(lines, i);
-		if (dwarf_lineno(line, &lineno) != 0 ||
-		    lineno != pf->lno)
-			continue;
+	pf->addr = addr;
+	ret = call_probe_finder(NULL, pf);
 
-		/* TODO: Get fileno from line, but how? */
-		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
-			continue;
-
-		if (dwarf_lineaddr(line, &addr) != 0) {
-			pr_warning("Failed to get the address of the line.\n");
-			return -ENOENT;
-		}
-		pr_debug("Probe line found: line[%d]:%d addr:0x%jx\n",
-			 (int)i, lineno, (uintmax_t)addr);
-		pf->addr = addr;
+	/* Continue if no error, because the line will be in inline function */
+	return ret < 0 ?: 0;
+}
 
-		ret = call_probe_finder(NULL, pf);
-		/* Continuing, because target line might be inlined. */
-	}
-	return ret;
+/* Find probe point from its line number */
+static int find_probe_point_by_line(struct probe_finder *pf)
+{
+	return die_walk_lines(&pf->cu_die, probe_point_line_walker, pf);
 }
 
 /* Find lines which match lazy pattern */
@@ -1140,15 +1241,31 @@ out_close:
 	return nlines;
 }
 
+static int probe_point_lazy_walker(const char *fname, int lineno,
+				   Dwarf_Addr addr, void *data)
+{
+	struct probe_finder *pf = data;
+	int ret;
+
+	if (!line_list__has_line(&pf->lcache, lineno) ||
+	    strtailcmp(fname, pf->fname) != 0)
+		return 0;
+
+	pr_debug("Probe line found: line:%d addr:0x%llx\n",
+		 lineno, (unsigned long long)addr);
+	pf->addr = addr;
+	ret = call_probe_finder(NULL, pf);
+
+	/*
+	 * Continue if no error, because the lazy pattern will match
+	 * to other lines
+	 */
+	return ret < 0 ?: 0;
+}
+
 /* Find probe points from lazy pattern  */
 static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
-	Dwarf_Lines *lines;
-	Dwarf_Line *line;
-	size_t nlines, i;
-	Dwarf_Addr addr;
-	Dwarf_Die die_mem;
-	int lineno;
 	int ret = 0;
 
 	if (list_empty(&pf->lcache)) {
@@ -1162,45 +1279,7 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 			return ret;
 	}
 
-	if (dwarf_getsrclines(&pf->cu_die, &lines, &nlines) != 0) {
-		pr_warning("No source lines found.\n");
-		return -ENOENT;
-	}
-
-	for (i = 0; i < nlines && ret >= 0; i++) {
-		line = dwarf_onesrcline(lines, i);
-
-		if (dwarf_lineno(line, &lineno) != 0 ||
-		    !line_list__has_line(&pf->lcache, lineno))
-			continue;
-
-		/* TODO: Get fileno from line, but how? */
-		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
-			continue;
-
-		if (dwarf_lineaddr(line, &addr) != 0) {
-			pr_debug("Failed to get the address of line %d.\n",
-				 lineno);
-			continue;
-		}
-		if (sp_die) {
-			/* Address filtering 1: does sp_die include addr? */
-			if (!dwarf_haspc(sp_die, addr))
-				continue;
-			/* Address filtering 2: No child include addr? */
-			if (die_find_inlinefunc(sp_die, addr, &die_mem))
-				continue;
-		}
-
-		pr_debug("Probe line found: line[%d]:%d addr:0x%llx\n",
-			 (int)i, lineno, (unsigned long long)addr);
-		pf->addr = addr;
-
-		ret = call_probe_finder(sp_die, pf);
-		/* Continuing, because target line might be inlined. */
-	}
-	/* TODO: deallocate lines, but how? */
-	return ret;
+	return die_walk_lines(sp_die, probe_point_lazy_walker, pf);
 }
 
 /* Callback parameter with return value */
@@ -1644,91 +1723,28 @@ static int line_range_add_line(const char *src, unsigned int lineno,
 	return line_list__add_line(&lr->line_list, lineno);
 }
 
-/* Search function declaration lines */
-static int line_range_funcdecl_cb(Dwarf_Die *sp_die, void *data)
+static int line_range_walk_cb(const char *fname, int lineno,
+			      Dwarf_Addr addr __used,
+			      void *data)
 {
-	struct dwarf_callback_param *param = data;
-	struct line_finder *lf = param->data;
-	const char *src;
-	int lineno;
-
-	src = dwarf_decl_file(sp_die);
-	if (src && strtailcmp(src, lf->fname) != 0)
-		return DWARF_CB_OK;
+	struct line_finder *lf = data;
 
-	if (dwarf_decl_line(sp_die, &lineno) != 0 ||
+	if ((strtailcmp(fname, lf->fname) != 0) ||
 	    (lf->lno_s > lineno || lf->lno_e < lineno))
-		return DWARF_CB_OK;
+		return 0;
 
-	param->retval = line_range_add_line(src, lineno, lf->lr);
-	if (param->retval < 0)
-		return DWARF_CB_ABORT;
-	return DWARF_CB_OK;
-}
+	if (line_range_add_line(fname, lineno, lf->lr) < 0)
+		return -EINVAL;
 
-static int find_line_range_func_decl_lines(struct line_finder *lf)
-{
-	struct dwarf_callback_param param = {.data = (void *)lf, .retval = 0};
-	dwarf_getfuncs(&lf->cu_die, line_range_funcdecl_cb, &param, 0);
-	return param.retval;
+	return 0;
 }
 
 /* Find line range from its line number */
 static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 {
-	Dwarf_Lines *lines;
-	Dwarf_Line *line;
-	size_t nlines, i;
-	Dwarf_Addr addr;
-	int lineno, ret = 0;
-	const char *src;
-	Dwarf_Die die_mem;
-
-	line_list__init(&lf->lr->line_list);
-	if (dwarf_getsrclines(&lf->cu_die, &lines, &nlines) != 0) {
-		pr_warning("No source lines found.\n");
-		return -ENOENT;
-	}
-
-	/* Search probable lines on lines list */
-	for (i = 0; i < nlines; i++) {
-		line = dwarf_onesrcline(lines, i);
-		if (dwarf_lineno(line, &lineno) != 0 ||
-		    (lf->lno_s > lineno || lf->lno_e < lineno))
-			continue;
-
-		if (sp_die) {
-			/* Address filtering 1: does sp_die include addr? */
-			if (dwarf_lineaddr(line, &addr) != 0 ||
-			    !dwarf_haspc(sp_die, addr))
-				continue;
-
-			/* Address filtering 2: No child include addr? */
-			if (die_find_inlinefunc(sp_die, addr, &die_mem))
-				continue;
-		}
-
-		/* TODO: Get fileno from line, but how? */
-		src = dwarf_linesrc(line, NULL, NULL);
-		if (strtailcmp(src, lf->fname) != 0)
-			continue;
-
-		ret = line_range_add_line(src, lineno, lf->lr);
-		if (ret < 0)
-			return ret;
-	}
+	int ret;
 
-	/*
-	 * Dwarf lines doesn't include function declarations. We have to
-	 * check functions list or given function.
-	 */
-	if (sp_die) {
-		src = dwarf_decl_file(sp_die);
-		if (src && dwarf_decl_line(sp_die, &lineno) == 0 &&
-		    (lf->lno_s <= lineno && lf->lno_e >= lineno))
-			ret = line_range_add_line(src, lineno, lf->lr);
-	} else
-		ret = find_line_range_func_decl_lines(lf);
+	ret = die_walk_lines(sp_die ?: &lf->cu_die, line_range_walk_cb, lf);
 
 	/* Update status */
 	if (ret >= 0)
@@ -1758,9 +1774,6 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	struct line_finder *lf = param->data;
 	struct line_range *lr = lf->lr;
 
-	pr_debug("find (%llx) %s\n",
-		 (unsigned long long)dwarf_dieoffset(sp_die),
-		 dwarf_diename(sp_die));
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);

