Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0DFV7t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 17:59:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449Ab0DFV7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:59:33 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 7/8] perf probe: Remove die() from probe-finder code
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 06 Apr 2010 18:06:29 -0400
Message-ID: <20100406220629.13329.71869.stgit@localhost6.localdomain6>
In-Reply-To: <20100406220542.13329.45837.stgit@localhost6.localdomain6>
References: <20100406220542.13329.45837.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove die() and DIE_IF() code from util/probe-finder.c since
these 'sudden death' in utility functions make reusing it from
other code (especially tui/gui) difficult.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---

 tools/perf/util/probe-event.c  |    4 
 tools/perf/util/probe-finder.c |  517 +++++++++++++++++++++++++---------------
 2 files changed, 322 insertions(+), 199 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index bef2805..7893b32 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -151,10 +151,10 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 
 	/* Error path */
 	if (need_dwarf) {
-		if (ntevs == -ENOENT)
+		if (ntevs == -EBADF)
 			pr_warning("No dwarf info found in the vmlinux - "
 				"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		die("Could not analyze debuginfo.");
+		die("Failed to analyze debuginfo.");
 	}
 	pr_debug("An error occurred in debuginfo analysis."
 		 " Try to use symbols.\n");
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 1f45285..4a57504 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -196,19 +196,7 @@ static bool die_compare_name(Dwarf_Die *dw_die, const char *tname)
 {
 	const char *name;
 	name = dwarf_diename(dw_die);
-	DIE_IF(name == NULL);
-	return strcmp(tname, name);
-}
-
-/* Get entry pc(or low pc, 1st entry of ranges)  of the die */
-static Dwarf_Addr die_get_entrypc(Dwarf_Die *dw_die)
-{
-	Dwarf_Addr epc;
-	int ret;
-
-	ret = dwarf_entrypc(dw_die, &epc);
-	DIE_IF(ret == -1);
-	return epc;
+	return name ? strcmp(tname, name) : -1;
 }
 
 /* Get type die, but skip qualifiers and typedef */
@@ -390,7 +378,7 @@ static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
  */
 
 /* Show a location */
-static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
+static int convert_location(Dwarf_Op *op, struct probe_finder *pf)
 {
 	unsigned int regn;
 	Dwarf_Word offs = 0;
@@ -400,8 +388,11 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 
 	/* If this is based on frame buffer, set the offset */
 	if (op->atom == DW_OP_fbreg) {
-		if (pf->fb_ops == NULL)
-			die("The attribute of frame base is not supported.\n");
+		if (pf->fb_ops == NULL) {
+			pr_warning("The attribute of frame base is not "
+				   "supported.\n");
+			return -ENOTSUP;
+		}
 		ref = true;
 		offs = op->number;
 		op = &pf->fb_ops[0];
@@ -419,50 +410,63 @@ static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 		ref = true;
 	} else if (op->atom == DW_OP_regx) {
 		regn = op->number;
-	} else
-		die("DW_OP %d is not supported.", op->atom);
+	} else {
+		pr_warning("DW_OP %d is not supported.\n", op->atom);
+		return -ENOTSUP;
+	}
 
 	regs = get_arch_regstr(regn);
-	if (!regs)
-		die("%u exceeds max register number.", regn);
+	if (!regs) {
+		pr_warning("%u exceeds max register number.\n", regn);
+		return -ERANGE;
+	}
 
 	tvar->value = xstrdup(regs);
 	if (ref) {
 		tvar->ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
 		tvar->ref->offset = (long)offs;
 	}
+	return 0;
 }
 
