Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649Ab0CPV6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:58:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752443Ab0CPV6U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:58:20 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 08/10] perf probe: Introduce kprobe_trace_event and
	perf_probe_event
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Mar 2010 18:06:12 -0400
Message-ID: <20100316220612.32050.33806.stgit@localhost6.localdomain6>
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce kprobe_trace_event and perf_probe_event and replace
old probe_point structure with it. probe_point structure is
not enough flexible nor extensible. New data structures
will help implementing further features.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 tools/perf/builtin-probe.c     |   30 +-
 tools/perf/util/probe-event.c  |  626 ++++++++++++++++++++++++++--------------
 tools/perf/util/probe-event.h  |  111 ++++++-
 tools/perf/util/probe-finder.c |  140 ++++-----
 tools/perf/util/probe-finder.h |   58 +---
 5 files changed, 589 insertions(+), 376 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index a1a2891..e0dafd9 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -48,12 +48,11 @@
 
 /* Session management structure */
 static struct {
-	bool need_dwarf;
 	bool list_events;
 	bool force_add;
 	bool show_lines;
-	int nr_probe;
-	struct probe_point probes[MAX_PROBES];
+	int nevents;
+	struct perf_probe_event events[MAX_PROBES];
 	struct strlist *dellist;
 	struct line_range line_range;
 } params;
@@ -62,16 +61,16 @@ static struct {
 /* Parse an event definition. Note that any error must die. */
 static void parse_probe_event(const char *str)
 {
-	struct probe_point *pp = &params.probes[params.nr_probe];
+	struct perf_probe_event *pev = &params.events[params.nevents];
 
-	pr_debug("probe-definition(%d): %s\n", params.nr_probe, str);
-	if (++params.nr_probe == MAX_PROBES)
+	pr_debug("probe-definition(%d): %s\n", params.nevents, str);
+	if (++params.nevents == MAX_PROBES)
 		die("Too many probes (> %d) are specified.", MAX_PROBES);
 
-	/* Parse perf-probe event into probe_point */
-	parse_perf_probe_event(str, pp, &params.need_dwarf);
+	/* Parse a perf-probe command into event */
+	parse_perf_probe_command(str, pev);
 
-	pr_debug("%d arguments\n", pp->nr_args);
+	pr_debug("%d arguments\n", pev->nargs);
 }
 
 static void parse_probe_event_argv(int argc, const char **argv)
@@ -191,7 +190,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		parse_probe_event_argv(argc, argv);
 	}
 
