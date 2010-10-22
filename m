Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab0JVB5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:57:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:55533 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab0JVB5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:57:16 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/7] perf probe: Support global variables
Date: Thu, 21 Oct 2010 23:57:00 -0200
Message-Id: <1287712624-27540-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1287712624-27540-1-git-send-email-acme@infradead.org>
References: <1287712624-27540-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Allow users to set external defined global variables as event arguments (e.g.
jiffies).

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20101021101316.3542.1999.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

