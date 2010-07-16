Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758748Ab0GPSJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:09:43 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:37156 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0GPSJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:09:42 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 3/3] perf probe: Fix the logic of die_compare_name
Date: Fri, 16 Jul 2010 15:09:33 -0300
Message-Id: <1279303773-27861-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1279303773-27861-1-git-send-email-acme@infradead.org>
References: <1279303773-27861-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Invert the return value of die_compare_name(), because it returns a 'bool'
result which should be expeced true if the die's name is same as compared
string.

LKML-Reference: <4C36EBED.1000006@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
-- 
1.6.2.5