-	if ((!params.nr_probe && !params.dellist && !params.list_events &&
+	if ((!params.nevents && !params.dellist && !params.list_events &&
 	     !params.show_lines))
 		usage_with_options(probe_usage, options);
 
@@ -199,7 +198,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 		die("Failed to find debugfs path.");
 
 	if (params.list_events) {
-		if (params.nr_probe != 0 || params.dellist) {
+		if (params.nevents != 0 || params.dellist) {
 			pr_warning("  Error: Don't use --list with"
 				   " --add/--del.\n");
 			usage_with_options(probe_usage, options);
@@ -214,7 +213,7 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 
 #ifndef NO_DWARF_SUPPORT
 	if (params.show_lines) {
-		if (params.nr_probe != 0 || params.dellist) {
+		if (params.nevents != 0 || params.dellist) {
 			pr_warning("  Error: Don't use --line with"
 				   " --add/--del.\n");
 			usage_with_options(probe_usage, options);
@@ -226,14 +225,13 @@ int cmd_probe(int argc, const char **argv, const char *prefix __used)
 #endif
 
 	if (params.dellist) {
-		del_trace_kprobe_events(params.dellist);
+		del_perf_probe_events(params.dellist);
 		strlist__delete(params.dellist);
-		if (params.nr_probe == 0)
+		if (params.nevents == 0)
 			return 0;
 	}
 
-	add_trace_kprobe_events(params.probes, params.nr_probe,
-				params.force_add, params.need_dwarf);
+	add_perf_probe_events(params.events, params.nevents, params.force_add);
 	return 0;
 }
 
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index ac41578..b44ddfb 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -44,6 +44,7 @@
 #include "thread.h"
 #include "parse-events.h"  /* For debugfs_path */
 #include "probe-event.h"
+#include "probe-finder.h"
 
 #define MAX_CMDLEN 256
 #define MAX_PROBE_ARGS 128
@@ -150,8 +151,9 @@ static bool check_event_name(const char *name)
 }
 
 /* Parse probepoint definition. */
-static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
+static void parse_perf_probe_point(char *arg, struct perf_probe_event *pev)
 {
+	struct perf_probe_point *pp = &pev->point;
 	char *ptr, *tmp;
 	char c, nc = 0;
 	/*
@@ -172,7 +174,8 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		if (!check_event_name(arg))
 			semantic_error("%s is bad for event name -it must "
 				       "follow C symbol-naming rule.", arg);
-		pp->event = xstrdup(arg);
+		pev->event = xstrdup(arg);
+		pev->group = NULL;
 		arg = tmp;
 	}
 
@@ -255,57 +258,65 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		semantic_error("Offset/Line/Lazy pattern can't be used with "
 			       "return probe.");
 
-	pr_debug("symbol:%s file:%s line:%d offset:%d return:%d lazy:%s\n",
+	pr_debug("symbol:%s file:%s line:%d offset:%lu return:%d lazy:%s\n",
 		 pp->function, pp->file, pp->line, pp->offset, pp->retprobe,
 		 pp->lazy_line);
 }
 
-/* Parse perf-probe event definition */
-void parse_perf_probe_event(const char *str, struct probe_point *pp,
-			    bool *need_dwarf)
+/* Parse perf-probe event command */
+void parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
 {
 	char **argv;
 	int argc, i;
 
-	*need_dwarf = false;
-
-	argv = argv_split(str, &argc);
+	argv = argv_split(cmd, &argc);
 	if (!argv)
 		die("argv_split failed.");
 	if (argc > MAX_PROBE_ARGS + 1)
 		semantic_error("Too many arguments");
 
 	/* Parse probe point */
-	parse_perf_probe_probepoint(argv[0], pp);
-	if (pp->file || pp->line || pp->lazy_line)
-		*need_dwarf = true;
+	parse_perf_probe_point(argv[0], pev);
 
 	/* Copy arguments and ensure return probe has no C argument */
-	pp->nr_args = argc - 1;
-	pp->args = xzalloc(sizeof(char *) * pp->nr_args);
-	for (i = 0; i < pp->nr_args; i++) {
-		pp->args[i] = xstrdup(argv[i + 1]);
-		if (is_c_varname(pp->args[i])) {
-			if (pp->retprobe)
-				semantic_error("You can't specify local"
-						" variable for kretprobe");
-			*need_dwarf = true;
-		}
+	pev->nargs = argc - 1;
+	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
+	for (i = 0; i < pev->nargs; i++) {
+		pev->args[i].name = xstrdup(argv[i + 1]);
+		if (is_c_varname(pev->args[i].name) && pev->point.retprobe)
+			semantic_error("You can't specify local variable for"
+				       " kretprobe");
 	}
 
 	argv_free(argv);
 }
 
+/* Return true if this perf_probe_event requires debuginfo */
+bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
+{
+	int i;
+
+	if (pev->point.file || pev->point.line || pev->point.lazy_line)
+		return true;
+
+	for (i = 0; i < pev->nargs; i++)
+		if (is_c_varname(pev->args[i].name))
+			return true;
+
+	return false;
+}
+
 /* Parse kprobe_events event into struct probe_point */
-void parse_trace_kprobe_event(const char *str, struct probe_point *pp)
+void parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 {
+	struct kprobe_trace_point *tp = &tev->point;
 	char pr;
 	char *p;
 	int ret, i, argc;
 	char **argv;
 
-	pr_debug("Parsing kprobe_events: %s\n", str);
-	argv = argv_split(str, &argc);
+	pr_debug("Parsing kprobe_events: %s\n", cmd);
+	argv = argv_split(cmd, &argc);
 	if (!argv)
 		die("argv_split failed.");
 	if (argc < 2)
@@ -313,47 +324,46 @@ void parse_trace_kprobe_event(const char *str, struct probe_point *pp)
 
 	/* Scan event and group name. */
 	ret = sscanf(argv[0], "%c:%a[^/ \t]/%a[^ \t]",
-		     &pr, (float *)(void *)&pp->group,
-		     (float *)(void *)&pp->event);
+		     &pr, (float *)(void *)&tev->group,
+		     (float *)(void *)&tev->event);
 	if (ret != 3)
 		semantic_error("Failed to parse event name: %s", argv[0]);
-	pr_debug("Group:%s Event:%s probe:%c\n", pp->group, pp->event, pr);
+	pr_debug("Group:%s Event:%s probe:%c\n", tev->group, tev->event, pr);
 
-	pp->retprobe = (pr == 'r');
+	tp->retprobe = (pr == 'r');
 
 	/* Scan function name and offset */
-	ret = sscanf(argv[1], "%a[^+]+%d", (float *)(void *)&pp->function,
-		     &pp->offset);
+	ret = sscanf(argv[1], "%a[^+]+%lu", (float *)(void *)&tp->symbol,
+		     &tp->offset);
 	if (ret == 1)
-		pp->offset = 0;
-
-	/* kprobe_events doesn't have this information */
-	pp->line = 0;
-	pp->file = NULL;
+		tp->offset = 0;
 
-	pp->nr_args = argc - 2;
-	pp->args = xzalloc(sizeof(char *) * pp->nr_args);
-	for (i = 0; i < pp->nr_args; i++) {
+	tev->nargs = argc - 2;
+	tev->args = xzalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	for (i = 0; i < tev->nargs; i++) {
 		p = strchr(argv[i + 2], '=');
 		if (p)	/* We don't need which register is assigned. */
-			*p = '\0';
-		pp->args[i] = xstrdup(argv[i + 2]);
+			*p++ = '\0';
+		else
+			p = argv[i + 2];
+		tev->args[i].name = xstrdup(argv[i + 2]);
+		/* TODO: parse regs and offset */
+		tev->args[i].value = xstrdup(p);
 	}
 
 	argv_free(argv);
 }
 
-/* Synthesize only probe point (not argument) */
-int synthesize_perf_probe_point(struct probe_point *pp)
+/* Compose only probe point (not argument) */
+static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 {
 	char *buf;
 	char offs[64] = "", line[64] = "";
 	int ret;
 
-	pp->probes[0] = buf = xzalloc(MAX_CMDLEN);
-	pp->found = 1;
+	buf = xzalloc(MAX_CMDLEN);
 	if (pp->offset) {
-		ret = e_snprintf(offs, 64, "+%d", pp->offset);
+		ret = e_snprintf(offs, 64, "+%lu", pp->offset);
 		if (ret <= 0)
 			goto error;
 	}
@@ -368,68 +378,209 @@ int synthesize_perf_probe_point(struct probe_point *pp)
 				 offs, pp->retprobe ? "%return" : "", line);
 	else
 		ret = e_snprintf(buf, MAX_CMDLEN, "%s%s", pp->file, line);
-	if (ret <= 0) {
+	if (ret <= 0)
+		goto error;
+
+	return buf;
 error:
-		free(pp->probes[0]);
-		pp->probes[0] = NULL;
-		pp->found = 0;
-	}
-	return ret;
+	die("Failed to synthesize perf probe point: %s", strerror(-ret));
 }
 
-int synthesize_perf_probe_event(struct probe_point *pp)
+#if 0
+char *synthesize_perf_probe_command(struct perf_probe_event *pev)
 {
 	char *buf;
 	int i, len, ret;
 
-	len = synthesize_perf_probe_point(pp);
-	if (len < 0)
-		return 0;
+	buf = synthesize_perf_probe_point(&pev->point);
+	if (!buf)
+		return NULL;
 
-	buf = pp->probes[0];
-	for (i = 0; i < pp->nr_args; i++) {
+	len = strlen(buf);
+	for (i = 0; i < pev->nargs; i++) {
 		ret = e_snprintf(&buf[len], MAX_CMDLEN - len, " %s",
-				 pp->args[i]);
-		if (ret <= 0)
-			goto error;
+				 pev->args[i].name);
+		if (ret <= 0) {
+			free(buf);
+			return NULL;
+		}
 		len += ret;
 	}
-	pp->found = 1;
 
-	return pp->found;
-error:
-	free(pp->probes[0]);
-	pp->probes[0] = NULL;
+	return buf;
+}
+#endif
+
+static int __synthesize_kprobe_trace_arg_ref(struct kprobe_trace_arg_ref *ref,
+					     char **buf, size_t *buflen,
+					     int depth)
+{
+	int ret;
+	if (ref->next) {
+		depth = __synthesize_kprobe_trace_arg_ref(ref->next, buf,
+							 buflen, depth + 1);
+		if (depth < 0)
+			goto out;
+	}
+
+	ret = e_snprintf(*buf, *buflen, "%+ld(", ref->offset);
+	if (ret < 0)
+		depth = ret;
+	else {
+		*buf += ret;
+		*buflen -= ret;
+	}
+out:
+	return depth;
 
-	return ret;
 }
 
-int synthesize_trace_kprobe_event(struct probe_point *pp)
+static int synthesize_kprobe_trace_arg(struct kprobe_trace_arg *arg,
+				       char *buf, size_t buflen)
 {
+	int ret, depth = 0;
+	char *tmp = buf;
+
+	/* Argument name or separator */
+	if (arg->name)
+		ret = e_snprintf(buf, buflen, " %s=", arg->name);
+	else
+		ret = e_snprintf(buf, buflen, " ");
+	if (ret < 0)
+		return ret;
+	buf += ret;
+	buflen -= ret;
+
+	/* Dereferencing arguments */
+	if (arg->ref) {
+		depth = __synthesize_kprobe_trace_arg_ref(arg->ref, &buf,
+							  &buflen, 1);
+		if (depth < 0)
+			return depth;
+	}
+
+	/* Print argument value */
+	ret = e_snprintf(buf, buflen, "%s", arg->value);
+	if (ret < 0)
+		return ret;
+	buf += ret;
+	buflen -= ret;
+
+	/* Closing */
+	while (depth--) {
+		ret = e_snprintf(buf, buflen, ")");
+		if (ret < 0)
+			return ret;
+		buf += ret;
+		buflen -= ret;
+	}
+
+	return buf - tmp;
+}
+
+char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev)
+{
+	struct kprobe_trace_point *tp = &tev->point;
 	char *buf;
 	int i, len, ret;
 
-	pp->probes[0] = buf = xzalloc(MAX_CMDLEN);
-	ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
-	if (ret <= 0)
+	buf = xzalloc(MAX_CMDLEN);
+	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
+			 tp->retprobe ? 'r' : 'p',
+			 tev->group, tev->event,
+			 tp->symbol, tp->offset);
+	if (len <= 0)
 		goto error;
-	len = ret;
 
-	for (i = 0; i < pp->nr_args; i++) {
-		ret = e_snprintf(&buf[len], MAX_CMDLEN - len, " %s",
-				 pp->args[i]);
+	for (i = 0; i < tev->nargs; i++) {
+		ret = synthesize_kprobe_trace_arg(&tev->args[i], buf + len,
+						  MAX_CMDLEN - len);
 		if (ret <= 0)
 			goto error;
 		len += ret;
 	}
-	pp->found = 1;
 
-	return pp->found;
+	return buf;
 error:
-	free(pp->probes[0]);
-	pp->probes[0] = NULL;
+	free(buf);
+	return NULL;
+}
 
-	return ret;
+void convert_to_perf_probe_event(struct kprobe_trace_event *tev,
+				 struct perf_probe_event *pev)
+{
+	char buf[64];
+	int i;
+
+	pev->event = xstrdup(tev->event);
+	pev->group = xstrdup(tev->group);
+
+	/* Convert trace_point to probe_point */
+	pev->point.function = xstrdup(tev->point.symbol);
+	pev->point.offset = tev->point.offset;
+	pev->point.retprobe = tev->point.retprobe;
+
+	/* Convert trace_arg to probe_arg */
+	pev->nargs = tev->nargs;
+	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
+	for (i = 0; i < tev->nargs; i++)
+		if (tev->args[i].name)
+			pev->args[i].name = xstrdup(tev->args[i].name);
+		else {
+			synthesize_kprobe_trace_arg(&tev->args[i], buf, 64);
+			pev->args[i].name = xstrdup(buf);
+		}
+}
+
+void clear_perf_probe_event(struct perf_probe_event *pev)
+{
+	struct perf_probe_point *pp = &pev->point;
+	int i;
+
+	if (pev->event)
+		free(pev->event);
+	if (pev->group)
+		free(pev->group);
+	if (pp->file)
+		free(pp->file);
+	if (pp->function)
+		free(pp->function);
+	if (pp->lazy_line)
+		free(pp->lazy_line);
+	for (i = 0; i < pev->nargs; i++)
+		if (pev->args[i].name)
+			free(pev->args[i].name);
+	if (pev->args)
+		free(pev->args);
+	memset(pev, 0, sizeof(*pev));
+}
+
+void clear_kprobe_trace_event(struct kprobe_trace_event *tev)
+{
+	struct kprobe_trace_arg_ref *ref, *next;
+	int i;
+
+	if (tev->event)
+		free(tev->event);
+	if (tev->group)
+		free(tev->group);
+	if (tev->point.symbol)
+		free(tev->point.symbol);
+	for (i = 0; i < tev->nargs; i++) {
+		if (tev->args[i].name)
+			free(tev->args[i].name);
+		if (tev->args[i].value)
+			free(tev->args[i].value);
+		ref = tev->args[i].ref;
+		while (ref) {
+			next = ref->next;
+			free(ref);
+			ref = next;
+		}
+	}
+	if (tev->args)
+		free(tev->args);
+	memset(tev, 0, sizeof(*tev));
 }
 
 static int open_kprobe_events(bool readwrite)
@@ -458,7 +609,7 @@ static int open_kprobe_events(bool readwrite)
 }
 
 /* Get raw string list of current kprobe_events */
-static struct strlist *get_trace_kprobe_event_rawlist(int fd)
+static struct strlist *get_kprobe_trace_command_rawlist(int fd)
 {
 	int ret, idx;
 	FILE *fp;
@@ -486,99 +637,82 @@ static struct strlist *get_trace_kprobe_event_rawlist(int fd)
 	return sl;
 }
 
-/* Free and zero clear probe_point */
-static void clear_probe_point(struct probe_point *pp)
-{
-	int i;
-
-	if (pp->event)
-		free(pp->event);
-	if (pp->group)
-		free(pp->group);
-	if (pp->function)
-		free(pp->function);
-	if (pp->file)
-		free(pp->file);
-	if (pp->lazy_line)
-		free(pp->lazy_line);
-	for (i = 0; i < pp->nr_args; i++)
-		free(pp->args[i]);
-	if (pp->args)
-		free(pp->args);
-	for (i = 0; i < pp->found; i++)
-		free(pp->probes[i]);
-	memset(pp, 0, sizeof(*pp));
-}
-
 /* Show an event */
-static void show_perf_probe_event(const char *event, const char *place,
-				  struct probe_point *pp)
+static void show_perf_probe_event(struct perf_probe_event *pev)
 {
 	int i, ret;
 	char buf[128];
+	char *place;
 
-	ret = e_snprintf(buf, 128, "%s:%s", pp->group, event);
+	/* Synthesize only event probe point */
+	place = synthesize_perf_probe_point(&pev->point);
+
+	ret = e_snprintf(buf, 128, "%s:%s", pev->group, pev->event);
 	if (ret < 0)
 		die("Failed to copy event: %s", strerror(-ret));
 	printf("  %-40s (on %s", buf, place);
 
-	if (pp->nr_args > 0) {
+	if (pev->nargs > 0) {
 		printf(" with");
-		for (i = 0; i < pp->nr_args; i++)
-			printf(" %s", pp->args[i]);
+		for (i = 0; i < pev->nargs; i++)
+			printf(" %s", pev->args[i].name);
 	}
 	printf(")\n");
+	free(place);
 }
 
 /* List up current perf-probe events */
 void show_perf_probe_events(void)
 {
 	int fd;
-	struct probe_point pp;
+	struct kprobe_trace_event tev;
+	struct perf_probe_event pev;
 	struct strlist *rawlist;
 	struct str_node *ent;
 
 	setup_pager();
-	memset(&pp, 0, sizeof(pp));
+
+	memset(&tev, 0, sizeof(tev));
+	memset(&pev, 0, sizeof(pev));
 
 	fd = open_kprobe_events(false);
-	rawlist = get_trace_kprobe_event_rawlist(fd);
+	rawlist = get_kprobe_trace_command_rawlist(fd);
 	close(fd);
 
 	strlist__for_each(ent, rawlist) {
-		parse_trace_kprobe_event(ent->s, &pp);
-		/* Synthesize only event probe point */
-		synthesize_perf_probe_point(&pp);
+		parse_kprobe_trace_command(ent->s, &tev);
+		convert_to_perf_probe_event(&tev, &pev);
 		/* Show an event */
-		show_perf_probe_event(pp.event, pp.probes[0], &pp);
-		clear_probe_point(&pp);
+		show_perf_probe_event(&pev);
+		clear_perf_probe_event(&pev);
+		clear_kprobe_trace_event(&tev);
 	}
 
 	strlist__delete(rawlist);
 }
 
 /* Get current perf-probe event names */
-static struct strlist *get_perf_event_names(int fd, bool include_group)
+static struct strlist *get_kprobe_trace_event_names(int fd, bool include_group)
 {
 	char buf[128];
 	struct strlist *sl, *rawlist;
 	struct str_node *ent;
-	struct probe_point pp;
+	struct kprobe_trace_event tev;
 
-	memset(&pp, 0, sizeof(pp));
-	rawlist = get_trace_kprobe_event_rawlist(fd);
+	memset(&tev, 0, sizeof(tev));
 
+	rawlist = get_kprobe_trace_command_rawlist(fd);
 	sl = strlist__new(true, NULL);
 	strlist__for_each(ent, rawlist) {
-		parse_trace_kprobe_event(ent->s, &pp);
+		parse_kprobe_trace_command(ent->s, &tev);
 		if (include_group) {
-			if (e_snprintf(buf, 128, "%s:%s", pp.group,
-				       pp.event) < 0)
+			if (e_snprintf(buf, 128, "%s:%s", tev.group,
+				       tev.event) < 0)
 				die("Failed to copy group:event name.");
 			strlist__add(sl, buf);
 		} else
-			strlist__add(sl, pp.event);
-		clear_probe_point(&pp);
+			strlist__add(sl, tev.event);
+		clear_kprobe_trace_event(&tev);
 	}
 
 	strlist__delete(rawlist);
@@ -586,9 +720,10 @@ static struct strlist *get_perf_event_names(int fd, bool include_group)
 	return sl;
 }
 
-static void write_trace_kprobe_event(int fd, const char *buf)
+static void write_kprobe_trace_event(int fd, struct kprobe_trace_event *tev)
 {
 	int ret;
+	char *buf = synthesize_kprobe_trace_command(tev);
 
 	pr_debug("Writing event: %s\n", buf);
 	if (!probe_event_dry_run) {
@@ -596,6 +731,7 @@ static void write_trace_kprobe_event(int fd, const char *buf)
 		if (ret <= 0)
 			die("Failed to write event: %s", strerror(errno));
 	}
+	free(buf);
 }
 
 static void get_new_event_name(char *buf, size_t len, const char *base,
@@ -628,81 +764,83 @@ static void get_new_event_name(char *buf, size_t len, const char *base,
 		die("Too many events are on the same function.");
 }
 
-static void __add_trace_kprobe_events(struct probe_point *probes,
-				      int nr_probes, bool force_add)
+static void __add_kprobe_trace_events(struct perf_probe_event *pev,
+				      struct kprobe_trace_event *tevs,
+				      int ntevs, bool allow_suffix)
 {
-	int i, j, fd;
-	struct probe_point *pp;
-	char buf[MAX_CMDLEN];
-	char event[64];
+	int i, fd;
+	struct kprobe_trace_event *tev;
+	char buf[64];
+	const char *event, *group;
 	struct strlist *namelist;
-	bool allow_suffix;
 
 	fd = open_kprobe_events(true);
 	/* Get current event names */
-	namelist = get_perf_event_names(fd, false);
-
-	for (j = 0; j < nr_probes; j++) {
-		pp = probes + j;
-		if (!pp->event)
-			pp->event = xstrdup(pp->function);
-		if (!pp->group)
-			pp->group = xstrdup(PERFPROBE_GROUP);
-		/* If force_add is true, suffix search is allowed */
-		allow_suffix = force_add;
-		for (i = 0; i < pp->found; i++) {
-			/* Get an unused new event name */
-			get_new_event_name(event, 64, pp->event, namelist,
-					   allow_suffix);
-			snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s\n",
-				 pp->retprobe ? 'r' : 'p',
-				 pp->group, event,
-				 pp->probes[i]);
-			write_trace_kprobe_event(fd, buf);
-			printf("Added new event:\n");
-			/* Get the first parameter (probe-point) */
-			sscanf(pp->probes[i], "%s", buf);
-			show_perf_probe_event(event, buf, pp);
-			/* Add added event name to namelist */
-			strlist__add(namelist, event);
-			/*
-			 * Probes after the first probe which comes from same
-			 * user input are always allowed to add suffix, because
-			 * there might be several addresses corresponding to
-			 * one code line.
-			 */
-			allow_suffix = true;
-		}
+	namelist = get_kprobe_trace_event_names(fd, false);
+
+	printf("Add new event%s\n", (ntevs > 1) ? "s:" : ":");
+	for (i = 0; i < ntevs; i++) {
+		tev = &tevs[i];
+		if (pev->event)
+			event = pev->event;
+		else
+			if (pev->point.function)
+				event = pev->point.function;
+			else
+				event = tev->point.symbol;
+		if (pev->group)
+			group = pev->group;
+		else
+			group = PERFPROBE_GROUP;
+
+		/* Get an unused new event name */
+		get_new_event_name(buf, 64, event, namelist, allow_suffix);
+		event = buf;
+
+		tev->event = xstrdup(event);
+		tev->group = xstrdup(group);
+		write_kprobe_trace_event(fd, tev);
+		/* Add added event name to namelist */
+		strlist__add(namelist, event);
+
+		/* Trick here - save current event/group */
+		event = pev->event;
+		group = pev->group;
+		pev->event = tev->event;
+		pev->group = tev->group;
+		show_perf_probe_event(pev);
+		/* Trick here - restore current event/group */
+		pev->event = (char *)event;
+		pev->group = (char *)group;
+
+		/*
+		 * Probes after the first probe which comes from same
+		 * user input are always allowed to add suffix, because
+		 * there might be several addresses corresponding to
+		 * one code line.
+		 */
+		allow_suffix = true;
 	}
 	/* Show how to use the event. */
 	printf("\nYou can now use it on all perf tools, such as:\n\n");
-	printf("\tperf record -e %s:%s -a sleep 1\n\n", PERFPROBE_GROUP, event);
+	printf("\tperf record -e %s:%s -a sleep 1\n\n", tev->group, tev->event);
 
 	strlist__delete(namelist);
 	close(fd);
 }
 
-/* Currently just checking function name from symbol map */
-static void evaluate_probe_point(struct probe_point *pp)
+static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
+					  struct kprobe_trace_event **tevs)
 {
 	struct symbol *sym;
-	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
-				       pp->function, NULL);
-	if (!sym)
-		die("Kernel symbol \'%s\' not found - probe not added.",
-		    pp->function);
-}
-
-void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
-			     bool force_add, bool need_dwarf)
-{
-	int i, ret;
-	struct probe_point *pp;
+	bool need_dwarf;
 #ifndef NO_DWARF_SUPPORT
 	int fd;
 #endif
-	/* Add probes */
-	init_vmlinux();
+	int ntevs = 0, i;
+	struct kprobe_trace_event *tev;
+
+	need_dwarf = perf_probe_event_need_dwarf(pev);
 
 	if (need_dwarf)
 #ifdef NO_DWARF_SUPPORT
@@ -721,57 +859,90 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
 	}
 
 	/* Searching probe points */
-	for (i = 0; i < nr_probes; i++) {
-		pp = &probes[i];
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
-		if (need_dwarf) {
-			if (ret == -ENOENT)
-				pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO=y.\n");
-			die("Could not analyze debuginfo.");
-		}
-		pr_debug("An error occurred in debuginfo analysis."
-			 " Try to use symbols.\n");
-		break;
+	ntevs = find_kprobe_trace_events(fd, pev, tevs);
+
+	if (ntevs > 0)	/* Found */
+		goto found;
+
+	if (ntevs == 0)	/* No error but failed to find probe point. */
+		die("Probe point '%s' not found. - probe not added.",
+		    synthesize_perf_probe_point(&pev->point));
+
+	/* Error path */
+	if (need_dwarf) {
+		if (ntevs == -ENOENT)
+			pr_warning("No dwarf info found in the vmlinux - please rebuild with CONFIG_DEBUG_INFO=y.\n");
+		die("Could not analyze debuginfo.");
 	}
-	close(fd);
+	pr_debug("An error occurred in debuginfo analysis."
+		 " Try to use symbols.\n");
 
 end_dwarf:
 #endif /* !NO_DWARF_SUPPORT */
 
-	/* Synthesize probes without dwarf */
-	for (i = 0; i < nr_probes; i++) {
-		pp = &probes[i];
-		if (pp->found)	/* This probe is already found. */
-			continue;
+	/* Allocate trace event buffer */
+	ntevs = 1;
+	tev = *tevs = xzalloc(sizeof(struct kprobe_trace_event));
+
+	/* Copy parameters */
+	tev->point.symbol = xstrdup(pev->point.function);
+	tev->point.offset = pev->point.offset;
+	tev->nargs = pev->nargs;
+	if (tev->nargs) {
+		tev->args = xzalloc(sizeof(struct kprobe_trace_arg)
+				    * tev->nargs);
+		for (i = 0; i < tev->nargs; i++)
+			tev->args[i].value = xstrdup(pev->args[i].name);
+	}
+
+	/* Currently just checking function name from symbol map */
+	sym = map__find_symbol_by_name(kmaps[MAP__FUNCTION],
+				       tev->point.symbol, NULL);
+	if (!sym)
+		die("Kernel symbol \'%s\' not found - probe not added.",
+		    tev->point.symbol);
+found:
+	close(fd);
+	return ntevs;
+}
+
+struct __event_package {
+	struct perf_probe_event		*pev;
+	struct kprobe_trace_event	*tevs;
+	int				ntevs;
+};
 
-		evaluate_probe_point(pp);
-		ret = synthesize_trace_kprobe_event(pp);
-		if (ret == -E2BIG)
-			die("probe point definition becomes too long.");
-		else if (ret < 0)
-			die("Failed to synthesize a probe point.");
+void add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
+			   bool force_add)
+{
+	int i;
+	struct __event_package *pkgs;
+
+	pkgs = xzalloc(sizeof(struct __event_package) * npevs);
+
+	/* Init vmlinux path */
+	init_vmlinux();
+
+	/* Loop 1: convert all events */
+	for (i = 0; i < npevs; i++) {
+		pkgs[i].pev = &pevs[i];
+		/* Convert with or without debuginfo */
+		pkgs[i].ntevs = convert_to_kprobe_trace_events(pkgs[i].pev,
+							       &pkgs[i].tevs);
 	}
 
-	/* Settng up probe points */
-	__add_trace_kprobe_events(probes, nr_probes, force_add);
+	/* Loop 2: add all events */
+	for (i = 0; i < npevs; i++)
+		__add_kprobe_trace_events(pkgs[i].pev, pkgs[i].tevs,
+					  pkgs[i].ntevs, force_add);
+	/* TODO: cleanup all trace events? */
 }
 
 static void __del_trace_kprobe_event(int fd, struct str_node *ent)
 {
 	char *p;
 	char buf[128];
+	int ret;
 
 	/* Convert from perf-probe event to trace-kprobe event */
 	if (e_snprintf(buf, 128, "-:%s", ent->s) < 0)
@@ -781,7 +952,10 @@ static void __del_trace_kprobe_event(int fd, struct str_node *ent)
 		die("Internal error: %s should have ':' but not.", ent->s);
 	*p = '/';
 
-	write_trace_kprobe_event(fd, buf);
+	pr_debug("Writing event: %s\n", buf);
+	ret = write(fd, buf, strlen(buf));
+	if (ret <= 0)
+		die("Failed to write event: %s", strerror(errno));
 	printf("Remove event: %s\n", ent->s);
 }
 
@@ -814,7 +988,7 @@ static void del_trace_kprobe_event(int fd, const char *group,
 		pr_info("Info: event \"%s\" does not exist, could not remove it.\n", buf);
 }
 
-void del_trace_kprobe_events(struct strlist *dellist)
+void del_perf_probe_events(struct strlist *dellist)
 {
 	int fd;
 	const char *group, *event;
@@ -824,7 +998,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 
 	fd = open_kprobe_events(true);
 	/* Get current event names */
-	namelist = get_perf_event_names(fd, true);
+	namelist = get_kprobe_trace_event_names(fd, true);
 
 	strlist__for_each(ent, dellist) {
 		str = xstrdup(ent->s);
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 703b887..2a2f0a2 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -2,24 +2,113 @@
 #define _PROBE_EVENT_H
 
 #include <stdbool.h>
-#include "probe-finder.h"
 #include "strlist.h"
 
 extern bool probe_event_dry_run;
 
-extern void parse_line_range_desc(const char *arg, struct line_range *lr);
-extern void parse_perf_probe_event(const char *str, struct probe_point *pp,
-				   bool *need_dwarf);
-extern int synthesize_perf_probe_point(struct probe_point *pp);
-extern int synthesize_perf_probe_event(struct probe_point *pp);
-extern void parse_trace_kprobe_event(const char *str, struct probe_point *pp);
-extern int synthesize_trace_kprobe_event(struct probe_point *pp);
-extern void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
-				    bool force_add, bool need_dwarf);
-extern void del_trace_kprobe_events(struct strlist *dellist);
+/* kprobe-tracer tracing point */
+struct kprobe_trace_point {
+	char		*symbol;	/* Base symbol */
+	unsigned long	offset;		/* Offset from symbol */
+	bool		retprobe;	/* Return probe flag */
+};
+
+/* kprobe-tracer tracing argument referencing offset */
+struct kprobe_trace_arg_ref {
+	struct kprobe_trace_arg_ref	*next;	/* Next reference */
+	long				offset;	/* Offset value */
+};
+
+/* kprobe-tracer tracing argument */
+struct kprobe_trace_arg {
+	char				*name;	/* Argument name */
+	char				*value;	/* Base value */
+	struct kprobe_trace_arg_ref	*ref;	/* Referencing offset */
+};
+
+/* kprobe-tracer tracing event (point + arg) */
+struct kprobe_trace_event {
+	char				*event;	/* Event name */
+	char				*group;	/* Group name */
+	struct kprobe_trace_point	point;	/* Trace point */
+	int				nargs;	/* Number of args */
+	struct kprobe_trace_arg		*args;	/* Arguments */
+};
+
+/* Perf probe probing point */
+struct perf_probe_point {
+	char		*file;		/* File path */
+	char		*function;	/* Function name */
+	int		line;		/* Line number */
+	char		*lazy_line;	/* Lazy matching pattern */
+	unsigned long	offset;		/* Offset from function entry */
+	bool		retprobe;	/* Return probe flag */
+};
+
+/* Perf probe probing argument */
+struct perf_probe_arg {
+	char		*name;		/* Argument name */
+};
+
+/* Perf probe probing event (point + arg) */
+struct perf_probe_event {
+	char			*event;	/* Event name */
+	char			*group;	/* Group name */
+	struct perf_probe_point	point;	/* Probe point */
+	int			nargs;	/* Number of arguments */
+	struct perf_probe_arg	*args;	/* Arguments */
+};
+
+
+/* Line number container */
+struct line_node {
+	struct list_head	list;
+	unsigned int		line;
+};
+
+/* Line range */
+struct line_range {
+	char			*file;		/* File name */
+	char			*function;	/* Function name */
+	unsigned int		start;		/* Start line number */
+	unsigned int		end;		/* End line number */
+	int			offset;		/* Start line offset */
+	char			*path;		/* Real path name */
+	struct list_head	line_list;	/* Visible lines */
+};
+
+/* Command string to events */
+extern void parse_perf_probe_command(const char *cmd,
+				     struct perf_probe_event *pev);
+extern void parse_kprobe_trace_command(const char *cmd,
+				       struct kprobe_trace_event *tev);
+
+/* Events to command string */
+extern char *synthesize_perf_probe_command(struct perf_probe_event *pev);
+extern char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev);
+
+/* Check the perf_probe_event needs debuginfo */
+extern bool perf_probe_event_need_dwarf(struct perf_probe_event *pev);
+
+/* Convert from kprobe_trace_event to perf_probe_event */
+extern void convert_to_perf_probe_event(struct kprobe_trace_event *tev,
+					struct perf_probe_event *pev);
+
+/* Release event contents */
+extern void clear_perf_probe_event(struct perf_probe_event *pev);
+extern void clear_kprobe_trace_event(struct kprobe_trace_event *tev);
+
+/* Command string to line-range */
+extern void parse_line_range_desc(const char *cmd, struct line_range *lr);
+
+
+extern void add_perf_probe_events(struct perf_probe_event *pevs, int ntevs,
+				  bool force_add);
+extern void del_perf_probe_events(struct strlist *dellist);
 extern void show_perf_probe_events(void);
 extern void show_line_range(struct line_range *lr);
 
+
 /* Maximum index number of event-name postfix */
 #define MAX_EVENT_INDEX	1024
 
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 3942e14..251b4c4 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -319,19 +319,20 @@ static Dwarf_Die *die_find_variable(Dwarf_Die *sp_die, const char *name,
  */
 
 /* Show a location */
-static void show_location(Dwarf_Op *op, struct probe_finder *pf)
+static void convert_location(Dwarf_Op *op, struct probe_finder *pf)
 {
 	unsigned int regn;
 	Dwarf_Word offs = 0;
-	int deref = 0, ret;
+	bool ref = false;
 	const char *regs;
+	struct kprobe_trace_arg *tvar = pf->tvar;
 
 	/* TODO: support CFA */
 	/* If this is based on frame buffer, set the offset */
 	if (op->atom == DW_OP_fbreg) {
 		if (pf->fb_ops == NULL)
 			die("The attribute of frame base is not supported.\n");
-		deref = 1;
+		ref = true;
 		offs = op->number;
 		op = &pf->fb_ops[0];
 	}
@@ -339,13 +340,13 @@ static void show_location(Dwarf_Op *op, struct probe_finder *pf)
 	if (op->atom >= DW_OP_breg0 && op->atom <= DW_OP_breg31) {
 		regn = op->atom - DW_OP_breg0;
 		offs += op->number;
-		deref = 1;
+		ref = true;
 	} else if (op->atom >= DW_OP_reg0 && op->atom <= DW_OP_reg31) {
 		regn = op->atom - DW_OP_reg0;
 	} else if (op->atom == DW_OP_bregx) {
 		regn = op->number;
 		offs += op->number2;
-		deref = 1;
+		ref = true;
 	} else if (op->atom == DW_OP_regx) {
 		regn = op->number;
 	} else
@@ -355,17 +356,15 @@ static void show_location(Dwarf_Op *op, struct probe_finder *pf)
 	if (!regs)
 		die("%u exceeds max register number.", regn);
 
-	if (deref)
-		ret = snprintf(pf->buf, pf->len, " %s=%+jd(%s)",
-			       pf->var, (intmax_t)offs, regs);
-	else
-		ret = snprintf(pf->buf, pf->len, " %s=%s", pf->var, regs);
-	DIE_IF(ret < 0);
-	DIE_IF(ret >= pf->len);
+	tvar->value = xstrdup(regs);
+	if (ref) {
+		tvar->ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
+		tvar->ref->offset = (long)offs;
+	}
 }
 
 /* Show a variables in kprobe event format */
-static void show_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
+static void convert_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 {
 	Dwarf_Attribute attr;
 	Dwarf_Op *expr;
@@ -379,50 +378,51 @@ static void show_variable(Dwarf_Die *vr_die, struct probe_finder *pf)
 	if (ret <= 0 || nexpr == 0)
 		goto error;
 
-	show_location(expr, pf);
+	convert_location(expr, pf);
 	/* *expr will be cached in libdw. Don't free it. */
 	return ;
 error:
 	/* TODO: Support const_value */
 	die("Failed to find the location of %s at this address.\n"
-	    " Perhaps, it has been optimized out.", pf->var);
+	    " Perhaps, it has been optimized out.", pf->pvar->name);
 }
 
 /* Find a variable in a subprogram die */
 static void find_variable(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
-	int ret;
 	Dwarf_Die vr_die;
 
 	/* TODO: Support struct members and arrays */
-	if (!is_c_varname(pf->var)) {
-		/* Output raw parameters */
-		ret = snprintf(pf->buf, pf->len, " %s", pf->var);
-		DIE_IF(ret < 0);
-		DIE_IF(ret >= pf->len);
-		return ;
+	if (!is_c_varname(pf->pvar->name)) {
+		/* Copy raw parameters */
+		pf->tvar->value = xstrdup(pf->pvar->name);
+	} else {
+		pf->tvar->name = xstrdup(pf->pvar->name);
+		pr_debug("Searching '%s' variable in context.\n",
+			 pf->pvar->name);
+		/* Search child die for local variables and parameters. */
+		if (!die_find_variable(sp_die, pf->pvar->name, &vr_die))
+			die("Failed to find '%s' in this function.",
+			    pf->pvar->name);
+		convert_variable(&vr_die, pf);
 	}
-
-	pr_debug("Searching '%s' variable in context.\n", pf->var);
-	/* Search child die for local variables and parameters. */
-	if (!die_find_variable(sp_die, pf->var, &vr_die))
-		die("Failed to find '%s' in this function.", pf->var);
-
-	show_variable(&vr_die, pf);
 }
 
 /* Show a probe point to output buffer */
-static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
+static void convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 {
-	struct probe_point *pp = pf->pp;
+	struct kprobe_trace_event *tev;
 	Dwarf_Addr eaddr;
 	Dwarf_Die die_mem;
 	const char *name;
-	char tmp[MAX_PROBE_BUFFER];
-	int ret, i, len;
+	int ret, i;
 	Dwarf_Attribute fb_attr;
 	size_t nops;
 
+	if (pf->ntevs == MAX_PROBES)
+		die("Too many( > %d) probe point found.\n", MAX_PROBES);
+	tev = &pf->tevs[pf->ntevs++];
+
 	/* If no real subprogram, find a real one */
 	if (!sp_die || dwarf_tag(sp_die) != DW_TAG_subprogram) {
 		sp_die = die_find_real_subprogram(&pf->cu_die,
@@ -431,31 +431,18 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 			die("Probe point is not found in subprograms.");
 	}
 
-	/* Output name of probe point */
+	/* Copy the name of probe point */
 	name = dwarf_diename(sp_die);
 	if (name) {
 		dwarf_entrypc(sp_die, &eaddr);
-		ret = snprintf(tmp, MAX_PROBE_BUFFER, "%s+%lu", name,
-				(unsigned long)(pf->addr - eaddr));
-		/* Copy the function name if possible */
-		if (!pp->function) {
-			pp->function = xstrdup(name);
-			pp->offset = (size_t)(pf->addr - eaddr);
-		}
-	} else {
+		tev->point.symbol = xstrdup(name);
+		tev->point.offset = (unsigned long)(pf->addr - eaddr);
+	} else
 		/* This function has no name. */
-		ret = snprintf(tmp, MAX_PROBE_BUFFER, "0x%jx",
-			       (uintmax_t)pf->addr);
-		if (!pp->function) {
-			/* TODO: Use _stext */
-			pp->function = xstrdup("");
-			pp->offset = (size_t)pf->addr;
-		}
-	}
-	DIE_IF(ret < 0);
-	DIE_IF(ret >= MAX_PROBE_BUFFER);
-	len = ret;
-	pr_debug("Probe point found: %s\n", tmp);
+		tev->point.offset = (unsigned long)pf->addr;
+
+	pr_debug("Probe point found: %s+%lu\n", tev->point.symbol,
+		 tev->point.offset);
 
 	/* Get the frame base attribute/ops */
 	dwarf_attr(sp_die, DW_AT_frame_base, &fb_attr);
@@ -465,22 +452,16 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* Find each argument */
 	/* TODO: use dwarf_cfi_addrframe */
-	for (i = 0; i < pp->nr_args; i++) {
-		pf->var = pp->args[i];
-		pf->buf = &tmp[len];
-		pf->len = MAX_PROBE_BUFFER - len;
+	tev->nargs = pf->pev->nargs;
+	tev->args = xzalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	for (i = 0; i < pf->pev->nargs; i++) {
+		pf->pvar = &pf->pev->args[i];
+		pf->tvar = &tev->args[i];
 		find_variable(sp_die, pf);
-		len += strlen(pf->buf);
 	}
 
 	/* *pf->fb_ops will be cached in libdw. Don't free it. */
 	pf->fb_ops = NULL;
-
-	if (pp->found == MAX_PROBES)
-		die("Too many( > %d) probe point found.\n", MAX_PROBES);
-
-	pp->probes[pp->found] = xstrdup(tmp);
-	pp->found++;
 }
 
 /* Find probe point from its line number */
@@ -512,7 +493,7 @@ static void find_probe_point_by_line(struct probe_finder *pf)
 			 (int)i, lineno, (uintmax_t)addr);
 		pf->addr = addr;
 
-		show_probe_point(NULL, pf);
+		convert_probe_point(NULL, pf);
 		/* Continuing, because target line might be inlined. */
 	}
 }
@@ -563,7 +544,7 @@ static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 	if (list_empty(&pf->lcache)) {
 		/* Matching lazy line pattern */
 		ret = find_lazy_match_lines(&pf->lcache, pf->fname,
-					    pf->pp->lazy_line);
+					    pf->pev->point.lazy_line);
 		if (ret <= 0)
 			die("No matched lines found in %s.", pf->fname);
 	}
@@ -596,7 +577,7 @@ static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 			 (int)i, lineno, (unsigned long long)addr);
 		pf->addr = addr;
 
-		show_probe_point(sp_die, pf);
+		convert_probe_point(sp_die, pf);
 		/* Continuing, because target line might be inlined. */
 	}
 	/* TODO: deallocate lines, but how? */
