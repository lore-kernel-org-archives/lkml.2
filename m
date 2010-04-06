Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab0DFWAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 18:00:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932100Ab0DFV7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 17:59:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip v2 8/8] perf probe: Remove die() from probe-event code
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 06 Apr 2010 18:06:36 -0400
Message-ID: <20100406220636.13329.45265.stgit@localhost6.localdomain6>
In-Reply-To: <20100406220542.13329.45837.stgit@localhost6.localdomain6>
References: <20100406220542.13329.45837.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove die() and DIE_IF() code from util/probe-event.c since
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

 tools/perf/builtin-probe.c    |   70 +++--
 tools/perf/util/probe-event.c |  615 ++++++++++++++++++++++++++++-------------
 tools/perf/util/probe-event.h |   24 +-
 3 files changed, 480 insertions(+), 229 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index dafaf76..5259c5a 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -59,23 +59,25 @@ static struct {
 
 
 /* Parse an event definition. Note that any error must die. */
-static void parse_probe_event(const char *str)
+static int parse_probe_event(const char *str)
 {
 	struct perf_probe_event *pev = &params.events[params.nevents];
+	int ret;
 
 	pr_debug("probe-definition(%d): %s\n", params.nevents, str);
 	if (++params.nevents == MAX_PROBES)
 		die("Too many probes (> %d) are specified.", MAX_PROBES);
 
 	/* Parse a perf-probe command into event */
-	parse_perf_probe_command(str, pev);
-
+	ret = parse_perf_probe_command(str, pev);
 	pr_debug("%d arguments\n", pev->nargs);
+
+	return ret;
 }
 
-static void parse_probe_event_argv(int argc, const char **argv)
+static int parse_probe_event_argv(int argc, const char **argv)
 {
-	int i, len;
+	int i, len, ret;
 	char *buf;
 
 	/* Bind up rest arguments */
@@ -86,16 +88,18 @@ static void parse_probe_event_argv(int argc, const char **argv)
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += sprintf(&buf[len], "%s ", argv[i]);
-	parse_probe_event(buf);
+	ret = parse_probe_event(buf);
 	free(buf);
+	return ret;
 }
 
 static int opt_add_probe_event(const struct option *opt __used,
 			      const char *str, int unset __used)
 {
 	if (str)
-		parse_probe_event(str);
-	return 0;
+		return parse_probe_event(str);
+	else
+		return 0;
 }
 
 static int opt_del_probe_event(const struct option *opt __used,
@@ -113,11 +117,14 @@ static int opt_del_probe_event(const struct option *opt __used,
 static int opt_show_lines(const struct option *opt __used,
 			  const char *str, int unset __used)
 {
+	int ret = 0;
+
 	if (str)
-		parse_line_range_desc(str, &params.line_range);
+		ret = parse_line_range_desc(str, &params.line_range);
 	INIT_LIST_HEAD(&params.line_range.line_list);
 	params.show_lines = true;
-	return 0;
+
+	return ret;
 }
 #endif
 
@@ -178,6 +185,8 @@ static const struct option options[] = {
 
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
+	int ret;
+
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (argc > 0) {
@@ -185,7 +194,11 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			pr_warning("  Error: '-' is not supported.\n");
 			usage_with_options(probe_usage, options);
 		}
-		parse_probe_event_argv(argc, argv);
+		ret = parse_probe_event_argv(argc, argv);
+		if (ret < 0) {
+			pr_err("  Error: Parse Error.  (%d)\n", ret);
+			return ret;
+		}
 	}
 
 	if ((!params.nevents && !params.dellist && !params.list_events &&
@@ -197,16 +210,18 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 	if (params.list_events) {
 		if (params.nevents != 0 || params.dellist) {
-			pr_warning("  Error: Don't use --list with"
-				   " --add/--del.\n");
+			pr_err("  Error: Don't use --list with --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
 		if (params.show_lines) {
-			pr_warning("  Error: Don't use --list with --line.\n");
+			pr_err("  Error: Don't use --list with --line.\n");
 			usage_with_options(probe_usage, options);
 		}
-		show_perf_probe_events();
-		return 0;
+		ret = show_perf_probe_events();
+		if (ret < 0)
+			pr_err("  Error: Failed to show event list. (%d)\n",
+			       ret);
+		return ret;
 	}
 
 #ifdef DWARF_SUPPORT
@@ -217,19 +232,30 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			usage_with_options(probe_usage, options);
 		}
 
-		show_line_range(&params.line_range);
-		return 0;
+		ret = show_line_range(&params.line_range);
+		if (ret < 0)
+			pr_err("  Error: Failed to show lines. (%d)\n", ret);
+		return ret;
 	}
 #endif
 
 	if (params.dellist) {
-		del_perf_probe_events(params.dellist);
+		ret = del_perf_probe_events(params.dellist);
 		strlist__delete(params.dellist);
-		if (params.nevents == 0)
-			return 0;
+		if (ret < 0) {
+			pr_err("  Error: Failed to delete events. (%d)\n", ret);
+			return ret;
+		}
 	}
 
-	add_perf_probe_events(params.events, params.nevents, params.force_add);
+	if (params.nevents) {
+		ret = add_perf_probe_events(params.events, params.nevents,
+					    params.force_add);
+		if (ret < 0) {
+			pr_err("  Error: Failed to add events. (%d)\n", ret);
+			return ret;
+		}
+	}
 	return 0;
 }
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7893b32..bd68f7b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -53,7 +53,7 @@
 
 bool probe_event_dry_run;	/* Dry run flag */
 
-#define semantic_error(msg ...) die("Semantic error :" msg)
+#define semantic_error(msg ...) pr_err("Semantic error :" msg)
 
 /* If there is no space to write, returns -E2BIG. */
 static int e_snprintf(char *str, size_t size, const char *format, ...)
@@ -76,19 +76,30 @@ static struct map_groups kmap_groups;
 static struct map *kmaps[MAP__NR_TYPES];
 
 /* Initialize symbol maps and path of vmlinux */
-static void init_vmlinux(void)
+static int init_vmlinux(void)
 {
+	int ret;
+
 	symbol_conf.sort_by_name = true;
 	if (symbol_conf.vmlinux_name == NULL)
 		symbol_conf.try_vmlinux_path = true;
 	else
 		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
-	if (symbol__init() < 0)
-		die("Failed to init symbol map.");
+	ret = symbol__init();
+	if (ret < 0) {
+		pr_debug("Failed to init symbol map.\n");
+		goto out;
+	}
 
 	map_groups__init(&kmap_groups);
-	if (map_groups__create_kernel_maps(&kmap_groups, kmaps) < 0)
-		die("Failed to create kernel maps.");
+	ret = map_groups__create_kernel_maps(&kmap_groups, kmaps);
+	if (ret < 0)
+		pr_debug("Failed to create kernel maps.\n");
+
+out:
+	if (ret < 0)
+		pr_warning("Failed to init vmlinux path.\n");
+	return ret;
 }
 
 #ifdef DWARF_SUPPORT
@@ -102,24 +113,32 @@ static int open_vmlinux(void)
 	return open(kmaps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
 }
 
-static void convert_to_perf_probe_point(struct kprobe_trace_point *tp,
-					struct perf_probe_point *pp)
+/* Convert trace point to probe point with debuginfo */
+static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
+				       struct perf_probe_point *pp)
 {
 	struct symbol *sym;
-	int fd, ret = 0;
+	int fd, ret = -ENOENT;
 
 	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
 				       tp->symbol, NULL);
 	if (sym) {
 		fd = open_vmlinux();
-		ret = find_perf_probe_point(fd, sym->start + tp->offset, pp);
-		close(fd);
+		if (fd >= 0) {
+			ret = find_perf_probe_point(fd,
+						 sym->start + tp->offset, pp);
+			close(fd);
+		}
 	}
 	if (ret <= 0) {
+		pr_debug("Failed to find corresponding probes from "
+			 "debuginfo. Use kprobe event information.\n");
 		pp->function = xstrdup(tp->symbol);
 		pp->offset = tp->offset;
 	}
 	pp->retprobe = tp->retprobe;
+
+	return 0;
 }
 
 /* Try to find perf_probe_event with debuginfo */
@@ -131,9 +150,10 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 
 	fd = open_vmlinux();
 	if (fd < 0) {
-		if (need_dwarf)
-			die("Could not open debuginfo file.");
-
+		if (need_dwarf) {
+			pr_warning("Failed to open debuginfo file.\n");
+			return fd;
+		}
 		pr_debug("Could not open vmlinux. Try to use symbols.\n");
 		return 0;
 	}
@@ -142,30 +162,32 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 	ntevs = find_kprobe_trace_events(fd, pev, tevs);
 	close(fd);
 
-	if (ntevs > 0)	/* Succeeded to find trace events */
+	if (ntevs > 0) {	/* Succeeded to find trace events */
+		pr_debug("find %d kprobe_trace_events.\n", ntevs);
 		return ntevs;
+	}
 
-	if (ntevs == 0)	/* No error but failed to find probe point. */
-		die("Probe point '%s' not found. - probe not added.",
-		    synthesize_perf_probe_point(&pev->point));
-
-	/* Error path */
+	if (ntevs == 0)	{	/* No error but failed to find probe point. */
+		pr_warning("Probe point '%s' not found.\n",
+			   synthesize_perf_probe_point(&pev->point));
+		return -ENOENT;
+	}
+	/* Error path : ntevs < 0 */
 	if (need_dwarf) {
 		if (ntevs == -EBADF)
 			pr_warning("No dwarf info found in the vmlinux - "
 				"please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		die("Failed to analyze debuginfo.");
+		return ntevs;
 	}
 	pr_debug("An error occurred in debuginfo analysis."
 		 " Try to use symbols.\n");
 	return 0;
-
 }
 
 #define LINEBUF_SIZE 256
 #define NR_ADDITIONAL_LINES 2
 
-static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
+static int show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
 {
 	char buf[LINEBUF_SIZE];
 	const char *color = PERF_COLOR_BLUE;
@@ -190,19 +212,22 @@ static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
 				color_fprintf(stdout, color, "%s", buf);
 		}
 	}
-	return;
+
+	return 0;
 error:
 	if (feof(fp))
-		die("Source file is shorter than expected.");
+		pr_warning("Source file is shorter than expected.\n");
 	else
-		die("File read error: %s", strerror(errno));
+		pr_warning("File read error: %s\n", strerror(errno));
+
+	return -1;
 }
 
 /*
  * Show line-range always requires debuginfo to find source file and
  * line number.
  */
