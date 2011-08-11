Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab1HKL1Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 07:27:16 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:47621 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab1HKL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 07:27:12 -0400
X-AuditID: b753bd60-a1479ba0000050a4-56-4e43bc8e2ac5
X-AuditID: b753bd60-a1479ba0000050a4-56-4e43bc8e2ac5
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip v2 7/9] [BUGFIX] perf probe: Avoid searching variables in
 intermediate scopes
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Thu, 11 Aug 2011 20:03:05 +0900
Message-ID: <20110811110305.19900.94374.stgit@fedora15>
In-Reply-To: <20110811110220.19900.54963.stgit@fedora15>
References: <20110811110220.19900.54963.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix variable searching logic to search one in inner than local
scope or global(CU) scope. In the other words, skip searching
in intermediate scopes.

e.g., in the following code,

int var1;

void inline infunc(int i)
{
    i++;   <--- [A]
}

void func(void)
{
   int var1, var2;
   infunc(var2);
}

At the [A], "var1" should point the global variable "var1",
however, if user mis-typed as "var2", variable search should
be failed. However, current logic searches variable infunc()
scope, global scope, and then func() scope. Thus, it can
find "var2" variable in func() scope. This may not be what
user expects.

So, it would better not search outer scopes except outermost
(compile unit) scope which contains only global variables,
when it failed to find given variable in local scope.

E.g.

Without this:
$ perf probe -V pre_schedule --externs > without.vars

With this:
$ perf probe -V pre_schedule --externs > with.vars

Check the diff:
$ diff without.vars with.vars
88d87
<               int     cpu
133d131
<               long unsigned int*      switch_count

These vars are actually in the scope of schedule(),
the caller of pre_schedule().


Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-finder.c |   44 ++++++++++++----------------------------
 1 files changed, 13 insertions(+), 31 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 5c83b7d..114542a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -615,9 +615,9 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 /* Find a variable in a scope DIE */
 static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 {
-	Dwarf_Die vr_die, *scopes;
+	Dwarf_Die vr_die;
 	char buf[32], *ptr;
-	int ret, nscopes;
+	int ret = 0;
 
 	if (!is_c_varname(pf->pvar->var)) {
 		/* Copy raw parameters */
@@ -652,29 +652,16 @@ static int find_variable(Dwarf_Die *sc_die, struct probe_finder *pf)
 	if (pf->tvar->name == NULL)
 		return -ENOMEM;
 
-	pr_debug("Searching '%s' variable in context.\n",
-		 pf->pvar->var);
+	pr_debug("Searching '%s' variable in context.\n", pf->pvar->var);
 	/* Search child die for local variables and parameters. */
-	if (die_find_variable_at(sc_die, pf->pvar->var, pf->addr, &vr_die))
-		ret = convert_variable(&vr_die, pf);
-	else {
-		/* Search upper class */
-		nscopes = dwarf_getscopes_die(sc_die, &scopes);
-		ret = -ENOENT;
-		while (nscopes-- > 1) {
-			pr_debug("Searching variables in %s\n",
-				 dwarf_diename(&scopes[nscopes]));
-			/* We should check this scope, so give dummy address */
-			if (die_find_variable_at(&scopes[nscopes],
-						 pf->pvar->var, 0,
-						 &vr_die)) {
-				ret = convert_variable(&vr_die, pf);
-				break;
-			}
-		}
-		if (scopes)
-			free(scopes);
+	if (!die_find_variable_at(sc_die, pf->pvar->var, pf->addr, &vr_die)) {
+		/* Search again in global variables */
+		if (!die_find_variable_at(&pf->cu_die, pf->pvar->var, 0, &vr_die))
+			ret = -ENOENT;
 	}
+	if (ret == 0)
+		ret = convert_variable(&vr_die, pf);
+
 	if (ret < 0)
 		pr_warning("Failed to find '%s' in this function.\n",
 			   pf->pvar->var);
@@ -1242,8 +1229,8 @@ static int add_available_vars(Dwarf_Die *sc_die, struct probe_finder *pf)
 	struct available_var_finder *af =
 			container_of(pf, struct available_var_finder, pf);
 	struct variable_list *vl;
-	Dwarf_Die die_mem, *scopes = NULL;
-	int ret, nscopes;
+	Dwarf_Die die_mem;
+	int ret;
 
 	/* Check number of tevs */
 	if (af->nvls == af->max_vls) {
@@ -1273,12 +1260,7 @@ static int add_available_vars(Dwarf_Die *sc_die, struct probe_finder *pf)
 		goto out;
 	/* Don't need to search child DIE for externs. */
 	af->child = false;
-	nscopes = dwarf_getscopes_die(sc_die, &scopes);
-	while (nscopes-- > 1)
-		die_find_child(&scopes[nscopes], collect_variables_cb,
-			       (void *)af, &die_mem);
-	if (scopes)
-		free(scopes);
+	die_find_child(&pf->cu_die, collect_variables_cb, (void *)af, &die_mem);
 
 out:
 	if (strlist__empty(vl->vars)) {