@@ -605,7 +586,7 @@ static void find_probe_point_lazy(Dwarf_Die *sp_die, struct probe_finder *pf)
 static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 {
 	struct probe_finder *pf = (struct probe_finder *)data;
-	struct probe_point *pp = pf->pp;
+	struct perf_probe_point *pp = &pf->pev->point;
 
 	if (pp->lazy_line)
 		find_probe_point_lazy(in_die, pf);
@@ -616,7 +597,7 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 		pr_debug("found inline addr: 0x%jx\n",
 			 (uintmax_t)pf->addr);
 
-		show_probe_point(in_die, pf);
+		convert_probe_point(in_die, pf);
 	}
 
 	return DWARF_CB_OK;
@@ -626,7 +607,7 @@ static int probe_point_inline_cb(Dwarf_Die *in_die, void *data)
 static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 {
 	struct probe_finder *pf = (struct probe_finder *)data;
-	struct probe_point *pp = pf->pp;
+	struct perf_probe_point *pp = &pf->pev->point;
 
 	/* Check tag and diename */
 	if (dwarf_tag(sp_die) != DW_TAG_subprogram ||
@@ -646,7 +627,7 @@ static int probe_point_search_cb(Dwarf_Die *sp_die, void *data)
 			pf->addr = die_get_entrypc(sp_die);
 			pf->addr += pp->offset;
 			/* TODO: Check the address in this function */
-			show_probe_point(sp_die, pf);
+			convert_probe_point(sp_die, pf);
 		}
 	} else
 		/* Inlined function: search instances */