-void show_line_range(struct line_range *lr)
+int show_line_range(struct line_range *lr)
 {
 	unsigned int l = 1;
 	struct line_node *ln;
@@ -210,14 +235,25 @@ void show_line_range(struct line_range *lr)
 	int fd, ret;
 
 	/* Search a line range */
-	init_vmlinux();
+	ret = init_vmlinux();
+	if (ret < 0)
+		return ret;
+
 	fd = open_vmlinux();
-	if (fd < 0)
-		die("Could not open debuginfo file.");
+	if (fd < 0) {
+		pr_warning("Failed to open debuginfo file.\n");
+		return fd;
+	}
+
 	ret = find_line_range(fd, lr);
-	if (ret <= 0)
-		die("Source line is not found.\n");
 	close(fd);
+	if (ret == 0) {
+		pr_warning("Specified source line is not found.\n");
+		return -ENOENT;
+	} else if (ret < 0) {
+		pr_warning("Debuginfo analysis failed. (%d)\n", ret);
+		return ret;
+	}
 
 	setup_pager();
 
@@ -228,52 +264,68 @@ void show_line_range(struct line_range *lr)
 		fprintf(stdout, "<%s:%d>\n", lr->file, lr->start);
 
 	fp = fopen(lr->path, "r");
-	if (fp == NULL)
-		die("Failed to open %s: %s", lr->path, strerror(errno));
+	if (fp == NULL) {
+		pr_warning("Failed to open %s: %s\n", lr->path,
+			   strerror(errno));
+		return -errno;
+	}
 	/* Skip to starting line number */
-	while (l < lr->start)
-		show_one_line(fp, l++, true, false);
+	while (l < lr->start && ret >= 0)
+		ret = show_one_line(fp, l++, true, false);
+	if (ret < 0)
+		goto end;
 
 	list_for_each_entry(ln, &lr->line_list, list) {
-		while (ln->line > l)
-			show_one_line(fp, (l++) - lr->offset, false, false);
-		show_one_line(fp, (l++) - lr->offset, false, true);
+		while (ln->line > l && ret >= 0)
+			ret = show_one_line(fp, (l++) - lr->offset,
+					    false, false);
+		if (ret >= 0)
+			ret = show_one_line(fp, (l++) - lr->offset,
+					    false, true);
+		if (ret < 0)
+			goto end;
 	}
 
 	if (lr->end == INT_MAX)
 		lr->end = l + NR_ADDITIONAL_LINES;
-	while (l < lr->end && !feof(fp))
-		show_one_line(fp, (l++) - lr->offset, false, false);
-
+	while (l < lr->end && !feof(fp) && ret >= 0)
+		ret = show_one_line(fp, (l++) - lr->offset, false, false);
+end:
 	fclose(fp);
+	return ret;
 }
 
 #else	/* !DWARF_SUPPORT */
 
