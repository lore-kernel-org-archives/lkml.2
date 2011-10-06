Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758864Ab1JFRYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 13:24:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50169 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758754Ab1JFRWw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 13:22:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/15] perf top: Add callgraph support
Date: Thu,  6 Oct 2011 14:22:30 -0300
Message-Id: <1317921758-4154-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1317921758-4154-1-git-send-email-acme@infradead.org>
References: <1317921758-4154-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like in 'perf report', but live.

Still needs to decay the callchains, but already somewhat useful as-is.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-cj3rmaf5jpsvi3v0tf7t4uvp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt |   15 ++++
 tools/perf/builtin-top.c              |  146 ++++++++++++++++++++++++++++++++-
 2 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index d146ba3..e2e5cd0 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -126,6 +126,21 @@ Default is to monitor all CPUS.
 --symbols::
 	Only consider these symbols.
 
+-G [type,min,order]::
+--call-graph::
+        Display call chains using type, min percent threshold and order.
+	type can be either:
+	- flat: single column, linear exposure of call chains.
+	- graph: use a graph tree, displaying absolute overhead rates.
+	- fractal: like graph, but displays relative rates. Each branch of
+		 the tree is considered as a new profiled object.
+
+	order can be either:
+	- callee: callee based call graph.
+	- caller: inverted caller based call graph.
+
+	Default: fractal,0.5,callee.
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2cf5e50..b9b7fe0 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -76,6 +76,12 @@ static bool			system_wide			=  false;
 
 static bool			use_tui, use_stdio;
 
+static bool			sort_has_symbols;
+
+static bool			dont_use_callchains;
+static char			callchain_default_opt[]		= "fractal,0.5,callee";
+
+
 static int			default_interval		=      0;
 
 static bool			kptr_restrict_warned;
@@ -648,9 +654,11 @@ static void perf_event__process_sample(const union perf_event *event,
 				       struct perf_sample *sample,
 				       struct perf_session *session)
 {
+	struct symbol *parent = NULL;
 	u64 ip = event->ip.ip;
 	struct addr_location al;
 	struct machine *machine;
+	int err;
 	u8 origin = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
 	++top.samples;
@@ -748,13 +756,29 @@ static void perf_event__process_sample(const union perf_event *event,
 		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
 		assert(evsel != NULL);
 
+		if ((sort__has_parent || symbol_conf.use_callchain) &&
+		    sample->callchain) {
+			err = perf_session__resolve_callchain(session, al.thread,
+							      sample->callchain, &parent);
+			if (err)
+				return;
+		}
+
 		he = perf_session__add_hist_entry(session, &al, sample, evsel);
 		if (he == NULL) {
 			pr_err("Problem incrementing symbol period, skipping event\n");
 			return;
 		}
 
-		record_precise_ip(he, evsel->idx, ip);
+		if (symbol_conf.use_callchain) {
+			err = callchain_append(he->callchain, &session->callchain_cursor,
+					       sample->period);
+			if (err)
+				return;
+		}
+
+		if (sort_has_symbols)
+			record_precise_ip(he, evsel->idx, ip);
 	}
 
 	return;
@@ -808,6 +832,9 @@ static void start_counters(struct perf_evlist *evlist)
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
+		if (symbol_conf.use_callchain)
+			attr->sample_type |= PERF_SAMPLE_CALLCHAIN;
+
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = inherit;
@@ -864,10 +891,27 @@ out_err:
 	exit(0);
 }
 
+static int setup_sample_type(void)
+{
+	if (!sort_has_symbols) {
+		if (symbol_conf.use_callchain) {
+			ui__warning("Selected -g but \"sym\" not present in --sort/-s.");
+			return -EINVAL;
+		}
+	} else if (!dont_use_callchains && callchain_param.mode != CHAIN_NONE) {
+		if (callchain_register_param(&callchain_param) < 0) {
+			ui__warning("Can't register callchain params.\n");
+			return -EINVAL;
+		}
+	}
+
+	return 0;
+}
+
 static int __cmd_top(void)
 {
 	pthread_t thread;
-	int ret __used;
+	int ret;
 	/*
 	 * FIXME: perf_session__new should allow passing a O_MMAP, so that all this
 	 * mmap reading, etc is encapsulated in it. Use O_WRONLY for now.
@@ -876,6 +920,10 @@ static int __cmd_top(void)
 	if (top.session == NULL)
 		return -ENOMEM;
 
+	ret = setup_sample_type();
+	if (ret)
+		goto out_delete;
+
 	if (top.target_tid != -1)
 		perf_event__synthesize_thread_map(top.evlist->threads,
 						  perf_event__process, top.session);
@@ -916,6 +964,90 @@ static int __cmd_top(void)
 			ret = poll(top.evlist->pollfd, top.evlist->nr_fds, 100);
 	}
 
+out_delete:
+	perf_session__delete(top.session);
+	top.session = NULL;
+
+	return 0;
+}
+
+static int
+parse_callchain_opt(const struct option *opt __used, const char *arg,
+		    int unset)
+{
+	char *tok, *tok2;
+	char *endptr;
+
+	/*
+	 * --no-call-graph
+	 */
+	if (unset) {
+		dont_use_callchains = true;
+		return 0;
+	}
+
+	symbol_conf.use_callchain = true;
+
+	if (!arg)
+		return 0;
+
+	tok = strtok((char *)arg, ",");
+	if (!tok)
+		return -1;
+
+	/* get the output mode */
+	if (!strncmp(tok, "graph", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_ABS;
+
+	else if (!strncmp(tok, "flat", strlen(arg)))
+		callchain_param.mode = CHAIN_FLAT;
+
+	else if (!strncmp(tok, "fractal", strlen(arg)))
+		callchain_param.mode = CHAIN_GRAPH_REL;
+
+	else if (!strncmp(tok, "none", strlen(arg))) {
+		callchain_param.mode = CHAIN_NONE;
+		symbol_conf.use_callchain = false;
+
+		return 0;
+	}
+
+	else
+		return -1;
+
+	/* get the min percentage */
+	tok = strtok(NULL, ",");
+	if (!tok)
+		goto setup;
+
+	callchain_param.min_percent = strtod(tok, &endptr);
+	if (tok == endptr)
+		return -1;
+
+	/* get the print limit */
+	tok2 = strtok(NULL, ",");
+	if (!tok2)
+		goto setup;
+
+	if (tok2[0] != 'c') {
+		callchain_param.print_limit = strtod(tok2, &endptr);
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
+setup:
+	if (callchain_register_param(&callchain_param) < 0) {
+		fprintf(stderr, "Can't register callchain params\n");
+		return -1;
+	}
 	return 0;
 }
 
@@ -973,6 +1105,10 @@ static const struct option options[] = {
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
+	OPT_CALLBACK_DEFAULT('G', "call-graph", NULL, "output_type,min_percent, call_order",
+		     "Display callchains using output_type (graph, flat, fractal, or none), min percent threshold and callchain order. "
+		     "Default: fractal,0.5,callee", &parse_callchain_opt,
+		     callchain_default_opt),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
 	OPT_STRING(0, "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
@@ -1082,6 +1218,12 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 
+	/*
+	 * Avoid annotation data structures overhead when symbols aren't on the
+	 * sort list.
+	 */
+	sort_has_symbols = sort_sym.list.next != NULL;
+
 	get_term_dimensions(&winsize);
 	if (top.print_entries == 0) {
 		update_print_entries(&winsize);
-- 
1.6.2.5