-static void convert_variable_type(Dwarf_Die *vr_die,
-				  struct kprobe_trace_arg *targ)
+static int convert_variable_type(Dwarf_Die *vr_die,
+				 struct kprobe_trace_arg *targ)
 {
 	Dwarf_Die type;
 	char buf[16];
 	int ret;
 
-	if (die_get_real_type(vr_die, &type) == NULL)
-		die("Failed to get a type information of %s.",
-		    dwarf_diename(vr_die));
+	if (die_get_real_type(vr_die, &type) == NULL) {
+		pr_warning("Failed to get a type information of %s.\n",
+			   dwarf_diename(vr_die));
+		return -ENOENT;
+	}
 
 	ret = die_get_byte_size(&type) * 8;
 	if (ret) {
 		/* Check the bitwidth */
 		if (ret > MAX_BASIC_TYPE_BITS) {
-			pr_warning("  Warning: %s exceeds max-bitwidth."
-				   " Cut down to %d bits.\n",
-				   dwarf_diename(&type), MAX_BASIC_TYPE_BITS);
+			pr_info("%s exceeds max-bitwidth."
+				" Cut down to %d bits.\n",
+				dwarf_diename(&type), MAX_BASIC_TYPE_BITS);
 			ret = MAX_BASIC_TYPE_BITS;
 		}
 
 		ret = snprintf(buf, 16, "%c%d",
 			       die_is_signed_type(&type) ? 's' : 'u', ret);
-		if (ret < 0 || ret >= 16)
-			die("Failed to convert variable type.");
+		if (ret < 0 || ret >= 16) {
+			if (ret >= 16)
+				ret = -E2BIG;
+			pr_warning("Failed to convert variable type: %s\n",
+				   strerror(-ret));
+			return ret;
+		}
 		targ->type = xstrdup(buf);
 	}
+	return 0;
 }
 
-static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
+static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 				    struct perf_probe_arg_field *field,
 				    struct kprobe_trace_arg_ref **ref_ptr,
 				    Dwarf_Die *die_mem)
@@ -473,21 +477,28 @@ static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 	Dwarf_Word offs;
 
 	pr_debug("converting %s in %s\n", field->name, varname);
-	if (die_get_real_type(vr_die, &type) == NULL)
-		die("Failed to get a type information of %s.", varname);
+	if (die_get_real_type(vr_die, &type) == NULL) {
+		pr_warning("Failed to get the type of %s.\n", varname);
+		return -ENOENT;
+	}
 
 	/* Check the pointer and dereference */
 	if (dwarf_tag(&type) == DW_TAG_pointer_type) {
-		if (!field->ref)
-			die("Semantic error: %s must be referred by '->'",
-			    field->name);
+		if (!field->ref) {
+			pr_err("Semantic error: %s must be referred by '->'\n",
+			       field->name);
+			return -EINVAL;
+		}
 		/* Get the type pointed by this pointer */
-		if (die_get_real_type(&type, &type) == NULL)
-			die("Failed to get a type information of %s.", varname);
-
+		if (die_get_real_type(&type, &type) == NULL) {
+			pr_warning("Failed to get the type of %s.\n", varname);
+			return -ENOENT;
+		}
 		/* Verify it is a data structure  */
-		if (dwarf_tag(&type) != DW_TAG_structure_type)
-			die("%s is not a data structure.", varname);
+		if (dwarf_tag(&type) != DW_TAG_structure_type) {
+			pr_warning("%s is not a data structure.\n", varname);
+			return -EINVAL;
+		}
 
 		ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
 		if (*ref_ptr)
@@ -496,34 +507,46 @@ static void convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			*ref_ptr = ref;
 	} else {
 		/* Verify it is a data structure  */
-		if (dwarf_tag(&type) != DW_TAG_structure_type)
-			die("%s is not a data structure.", varname);
-
-		if (field->ref)
-			die("Semantic error: %s must be referred by '.'",
-			    field->name);
-		if (!ref)
-			die("Structure on a register is not supported yet.");
+		if (dwarf_tag(&type) != DW_TAG_structure_type) {
+			pr_warning("%s is not a data structure.\n", varname);
+			return -EINVAL;
+		}
+		if (field->ref) {
+			pr_err("Semantic error: %s must be referred by '.'\n",
+			       field->name);
+			return -EINVAL;
+		}
+		if (!ref) {
+			pr_warning("Structure on a register is not "
+				   "supported yet.\n");
+			return -ENOTSUP;
+		}
 	}
 
-	if (die_find_member(&type, field->name, die_mem) == NULL)
-		die("%s(tyep:%s) has no member %s.", varname,
-		    dwarf_diename(&type), field->name);
+	if (die_find_member(&type, field->name, die_mem) == NULL) {
+		pr_warning("%s(tyep:%s) has no member %s.\n", varname,
+			   dwarf_diename(&type), field->name);
+		return -EINVAL;
+	}
 
 	/* Get the offset of the field */
 	if (dwarf_attr(die_mem, DW_AT_data_member_location, &attr) == NULL ||
-	    dwarf_formudata(&attr, &offs) != 0)
-		die("Failed to get the offset of %s.", field->name);
+	    dwarf_formudata(&attr, &offs) != 0) {
+		pr_warning("Failed to get the offset of %s.\n", field->name);
+		return -ENOENT;
+	}
 	ref->offset += (long)offs;
 
 	/* Converting next field */
 	if (field->next)