-static void convert_to_perf_probe_point(struct kprobe_trace_point *tp,
+static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 					struct perf_probe_point *pp)
 {
 	pp->function = xstrdup(tp->symbol);
 	pp->offset = tp->offset;
 	pp->retprobe = tp->retprobe;
+
+	return 0;
 }
 
 static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 				struct kprobe_trace_event **tevs __unused)
 {
-	if (perf_probe_event_need_dwarf(pev))
-		die("Debuginfo-analysis is not supported");
+	if (perf_probe_event_need_dwarf(pev)) {
+		pr_warning("Debuginfo-analysis is not supported.\n");
+		return -ENOSYS;
+	}
 	return 0;
 }
 
-void show_line_range(struct line_range *lr __unused)
+int show_line_range(struct line_range *lr __unused)
 {
-	die("Debuginfo-analysis is not supported");
+	pr_warning("Debuginfo-analysis is not supported.\n");
+	return -ENOSYS;
 }
 
 #endif
 
-void parse_line_range_desc(const char *arg, struct line_range *lr)
+int parse_line_range_desc(const char *arg, struct line_range *lr)
 {
 	const char *ptr;
 	char *tmp;
@@ -293,12 +345,16 @@ void parse_line_range_desc(const char *arg, struct line_range *lr)
 		else
 			lr->end = 0;
 		pr_debug("Line range is %u to %u\n", lr->start, lr->end);
-		if (lr->end && lr->start > lr->end)
+		if (lr->end && lr->start > lr->end) {
 			semantic_error("Start line must be smaller"
-				       " than end line.");
-		if (*tmp != '\0')
-			semantic_error("Tailing with invalid character '%d'.",
+				       " than end line.\n");
+			return -EINVAL;
+		}
+		if (*tmp != '\0') {
+			semantic_error("Tailing with invalid character '%d'.\n",
 				       *tmp);
+			return -EINVAL;
+		}
 		tmp = xstrndup(arg, (ptr - arg));
 	} else
 		tmp = xstrdup(arg);
@@ -307,6 +363,8 @@ void parse_line_range_desc(const char *arg, struct line_range *lr)
 		lr->file = tmp;
 	else
 		lr->function = tmp;
+
+	return 0;
 }
 
 /* Check the name is good for event/group */
@@ -322,7 +380,7 @@ static bool check_event_name(const char *name)
 }
 
 /* Parse probepoint definition. */
-static void parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
+static int parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 {
 	struct perf_probe_point *pp = &pev->point;
 	char *ptr, *tmp;
@@ -339,12 +397,15 @@ static void parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 	if (ptr && *ptr == '=') {	/* Event name */
 		*ptr = '\0';
 		tmp = ptr + 1;
-		ptr = strchr(arg, ':');
-		if (ptr)	/* Group name is not supported yet. */
-			semantic_error("Group name is not supported yet.");
-		if (!check_event_name(arg))
+		if (strchr(arg, ':')) {
+			semantic_error("Group name is not supported yet.\n");
+			return -ENOTSUP;
+		}
+		if (!check_event_name(arg)) {
 			semantic_error("%s is bad for event name -it must "
-				       "follow C symbol-naming rule.", arg);
+				       "follow C symbol-naming rule.\n", arg);
+			return -EINVAL;
+		}
 		pev->event = xstrdup(arg);
 		pev->group = NULL;
 		arg = tmp;
@@ -378,64 +439,89 @@ static void parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 		switch (c) {
 		case ':':	/* Line number */
 			pp->line = strtoul(arg, &tmp, 0);
-			if (*tmp != '\0')
+			if (*tmp != '\0') {
 				semantic_error("There is non-digit char"
-					       " in line number.");
+					       " in line number.\n");
+				return -EINVAL;
+			}
 			break;
 		case '+':	/* Byte offset from a symbol */
 			pp->offset = strtoul(arg, &tmp, 0);
-			if (*tmp != '\0')
+			if (*tmp != '\0') {
 				semantic_error("There is non-digit character"
-						" in offset.");
+						" in offset.\n");
+				return -EINVAL;
+			}
 			break;
 		case '@':	/* File name */
