Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756029Ab1DGRss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 13:48:48 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49037 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab1DGRsr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 13:48:47 -0400
Date: Thu, 7 Apr 2011 19:48:30 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20110407174830.GA29530@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git perf-fixes-for-linus

 Thanks,

	Ingo

------------------>
Masami Hiramatsu (5):
      perf probe: Fix to ensure function declared file
      perf probe: Fix to remove redundant close
      perf probe: Fix multiple --vars options behavior
      perf probe: Fix to find recursively inlined function
      perf probe: Fix listing incorrect line number with inline function


 tools/perf/util/probe-event.c  |   19 ++---
 tools/perf/util/probe-finder.c |  159 ++++++++++++++++++++++++++--------------
 2 files changed, 113 insertions(+), 65 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 5ddee66..f022316 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -234,7 +234,6 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 
 	/* Searching trace events corresponding to probe event */
 	ntevs = find_probe_trace_events(fd, pev, tevs, max_tevs);
-	close(fd);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("find %d probe_trace_events.\n", ntevs);
@@ -388,7 +387,6 @@ int show_line_range(struct line_range *lr, const char *module)
 	}
 
 	ret = find_line_range(fd, lr);
-	close(fd);
 	if (ret == 0) {
 		pr_warning("Specified source line is not found.\n");
 		return -ENOENT;
@@ -512,19 +510,18 @@ int show_available_vars(struct perf_probe_event *pevs, int npevs,
 	if (ret < 0)
 		return ret;
 
-	fd = open_vmlinux(module);
-	if (fd < 0) {
-		pr_warning("Failed to open debug information file.\n");
-		return fd;
-	}
-
 	setup_pager();
 
-	for (i = 0; i < npevs && ret >= 0; i++)
+	for (i = 0; i < npevs && ret >= 0; i++) {
+		fd = open_vmlinux(module);
+		if (fd < 0) {
+			pr_warning("Failed to open debug information file.\n");
+			ret = fd;
+			break;
+		}
 		ret = show_available_vars_at(fd, &pevs[i], max_vls, _filter,
 					     externs);
-
-	close(fd);
+	}
 	return ret;
 }
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 194f9e2..b7c85ce 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -273,6 +273,25 @@ static const char *cu_get_comp_dir(Dwarf_Die *cu_die)
 	return dwarf_formstring(&attr);
 }
 
+/* Get a line number and file name for given address */
+static int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
+			    const char **fname, int *lineno)
+{
+	Dwarf_Line *line;
+	Dwarf_Addr laddr;
+
+	line = dwarf_getsrc_die(cudie, (Dwarf_Addr)addr);
+	if (line && dwarf_lineaddr(line, &laddr) == 0 &&
+	    addr == (unsigned long)laddr && dwarf_lineno(line, lineno) == 0) {
+		*fname = dwarf_linesrc(line, NULL, NULL);
+		if (!*fname)
+			/* line number is useless without filename */
+			*lineno = 0;
+	}
+
+	return *lineno ?: -ENOENT;
+}
+
 /* Compare diename and tname */
 static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
@@ -497,7 +516,20 @@ static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
 static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 				      Dwarf_Die *die_mem)
 {
-	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
+	Dwarf_Die tmp_die;
+
+	sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr, &tmp_die);
+	if (!sp_die)
+		return NULL;
+
+	/* Inlined function could be recursive. Trace it until fail */
+	while (sp_die) {
+		memcpy(die_mem, sp_die, sizeof(Dwarf_Die));
+		sp_die = die_find_child(sp_die, __die_find_inline_cb, &addr,
+					&tmp_die);
+	}
+
+	return die_mem;
 }
 
 /* Walker on lines (Note: line number will not be sorted) */
@@ -1395,6 +1427,10 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	    !die_compare_name(sp_die, pp->function))
 		return DWARF_CB_OK;
 
+	/* Check declared file */
+	if (pp->file && strtailcmp(pp->file, dwarf_decl_file(sp_die)))
+		return DWARF_CB_OK;
+
 	pf->fname = dwarf_decl_file(sp_die);
 	if (pp->line) { /* Function relative line */
 		dwarf_decl_line(sp_die, &pf->lno);
@@ -1451,6 +1487,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 	if (!dbg) {
 		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		close(fd);	/* Without dwfl_end(), fd isn't closed. */
 		return -EBADF;
 	}
 
@@ -1686,11 +1723,9 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
 	Dwarf_Die cudie, spdie, indie;
 	Dwarf *dbg = NULL;
 	Dwfl *dwfl = NULL;
-	Dwarf_Line *line;
-	Dwarf_Addr laddr, eaddr, bias = 0;
-	const char *tmp;
-	int lineno, ret = 0;
-	bool found = false;
+	Dwarf_Addr _addr, baseaddr, bias = 0;
+	const char *fname = NULL, *func = NULL, *tmp;
+	int baseline = 0, lineno = 0, ret = 0;
 
 	/* Open the live linux kernel */
 	dbg = dwfl_init_live_kernel_dwarf(addr, &dwfl, &bias);
@@ -1711,68 +1746,79 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
 		goto end;
 	}
 