-		convert_variable_fields(die_mem, field->name, field->next,
-					&ref, die_mem);
+		return convert_variable_fields(die_mem, field->name,
+					       field->next, &ref, die_mem);
+	else
+		return 0;
 }
 
 /* Show a variables in kprobe event format */
-static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
+static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
 	Dwarf_Attribute attr;
 	Dwarf_Die die_mem;
@@ -538,28 +561,30 @@ static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	if (ret <= 0 || nexpr == 0)
 		goto error;
 
-	convert_location(expr, pf);
-
-	if (pf->pvar->field) {
-		convert_variable_fields(vr_die, pf->pvar->var,
-					pf->pvar->field, &pf->tvar->ref,
-					&die_mem);
+	ret = convert_location(expr, pf);
+	if (ret == 0 && pf->pvar->field) {
+		ret = convert_variable_fields(vr_die, pf->pvar->var,
+					      pf->pvar->field, &pf->tvar->ref,
+					      &die_mem);
 		vr_die = &die_mem;
 	}
-	if (pf->pvar->type)
-		pf->tvar->type = xstrdup(pf->pvar->type);
-	else
-		convert_variable_type(vr_die, pf->tvar);
+	if (ret == 0) {
+		if (pf->pvar->type)
+			pf->tvar->type = xstrdup(pf->pvar->type);
+		else
+			ret = convert_variable_type(vr_die, pf->tvar);
+	}
 	/* *expr will be cached in libdw. Don't free it. */
-	return ;
+	return ret;
 error:
 	/* TODO: Support const_value */
-	die("Failed to find the location of %s at this address.\n"
-	    " Perhaps, it has been optimized out.", pf->pvar->var);
+	pr_err("Failed to find the location of %s at this address.\n"
+	       " Perhaps, it has been optimized out.\n", pf->pvar->var);
+	return -ENOENT;
 }
 
 /* Find a variable in a subprogram die */
-static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
+static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	Dwarf_Die vr_die;
 	char buf[32], *ptr;
@@ -578,19 +603,22 @@ static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 	if (!is_c_varname(pf->pvar->var)) {
 		/* Copy raw parameters */
 		pf->tvar->value = xstrdup(pf->pvar->var);
-	} else {
-		pr_debug("Searching '%s' variable in context.\n",
-			 pf->pvar->var);
-		/* Search child die for local variables and parameters. */
-		if (!die_find_variable(sp_die, pf->pvar->var, &vr_die))
-			die("Failed to find '%s' in this function.",
-			    pf->pvar->var);
-		convert_variable(&vr_die, pf);
+		return 0;
 	}
+
+	pr_debug("Searching '%s' variable in context.\n",
+		 pf->pvar->var);
+	/* Search child die for local variables and parameters. */
+	if (!die_find_variable(sp_die, pf->pvar->var, &vr_die)) {
+		pr_warning("Failed to find '%s' in this function.\n",
+			   pf->pvar->var);
+		return -ENOENT;
+	}
+	return convert_variable(&vr_die, pf);
 }
 
 /* Show a probe point to output buffer */
-static void convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
+static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	struct kprobe_trace_event *tev;
 	Dwarf_Addr eaddr;
@@ -600,22 +628,31 @@ static void convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	Dwarf_Attribute fb_attr;
 	size_t nops;
 
-	if (pf->ntevs == MAX_PROBES)
-		die("Too many( > %d) probe point found.\n", MAX_PROBES);
+	if (pf->ntevs == MAX_PROBES) {
+		pr_warning("Too many( > %d) probe point found.\n", MAX_PROBES);
+		return -ERANGE;
+	}
 	tev = &pf->tevs[pf->ntevs++];
 
 	/* If no real subprogram, find a real one */
 	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
 		sp_die = die_find_real_subprogram(&pf->cu_die,
 						 pf->addr, &die_mem);
-		if (!sp_die)
-			die("Probe point is not found in subprograms.");
+		if (!sp_die) {
+			pr_warning("Failed to find probe point in any "
+				   "functions.\n");
+			return -ENOENT;
+		}
 	}
 
 	/* Copy the name of probe point */
 	name = dwarf_diename(sp_die);
 	if (name) {
-		dwarf_entrypc(sp_die, &eaddr);
+		if (dwarf_entrypc(sp_die, &eaddr) != 0) {
+			pr_warning("Failed to get entry pc of %s\n",
+				   dwarf_diename(sp_die));
+			return -ENOENT;
+		}
 		tev->point.symbol = xstrdup(name);
 		tev->point.offset = (unsigned long)(pf->addr - eaddr);
 	} else
