Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab1GPLXf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 07:23:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:39371 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412Ab1GPLXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 07:23:03 -0400
X-Authority-Analysis: v=1.1 cv=yMxAJ7W7nAoPh8ZdbvCArpG6pAdHwgpzIvOq8QbMesM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=SJL2JUfbD90A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=3nbZYyFuAAAA:8 a=pGLkceISAAAA:8 a=hGzw-44bAAAA:8 a=h3sCQ_blAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=6hMUUjX4KwosnG4RBDEA:9 a=KTIKw5AiXJ6jC_Y-xLgA:7 a=EvKJbDF4Ut8A:10 a=MSl-tDqOz04A:10 a=dowx1zmaLagA:10 a=fNChW5oJl9MA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110716112256.399703833@goodmis.org>
User-Agent: quilt/0.48-1
Date: Sat, 16 Jul 2011 07:22:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 19/20] perf probe: Add probed module in front of function
References: <20110716112200.096203519@goodmis.org>
Content-Disposition: inline; filename=0019-perf-probe-Add-probed-module-in-front-of-function.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Add probed module name and ":" in front of function name
if -m module option is given. In the result, the symbol
name passed to kprobe-tracer becomes MODULE:FUNCTION,
so that kallsyms can solve it as a symbol in the module
correctly.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Link: http://lkml.kernel.org/r/20110627072745.6528.26416.stgit@fedora15
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/perf/util/probe-event.c |   47 +++++++++++++++++++++++++++++++++-------
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
-- 
1.7.5.4


