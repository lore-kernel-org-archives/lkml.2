Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753452Ab1HNPra (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 11:47:30 -0400
Received: from hera.kernel.org ([140.211.167.34]:49368 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751688Ab1HNPr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 11:47:28 -0400
Date: Sun, 14 Aug 2011 15:47:09 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Message-ID: <tip-f182e3e13ca71b64b40fab1aef31fa6a78271648@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        penberg@kernel.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, penberg@kernel.org,
        peterz@infradead.org, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20110811110305.19900.94374.stgit@fedora15>
References: <20110811110305.19900.94374.stgit@fedora15>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Avoid searching variables in intermediate scopes
Git-Commit-ID: f182e3e13ca71b64b40fab1aef31fa6a78271648
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 14 Aug 2011 15:47:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f182e3e13ca71b64b40fab1aef31fa6a78271648
Gitweb:     http://git.kernel.org/tip/f182e3e13ca71b64b40fab1aef31fa6a78271648
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 11 Aug 2011 20:03:05 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 12 Aug 2011 09:29:34 -0300

perf probe: Avoid searching variables in intermediate scopes

Fix variable searching logic to search one in inner than local scope or
global(CU) scope. In the other words, skip searching in intermediate
scopes.

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

At [A], "var1" should point the global variable "var1", however, if user
mis-typed as "var2", variable search should be failed. However, current
logic searches variable infunc() scope, global scope, and then func()
scope. Thus, it can find "var2" variable in func() scope. This may not
be what user expects.

So, it would better not search outer scopes except outermost (compile
unit) scope which contains only global variables, when it failed to find
given variable in local scope.

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

These vars are actually in the scope of schedule(), the caller of
pre_schedule().

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: yrl.pp-manager.tt@hitachi.com
Link: http://lkml.kernel.org/r/20110811110305.19900.94374.stgit@fedora15
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   44 +++++++++++----------------------------
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
