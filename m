Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab0JUKL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 06:11:59 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:41967 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135Ab0JUKLz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 06:11:55 -0400
X-AuditID: b753bd60-a98ddba000000a18-c2-4cc011e7a4a0
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip  4/7] perf probe: Show accessible local variables
To: Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, 2nddept-manager@sdl.hitachi.co.jp,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
Date: Thu, 21 Oct 2010 19:13:23 +0900
Message-ID: <20101021101323.3542.40282.stgit@ltc236.sdl.hitachi.co.jp>
In-Reply-To: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
References: <20101021101243.3542.28282.stgit@ltc236.sdl.hitachi.co.jp>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add -V (--vars) option for listing accessible local
variables at given probe point. This will help finding
which local variables are available for event arguments.

e.g.)
# perf probe -V call_timer_fn:23
Available variables at call_timer_fn:23
        @<run_timer_softirq+345>
                function_type*  fn
                int     preempt_count
                long unsigned int       data
                struct list_head        work_list
                struct list_head*       head
                struct timer_list*      timer
                struct tvec_base*       base


Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org
---

 tools/perf/Documentation/perf-probe.txt |    7 +
 tools/perf/builtin-probe.c              |   61 ++++-
 tools/perf/util/probe-event.c           |   72 +++++
 tools/perf/util/probe-event.h           |    8 +
 tools/perf/util/probe-finder.c          |  412 ++++++++++++++++++++++++-------
 tools/perf/util/probe-finder.h          |   25 ++
 6 files changed, 480 insertions(+), 105 deletions(-)

diff --git a/tools/perf/Documentation/perf-probe.txt b/tools/perf/Documentation/perf-probe.txt
index 27d52da..72f5d9e 100644
--- a/tools/perf/Documentation/perf-probe.txt
+++ b/tools/perf/Documentation/perf-probe.txt
@@ -17,6 +17,8 @@ or
 'perf probe' --list
 or
 'perf probe' --line='FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]'
+or
+'perf probe' --vars='PROBEPOINT'
 
 DESCRIPTION
 -----------
@@ -57,6 +59,11 @@ OPTIONS
 	Show source code lines which can be probed. This needs an argument
 	which specifies a range of the source code. (see LINE SYNTAX for detail)
 
