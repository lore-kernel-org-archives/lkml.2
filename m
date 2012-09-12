Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab2ILH5r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 03:57:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52332 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab2ILH5q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 03:57:46 -0400
MIME-Version: 1.0
Date: Wed, 12 Sep 2012 16:57:45 +0900
Message-ID: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
Subject: [PATCH -tip/perf/core] perf probe: Add union member access support
From: Hyeoncheol Lee <hyc.lee@gmail.com>
To: acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Union members can be accessed with '.' or '->' like data structure
member access

Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
---
 tools/perf/util/probe-finder.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 94a00de..cc2b856 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -525,8 +525,10 @@ static int convert_variable_fields(Dwarf_Die
*vr_die, const char *varname,
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

@@ -539,8 +541,9 @@ static int convert_variable_fields(Dwarf_Die
*vr_die, const char *varname,
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
@@ -567,10 +570,15 @@ static int convert_variable_fields(Dwarf_Die
*vr_die, const char *varname,
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
1.7.10
