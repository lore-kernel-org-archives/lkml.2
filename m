Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab0GFBFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 21:05:11 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41812 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0GFBEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 21:04:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Masami Hiramatsu <mhiramat@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf probe: Support static and global variables
Date: Mon,  5 Jul 2010 22:04:36 -0300
Message-Id: <1278378276-25872-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1278378276-25872-1-git-send-email-acme@infradead.org>
References: <1278378276-25872-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <mhiramat@redhat.com>

Add static and global variables support to perf probe.
This allows user to trace non-local variables (and
structure members) at probe points.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100519195749.2885.17451.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |   15 ++++++-
 tools/perf/util/probe-finder.c |   85 ++++++++++++++++++++++++++++-----------
 2 files changed, 73 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 351baa9..09cf546 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -926,6 +926,7 @@ out:
 static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
 				       char *buf, size_t buflen)
 {
+	struct kprobe_trace_arg_ref *ref = arg->ref;
 	int ret, depth = 0;
 	char *tmp = buf;
 
@@ -939,16 +940,24 @@ static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
 	buf += ret;
 	buflen -= ret;
 
+	/* Special case: @XXX */
+	if (arg->value[0] == '@' && arg->ref)
+			ref = ref->next;
+
 	/* Dereferencing arguments */
-	if (arg->ref) {
-		depth = __synthesize_kprobe_trace_arg_ref(arg->ref, &buf,
+	if (ref) {
+		depth = __synthesize_kprobe_trace_arg_ref(ref, &buf,
 							  &buflen, 1);
 		if (depth < 0)
 			return depth;
 	}
 
 	/* Print argument value */
-	ret = e_snprintf(buf, buflen, "%s", arg->value);
+	if (arg->value[0] == '@' && arg->ref)
+		ret = e_snprintf(buf, buflen, "%s%+ld", arg->value,
+				 arg->ref->offset);
+	else
+		ret = e_snprintf(buf, buflen, "%s", arg->value);
 	if (ret < 0)
 		return ret;
 	buf += ret;
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 308664d..3e64e1f 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -406,14 +406,50 @@ static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
  * Probe finder related functions
  */
 
+static struct kprobe_trace_arg_ref *alloc_trace_arg_ref(long offs)
+{
+	struct kprobe_trace_arg_ref *ref;
+	ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+	if (ref != NULL)
+		ref->offset = offs;
+	return ref;
+}
+
 /* Show a location */
-static int convert_location(Dwarf_Op *op, struct probe_finder *pf)
+static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
+	Dwarf_Attribute attr;
+	Dwarf_Op *op;
+	size_t nops;
 	unsigned int regn;
 	Dwarf_Word offs = 0;
 	bool ref = false;
 	const char *regs;
 	struct kprobe_trace_arg *tvar = pf->tvar;
+	int ret;
+
+	/* TODO: handle more than 1 exprs */
+	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL ||
+	    dwarf_getlocation_addr(&attr, pf->addr, &op, &nops, 1) <= 0 ||
+	    nops == 0) {
+		/* TODO: Support const_value */
+		pr_err("Failed to find the location of %s at this address.\n"
+		       " Perhaps, it has been optimized out.\n", pf->pvar->var);
+		return -ENOENT;
+	}
+
+	if (op->atom == DW_OP_addr) {
+		/* Static variables on memory (not stack), make @varname */
+		ret = strlen(dwarf_diename(vr_die));
+		tvar->value = zalloc(ret + 2);
+		if (tvar->value == NULL)
+			return -ENOMEM;
+		snprintf(tvar->value, ret + 2, "@%s", dwarf_diename(vr_die));
+		tvar->ref = alloc_trace_arg_ref((long)offs);
+		if (tvar->ref == NULL)
+			return -ENOMEM;
+		return 0;
+	}
 
 	/* If this is based on frame buffer, set the offset */
 	if (op->atom == DW_OP_fbreg) {
@@ -455,10 +491,9 @@ static int convert_location(Dwarf_Op *op, struct probe_finder *pf)
 		return -ENOMEM;
 
 	if (ref) {
-		tvar->ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+		tvar->ref = alloc_trace_arg_ref((long)offs);
 		if (tvar->ref == NULL)
 			return -ENOMEM;
-		tvar->ref->offset = (long)offs;
 	}
 	return 0;
 }
@@ -666,20 +701,13 @@ next:
 /* Show a variables in kprobe event format */
 static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
-	Dwarf_Attribute attr;
 	Dwarf_Die die_mem;
-	Dwarf_Op *expr;
-	size_t nexpr;
 	int ret;
 
-	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL)
-		goto error;
-	/* TODO: handle more than 1 exprs */
-	ret = dwarf_getlocation_addr(&attr, pf->addr, &expr, &nexpr, 1);
-	if (ret <= 0 || nexpr == 0)
-		goto error;
+	pr_debug("Converting variable %s into trace event.\n",
+		 dwarf_diename(vr_die));
 
-	ret = convert_location(expr, pf);
+	ret = convert_variable_location(vr_die, pf);
 	if (ret == 0 && pf->pvar->field) {
 		ret = convert_variable_fields(vr_die, pf->pvar->var,
 					      pf->pvar->field, &pf->tvar->ref,
@@ -690,19 +718,14 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 		ret = convert_variable_type(vr_die, pf->tvar, pf->pvar->type);
 	/* *expr will be cached in libdw. Don't free it. */
 	return ret;
-error:
-	/* TODO: Support const_value */
-	pr_err("Failed to find the location of %s at this address.\n"
-	       " Perhaps, it has been optimized out.\n", pf->pvar->var);
-	return -ENOENT;
 }
 
 /* Find a variable in a subprogram die */
 static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
-	Dwarf_Die vr_die;
+	Dwarf_Die vr_die, *scopes;
 	char buf[32], *ptr;
-	int ret;
+	int ret, nscopes;
 
 	if (pf->pvar->name)
 		pf->tvar->name = strdup(pf->pvar->name);
@@ -730,12 +753,26 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	pr_debug("Searching '%s' variable in context.\n",
 		 pf->pvar->var);
 	/* Search child die for local variables and parameters. */
-	if (!die_find_variable(sp_die, pf->pvar->var, &vr_die)) {
+	if (die_find_variable(sp_die, pf->pvar->var, &vr_die))
+		ret = convert_variable(&vr_die, pf);
+	else {
+		/* Search upper class */
+		nscopes = dwarf_getscopes_die(sp_die, &scopes);
+		if (nscopes > 0) {
+			ret = dwarf_getscopevar(scopes, nscopes, pf->pvar->var,
+						0, NULL, 0, 0, &vr_die);
+			if (ret >= 0)
+				ret = convert_variable(&vr_die, pf);
+			else
+				ret = -ENOENT;
+			free(scopes);
+		} else
+			ret = -ENOENT;
+	}
+	if (ret < 0)
 		pr_warning("Failed to find '%s' in this function.\n",
 			   pf->pvar->var);
-		return -ENOENT;
-	}
-	return convert_variable(&vr_die, pf);
+	return ret;
 }
 
 /* Show a probe point to output buffer */
-- 
1.6.2.5

