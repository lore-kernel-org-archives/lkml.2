Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab0CPV6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:58:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0CPV5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:57:54 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 03/10] perf probe: Move add-probe routine under util/
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Mar 2010 18:05:37 -0400
Message-ID: <20100316220537.32050.72214.stgit@localhost6.localdomain6>
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move add-probe routine into util/probe_event.c. This simplifies
main routine for reducing maintenance cost.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 tools/perf/builtin-probe.c    |  126 +-------------------------------------
 tools/perf/util/probe-event.c |  137 ++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/probe-event.h |    2 -
 3 files changed, 139 insertions(+), 126 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index b6afe7b..2087034 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -36,11 +36,9 @@
 #include "builtin.h"
 #include "util/util.h"
 #include "util/strlist.h"
-#include "util/event.h"
+#include "util/symbol.h"
 #include "util/debug.h"
 #include "util/debugfs.h"
-#include "util/symbol.h"
-#include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/parse-events.h"	/* For debugfs_path */
 #include "util/probe-finder.h"
@@ -57,8 +55,6 @@ static struct {
 	int nr_probe;
 	struct probe_point probes[MAX_PROBES];
 	struct strlist *dellist;
-	struct map_groups kmap_groups;
-	struct map *kmaps[MAP__NR_TYPES];
 	struct line_range line_range;
 } session;
 
@@ -114,29 +110,7 @@ static int opt_del_probe_event(const struct option *opt __used,
 	return 0;
 }
 
-/* Currently just checking function name from symbol map */
-static void evaluate_probe_point(struct probe_point *pp)
-{
-	struct symbol *sym;
-	sym = map__find_symbol_by_name(session.kmaps[MAP__FUNCTION],
-				       pp->function, NULL);
-	if (!sym)
-		die("Kernel symbol \'%s\' not found - probe not added.",
-		    pp->function);
-}
-
 #ifndef NO_DWARF_SUPPORT
-static int open_vmlinux(void)
-{
-	if (map__load(session.kmaps[MAP__FUNCTION], NULL) < 0) {
-		pr_debug("Failed to load kernel map.\n");
-		return -EINVAL;
-	}
-	pr_debug("Try to open %s\n",
-		 session.kmaps[MAP__FUNCTION]->dso->long_name);
-	return open(session.kmaps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
-}
-
 static int opt_show_lines(const struct option *opt __used,
 			  const char *str, int unset __used)
 {
@@ -204,31 +178,8 @@ static const struct option options[] = {
 	OPT_END()
 };
 
-/* Initialize symbol maps for vmlinux */
-static void init_vmlinux(void)
-{
-	symbol_conf.sort_by_name = true;
-	if (symbol_conf.vmlinux_name == NULL)
-		symbol_conf.try_vmlinux_path = true;
-	else
-		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
-	if (symbol__init() < 0)
-		die("Failed to init symbol map.");
-
-	map_groups__init(&session.kmap_groups);
-	if (map_groups__create_kernel_maps(&session.kmap_groups,
-					   session.kmaps) < 0)
-		die("Failed to create kernel maps.");
-}
-
 int cmd_probe(int argc, const char **argv, const char *prefix __used)
 {
-	int i, ret;
-#ifndef NO_DWARF_SUPPORT
-	int fd;
-#endif
-	struct probe_point *pp;
-
 	argc = parse_options(argc, argv, options, probe_usage,
 			     PARSE_OPT_STOP_AT_NON_OPTION);
 	if (argc > 0) {
@@ -267,14 +218,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 				   " --add/--del.\n");
 			usage_with_options(probe_usage, options);
 		}
-		init_vmlinux();
-		fd = open_vmlinux();
-		if (fd < 0)
-			die("Could not open debuginfo file.");
-		ret = find_line_range(fd, &session.line_range);
-		if (ret <= 0)
-			die("Source line is not found.\n");
-		close(fd);
+
 		show_line_range(&session.line_range);
 		return 0;
 	}
@@ -287,72 +231,8 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 			return 0;
 	}
 
