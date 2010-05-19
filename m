Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab0ESTwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:52:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4982 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753772Ab0ESTw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:52:28 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 2/4] perf probe: Support "string" type
To: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Wed, 19 May 2010 15:57:35 -0400
Message-ID: <20100519195734.2885.1666.stgit@localhost6.localdomain6>
In-Reply-To: <20100519195717.2885.90799.stgit@localhost6.localdomain6>
References: <20100519195717.2885.90799.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support string type casting to event argument. If perf-probe
finds an argument casted as string, it ensures the target
variable is "(unsigned/signed) char *(or []). perf-probe also
adds dereference if the target is a pointer.
So, both of 'char buf[10];' and 'char *buf;' can be accessed
by 'buf:string'

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/Documentation/perf-probe.txt |    2 +
 tools/perf/util/probe-finder.c          |   59 +++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 94a258c..e5cf3ff 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -91,7 +91,7 @@ Each probe argument follows below syntax.
  [NAME=]LOCALVAR|$retval|%REG|@SYMBOL[:TYPE]
 
 'NAME' specifies the name of this argument (optional). You can use the name of local variable, local data structure member (e.g. var->field, var.field2), or kprobe-tracer argument format (e.g. $retval, %ax, etc). Note that the name of this argument will be set as the last member name if you specify a local data structure member (e.g. field2 for 'var->field1.field2'.)
-'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo.
+'TYPE' casts the type of this argument (optional). If omitted, perf probe automatically set the type based on debuginfo. You can specify 'string' type only for the local variable or structure member which is an array of or a pointer to 'char' or 'unsigned char' type.
 
 LINE SYNTAX
 -----------
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index d964cb1..af3868b 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -414,18 +414,61 @@ static int convert_location(Dwarf_Op *op, struct probe_finder *pf)
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
@@ -445,8 +488,8 @@ static int convert_variable_type(Dwarf_Die *vr_die,
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
@@ -556,14 +599,8 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
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
Masami Hiramatsu
e-mail: mhiramat@redhat.com
