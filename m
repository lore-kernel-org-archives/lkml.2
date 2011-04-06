Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1DFLAv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 07:00:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51865 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751972Ab1DFLAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 07:00:36 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        2nddept-manager@sdl.hitachi.co.jp,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf probe: Fix listing incorrect line number with inline function
Date: Wed,  6 Apr 2011 08:00:23 -0300
Message-Id: <1302087623-14724-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1302087623-14724-1-git-send-email-acme@infradead.org>
References: <1302087623-14724-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix a bug showing incorrect line number when a probe is put on the head of an
inline function. This patch updates find_perf_probe_point() and introduces new
rules to get correct line number.

 - If debuginfo doesn't have a correct file name, we shouldn't return line
   number too, because, without file name, line number is meaningless.

 - If the address is in a function, it stores the function name and the offset
   from the function entry.

   - If the address is on a line, it tries to get the relative line number from
     the function entry line, except for the address is same as the entry
     address of the function (in this case, the relative line number should
     be 0).

     - If the address is in an inline function entry (call-site), it uses the
       inline function call line number as the line on which the address is.

   - If the address is in an inline function body, it stores the inline
     function name and offset from the inline function call site instead of the
     (non-inlined) function.

Cc: 2nddept-manager@sdl.hitachi.co.jp
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <20110330092605.2132.11629.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |  134 ++++++++++++++++++++++++----------------
 1 files changed, 81 insertions(+), 53 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 689ab46..b7c85ce 100644
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
@@ -1704,11 +1723,9 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
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
@@ -1729,68 +1746,79 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
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
 
-- 
1.6.2.5

