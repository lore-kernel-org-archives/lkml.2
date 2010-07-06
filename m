Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0GFBEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:04:45 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41802 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752839Ab0GFBEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:04:44 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 3/5] perf probe: Support "string" type
Date: Mon,  5 Jul 2010 22:04:34 -0300
Message-Id: <1278378276-25872-4-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1278378276-25872-1-git-send-email-acme@infradead.org>
References: <1278378276-25872-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Support string type casting to event argument. If perf-probe finds an argument
casted as string, it ensures the target variable is "(unsigned/signed) char
*(or []). perf-probe also adds dereference if the target is a pointer.

So, both of 'char buf[10];' and 'char *buf;' can be accessed by 'buf:string'

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100519195734.2885.1666.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-probe.txt |    2 +-
 tools/perf/util/probe-finder.c          |   59 +++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index ea531d9..394016d 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -95,7 +95,7 @@ Each probe argument follows below syntax.
  [NAME=]LOCALVAR|$retval|%REG|@SYMBOL[:TYPE]
 
 'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
-'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo.
+'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
 
 LINE SYNTAX
 -----------
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index baf6653..aaea16b 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -464,18 +464,61 @@ static int convert_location(Dwarf_Op *op, struct probe_finder *pf)
 }
 
 static int convert_variable_type(Dwarf_Die *vr_die,
-				 struct kprobe_trace_arg *targ)
+				 struct kprobe_trace_arg *tvar,
+				 const char *cast)
 {
+	struct kprobe_trace_arg_ref **ref_ptr = &tvar->ref;
 	Dwarf_Die type;
 	char buf[16];
 	int ret;
 
+	/* TODO: check all types */
+	if (cast && strcmp(cast, "string") != 0) {
+		/* Non string type is OK */
+		tvar->type = strdup(cast);
+		return (tvar->type == NULL) ? -ENOMEM : 0;
+	}
+
 	if (die_get_real_type(vr_die, &type) == NULL) {
 		pr_warning("Failed to get a type information of %s.\n",
 			   dwarf_diename(vr_die));
 		return -ENOENT;
 	}
 
+	if (cast && strcmp(cast, "string") == 0) {	/* String type */
+		ret = dwarf_tag(&type);
+		if (ret != DW_TAG_pointer_type &&
+		    ret != DW_TAG_array_type) {
+			pr_warning("Failed to cast into string: "
+				   "%s(%s) is not a pointer nor array.",
+				   dwarf_diename(vr_die), dwarf_diename(&type));
+			return -EINVAL;
+		}
+		if (ret == DW_TAG_pointer_type) {
+			if (die_get_real_type(&type, &type) == NULL) {
+				pr_warning("Failed to get a type information.");
+				return -ENOENT;
+			}
+			while (*ref_ptr)
+				ref_ptr = &(*ref_ptr)->next;
+			/* Add new reference with offset +0 */
+			*ref_ptr = zalloc(sizeof(struct kprobe_trace_arg_ref));
+			if (*ref_ptr == NULL) {
+				pr_warning("Out of memory error\n");
+				return -ENOMEM;
+			}
+		}
+		if (die_compare_name(&type, "char") != 0 &&
+		    die_compare_name(&type, "unsigned char") != 0) {
+			pr_warning("Failed to cast into string: "
+				   "%s is not (unsigned) char *.",
+				   dwarf_diename(vr_die));
+			return -EINVAL;
+		}
+		tvar->type = strdup(cast);
+		return (tvar->type == NULL) ? -ENOMEM : 0;
+	}
+
 	ret = die_get_byte_size(&type) * 8;
 	if (ret) {
 		/* Check the bitwidth */
@@ -495,8 +538,8 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 				   strerror(-ret));
 			return ret;
 		}
-		targ->type = strdup(buf);
-		if (targ->type == NULL)
+		tvar->type = strdup(buf);
+		if (tvar->type == NULL)
 			return -ENOMEM;
 	}
 	return 0;
@@ -606,14 +649,8 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 					      &die_mem);
 		vr_die = &die_mem;
 	}
-	if (ret == 0) {
-		if (pf->pvar->type) {
-			pf->tvar->type = strdup(pf->pvar->type);
-			if (pf->tvar->type == NULL)
-				ret = -ENOMEM;
-		} else
-			ret = convert_variable_type(vr_die, pf->tvar);
-	}
+	if (ret == 0)
+		ret = convert_variable_type(vr_die, pf->tvar, pf->pvar->type);
 	/* *expr will be cached in libdw. Don't free it. */
 	return ret;
 error:
-- 
1.6.2.5

