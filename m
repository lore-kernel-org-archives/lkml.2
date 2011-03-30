Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755701Ab1C3Jcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 05:32:53 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:51535 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932349Ab1C3Jcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 05:32:50 -0400
X-AuditID: b753bd60-a1d49ba0000001d0-1b-4d92f8c024af
X-AuditID: b753bd60-a1d49ba0000001d0-1b-4d92f8c024af
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 05/12] [BUGFIX]perf probe: Fix listing incorrect line
	number with inline function
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Wed, 30 Mar 2011 18:26:05 +0900
Message-ID: <20110330092605.2132.11629.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
References: <20110330092533.2132.35412.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a bug showing incorrect line number when a probe is put on the head
of an inline function. This patch updates find_perf_probe_point() and
introduces new rules to get correct line number.
 - If debuginfo doesn't have a correct file name, we shouldn't return
   line number too, because, without file name, line number is meaningless.
 - If the address is in a function, it stores the function name and
   the offset from the function entry.
   - If the address is on a line, it tries to get the relative line number
     from the function entry line, except for the address is same as the
     entry address of the function (in this case, the relative line number
     should be 0).
     - If the address is in an inline function entry (call-site), it uses
       the inline function call line number as the line on which the address
       is.
   - If the address is in an inline function body, it stores the inline
     function name and offset from the inline function call site instead of
     the (non-inlined) function.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 tools/perf/util/probe-finder.c |  134 ++++++++++++++++++++++++----------------
 1 files changed, 81 insertions(+), 53 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d6cf0ac..c579e04 100644
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
@@ -1755,11 +1774,9 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
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
@@ -1780,68 +1797,79 @@ int find_perf_probe_point(unsigned long addr, struct perf_probe_point *ppt)
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
 

