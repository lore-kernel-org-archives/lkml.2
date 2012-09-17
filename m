Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab2IQRYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 13:24:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:46439 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755760Ab2IQRS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 13:18:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Hyeoncheol Lee <hyc.lee@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/18] perf probe: Add union member access support
Date: Mon, 17 Sep 2012 14:17:55 -0300
Message-Id: <1347902292-14536-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347902292-14536-1-git-send-email-acme@infradead.org>
References: <1347902292-14536-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hyeoncheol Lee <hyc.lee@gmail.com>

Union members can be accessed with '.' or '->' like data structure
member access

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 526ba56..1daf5c1 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -525,8 +525,10 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			return -ENOENT;
 		}
 		/* Verify it is a data structure  */
-		if (dwarf_tag(&type) != DW_TAG_structure_type) {
-			pr_warning("%s is not a data structure.\n", varname);
+		tag = dwarf_tag(&type);
+		if (tag != DW_TAG_structure_type && tag != DW_TAG_union_type) {
+			pr_warning("%s is not a data structure nor an union.\n",
+				   varname);
 			return -EINVAL;
 		}
 
@@ -539,8 +541,9 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			*ref_ptr = ref;
 	} else {
 		/* Verify it is a data structure  */
-		if (tag != DW_TAG_structure_type) {
-			pr_warning("%s is not a data structure.\n", varname);
+		if (tag != DW_TAG_structure_type && tag != DW_TAG_union_type) {
+			pr_warning("%s is not a data structure nor an union.\n",
+				   varname);
 			return -EINVAL;
 		}
 		if (field->name[0] == '[') {
@@ -567,10 +570,15 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 	}
 
 	/* Get the offset of the field */
-	ret = die_get_data_member_location(die_mem, &offs);
-	if (ret < 0) {
-		pr_warning("Failed to get the offset of %s.\n", field->name);
-		return ret;
+	if (tag == DW_TAG_union_type) {
+		offs = 0;
+	} else {
+		ret = die_get_data_member_location(die_mem, &offs);
+		if (ret < 0) {
+			pr_warning("Failed to get the offset of %s.\n",
+				   field->name);
+			return ret;
+		}
 	}
 	ref->offset += (long)offs;
 
-- 
1.7.1