-			if (pp->file)
-				semantic_error("SRC@SRC is not allowed.");
+			if (pp->file) {
+				semantic_error("SRC@SRC is not allowed.\n");
+				return -EINVAL;
+			}
 			pp->file = xstrdup(arg);
 			break;
 		case '%':	/* Probe places */
 			if (strcmp(arg, "return") == 0) {
 				pp->retprobe = 1;
-			} else	/* Others not supported yet */
-				semantic_error("%%%s is not supported.", arg);
+			} else {	/* Others not supported yet */
+				semantic_error("%%%s is not supported.\n", arg);
+				return -ENOTSUP;
+			}
 			break;
-		default:
-			DIE_IF("Program has a bug.");
+		default:	/* Buggy case */
+			pr_err("This program has a bug at %s:%d.\n",
+				__FILE__, __LINE__);
+			return -ENOTSUP;
 			break;
 		}
 	}
 
 	/* Exclusion check */
-	if (pp->lazy_line && pp->line)
+	if (pp->lazy_line && pp->line) {
 		semantic_error("Lazy pattern can't be used with line number.");
+		return -EINVAL;
+	}
 
-	if (pp->lazy_line && pp->offset)
+	if (pp->lazy_line && pp->offset) {
 		semantic_error("Lazy pattern can't be used with offset.");
+		return -EINVAL;
+	}
 
-	if (pp->line && pp->offset)
+	if (pp->line && pp->offset) {
 		semantic_error("Offset can't be used with line number.");
+		return -EINVAL;
+	}
 
-	if (!pp->line && !pp->lazy_line && pp->file && !pp->function)
+	if (!pp->line && !pp->lazy_line && pp->file && !pp->function) {
 		semantic_error("File always requires line number or "
 			       "lazy pattern.");
+		return -EINVAL;
+	}
 
-	if (pp->offset && !pp->function)
+	if (pp->offset && !pp->function) {
 		semantic_error("Offset requires an entry function.");
+		return -EINVAL;
+	}
 
-	if (pp->retprobe && !pp->function)
+	if (pp->retprobe && !pp->function) {
 		semantic_error("Return probe requires an entry function.");
+		return -EINVAL;
+	}
 
-	if ((pp->offset || pp->line || pp->lazy_line) && pp->retprobe)
+	if ((pp->offset || pp->line || pp->lazy_line) && pp->retprobe) {
 		semantic_error("Offset/Line/Lazy pattern can't be used with "
 			       "return probe.");
+		return -EINVAL;
+	}
 
 	pr_debug("symbol:%s file:%s line:%d offset:%lu return:%d lazy:%s\n",
 		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe,
 		 pp->lazy_line);
+	return 0;
 }
 
 /* Parse perf-probe event argument */
-static void parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
+static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 {
 	char *tmp;
 	struct perf_probe_arg_field **fieldp;
@@ -461,7 +547,7 @@ static void parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 		/* A variable, register, symbol or special value */
 		arg->var = xstrdup(str);
 		pr_debug("%s\n", arg->var);
-		return;
+		return 0;
 	}
 
 	/* Structure fields */
@@ -477,8 +563,10 @@ static void parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 		} else if (tmp[1] == '>') {
 			str = tmp + 2;
 			(*fieldp)->ref = true;
-		} else
-			semantic_error("Argument parse error: %s", str);
+		} else {
+			semantic_error("Argument parse error: %s\n", str);
+			return -EINVAL;
+		}
 
 		tmp = strpbrk(str, "-.");
 		if (tmp) {
@@ -493,34 +581,47 @@ static void parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 	/* If no name is specified, set the last field name */
 	if (!arg->name)
 		arg->name = xstrdup((*fieldp)->name);
+
+	return 0;
 }
 
 /* Parse perf-probe event command */
-void parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
+int parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
 {
 	char **argv;
-	int argc, i;
+	int argc, i, ret = 0;
 
 	argv = argv_split(cmd, &argc);
-	if (!argv)
-		die("argv_split failed.");
-	if (argc > MAX_PROBE_ARGS + 1)
-		semantic_error("Too many arguments");
-
+	if (!argv) {
+		pr_debug("Failed to split arguments.\n");
+		return -ENOMEM;
+	}
+	if (argc - 1 > MAX_PROBE_ARGS) {
+		semantic_error("Too many probe arguments (%d).\n", argc - 1);
+		ret = -ERANGE;
+		goto out;
+	}
 	/* Parse probe point */
-	parse_perf_probe_point(argv[0], pev);
+	ret = parse_perf_probe_point(argv[0], pev);
+	if (ret < 0)
+		goto out;
 
 	/* Copy arguments and ensure return probe has no C argument */
 	pev->nargs = argc - 1;
 	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
-	for (i = 0; i < pev->nargs; i++) {
-		parse_perf_probe_arg(argv[i + 1], &pev->args[i]);
-		if (is_c_varname(pev->args[i].var) && pev->point.retprobe)
+	for (i = 0; i < pev->nargs && ret >= 0; i++) {
+		ret = parse_perf_probe_arg(argv[i + 1], &pev->args[i]);
+		if (ret >= 0 &&
+		    is_c_varname(pev->args[i].var) && pev->point.retprobe) {
 			semantic_error("You can't specify local variable for"
-				       " kretprobe");
+				       " kretprobe.\n");
+			ret = -EINVAL;
+		}
 	}
-
+out:
 	argv_free(argv);
+
+	return ret;
 }
 
 /* Return true if this perf_probe_event requires debuginfo */
@@ -539,7 +640,7 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 }
 
 /* Parse kprobe_events event into struct probe_point */
