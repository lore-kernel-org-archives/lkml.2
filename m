Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929Ab0CVS5x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 14:57:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:56300 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755898Ab0CVS5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 14:57:51 -0400
Date: Mon, 22 Mar 2010 18:55:18 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, acme@redhat.com,
       hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl, efault@gmx.de,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <1269274229-20442-2-git-send-email-acme@infradead.org>
References: <1269274229-20442-2-git-send-email-acme@infradead.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Cleanup debuginfo related code
Message-ID: <tip-4b4da7f76660ea8b5aa45615165c48f62167ffa8@git.kernel.org>
Git-Commit-ID: 4b4da7f76660ea8b5aa45615165c48f62167ffa8
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 22 Mar 2010 18:55:19 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b4da7f76660ea8b5aa45615165c48f62167ffa8
Gitweb:     http://git.kernel.org/tip/4b4da7f76660ea8b5aa45615165c48f62167ffa8
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 22 Mar 2010 13:10:26 -0300
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 22 Mar 2010 18:47:35 +0100

perf probe: Cleanup debuginfo related code

Cleanup debuginfo related code to eliminate fragile code which
pointed by Ingo (Thanks!).
1) Invert logic of NO_DWARF_SUPPORT to DWARF_SUPPORT.
2) For removing assymetric/local variable ifdefs, introduce
  more helper functions.
3) Change options order to reduce the number of ifdefs.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <1269274229-20442-2-git-send-email-acme@infradead.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/Makefile            |    3 +-
 tools/perf/builtin-probe.c     |   28 ++--
 tools/perf/util/probe-event.c  |  343 +++++++++++++++++++++-------------------
 tools/perf/util/probe-finder.h |    4 +-
 4 files changed, 200 insertions(+), 178 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 0abd25e..c991818 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -506,9 +506,8 @@ endif
 
 ifneq ($(shell sh -c "(echo '\#include <dwarf.h>'; echo '\#include <libdw.h>'; echo 'int main(void) { Dwarf *dbg; dbg = dwarf_begin(0, DWARF_C_READ); return (long)dbg; }') | $(CC) -x c - $(ALL_CFLAGS) -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -I/usr/include/elfutils -ldw -lelf -o $(BITBUCKET) $(ALL_LDFLAGS) $(EXTLIBS) "$(QUIET_STDERR)" && echo y"), y)
 	msg := $(warning No libdw.h found or old libdw.h found, disables dwarf support. Please install elfutils-devel/elfutils-dev);
-	BASIC_CFLAGS += -DNO_DWARF_SUPPORT
 else
-	BASIC_CFLAGS += -I/usr/include/elfutils
+	BASIC_CFLAGS += -I/usr/include/elfutils -DDWARF_SUPPORT
 	EXTLIBS += -lelf -ldw
 	LIB_OBJS += util/probe-finder.o
 endif
diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index e0dafd9..cf2ffa5 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -109,7 +109,7 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
-#ifndef NO_DWARF_SUPPORT
+#ifdef DWARF_SUPPORT
 static int opt_show_lines(const struct option *opt __used,
 			  const char *str, int unset __used)
 {
@@ -126,7 +126,7 @@ static const char * const probe_usage[] = {
 	"perf probe [<options>] --add 'PROBEDEF' [--add 'PROBEDEF' ...]",
 	"perf probe [<options>] --del '[GROUP:]EVENT' ...",
 	"perf probe --list",
-#ifndef NO_DWARF_SUPPORT
+#ifdef DWARF_SUPPORT
 	"perf probe --line 'LINEDESC'",
 #endif
 	NULL
@@ -135,20 +135,16 @@ static const char * const probe_usage[] = {
 static const struct option options[] = {
 	OPT_BOOLEAN('v', "verbose", &verbose,
 		    "be more verbose (show parsed arguments, etc)"),
-#ifndef NO_DWARF_SUPPORT
-	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
-		   "file", "vmlinux pathname"),
-#endif
 	OPT_BOOLEAN('l', "list", &params.list_events,
 		    "list up current probe events"),
 	OPT_CALLBACK('d', "del", NULL, "[GROUP:]EVENT", "delete a probe event.",
 		opt_del_probe_event),
 	OPT_CALLBACK('a', "add", NULL,
-#ifdef NO_DWARF_SUPPORT
-		"[EVENT=]FUNC[+OFF|%return] [ARG ...]",
-#else
+#ifdef DWARF_SUPPORT
 		"[EVENT=]FUNC[@SRC][+OFF|%return|:RL|;PT]|SRC:AL|SRC;PT"
 		" [ARG ...]",
+#else
+		"[EVENT=]FUNC[+OFF|%return] [ARG ...]",
 #endif
 		"probe point definition, where\n"
 		"\t\tGROUP:\tGroup name (optional)\n"
@@ -156,23 +152,25 @@ static const struct option options[] = {
 		"\t\tFUNC:\tFunction name\n"
 		"\t\tOFF:\tOffset from function entry (in byte)\n"
 		"\t\t%return:\tPut the probe at function return\n"
-#ifdef NO_DWARF_SUPPORT
-		"\t\tARG:\tProbe argument (only \n"
-#else
+#ifdef DWARF_SUPPORT
 		"\t\tSRC:\tSource code path\n"
 		"\t\tRL:\tRelative line number from function entry.\n"
 		"\t\tAL:\tAbsolute line number in file.\n"
 		"\t\tPT:\tLazy expression of line code.\n"
 		"\t\tARG:\tProbe argument (local variable name or\n"
-#endif
 		"\t\t\tkprobe-tracer argument format.)\n",
+#else
+		"\t\tARG:\tProbe argument (kprobe-tracer argument format.)\n",
+#endif
 		opt_add_probe_event),
 	OPT_BOOLEAN('f', "force", &params.force_add, "forcibly add events"
 		    " with existing name"),
-#ifndef NO_DWARF_SUPPORT
+#ifdef DWARF_SUPPORT
 	OPT_CALLBACK('L', "line", NULL,
 		     "FUNC[:RLN[+NUM|:RLN2]]|SRC:ALN[+NUM|:ALN2]",
 		     "Show source code lines.", opt_show_lines),
+	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
+		   "file", "vmlinux pathname"),
 #endif
 	OPT__DRY_RUN(&probe_event_dry_run),
 	OPT_END()
@@ -211,7 +209,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		return 0;
 	}
 
-#ifndef NO_DWARF_SUPPORT
+#ifdef DWARF_SUPPORT
 	if (params.show_lines) {
 		if (params.nevents != 0 || params.dellist) {
 			pr_warning("  Error: Don't use --line with"
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index c6603f3..3fc0be7 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -42,7 +42,8 @@
 #include "color.h"
 #include "symbol.h"
 #include "thread.h"
-#include "parse-events.h"  /* For debugfs_path */
+#include "trace-event.h"	/* For __unused */
+#include "parse-events.h"	/* For debugfs_path */
 #include "probe-event.h"
 #include "probe-finder.h"
 
@@ -70,10 +71,11 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 	return ret;
 }
 
+static char *synthesize_perf_probe_point(struct perf_probe_point *pp);
 static struct map_groups kmap_groups;
 static struct map *kmaps[MAP__NR_TYPES];
 
-/* Initialize symbol maps for vmlinux */
+/* Initialize symbol maps and path of vmlinux */
 static void init_vmlinux(void)
 {
 	symbol_conf.sort_by_name = true;
@@ -89,7 +91,7 @@ static void init_vmlinux(void)
 		die("Failed to create kernel maps.");
 }
 
-#ifndef NO_DWARF_SUPPORT
+#ifdef DWARF_SUPPORT
 static int open_vmlinux(void)
 {
 	if (map__load(kmaps[MAP__FUNCTION], NULL) < 0) {
@@ -99,6 +101,176 @@ static int open_vmlinux(void)
 	pr_debug("Try to open %s\n", kmaps[MAP__FUNCTION]->dso->long_name);
 	return open(kmaps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
 }
+
+static void convert_to_perf_probe_point(struct kprobe_trace_point *tp,
+					struct perf_probe_point *pp)
+{
+	struct symbol *sym;
+	int fd, ret = 0;
+
+	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
+				       tp->symbol, NULL);
+	if (sym) {
+		fd = open_vmlinux();
+		ret = find_perf_probe_point(fd, sym->start + tp->offset, pp);
+		close(fd);
+	}
+	if (ret <= 0) {
+		pp->function = xstrdup(tp->symbol);
+		pp->offset = tp->offset;
+	}
+	pp->retprobe = tp->retprobe;
+}
+
+/* Try to find perf_probe_event with debuginfo */
+static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
+					   struct kprobe_trace_event **tevs)
+{
+	bool need_dwarf = perf_probe_event_need_dwarf(pev);
+	int fd, ntevs;
+
+	fd = open_vmlinux();
+	if (fd < 0) {
+		if (need_dwarf)
+			die("Could not open debuginfo file.");
+
+		pr_debug("Could not open vmlinux. Try to use symbols.\n");
+		return 0;
+	}
+
+	/* Searching trace events corresponding to probe event */
+	ntevs = find_kprobe_trace_events(fd, pev, tevs);
+	close(fd);
+
+	if (ntevs > 0)	/* Succeeded to find trace events */
+		return ntevs;
+
+	if (ntevs == 0)	/* No error but failed to find probe point. */
+		die("Probe point '%s' not found. - probe not added.",
+		    synthesize_perf_probe_point(&pev->point));
+
+	/* Error path */
+	if (need_dwarf) {
+		if (ntevs == -ENOENT)
+			pr_warning("No dwarf info found in the vmlinux - "
+				"please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		die("Could not analyze debuginfo.");
+	}
+	pr_debug("An error occurred in debuginfo analysis."
+		 " Try to use symbols.\n");
+	return 0;
+
+}
+
+#define LINEBUF_SIZE 256
+#define NR_ADDITIONAL_LINES 2
+
+static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
+{
+	char buf[LINEBUF_SIZE];
+	const char *color = PERF_COLOR_BLUE;
+
+	if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
+		goto error;
+	if (!skip) {
+		if (show_num)
+			fprintf(stdout, "%7u  %s", l, buf);
+		else
+			color_fprintf(stdout, color, "         %s", buf);
+	}
+
+	while (strlen(buf) == LINEBUF_SIZE - 1 &&
+	       buf[LINEBUF_SIZE - 2] != '\n') {
+		if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
+			goto error;
+		if (!skip) {
+			if (show_num)
+				fprintf(stdout, "%s", buf);
+			else
+				color_fprintf(stdout, color, "%s", buf);
+		}
+	}
+	return;
+error:
+	if (feof(fp))
+		die("Source file is shorter than expected.");
+	else
+		die("File read error: %s", strerror(errno));
+}
+
+/*
+ * Show line-range always requires debuginfo to find source file and
+ * line number.
+ */
+void show_line_range(struct line_range *lr)
+{
+	unsigned int l = 1;
+	struct line_node *ln;
+	FILE *fp;
+	int fd, ret;
+
+	/* Search a line range */
+	init_vmlinux();
+	fd = open_vmlinux();
+	if (fd < 0)
+		die("Could not open debuginfo file.");
+	ret = find_line_range(fd, lr);
+	if (ret <= 0)
+		die("Source line is not found.\n");
+	close(fd);
+
+	setup_pager();
+
+	if (lr->function)
+		fprintf(stdout, "<%s:%d>\n", lr->function,
+			lr->start - lr->offset);
+	else
+		fprintf(stdout, "<%s:%d>\n", lr->file, lr->start);
+
+	fp = fopen(lr->path, "r");
+	if (fp == NULL)
+		die("Failed to open %s: %s", lr->path, strerror(errno));
+	/* Skip to starting line number */
+	while (l < lr->start)
+		show_one_line(fp, l++, true, false);
+
+	list_for_each_entry(ln, &lr->line_list, list) {
+		while (ln->line > l)
+			show_one_line(fp, (l++) - lr->offset, false, false);
+		show_one_line(fp, (l++) - lr->offset, false, true);
+	}
+
+	if (lr->end == INT_MAX)
+		lr->end = l + NR_ADDITIONAL_LINES;
+	while (l < lr->end && !feof(fp))
+		show_one_line(fp, (l++) - lr->offset, false, false);
+
+	fclose(fp);
+}
+
+#else	/* !DWARF_SUPPORT */
+
+static void convert_to_perf_probe_point(struct kprobe_trace_point *tp,
+					struct perf_probe_point *pp)
+{
+	pp->function = xstrdup(tp->symbol);
+	pp->offset = tp->offset;
+	pp->retprobe = tp->retprobe;
+}
+
+static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
+				struct kprobe_trace_event **tevs __unused)
+{
+	if (perf_probe_event_need_dwarf(pev))
+		die("Debuginfo-analysis is not supported");
+	return 0;
+}
+
+void show_line_range(struct line_range *lr __unused)
+{
+	die("Debuginfo-analysis is not supported");
+}
+
 #endif
 
 void parse_line_range_desc(const char *arg, struct line_range *lr)
@@ -592,32 +764,14 @@ void convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 {
 	char buf[64];
 	int i;
-#ifndef NO_DWARF_SUPPORT
-	struct symbol *sym;
-	int fd, ret = 0;
-
-	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
-				       tev->point.symbol, NULL);
-	if (sym) {
-		fd = open_vmlinux();
-		ret = find_perf_probe_point(fd, sym->start + tev->point.offset,
-					    &pev->point);
-		close(fd);
-	}
-	if (ret <= 0) {
-		pev->point.function = xstrdup(tev->point.symbol);
-		pev->point.offset = tev->point.offset;
-	}
-#else
-	/* Convert trace_point to probe_point */
-	pev->point.function = xstrdup(tev->point.symbol);
-	pev->point.offset = tev->point.offset;
-#endif
-	pev->point.retprobe = tev->point.retprobe;
 
+	/* Convert event/group name */
 	pev->event = xstrdup(tev->event);
 	pev->group = xstrdup(tev->group);
 
+	/* Convert trace_point to probe_point */
+	convert_to_perf_probe_point(&tev->point, &pev->point);
+
 	/* Convert trace_arg to probe_arg */
 	pev->nargs = tev->nargs;
 	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
@@ -944,52 +1098,13 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 					  struct kprobe_trace_event **tevs)
 {
 	struct symbol *sym;
-	bool need_dwarf;
-#ifndef NO_DWARF_SUPPORT
-	int fd;
-#endif
 	int ntevs = 0, i;
 	struct kprobe_trace_event *tev;
 
-	need_dwarf = perf_probe_event_need_dwarf(pev);
-
-	if (need_dwarf)
-#ifdef NO_DWARF_SUPPORT
-		die("Debuginfo-analysis is not supported");
-#else	/* !NO_DWARF_SUPPORT */
-		pr_debug("Some probes require debuginfo.\n");
-
-	fd = open_vmlinux();
-	if (fd < 0) {
-		if (need_dwarf)
-			die("Could not open debuginfo file.");
-
-		pr_debug("Could not open vmlinux/module file."
-			 " Try to use symbols.\n");
-		goto end_dwarf;
-	}
-
-	/* Searching probe points */
-	ntevs = find_kprobe_trace_events(fd, pev, tevs);
-
-	if (ntevs > 0)	/* Found */
-		goto found;
-
-	if (ntevs == 0)	/* No error but failed to find probe point. */
-		die("Probe point '%s' not found. - probe not added.",
-		    synthesize_perf_probe_point(&pev->point));
-
-	/* Error path */
-	if (need_dwarf) {
-		if (ntevs == -ENOENT)
-			pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO=y.\n");
-		die("Could not analyze debuginfo.");
-	}
-	pr_debug("An error occurred in debuginfo analysis."
-		 " Try to use symbols.\n");
-
-end_dwarf:
-#endif /* !NO_DWARF_SUPPORT */
+	/* Convert perf_probe_event with debuginfo */
+	ntevs = try_to_find_kprobe_trace_events(pev, tevs);
+	if (ntevs > 0)
+		return ntevs;
 
 	/* Allocate trace event buffer */
 	ntevs = 1;
@@ -1012,10 +1127,7 @@ end_dwarf:
 	if (!sym)
 		die("Kernel symbol \'%s\' not found - probe not added.",
 		    tev->point.symbol);
-#ifndef NO_DWARF_SUPPORT
-found:
-	close(fd);
-#endif
+
 	return ntevs;
 }
 
@@ -1133,90 +1245,3 @@ void del_perf_probe_events(struct strlist *dellist)
 	close(fd);
 }
 
-#define LINEBUF_SIZE 256
-#define NR_ADDITIONAL_LINES 2
-
-static void show_one_line(FILE *fp, unsigned int l, bool skip, bool show_num)
-{
-	char buf[LINEBUF_SIZE];
-	const char *color = PERF_COLOR_BLUE;
-
-	if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
-		goto error;
-	if (!skip) {
-		if (show_num)
-			fprintf(stdout, "%7u  %s", l, buf);
-		else
-			color_fprintf(stdout, color, "         %s", buf);
-	}
-
-	while (strlen(buf) == LINEBUF_SIZE - 1 &&
-	       buf[LINEBUF_SIZE - 2] != '\n') {
-		if (fgets(buf, LINEBUF_SIZE, fp) == NULL)
-			goto error;
-		if (!skip) {
-			if (show_num)
-				fprintf(stdout, "%s", buf);
-			else
-				color_fprintf(stdout, color, "%s", buf);
-		}
-	}
-	return;
-error:
-	if (feof(fp))
-		die("Source file is shorter than expected.");
-	else
-		die("File read error: %s", strerror(errno));
-}
-
-void show_line_range(struct line_range *lr)
-{
-	unsigned int l = 1;
-	struct line_node *ln;
-	FILE *fp;
-#ifndef NO_DWARF_SUPPORT
-	int fd, ret;
-#endif
-
-	/* Search a line range */
-	init_vmlinux();
-#ifndef NO_DWARF_SUPPORT
-	fd = open_vmlinux();
-	if (fd < 0)
-		die("Could not open debuginfo file.");
-	ret = find_line_range(fd, lr);
-	if (ret <= 0)
-		die("Source line is not found.\n");
-	close(fd);
-#endif
-
-	setup_pager();
-
-	if (lr->function)
-		fprintf(stdout, "<%s:%d>\n", lr->function,
-			lr->start - lr->offset);
-	else
-		fprintf(stdout, "<%s:%d>\n", lr->file, lr->start);
-
-	fp = fopen(lr->path, "r");
-	if (fp == NULL)
-		die("Failed to open %s: %s", lr->path, strerror(errno));
-	/* Skip to starting line number */
-	while (l < lr->start)
-		show_one_line(fp, l++, true, false);
-
-	list_for_each_entry(ln, &lr->line_list, list) {
-		while (ln->line > l)
-			show_one_line(fp, (l++) - lr->offset, false, false);
-		show_one_line(fp, (l++) - lr->offset, false, true);
-	}
-
-	if (lr->end == INT_MAX)
-		lr->end = l + NR_ADDITIONAL_LINES;
-	while (l < lr->end && !feof(fp))
-		show_one_line(fp, (l++) - lr->offset, false, false);
-
-	fclose(fp);
-}
-
-
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 2f2307d..3564f22 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -15,7 +15,7 @@ static inline int is_c_varname(const char *name)
 	return isalpha(name[0]) || name[0] == '_';
 }
 
-#ifndef NO_DWARF_SUPPORT
+#ifdef DWARF_SUPPORT
 /* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
 extern int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 				    struct kprobe_trace_event **tevs);
@@ -57,6 +57,6 @@ struct line_finder {
 	int			found;
 };
 
-#endif /* NO_DWARF_SUPPORT */
+#endif /* DWARF_SUPPORT */
 
 #endif /*_PROBE_FINDER_H */