+-V::
+--vars=::
+	Show available local variables at given probe point. The argument
+	syntax is same as PROBE SYNTAX, but NO ARGs.
+
 -f::
 --force::
 	Forcibly add events with existing name.
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 199d5e1..91bb6cf 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -50,6 +50,8 @@ static struct {
 	bool list_events;
 	bool force_add;
 	bool show_lines;
+	bool show_vars;
+	bool mod_events;
 	int nevents;
 	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
@@ -57,7 +59,6 @@ static struct {
 	int max_probe_points;
 } params;
 
-
 /* Parse an event definition. Note that any error must die. */
 static int parse_probe_event(const char *str)
 {
@@ -92,6 +93,7 @@ static int parse_probe_event_argv(int argc, const char **argv)
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += sprintf(&buf[len], "%s ", argv[i]);
+	params.mod_events = true;
 	ret = parse_probe_event(buf);
 	free(buf);
 	return ret;
@@ -100,9 +102,10 @@ static int parse_probe_event_argv(int argc, const char **argv)
 static int opt_add_probe_event(const struct option *opt __used,
 			      const char *str, int unset __used)
 {
-	if (str)
+	if (str) {
+		params.mod_events = true;
 		return parse_probe_event(str);
-	else
+	} else
 		return 0;
 }
 
@@ -110,6 +113,7 @@ static int opt_del_probe_event(const struct option *opt __used,
 			       const char *str, int unset __used)
 {
 	if (str) {
+		params.mod_events = true;
 		if (!params.dellist)
 			params.dellist = strlist__new(true, NULL);
 		strlist__add(params.dellist, str);
@@ -130,6 +134,25 @@ static int opt_show_lines(const struct option *opt __used,
 
 	return ret;
 }
+
+static int opt_show_vars(const struct option *opt __used,
+			 const char *str, int unset __used)
+{
+	struct perf_probe_event *pev = &params.events[params.nevents];
+	int ret;
+
+	if (!str)
+		return 0;
+
+	ret = parse_probe_event(str);
+	if (!ret && pev->nargs != 0) {
+		pr_err("  Error: '--vars' doesn't accept arguments.\n");
+		return -EINVAL;
+	}
+	params.show_vars = true;
+
+	return ret;
+}
 #endif
 
 static const char * const probe_usage[] = {
@@ -139,6 +162,7 @@ static const char * const probe_usage[] = {
 	"perf probe --list",
 #ifdef DWARF_SUPPORT
 	"perf probe --line 'LINEDESC'",
+	"perf probe --vars 'PROBEPOINT'",
 #endif
 	NULL
 };
@@ -180,6 +204,9 @@ static const struct option options[] = {
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|-RLN2]]|SRC:ALN[+NUM|-ALN2]",
 		     "Show source code lines.", opt_show_lines),
+	OPT_CALLBACK('V', "vars", NULL,
+		     "FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT",
+		     "Show accessible variables on PROBEDEF", opt_show_vars),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_STRING('s', "source", &symbol_conf.source_prefix,
@@ -217,7 +244,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(probe_usage, options);
 
 	if (params.list_events) {
-		if (params.nevents != 0 || params.dellist) {
+		if (params.mod_events) {
 			pr_err("  Error: Don't use --list with --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
@@ -225,6 +252,10 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_err("  Error: Don't use --list with --line.\n");
 			usage_with_options(probe_usage, options);
 		}
+		if (params.show_vars) {
+			pr_err(" Error: Don't use --list with --vars.\n");
+			usage_with_options(probe_usage, options);
+		}
 		ret = show_perf_probe_events();
 		if (ret < 0)
 			pr_err("  Error: Failed to show event list. (%d)\n",
@@ -234,9 +265,13 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 #ifdef DWARF_SUPPORT
 	if (params.show_lines) {
-		if (params.nevents != 0 || params.dellist) {
-			pr_warning("  Error: Don't use --line with"
-				   " --add/--del.\n");
+		if (params.mod_events) {
+			pr_err("  Error: Don't use --line with"
+			       " --add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
+		if (params.show_vars) {
+			pr_err(" Error: Don't use --line with --vars.\n");
 			usage_with_options(probe_usage, options);
 		}
 
@@ -245,6 +280,18 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_err("  Error: Failed to show lines. (%d)\n", ret);
 		return ret;
 	}
+	if (params.show_vars) {
+		if (params.mod_events) {
+			pr_err("  Error: Don't use --vars with"
+			       " --add/--del.\n");
+			usage_with_options(probe_usage, options);
+		}
+		ret = show_available_vars(params.events, params.nevents,
+					  params.max_probe_points);
+		if (ret < 0)
+			pr_err("  Error: Failed to show vars. (%d)\n", ret);
+		return ret;
+	}
 #endif
 
 	if (params.dellist) {
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index fcc16e4..3de265e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -378,6 +378,72 @@ end:
 	return ret;
 }
 
+static int show_available_vars_at(int fd, struct perf_probe_event *pev,
+				  int max_vls)
+{
+	char *buf;
+	int ret, i;
+	struct str_node *node;
+	struct variable_list *vls = NULL, *vl;
+
+	buf = synthesize_perf_probe_point(&pev->point);
+	if (!buf)
+		return -EINVAL;
+	pr_debug("Searching variables at %s\n", buf);
+
+	ret = find_available_vars_at(fd, pev, &vls, max_vls);
+	if (ret > 0) {
+		/* Some variables are found */
+		fprintf(stdout, "Available variables at %s\n", buf);
+		for (i = 0; i < ret; i++) {
+			vl = &vls[i];
+			/*
+			 * A probe point might be converted to
+			 * several trace points.
+			 */
+			fprintf(stdout, "\t@<%s+%lu>\n", vl->point.symbol,
+				vl->point.offset);
+			free(vl->point.symbol);
+			if (vl->vars) {
+				strlist__for_each(node, vl->vars)
+					fprintf(stdout, "\t\t%s\n", node->s);
+				strlist__delete(vl->vars);
+			} else
+				fprintf(stdout, "(No variables)\n");
+		}
+		free(vls);
+	} else
+		pr_err("Failed to find variables at %s (%d)\n", buf, ret);
+
+	free(buf);
+	return ret;
+}
+
+/* Show available variables on given probe point */
+int show_available_vars(struct perf_probe_event *pevs, int npevs,
+			int max_vls)
+{
+	int i, fd, ret = 0;
+
+	ret = init_vmlinux();
+	if (ret < 0)
+		return ret;
+
+	fd = open_vmlinux();
+	if (fd < 0) {
+		pr_warning("Failed to open debuginfo file.\n");
+		return fd;
+	}
+
+	setup_pager();
+
+	for (i = 0; i < npevs && ret >= 0; i++)
+		ret = show_available_vars_at(fd, &pevs[i], max_vls);
+
+	close(fd);
+	return ret;
+}
+
 #else	/* !DWARF_SUPPORT */
 
 static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
@@ -409,6 +475,12 @@ int show_line_range(struct line_range *lr __unused)
 	return -ENOSYS;
 }
 
+int show_available_vars(struct perf_probe_event *pevs __unused,
+			int npevs __unused, int max_probe_points __unused)
+{
+	pr_warning("Debuginfo-analysis is not supported.\n");
+	return -ENOSYS;
+}
 #endif
 
 int parse_line_range_desc(const char *arg, struct line_range *lr)
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 5af3924..727a7fe 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -90,6 +90,12 @@ struct line_range {
 	struct list_head	line_list;	/* Visible lines */
 };
 
+/* List of variables */
+struct variable_list {
+	struct probe_trace_point	point;	/* Actual probepoint */
+	struct strlist			*vars;	/* Available variables */
+};
+
 /* Command string to events */
 extern int parse_perf_probe_command(const char *cmd,
 				    struct perf_probe_event *pev);
@@ -115,6 +121,8 @@ extern int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 extern int del_perf_probe_events(struct strlist *dellist);
 extern int show_perf_probe_events(void);
 extern int show_line_range(struct line_range *lr);
+extern int show_available_vars(struct perf_probe_event *pevs, int npevs,
+			       int max_probe_points);
 
 
 /* Maximum index number of event-name postfix */
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c6fe80e..986027f 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -172,8 +172,8 @@ static Dwarf_Die *die_get_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
 		return NULL;
 }
 
-/* Get type die, but skip qualifiers and typedef */
-static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
+/* Get a type die, but skip qualifiers */
+static Dwarf_Die *__die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
 {
 	int tag;
 
@@ -185,8 +185,17 @@ static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
 	} while (tag == DW_TAG_const_type ||
 		 tag == DW_TAG_restrict_type ||
 		 tag == DW_TAG_volatile_type ||
-		 tag == DW_TAG_shared_type ||
-		 tag == DW_TAG_typedef);
+		 tag == DW_TAG_shared_type);
+
+	return vr_die;
+}
+
+/* Get a type die, but skip qualifiers and typedef */
+static Dwarf_Die *die_get_real_type(Dwarf_Die *vr_die, Dwarf_Die *die_mem)
+{
+	do {
+		vr_die = __die_get_real_type(vr_die, die_mem);
+	} while (vr_die && dwarf_tag(vr_die) == DW_TAG_typedef);
 
 	return vr_die;
 }
@@ -380,6 +389,60 @@ static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
 			      die_mem);
 }
 
+/* Get the name of given variable DIE */
+static int die_get_typename(Dwarf_Die *vr_die, char *buf, int len)
+{
+	Dwarf_Die type;
+	int tag, ret, ret2;
+	const char *tmp = "";
+
+	if (__die_get_real_type(vr_die, &type) == NULL)
+		return -ENOENT;
+
+	tag = dwarf_tag(&type);
+	if (tag == DW_TAG_array_type || tag == DW_TAG_pointer_type)
+		tmp = "*";
+	else if (tag == DW_TAG_subroutine_type) {
+		/* Function pointer */
+		ret = snprintf(buf, len, "(function_type)");
+		return (ret >= len) ? -E2BIG : ret;
+	} else {
+		if (!dwarf_diename(&type))
+			return -ENOENT;
+		if (tag == DW_TAG_union_type)
+			tmp = "union ";
+		else if (tag == DW_TAG_structure_type)
+			tmp = "struct ";
+		/* Write a base name */
+		ret = snprintf(buf, len, "%s%s", tmp, dwarf_diename(&type));
+		return (ret >= len) ? -E2BIG : ret;
+	}
+	ret = die_get_typename(&type, buf, len);
+	if (ret > 0) {
+		ret2 = snprintf(buf + ret, len - ret, "%s", tmp);
+		ret = (ret2 >= len - ret) ? -E2BIG : ret2 + ret;
+	}
+	return ret;
+}
+
+/* Get the name and type of given variable DIE, stored as "type\tname" */
+static int die_get_varname(Dwarf_Die *vr_die, char *buf, int len)
+{
+	int ret, ret2;
+
+	ret = die_get_typename(vr_die, buf, len);
+	if (ret < 0) {
+		pr_debug("Failed to get type, make it unknown.\n");
+		ret = snprintf(buf, len, "(unknown_type)");
+	}
+	if (ret > 0) {
+		ret2 = snprintf(buf + ret, len - ret, "\t%s",
+				dwarf_diename(vr_die));
+		ret = (ret2 >= len - ret) ? -E2BIG : ret2 + ret;
+	}
+	return ret;
+}
+
 /*
  * Probe finder related functions
  */
@@ -393,8 +456,13 @@ static struct probe_trace_arg_ref *alloc_trace_arg_ref(long offs)
 	return ref;
 }
 
-/* Show a location */
-static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
+/*
+ * Convert a location into trace_arg.
+ * If tvar == NULL, this just checks variable can be converted.
+ */
+static int convert_variable_location(Dwarf_Die *vr_die, Dwarf_Addr addr,
+				     Dwarf_Op *fb_ops,
+				     struct probe_trace_arg *tvar)
 {
 	Dwarf_Attribute attr;
 	Dwarf_Op *op;
@@ -403,7 +471,6 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 	Dwarf_Word offs = 0;
 	bool ref = false;
 	const char *regs;
-	struct probe_trace_arg *tvar = pf->tvar;
 	int ret;
 
 	if (dwarf_attr(vr_die, DW_AT_external, &attr) != NULL)
@@ -411,16 +478,16 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 
 	/* TODO: handle more than 1 exprs */
 	if (dwarf_attr(vr_die, DW_AT_location, &attr) == NULL ||
-	    dwarf_getlocation_addr(&attr, pf->addr, &op, &nops, 1) <= 0 ||
+	    dwarf_getlocation_addr(&attr, addr, &op, &nops, 1) <= 0 ||
 	    nops == 0) {
 		/* TODO: Support const_value */
-		pr_err("Failed to find the location of %s at this address.\n"
-		       " Perhaps, it has been optimized out.\n", pf->pvar->var);
 		return -ENOENT;
 	}
 
 	if (op->atom == DW_OP_addr) {
 static_var:
+		if (!tvar)
+			return 0;
 		/* Static variables on memory (not stack), make @varname */
 		ret = strlen(dwarf_diename(vr_die));
 		tvar->value = zalloc(ret + 2);
@@ -435,14 +502,11 @@ static_var:
 
 	/* If this is based on frame buffer, set the offset */
 	if (op->atom == DW_OP_fbreg) {
-		if (pf->fb_ops == NULL) {
-			pr_warning("The attribute of frame base is not "
-				   "supported.\n");
+		if (fb_ops == NULL)
 			return -ENOTSUP;
-		}
 		ref = true;
 		offs = op->number;
-		op = &pf->fb_ops[0];
+		op = &fb_ops[0];
 	}
 
 	if (op->atom >= DW_OP_breg0 && op->atom <= DW_OP_breg31) {
@@ -458,13 +522,18 @@ static_var:
 	} else if (op->atom == DW_OP_regx) {
 		regn = op->number;
 	} else {
-		pr_warning("DW_OP %x is not supported.\n", op->atom);
+		pr_debug("DW_OP %x is not supported.\n", op->atom);
 		return -ENOTSUP;
 	}
 
+	if (!tvar)
+		return 0;
+
 	regs = get_arch_regstr(regn);
 	if (!regs) {
-		pr_warning("Mapping for DWARF register number %u missing on this architecture.", regn);
+		/* This should be a bug in DWARF or this tool */
+		pr_warning("Mapping for DWARF register number %u "
+			   "missing on this architecture.", regn);
 		return -ERANGE;
 	}
 
@@ -689,8 +758,14 @@ static int convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	pr_debug("Converting variable %s into trace event.\n",
 		 dwarf_diename(vr_die));
 
-	ret = convert_variable_location(vr_die, pf);
-	if (ret == 0 && pf->pvar->field) {
+	ret = convert_variable_location(vr_die, pf->addr, pf->fb_ops,
+					pf->tvar);
+	if (ret == -ENOENT)
+		pr_err("Failed to find the location of %s at this address.\n"
+		       " Perhaps, it has been optimized out.\n", pf->pvar->var);
+	else if (ret == -ENOTSUP)
+		pr_err("Sorry, we don't support this variable location yet.\n");
+	else if (pf->pvar->field) {
 		ret = convert_variable_fields(vr_die, pf->pvar->var,
 					      pf->pvar->field, &pf->tvar->ref,
 					      &die_mem);
@@ -772,34 +847,12 @@ found:
 	return ret;
 }
 
-/* Show a probe point to output buffer */
-static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
+/* Convert subprogram DIE to trace point */
+static int convert_to_trace_point(Dwarf_Die *sp_die, Dwarf_Addr paddr,
+				  bool retprobe, struct probe_trace_point *tp)
 {
-	struct probe_trace_event *tev;
 	Dwarf_Addr eaddr;
-	Dwarf_Die die_mem;
 	const char *name;
-	int ret, i;
-	Dwarf_Attribute fb_attr;
-	size_t nops;
-
-	if (pf->ntevs == pf->max_tevs) {
-		pr_warning("Too many( > %d) probe point found.\n",
-			   pf->max_tevs);
-		return -ERANGE;
-	}
-	tev = &pf->tevs[pf->ntevs++];
-
-	/* If no real subprogram, find a real one */
-	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
-		sp_die = die_find_real_subprogram(&pf->cu_die,
-						 pf->addr, &die_mem);
-		if (!sp_die) {
-			pr_warning("Failed to find probe point in any "
-				   "functions.\n");
-			return -ENOENT;
-		}
-	}
 
 	/* Copy the name of probe point */
 	name = dwarf_diename(sp_die);
@@ -809,26 +862,45 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 				   dwarf_diename(sp_die));
 			return -ENOENT;
 		}
-		tev->point.symbol = strdup(name);
-		if (tev->point.symbol == NULL)
+		tp->symbol = strdup(name);
+		if (tp->symbol == NULL)
 			return -ENOMEM;
-		tev->point.offset = (unsigned long)(pf->addr - eaddr);
+		tp->offset = (unsigned long)(paddr - eaddr);
 	} else
 		/* This function has no name. */
-		tev->point.offset = (unsigned long)pf->addr;
+		tp->offset = (unsigned long)paddr;
 
 	/* Return probe must be on the head of a subprogram */
-	if (pf->pev->point.retprobe) {
-		if (tev->point.offset != 0) {
+	if (retprobe) {
+		if (eaddr != paddr) {
 			pr_warning("Return probe must be on the head of"
 				   " a real function\n");
 			return -EINVAL;
 		}
-		tev->point.retprobe = true;
+		tp->retprobe = true;
 	}
 
-	pr_debug("Probe point found: %s+%lu\n", tev->point.symbol,
-		 tev->point.offset);
+	return 0;
+}
+
+/* Call probe_finder callback with real subprogram DIE */
+static int call_probe_finder(Dwarf_Die *sp_die, struct probe_finder *pf)
+{
+	Dwarf_Die die_mem;
+	Dwarf_Attribute fb_attr;
+	size_t nops;
+	int ret;
+
+	/* If no real subprogram, find a real one */
+	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
+		sp_die = die_find_real_subprogram(&pf->cu_die,
+						  pf->addr, &die_mem);
+		if (!sp_die) {
+			pr_warning("Failed to find probe point in any "
+				   "functions.\n");
+			return -ENOENT;
+		}
+	}
 
 	/* Get the frame base attribute/ops */
 	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
@@ -848,22 +920,13 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 #endif
 	}
 
-	/* Find each argument */
-	tev->nargs = pf->pev->nargs;
-	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
-	if (tev->args == NULL)
-		return -ENOMEM;
-	for (i = 0; i < pf->pev->nargs; i++) {
-		pf->pvar = &pf->pev->args[i];
-		pf->tvar = &tev->args[i];
-		ret = find_variable(sp_die, pf);
-		if (ret != 0)
-			return ret;
-	}
+	/* Call finder's callback handler */
+	ret = pf->callback(sp_die, pf);
 
 	/* *pf->fb_ops will be cached in libdw. Don't free it. */
 	pf->fb_ops = NULL;
-	return 0;
+
+	return ret;
 }
 
 /* Find probe point from its line number */
@@ -899,7 +962,7 @@ static int find_probe_point_by_line(struct probe_finder *pf)
 			 (int)i, lineno, (uintmax_t)addr);
 		pf->addr = addr;
 
-		ret = convert_probe_point(NULL, pf);
+		ret = call_probe_finder(NULL, pf);
 		/* Continuing, because target line might be inlined. */
 	}
 	return ret;
@@ -1012,7 +1075,7 @@ static int find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 			 (int)i, lineno, (unsigned long long)addr);
 		pf->addr = addr;
 
