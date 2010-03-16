Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab0CPV6A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:58:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13024 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162Ab0CPV5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:57:55 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 06/10] perf probe: Introduce die_find_child() function
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Mar 2010 18:05:58 -0400
Message-ID: <20100316220558.32050.7905.stgit@localhost6.localdomain6>
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce die_find_child() function to integrate DIE-tree searching
functions.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 tools/perf/util/probe-finder.c |  136 ++++++++++++++++++++++++----------------
 1 files changed, 80 insertions(+), 56 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c91a960..3942e14 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -186,6 +186,62 @@ static const char *cu_find_realpath(Dwarf_Die *cu_die, const char *fname)
 	return src;
 }
 
+/* Compare diename and tname */
+static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
+{
+	const char *name;
+	name = dwarf_diename(dw_die);
+	DIE_IF(name == NULL);
+	return strcmp(tname, name);
+}
+
+/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
+static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
+{
+	Dwarf_Addr epc;
+	int ret;
+
+	ret = dwarf_entrypc(dw_die, &epc);
+	DIE_IF(ret == -1);
+	return epc;
+}
+
+/* Return values for die_find callbacks */
+enum {
+	DIE_FIND_CB_FOUND = 0,		/* End of Search */
+	DIE_FIND_CB_CHILD = 1,		/* Search only children */
+	DIE_FIND_CB_SIBLING = 2,	/* Search only siblings */
+	DIE_FIND_CB_CONTINUE = 3,	/* Search children and siblings */
+};
+
+/* Search a child die */
+static Dwarf_Die *die_find_child(Dwarf_Die *rt_die,
+				 int (*callback)(Dwarf_Die *, void *),
+				 void *data, Dwarf_Die *die_mem)
+{
+	Dwarf_Die child_die;
+	int ret;
+
+	ret = dwarf_child(rt_die, die_mem);
+	if (ret != 0)
+		return NULL;
+
+	do {
+		ret = callback(die_mem, data);
+		if (ret == DIE_FIND_CB_FOUND)
+			return die_mem;
+
+		if ((ret & DIE_FIND_CB_CHILD) &&
+		    die_find_child(die_mem, callback, data, &child_die)) {
+			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
+			return die_mem;
+		}
+	} while ((ret & DIE_FIND_CB_SIBLING) &&
+		 dwarf_siblingof(die_mem, die_mem) == 0);
+
+	return NULL;
+}
+
 struct __addr_die_search_param {
 	Dwarf_Addr	addr;
 	Dwarf_Die	*die_mem;
@@ -217,77 +273,45 @@ static Dwarf_Die *die_find_real_subprogram(Dwarf_Die *cu_die, Dwarf_Addr addr,
 		return die_mem;
 }
 
-/* Similar to dwarf_getfuncs, but returns inlined_subroutine if exists. */
-static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
-				      Dwarf_Die *die_mem)
+/* die_find callback for inline function search */
+static int __die_find_inline_cb(Dwarf_Die *die_mem, void *data)
 {
-	Dwarf_Die child_die;
-	int ret;
+	Dwarf_Addr *addr = data;
 
-	ret = dwarf_child(sp_die, die_mem);
-	if (ret != 0)
-		return NULL;
-
-	do {
-		if (dwarf_tag(die_mem) == DW_TAG_inlined_subroutine &&
-		    dwarf_haspc(die_mem, addr))
-			return die_mem;
+	if (dwarf_tag(die_mem) == DW_TAG_inlined_subroutine &&
+	    dwarf_haspc(die_mem, *addr))
+		return DIE_FIND_CB_FOUND;
 
-		if (die_find_inlinefunc(die_mem, addr, &child_die)) {
-			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
-			return die_mem;
-		}
-	} while (dwarf_siblingof(die_mem, die_mem) == 0);
-
-	return NULL;
+	return DIE_FIND_CB_CONTINUE;
 }
 
-/* Compare diename and tname */
-static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
+/* Similar to dwarf_getfuncs, but returns inlined_subroutine if exists. */
+static Dwarf_Die *die_find_inlinefunc(Dwarf_Die *sp_die, Dwarf_Addr addr,
+				      Dwarf_Die *die_mem)
 {
-	const char *name;
-	name = dwarf_diename(dw_die);
-	DIE_IF(name == NULL);
-	return strcmp(tname, name);
+	return die_find_child(sp_die, __die_find_inline_cb, &addr, die_mem);
 }
 
-/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
-static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
+static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
 {
-	Dwarf_Addr epc;
-	int ret;
+	const char *name = data;
+	int tag;
 
-	ret = dwarf_entrypc(dw_die, &epc);
-	DIE_IF(ret == -1);
-	return epc;
+	tag = dwarf_tag(die_mem);
+	if ((tag == DW_TAG_formal_parameter ||
+	     tag == DW_TAG_variable) &&
+	    (die_compare_name(die_mem, name) == 0))
+		return DIE_FIND_CB_FOUND;
+
+	return DIE_FIND_CB_CONTINUE;
 }
 
-/* Get a variable die */
+/* Find a variable called 'name' */
 static Dwarf_Die *die_find_variable(Dwarf_Die *sp_die, const char *name,
 				    Dwarf_Die *die_mem)
 {
-	Dwarf_Die child_die;
-	int tag;
-	int ret;
-
-	ret = dwarf_child(sp_die, die_mem);
-	if (ret != 0)
-		return NULL;
-
-	do {
-		tag = dwarf_tag(die_mem);
-		if ((tag == DW_TAG_formal_parameter ||
-		     tag == DW_TAG_variable) &&
-		    (die_compare_name(die_mem, name) == 0))
-			return die_mem;
-
-		if (die_find_variable(die_mem, name, &child_die)) {
-			memcpy(die_mem, &child_die, sizeof(Dwarf_Die));
-			return die_mem;
-		}
-	} while (dwarf_siblingof(die_mem, die_mem) == 0);
-
-	return NULL;
+	return die_find_child(sp_die, __die_find_variable_cb, (void *)name,
+			      die_mem);
 }
 
 /*


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
