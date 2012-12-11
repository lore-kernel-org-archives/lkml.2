Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab2LKWwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:52:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:43875 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab2LKWsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 37/37] perf top: Use perf_evlist__config()
Date: Tue, 11 Dec 2012 19:48:23 -0300
Message-Id: <1355266103-17238-38-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using struct perf_record_opts to specify how to configure the evsel
perf_event_attrs.

This gets top closer to record in the way it sets up evsels, with the
aim of sharing more and more to the point that both will be a single
utility.

In this direction top now uses the same callchain option parsing as
record and that brings DWARF callchains to top, something that was
already available for record.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-u03o0bsrqcjgskciso3pvsjr@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-top.txt |    2 +-
 tools/perf/builtin-top.c              |  204 +++++++++++----------------------
 tools/perf/util/top.c                 |   22 ++--
 tools/perf/util/top.h                 |    8 +-
 4 files changed, 79 insertions(+), 157 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 5b80d84..a414bc9 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -60,7 +60,7 @@ Default is to monitor all CPUS.
 
 -i::
 --inherit::
-	Child tasks inherit counters, only makes sens with -p option.
+	Child tasks do not inherit counters.
 
 -k <path>::
 --vmlinux=<path>::
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index a306474..b7d2ea6 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -596,7 +596,7 @@ static void *display_thread_tui(void *arg)
 	 * via --uid.
 	 */
 	list_for_each_entry(pos, &top->evlist->entries, node)
-		pos->hists.uid_filter_str = top->target.uid_str;
+		pos->hists.uid_filter_str = top->record_opts.target.uid_str;
 
 	perf_evlist__tui_browse_hists(top->evlist, help, &hbt,
 				      &top->session->header.env);