-		ret = convert_probe_point(sp_die, pf);
+		ret = call_probe_finder(sp_die, pf);
 		/* Continuing, because target line might be inlined. */
 	}
 	/* TODO: deallocate lines, but how? */
@@ -1047,7 +1110,7 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 		pr_debug("found inline addr: 0x%jx\n",
 			 (uintmax_t)pf->addr);
 
-		param->retval = convert_probe_point(in_die, pf);
+		param->retval = call_probe_finder(in_die, pf);
 		if (param->retval < 0)
 			return DWARF_CB_ABORT;
 	}
@@ -1085,7 +1148,7 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			}
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
-			param->retval = convert_probe_point(sp_die, pf);
+			param->retval = call_probe_finder(sp_die, pf);
 		}
 	} else {
 		struct dwarf_callback_param _param = {.data = (void *)pf,
@@ -1107,70 +1170,229 @@ static int find_probe_point_by_func(struct probe_finder *pf)
 	return _param.retval;
 }
 
-/* Find probe_trace_events specified by perf_probe_event from debuginfo */
-int find_probe_trace_events(int fd, struct perf_probe_event *pev,
-			     struct probe_trace_event **tevs, int max_tevs)
+/* Find probe points from debuginfo */
+static int find_probes(int fd, struct probe_finder *pf)
 {
-	struct probe_finder pf = {.pev = pev, .max_tevs = max_tevs};
-	struct perf_probe_point *pp = &pev->point;
+	struct perf_probe_point *pp = &pf->pev->point;
 	Dwarf_Off off, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
 	Dwarf *dbg;
 	int ret = 0;
 
-	pf.tevs = zalloc(sizeof(struct probe_trace_event) * max_tevs);
-	if (pf.tevs == NULL)
-		return -ENOMEM;
-	*tevs = pf.tevs;
-	pf.ntevs = 0;
-
 	dbg = dwarf_begin(fd, DWARF_C_READ);
 	if (!dbg) {
 		pr_warning("No dwarf info found in the vmlinux - "
 			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		free(pf.tevs);
-		*tevs = NULL;
 		return -EBADF;
 	}
 
 #if _ELFUTILS_PREREQ(0, 142)
 	/* Get the call frame information from this dwarf */
-	pf.cfi = dwarf_getcfi(dbg);
+	pf->cfi = dwarf_getcfi(dbg);
 #endif
 
 	off = 0;
-	line_list__init(&pf.lcache);
+	line_list__init(&pf->lcache);
 	/* Loop on CUs (Compilation Unit) */
 	while (!dwarf_nextcu(dbg, off, &noff, &cuhl, NULL, NULL, NULL) &&
 	       ret >= 0) {
 		/* Get the DIE(Debugging Information Entry) of this CU */
-		diep = dwarf_offdie(dbg, off + cuhl, &pf.cu_die);
+		diep = dwarf_offdie(dbg, off + cuhl, &pf->cu_die);
 		if (!diep)
 			continue;
 
 		/* Check if target file is included. */
 		if (pp->file)
-			pf.fname = cu_find_realpath(&pf.cu_die, pp->file);
+			pf->fname = cu_find_realpath(&pf->cu_die, pp->file);
 		else
-			pf.fname = NULL;
+			pf->fname = NULL;
 
-		if (!pp->file || pf.fname) {
+		if (!pp->file || pf->fname) {
 			if (pp->function)
-				ret = find_probe_point_by_func(&pf);
+				ret = find_probe_point_by_func(pf);
 			else if (pp->lazy_line)
-				ret = find_probe_point_lazy(NULL, &pf);
+				ret = find_probe_point_lazy(NULL, pf);
 			else {
-				pf.lno = pp->line;
-				ret = find_probe_point_by_line(&pf);
+				pf->lno = pp->line;
+				ret = find_probe_point_by_line(pf);
 			}
 		}
 		off = noff;
 	}
-	line_list__free(&pf.lcache);
+	line_list__free(&pf->lcache);
 	dwarf_end(dbg);
 
-	return (ret < 0) ? ret : pf.ntevs;
+	return ret;
+}
+
+/* Add a found probe point into trace event list */
+static int add_probe_trace_event(Dwarf_Die *sp_die, struct probe_finder *pf)
+{
+	struct trace_event_finder *tf =
+			container_of(pf, struct trace_event_finder, pf);
+	struct probe_trace_event *tev;
+	int ret, i;
+
+	/* Check number of tevs */
+	if (tf->ntevs == tf->max_tevs) {
+		pr_warning("Too many( > %d) probe point found.\n",
+			   tf->max_tevs);
+		return -ERANGE;
+	}
+	tev = &tf->tevs[tf->ntevs++];
+
+	ret = convert_to_trace_point(sp_die, pf->addr, pf->pev->point.retprobe,
+				     &tev->point);
+	if (ret < 0)
+		return ret;
+
+	pr_debug("Probe point found: %s+%lu\n", tev->point.symbol,
+		 tev->point.offset);
+
+	/* Find each argument */
+	tev->nargs = pf->pev->nargs;
+	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
+	if (tev->args == NULL)
+		return -ENOMEM;
+	for (i = 0; i < pf->pev->nargs; i++) {
+		pf->pvar = &pf->pev->args[i];
+		pf->tvar = &tev->args[i];
+		ret = find_variable(sp_die, pf);
+		if (ret != 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+/* Find probe_trace_events specified by perf_probe_event from debuginfo */
+int find_probe_trace_events(int fd, struct perf_probe_event *pev,
+			    struct probe_trace_event **tevs, int max_tevs)
+{
+	struct trace_event_finder tf = {
+			.pf = {.pev = pev, .callback = add_probe_trace_event},
+			.max_tevs = max_tevs};
+	int ret;
+
+	/* Allocate result tevs array */
+	*tevs = zalloc(sizeof(struct probe_trace_event) * max_tevs);
+	if (*tevs == NULL)
+		return -ENOMEM;
+
+	tf.tevs = *tevs;
+	tf.ntevs = 0;
+
+	ret = find_probes(fd, &tf.pf);
+	if (ret < 0) {
+		free(*tevs);
+		*tevs = NULL;
+		return ret;
+	}
+
+	return (ret < 0) ? ret : tf.ntevs;
+}
+
+#define MAX_VAR_LEN 64
+
+/* Collect available variables in this scope */
+static int collect_variables_cb(Dwarf_Die *die_mem, void *data)
+{
+	struct available_var_finder *af = data;
+	struct variable_list *vl;
+	char buf[MAX_VAR_LEN];
+	int tag, ret;
+
+	vl = &af->vls[af->nvls - 1];
+
+	tag = dwarf_tag(die_mem);
+	if (tag == DW_TAG_formal_parameter ||
+	    tag == DW_TAG_variable) {
+		ret = convert_variable_location(die_mem, af->pf.addr,
+						af->pf.fb_ops, NULL);
+		if (ret == 0) {
+			ret = die_get_varname(die_mem, buf, MAX_VAR_LEN);
+			if (ret > 0)
+				strlist__add(vl->vars, buf);
+		}
+	}
+
+	if (dwarf_haspc(die_mem, af->pf.addr))
+		return DIE_FIND_CB_CONTINUE;
+	else
+		return DIE_FIND_CB_SIBLING;
+}
+
+/* Add a found vars into available variables list */
+static int add_available_vars(Dwarf_Die *sp_die, struct probe_finder *pf)
+{
+	struct available_var_finder *af =
+			container_of(pf, struct available_var_finder, pf);
+	struct variable_list *vl;
+	Dwarf_Die die_mem;
+	int ret;
+
+	/* Check number of tevs */
+	if (af->nvls == af->max_vls) {
+		pr_warning("Too many( > %d) probe point found.\n", af->max_vls);
+		return -ERANGE;
+	}
+	vl = &af->vls[af->nvls++];
+
+	ret = convert_to_trace_point(sp_die, pf->addr, pf->pev->point.retprobe,
+				     &vl->point);
+	if (ret < 0)
+		return ret;
+
+	pr_debug("Probe point found: %s+%lu\n", vl->point.symbol,
+		 vl->point.offset);
+
+	/* Find local variables */
+	vl->vars = strlist__new(true, NULL);
+	if (vl->vars == NULL)
+		return -ENOMEM;
+	die_find_child(sp_die, collect_variables_cb, (void *)af, &die_mem);
+
+	if (strlist__empty(vl->vars)) {
+		strlist__delete(vl->vars);
+		vl->vars = NULL;
+	}
+
+	return ret;
+}
+
+/* Find available variables at given probe point */
+int find_available_vars_at(int fd, struct perf_probe_event *pev,
+			   struct variable_list **vls, int max_vls)
+{
+	struct available_var_finder af = {
+			.pf = {.pev = pev, .callback = add_available_vars},
+			.max_vls = max_vls};
+	int ret;
+
+	/* Allocate result vls array */
+	*vls = zalloc(sizeof(struct variable_list) * max_vls);
+	if (*vls == NULL)
+		return -ENOMEM;
+
+	af.vls = *vls;
+	af.nvls = 0;
+
+	ret = find_probes(fd, &af.pf);
+	if (ret < 0) {
+		/* Free vlist for error */
+		while (af.nvls--) {
+			if (af.vls[af.nvls].point.symbol)
+				free(af.vls[af.nvls].point.symbol);
+			if (af.vls[af.nvls].vars)
+				strlist__delete(af.vls[af.nvls].vars);
+		}
+		free(af.vls);
+		*vls = NULL;
+		return ret;
+	}
+
+	return (ret < 0) ? ret : af.nvls;
 }
 
 /* Reverse search */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 4507d51..baffd25 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -25,17 +25,22 @@ extern int find_probe_trace_events(int fd, struct perf_probe_event *pev,
 extern int find_perf_probe_point(int fd, unsigned long addr,
 				 struct perf_probe_point *ppt);
 
+/* Find a line range */
 extern int find_line_range(int fd, struct line_range *lr);
 
+/* Find available variables */
+extern int find_available_vars_at(int fd, struct perf_probe_event *pev,
+				  struct variable_list **vls, int max_points);
+
 #include <dwarf.h>
 #include <libdw.h>
 #include <version.h>
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
-	struct probe_trace_event *tevs;		/* Result trace events */
-	int			ntevs;		/* Number of trace events */
-	int			max_tevs;	/* Max number of trace events */
+
+	/* Callback when a probe point is found */
+	int (*callback)(Dwarf_Die *sp_die, struct probe_finder *pf);
 
 	/* For function searching */
 	int			lno;		/* Line number */
@@ -53,6 +58,20 @@ struct probe_finder {
 	struct probe_trace_arg	*tvar;		/* Current result variable */
 };
 
+struct trace_event_finder {
+	struct probe_finder	pf;
+	struct probe_trace_event *tevs;		/* Found trace events */
+	int			ntevs;		/* Number of trace events */
+	int			max_tevs;	/* Max number of trace events */
+};
+
+struct available_var_finder {
+	struct probe_finder	pf;
+	struct variable_list	*vls;		/* Found variable lists */
+	int			nvls;		/* Number of variable lists */
+	int			max_vls;	/* Max no. of variable lists */
+};
+
 struct line_finder {
 	struct line_range	*lr;		/* Target line range */
 

