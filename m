Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab2DWDYg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 23:24:36 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50733 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753121Ab2DWDYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 23:24:34 -0400
X-AuditID: b753bd60-99794ba000007b1b-34-4f94cb6fca8b
X-AuditID: b753bd60-99794ba000007b1b-34-4f94cb6fca8b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip ] perf probe: Fix finder to find lines of given function
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Date: Mon, 23 Apr 2012 12:24:36 +0900
Message-ID: <20120423032435.8737.80064.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit ba28c59bc9ed8fb7b9a753cd88ee54a2c4f6265b fixed
a declaration entry bug in probe_point_search_cb().
There are same bugs in line finder and call_probe_finder().
This introduces a new dwarf utility function to determine
given DIE is a function definition, not declaration.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Prashanth Nageshappa <prashanth@linux.vnet.ibm.com>
Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---

 tools/perf/util/dwarf-aux.c    |   19 +++++++++++++++++++
 tools/perf/util/dwarf-aux.h    |    3 +++
 tools/perf/util/probe-finder.c |   12 +++++-------
 3 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/dwarf-aux.c b/tools/perf/util/dwarf-aux.c
index ee51e9b..66a76e5 100644
--- a/tools/perf/util/dwarf-aux.c
+++ b/tools/perf/util/dwarf-aux.c
@@ -263,6 +263,21 @@ bool die_is_signed_type(Dwarf_Die *tp_die)
 }
 
 /**
+ * die_is_func_def - Ensure that this DIE is a subprogram and definition
+ * @dw_die: a DIE
+ *
+ * Ensure that this DIE is a subprogram and NOT a declaration. This
+ * returns true if @dw_die is a function definition.
+ **/
+bool die_is_func_def(Dwarf_Die *dw_die)
+{
+	Dwarf_Attribute attr;
+
+	return (dwarf_tag(dw_die) == DW_TAG_subprogram &&
+		dwarf_attr(dw_die, DW_AT_declaration, &attr) == NULL);
+}
+
+/**
  * die_get_data_member_location - Get the data-member offset
  * @mb_die: a DIE of a member of a data structure
  * @offs: The offset of the member in the data structure
@@ -392,6 +407,10 @@ static int __die_search_func_cb(Dwarf_Die *fn_die, void *data)
 {
 	struct __addr_die_search_param *ad = data;
 
+	/*
+	 * Since a declaration entry doesn't has given pc, this always returns
+	 * function definition entry.
+	 */
 	if (dwarf_tag(fn_die) == DW_TAG_subprogram &&
 	    dwarf_haspc(fn_die, ad->addr)) {
 		memcpy(ad->die_mem, fn_die, sizeof(Dwarf_Die));
diff --git a/tools/perf/util/dwarf-aux.h b/tools/perf/util/dwarf-aux.h
index 6ce1717..8658d41 100644
--- a/tools/perf/util/dwarf-aux.h
+++ b/tools/perf/util/dwarf-aux.h
@@ -38,6 +38,9 @@ extern int cu_find_lineinfo(Dwarf_Die *cudie, unsigned long addr,
 extern int cu_walk_functions_at(Dwarf_Die *cu_die, Dwarf_Addr addr,
 			int (*callback)(Dwarf_Die *, void *), void *data);
 
+/* Ensure that this DIE is a subprogram and definition (not declaration) */
+extern bool die_is_func_def(Dwarf_Die *dw_die);
+
 /* Compare diename and tname */
 extern bool die_compare_name(Dwarf_Die *dw_die, const char *tname);
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d448984..d793c0a 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -726,7 +726,7 @@ static int call_probe_finder(Dwarf_Die *sc_die, struct probe_finder *pf)
 	}
 
 	/* If not a real subprogram, find a real one */
-	if (dwarf_tag(sc_die) != DW_TAG_subprogram) {
+	if (!die_is_func_def(sc_die)) {
 		if (!die_find_realfunc(&pf->cu_die, pf->addr, &pf->sp_die)) {
 			pr_warning("Failed to find probe point in any "
 				   "functions.\n");
@@ -972,12 +972,10 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 	struct dwarf_callback_param *param = data;
 	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
-	Dwarf_Attribute attr;
 
 	/* Check tag and diename */
-	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
-	    !die_compare_name(sp_die, pp->function) ||
-	    dwarf_attr(sp_die, DW_AT_declaration, &attr))
+	if (!die_is_func_def(sp_die) ||
+	    !die_compare_name(sp_die, pp->function))
 		return DWARF_CB_OK;
 
 	/* Check declared file */
@@ -1466,7 +1464,7 @@ static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 	return 0;
 }
 
-/* Search function from function name */
+/* Search function definition from function name */
 static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct dwarf_callback_param *param = data;
@@ -1477,7 +1475,7 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	if (lr->file && strtailcmp(lr->file, dwarf_decl_file(sp_die)))
 		return DWARF_CB_OK;
 
-	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
+	if (die_is_func_def(sp_die) &&
 	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
 		dwarf_decl_line(sp_die, &lr->offset);