-	/* Add probes */
-	init_vmlinux();
-
-	if (session.need_dwarf)
-#ifdef NO_DWARF_SUPPORT
-		die("Debuginfo-analysis is not supported");
-#else	/* !NO_DWARF_SUPPORT */
-		pr_debug("Some probes require debuginfo.\n");
-
-	fd = open_vmlinux();
-	if (fd < 0) {
-		if (session.need_dwarf)
-			die("Could not open debuginfo file.");
-
-		pr_debug("Could not open vmlinux/module file."
-			 " Try to use symbols.\n");
-		goto end_dwarf;
-	}
-
-	/* Searching probe points */
-	for (i = 0; i < session.nr_probe; i++) {
-		pp = &session.probes[i];
-		if (pp->found)
-			continue;
-
-		lseek(fd, SEEK_SET, 0);
-		ret = find_probe_point(fd, pp);
-		if (ret > 0)
-			continue;
-		if (ret == 0) {	/* No error but failed to find probe point. */
-			synthesize_perf_probe_point(pp);
-			die("Probe point '%s' not found. - probe not added.",
-			    pp->probes[0]);
-		}
-		/* Error path */
-		if (session.need_dwarf) {
-			if (ret == -ENOENT)
-				pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO=y.\n");
-			die("Could not analyze debuginfo.");
-		}
-		pr_debug("An error occurred in debuginfo analysis."
-			 " Try to use symbols.\n");
-		break;
-	}
-	close(fd);
-
-end_dwarf:
-#endif /* !NO_DWARF_SUPPORT */
-
-	/* Synthesize probes without dwarf */
-	for (i = 0; i < session.nr_probe; i++) {
-		pp = &session.probes[i];
-		if (pp->found)	/* This probe is already found. */
-			continue;
-
-		evaluate_probe_point(pp);
-		ret = synthesize_trace_kprobe_event(pp);
-		if (ret == -E2BIG)
-			die("probe point definition becomes too long.");
-		else if (ret < 0)
-			die("Failed to synthesize a probe point.");
-	}
-
-	/* Settng up probe points */
 	add_trace_kprobe_events(session.probes, session.nr_probe,
-				session.force_add);
+				session.force_add, session.need_dwarf);
 	return 0;
 }
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 88a3b6d..1e60a65 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -40,6 +40,8 @@
 #include "debug.h"
 #include "cache.h"
 #include "color.h"
+#include "symbol.h"
+#include "thread.h"
 #include "parse-events.h"  /* For debugfs_path */
 #include "probe-event.h"
 
@@ -65,6 +67,38 @@ static int e_snprintf(char *str, size_t size, const char *format, ...)
 	return ret;
 }
 
+
+static struct map_groups kmap_groups;
+static struct map *kmaps[MAP__NR_TYPES];
+
+/* Initialize symbol maps for vmlinux */
+static void init_vmlinux(void)
+{
+	symbol_conf.sort_by_name = true;
+	if (symbol_conf.vmlinux_name == NULL)
+		symbol_conf.try_vmlinux_path = true;
+	else
+		pr_debug("Use vmlinux: %s\n", symbol_conf.vmlinux_name);
+	if (symbol__init() < 0)
+		die("Failed to init symbol map.");
+
+	map_groups__init(&kmap_groups);
+	if (map_groups__create_kernel_maps(&kmap_groups, kmaps) < 0)
+		die("Failed to create kernel maps.");
+}
+
+#ifndef NO_DWARF_SUPPORT
+static int open_vmlinux(void)
+{
+	if (map__load(kmaps[MAP__FUNCTION], NULL) < 0) {
+		pr_debug("Failed to load kernel map.\n");
+		return -EINVAL;
+	}
+	pr_debug("Try to open %s\n", kmaps[MAP__FUNCTION]->dso->long_name);
+	return open(kmaps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
+}
+#endif
+
 void parse_line_range_desc(const char *arg, struct line_range *lr)
 {
 	const char *ptr;
@@ -586,8 +620,8 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 		die("Too many events are on the same function.");
 }
 
-void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
-			     bool force_add)
+static void __add_trace_kprobe_events(struct probe_point *probes,
+				      int nr_probes, bool force_add)
 {
 	int i, j, fd;
 	struct probe_point *pp;
@@ -640,6 +674,92 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
 	close(fd);
 }
 
