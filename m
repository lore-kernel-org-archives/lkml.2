Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab0GFIhy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:37:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:50763 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756820Ab0GFIhw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:37:52 -0400
Date: Tue, 6 Jul 2010 08:37:24 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100519195734.2885.1666.stgit@localhost6.localdomain6>
References: <20100519195734.2885.1666.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Support "string" type
Message-ID: <tip-73317b954041031249e8968d2e9023ff4e960d99@git.kernel.org>
Git-Commit-ID: 73317b954041031249e8968d2e9023ff4e960d99
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Jul 2010 08:37:24 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  73317b954041031249e8968d2e9023ff4e960d99
Gitweb:     http://git.kernel.org/tip/73317b954041031249e8968d2e9023ff4e960d99
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 19 May 2010 15:57:35 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Jul 2010 18:47:28 -0300

perf probe: Support "string" type

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
