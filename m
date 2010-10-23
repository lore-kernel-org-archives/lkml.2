Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758315Ab0JWTlF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:41:05 -0400
Received: from hera.kernel.org ([140.211.167.34]:42041 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758113Ab0JWTlC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:41:02 -0400
Date: Sat, 23 Oct 2010 19:40:34 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101021101309.3542.46434.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101309.3542.46434.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix local variable searching loop
Message-ID: <tip-378eeaad3e1cfea7f6614018fb335de93df2ba1f@git.kernel.org>
Git-Commit-ID: 378eeaad3e1cfea7f6614018fb335de93df2ba1f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 19:40:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  378eeaad3e1cfea7f6614018fb335de93df2ba1f
Gitweb:     http://git.kernel.org/tip/378eeaad3e1cfea7f6614018fb335de93df2ba1f
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 21 Oct 2010 19:13:09 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Oct 2010 15:58:05 -0200

perf probe: Fix local variable searching loop

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
