Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757350Ab0DOH3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:29:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:38058 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757252Ab0DOH3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:29:11 -0400
Date: Thu, 15 Apr 2010 07:28:44 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100412171715.3790.23730.stgit@localhost6.localdomain6>
References: <20100412171715.3790.23730.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Query basic types from debuginfo
Message-ID: <tip-4984912eb23113a4007940cd09c8351c0623ea5f@git.kernel.org>
Git-Commit-ID: 4984912eb23113a4007940cd09c8351c0623ea5f
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:28:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4984912eb23113a4007940cd09c8351c0623ea5f
Gitweb:     http://git.kernel.org/tip/4984912eb23113a4007940cd09c8351c0623ea5f
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 12 Apr 2010 13:17:15 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:27:56 -0300

perf probe: Query basic types from debuginfo

Query the basic type information (byte-size and signed-flag) from
debuginfo and pass that to kprobe-tracer. This is especially useful
for tracing the members of data structure, because each member has
different byte-size on the memory.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100412171715.3790.23730.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |    9 +++++
 tools/perf/util/probe-event.h  |    1 +
 tools/perf/util/probe-finder.c |   78 +++++++++++++++++++++++++++++++++++----
 3 files changed, 80 insertions(+), 8 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 19de8b7..05ca4a9 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -740,6 +740,13 @@ static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
 		buf += ret;
 		buflen -= ret;
 	}
+	/* Print argument type */
+	if (arg->type) {
+		ret = e_snprintf(buf, buflen, ":%s", arg->type);
+		if (ret <= 0)
+			return ret;
+		buf += ret;
+	}
 
 	return buf - tmp;
 }
@@ -848,6 +855,8 @@ void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
 			free(tev->args[i].name);
 		if (tev->args[i].value)
 			free(tev->args[i].value);
+		if (tev->args[i].type)
+			free(tev->args[i].type);
 		ref = tev->args[i].ref;
 		while (ref) {
 			next = ref->next;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 10411f5..a393a3f 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -23,6 +23,7 @@ struct kprobe_trace_arg_ref {
 struct kprobe_trace_arg {
 	char				*name;	/* Argument name */
 	char				*value;	/* Base value */
+	char				*type;	/* Type name */
 	struct kprobe_trace_arg_ref	*ref;	/* Referencing offset */
 };
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 105e95c..ebeb413 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -84,6 +84,9 @@ const char *x86_64_regs_table[X86_64_MAX_REGS] = {
 #define arch_regs_table x86_32_regs_table
 #endif
 
+/* Kprobe tracer basic type is up to u64 */
+#define MAX_BASIC_TYPE_BITS	64
+
 /* Return architecture dependent register string (for kprobe-tracer) */
 static const char *get_arch_regstr(unsigned int n)
 {
@@ -230,6 +233,31 @@ static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
 	return die_mem;
 }
 
+static bool die_is_signed_type(Dwarf_Die *tp_die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Word ret;
+
+	if (dwarf_attr(tp_die, DW_AT_encoding, &attr) == NULL ||
+	    dwarf_formudata(&attr, &ret) != 0)
+		return false;
+
+	return (ret == DW_ATE_signed_char || ret == DW_ATE_signed ||
+		ret == DW_ATE_signed_fixed);
+}
+
+static int die_get_byte_size(Dwarf_Die *tp_die)
+{
+	Dwarf_Attribute attr;
+	Dwarf_Word ret;
+
+	if (dwarf_attr(tp_die, DW_AT_byte_size, &attr) == NULL ||
+	    dwarf_formudata(&attr, &ret) != 0)
+		return 0;
+
+	return (int)ret;
+}
+
 /* Return values for die_find callbacks */
 enum {
 	DIE_FIND_CB_FOUND = 0,		/* End of Search */
@@ -406,13 +434,42 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 	}
 }
 
+static void convert_variable_type(Dwarf_Die *vr_die,
+				  struct kprobe_trace_arg *targ)
+{
+	Dwarf_Die type;
+	char buf[16];
+	int ret;
+
+	if (die_get_real_type(vr_die, &type) == NULL)
+		die("Failed to get a type information of %s.",
+		    dwarf_diename(vr_die));
+
+	ret = die_get_byte_size(&type) * 8;
+	if (ret) {
+		/* Check the bitwidth */
+		if (ret > MAX_BASIC_TYPE_BITS) {
+			pr_warning("  Warning: %s exceeds max-bitwidth."
+				   " Cut down to %d bits.\n",
+				   dwarf_diename(&type), MAX_BASIC_TYPE_BITS);
+			ret = MAX_BASIC_TYPE_BITS;
+		}
+
+		ret = snprintf(buf, 16, "%c%d",
+			       die_is_signed_type(&type) ? 's' : 'u', ret);
+		if (ret < 0 || ret >= 16)
+			die("Failed to convert variable type.");
+		targ->type = xstrdup(buf);
+	}
+}
+
 static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 				    struct perf_probe_arg_field *field,
-				    struct kprobe_trace_arg_ref **ref_ptr)
+				    struct kprobe_trace_arg_ref **ref_ptr,
+				    Dwarf_Die *die_mem)
 {
 	struct kprobe_trace_arg_ref *ref = *ref_ptr;
 	Dwarf_Attribute attr;
-	Dwarf_Die member;
 	Dwarf_Die type;
 	Dwarf_Word offs;
 
@@ -450,26 +507,27 @@ static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			die("Structure on a register is not supported yet.");
 	}
 
-	if (die_find_member(&type, field->name, &member) == NULL)
+	if (die_find_member(&type, field->name, die_mem) == NULL)
 		die("%s(tyep:%s) has no member %s.", varname,
 		    dwarf_diename(&type), field->name);
 
 	/* Get the offset of the field */
-	if (dwarf_attr(&member, DW_AT_data_member_location, &attr) == NULL ||
+	if (dwarf_attr(die_mem, DW_AT_data_member_location, &attr) == NULL ||
 	    dwarf_formudata(&attr, &offs) != 0)
 		die("Failed to get the offset of %s.", field->name);
 	ref->offset += (long)offs;
 
 	/* Converting next field */
 	if (field->next)
-		convert_variable_fields(&member, field->name, field->next,
-					&ref);
+		convert_variable_fields(die_mem, field->name, field->next,
+					&ref, die_mem);
 }
 
 /* Show a variables in kprobe event format */
 static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
 	Dwarf_Attribute attr;
+	Dwarf_Die die_mem;
 	Dwarf_Op *expr;
 	size_t nexpr;
 	int ret;
@@ -483,9 +541,13 @@ static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 
 	convert_location(expr, pf);
 
-	if (pf->pvar->field)
+	if (pf->pvar->field) {
 		convert_variable_fields(vr_die, pf->pvar->var,
-					pf->pvar->field, &pf->tvar->ref);
+					pf->pvar->field, &pf->tvar->ref,
+					&die_mem);
+		vr_die = &die_mem;
+	}
+	convert_variable_type(vr_die, pf->tvar);
 	/* *expr will be cached in libdw. Don't free it. */
 	return ;
 error:
