Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab0HBBJY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:09:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752712Ab0HBBJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:09:20 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mark Wielaard <mjw@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Naren A Devaiah <naren.devaiah@in.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 17/19] perf probe: Rename common fields/functions from kprobe to probe.
Date: Sun,  1 Aug 2010 22:08:52 -0300
Message-Id: <1280711334-30000-18-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1280711334-30000-1-git-send-email-acme@infradead.org>
References: <1280711334-30000-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

As a precursor for perf to support uprobes, rename fields/functions
that had kprobe in their name but can be shared across perf-kprobes
and perf-uprobes to probe.

Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: "Frank Ch. Eigler" <fche@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jim Keniston <jkenisto@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Mark Wielaard <mjw@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Naren A Devaiah <naren.devaiah@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Cc: Steven Rostedt <rostedt@goodmis.org>
LKML-Reference: <20100729141351.GG21723@linux.vnet.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-probe.c     |    1 -
 tools/perf/util/probe-event.c  |  135 ++++++++++++++++++++-------------------
 tools/perf/util/probe-event.h  |   27 +++-----
 tools/perf/util/probe-finder.c |   34 +++++-----
 tools/perf/util/probe-finder.h |   10 ++--
 5 files changed, 101 insertions(+), 106 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 5455186..199d5e1 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -267,4 +267,3 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 	}
 	return 0;
 }
-
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 4445a1e..2e665cb 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1,5 +1,5 @@
 /*
- * probe-event.c : perf-probe definition to kprobe_events format converter
+ * probe-event.c : perf-probe definition to probe_events format converter
  *
  * Written by Masami Hiramatsu <mhiramat@redhat.com>
  *
@@ -120,8 +120,11 @@ static int open_vmlinux(void)
 	return open(machine.vmlinux_maps[MAP__FUNCTION]->dso->long_name, O_RDONLY);
 }
 
-/* Convert trace point to probe point with debuginfo */
-static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
+/*
+ * Convert trace point to probe point with debuginfo
+ * Currently only handles kprobes.
+ */
+static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 				       struct perf_probe_point *pp)
 {
 	struct symbol *sym;
@@ -151,8 +154,8 @@ static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 }
 
 /* Try to find perf_probe_event with debuginfo */
-static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
-					   struct kprobe_trace_event **tevs,
+static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
+					   struct probe_trace_event **tevs,
 					   int max_tevs)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
@@ -169,11 +172,11 @@ static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
 	}
 
 	/* Searching trace events corresponding to probe event */
-	ntevs = find_kprobe_trace_events(fd, pev, tevs, max_tevs);
+	ntevs = find_probe_trace_events(fd, pev, tevs, max_tevs);
 	close(fd);
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
-		pr_debug("find %d kprobe_trace_events.\n", ntevs);
+		pr_debug("find %d probe_trace_events.\n", ntevs);
 		return ntevs;
 	}
 
@@ -377,8 +380,8 @@ end:
 
 #else	/* !DWARF_SUPPORT */
 
-static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
-					struct perf_probe_point *pp)
+static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
+				       struct perf_probe_point *pp)
 {
 	pp->function = strdup(tp->symbol);
 	if (pp->function == NULL)
@@ -389,8 +392,8 @@ static int convert_to_perf_probe_point(struct kprobe_trace_point *tp,
 	return 0;
 }
 
-static int try_to_find_kprobe_trace_events(struct perf_probe_event *pev,
-				struct kprobe_trace_event **tevs __unused,
+static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
+				struct probe_trace_event **tevs __unused,
 				int max_tevs __unused)
 {
 	if (perf_probe_event_need_dwarf(pev)) {
@@ -781,16 +784,17 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 	return false;
 }
 
-/* Parse kprobe_events event into struct probe_point */
-int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
+/* Parse probe_events event into struct probe_point */
+static int parse_probe_trace_command(const char *cmd,
+					struct probe_trace_event *tev)
 {
-	struct kprobe_trace_point *tp = &tev->point;
+	struct probe_trace_point *tp = &tev->point;
 	char pr;
 	char *p;
 	int ret, i, argc;
 	char **argv;
 
-	pr_debug("Parsing kprobe_events: %s\n", cmd);
+	pr_debug("Parsing probe_events: %s\n", cmd);
 	argv = argv_split(cmd, &argc);
 	if (!argv) {
 		pr_debug("Failed to split arguments.\n");
@@ -822,7 +826,7 @@ int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 		tp->offset = 0;
 
 	tev->nargs = argc - 2;
-	tev->args = zalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
 	if (tev->args == NULL) {
 		ret = -ENOMEM;
 		goto out;
@@ -968,13 +972,13 @@ char *synthesize_perf_probe_command(struct perf_probe_event *pev)
 }
 #endif
 
-static int __synthesize_kprobe_trace_arg_ref(struct kprobe_trace_arg_ref *ref,
+static int __synthesize_probe_trace_arg_ref(struct probe_trace_arg_ref *ref,
 					     char **buf, size_t *buflen,
 					     int depth)
 {
 	int ret;
 	if (ref->next) {
-		depth = __synthesize_kprobe_trace_arg_ref(ref->next, buf,
+		depth = __synthesize_probe_trace_arg_ref(ref->next, buf,
 							 buflen, depth + 1);
 		if (depth < 0)
 			goto out;
@@ -992,10 +996,10 @@ out:
 
 }
 
-static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
+static int synthesize_probe_trace_arg(struct probe_trace_arg *arg,
 				       char *buf, size_t buflen)
 {
-	struct kprobe_trace_arg_ref *ref = arg->ref;
+	struct probe_trace_arg_ref *ref = arg->ref;
 	int ret, depth = 0;
 	char *tmp = buf;
 
@@ -1015,7 +1019,7 @@ static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
 
 	/* Dereferencing arguments */
 	if (ref) {
-		depth = __synthesize_kprobe_trace_arg_ref(ref, &buf,
+		depth = __synthesize_probe_trace_arg_ref(ref, &buf,
 							  &buflen, 1);
 		if (depth < 0)
 			return depth;
@@ -1051,9 +1055,9 @@ static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
 	return buf - tmp;
 }
 
-char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev)
+char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 {
-	struct kprobe_trace_point *tp = &tev->point;
+	struct probe_trace_point *tp = &tev->point;
 	char *buf;
 	int i, len, ret;
 
@@ -1069,7 +1073,7 @@ char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev)
 		goto error;
 
 	for (i = 0; i < tev->nargs; i++) {
-		ret = synthesize_kprobe_trace_arg(&tev->args[i], buf + len,
+		ret = synthesize_probe_trace_arg(&tev->args[i], buf + len,
 						  MAX_CMDLEN - len);
 		if (ret <= 0)
 			goto error;
@@ -1082,7 +1086,7 @@ error:
 	return NULL;
 }
 
-int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
+static int convert_to_perf_probe_event(struct probe_trace_event *tev,
 				struct perf_probe_event *pev)
 {
 	char buf[64] = "";
@@ -1095,7 +1099,7 @@ int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 		return -ENOMEM;
 
 	/* Convert trace_point to probe_point */
-	ret = convert_to_perf_probe_point(&tev->point, &pev->point);
+	ret = kprobe_convert_to_perf_probe(&tev->point, &pev->point);
 	if (ret < 0)
 		return ret;
 
@@ -1108,7 +1112,7 @@ int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 		if (tev->args[i].name)
 			pev->args[i].name = strdup(tev->args[i].name);
 		else {
-			ret = synthesize_kprobe_trace_arg(&tev->args[i],
+			ret = synthesize_probe_trace_arg(&tev->args[i],
 							  buf, 64);
 			pev->args[i].name = strdup(buf);
 		}
@@ -1159,9 +1163,9 @@ void clear_perf_probe_event(struct perf_probe_event *pev)
 	memset(pev, 0, sizeof(*pev));
 }
 
-void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
+static void clear_probe_trace_event(struct probe_trace_event *tev)
 {
-	struct kprobe_trace_arg_ref *ref, *next;
+	struct probe_trace_arg_ref *ref, *next;
 	int i;
 
 	if (tev->event)
@@ -1222,7 +1226,7 @@ static int open_kprobe_events(bool readwrite)
 }
 
 /* Get raw string list of current kprobe_events */
-static struct strlist *get_kprobe_trace_command_rawlist(int fd)
+static struct strlist *get_probe_trace_command_rawlist(int fd)
 {
 	int ret, idx;
 	FILE *fp;
@@ -1290,7 +1294,7 @@ static int show_perf_probe_event(struct perf_probe_event *pev)
 int show_perf_probe_events(void)
 {
 	int fd, ret;
-	struct kprobe_trace_event tev;
+	struct probe_trace_event tev;
 	struct perf_probe_event pev;
 	struct strlist *rawlist;
 	struct str_node *ent;
@@ -1307,20 +1311,20 @@ int show_perf_probe_events(void)
 	if (fd < 0)
 		return fd;
 
-	rawlist = get_kprobe_trace_command_rawlist(fd);
+	rawlist = get_probe_trace_command_rawlist(fd);
 	close(fd);
 	if (!rawlist)
 		return -ENOENT;
 
 	strlist__for_each(ent, rawlist) {
-		ret = parse_kprobe_trace_command(ent->s, &tev);
+		ret = parse_probe_trace_command(ent->s, &tev);
 		if (ret >= 0) {
 			ret = convert_to_perf_probe_event(&tev, &pev);
 			if (ret >= 0)
 				ret = show_perf_probe_event(&pev);
 		}
 		clear_perf_probe_event(&pev);
-		clear_kprobe_trace_event(&tev);
+		clear_probe_trace_event(&tev);
 		if (ret < 0)
 			break;
 	}
@@ -1330,20 +1334,19 @@ int show_perf_probe_events(void)
 }
 
 /* Get current perf-probe event names */
-static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
+static struct strlist *get_probe_trace_event_names(int fd, bool include_group)
 {
 	char buf[128];
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
-	struct kprobe_trace_event tev;
+	struct probe_trace_event tev;
 	int ret = 0;
 
 	memset(&tev, 0, sizeof(tev));
-
-	rawlist = get_kprobe_trace_command_rawlist(fd);
+	rawlist = get_probe_trace_command_rawlist(fd);
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
-		ret = parse_kprobe_trace_command(ent->s, &tev);
+		ret = parse_probe_trace_command(ent->s, &tev);
 		if (ret < 0)
 			break;
 		if (include_group) {
@@ -1353,7 +1356,7 @@ static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
 				ret = strlist__add(sl, buf);
 		} else
 			ret = strlist__add(sl, tev.event);
-		clear_kprobe_trace_event(&tev);
+		clear_probe_trace_event(&tev);
 		if (ret < 0)
 			break;
 	}
@@ -1366,13 +1369,13 @@ static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
 	return sl;
 }
 
-static int write_kprobe_trace_event(int fd, struct kprobe_trace_event *tev)
+static int write_probe_trace_event(int fd, struct probe_trace_event *tev)
 {
 	int ret = 0;
-	char *buf = synthesize_kprobe_trace_command(tev);
+	char *buf = synthesize_probe_trace_command(tev);
 
 	if (!buf) {
-		pr_debug("Failed to synthesize kprobe trace event.\n");
+		pr_debug("Failed to synthesize probe trace event.\n");
 		return -EINVAL;
 	}
 
@@ -1425,12 +1428,12 @@ static int get_new_event_name(char *buf, size_t len, const char *base,
 	return ret;
 }
 
-static int __add_kprobe_trace_events(struct perf_probe_event *pev,
-				     struct kprobe_trace_event *tevs,
+static int __add_probe_trace_events(struct perf_probe_event *pev,
+				     struct probe_trace_event *tevs,
 				     int ntevs, bool allow_suffix)
 {
 	int i, fd, ret;
-	struct kprobe_trace_event *tev = NULL;
+	struct probe_trace_event *tev = NULL;
 	char buf[64];
 	const char *event, *group;
 	struct strlist *namelist;
@@ -1439,7 +1442,7 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 	if (fd < 0)
 		return fd;
 	/* Get current event names */
-	namelist = get_kprobe_trace_event_names(fd, false);
+	namelist = get_probe_trace_event_names(fd, false);
 	if (!namelist) {
 		pr_debug("Failed to get current event list.\n");
 		return -EIO;
@@ -1474,7 +1477,7 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 			ret = -ENOMEM;
 			break;
 		}
-		ret = write_kprobe_trace_event(fd, tev);
+		ret = write_probe_trace_event(fd, tev);
 		if (ret < 0)
 			break;
 		/* Add added event name to namelist */
@@ -1511,21 +1514,21 @@ static int __add_kprobe_trace_events(struct perf_probe_event *pev,
 	return ret;
 }
 
-static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
-					  struct kprobe_trace_event **tevs,
+static int convert_to_probe_trace_events(struct perf_probe_event *pev,
+					  struct probe_trace_event **tevs,
 					  int max_tevs)
 {
 	struct symbol *sym;
 	int ret = 0, i;
-	struct kprobe_trace_event *tev;
+	struct probe_trace_event *tev;
 
 	/* Convert perf_probe_event with debuginfo */
-	ret = try_to_find_kprobe_trace_events(pev, tevs, max_tevs);
+	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs);
 	if (ret != 0)
 		return ret;
 
 	/* Allocate trace event buffer */
-	tev = *tevs = zalloc(sizeof(struct kprobe_trace_event));
+	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
 	if (tev == NULL)
 		return -ENOMEM;
 
@@ -1538,7 +1541,7 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 	tev->point.offset = pev->point.offset;
 	tev->nargs = pev->nargs;
 	if (tev->nargs) {
-		tev->args = zalloc(sizeof(struct kprobe_trace_arg)
+		tev->args = zalloc(sizeof(struct probe_trace_arg)
 				   * tev->nargs);
 		if (tev->args == NULL) {
 			ret = -ENOMEM;
@@ -1579,7 +1582,7 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 
 	return 1;
 error:
-	clear_kprobe_trace_event(tev);
+	clear_probe_trace_event(tev);
 	free(tev);
 	*tevs = NULL;
 	return ret;
@@ -1587,7 +1590,7 @@ error:
 
 struct __event_package {
 	struct perf_probe_event		*pev;
-	struct kprobe_trace_event	*tevs;
+	struct probe_trace_event	*tevs;
 	int				ntevs;
 };
 
@@ -1610,7 +1613,7 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 	for (i = 0; i < npevs; i++) {
 		pkgs[i].pev = &pevs[i];
 		/* Convert with or without debuginfo */
-		ret  = convert_to_kprobe_trace_events(pkgs[i].pev,
+		ret  = convert_to_probe_trace_events(pkgs[i].pev,
 						      &pkgs[i].tevs, max_tevs);
 		if (ret < 0)
 			goto end;
@@ -1619,24 +1622,24 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 
 	/* Loop 2: add all events */
 	for (i = 0; i < npevs && ret >= 0; i++)
-		ret = __add_kprobe_trace_events(pkgs[i].pev, pkgs[i].tevs,
+		ret = __add_probe_trace_events(pkgs[i].pev, pkgs[i].tevs,
 						pkgs[i].ntevs, force_add);
 end:
 	/* Loop 3: cleanup trace events  */
 	for (i = 0; i < npevs; i++)
 		for (j = 0; j < pkgs[i].ntevs; j++)
-			clear_kprobe_trace_event(&pkgs[i].tevs[j]);
+			clear_probe_trace_event(&pkgs[i].tevs[j]);
 
 	return ret;
 }
 
-static int __del_trace_kprobe_event(int fd, struct str_node *ent)
+static int __del_trace_probe_event(int fd, struct str_node *ent)
 {
 	char *p;
 	char buf[128];
 	int ret;
 
-	/* Convert from perf-probe event to trace-kprobe event */
+	/* Convert from perf-probe event to trace-probe event */
 	ret = e_snprintf(buf, 128, "-:%s", ent->s);
 	if (ret < 0)
 		goto error;
@@ -1662,7 +1665,7 @@ error:
 	return ret;
 }
 
-static int del_trace_kprobe_event(int fd, const char *group,
+static int del_trace_probe_event(int fd, const char *group,
 				  const char *event, struct strlist *namelist)
 {
 	char buf[128];
@@ -1679,7 +1682,7 @@ static int del_trace_kprobe_event(int fd, const char *group,
 		strlist__for_each_safe(ent, n, namelist)
 			if (strglobmatch(ent->s, buf)) {
 				found++;
-				ret = __del_trace_kprobe_event(fd, ent);
+				ret = __del_trace_probe_event(fd, ent);
 				if (ret < 0)
 					break;
 				strlist__remove(namelist, ent);
@@ -1688,7 +1691,7 @@ static int del_trace_kprobe_event(int fd, const char *group,
 		ent = strlist__find(namelist, buf);
 		if (ent) {
 			found++;
-			ret = __del_trace_kprobe_event(fd, ent);
+			ret = __del_trace_probe_event(fd, ent);
 			if (ret >= 0)
 				strlist__remove(namelist, ent);
 		}
@@ -1712,7 +1715,7 @@ int del_perf_probe_events(struct strlist *dellist)
 		return fd;
 
 	/* Get current event names */
-	namelist = get_kprobe_trace_event_names(fd, true);
+	namelist = get_probe_trace_event_names(fd, true);
 	if (namelist == NULL)
 		return -EINVAL;
 
@@ -1733,7 +1736,7 @@ int del_perf_probe_events(struct strlist *dellist)
 			event = str;
 		}
 		pr_debug("Group: %s, Event: %s\n", group, event);
-		ret = del_trace_kprobe_event(fd, group, event, namelist);
+		ret = del_trace_probe_event(fd, group, event, namelist);
 		free(str);
 		if (ret < 0)
 			break;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index ed362ac..5af3924 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -7,33 +7,33 @@
 extern bool probe_event_dry_run;
 
 /* kprobe-tracer tracing point */
-struct kprobe_trace_point {
+struct probe_trace_point {
 	char		*symbol;	/* Base symbol */
 	unsigned long	offset;		/* Offset from symbol */
 	bool		retprobe;	/* Return probe flag */
 };
 
-/* kprobe-tracer tracing argument referencing offset */
-struct kprobe_trace_arg_ref {
-	struct kprobe_trace_arg_ref	*next;	/* Next reference */
+/* probe-tracer tracing argument referencing offset */
+struct probe_trace_arg_ref {
+	struct probe_trace_arg_ref	*next;	/* Next reference */
 	long				offset;	/* Offset value */
 };
 
 /* kprobe-tracer tracing argument */
-struct kprobe_trace_arg {
+struct probe_trace_arg {
 	char				*name;	/* Argument name */
 	char				*value;	/* Base value */
 	char				*type;	/* Type name */
-	struct kprobe_trace_arg_ref	*ref;	/* Referencing offset */
+	struct probe_trace_arg_ref	*ref;	/* Referencing offset */
 };
 
 /* kprobe-tracer tracing event (point + arg) */
-struct kprobe_trace_event {
+struct probe_trace_event {
 	char				*event;	/* Event name */
 	char				*group;	/* Group name */
-	struct kprobe_trace_point	point;	/* Trace point */
+	struct probe_trace_point	point;	/* Trace point */
 	int				nargs;	/* Number of args */
-	struct kprobe_trace_arg		*args;	/* Arguments */
+	struct probe_trace_arg		*args;	/* Arguments */
 };
 
 /* Perf probe probing point */
@@ -93,25 +93,18 @@ struct line_range {
 /* Command string to events */
 extern int parse_perf_probe_command(const char *cmd,
 				    struct perf_probe_event *pev);
-extern int parse_kprobe_trace_command(const char *cmd,
-				      struct kprobe_trace_event *tev);
 
 /* Events to command string */
 extern char *synthesize_perf_probe_command(struct perf_probe_event *pev);
-extern char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev);
+extern char *synthesize_probe_trace_command(struct probe_trace_event *tev);
 extern int synthesize_perf_probe_arg(struct perf_probe_arg *pa, char *buf,
 				     size_t len);
 
 /* Check the perf_probe_event needs debuginfo */
 extern bool perf_probe_event_need_dwarf(struct perf_probe_event *pev);
 
-/* Convert from kprobe_trace_event to perf_probe_event */
-extern int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
-				       struct perf_probe_event *pev);
-
 /* Release event contents */
 extern void clear_perf_probe_event(struct perf_probe_event *pev);
-extern void clear_kprobe_trace_event(struct kprobe_trace_event *tev);
 
 /* Command string to line-range */
 extern int parse_line_range_desc(const char *cmd, struct line_range *lr);
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index f88070e..840f1aa 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -366,10 +366,10 @@ static Dwarf_Die *die_find_member(Dwarf_Die *st_die, const char *name,
  * Probe finder related functions
  */
 
-static struct kprobe_trace_arg_ref *alloc_trace_arg_ref(long offs)
+static struct probe_trace_arg_ref *alloc_trace_arg_ref(long offs)
 {
-	struct kprobe_trace_arg_ref *ref;
-	ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+	struct probe_trace_arg_ref *ref;
+	ref = zalloc(sizeof(struct probe_trace_arg_ref));
 	if (ref != NULL)
 		ref->offset = offs;
 	return ref;
@@ -385,7 +385,7 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 	Dwarf_Word offs = 0;
 	bool ref = false;
 	const char *regs;
-	struct kprobe_trace_arg *tvar = pf->tvar;
+	struct probe_trace_arg *tvar = pf->tvar;
 	int ret;
 
 	/* TODO: handle more than 1 exprs */
@@ -459,10 +459,10 @@ static int convert_variable_location(Dwarf_Die *vr_die, struct probe_finder *pf)
 }
 
 static int convert_variable_type(Dwarf_Die *vr_die,
-				 struct kprobe_trace_arg *tvar,
+				 struct probe_trace_arg *tvar,
 				 const char *cast)
 {
-	struct kprobe_trace_arg_ref **ref_ptr = &tvar->ref;
+	struct probe_trace_arg_ref **ref_ptr = &tvar->ref;
 	Dwarf_Die type;
 	char buf[16];
 	int ret;
@@ -500,7 +500,7 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 			while (*ref_ptr)
 				ref_ptr = &(*ref_ptr)->next;
 			/* Add new reference with offset +0 */
-			*ref_ptr = zalloc(sizeof(struct kprobe_trace_arg_ref));
+			*ref_ptr = zalloc(sizeof(struct probe_trace_arg_ref));
 			if (*ref_ptr == NULL) {
 				pr_warning("Out of memory error\n");
 				return -ENOMEM;
@@ -545,10 +545,10 @@ static int convert_variable_type(Dwarf_Die *vr_die,
 
 static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 				    struct perf_probe_arg_field *field,
-				    struct kprobe_trace_arg_ref **ref_ptr,
+				    struct probe_trace_arg_ref **ref_ptr,
 				    Dwarf_Die *die_mem)
 {
-	struct kprobe_trace_arg_ref *ref = *ref_ptr;
+	struct probe_trace_arg_ref *ref = *ref_ptr;
 	Dwarf_Die type;
 	Dwarf_Word offs;
 	int ret, tag;
@@ -574,7 +574,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 		pr_debug2("Array real type: (%x)\n",
 			 (unsigned)dwarf_dieoffset(&type));
 		if (tag == DW_TAG_pointer_type) {
-			ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+			ref = zalloc(sizeof(struct probe_trace_arg_ref));
 			if (ref == NULL)
 				return -ENOMEM;
 			if (*ref_ptr)
@@ -605,7 +605,7 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			return -EINVAL;
 		}
 
-		ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+		ref = zalloc(sizeof(struct probe_trace_arg_ref));
 		if (ref == NULL)
 			return -ENOMEM;
 		if (*ref_ptr)
@@ -738,7 +738,7 @@ static int find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 /* Show a probe point to output buffer */
 static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
-	struct kprobe_trace_event *tev;
+	struct probe_trace_event *tev;
 	Dwarf_Addr eaddr;
 	Dwarf_Die die_mem;
 	const char *name;
@@ -803,7 +803,7 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* Find each argument */
 	tev->nargs = pf->pev->nargs;
-	tev->args = zalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	tev->args = zalloc(sizeof(struct probe_trace_arg) * tev->nargs);
 	if (tev->args == NULL)
 		return -ENOMEM;
 	for (i = 0; i < pf->pev->nargs; i++) {
@@ -1060,9 +1060,9 @@ static int find_probe_point_by_func(struct probe_finder *pf)
 	return _param.retval;
 }
 
-/* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
-int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
-			     struct kprobe_trace_event **tevs, int max_tevs)
+/* Find probe_trace_events specified by perf_probe_event from debuginfo */
+int find_probe_trace_events(int fd, struct perf_probe_event *pev,
+			     struct probe_trace_event **tevs, int max_tevs)
 {
 	struct probe_finder pf = {.pev = pev, .max_tevs = max_tevs};
 	struct perf_probe_point *pp = &pev->point;
@@ -1072,7 +1072,7 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	Dwarf *dbg;
 	int ret = 0;
 
-	pf.tevs = zalloc(sizeof(struct kprobe_trace_event) * max_tevs);
+	pf.tevs = zalloc(sizeof(struct probe_trace_event) * max_tevs);
 	if (pf.tevs == NULL)
 		return -ENOMEM;
 	*tevs = pf.tevs;
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index e1f61dc..4507d51 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -16,9 +16,9 @@ static inline int is_c_varname(const char *name)
 }
 
 #ifdef DWARF_SUPPORT
-/* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
-extern int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
-				    struct kprobe_trace_event **tevs,
+/* Find probe_trace_events specified by perf_probe_event from debuginfo */
+extern int find_probe_trace_events(int fd, struct perf_probe_event *pev,
+				    struct probe_trace_event **tevs,
 				    int max_tevs);
 
 /* Find a perf_probe_point from debuginfo */
@@ -33,7 +33,7 @@ extern int find_line_range(int fd, struct line_range *lr);
 
 struct probe_finder {
 	struct perf_probe_event	*pev;		/* Target probe event */
-	struct kprobe_trace_event *tevs;	/* Result trace events */
+	struct probe_trace_event *tevs;		/* Result trace events */
 	int			ntevs;		/* Number of trace events */
 	int			max_tevs;	/* Max number of trace events */
 
@@ -50,7 +50,7 @@ struct probe_finder {
 #endif
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
 	struct perf_probe_arg	*pvar;		/* Current target variable */
-	struct kprobe_trace_arg	*tvar;		/* Current result variable */
+	struct probe_trace_arg	*tvar;		/* Current result variable */
 };
 
 struct line_finder {
-- 
1.6.2.5