@@ -633,9 +670,12 @@ static void convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	} else if (nops == 1 && pf->fb_ops[0].atom == DW_OP_call_frame_cfa &&
 		   pf->cfi != NULL) {
 		Dwarf_Frame *frame;
-		ret = dwarf_cfi_addrframe(pf->cfi, pf->addr, &frame);
-		DIE_IF(ret != 0);
-		dwarf_frame_cfa(frame, &pf->fb_ops, &nops);
+		if (dwarf_cfi_addrframe(pf->cfi, pf->addr, &frame) != 0 ||
+		    dwarf_frame_cfa(frame, &pf->fb_ops, &nops) != 0) {
+			pr_warning("Failed to get CFA on 0x%jx\n",
+				   (uintmax_t)pf->addr);
+			return -ENOENT;
+		}
 	}
 
 	/* Find each argument */
@@ -644,45 +684,53 @@ static void convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	for (i = 0; i < pf->pev->nargs; i++) {
 		pf->pvar = &pf->pev->args[i];
 		pf->tvar = &tev->args[i];
-		find_variable(sp_die, pf);
+		ret = find_variable(sp_die, pf);
+		if (ret != 0)
+			return ret;
 	}
 
 	/* *pf->fb_ops will be cached in libdw. Don't free it. */
 	pf->fb_ops = NULL;
+	return 0;
 }
 
 /* Find probe point from its line number */