@@ -660,20 +641,25 @@ static void find_probe_point_by_func(struct probe_finder *pf)
 	dwarf_getfuncs(&pf->cu_die, probe_point_search_cb, pf, 0);
 }
 
-/* Find a probe point */
-int find_probe_point(int fd, struct probe_point *pp)
+/* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
+int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
+			     struct kprobe_trace_event **tevs)
 {
-	struct probe_finder pf = {.pp = pp};
+	struct probe_finder pf = {.pev = pev};
+	struct perf_probe_point *pp = &pev->point;
 	Dwarf_Off off, noff;
 	size_t cuhl;
 	Dwarf_Die *diep;
 	Dwarf *dbg;
 
+	pf.tevs = xzalloc(sizeof(struct kprobe_trace_event) * MAX_PROBES);
+	*tevs = pf.tevs;
+	pf.ntevs = 0;
+
 	dbg = dwarf_begin(fd, DWARF_C_READ);
 	if (!dbg)
 		return -ENOENT;
 
-	pp->found = 0;
 	off = 0;
 	line_list__init(&pf.lcache);
 	/* Loop on CUs (Compilation Unit) */
@@ -704,7 +690,7 @@ int find_probe_point(int fd, struct probe_point *pp)
 	line_list__free(&pf.lcache);
 	dwarf_end(dbg);
 
