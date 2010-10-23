Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758240Ab0JWTku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 15:40:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:42003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754777Ab0JWTks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 15:40:48 -0400
Date: Sat, 23 Oct 2010 19:40:10 GMT
From: tip-bot for Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        masami.hiramatsu.pt@hitachi.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101021101302.3542.38549.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101302.3542.38549.stgit@ltc236.sdl.hitachi.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf probe: Fix type searching
Message-ID: <tip-4046b8bb5ffae9ee916e504cdadee804f10e0c56@git.kernel.org>
Git-Commit-ID: 4046b8bb5ffae9ee916e504cdadee804f10e0c56
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 23 Oct 2010 19:40:13 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4046b8bb5ffae9ee916e504cdadee804f10e0c56
Gitweb:     http://git.kernel.org/tip/4046b8bb5ffae9ee916e504cdadee804f10e0c56
Author:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
AuthorDate: Thu, 21 Oct 2010 19:13:02 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 21 Oct 2010 15:57:08 -0200

perf probe: Fix type searching

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