-static void find_probe_point_by_line(struct probe_finder *pf)
+static int find_probe_point_by_line(struct probe_finder *pf)
 {
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
 	size_t nlines, i;
 	Dwarf_Addr addr;
 	int lineno;
-	int ret;
+	int ret = 0;
 
-	ret = dwarf_getsrclines(&pf->cu_die, &lines, &nlines);
-	DIE_IF(ret != 0);
+	if (dwarf_getsrclines(&pf->cu_die, &lines, &nlines) != 0) {
+		pr_warning("No source lines found in this CU.\n");
+		return -ENOENT;
+	}
 
-	for (i = 0; i < nlines; i++) {
+	for (i = 0; i < nlines && ret == 0; i++) {
 		line = dwarf_onesrcline(lines, i);
-		dwarf_lineno(line, &lineno);
-		if (lineno != pf->lno)
+		if (dwarf_lineno(line, &lineno) != 0 ||
+		    lineno != pf->lno)
 			continue;
 
 		/* TODO: Get fileno from line, but how? */
 		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
 			continue;
 
-		ret = dwarf_lineaddr(line, &addr);
-		DIE_IF(ret != 0);
+		if (dwarf_lineaddr(line, &addr) != 0) {
+			pr_warning("Failed to get the address of the line.\n");
+			return -ENOENT;
+		}
 		pr_debug("Probe line found: line[%d]:%d addr:0x%jx\n",
 			 (int)i, lineno, (uintmax_t)addr);
 		pf->addr = addr;
 
-		convert_probe_point(NULL, pf);
+		ret = convert_probe_point(NULL, pf);
 		/* Continuing, because target line might be inlined. */
 	}
+	return ret;
 }
 
 /* Find lines which match lazy pattern */
@@ -690,15 +738,27 @@ static int find_lazy_match_lines(struct list_head *head,
 				 const char *fname, const char *pat)
 {
 	char *fbuf, *p1, *p2;
-	int fd, line, nlines = 0;
+	int fd, ret, line, nlines = 0;
 	struct stat st;
 
 	fd = open(fname, O_RDONLY);
-	if (fd < 0)
-		die("failed to open %s", fname);
-	DIE_IF(fstat(fd, &st) < 0);
+	if (fd < 0) {
+		pr_warning("Failed to open %s: %s\n", fname, strerror(-fd));
+		return fd;
+	}
+
+	ret = fstat(fd, &st);
+	if (ret < 0) {
+		pr_warning("Failed to get the size of %s: %s\n",
+			   fname, strerror(errno));
+		return ret;
+	}
 	fbuf = xmalloc(st.st_size + 2);
-	DIE_IF(read(fd, fbuf, st.st_size) < 0);
+	ret = read(fd, fbuf, st.st_size);
+	if (ret < 0) {
+		pr_warning("Failed to read %s: %s\n", fname, strerror(errno));
+		return ret;
+	}
 	close(fd);
 	fbuf[st.st_size] = '\n';	/* Dummy line */
 	fbuf[st.st_size + 1] = '\0';
@@ -718,7 +778,7 @@ static int find_lazy_match_lines(struct list_head *head,
 }
 
 /* Find probe points from lazy pattern  */
-static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
+static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
@@ -726,31 +786,40 @@ static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 	Dwarf_Addr addr;
 	Dwarf_Die die_mem;
 	int lineno;
-	int ret;
+	int ret = 0;
 
 	if (list_empty(&pf->lcache)) {
 		/* Matching lazy line pattern */
 		ret = find_lazy_match_lines(&pf->lcache, pf->fname,
 					    pf->pev->point.lazy_line);
-		if (ret <= 0)
-			die("No matched lines found in %s.", pf->fname);
+		if (ret == 0) {
+			pr_debug("No matched lines found in %s.\n", pf->fname);
+			return 0;
+		} else if (ret < 0)
+			return ret;
 	}
 
-	ret = dwarf_getsrclines(&pf->cu_die, &lines, &nlines);
-	DIE_IF(ret != 0);
-	for (i = 0; i < nlines; i++) {
+	if (dwarf_getsrclines(&pf->cu_die, &lines, &nlines) != 0) {
+		pr_warning("No source lines found in this CU.\n");
+		return -ENOENT;
+	}
+
+	for (i = 0; i < nlines && ret >= 0; i++) {
 		line = dwarf_onesrcline(lines, i);
 
-		dwarf_lineno(line, &lineno);
-		if (!line_list__has_line(&pf->lcache, lineno))
+		if (dwarf_lineno(line, &lineno) != 0 ||
+		    !line_list__has_line(&pf->lcache, lineno))
 			continue;
 
 		/* TODO: Get fileno from line, but how? */
 		if (strtailcmp(dwarf_linesrc(line, NULL, NULL), pf->fname) != 0)
 			continue;
 
-		ret = dwarf_lineaddr(line, &addr);
-		DIE_IF(ret != 0);
+		if (dwarf_lineaddr(line, &addr) != 0) {
+			pr_debug("Failed to get the address of line %d.\n",
+				 lineno);
+			continue;
+		}
 		if (sp_die) {
 			/* Address filtering 1: does sp_die include addr? */
 			if (!dwarf_haspc(sp_die, addr))
@@ -764,27 +833,42 @@ static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 			 (int)i, lineno, (unsigned long long)addr);
 		pf->addr = addr;
 
-		convert_probe_point(sp_die, pf);
+		ret = convert_probe_point(sp_die, pf);
 		/* Continuing, because target line might be inlined. */
 	}
 	/* TODO: deallocate lines, but how? */
+	return ret;
 }
 
+/* Callback parameter with return value */
+struct dwarf_callback_param {
+	void *data;
+	int retval;
+};
+
 static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	struct probe_finder *pf = (struct probe_finder *)data;
+	struct dwarf_callback_param *param = data;
+	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
+	Dwarf_Addr addr;
 
 	if (pp->lazy_line)
-		find_probe_point_lazy(in_die, pf);
+		param->retval = find_probe_point_lazy(in_die, pf);
 	else {
 		/* Get probe address */
-		pf->addr = die_get_entrypc(in_die);
+		if (dwarf_entrypc(in_die, &addr) != 0) {
+			pr_warning("Failed to get entry pc of %s.\n",
+				   dwarf_diename(in_die));
+			param->retval = -ENOENT;
+			return DWARF_CB_ABORT;
+		}
+		pf->addr = addr;
 		pf->addr += pp->offset;
 		pr_debug("found inline addr: 0x%jx\n",
 			 (uintmax_t)pf->addr);
 
-		convert_probe_point(in_die, pf);
+		param->retval = convert_probe_point(in_die, pf);
 	}
 
 	return DWARF_CB_OK;
@@ -793,39 +877,53 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 /* Search function from function name */
 static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 {
-	struct probe_finder *pf = (struct probe_finder *)data;
+	struct dwarf_callback_param *param = data;
+	struct probe_finder *pf = param->data;
 	struct perf_probe_point *pp = &pf->pev->point;
 
 	/* Check tag and diename */
 	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
 	    die_compare_name(sp_die, pp->function) != 0)
-		return 0;
+		return DWARF_CB_OK;
 
 	pf->fname = dwarf_decl_file(sp_die);
 	if (pp->line) { /* Function relative line */
 		dwarf_decl_line(sp_die, &pf->lno);
 		pf->lno += pp->line;
-		find_probe_point_by_line(pf);
+		param->retval = find_probe_point_by_line(pf);
 	} else if (!dwarf_func_inline(sp_die)) {
 		/* Real function */
 		if (pp->lazy_line)
-			find_probe_point_lazy(sp_die, pf);
+			param->retval = find_probe_point_lazy(sp_die, pf);
 		else {
-			pf->addr = die_get_entrypc(sp_die);
+			if (dwarf_entrypc(sp_die, &pf->addr) != 0) {
+				pr_warning("Failed to get entry pc of %s.\n",
+					   dwarf_diename(sp_die));
+				param->retval = -ENOENT;
+				return DWARF_CB_ABORT;
+			}
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
-			convert_probe_point(sp_die, pf);
+			param->retval = convert_probe_point(sp_die, pf);
 		}
-	} else
+	} else {
+		struct dwarf_callback_param _param = {.data = (void *)pf,
+						      .retval = 0};
 		/* Inlined function: search instances */
-		dwarf_func_inline_instances(sp_die, probe_point_inline_cb, pf);
+		dwarf_func_inline_instances(sp_die, probe_point_inline_cb,
+					    &_param);
+		param->retval = _param.retval;
+	}
 
-	return 1; /* Exit; no same symbol in this CU. */
+	return DWARF_CB_ABORT; /* Exit; no same symbol in this CU. */
 }
 
