Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab2KUMx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:53:57 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49713 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2KUMv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:51:57 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH v3 12/19] perf report: add support for mem access profiling
Date: Wed, 21 Nov 2012 13:49:38 +0100
Message-Id: <1353502185-26521-13-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353502185-26521-1-git-send-email-eranian@google.com>
References: <1353502185-26521-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the --mem-mode option to perf report.

This mode requires a perf.data file created with memory
access samples.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-report.c |  131 +++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 127 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index fc25100..231165a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -46,6 +46,7 @@ struct perf_report {
 	bool			show_full_info;
 	bool			show_threads;
 	bool			inverted_callchain;
+	bool			mem_mode;
 	struct perf_read_values	show_threads_values;
 	const char		*pretty_printing_style;
 	symbol_filter_t		annotate_init;
@@ -54,6 +55,96 @@ struct perf_report {
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
+static int perf_report__add_mem_hist_entry(struct perf_tool *tool,
+					   struct addr_location *al,
+					   struct perf_sample *sample,
+					   struct perf_evsel *evsel,
+					   struct machine *machine,
+					   union perf_event *event)
+{
+	struct perf_report *rep = container_of(tool, struct perf_report, tool);
+	struct symbol *parent = NULL;
+	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
+	int err = 0;
+	struct hist_entry *he;
+	struct mem_info *mi, *mx;
+	uint64_t cost;
+
+	if ((sort__has_parent || symbol_conf.use_callchain)
+	    && sample->callchain) {
+		err = machine__resolve_callchain(machine, evsel, al->thread,
+						 sample, &parent);
+		if (err)
+			return err;
+	}
+
+	mi = machine__resolve_mem(machine, al->thread, sample, cpumode);
+	if (!mi)
+		return -ENOMEM;
+
+	if (rep->hide_unresolved && !al->sym)
+		return 0;
+
+	cost = mi->cost;
+	if (!cost)
+		cost = 1;
+
+	/*
+	 * The report shows the percentage of total branches captured
+	 * and not events sampled. Thus we use a pseudo period of 1.
+	 * Only in the newt browser we are doing integrated annotation,
+	 * so we don't allocated the extra space needed because the stdio
+	 * code will not use it.
+	 */
+	he = __hists__add_mem_entry(&evsel->hists, al, parent, mi,
+				    cost);
+	if (!he)
+		return -ENOMEM;
+
+	if (sort__has_sym && he->ms.sym && use_browser > 0) {
+		struct annotation *notes = symbol__annotation(he->ms.sym);
+
+		assert(evsel != NULL);
+
+		if (notes->src == NULL && symbol__alloc_hist(he->ms.sym) < 0)
+			goto out;
+
+		err = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
+		if (err)
+			goto out;
+	}
+
+	if (sort__has_sym && he->mem_info->daddr.sym && use_browser > 0) {
+		struct annotation *notes;
+
+		mx = he->mem_info;
+
+		notes = symbol__annotation(mx->daddr.sym);
+		if (!notes->src
+		    && symbol__alloc_hist(mx->daddr.sym) < 0)
+			goto out;
+
+		err = symbol__inc_addr_samples(mx->daddr.sym,
+					       mx->daddr.map,
+					       evsel->idx,
+					       mx->daddr.al_addr);
+		if (err)
+			goto out;
+	}
+
+	evsel->hists.stats.total_period += sample->period;
+	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+	err = 0;
+
+	if (symbol_conf.use_callchain) {
+		err = callchain_append(he->callchain,
+				       &callchain_cursor,
+				       sample->period);
+	}
+out:
+	return err;
+}
+
 static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 					struct addr_location *al,
 					struct perf_sample *sample,
@@ -209,6 +300,12 @@ static int process_sample_event(struct perf_tool *tool,
 			pr_debug("problem adding lbr entry, skipping event\n");
 			return -1;
 		}
+	} else if (rep->mem_mode == 1) {
+		if (perf_report__add_mem_hist_entry(tool, &al, sample,
+						    evsel, machine, event)) {
+			pr_debug("problem adding mem entry, skipping event\n");
+			return -1;
+		}
 	} else {
 		if (al.map != NULL)
 			al.map->dso->hit = 1;
@@ -292,7 +389,8 @@ static void sig_handler(int sig __maybe_unused)
 	session_done = 1;
 }
 
-static size_t hists__fprintf_nr_sample_events(struct hists *self,
+static size_t hists__fprintf_nr_sample_events(struct perf_report *rep,
+					      struct hists *self,
 					      const char *evname, FILE *fp)
 {
 	size_t ret;
@@ -305,7 +403,11 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
+	if (rep->mem_mode) {
+		ret += fprintf(fp, "\n# Total cost : %" PRIu64, nr_events);
+		ret += fprintf(fp, "\n# Sort order : %s", sort_order);
+	} else
+		ret += fprintf(fp, "\n# Event count (approx.): %" PRIu64, nr_events);
 	return ret + fprintf(fp, "\n#\n");
 }
 
@@ -319,7 +421,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 		struct hists *hists = &pos->hists;
 		const char *evname = perf_evsel__name(pos);
 
-		hists__fprintf_nr_sample_events(hists, evname, stdout);
+		hists__fprintf_nr_sample_events(rep, hists, evname, stdout);
 		hists__fprintf(hists, true, 0, 0, stdout);
 		fprintf(stdout, "\n\n");
 	}
@@ -596,7 +698,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Use the stdio interface"),
 	OPT_STRING('s', "sort", &sort_order, "key[,key2...]",
 		   "sort by key(s): pid, comm, dso, symbol, parent, dso_to,"
-		   " dso_from, symbol_to, symbol_from, mispredict"),
+		   " dso_from, symbol_to, symbol_from, mispredict, mem, cost, symbol_daddr, dso_daddr, tlb, snoop, locked"),
 	OPT_BOOLEAN(0, "showcpuutilization", &symbol_conf.show_cpu_utilization,
 		    "Show sample percentage for different cpu modes"),
 	OPT_STRING('p', "parent", &parent_pattern, "regex",
@@ -642,6 +744,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "use branch records for histogram filling", parse_branch_mode),
 	OPT_STRING(0, "objdump", &objdump_path, "path",
 		   "objdump binary to use for disassembly and annotations"),
+	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_END()
 	};
 
@@ -687,6 +790,18 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 				     "dso_to,symbol_to";
 
 	}
+	if (report.mem_mode) {
+		if (sort__branch_mode == 1) {
+			fprintf(stderr, "branch and mem mode incompatible\n");
+			goto error;
+		}
+		/*
+		 * if no sort_order is provided, then specify
+		 * branch-mode specific order
+		 */
+		if (sort_order == default_sort_order)
+			sort_order = "cost,mem,sym,dso,symbol_daddr,dso_daddr,snoop,tlb,locked";
+	}
 
 	if (strcmp(input_name, "-") != 0)
 		setup_browser(true);
@@ -758,6 +873,14 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 		sort_entry__setup_elide(&sort_sym_from, symbol_conf.sym_from_list, "sym_from", stdout);
 		sort_entry__setup_elide(&sort_sym_to, symbol_conf.sym_to_list, "sym_to", stdout);
 	} else {
+		if (report.mem_mode) {
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "symbol_daddr", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso_daddr", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "mem", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "cost", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "tlb", stdout);
+			sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "snoop", stdout);
+		}
 		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 		sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 	}
-- 
1.7.9.5