-void parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
+int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 {
 	struct kprobe_trace_point *tp = &tev->point;
 	char pr;
@@ -549,17 +650,25 @@ void parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 
 	pr_debug("Parsing kprobe_events: %s\n", cmd);
 	argv = argv_split(cmd, &argc);
-	if (!argv)
-		die("argv_split failed.");
-	if (argc < 2)
-		semantic_error("Too less arguments.");
+	if (!argv) {
+		pr_debug("Failed to split arguments.\n");
+		return -ENOMEM;
+	}
+	if (argc < 2) {
+		semantic_error("Too few probe arguments.\n");
+		ret = -ERANGE;
+		goto out;
+	}
 
 	/* Scan event and group name. */
 	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
 		     &pr, (float *)(void *)&tev->group,
 		     (float *)(void *)&tev->event);
-	if (ret != 3)
-		semantic_error("Failed to parse event name: %s", argv[0]);
+	if (ret != 3) {
+		semantic_error("Failed to parse event name: %s\n", argv[0]);
+		ret = -EINVAL;
+		goto out;
+	}
 	pr_debug("Group:%s Event:%s probe:%c\n", tev->group, tev->event, pr);
 
 	tp->retprobe = (pr == 'r');
@@ -582,8 +691,10 @@ void parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 		/* TODO: parse regs and offset */
 		tev->args[i].value = xstrdup(p);
 	}
-
+	ret = 0;
+out:
 	argv_free(argv);
+	return ret;
 }
 
 /* Compose only probe arg */
@@ -622,7 +733,9 @@ int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf, size_t len)
 
 	return tmp - buf;
 error:
-	die("Failed to synthesize perf probe argument: %s", strerror(-ret));
+	pr_debug("Failed to synthesize perf probe argument: %s",
+		 strerror(-ret));
+	return ret;
 }
 
 /* Compose only probe point (not argument) */
@@ -666,7 +779,10 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 
 	return buf;
 error:
-	die("Failed to synthesize perf probe point: %s", strerror(-ret));
+	pr_debug("Failed to synthesize perf probe point: %s",
+		 strerror(-ret));
+	free(buf);
+	return NULL;
 }
 
 #if 0
@@ -796,29 +912,37 @@ error:
 	return NULL;
 }
 
-void convert_to_perf_probe_event(struct kprobe_trace_event *tev,
-				 struct perf_probe_event *pev)
+int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
+				struct perf_probe_event *pev)
 {
 	char buf[64];
-	int i;
+	int i, ret;
 
 	/* Convert event/group name */
 	pev->event = xstrdup(tev->event);
 	pev->group = xstrdup(tev->group);
 
 	/* Convert trace_point to probe_point */
-	convert_to_perf_probe_point(&tev->point, &pev->point);
+	ret = convert_to_perf_probe_point(&tev->point, &pev->point);
+	if (ret < 0)
+		return ret;
 
 	/* Convert trace_arg to probe_arg */
 	pev->nargs = tev->nargs;
 	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
-	for (i = 0; i < tev->nargs; i++)
+	for (i = 0; i < tev->nargs && ret >= 0; i++)
 		if (tev->args[i].name)
 			pev->args[i].name = xstrdup(tev->args[i].name);
 		else {
-			synthesize_kprobe_trace_arg(&tev->args[i], buf, 64);
+			ret = synthesize_kprobe_trace_arg(&tev->args[i],
+							  buf, 64);
 			pev->args[i].name = xstrdup(buf);
 		}
+
+	if (ret < 0)
+		clear_perf_probe_event(pev);
+
+	return ret;
 }
 
 void clear_perf_probe_event(struct perf_probe_event *pev)
@@ -894,21 +1018,20 @@ static int open_kprobe_events(bool readwrite)
 	int ret;
 
 	ret = e_snprintf(buf, PATH_MAX, "%s/../kprobe_events", debugfs_path);
-	if (ret < 0)
-		die("Failed to make kprobe_events path.");
-
-	if (readwrite && !probe_event_dry_run)
-		ret = open(buf, O_RDWR, O_APPEND);
-	else
-		ret = open(buf, O_RDONLY, 0);
+	if (ret >= 0) {
+		if (readwrite && !probe_event_dry_run)
+			ret = open(buf, O_RDWR, O_APPEND);
+		else
+			ret = open(buf, O_RDONLY, 0);
+	}
 
 	if (ret < 0) {
 		if (errno == ENOENT)
-			die("kprobe_events file does not exist -"
-			    " please rebuild with CONFIG_KPROBE_EVENT.");
+			pr_warning("kprobe_events file does not exist - please"
+				 " rebuild kernel with CONFIG_KPROBE_EVENT.\n");
 		else
-			die("Could not open kprobe_events file: %s",
-			    strerror(errno));
+			pr_warning("Failed to open kprobe_events file: %s\n",
+				   strerror(errno));
 	}
 	return ret;
 }
@@ -934,8 +1057,11 @@ static struct strlist *get_kprobe_trace_command_rawlist(int fd)
 		if (p[idx] == '\n')
 			p[idx] = '\0';
 		ret = strlist__add(sl, buf);
-		if (ret < 0)
-			die("strlist__add failed: %s", strerror(-ret));
+		if (ret < 0) {
+			pr_debug("strlist__add failed: %s\n", strerror(-ret));
+			strlist__delete(sl);
+			return NULL;
+		}
 	}
 	fclose(fp);
 
@@ -943,7 +1069,7 @@ static struct strlist *get_kprobe_trace_command_rawlist(int fd)
 }
 
 /* Show an event */
