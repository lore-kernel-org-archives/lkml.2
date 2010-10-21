Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab0JUKLh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:11:37 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:42790 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753262Ab0JUKLf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:11:35 -0400
X-AuditID: b753bd60-a6acdba000005dcc-e0-4cc011d3826b
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  1/7] [BUGFIX] perf probe: Fix type searching
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 21 Oct 2010 19:13:02 +0900
Message-ID: <20101021101302.3542.38549.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix to get the actual type die of variables by
using dwarf_attr_integrate() which gets attribute
from die even if the type die is connected by
DW_AT_abstract_origin.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
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

