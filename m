Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0JVB5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:57:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:50570 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131Ab0JVB5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:57:32 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/7] perf probe: Fix local variable searching loop
Date: Thu, 21 Oct 2010 23:56:59 -0200
Message-Id: <1287712624-27540-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1287712624-27540-1-git-send-email-acme@infradead.org>
References: <1287712624-27540-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix to check the die's address and search into the die only if it has given
address.

This will avoid finding wrong variables in wrong basic block.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20101021101309.3542.46434.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