-static void show_perf_probe_event(struct perf_probe_event *pev)
+static int show_perf_probe_event(struct perf_probe_event *pev)
 {
 	int i, ret;
 	char buf[128];
@@ -951,52 +1077,71 @@ static void show_perf_probe_event(struct perf_probe_event *pev)
 
 	/* Synthesize only event probe point */
 	place = synthesize_perf_probe_point(&pev->point);
+	if (!place)
+		return -EINVAL;
 
 	ret = e_snprintf(buf, 128, "%s:%s", pev->group, pev->event);
 	if (ret < 0)
-		die("Failed to copy event: %s", strerror(-ret));
+		return ret;
+
 	printf("  %-20s (on %s", buf, place);
 
 	if (pev->nargs > 0) {
 		printf(" with");
 		for (i = 0; i < pev->nargs; i++) {
-			synthesize_perf_probe_arg(&pev->args[i], buf, 128);
+			ret = synthesize_perf_probe_arg(&pev->args[i],
+							buf, 128);
+			if (ret < 0)
+				break;
 			printf(" %s", buf);
 		}
 	}
 	printf(")\n");
 	free(place);
+	return ret;
 }
 
 /* List up current perf-probe events */
-void show_perf_probe_events(void)
+int show_perf_probe_events(void)
 {
-	int fd;
+	int fd, ret;
 	struct kprobe_trace_event tev;
 	struct perf_probe_event pev;
 	struct strlist *rawlist;
 	struct str_node *ent;
 
 	setup_pager();
-	init_vmlinux();
+	ret = init_vmlinux();
+	if (ret < 0)
+		return ret;
 
 	memset(&tev, 0, sizeof(tev));
 	memset(&pev, 0, sizeof(pev));
 
 	fd = open_kprobe_events(false);
+	if (fd < 0)
+		return fd;
+
 	rawlist = get_kprobe_trace_command_rawlist(fd);
 	close(fd);
+	if (!rawlist)
+		return -ENOENT;
 
 	strlist__for_each(ent, rawlist) {
-		parse_kprobe_trace_command(ent->s, &tev);
-		convert_to_perf_probe_event(&tev, &pev);
-		/* Show an event */
-		show_perf_probe_event(&pev);
+		ret = parse_kprobe_trace_command(ent->s, &tev);
+		if (ret >= 0) {
+			ret = convert_to_perf_probe_event(&tev, &pev);
+			if (ret >= 0)
+				ret = show_perf_probe_event(&pev);
+		}
 		clear_perf_probe_event(&pev);
 		clear_kprobe_trace_event(&tev);
+		if (ret < 0)
+			break;
 	}
-
 	strlist__delete(rawlist);
+
+	return ret;
 }
 
 /* Get current perf-probe event names */
@@ -1006,88 +1151,118 @@ static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
 	struct kprobe_trace_event tev;
+	int ret = 0;
 
 	memset(&tev, 0, sizeof(tev));
 
 	rawlist = get_kprobe_trace_command_rawlist(fd);
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
-		parse_kprobe_trace_command(ent->s, &tev);
+		ret = parse_kprobe_trace_command(ent->s, &tev);
+		if (ret < 0)
+			break;
 		if (include_group) {
-			if (e_snprintf(buf, 128, "%s:%s", tev.group,
-				       tev.event) < 0)
-				die("Failed to copy group:event name.");
-			strlist__add(sl, buf);
+			ret = e_snprintf(buf, 128, "%s:%s", tev.group,
+					tev.event);
+			if (ret >= 0)
+				ret = strlist__add(sl, buf);
 		} else
-			strlist__add(sl, tev.event);
+			ret = strlist__add(sl, tev.event);
 		clear_kprobe_trace_event(&tev);
+		if (ret < 0)
+			break;
 	}
-
 	strlist__delete(rawlist);
 
+	if (ret < 0) {
+		strlist__delete(sl);
+		return NULL;
+	}
 	return sl;
 }
 
-static void write_kprobe_trace_event(int fd, struct kprobe_trace_event *tev)
+static int write_kprobe_trace_event(int fd, struct kprobe_trace_event *tev)
 {
 	int ret;
 	char *buf = synthesize_kprobe_trace_command(tev);
 
+	if (!buf) {
+		pr_debug("Failed to synthesize kprobe trace event.\n");
+		return -EINVAL;
+	}
+
 	pr_debug("Writing event: %s\n", buf);
 	if (!probe_event_dry_run) {
 		ret = write(fd, buf, strlen(buf));
 		if (ret <= 0)
-			die("Failed to write event: %s", strerror(errno));
+			pr_warning("Failed to write event: %s\n",
+				   strerror(errno));
 	}
 	free(buf);
+	return ret;
 }
 
-static void get_new_event_name(char *buf, size_t len, const char *base,
-			       struct strlist *namelist, bool allow_suffix)
+static int get_new_event_name(char *buf, size_t len, const char *base,
+			      struct strlist *namelist, bool allow_suffix)
 {
 	int i, ret;
 
 	/* Try no suffix */
 	ret = e_snprintf(buf, len, "%s", base);
-	if (ret < 0)
-		die("snprintf() failed: %s", strerror(-ret));
+	if (ret < 0) {
+		pr_debug("snprintf() failed: %s\n", strerror(-ret));
+		return ret;
+	}
 	if (!strlist__has_entry(namelist, buf))
-		return;
+		return 0;
 
 	if (!allow_suffix) {
 		pr_warning("Error: event \"%s\" already exists. "
 			   "(Use -f to force duplicates.)\n", base);
-		die("Can't add new event.");
+		return -EEXIST;
 	}
 
 	/* Try to add suffix */
 	for (i = 1; i < MAX_EVENT_INDEX; i++) {
 		ret = e_snprintf(buf, len, "%s_%d", base, i);
-		if (ret < 0)
-			die("snprintf() failed: %s", strerror(-ret));
+		if (ret < 0) {
+			pr_debug("snprintf() failed: %s\n", strerror(-ret));
+			return ret;
+		}
 		if (!strlist__has_entry(namelist, buf))
 			break;
 	}
-	if (i == MAX_EVENT_INDEX)
-		die("Too many events are on the same function.");
+	if (i == MAX_EVENT_INDEX) {
+		pr_warning("Too many events are on the same function.\n");
+		ret = -ERANGE;
+	}
+
+	return ret;
 }
 
