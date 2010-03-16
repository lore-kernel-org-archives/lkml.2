Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751867Ab0CPV52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 17:57:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42891 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751527Ab0CPV5Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 17:57:25 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH -tip 02/10] perf probe: Use wrapper functions
To: Ingo Molnar <mingo@elte.hu>, lkml <linux-kernel@vger.kernel.org>
Cc: systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Masami Hiramatsu <mhiramat@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 16 Mar 2010 18:05:30 -0400
Message-ID: <20100316220530.32050.53951.stgit@localhost6.localdomain6>
In-Reply-To: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
References: <20100316220515.32050.82185.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use wrapperf functions as much as possible, to check out of memory
in perf probe.

Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
---

 tools/perf/builtin-probe.c     |    4 +--
 tools/perf/util/probe-event.c  |   46 +++++++++++++++-------------------------
 tools/perf/util/probe-finder.c |   14 +++++-------
 3 files changed, 24 insertions(+), 40 deletions(-)

diff --git a/tools/perf/builtin-probe.c b/tools/perf/builtin-probe.c
index 152d6c9..b6afe7b 100644
--- a/tools/perf/builtin-probe.c
+++ b/tools/perf/builtin-probe.c
@@ -87,9 +87,7 @@ static void parse_probe_event_argv(int argc, const char **argv)
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += strlen(argv[i]) + 1;
-	buf = zalloc(len + 1);
-	if (!buf)
-		die("Failed to allocate memory for binding arguments.");
+	buf = xzalloc(len + 1);
 	len = 0;
 	for (i = 0; i < argc; i++)
 		len += sprintf(&buf[len], "%s ", argv[i]);
diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 7c004b6..88a3b6d 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -33,6 +33,7 @@
 #include <limits.h>
 
 #undef _GNU_SOURCE
+#include "util.h"
 #include "event.h"
 #include "string.h"
 #include "strlist.h"
@@ -90,9 +91,9 @@ void parse_line_range_desc(const char *arg, struct line_range *lr)
 		if (*tmp != '\0')
 			semantic_error("Tailing with invalid character '%d'.",
 				       *tmp);
-		tmp = strndup(arg, (ptr - arg));
+		tmp = xstrndup(arg, (ptr - arg));
 	} else
-		tmp = strdup(arg);
+		tmp = xstrdup(arg);
 
 	if (strchr(tmp, '.'))
 		lr->file = tmp;
@@ -135,7 +136,7 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		if (!check_event_name(arg))
 			semantic_error("%s is bad for event name -it must "
 				       "follow C symbol-naming rule.", arg);
-		pp->event = strdup(arg);
+		pp->event = xstrdup(arg);
 		arg = tmp;
 	}
 
@@ -147,17 +148,16 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 
 	/* Check arg is function or file and copy it */
 	if (strchr(arg, '.'))	/* File */
-		pp->file = strdup(arg);
+		pp->file = xstrdup(arg);
 	else			/* Function */