-static void find_probe_point_by_func(struct probe_finder *pf)
+static int find_probe_point_by_func(struct probe_finder *pf)
 {
-	dwarf_getfuncs(&pf->cu_die, probe_point_search_cb, pf, 0);
+	struct dwarf_callback_param _param = {.data = (void *)pf,
+					      .retval = 0};
+	dwarf_getfuncs(&pf->cu_die, probe_point_search_cb, &_param, 0);
+	return _param.retval;
 }
 
 /* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
@@ -838,14 +936,18 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	size_t cuhl;
 	Dwarf_Die *diep;
 	Dwarf *dbg;
+	int ret = 0;
 
 	pf.tevs = xzalloc(sizeof(struct kprobe_trace_event) * MAX_PROBES);
 	*tevs = pf.tevs;
 	pf.ntevs = 0;
 
 	dbg = dwarf_begin(fd, DWARF_C_READ);
-	if (!dbg)
-		return -ENOENT;
+	if (!dbg) {
+		pr_warning("No dwarf info found in the vmlinux - "
+			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		return -EBADF;
+	}
 
 	/* Get the call frame information from this dwarf */
 	pf.cfi = dwarf_getcfi(dbg);
@@ -853,7 +955,8 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	off = 0;
 	line_list__init(&pf.lcache);
 	/* Loop on CUs (Compilation Unit) */
-	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL)) {
+	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) &&
+	       ret >= 0) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
 		diep = dwarf_offdie(dbg, off + cuhl, &pf.cu_die);
 		if (!diep)
@@ -867,12 +970,12 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 
 		if (!pp->file || pf.fname) {
 			if (pp->function)
-				find_probe_point_by_func(&pf);
+				ret = find_probe_point_by_func(&pf);
 			else if (pp->lazy_line)
-				find_probe_point_lazy(NULL, &pf);
+				ret = find_probe_point_lazy(NULL, &pf);
 			else {
 				pf.lno = pp->line;
-				find_probe_point_by_line(&pf);
+				ret = find_probe_point_by_line(&pf);
 			}
 		}
 		off = noff;
@@ -880,7 +983,7 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	line_list__free(&pf.lcache);
 	dwarf_end(dbg);
 
-	return pf.ntevs;
+	return (ret < 0) ? ret : pf.ntevs;
 }
 
 /* Reverse search */