-static void __add_kprobe_trace_events(struct perf_probe_event *pev,
-				      struct kprobe_trace_event *tevs,
-				      int ntevs, bool allow_suffix)
+static int __add_kprobe_trace_events(struct perf_probe_event *pev,
+				     struct kprobe_trace_event *tevs,
+				     int ntevs, bool allow_suffix)
 {
-	int i, fd;
+	int i, fd, ret;
 	struct kprobe_trace_event *tev = NULL;
 	char buf[64];
 	const char *event, *group;
 	struct strlist *namelist;
 
 	fd = open_kprobe_events(true);
+	if (fd < 0)
+		return fd;
 	/* Get current event names */
 	namelist = get_kprobe_trace_event_names(fd, false);
+	if (!namelist) {
+		pr_debug("Failed to get current event list.\n");
+		return -EIO;
+	}
 
+	ret = 0;
 	printf("Add new event%s\n", (ntevs > 1) ? "s:" : ":");
-	for (i = 0; i < ntevs; i++) {
+	for (i = 0; i < ntevs && ret >= 0; i++) {
 		tev = &tevs[i];
 		if (pev->event)
 			event = pev->event;
@@ -1102,12 +1277,17 @@ static void __add_kprobe_trace_events(struct perf_probe_event *pev,
 			group = PERFPROBE_GROUP;
 
 		/* Get an unused new event name */
-		get_new_event_name(buf, 64, event, namelist, allow_suffix);
+		ret = get_new_event_name(buf, 64, event,
+					 namelist, allow_suffix);
+		if (ret < 0)
+			break;
 		event = buf;
 
 		tev->event = xstrdup(event);
 		tev->group = xstrdup(group);
-		write_kprobe_trace_event(fd, tev);
+		ret = write_kprobe_trace_event(fd, tev);
+		if (ret < 0)
+			break;
 		/* Add added event name to namelist */
 		strlist__add(namelist, event);
 
@@ -1129,12 +1309,17 @@ static void __add_kprobe_trace_events(struct perf_probe_event *pev,
 		 */
 		allow_suffix = true;
 	}
-	/* Show how to use the event. */
-	printf("\nYou can now use it on all perf tools, such as:\n\n");
-	printf("\tperf record -e %s:%s -a sleep 1\n\n", tev->group, tev->event);
+
+	if (ret >= 0) {
+		/* Show how to use the event. */
+		printf("\nYou can now use it on all perf tools, such as:\n\n");
+		printf("\tperf record -e %s:%s -aR sleep 1\n\n", tev->group,
+			 tev->event);
+	}
 
 	strlist__delete(namelist);
 	close(fd);
+	return ret;
 }
 
 static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
@@ -1146,7 +1331,7 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 
 	/* Convert perf_probe_event with debuginfo */
 	ntevs = try_to_find_kprobe_trace_events(pev, tevs);
-	if (ntevs > 0)
+	if (ntevs != 0)
 		return ntevs;
 
 	/* Allocate trace event buffer */
@@ -1172,10 +1357,11 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 	/* Currently just checking function name from symbol map */
 	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
 				       tev->point.symbol, NULL);
-	if (!sym)
-		die("Kernel symbol \'%s\' not found - probe not added.",
-		    tev->point.symbol);
-
+	if (!sym) {
+		pr_warning("Kernel symbol \'%s\' not found.\n",
+			   tev->point.symbol);
+		return -ENOENT;
+	}
 	return ntevs;
 }
 
@@ -1185,93 +1371,128 @@ struct __event_package {
 	int				ntevs;
 };
 
-void add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
-			   bool force_add)
+int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
+			  bool force_add)
 {
-	int i;
+	int i, j, ret;
 	struct __event_package *pkgs;
 
 	pkgs = xzalloc(sizeof(struct __event_package) * npevs);
 
 	/* Init vmlinux path */
-	init_vmlinux();
+	ret = init_vmlinux();
+	if (ret < 0)
+		return ret;
 
 	/* Loop 1: convert all events */
 	for (i = 0; i < npevs; i++) {
 		pkgs[i].pev = &pevs[i];
 		/* Convert with or without debuginfo */
-		pkgs[i].ntevs = convert_to_kprobe_trace_events(pkgs[i].pev,
-							       &pkgs[i].tevs);
+		ret  = convert_to_kprobe_trace_events(pkgs[i].pev,
+						      &pkgs[i].tevs);
+		if (ret < 0)
+			goto end;
+		pkgs[i].ntevs = ret;
 	}
 
 	/* Loop 2: add all events */
+	for (i = 0; i < npevs && ret >= 0; i++)
+		ret = __add_kprobe_trace_events(pkgs[i].pev, pkgs[i].tevs,
+						pkgs[i].ntevs, force_add);
+end:
+	/* Loop 3: cleanup trace events  */
 	for (i = 0; i < npevs; i++)
-		__add_kprobe_trace_events(pkgs[i].pev, pkgs[i].tevs,
-					  pkgs[i].ntevs, force_add);
-	/* TODO: cleanup all trace events? */
+		for (j = 0; j < pkgs[i].ntevs; j++)
+			clear_kprobe_trace_event(&pkgs[i].tevs[j]);
+
+	return ret;
 }
 
