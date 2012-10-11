Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab2JKEZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:25:51 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:58804 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab2JKEZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:25:47 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 2/9] perf top: make use of perf_record_opts
Date: Wed, 10 Oct 2012 22:25:28 -0600
Message-Id: <1349929535-92861-3-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
References: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes top code to use the perf_record_opts struct. Stepping stone to
consolidating the open counters code.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-top.c |   84 ++++++++++++++++++++++++----------------------
 tools/perf/util/top.c    |   20 +++++------
 tools/perf/util/top.h    |    9 +----
 3 files changed, 54 insertions(+), 59 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index fb9da71..33c3825 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -591,7 +591,7 @@ static void *display_thread_tui(void *arg)
 	 * via --uid.
 	 */
 	list_for_each_entry(pos, &top->evlist->entries, node)
-		pos->hists.uid_filter_str = top->target.uid_str;
+		pos->hists.uid_filter_str = top->opts.target.uid_str;
 
 	perf_evlist__tui_browse_hists(top->evlist, help,
 				      perf_top__sort_new_samples,
@@ -891,7 +891,7 @@ static void perf_top__start_counters(struct perf_top *top)
 	struct perf_evsel *counter;
 	struct perf_evlist *evlist = top->evlist;
 
-	if (top->group)
+	if (top->opts.group)
 		perf_evlist__set_leader(evlist);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
@@ -899,10 +899,10 @@ static void perf_top__start_counters(struct perf_top *top)
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
-		if (top->freq) {
+		if (top->opts.freq) {
 			attr->sample_type |= PERF_SAMPLE_PERIOD;
 			attr->freq	  = 1;
-			attr->sample_freq = top->freq;
+			attr->sample_freq = top->opts.freq;
 		}
 
 		if (evlist->nr_entries > 1) {
@@ -910,7 +910,7 @@ static void perf_top__start_counters(struct perf_top *top)
 			attr->read_format |= PERF_FORMAT_ID;
 		}
 
-		if (perf_target__has_cpu(&top->target))
+		if (perf_target__has_cpu(&top->opts.target))
 			attr->sample_type |= PERF_SAMPLE_CPU;
 
 		if (symbol_conf.use_callchain)
@@ -918,12 +918,12 @@ static void perf_top__start_counters(struct perf_top *top)
 
 		attr->mmap = 1;
 		attr->comm = 1;
-		attr->inherit = top->inherit;
+		attr->inherit = !top->opts.no_inherit;
 fallback_missing_features:
-		if (top->exclude_guest_missing)
+		if (top->opts.exclude_guest_missing)
 			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
-		attr->sample_id_all = top->sample_id_all_missing ? 0 : 1;
+		attr->sample_id_all = top->opts.sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(counter, top->evlist->cpus,
 				     top->evlist->threads) < 0) {
@@ -933,17 +933,17 @@ try_again:
 				ui__error_paranoid();
 				goto out_err;
 			} else if (err == EINVAL) {
-				if (!top->exclude_guest_missing &&
+				if (!top->opts.exclude_guest_missing &&
 				    (attr->exclude_guest || attr->exclude_host)) {
 					pr_debug("Old kernel, cannot exclude "
 						 "guest or host samples.\n");
-					top->exclude_guest_missing = true;
+					top->opts.exclude_guest_missing = true;
 					goto fallback_missing_features;
-				} else if (!top->sample_id_all_missing) {
+				} else if (!top->opts.sample_id_all_missing) {
 					/*
 					 * Old kernel, no attr->sample_id_type_all field
 					 */
-					top->sample_id_all_missing = true;
+					top->opts.sample_id_all_missing = true;
 					goto retry_sample_id;
 				}
 			}
@@ -988,7 +988,7 @@ try_again:
 		}
 	}
 
