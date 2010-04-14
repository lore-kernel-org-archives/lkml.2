Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101Ab0DNWd2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 18:33:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757027Ab0DNWdZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 18:33:25 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 5/6] perf probe: Support DW_OP_plus_uconst in
	DW_AT_data_member_location
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Date: Wed, 14 Apr 2010 18:39:58 -0400
Message-ID: <20100414223958.14630.5230.stgit@localhost6.localdomain6>
In-Reply-To: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
References: <20100414223921.14630.62353.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DW_OP_plus_uconst can be used for DW_AT_data_member_location.
This patch adds DW_OP_plus_uconst support when getting
structure member offset.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
---

 tools/perf/util/probe-finder.c |   37 ++++++++++++++++++++++++++++++++-----
 1 files changed, 32 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index b4c9365..4f83121 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -249,6 +249,33 @@ static int die_get_byte_size(Dwarf_Die *tp_die)
 	return (int)ret;
 }
 
+/* Get data_member_location offset */
+static int die_get_data_member_location(Dwarf_Die *mb_die, Dwarf_Word *offs)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Op *expr;
+	size_t nexpr;
+	int ret;
+
+	if (dwarf_attr(mb_die, DW_AT_data_member_location, &attr) == NULL)
+		return -ENOENT;
+
+	if (dwarf_formudata(&attr, offs) != 0) {
+		/* DW_AT_data_member_location should be DW_OP_plus_uconst */
+		ret = dwarf_getlocation(&attr, &expr, &nexpr);
+		if (ret < 0 || nexpr == 0)
+			return -ENOENT;
+
+		if (expr[0].atom != DW_OP_plus_uconst || nexpr != 1) {
+			pr_debug("Unable to get offset:Unexpected OP %x (%d)\n",
+				 expr[0].atom, nexpr);
+			return -ENOTSUP;
+		}
+		*offs = (Dwarf_Word)expr[0].number;
+	}
+	return 0;
+}
+
 /* Return values for die_find callbacks */
 enum {
 	DIE_FIND_CB_FOUND = 0,		/* End of Search */
@@ -482,9 +509,9 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 				    Dwarf_Die *die_mem)
 {
 	struct kprobe_trace_arg_ref *ref = *ref_ptr;
-	Dwarf_Attribute attr;
 	Dwarf_Die type;
 	Dwarf_Word offs;
+	int ret;
 
 	pr_debug("converting %s in %s\n", field->name, varname);
 	if (die_get_real_type(vr_die, &type) == NULL) {
@@ -542,17 +569,17 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 	}
 
 	/* Get the offset of the field */
-	if (dwarf_attr(die_mem, DW_AT_data_member_location, &attr) == NULL ||
-	    dwarf_formudata(&attr, &offs) != 0) {
+	ret = die_get_data_member_location(die_mem, &offs);
+	if (ret < 0) {
 		pr_warning("Failed to get the offset of %s.\n", field->name);
-		return -ENOENT;
+		return ret;
 	}
 	ref->offset += (long)offs;
 
 	/* Converting next field */
 	if (field->next)
 		return convert_variable_fields(die_mem, field->name,
-					       field->next, &ref, die_mem);
+					field->next, &ref, die_mem);
 	else
 		return 0;
 }


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