-static void __del_trace_kprobe_event(int fd, struct str_node *ent)
+static int __del_trace_kprobe_event(int fd, struct str_node *ent)
 {
 	char *p;
 	char buf[128];
 	int ret;
 
 	/* Convert from perf-probe event to trace-kprobe event */
-	if (e_snprintf(buf, 128, "-:%s", ent->s) < 0)
-		die("Failed to copy event.");
+	ret = e_snprintf(buf, 128, "-:%s", ent->s);
+	if (ret < 0)
+		goto error;
+
 	p = strchr(buf + 2, ':');
-	if (!p)
-		die("Internal error: %s should have ':' but not.", ent->s);
+	if (!p) {
+		pr_debug("Internal error: %s should have ':' but not.\n",
+			 ent->s);
+		ret = -ENOTSUP;
+		goto error;
+	}
 	*p = '/';
 
 	pr_debug("Writing event: %s\n", buf);
 	ret = write(fd, buf, strlen(buf));
-	if (ret <= 0)
-		die("Failed to write event: %s", strerror(errno));
+	if (ret < 0)
+		goto error;
+
 	printf("Remove event: %s\n", ent->s);
+	return 0;
+error:
+	pr_warning("Failed to delete event: %s\n", strerror(-ret));
+	return ret;
 }
 
-static void del_trace_kprobe_event(int fd, const char *group,
-				   const char *event, struct strlist *namelist)
+static int del_trace_kprobe_event(int fd, const char *group,
+				  const char *event, struct strlist *namelist)
 {
 	char buf[128];
 	struct str_node *ent, *n;
-	int found = 0;
+	int found = 0, ret = 0;
 
-	if (e_snprintf(buf, 128, "%s:%s", group, event) < 0)
-		die("Failed to copy event.");
+	ret = e_snprintf(buf, 128, "%s:%s", group, event);
+	if (ret < 0) {
+		pr_err("Failed to copy event.");
+		return ret;
+	}
 
 	if (strpbrk(buf, "*?")) { /* Glob-exp */
 		strlist__for_each_safe(ent, n, namelist)
 			if (strglobmatch(ent->s, buf)) {
 				found++;
-				__del_trace_kprobe_event(fd, ent);
+				ret = __del_trace_kprobe_event(fd, ent);
+				if (ret < 0)
+					break;
 				strlist__remove(namelist, ent);
 			}
 	} else {
 		ent = strlist__find(namelist, buf);
 		if (ent) {
 			found++;
-			__del_trace_kprobe_event(fd, ent);
-			strlist__remove(namelist, ent);
+			ret = __del_trace_kprobe_event(fd, ent);
+			if (ret >= 0)
+				strlist__remove(namelist, ent);
 		}
 	}
-	if (found == 0)
-		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
+	if (found == 0 && ret >= 0)
+		pr_info("Info: Event \"%s\" does not exist.\n", buf);
+
+	return ret;
 }
 
-void del_perf_probe_events(struct strlist *dellist)
+int del_perf_probe_events(struct strlist *dellist)
 {
-	int fd;
+	int fd, ret = 0;
 	const char *group, *event;
 	char *p, *str;
 	struct str_node *ent;
 	struct strlist *namelist;
 
 	fd = open_kprobe_events(true);
+	if (fd < 0)
+		return fd;
+
 	/* Get current event names */
 	namelist = get_kprobe_trace_event_names(fd, true);
+	if (namelist == NULL)
+		return -EINVAL;
 
 	strlist__for_each(ent, dellist) {
 		str = xstrdup(ent->s);
@@ -1286,10 +1507,14 @@ void del_perf_probe_events(struct strlist *dellist)
 			event = str;
 		}
 		pr_debug("Group: %s, Event: %s\n", group, event);
-		del_trace_kprobe_event(fd, group, event, namelist);
+		ret = del_trace_kprobe_event(fd, group, event, namelist);
 		free(str);
+		if (ret < 0)
+			break;
 	}
 	strlist__delete(namelist);
 	close(fd);
+
+	return ret;
 }
 
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 5a9837c..aee60e1 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -89,10 +89,10 @@ struct line_range {
 };
 
 /* Command string to events */
-extern void parse_perf_probe_command(const char *cmd,
-				     struct perf_probe_event *pev);
-extern void parse_kprobe_trace_command(const char *cmd,
-				       struct kprobe_trace_event *tev);
+extern int parse_perf_probe_command(const char *cmd,
+				    struct perf_probe_event *pev);
+extern int parse_kprobe_trace_command(const char *cmd,
+				      struct kprobe_trace_event *tev);
 
 /* Events to command string */
 extern char *synthesize_perf_probe_command(struct perf_probe_event *pev);
@@ -104,22 +104,22 @@ extern int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf,
 extern bool perf_probe_event_need_dwarf(struct perf_probe_event *pev);
 
 /* Convert from kprobe_trace_event to perf_probe_event */
-extern void convert_to_perf_probe_event(struct kprobe_trace_event *tev,
-					struct perf_probe_event *pev);
+extern int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
+				       struct perf_probe_event *pev);
 
 /* Release event contents */
 extern void clear_perf_probe_event(struct perf_probe_event *pev);
 extern void clear_kprobe_trace_event(struct kprobe_trace_event *tev);
 
 /* Command string to line-range */
-extern void parse_line_range_desc(const char *cmd, struct line_range *lr);
+extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
 
 
-extern void add_perf_probe_events(struct perf_probe_event *pevs, int ntevs,
-				  bool force_add);
-extern void del_perf_probe_events(struct strlist *dellist);
-extern void show_perf_probe_events(void);
-extern void show_line_range(struct line_range *lr);
+extern int add_perf_probe_events(struct perf_probe_event *pevs, int ntevs,
+				 bool force_add);
+extern int del_perf_probe_events(struct strlist *dellist);
+extern int show_perf_probe_events(void);
+extern int show_line_range(struct line_range *lr);
 
 
 /* Maximum index number of event-name postfix */


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