-	return pp->found;
+	return pf.ntevs;
 }
 
 /* Find line range from its line number */
diff --git a/tools/perf/util/probe-finder.h b/tools/perf/util/probe-finder.h
index 21f7354..4949526 100644
--- a/tools/perf/util/probe-finder.h
+++ b/tools/perf/util/probe-finder.h
@@ -3,6 +3,7 @@
 
 #include <stdbool.h>
 #include "util.h"
+#include "probe-event.h"
 
 #define MAX_PATH_LEN		 256
 #define MAX_PROBE_BUFFER	1024
@@ -14,67 +15,32 @@ static inline int is_c_varname(const char *name)
 	return isalpha(name[0]) || name[0] == '_';
 }
 
-struct probe_point {
-	char			*event;			/* Event name */
-	char			*group;			/* Event group */
-
-	/* Inputs */
-	char			*file;			/* File name */
-	int			line;			/* Line number */
-	char			*lazy_line;		/* Lazy line pattern */
-
-	char			*function;		/* Function name */
-	int			offset;			/* Offset bytes */
-
-	int			nr_args;		/* Number of arguments */
-	char			**args;			/* Arguments */
-
-	int			retprobe;		/* Return probe */
-
-	/* Output */
-	int			found;			/* Number of found probe points */
-	char			*probes[MAX_PROBES];	/* Output buffers (will be allocated)*/
-};
-
-/* Line number container */
-struct line_node {
-	struct list_head	list;
-	unsigned int		line;
-};
-
-/* Line range */
-struct line_range {
-	char			*file;			/* File name */
-	char			*function;		/* Function name */
-	unsigned int		start;			/* Start line number */
-	unsigned int		end;			/* End line number */
-	int			offset;			/* Start line offset */
-	char			*path;			/* Real path name */
-	struct list_head	line_list;		/* Visible lines */
-};
-
 #ifndef NO_DWARF_SUPPORT