-	if (perf_evlist__mmap(evlist, top->mmap_pages, false) < 0) {
+	if (perf_evlist__mmap(evlist, top->opts.mmap_pages, false) < 0) {
 		ui__error("Failed to mmap with %d (%s)\n",
 			    errno, strerror(errno));
 		goto out_err;
@@ -1034,7 +1034,7 @@ static int __cmd_top(struct perf_top *top)
 	if (ret)
 		goto out_delete;
 
-	if (perf_target__has_task(&top->target))
+	if (perf_target__has_task(&top->opts.target))
 		perf_event__synthesize_thread_map(&top->tool, top->evlist->threads,
 						  perf_event__process,
 						  &top->session->host_machine);
@@ -1168,11 +1168,13 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	struct perf_top top = {
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
-		.freq		     = 4000, /* 4 KHz */
-		.mmap_pages	     = 128,
 		.sym_pcnt_filter     = 5,
-		.target		     = {
-			.uses_mmap   = true,
+		.opts = {
+			.freq		     = 4000, /* 4 KHz */
+			.mmap_pages	     = 128,
+			.target		     = {
+				.uses_mmap   = true,
+			},
 		},
 	};
 	char callchain_default_opt[] = "fractal,0.5,callee";
@@ -1180,21 +1182,21 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK('e', "event", &top.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
-	OPT_INTEGER('c', "count", &top.default_interval,
-		    "event period to sample"),
-	OPT_STRING('p', "pid", &top.target.pid, "pid",
+	OPT_U64('c', "count", &top.opts.default_interval,
+		"event period to sample"),
+	OPT_STRING('p', "pid", &top.opts.target.pid, "pid",
 		    "profile events on existing process id"),
-	OPT_STRING('t', "tid", &top.target.tid, "tid",
+	OPT_STRING('t', "tid", &top.opts.target.tid, "tid",
 		    "profile events on existing thread id"),
-	OPT_BOOLEAN('a', "all-cpus", &top.target.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &top.opts.target.system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_STRING('C', "cpu", &top.target.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &top.opts.target.cpu_list, "cpu",
 		    "list of cpus to monitor"),
 	OPT_STRING('k', "vmlinux", &symbol_conf.vmlinux_name,
 		   "file", "vmlinux pathname"),
 	OPT_BOOLEAN('K', "hide_kernel_symbols", &top.hide_kernel_symbols,
 		    "hide kernel symbols"),
-	OPT_UINTEGER('m', "mmap-pages", &top.mmap_pages, "number of mmap data pages"),
+	OPT_UINTEGER('m', "mmap-pages", &top.opts.mmap_pages, "number of mmap data pages"),
 	OPT_INTEGER('r', "realtime", &top.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
 	OPT_INTEGER('d', "delay", &top.delay_secs,
@@ -1203,15 +1205,15 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "dump the symbol table used for profiling"),
 	OPT_INTEGER('f', "count-filter", &top.count_filter,
 		    "only display functions with more events than this"),
-	OPT_BOOLEAN('g', "group", &top.group,
+	OPT_BOOLEAN('g', "group", &top.opts.group,
 			    "put the counters into a counter group"),
-	OPT_BOOLEAN('i', "inherit", &top.inherit,
+	OPT_BOOLEAN('i', "inherit", &top.opts.no_inherit,
 		    "child tasks inherit counters"),
 	OPT_STRING(0, "sym-annotate", &top.sym_filter, "symbol name",
 		    "symbol to annotate"),
 	OPT_BOOLEAN('z', "zero", &top.zero,
 		    "zero history across updates"),
-	OPT_INTEGER('F', "freq", &top.freq,
+	OPT_UINTEGER('F', "freq", &top.opts.freq,
 		    "profile at this frequency"),
 	OPT_INTEGER('E', "entries", &top.print_entries,
 		    "display this many functions"),
@@ -1243,7 +1245,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Display raw encoding of assembly instructions (default)"),
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
-	OPT_STRING('u', "uid", &top.target.uid_str, "user", "user to profile"),
+	OPT_STRING('u', "uid", &top.opts.target.uid_str, "user", "user to profile"),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
@@ -1273,27 +1275,27 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 
 	setup_browser(false);
 
-	status = perf_target__validate(&top.target);
+	status = perf_target__validate(&top.opts.target);
 	if (status) {
-		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
+		perf_target__strerror(&top.opts.target, status, errbuf, BUFSIZ);
 		ui__warning("%s", errbuf);
 	}
 
-	status = perf_target__parse_uid(&top.target);
+	status = perf_target__parse_uid(&top.opts.target);
 	if (status) {
 		int saved_errno = errno;
 
-		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
+		perf_target__strerror(&top.opts.target, status, errbuf, BUFSIZ);
 		ui__error("%s", errbuf);
 
 		status = -saved_errno;
 		goto out_delete_evlist;
 	}
 
-	if (perf_target__none(&top.target))
-		top.target.system_wide = true;
+	if (perf_target__none(&top.opts.target))
+		top.opts.target.system_wide = true;
 
-	if (perf_evlist__create_maps(top.evlist, &top.target) < 0)
+	if (perf_evlist__create_maps(top.evlist, &top.opts.target) < 0)
 		usage_with_options(top_usage, options);
 
 	if (!top.evlist->nr_entries &&
@@ -1310,10 +1312,10 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	/*
 	 * User specified count overrides default frequency.
 	 */
-	if (top.default_interval)
-		top.freq = 0;
-	else if (top.freq) {
-		top.default_interval = top.freq;
+	if (top.opts.default_interval)
+		top.opts.freq = 0;
+	else if (top.opts.freq) {
+		top.opts.default_interval = top.opts.freq;
 	} else {
 		ui__error("frequency and count are zero, aborting\n");
 		exit(EXIT_FAILURE);
@@ -1324,7 +1326,7 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 		 * Fill in the ones not specifically initialized via -c:
 		 */
 		if (!pos->attr.sample_period)
-			pos->attr.sample_period = top.default_interval;
+			pos->attr.sample_period = top.opts.default_interval;
 	}
 
 	top.sym_evsel = perf_evlist__first(top.evlist);
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index 884dde9..deea8fd 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -61,31 +61,31 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 		struct perf_evsel *first = perf_evlist__first(top->evlist);
 		ret += SNPRINTF(bf + ret, size - ret, "%" PRIu64 "%s ",
 				(uint64_t)first->attr.sample_period,
-				top->freq ? "Hz" : "");
+				top->opts.freq ? "Hz" : "");
 	}
 
 	ret += SNPRINTF(bf + ret, size - ret, "%s", perf_evsel__name(top->sym_evsel));
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
-	if (top->target.pid)
+	if (top->opts.target.pid)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_pid: %s",
-				top->target.pid);
-	else if (top->target.tid)
+				top->opts.target.pid);
+	else if (top->opts.target.tid)
 		ret += SNPRINTF(bf + ret, size - ret, " (target_tid: %s",
-				top->target.tid);
-	else if (top->target.uid_str != NULL)
+				top->opts.target.tid);
+	else if (top->opts.target.uid_str != NULL)
 		ret += SNPRINTF(bf + ret, size - ret, " (uid: %s",
-				top->target.uid_str);
+				top->opts.target.uid_str);
 	else
 		ret += SNPRINTF(bf + ret, size - ret, " (all");
 
-	if (top->target.cpu_list)
+	if (top->opts.target.cpu_list)
 		ret += SNPRINTF(bf + ret, size - ret, ", CPU%s: %s)",
 				top->evlist->cpus->nr > 1 ? "s" : "",
-				top->target.cpu_list);
+				top->opts.target.cpu_list);
 	else {
-		if (top->target.tid)
+		if (top->opts.target.tid)
 			ret += SNPRINTF(bf + ret, size - ret, ")");
 		else
 			ret += SNPRINTF(bf + ret, size - ret, ", %d CPU%s)",
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 86ff1b1..9728740 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -14,7 +14,7 @@ struct perf_session;
 struct perf_top {
 	struct perf_tool   tool;
 	struct perf_evlist *evlist;
-	struct perf_target target;
+	struct perf_record_opts opts;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
 	 * get out after decayed.
@@ -24,24 +24,17 @@ struct perf_top {
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
 	int		   print_entries, count_filter, delay_secs;
-	int		   freq;
 	bool		   hide_kernel_symbols, hide_user_symbols, zero;
 	bool		   use_tui, use_stdio;
 	bool		   sort_has_symbols;
 	bool		   dont_use_callchains;
 	bool		   kptr_restrict_warned;
 	bool		   vmlinux_warned;
-	bool		   inherit;
-	bool		   group;
-	bool		   sample_id_all_missing;
-	bool		   exclude_guest_missing;
 	bool		   dump_symtab;
 	struct hist_entry  *sym_filter_entry;
 	struct perf_evsel  *sym_evsel;
 	struct perf_session *session;
 	struct winsize	   winsize;
-	unsigned int	   mmap_pages;
-	int		   default_interval;
 	int		   realtime_prio;
 	int		   sym_pcnt_filter;
 	const char	   *sym_filter;
-- 
1.7.10.1

