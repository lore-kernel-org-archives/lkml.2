Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686Ab0JUKLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:11:50 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42844 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753842Ab0JUKLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:11:47 -0400
X-AuditID: b753bd60-a98ddba000000a18-93-4cc011e1c2c5
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  3/7] perf probe: Support global variables
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Oct 2010 19:13:16 +0900
Message-ID: <20101021101316.3542.1999.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow users to set external defined global variables
as event arguments (e.g. jiffies).

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/util/probe-finder.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index abcaec5..c6fe80e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -406,6 +406,9 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 	struct probe_trace_arg *tvar = pf->tvar;
 	int ret;
 
+	if (dwarf_attr(vr_die, DW_AT_external, &attr) != NULL)
+		goto static_var;
+
 	/* TODO: handle more than 1 exprs */
 	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL ||
 	    dwarf_getlocation_addr(&attr, pf->addr, &op, &nops, 1) <= 0 ||
@@ -417,6 +420,7 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 	}
 
 	if (op->atom == DW_OP_addr) {
+static_var:
 		/* Static variables on memory (not stack), make @varname */
 		ret = strlen(dwarf_diename(vr_die));
 		tvar->value = zalloc(ret + 2);
@@ -746,17 +750,22 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	else {
 		/* Search upper class */
 		nscopes = dwarf_getscopes_die(sp_die, &scopes);
-		if (nscopes > 0) {
-			ret = dwarf_getscopevar(scopes, nscopes, pf->pvar->var,
-						0, NULL, 0, 0, &vr_die);
-			if (ret >= 0)
+		while (nscopes-- > 1) {
+			pr_debug("Searching variables in %s\n",
+				 dwarf_diename(&scopes[nscopes]));
+			/* We should check this scope, so give dummy address */
+			if (die_find_variable_at(&scopes[nscopes],
+						 pf->pvar->var, 0,
+						 &vr_die)) {
 				ret = convert_variable(&vr_die, pf);
-			else
-				ret = -ENOENT;
+				goto found;
+			}
+		}
+		if (scopes)
 			free(scopes);
-		} else
-			ret = -ENOENT;
+		ret = -ENOENT;
 	}
+found:
 	if (ret < 0)
 		pr_warning("Failed to find '%s' in this function.\n",
 			   pf->pvar->var);