@@ -893,10 +996,11 @@ int find_perf_probe_point(int fd, unsigned long addr,
 	Dwarf_Addr laddr, eaddr;
 	const char *tmp;
 	int lineno, ret = 0;
+	bool found = false;
 
 	dbg = dwarf_begin(fd, DWARF_C_READ);
 	if (!dbg)
-		return -ENOENT;
+		return -EBADF;
 
 	/* Find cu die */
 	if (!dwarf_addrdie(dbg, (Dwarf_Addr)addr, &cudie)) {
@@ -907,82 +1011,87 @@ int find_perf_probe_point(int fd, unsigned long addr,
 	/* Find a corresponding line */
 	line = dwarf_getsrc_die(&cudie, (Dwarf_Addr)addr);
 	if (line) {
-		dwarf_lineaddr(line, &laddr);
-		if ((Dwarf_Addr)addr == laddr) {
-			dwarf_lineno(line, &lineno);
-			ppt->line = lineno;
-
+		if (dwarf_lineaddr(line, &laddr) == 0 &&
+		    (Dwarf_Addr)addr == laddr &&
+		    dwarf_lineno(line, &lineno) == 0) {
 			tmp = dwarf_linesrc(line, NULL, NULL);
-			DIE_IF(!tmp);
-			ppt->file = xstrdup(tmp);
-			ret = 1;
+			if (tmp) {
+				ppt->line = lineno;
+				ppt->file = xstrdup(tmp);
+				found = true;
+			}
 		}
 	}
 
 	/* Find a corresponding function */
 	if (die_find_real_subprogram(&cudie, (Dwarf_Addr)addr, &spdie)) {
 		tmp = dwarf_diename(&spdie);
-		if (!tmp)
+		if (!tmp || dwarf_entrypc(&spdie, &eaddr) != 0)
 			goto end;
 
-		dwarf_entrypc(&spdie, &eaddr);
-		if (!lineno) {
-			/* We don't have a line number, let's use offset */
-			ppt->function = xstrdup(tmp);
-			ppt->offset = addr - (unsigned long)eaddr;
-			ret = 1;
-			goto end;
-		}
-		if (die_find_inlinefunc(&spdie, (Dwarf_Addr)addr, &indie)) {
-			/* addr in an inline function */
-			tmp = dwarf_diename(&indie);
-			if (!tmp)
-				goto end;
-			dwarf_decl_line(&indie, &lineno);
-		} else {
-			if (eaddr == addr)	/* No offset: function entry */
-				lineno = ppt->line;
-			else
-				dwarf_decl_line(&spdie, &lineno);
+		if (ppt->line) {
+			if (die_find_inlinefunc(&spdie, (Dwarf_Addr)addr,
+						&indie)) {
+				/* addr in an inline function */
+				tmp = dwarf_diename(&indie);
+				if (!tmp)
+					goto end;
+				ret = dwarf_decl_line(&indie, &lineno);
+			} else {
+				if (eaddr == addr) {	/* Function entry */
+					lineno = ppt->line;
+					ret = 0;
+				} else
+					ret = dwarf_decl_line(&spdie, &lineno);
+			}
+			if (ret == 0) {
+				/* Make a relative line number */
+				ppt->line -= lineno;
+				goto found;
+			}
 		}
+		/* We don't have a line number, let's use offset */
+		ppt->offset = addr - (unsigned long)eaddr;
+found:
 		ppt->function = xstrdup(tmp);
-		ppt->line -= lineno;	/* Make a relative line number */
+		found = true;
 	}
 
 end:
 	dwarf_end(dbg);
+	if (ret >= 0)
+		ret = found ? 1 : 0;
 	return ret;
 }
 
 
 /* Find line range from its line number */
-static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
+static int find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 {
 	Dwarf_Lines *lines;
 	Dwarf_Line *line;
 	size_t nlines, i;
 	Dwarf_Addr addr;
 	int lineno;
-	int ret;
 	const char *src;
 	Dwarf_Die die_mem;
 
 	line_list__init(&lf->lr->line_list);
-	ret = dwarf_getsrclines(&lf->cu_die, &lines, &nlines);
-	DIE_IF(ret != 0);
+	if (dwarf_getsrclines(&lf->cu_die, &lines, &nlines) != 0) {
+		pr_warning("No source lines found in this CU.\n");
+		return -ENOENT;
+	}
 
 	for (i = 0; i < nlines; i++) {
 		line = dwarf_onesrcline(lines, i);
-		ret = dwarf_lineno(line, &lineno);
-		DIE_IF(ret != 0);
-		if (lf->lno_s > lineno || lf->lno_e < lineno)
+		if (dwarf_lineno(line, &lineno) != 0 ||
+		    (lf->lno_s > lineno || lf->lno_e < lineno))
 			continue;
 
 		if (sp_die) {
 			/* Address filtering 1: does sp_die include addr? */
-			ret = dwarf_lineaddr(line, &addr);
-			DIE_IF(ret != 0);
-			if (!dwarf_haspc(sp_die, addr))
+			if (dwarf_lineaddr(line, &addr) != 0 ||
+			    !dwarf_haspc(sp_die, addr))
 				continue;
 
 			/* Address filtering 2: No child include addr? */
@@ -1007,18 +1116,22 @@ static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 		free(lf->lr->path);
 		lf->lr->path = NULL;
 	}
+	return lf->found;
 }
 
 static int line_range_inline_cb(Dwarf_Die *in_die, void *data)
 {
-	find_line_range_by_line(in_die, (struct line_finder *)data);
+	struct dwarf_callback_param *param = data;
+
+	param->retval = find_line_range_by_line(in_die, param->data);
 	return DWARF_CB_ABORT;	/* No need to find other instances */
 }
 
 /* Search function from function name */
 static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 {
-	struct line_finder *lf = (struct line_finder *)data;
+	struct dwarf_callback_param *param = data;
+	struct line_finder *lf = param->data;
 	struct line_range *lr = lf->lr;
 
 	if (dwarf_tag(sp_die) == DW_TAG_subprogram &&
@@ -1033,38 +1146,47 @@ static int line_range_search_cb(Dwarf_Die *sp_die, void *data)
 			lf->lno_e = lr->offset + lr->end;
 		lr->start = lf->lno_s;
 		lr->end = lf->lno_e;
-		if (dwarf_func_inline(sp_die))
+		if (dwarf_func_inline(sp_die)) {
+			struct dwarf_callback_param _param;
+			_param.data = (void *)lf;
+			_param.retval = 0;
 			dwarf_func_inline_instances(sp_die,
-						    line_range_inline_cb, lf);
-		else
-			find_line_range_by_line(sp_die, lf);
-		return 1;
+						    line_range_inline_cb,
+						    &_param);
+			param->retval = _param.retval;
+		} else
+			param->retval = find_line_range_by_line(sp_die, lf);
+		return DWARF_CB_ABORT;
 	}
-	return 0;
+	return DWARF_CB_OK;
 }
 
-static void find_line_range_by_func(struct line_finder *lf)
+static int find_line_range_by_func(struct line_finder *lf)
 {
-	dwarf_getfuncs(&lf->cu_die, line_range_search_cb, lf, 0);
+	struct dwarf_callback_param param = {.data = (void *)lf, .retval = 0};
+	dwarf_getfuncs(&lf->cu_die, line_range_search_cb, &param, 0);
+	return param.retval;
 }
 
 int find_line_range(int fd, struct line_range *lr)
 {
 	struct line_finder lf = {.lr = lr, .found = 0};
-	int ret;
+	int ret = 0;
 	Dwarf_Off off = 0, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
 	Dwarf *dbg;
 
 	dbg = dwarf_begin(fd, DWARF_C_READ);
-	if (!dbg)
-		return -ENOENT;
+	if (!dbg) {
+		pr_warning("No dwarf info found in the vmlinux - "
+			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		return -EBADF;
+	}
 
 	/* Loop on CUs (Compilation Unit) */
-	while (!lf.found) {
-		ret = dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL);
-		if (ret != 0)
+	while (!lf.found && ret >= 0) {
+		if (dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) != 0)
 			break;
 
 		/* Get the DIE(Debugging Information Entry) of this CU */
@@ -1080,20 +1202,21 @@ int find_line_range(int fd, struct line_range *lr)
 
 		if (!lr->file || lf.fname) {
 			if (lr->function)
-				find_line_range_by_func(&lf);
+				ret = find_line_range_by_func(&lf);
 			else {
 				lf.lno_s = lr->start;
 				if (!lr->end)
 					lf.lno_e = INT_MAX;
 				else
 					lf.lno_e = lr->end;
-				find_line_range_by_line(NULL, &lf);
+				ret = find_line_range_by_line(NULL, &lf);
 			}
 		}
 		off = noff;
 	}
 	pr_debug("path: %lx\n", (unsigned long)lr->path);
 	dwarf_end(dbg);
-	return lf.found;
+
+	return (ret < 0) ? ret : lf.found;
 }
 


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
