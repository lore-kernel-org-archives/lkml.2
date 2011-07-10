Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab1GJKmP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 06:42:15 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:56963 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab1GJKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 06:42:13 -0400
X-AuditID: b753bd60-a287bba0000050a4-7c-4e198202e385
X-AuditID: b753bd60-a287bba0000050a4-7c-4e198202e385
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 4/5] [BUGFIX] perf probe: Fix the order of searching
 scopes for variables
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Sun, 10 Jul 2011 19:00:33 +0900
Message-ID: <20110710100033.2550.78762.stgit@fedora15>
In-Reply-To: <20110710100005.2550.83138.stgit@fedora15>
References: <20110710100005.2550.83138.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix variable searching routine to search from inner scope
to outer scope.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-finder.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 222ba66..cf7d48d 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1135,7 +1135,7 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	Dwarf_Die vr_die, *scopes;
 	char buf[32], *ptr;
-	int ret, nscopes;
+	int ret, nscopes, i;
 
 	if (!is_c_varname(pf->pvar->var)) {
 		/* Copy raw parameters */
@@ -1179,11 +1179,11 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 		/* Search upper class */
 		nscopes = dwarf_getscopes_die(sp_die, &scopes);
 		ret = -ENOENT;
-		while (nscopes-- > 1) {
+		for (i = 1; i < nscopes; i++) {	/* scopes[0] is sp_die */
 			pr_debug("Searching variables in %s\n",
-				 dwarf_diename(&scopes[nscopes]));
+				 dwarf_diename(&scopes[i]));
 			/* We should check this scope, so give dummy address */
-			if (die_find_variable_at(&scopes[nscopes],
+			if (die_find_variable_at(&scopes[i],
 						 pf->pvar->var, 0,
 						 &vr_die)) {
 				ret = convert_variable(&vr_die, pf);
@@ -1693,7 +1693,7 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 			container_of(pf, struct available_var_finder, pf);
 	struct variable_list *vl;
 	Dwarf_Die die_mem, *scopes = NULL;
-	int ret, nscopes;
+	int ret, nscopes, i;
 
 	/* Check number of tevs */
 	if (af->nvls == af->max_vls) {
@@ -1723,8 +1723,8 @@ static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
 	/* Don't need to search child DIE for externs. */
 	af->child = false;
 	nscopes = dwarf_getscopes_die(sp_die, &scopes);
-	while (nscopes-- > 1)
-		die_find_child(&scopes[nscopes], collect_variables_cb,
+	for (i = 1; i < nscopes; i++)	/* scopes[0] is sp_die */
+		die_find_child(&scopes[i], collect_variables_cb,
 			       (void *)af, &die_mem);
 	if (scopes)
 		free(scopes);

