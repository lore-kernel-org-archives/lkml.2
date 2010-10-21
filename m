Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab0JUKLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:11:43 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:32869 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab0JUKLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:11:41 -0400
X-AuditID: b753bd60-a88d0ba000005dcc-0c-4cc011da5629
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 2/7] [BUGFIX] perf probe: Fix local variable searching
	loop
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Oct 2010 19:13:09 +0900
Message-ID: <20101021101309.3542.46434.stgit@ltc236.sdl.hitachi.co.jp>
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

Fix to check the die's address and search into the die
only if it has given address.
This will avoid finding wrong variables in wrong
basic block.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/util/probe-finder.c |   26 ++++++++++++++++++--------
 1 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a2d1f79..abcaec5 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -329,25 +329,35 @@ static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
 	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
 }
 
+struct __find_variable_param {
+	const char *name;
+	Dwarf_Addr addr;
+};
+
 static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
 {
-	const char *name = data;
+	struct __find_variable_param *fvp = data;
 	int tag;
 
 	tag = dwarf_tag(die_mem);
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
-	    die_compare_name(die_mem, name))
+	    die_compare_name(die_mem, fvp->name))
 		return DIE_FIND_CB_FOUND;
 
-	return DIE_FIND_CB_CONTINUE;
+	if (dwarf_haspc(die_mem, fvp->addr))
+		return DIE_FIND_CB_CONTINUE;
+	else
+		return DIE_FIND_CB_SIBLING;
 }
 
-/* Find a variable called 'name' */
-static Dwarf_Die *die_find_variable(Dwarf_Die *sp_die, const char *name,
-				    Dwarf_Die *die_mem)
+/* Find a variable called 'name' at given address */
+static Dwarf_Die *die_find_variable_at(Dwarf_Die *sp_die, const char *name,
+				       Dwarf_Addr addr, Dwarf_Die *die_mem)
 {
-	return die_find_child(sp_die, __die_find_variable_cb, (void *)name,
+	struct __find_variable_param fvp = { .name = name, .addr = addr};
+
+	return die_find_child(sp_die, __die_find_variable_cb, (void *)&fvp,
 			      die_mem);
 }
 
@@ -731,7 +741,7 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	pr_debug("Searching '%s' variable in context.\n",
 		 pf->pvar->var);
 	/* Search child die for local variables and parameters. */
-	if (die_find_variable(sp_die, pf->pvar->var, &vr_die))
+	if (die_find_variable_at(sp_die, pf->pvar->var, pf->addr, &vr_die))
 		ret = convert_variable(&vr_die, pf);
 	else {
 		/* Search upper class */

