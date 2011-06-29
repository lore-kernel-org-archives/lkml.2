Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1F2Xed (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 19:34:33 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58062 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753194Ab1F2XeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 19:34:18 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Sam Liao <phyomh@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/6] perf tools: Add inverted call graph report support.
Date: Thu, 30 Jun 2011 01:34:03 +0200
Message-Id: <1309390448-9160-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
References: <1309390448-9160-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Liao <phyomh@gmail.com>

Add "caller/callee" option to support inverted butterfly report,
in the inverted report (with caller option), the call graph start
from the callee's ancestor. Users can use such view to catch system's
performance bottleneck from a sysprof like view. Using this option
with specified sort order like pid gives us high level view of call
graph statistics.

Also add "-G" alias for inverted call graph.

Signed-off-by: Sam Liao <phyomh@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/Documentation/perf-report.txt |   15 ++++++++++--
 tools/perf/builtin-report.c              |   33 ++++++++++++++++++++++++-----
 tools/perf/util/callchain.h              |    6 +++++
 tools/perf/util/hist.c                   |    3 +-
 tools/perf/util/session.c                |    7 +++++-
 5 files changed, 53 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8ba03d6..cfa8e51 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -80,15 +80,24 @@ OPTIONS
 --dump-raw-trace::
         Dump raw trace in ASCII.
 
--g [type,min]::
+-g [type,min,order]::
 --call-graph::
-        Display call chains using type and min percent threshold.
+        Display call chains using type, min percent threshold and order.
 	type can be either:
 	- flat: single column, linear exposure of call chains.
 	- graph: use a graph tree, displaying absolute overhead rates.
 	- fractal: like graph, but displays relative rates. Each branch of
 		 the tree is considered as a new profiled object. +
-	Default: fractal,0.5.
+
+	order can be either:
+	- callee: callee based call graph.
+	- caller: inverted caller based call graph.
+
+	Default: fractal,0.5,callee.
+
+-G::
+--inverted::
+        alias for inverted caller based call graph.
 
 --pretty=<key>::
         Pretty printing style.  key: normal, raw
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 287a173..271e252 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -45,7 +45,8 @@ static struct perf_read_values	show_threads_values;
 static const char	default_pretty_printing_style[] = "normal";
 static const char	*pretty_printing_style = default_pretty_printing_style;
 
-static char		callchain_default_opt[] = "fractal,0.5";
+static char		callchain_default_opt[] = "fractal,0.5,callee";
+static bool		inverted_callchain;
 static symbol_filter_t	annotate_init;
 
 static int perf_session__add_hist_entry(struct perf_session *session,
@@ -386,13 +387,29 @@ parse_callchain_opt(const struct option *opt __used, const char *arg,
 	if (!tok)
 		goto setup;
 
-	tok2 = strtok(NULL, ",");
 	callchain_param.min_percent = strtod(tok, &endptr);
 	if (tok == endptr)
 		return -1;
 
-	if (tok2)
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
 		callchain_param.print_limit = strtod(tok2, &endptr);
+		tok2 = strtok(NULL, ",");
+		if (!tok2)
+			goto setup;
+	}
+
+	/* get the call chain order */
+	if (!strcmp(tok2, "caller"))
+		callchain_param.order = ORDER_CALLER;
+	else if (!strcmp(tok2, "callee"))
+		callchain_param.order = ORDER_CALLEE;
+	else
+		return -1;
 setup:
 	if (callchain_register_param(&callchain_param) < 0) {
 		fprintf(stderr, "Can't register callchain params\n");
@@ -436,9 +453,10 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent",
-		     "Display callchains using output_type (graph, flat, fractal, or none) and min percent threshold. "
-		     "Default: fractal,0.5", &parse_callchain_opt, callchain_default_opt),
+	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent, call_order",
+		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold and callchain order. "
+		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
+	OPT_BOOLEAN('G', "inverted", &inverted_callchain, "alias for inverted call graph"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
 		   "only consider symbols in these dsos"),
 	OPT_STRING('C', "comms", &symbol_conf.comm_list_str, "comm[,comm...]",
@@ -467,6 +485,9 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	else if (use_tui)
 		use_browser = 1;
 
+	if (inverted_callchain)
+		callchain_param.order = ORDER_CALLER;
+
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
 	else
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 1a79df9..9b4ff16 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -14,6 +14,11 @@ enum chain_mode {
 	CHAIN_GRAPH_REL
 };
 
+enum chain_order {
+	ORDER_CALLER,
+	ORDER_CALLEE
+};
+
 struct callchain_node {
 	struct callchain_node	*parent;
 	struct list_head	siblings;
@@ -41,6 +46,7 @@ struct callchain_param {
 	u32			print_limit;
 	double			min_percent;
 	sort_chain_func_t	sort;
+	enum chain_order	order;
 };
 
 struct callchain_list {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 627a02e..dae4202 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -14,7 +14,8 @@ enum hist_filter {
 
 struct callchain_param	callchain_param = {
 	.mode	= CHAIN_GRAPH_REL,
-	.min_percent = 0.5
+	.min_percent = 0.5,
+	.order  = ORDER_CALLEE
 };
 
 u16 hists__col_len(struct hists *self, enum hist_column col)
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index b723f21..558bcf9 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -247,9 +247,14 @@ int perf_session__resolve_callchain(struct perf_session *self,
 	callchain_cursor_reset(&self->callchain_cursor);
 
 	for (i = 0; i < chain->nr; i++) {
-		u64 ip = chain->ips[i];
+		u64 ip;
 		struct addr_location al;
 
+		if (callchain_param.order == ORDER_CALLEE)
+			ip = chain->ips[i];
+		else
+			ip = chain->ips[chain->nr - i - 1];
+
 		if (ip >= PERF_CONTEXT_MAX) {
 			switch (ip) {
 			case PERF_CONTEXT_HV:
-- 
1.7.5.4