+/* Currently just checking function name from symbol map */
+static void evaluate_probe_point(struct probe_point *pp)
+{
+	struct symbol *sym;
+	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
+				       pp->function, NULL);
+	if (!sym)
+		die("Kernel symbol \'%s\' not found - probe not added.",
+		    pp->function);
+}
+
+void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
+			     bool force_add, bool need_dwarf)
+{
+	int i, ret;
+	struct probe_point *pp;
+#ifndef NO_DWARF_SUPPORT
+	int fd;
+#endif
+	/* Add probes */
+	init_vmlinux();
+
+	if (need_dwarf)
+#ifdef NO_DWARF_SUPPORT
+		die("Debuginfo-analysis is not supported");
+#else	/* !NO_DWARF_SUPPORT */
+		pr_debug("Some probes require debuginfo.\n");
+
+	fd = open_vmlinux();
+	if (fd < 0) {
+		if (need_dwarf)
+			die("Could not open debuginfo file.");
+
+		pr_debug("Could not open vmlinux/module file."
+			 " Try to use symbols.\n");
+		goto end_dwarf;
+	}
+
+	/* Searching probe points */
+	for (i = 0; i < nr_probes; i++) {
+		pp = &probes[i];
+		if (pp->found)
+			continue;
+
+		lseek(fd, SEEK_SET, 0);
+		ret = find_probe_point(fd, pp);
+		if (ret > 0)
+			continue;
+		if (ret == 0) {	/* No error but failed to find probe point. */
+			synthesize_perf_probe_point(pp);
+			die("Probe point '%s' not found. - probe not added.",
+			    pp->probes[0]);
+		}
+		/* Error path */
+		if (need_dwarf) {
+			if (ret == -ENOENT)
+				pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO=y.\n");
+			die("Could not analyze debuginfo.");
+		}
+		pr_debug("An error occurred in debuginfo analysis."
+			 " Try to use symbols.\n");
+		break;
+	}
+	close(fd);
+
+end_dwarf:
+#endif /* !NO_DWARF_SUPPORT */
+
+	/* Synthesize probes without dwarf */
+	for (i = 0; i < nr_probes; i++) {
+		pp = &probes[i];
+		if (pp->found)	/* This probe is already found. */
+			continue;
+
+		evaluate_probe_point(pp);
+		ret = synthesize_trace_kprobe_event(pp);
+		if (ret == -E2BIG)
+			die("probe point definition becomes too long.");
+		else if (ret < 0)
+			die("Failed to synthesize a probe point.");
+	}
+
+	/* Settng up probe points */
+	__add_trace_kprobe_events(probes, nr_probes, force_add);
+}
+
 static void __del_trace_kprobe_event(int fd, struct str_node *ent)
 {
 	char *p;
@@ -759,6 +879,17 @@ void show_line_range(struct line_range *lr)
 	unsigned int l = 1;
 	struct line_node *ln;
 	FILE *fp;
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
 
 	setup_pager();
 
@@ -788,3 +919,5 @@ void show_line_range(struct line_range *lr)
 
 	fclose(fp);
 }
+
+
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 711287d..3865e16 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -13,7 +13,7 @@ extern int synthesize_perf_probe_event(struct probe_point *pp);
 extern void parse_trace_kprobe_event(const char *str, struct probe_point *pp);
 extern int synthesize_trace_kprobe_event(struct probe_point *pp);
 extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
-				    bool force_add);
+				    bool force_add, bool need_dwarf);
 extern void del_trace_kprobe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
 extern void show_line_range(struct line_range *lr);


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
