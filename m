Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab0JWTlb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:41:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:42063 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab0JWTl2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:41:28 -0400
Date: Sat, 23 Oct 2010 19:40:57 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101021101316.3542.1999.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101316.3542.1999.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Support global variables
Message-ID: <tip-632941c4f8fbd5b90dcb1672cd0422dfd7332bc9@git.kernel.org>
Git-Commit-ID: 632941c4f8fbd5b90dcb1672cd0422dfd7332bc9
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 19:40:58 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  632941c4f8fbd5b90dcb1672cd0422dfd7332bc9
Gitweb:     http://git.kernel.org/tip/632941c4f8fbd5b90dcb1672cd0422dfd7332bc9
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 21 Oct 2010 19:13:16 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Oct 2010 15:58:27 -0200

perf probe: Support global variables

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
