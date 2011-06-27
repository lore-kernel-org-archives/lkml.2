Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680Ab1F1MEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 08:04:24 -0400
Received: from mail7.hitachi.co.jp ([133.145.228.42]:54329 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757481Ab1F1L6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:58:16 -0400
X-AuditID: b753bd60-a0aaaba0000019f4-67-4e09c1d59b79
X-AuditID: b753bd60-a0aaaba0000019f4-67-4e09c1d59b79
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH -tip 12/13] perf probe: Add probed module in front of function
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Date: Mon, 27 Jun 2011 16:27:45 +0900
Message-ID: <20110627072745.6528.26416.stgit@fedora15>
In-Reply-To: <20110627072626.6528.41792.stgit@fedora15>
References: <20110627072626.6528.41792.stgit@fedora15>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add probed module name and ":" in front of function name
if -m module option is given. In the result, the symbol
name passed to kprobe-tracer becomes MODULE:FUNCTION,
so that kallsyms can solve it as a symbol in the module
correctly.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---

 tools/perf/util/probe-event.c |   47 +++++++++++++++++++++++++++++++++--------
 tools/perf/util/probe-event.h |    1 +
 2 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 920c195..ee3f41e 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -226,14 +226,26 @@ static int kprobe_convert_to_perf_probe(struct probe_trace_point *tp,
 	return 0;
 }
 
+static int add_module_to_probe_trace_events(struct probe_trace_event *tevs,
+					    int ntevs, const char *module)
+{
+	int i;
+	for (i = 0; i < ntevs; i++) {
+		tevs[i].point.module = strdup(module);
+		if (!tevs[i].point.module)
+			return -ENOMEM;
+	}
+	return 0;
+}
+
 /* Try to find perf_probe_event with debuginfo */
 static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
-					   struct probe_trace_event **tevs,
-					   int max_tevs, const char *module)
+					  struct probe_trace_event **tevs,
+					  int max_tevs, const char *module)
 {
 	bool need_dwarf = perf_probe_event_need_dwarf(pev);
 	struct debuginfo *dinfo = open_debuginfo(module);
-	int ntevs;
+	int ntevs, ret = 0;
 
 	if (!dinfo) {
 		if (need_dwarf) {
@@ -251,7 +263,10 @@ static int try_to_find_probe_trace_events(struct perf_probe_event *pev,
 
 	if (ntevs > 0) {	/* Succeeded to find trace events */
 		pr_debug("find %d probe_trace_events.\n", ntevs);
-		return ntevs;
+		if (module)
+			ret = add_module_to_probe_trace_events(*tevs, ntevs,
+							       module);
+		return ret < 0 ? ret : ntevs;
 	}
 
 	if (ntevs == 0)	{	/* No error but failed to find probe point. */
@@ -1010,7 +1025,7 @@ bool perf_probe_event_need_dwarf(struct perf_probe_event *pev)
 
 /* Parse probe_events event into struct probe_point */
 static int parse_probe_trace_command(const char *cmd,
-					struct probe_trace_event *tev)
+				     struct probe_trace_event *tev)
 {
 	struct probe_trace_point *tp = &tev->point;
 	char pr;
@@ -1043,8 +1058,14 @@ static int parse_probe_trace_command(const char *cmd,
 
 	tp->retprobe = (pr == 'r');
 
-	/* Scan function name and offset */
-	ret = sscanf(argv[1], "%a[^+]+%lu", (float *)(void *)&tp->symbol,
+	/* Scan module name(if there), function name and offset */
+	p = strchr(argv[1], ':');
+	if (p) {
+		tp->module = strndup(argv[1], p - argv[1]);
+		p++;
+	} else
+		p = argv[1];
+	ret = sscanf(p, "%a[^+]+%lu", (float *)(void *)&tp->symbol,
 		     &tp->offset);
 	if (ret == 1)
 		tp->offset = 0;
@@ -1289,9 +1310,10 @@ char *synthesize_probe_trace_command(struct probe_trace_event *tev)
 	if (buf == NULL)
 		return NULL;
 
-	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s+%lu",
+	len = e_snprintf(buf, MAX_CMDLEN, "%c:%s/%s %s%s%s+%lu",
 			 tp->retprobe ? 'r' : 'p',
 			 tev->group, tev->event,
+			 tp->module ?: "", tp->module ? ":" : "",
 			 tp->symbol, tp->offset);
 	if (len <= 0)
 		goto error;
@@ -1398,6 +1420,8 @@ static void clear_probe_trace_event(struct probe_trace_event *tev)
 		free(tev->group);
 	if (tev->point.symbol)
 		free(tev->point.symbol);
+	if (tev->point.module)
+		free(tev->point.module);
 	for (i = 0; i < tev->nargs; i++) {
 		if (tev->args[i].name)
 			free(tev->args[i].name);
@@ -1749,7 +1773,7 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 	/* Convert perf_probe_event with debuginfo */
 	ret = try_to_find_probe_trace_events(pev, tevs, max_tevs, module);
 	if (ret != 0)
-		return ret;
+		return ret;	/* Found in debuginfo or got an error */
 
 	/* Allocate trace event buffer */
 	tev = *tevs = zalloc(sizeof(struct probe_trace_event));
@@ -1762,6 +1786,11 @@ static int convert_to_probe_trace_events(struct perf_probe_event *pev,
 		ret = -ENOMEM;
 		goto error;
 	}
+	tev->point.module = strdup(module);
+	if (tev->point.module == NULL) {
+		ret = -ENOMEM;
+		goto error;
+	}
 	tev->point.offset = pev->point.offset;
 	tev->point.retprobe = pev->point.retprobe;
 	tev->nargs = pev->nargs;
diff --git a/tools/perf/util/probe-event.h b/tools/perf/util/probe-event.h
index 3434fc9..a7dee83 100644
--- a/tools/perf/util/probe-event.h
+++ b/tools/perf/util/probe-event.h
@@ -10,6 +10,7 @@ extern bool probe_event_dry_run;
 /* kprobe-tracer tracing point */
 struct probe_trace_point {
 	char		*symbol;	/* Base symbol */
+	char		*module;	/* Module name */
 	unsigned long	offset;		/* Offset from symbol */
 	bool		retprobe;	/* Return probe flag */
 };

