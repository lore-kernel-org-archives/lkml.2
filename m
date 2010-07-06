Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0GFIie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 04:38:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:50797 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756698Ab0GFIic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 04:38:32 -0400
Date: Tue, 6 Jul 2010 08:38:02 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100519195749.2885.17451.stgit@localhost6.localdomain6>
References: <20100519195749.2885.17451.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Support static and global variables
Message-ID: <tip-b7dcb857cc3eb89136111fefe89780129c1af1d7@git.kernel.org>
Git-Commit-ID: b7dcb857cc3eb89136111fefe89780129c1af1d7
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Jul 2010 08:38:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b7dcb857cc3eb89136111fefe89780129c1af1d7
Gitweb:     http://git.kernel.org/tip/b7dcb857cc3eb89136111fefe89780129c1af1d7
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Wed, 19 May 2010 15:57:49 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 5 Jul 2010 18:51:33 -0300

perf probe: Support static and global variables

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