-		pp->function = strdup(arg);
-	DIE_IF(pp->file == NULL && pp->function == NULL);
+		pp->function = xstrdup(arg);
 
 	/* Parse other options */
 	while (ptr) {
 		arg = ptr;
 		c = nc;
 		if (c == ';') {	/* Lazy pattern must be the last part */
-			pp->lazy_line = strdup(arg);
+			pp->lazy_line = xstrdup(arg);
 			break;
 		}
 		ptr = strpbrk(arg, ";:+@%");
@@ -181,8 +181,7 @@ static void parse_perf_probe_probepoint(char *arg, struct probe_point *pp)
 		case '@':	/* File name */
 			if (pp->file)
 				semantic_error("SRC@SRC is not allowed.");
-			pp->file = strdup(arg);
-			DIE_IF(pp->file == NULL);
+			pp->file = xstrdup(arg);
 			break;
 		case '%':	/* Probe places */
 			if (strcmp(arg, "return") == 0) {
@@ -247,11 +246,9 @@ void parse_perf_probe_event(const char *str, struct probe_point *pp,
 
 	/* Copy arguments and ensure return probe has no C argument */
 	pp->nr_args = argc - 1;
-	pp->args = zalloc(sizeof(char *) * pp->nr_args);
+	pp->args = xzalloc(sizeof(char *) * pp->nr_args);
 	for (i = 0; i < pp->nr_args; i++) {
-		pp->args[i] = strdup(argv[i + 1]);
-		if (!pp->args[i])
-			die("Failed to copy argument.");
+		pp->args[i] = xstrdup(argv[i + 1]);
 		if (is_c_varname(pp->args[i])) {
 			if (pp->retprobe)
 				semantic_error("You can't specify local"
@@ -299,14 +296,12 @@ void parse_trace_kprobe_event(const char *str, struct probe_point *pp)
 	pp->file = NULL;
 
 	pp->nr_args = argc - 2;
-	pp->args = zalloc(sizeof(char *) * pp->nr_args);
+	pp->args = xzalloc(sizeof(char *) * pp->nr_args);
 	for (i = 0; i < pp->nr_args; i++) {
 		p = strchr(argv[i + 2], '=');
 		if (p)	/* We don't need which register is assigned. */
 			*p = '\0';
-		pp->args[i] = strdup(argv[i + 2]);
-		if (!pp->args[i])
-			die("Failed to copy argument.");
+		pp->args[i] = xstrdup(argv[i + 2]);
 	}
 
 	argv_free(argv);
@@ -319,10 +314,8 @@ int synthesize_perf_probe_point(struct probe_point *pp)
 	char offs[64] = "", line[64] = "";
 	int ret;
 
-	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
+	pp->probes[0] = buf = xzalloc(MAX_CMDLEN);
 	pp->found = 1;
-	if (!buf)
-		die("Failed to allocate memory by zalloc.");
 	if (pp->offset) {
 		ret = e_snprintf(offs, 64, "+%d", pp->offset);
 		if (ret <= 0)
@@ -380,9 +373,7 @@ int synthesize_trace_kprobe_event(struct probe_point *pp)
 	char *buf;
 	int i, len, ret;
 
-	pp->probes[0] = buf = zalloc(MAX_CMDLEN);
-	if (!buf)
-		die("Failed to allocate memory by zalloc.");
+	pp->probes[0] = buf = xzalloc(MAX_CMDLEN);
 	ret = e_snprintf(buf, MAX_CMDLEN, "%s+%d", pp->function, pp->offset);
 	if (ret <= 0)
 		goto error;
@@ -612,10 +603,9 @@ void add_trace_kprobe_events(struct probe_point *probes, int nr_probes,
 	for (j = 0; j < nr_probes; j++) {
 		pp = probes + j;
 		if (!pp->event)
-			pp->event = strdup(pp->function);
+			pp->event = xstrdup(pp->function);
 		if (!pp->group)
-			pp->group = strdup(PERFPROBE_GROUP);
-		DIE_IF(!pp->event || !pp->group);
+			pp->group = xstrdup(PERFPROBE_GROUP);
 		/* If force_add is true, suffix search is allowed */
 		allow_suffix = force_add;
 		for (i = 0; i < pp->found; i++) {
@@ -709,9 +699,7 @@ void del_trace_kprobe_events(struct strlist *dellist)
 	namelist = get_perf_event_names(fd, true);
 
 	strlist__for_each(ent, dellist) {
-		str = strdup(ent->s);
-		if (!str)
-			die("Failed to copy event.");
+		str = xstrdup(ent->s);
 		pr_debug("Parsing: %s\n", str);
 		p = strchr(str, ':');
 		if (p) {
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index c171a24..e887bb6 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -125,8 +125,7 @@ static void line_list__add_line(struct list_head *head, unsigned int line)
 	p = head;
 found:
 	pr_debug("line list: add a line %u\n", line);
-	ln = zalloc(sizeof(struct line_node));
-	DIE_IF(ln == NULL);
+	ln = xzalloc(sizeof(struct line_node));
 	ln->line = line;
 	INIT_LIST_HEAD(&ln->list);
 	list_add(&ln->list, p);
@@ -416,7 +415,7 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 				(unsigned long)(pf->addr - eaddr));
 		/* Copy the function name if possible */
 		if (!pp->function) {
-			pp->function = strdup(name);
+			pp->function = xstrdup(name);
 			pp->offset = (size_t)(pf->addr - eaddr);
 		}
 	} else {
@@ -425,7 +424,7 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 			       (uintmax_t)pf->addr);
 		if (!pp->function) {
 			/* TODO: Use _stext */
-			pp->function = strdup("");
+			pp->function = xstrdup("");
 			pp->offset = (size_t)pf->addr;
 		}
 	}
@@ -456,7 +455,7 @@ static void show_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 	if (pp->found == MAX_PROBES)
 		die("Too many( > %d) probe point found.\n", MAX_PROBES);
 
-	pp->probes[pp->found] = strdup(tmp);
+	pp->probes[pp->found] = xstrdup(tmp);
 	pp->found++;
 }
 
@@ -506,8 +505,7 @@ static int find_lazy_match_lines(struct list_head *head,
 	if (fd < 0)
 		die("failed to open %s", fname);
 	DIE_IF(fstat(fd, &st) < 0);
-	fbuf = malloc(st.st_size + 2);
-	DIE_IF(fbuf == NULL);
+	fbuf = xmalloc(st.st_size + 2);
 	DIE_IF(read(fd, fbuf, st.st_size) < 0);
 	close(fd);
 	fbuf[st.st_size] = '\n';	/* Dummy line */
@@ -727,7 +725,7 @@ static void find_line_range_by_line(Dwarf_Die *sp_die, struct line_finder *lf)
 
 		/* Copy real path */
 		if (!lf->lr->path)
-			lf->lr->path = strdup(src);
+			lf->lr->path = xstrdup(src);
 		line_list__add_line(&lf->lr->line_list, (unsigned int)lineno);
 	}
 	/* Update status */


-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