@@ -894,34 +894,13 @@ static void perf_top__start_counters(struct perf_top *top)
 {
 	struct perf_evsel *counter;
 	struct perf_evlist *evlist = top->evlist;
+	struct perf_record_opts *opts = &top->record_opts;
 
-	if (top->group)
-		perf_evlist__set_leader(evlist);
+	perf_evlist__config(evlist, opts);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
 
-		perf_evsel__set_sample_bit(counter, IP);
-		perf_evsel__set_sample_bit(counter, TID);
-
-		if (top->freq) {
-			perf_evsel__set_sample_bit(counter, PERIOD);
-			attr->freq	  = 1;
-			attr->sample_freq = top->freq;
-		}
-
-		if (evlist->nr_entries > 1)
-			perf_evsel__set_sample_id(counter);
-
-		if (perf_target__has_cpu(&top->target))
-			perf_evsel__set_sample_bit(counter, CPU);
-
-		if (symbol_conf.use_callchain)
-			perf_evsel__set_sample_bit(counter, CALLCHAIN);
-
-		attr->mmap = 1;
-		attr->comm = 1;
-		attr->inherit = top->inherit;
 fallback_missing_features:
 		if (top->exclude_guest_missing)
 			attr->exclude_guest = attr->exclude_host = 0;
@@ -995,7 +974,7 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, top->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0) {
 		ui__error("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
@@ -1015,7 +994,7 @@ static int perf_top__setup_sample_type(struct perf_top *top)
 			ui__error("Selected -g but \"sym\" not present in --sort/-s.");
 			return -EINVAL;
 		}
-	} else if (!top->dont_use_callchains && callchain_param.mode != CHAIN_NONE) {
+	} else if (callchain_param.mode != CHAIN_NONE) {
 		if (callchain_register_param(&callchain_param) < 0) {
 			ui__error("Can't register callchain params.\n");
 			return -EINVAL;
@@ -1027,6 +1006,7 @@ static int perf_top__setup_sample_type(struct perf_top *top)
 
 static int __cmd_top(struct perf_top *top)
 {
+	struct perf_record_opts *opts = &top->record_opts;
 	pthread_t thread;
 	int ret;
 	/*
@@ -1041,7 +1021,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (perf_target__has_task(&top->target))
+	if (perf_target__has_task(&opts->target))
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
@@ -1052,6 +1032,17 @@ static int __cmd_top(struct perf_top *top)
 	top->session->evlist = top->evlist;
 	perf_session__set_id_hdr_size(top->session);
 
+	/*
+	 * When perf is starting the traced process, all the events (apart from
+	 * group members) have enable_on_exec=1 set, so don't spoil it by
+	 * prematurely enabling them.
+	 *
+	 * XXX 'top' still doesn't start workloads like record, trace, but should,
+	 * so leave the check here.
+	 */
+        if (!perf_target__none(&opts->target))
+                perf_evlist__enable(top->evlist);
+
 	/* Wait for a minimal set of events before starting the snapshot */
 	poll(top->evlist->pollfd, top->evlist->nr_fds, 100);
 
@@ -1092,116 +1083,56 @@ out_delete:
 static int
 parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
-	struct perf_top *top = (struct perf_top *)opt->value;
-	char *tok, *tok2;
-	char *endptr;
-
 	/*
 	 * --no-call-graph
 	 */
-	if (unset) {
-		top->dont_use_callchains = true;
+	if (unset)
 		return 0;
-	}
 
 	symbol_conf.use_callchain = true;
 
-	if (!arg)
-		return 0;
-
-	tok = strtok((char *)arg, ",");
-	if (!tok)
-		return -1;
-
-	/* get the output mode */
-	if (!strncmp(tok, "graph", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_ABS;
-
-	else if (!strncmp(tok, "flat", strlen(arg)))
-		callchain_param.mode = CHAIN_FLAT;
-
-	else if (!strncmp(tok, "fractal", strlen(arg)))
-		callchain_param.mode = CHAIN_GRAPH_REL;
-
-	else if (!strncmp(tok, "none", strlen(arg))) {
-		callchain_param.mode = CHAIN_NONE;
-		symbol_conf.use_callchain = false;
-
-		return 0;
-	} else
-		return -1;
-
-	/* get the min percentage */
-	tok = strtok(NULL, ",");
-	if (!tok)
-		goto setup;
-
-	callchain_param.min_percent = strtod(tok, &endptr);
-	if (tok == endptr)
-		return -1;
-
-	/* get the print limit */
-	tok2 = strtok(NULL, ",");
-	if (!tok2)
-		goto setup;
-
-	if (tok2[0] != 'c') {
-		callchain_param.print_limit = strtod(tok2, &endptr);
-		tok2 = strtok(NULL, ",");
-		if (!tok2)
-			goto setup;
-	}
-
-	/* get the call chain order */
-	if (!strcmp(tok2, "caller"))
-		callchain_param.order = ORDER_CALLER;
-	else if (!strcmp(tok2, "callee"))
-		callchain_param.order = ORDER_CALLEE;
-	else
-		return -1;
-setup:
-	if (callchain_register_param(&callchain_param) < 0) {
-		fprintf(stderr, "Can't register callchain params\n");
-		return -1;
-	}
-	return 0;
+	return record_parse_callchain_opt(opt, arg, unset);
 }
 
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
-	struct perf_evsel *pos;
 	int status;
 	char errbuf[BUFSIZ];
 	struct perf_top top = {
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
-		.freq		     = 4000, /* 4 KHz */
-		.mmap_pages	     = 128,
-		.sym_pcnt_filter     = 5,
-		.target		     = {
-			.uses_mmap   = true,
+		.record_opts = {
+			.mmap_pages	= UINT_MAX,
+			.user_freq	= UINT_MAX,
+			.user_interval	= ULLONG_MAX,
+			.freq		= 4000, /* 4 KHz */
+			.target		     = {
+				.uses_mmap   = true,
+			},
 		},
+		.sym_pcnt_filter     = 5,
 	};
-	char callchain_default_opt[] = "fractal,0.5,callee";
+	struct perf_record_opts *opts = &top.record_opts;
+	struct perf_target *target = &opts->target;
 	const struct option options[] = {
 	OPT_CALLBACK('e', "event", &top.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
-	OPT_INTEGER('c', "count", &top.default_interval,
-		    "event period to sample"),
-	OPT_STRING('p', "pid", &top.target.pid, "pid",
+	OPT_U64('c', "count", &opts->user_interval, "event period to sample"),
+	OPT_STRING('p', "pid", &target->pid, "pid",
 		    "profile events on existing process id"),
-	OPT_STRING('t', "tid", &top.target.tid, "tid",
+	OPT_STRING('t', "tid", &target->tid, "tid",
 		    "profile events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &top.target.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &target->system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_STRING('C', "cpu", &top.target.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &target->cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
-	OPT_UINTEGER('m', "mmap-pages", &top.mmap_pages, "number of mmap data pages"),
+	OPT_UINTEGER('m', "mmap-pages", &opts->mmap_pages,
+		     "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &top.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_INTEGER('d', "delay", &top.delay_secs,
@@ -1210,16 +1141,14 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "dump the symbol table used for profiling"),
 	OPT_INTEGER('f', "count-filter", &top.count_filter,
 		    "only display functions with more events than this"),
-	OPT_BOOLEAN('g', "group", &top.group,
+	OPT_BOOLEAN('g', "group", &opts->group,
 			    "put the counters into a counter group"),
-	OPT_BOOLEAN('i', "inherit", &top.inherit,
-		    "child tasks inherit counters"),
+	OPT_BOOLEAN('i', "no-inherit", &opts->no_inherit,
+		    "child tasks do not inherit counters"),
 	OPT_STRING(0, "sym-annotate", &top.sym_filter, "symbol name",
 		    "symbol to annotate"),
-	OPT_BOOLEAN('z', "zero", &top.zero,
-		    "zero history across updates"),
-	OPT_INTEGER('F', "freq", &top.freq,
-		    "profile at this frequency"),
+	OPT_BOOLEAN('z', "zero", &top.zero, "zero history across updates"),
+	OPT_UINTEGER('F', "freq", &opts->user_freq, "profile at this frequency"),
 	OPT_INTEGER('E', "entries", &top.print_entries,
 		    "display this many functions"),
 	OPT_BOOLEAN('U', "hide_user_symbols", &top.hide_user_symbols,
@@ -1232,10 +1161,9 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		   "sort by key(s): pid, comm, dso, symbol, parent"),
 	OPT_BOOLEAN('n', "show-nr-samples", &symbol_conf.show_nr_samples,
 		    "Show a column with the number of samples"),
-	OPT_CALLBACK_DEFAULT('G', "call-graph", &top, "output_type,min_percent, call_order",
-		     "Display callchains using output_type (graph, flat, fractal, or none), min percent threshold and callchain order. "
-		     "Default: fractal,0.5,callee", &parse_callchain_opt,
-		     callchain_default_opt),
+	OPT_CALLBACK_DEFAULT('G', "call-graph", &top.record_opts,
+			     "mode[,dump_size]", record_callchain_help,
+			     &parse_callchain_opt, "fp"),
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
 	OPT_STRING(0, "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
@@ -1250,7 +1178,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
-	OPT_STRING('u', "uid", &top.target.uid_str, "user", "user to profile"),
+	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
@@ -1280,27 +1208,27 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_browser(false);
 
-	status = perf_target__validate(&top.target);
+	status = perf_target__validate(target);
 	if (status) {
-		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
+		perf_target__strerror(target, status, errbuf, BUFSIZ);
 		ui__warning("%s", errbuf);
 	}
 
-	status = perf_target__parse_uid(&top.target);
+	status = perf_target__parse_uid(target);
 	if (status) {
 		int saved_errno = errno;
 
-		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
+		perf_target__strerror(target, status, errbuf, BUFSIZ);
 		ui__error("%s", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;
 	}
 
-	if (perf_target__none(&top.target))
-		top.target.system_wide = true;
+	if (perf_target__none(target))
+		target->system_wide = true;
 
-	if (perf_evlist__create_maps(top.evlist, &top.target) < 0)
+	if (perf_evlist__create_maps(top.evlist, target) < 0)
 		usage_with_options(top_usage, options);
 
 	if (!top.evlist->nr_entries &&
@@ -1314,24 +1242,22 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (top.delay_secs < 1)
 		top.delay_secs = 1;
 
+	if (opts->user_interval != ULLONG_MAX)
+		opts->default_interval = opts->user_interval;
+	if (opts->user_freq != UINT_MAX)
+		opts->freq = opts->user_freq;
+
 	/*
 	 * User specified count overrides default frequency.
 	 */
-	if (top.default_interval)
-		top.freq = 0;
-	else if (top.freq) {
-		top.default_interval = top.freq;
+	if (opts->default_interval)
+		opts->freq = 0;
+	else if (opts->freq) {
+		opts->default_interval = opts->freq;
 	} else {
 		ui__error("frequency and count are zero, aborting\n");
-		exit(EXIT_FAILURE);
-	}
-
-	list_for_each_entry(pos, &top.evlist->entries, node) {
-		/*
-		 * Fill in the ones not specifically initialized via -c:
-		 */
-		if (!pos->attr.sample_period)
-			pos->attr.sample_period = top.default_interval;
+		status = -EINVAL;
+		goto out_delete_evlist;
 	}
 
 	top.sym_evsel = perf_evlist__first(top.evlist);
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 884dde9..54d37a4 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -26,6 +26,8 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 	float samples_per_sec = top->samples / top->delay_secs;
 	float ksamples_per_sec = top->kernel_samples / top->delay_secs;
 	float esamples_percent = (100.0 * top->exact_samples) / top->samples;
+	struct perf_record_opts *opts = &top->record_opts;
+	struct perf_target *target = &opts->target;
 	size_t ret = 0;
 
 	if (!perf_guest) {
@@ -61,31 +63,31 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 		struct perf_evsel *first = perf_evlist__first(top->evlist);
 		ret += SNPRINTF(bf + ret, size - ret, "%" PRIu64 "%s ",
 				(uint64_t)first->attr.sample_period,
-				top->freq ? "Hz" : "");
+				opts->freq ? "Hz" : "");
 	}
 
 	ret += SNPRINTF(bf + ret, size - ret, "%s", perf_evsel__name(top->sym_evsel));
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
-	if (top->target.pid)
+	if (target->pid)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %s",
-				top->target.pid);
-	else if (top->target.tid)
+				target->pid);
+	else if (target->tid)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %s",
-				top->target.tid);
-	else if (top->target.uid_str != NULL)
+				target->tid);
+	else if (target->uid_str != NULL)
 		ret += SNPRINTF(bf + ret, size - ret, " (uid: %s",
-				top->target.uid_str);
+				target->uid_str);
 	else
 		ret += SNPRINTF(bf + ret, size - ret, " (all");
 
-	if (top->target.cpu_list)
+	if (target->cpu_list)
 		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
 				top->evlist->cpus->nr > 1 ? "s" : "",
-				top->target.cpu_list);
+				target->cpu_list);
 	else {
-		if (top->target.tid)
+		if (target->tid)
 			ret += SNPRINTF(bf + ret, size - ret, ")");
 		else
 			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 86ff1b1..927c229 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -14,7 +14,7 @@ struct perf_session;
 struct perf_top {
 	struct perf_tool   tool;
 	struct perf_evlist *evlist;
-	struct perf_target target;
+	struct perf_record_opts record_opts;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
 	 * get out after decayed.
@@ -24,15 +24,11 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
-	int		   freq;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	bool		   use_tui, use_stdio;
 	bool		   sort_has_symbols;
-	bool		   dont_use_callchains;
 	bool		   kptr_restrict_warned;
 	bool		   vmlinux_warned;
-	bool		   inherit;
-	bool		   group;
 	bool		   sample_id_all_missing;
 	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
@@ -40,8 +36,6 @@ struct perf_top {
 	struct perf_evsel  *sym_evsel;
 	struct perf_session *session;
 	struct winsize	   winsize;
-	unsigned int	   mmap_pages;
-	int		   default_interval;
 	int		   realtime_prio;
 	int		   sym_pcnt_filter;
 	const char	   *sym_filter;
-- 
1.7.9.2.358.g22243

