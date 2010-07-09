Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab0GIJ3Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 05:29:24 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:50209 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754932Ab0GIJ3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 05:29:21 -0400
X-AuditID: b753bd60-aa643ba000006d9b-13-4c36ebef5de1
Message-ID: <4C36EBED.1000006@hitachi.com>
Date: Fri, 09 Jul 2010 18:29:17 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] perf probe: Fix the logic of die_compare_name
References: <20100709081743.7173.62191.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20100709081743.7173.62191.stgit@ltc236.sdl.hitachi.co.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Invert the return value of die_compare_name(), because it
returns a 'bool' result which should be expeced true if
the die's name is same as compared string.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 tools/perf/util/probe-finder.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 37dcdb6..f88070e 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -158,7 +158,7 @@ static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
 	const char *name;
 	name = dwarf_diename(dw_die);
-	return name ? strcmp(tname, name) : -1;
+	return name ? (strcmp(tname, name) == 0) : false;
 }

 /* Get type die, but skip qualifiers and typedef */
@@ -329,7 +329,7 @@ static int __die_find_variable_cb(Dwarf_Die *die_mem, void *data)
 	tag = dwarf_tag(die_mem);
 	if ((tag == DW_TAG_formal_parameter ||
 	     tag == DW_TAG_variable) &&
-	    (die_compare_name(die_mem, name) == 0))
+	    die_compare_name(die_mem, name))
 		return DIE_FIND_CB_FOUND;

 	return DIE_FIND_CB_CONTINUE;
@@ -348,7 +348,7 @@ static int __die_find_member_cb(Dwarf_Die *die_mem, void *data)
 	const char *name = data;

 	if ((dwarf_tag(die_mem) == DW_TAG_member) &&
-	    (die_compare_name(die_mem, name) == 0))
+	    die_compare_name(die_mem, name))
 		return DIE_FIND_CB_FOUND;

 	return DIE_FIND_CB_SIBLING;
@@ -506,8 +506,8 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 				return -ENOMEM;
 			}
 		}
-		if (die_compare_name(&type, "char") != 0 &&
-		    die_compare_name(&type, "unsigned char") != 0) {
+		if (!die_compare_name(&type, "char") &&
+		    !die_compare_name(&type, "unsigned char")) {
 			pr_warning("Failed to cast into string: "
 				   "%s is not (unsigned) char *.",
 				   dwarf_diename(vr_die));
@@ -1017,7 +1017,7 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)

 	/* Check tag and diename */
 	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
-	    die_compare_name(sp_die, pp->function) != 0)
+	    !die_compare_name(sp_die, pp->function))
 		return DWARF_CB_OK;

 	pf->fname = dwarf_decl_file(sp_die);
@@ -1340,7 +1340,7 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 	struct line_range *lr = lf->lr;

 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
-	    die_compare_name(sp_die, lr->function) == 0) {
+	    die_compare_name(sp_die, lr->function)) {
 		lf->fname = dwarf_decl_file(sp_die);
 		dwarf_decl_line(sp_die, &lr->offset);
 		pr_debug("fname: %s, lineno:%d\n", lf->fname, lr->offset);