-	/* Find a corresponding line */
-	line = dwarf_getsrc_die(&cudie, (Dwarf_Addr)addr);
-	if (line) {
-		if (dwarf_lineaddr(line, &laddr) == 0 &&
-		    (Dwarf_Addr)addr == laddr &&
-		    dwarf_lineno(line, &lineno) == 0) {
-			tmp = dwarf_linesrc(line, NULL, NULL);
-			if (tmp) {
-				ppt->line = lineno;
-				ppt->file = strdup(tmp);
-				if (ppt->file == NULL) {
-					ret = -ENOMEM;
-					goto end;
-				}
-				found = true;
-			}
-		}
-	}
+	/* Find a corresponding line (filename and lineno) */
+	cu_find_lineinfo(&cudie, addr, &fname, &lineno);
+	/* Don't care whether it failed or not */
 
-	/* Find a corresponding function */
+	/* Find a corresponding function (name, baseline and baseaddr) */
 	if (die_find_real_subprogram(&cudie, (Dwarf_Addr)addr, &spdie)) {
+		/* Get function entry information */
 		tmp = dwarf_diename(&spdie);
-		if (!tmp || dwarf_entrypc(&spdie, &eaddr) != 0)
-			goto end;
-
-		if (ppt->line) {
-			if (die_find_inlinefunc(&spdie, (Dwarf_Addr)addr,
-						&indie)) {
-				/* addr in an inline function */
+		if (!tmp ||
+		    dwarf_entrypc(&spdie, &baseaddr) != 0 ||
+		    dwarf_decl_line(&spdie, &baseline) != 0)
+			goto post;
+		func = tmp;
+
+		if (addr == (unsigned long)baseaddr)
+			/* Function entry - Relative line number is 0 */
+			lineno = baseline;
+		else if (die_find_inlinefunc(&spdie, (Dwarf_Addr)addr,
+					     &indie)) {
+			if (dwarf_entrypc(&indie, &_addr) == 0 &&
+			    _addr == addr)
+				/*
+				 * addr is at an inline function entry.
+				 * In this case, lineno should be the call-site
+				 * line number.
+				 */
+				lineno = die_get_call_lineno(&indie);
+			else {
+				/*
+				 * addr is in an inline function body.
+				 * Since lineno points one of the lines
+				 * of the inline function, baseline should
+				 * be the entry line of the inline function.
+				 */
 				tmp = dwarf_diename(&indie);
-				if (!tmp)
-					goto end;
-				ret = dwarf_decl_line(&indie, &lineno);
-			} else {
-				if (eaddr == addr) {	/* Function entry */
-					lineno = ppt->line;
-					ret = 0;
-				} else
-					ret = dwarf_decl_line(&spdie, &lineno);
-			}
-			if (ret == 0) {
-				/* Make a relative line number */
-				ppt->line -= lineno;
-				goto found;
+				if (tmp &&
+				    dwarf_decl_line(&spdie, &baseline) == 0)
+					func = tmp;
 			}
 		}
-		/* We don't have a line number, let's use offset */
-		ppt->offset = addr - (unsigned long)eaddr;
-found:
-		ppt->function = strdup(tmp);
+	}
+
+post:
+	/* Make a relative line number or an offset */
+	if (lineno)
+		ppt->line = lineno - baseline;
+	else if (func)
+		ppt->offset = addr - (unsigned long)baseaddr;
+
+	/* Duplicate strings */
+	if (func) {
+		ppt->function = strdup(func);
 		if (ppt->function == NULL) {
 			ret = -ENOMEM;
 			goto end;
 		}
-		found = true;
 	}
-
+	if (fname) {
+		ppt->file = strdup(fname);
+		if (ppt->file == NULL) {
+			if (ppt->function) {
+				free(ppt->function);
+				ppt->function = NULL;
+			}
+			ret = -ENOMEM;
+			goto end;
+		}
+	}
 end:
 	if (dwfl)
 		dwfl_end(dwfl);
-	if (ret >= 0)
-		ret = found ? 1 : 0;
+	if (ret == 0 && (fname || func))
+		ret = 1;	/* Found a point */
 	return ret;
 }
 
@@ -1840,6 +1886,10 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	struct line_finder *lf = param->data;
 	struct line_range *lr = lf->lr;
 
+	/* Check declared file */
+	if (lr->file && strtailcmp(lr->file, dwarf_decl_file(sp_die)))
+		return DWARF_CB_OK;
+
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
@@ -1892,6 +1942,7 @@ int find_line_range(int fd, struct line_range *lr)
 	if (!dbg) {
 		pr_warning("No debug information found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		close(fd);	/* Without dwfl_end(), fd isn't closed. */
 		return -EBADF;
 	}
 
