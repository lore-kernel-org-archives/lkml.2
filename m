Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab0DOHal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:30:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:38180 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757439Ab0DOHah (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:30:37 -0400
Date: Thu, 15 Apr 2010 07:30:08 GMT
From: tip-bot for Masami Hiramatsu <mhiramat@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
       hpa@zytor.com, mingo@redhat.com, efault@gmx.de, peterz@infradead.org,
       fweisbec@gmail.com, tglx@linutronix.de, mhiramat@redhat.com,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
       linux-kernel@vger.kernel.org, acme@redhat.com, fweisbec@gmail.com,
       peterz@infradead.org, efault@gmx.de, tglx@linutronix.de,
       mhiramat@redhat.com, mingo@elte.hu
In-Reply-To: <20100412171749.3790.33303.stgit@localhost6.localdomain6>
References: <20100412171749.3790.33303.stgit@localhost6.localdomain6>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Remove xzalloc() from util/probe-{event, finder}.c
Message-ID: <tip-e334016f1d7250a6523b3a44ccecfe23af6e2f57@git.kernel.org>
Git-Commit-ID: e334016f1d7250a6523b3a44ccecfe23af6e2f57
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 15 Apr 2010 07:30:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e334016f1d7250a6523b3a44ccecfe23af6e2f57
Gitweb:     http://git.kernel.org/tip/e334016f1d7250a6523b3a44ccecfe23af6e2f57
Author:     Masami Hiramatsu <mhiramat@redhat.com>
AuthorDate: Mon, 12 Apr 2010 13:17:49 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Apr 2010 17:28:45 -0300

perf probe: Remove xzalloc() from util/probe-{event, finder}.c

Remove all xzalloc() calls from util/probe-{event,finder}.c since
it may cause 'sudden death' in utility functions and it makes
reusing it from other code difficult.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
LKML-Reference: <20100412171749.3790.33303.stgit@localhost6.localdomain6>
Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/probe-event.c  |   69 +++++++++++++++++++++++++++++----------
 tools/perf/util/probe-finder.c |   25 ++++++++++----
 2 files changed, 69 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index bd68f7b..aacbf73 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -556,7 +556,9 @@ static int parse_perf_probe_arg(char *str, struct perf_probe_arg *arg)
 	fieldp = &arg->field;
 
 	do {
-		*fieldp = xzalloc(sizeof(struct perf_probe_arg_field));
+		*fieldp = zalloc(sizeof(struct perf_probe_arg_field));
+		if (*fieldp == NULL)
+			return -ENOMEM;
 		if (*tmp == '.') {
 			str = tmp + 1;
 			(*fieldp)->ref = false;
@@ -608,7 +610,11 @@ int parse_perf_probe_command(const char *cmd, struct perf_probe_event *pev)
 
 	/* Copy arguments and ensure return probe has no C argument */
 	pev->nargs = argc - 1;
-	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
+	pev->args = zalloc(sizeof(struct perf_probe_arg) * pev->nargs);
+	if (pev->args == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	for (i = 0; i < pev->nargs && ret >= 0; i++) {
 		ret = parse_perf_probe_arg(argv[i + 1], &pev->args[i]);
 		if (ret >= 0 &&
@@ -680,7 +686,11 @@ int parse_kprobe_trace_command(const char *cmd, struct kprobe_trace_event *tev)
 		tp->offset = 0;
 
 	tev->nargs = argc - 2;
-	tev->args = xzalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	tev->args = zalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	if (tev->args == NULL) {
+		ret = -ENOMEM;
+		goto out;
+	}
 	for (i = 0; i < tev->nargs; i++) {
 		p = strchr(argv[i + 2], '=');
 		if (p)	/* We don't need which register is assigned. */
@@ -745,7 +755,11 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 	char offs[32] = "", line[32] = "", file[32] = "";
 	int ret, len;
 
-	buf = xzalloc(MAX_CMDLEN);
+	buf = zalloc(MAX_CMDLEN);
+	if (buf == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
 	if (pp->offset) {
 		ret = e_snprintf(offs, 32, "+%lu", pp->offset);
 		if (ret <= 0)
@@ -781,7 +795,8 @@ static char *synthesize_perf_probe_point(struct perf_probe_point *pp)
 error:
 	pr_debug("Failed to synthesize perf probe point: %s",
 		 strerror(-ret));
-	free(buf);
+	if (buf)
+		free(buf);
 	return NULL;
 }
 
@@ -890,7 +905,10 @@ char *synthesize_kprobe_trace_command(struct kprobe_trace_event *tev)
 	char *buf;
 	int i, len, ret;
 
-	buf = xzalloc(MAX_CMDLEN);
+	buf = zalloc(MAX_CMDLEN);
+	if (buf == NULL)
+		return NULL;
+
 	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
 			 tp->retprobe ? 'r' : 'p',
 			 tev->group, tev->event,
@@ -929,7 +947,9 @@ int convert_to_perf_probe_event(struct kprobe_trace_event *tev,
 
 	/* Convert trace_arg to probe_arg */
 	pev->nargs = tev->nargs;
-	pev->args = xzalloc(sizeof(struct perf_probe_arg) * pev->nargs);
+	pev->args = zalloc(sizeof(struct perf_probe_arg) * pev->nargs);
+	if (pev->args == NULL)
+		return -ENOMEM;
 	for (i = 0; i < tev->nargs && ret >= 0; i++)
 		if (tev->args[i].name)
 			pev->args[i].name = xstrdup(tev->args[i].name);
@@ -1326,25 +1346,31 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 					  struct kprobe_trace_event **tevs)
 {
 	struct symbol *sym;
-	int ntevs = 0, i;
+	int ret = 0, i;
 	struct kprobe_trace_event *tev;
 
 	/* Convert perf_probe_event with debuginfo */
-	ntevs = try_to_find_kprobe_trace_events(pev, tevs);
-	if (ntevs != 0)
-		return ntevs;
+	ret = try_to_find_kprobe_trace_events(pev, tevs);
+	if (ret != 0)
+		return ret;
 
 	/* Allocate trace event buffer */
-	ntevs = 1;
-	tev = *tevs = xzalloc(sizeof(struct kprobe_trace_event));
+	tev = *tevs = zalloc(sizeof(struct kprobe_trace_event));
+	if (tev == NULL)
+		return -ENOMEM;
 
 	/* Copy parameters */
 	tev->point.symbol = xstrdup(pev->point.function);
 	tev->point.offset = pev->point.offset;
 	tev->nargs = pev->nargs;
 	if (tev->nargs) {
-		tev->args = xzalloc(sizeof(struct kprobe_trace_arg)
-				    * tev->nargs);
+		tev->args = zalloc(sizeof(struct kprobe_trace_arg)
+				   * tev->nargs);
+		if (tev->args == NULL) {
+			free(tev);
+			*tevs = NULL;
+			return -ENOMEM;
+		}
 		for (i = 0; i < tev->nargs; i++) {
 			if (pev->args[i].name)
 				tev->args[i].name = xstrdup(pev->args[i].name);
@@ -1360,9 +1386,14 @@ static int convert_to_kprobe_trace_events(struct perf_probe_event *pev,
 	if (!sym) {
 		pr_warning("Kernel symbol \'%s\' not found.\n",
 			   tev->point.symbol);
+		clear_kprobe_trace_event(tev);
+		free(tev);
+		*tevs = NULL;
 		return -ENOENT;
-	}
-	return ntevs;
+	} else
+		ret = 1;
+
+	return ret;
 }
 
 struct __event_package {
@@ -1377,7 +1408,9 @@ int add_perf_probe_events(struct perf_probe_event *pevs, int npevs,
 	int i, j, ret;
 	struct __event_package *pkgs;
 
-	pkgs = xzalloc(sizeof(struct __event_package) * npevs);
+	pkgs = zalloc(sizeof(struct __event_package) * npevs);
+	if (pkgs == NULL)
+		return -ENOMEM;
 
 	/* Init vmlinux path */
 	ret = init_vmlinux();
diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index 54daa91..ce1ac82 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -111,7 +111,7 @@ static int strtailcmp(const char *s1, const char *s2)
 /* Line number list operations */
 
 /* Add a line to line number list */
-static void line_list__add_line(struct list_head *head, unsigned int line)
+static int line_list__add_line(struct list_head *head, unsigned int line)
 {
 	struct line_node *ln;
 	struct list_head *p;
@@ -122,16 +122,19 @@ static void line_list__add_line(struct list_head *head, unsigned int line)
 			p = &ln->list;
 			goto found;
 		} else if (ln->line == line)	/* Already exist */
-			return ;
+			return 1;
 	}
 	/* List is empty, or the smallest entry */
 	p = head;
 found:
 	pr_debug("line list: add a line %u\n", line);
-	ln = xzalloc(sizeof(struct line_node));
+	ln = zalloc(sizeof(struct line_node));
+	if (ln == NULL)
+		return -ENOMEM;
 	ln->line = line;
 	INIT_LIST_HEAD(&ln->list);
 	list_add(&ln->list, p);
+	return 0;
 }
 
 /* Check if the line in line number list */
@@ -423,7 +426,9 @@ static int convert_location(Dwarf_Op *op, struct probe_finder *pf)
 
 	tvar->value = xstrdup(regs);
 	if (ref) {
-		tvar->ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
+		tvar->ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+		if (tvar->ref == NULL)
+			return -ENOMEM;
 		tvar->ref->offset = (long)offs;
 	}
 	return 0;
@@ -500,7 +505,9 @@ static int convert_variable_fields(Dwarf_Die *vr_die, const char *varname,
 			return -EINVAL;
 		}
 
-		ref = xzalloc(sizeof(struct kprobe_trace_arg_ref));
+		ref = zalloc(sizeof(struct kprobe_trace_arg_ref));
+		if (ref == NULL)
+			return -ENOMEM;
 		if (*ref_ptr)
 			(*ref_ptr)->next = ref;
 		else
@@ -680,7 +687,9 @@ static int convert_probe_point(Dwarf_Die *sp_die, struct probe_finder *pf)
 
 	/* Find each argument */
 	tev->nargs = pf->pev->nargs;
-	tev->args = xzalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	tev->args = zalloc(sizeof(struct kprobe_trace_arg) * tev->nargs);
+	if (tev->args == NULL)
+		return -ENOMEM;
 	for (i = 0; i < pf->pev->nargs; i++) {
 		pf->pvar = &pf->pev->args[i];
 		pf->tvar = &tev->args[i];
@@ -938,7 +947,9 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
 	Dwarf *dbg;
 	int ret = 0;
 
-	pf.tevs = xzalloc(sizeof(struct kprobe_trace_event) * MAX_PROBES);
+	pf.tevs = zalloc(sizeof(struct kprobe_trace_event) * MAX_PROBES);
+	if (pf.tevs == NULL)
+		return -ENOMEM;
 	*tevs = pf.tevs;
 	pf.ntevs = 0;
 
