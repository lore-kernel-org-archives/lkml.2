Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2ISPK7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 11:10:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52587 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490Ab2ISPKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 11:10:45 -0400
Date: Wed, 19 Sep 2012 08:10:20 -0700
From: tip-bot for Hyeoncheol Lee <hyc.lee@gmail.com>
Message-ID: <tip-7b0295b3db20a89b3296673871858b9ab6b68404@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, hyc.lee@gmail.com, masami.hiramatsu.pt@hitachi.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, masami.hiramatsu.pt@hitachi.com, hyc.lee@gmail.com,
        srikar@linux.vnet.ibm.com, tglx@linutronix.de
In-Reply-To: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
References: <CANFS6baeuSBxPGQ8SUZWZErJ2bWs-Nojg+FSo138E1QK8bJJig@mail.gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Add union member access support
Git-Commit-ID: 7b0295b3db20a89b3296673871858b9ab6b68404
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 19 Sep 2012 08:10:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b0295b3db20a89b3296673871858b9ab6b68404
Gitweb:     http://git.kernel.org/tip/7b0295b3db20a89b3296673871858b9ab6b68404
Author:     Hyeoncheol Lee <hyc.lee@gmail.com>
AuthorDate: Wed, 12 Sep 2012 16:57:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 14 Sep 2012 15:48:08 -0300

perf probe: Add union member access support

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
 