-extern int find_probe_point(int fd, struct probe_point *pp);
+/* Find kprobe_trace_events specified by perf_probe_event from debuginfo */
+extern int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
+				    struct kprobe_trace_event **tevs);
+
 extern int find_line_range(int fd, struct line_range *lr);
 
 #include <dwarf.h>
 #include <libdw.h>
 
 struct probe_finder {
-	struct probe_point	*pp;		/* Target probe point */
+	struct perf_probe_event	*pev;		/* Target probe event */
+	int			ntevs;		/* number of trace events */
+	struct kprobe_trace_event *tevs;	/* Result trace events */
 
 	/* For function searching */
 	Dwarf_Addr		addr;		/* Address */
-	const char		*fname;		/* File name */
+	const char		*fname;		/* Real file name */
 	int			lno;		/* Line number */
 	Dwarf_Die		cu_die;		/* Current CU */
+	struct list_head	lcache;		/* Line cache for lazy match */
 
 	/* For variable searching */
 	Dwarf_Op		*fb_ops;	/* Frame base attribute */
-	const char		*var;		/* Current variable name */
-	char			*buf;		/* Current output buffer */
-	int			len;		/* Length of output buffer */
-	struct list_head	lcache;		/* Line cache for lazy match */
+	struct perf_probe_arg	*pvar;		/* Current target variable */
+	struct kprobe_trace_arg	*tvar;		/* Current result variable */
 };
 
 struct line_finder {


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
