Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752197Ab0JVB5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 21:57:16 -0400
Received: from casper.infradead.org ([85.118.1.10]:50558 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751955Ab0JVB5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 21:57:14 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/7] perf probe: Fix type searching
Date: Thu, 21 Oct 2010 23:56:58 -0200
Message-Id: <1287712624-27540-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1287712624-27540-1-git-send-email-acme@infradead.org>
References: <1287712624-27540-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Fix to get the actual type die of variables by using dwarf_attr_integrate()
which gets attribute from die even if the type die is connected by
DW_AT_abstract_origin.

Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
LKML-Reference: <20101021101302.3542.38549.stgit@ltc236.sdl.hitachi.co.jp>
Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-finder.c |   25 +++++++++++++++++--------
 1 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 32b81f7..a2d1f79 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -160,26 +160,35 @@ static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 	return name ? (strcmp(tname, name) == 0) : false;
 }
 
+/* Get type die */
+static Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
+{
+	Dwarf_Attribute attr;
+
+	if (dwarf_attr_integrate(vr_die, DW_AT_type, &attr) &&
+	    dwarf_formref_die(&attr, die_mem))
+		return die_mem;
+	else
+		return NULL;
+}
+
 /* Get type die, but skip qualifiers and typedef */
 static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
 {
-	Dwarf_Attribute attr;
 	int tag;
 
 	do {
-		if (dwarf_attr(vr_die, DW_AT_type, &attr) == NULL ||
-		    dwarf_formref_die(&attr, die_mem) == NULL)
-			return NULL;
-
-		tag = dwarf_tag(die_mem);
-		vr_die = die_mem;
+		vr_die = die_get_type(vr_die, die_mem);
+		if (!vr_die)
+			break;
+		tag = dwarf_tag(vr_die);
 	} while (tag == DW_TAG_const_type ||
 		 tag == DW_TAG_restrict_type ||
 		 tag == DW_TAG_volatile_type ||
 		 tag == DW_TAG_shared_type ||
 		 tag == DW_TAG_typedef);
 
-	return die_mem;
+	return vr_die;
 }
 
 static bool die_is_signed_type(Dwarf_Die *tp_die)
-- 
1.6.2.5

