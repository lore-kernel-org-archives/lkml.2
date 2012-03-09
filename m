Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2CINgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 08:36:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58857 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab2CINgP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 08:36:15 -0500
Date: Fri, 9 Mar 2012 05:35:44 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-a68c2c58171391ef368fced32a555b2f0ff106e5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1331246868-19905-5-git-send-email-eranian@google.com>
References: <1331246868-19905-5-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/hw-branch-sampling] perf report:
  Enable TUI in branch view mode
Git-Commit-ID: a68c2c58171391ef368fced32a555b2f0ff106e5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 09 Mar 2012 05:36:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a68c2c58171391ef368fced32a555b2f0ff106e5
Gitweb:     http://git.kernel.org/tip/a68c2c58171391ef368fced32a555b2f0ff106e5
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Thu, 8 Mar 2012 23:47:48 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 9 Mar 2012 08:26:08 +0100

perf report: Enable TUI in branch view mode

This patch updates perf report to support TUI mode
when the perf.data file contains samples with branch
stacks.

For each row in the report, it is possible to annotate
either the source or target of each branch.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: acme@redhat.com
Cc: asharma@fb.com
Cc: ravitillo@lbl.gov
Cc: vweaver1@eecs.utk.edu
Cc: khandual@linux.vnet.ibm.com
Cc: dsahern@gmail.com
Link: http://lkml.kernel.org/r/1331246868-19905-5-git-send-email-eranian@google.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-report.c         |   73 ++++++++++++++++++++++++-----------
 tools/perf/util/session.c           |    1 +
 tools/perf/util/sort.h              |    6 ++-
 tools/perf/util/symbol.h            |    7 +++-
 tools/perf/util/ui/browsers/hists.c |   62 ++++++++++++++++++++++++------
 5 files changed, 111 insertions(+), 38 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 66e8523..8e91c6e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -64,7 +64,7 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 	int err = 0;
 	unsigned i;
 	struct hist_entry *he;
-	struct branch_info *bi;
+	struct branch_info *bi, *bx;
 
 	if ((sort__has_parent || symbol_conf.use_callchain)
 	    && sample->callchain) {
@@ -87,13 +87,45 @@ static int perf_report__add_branch_hist_entry(struct perf_tool *tool,
 		 * and not events sampled. Thus we use a pseudo period of 1.
 		 */
 		he = __hists__add_branch_entry(&evsel->hists, al, parent,
-					       &bi[i], 1);
+				&bi[i], 1);
 		if (he) {
+			struct annotation *notes;
+			err = -ENOMEM;
+			bx = he->branch_info;
+			if (bx->from.sym && use_browser > 0) {
+				notes = symbol__annotation(bx->from.sym);
+				if (!notes->src
+				    && symbol__alloc_hist(bx->from.sym) < 0)
+					goto out;
+
+				err = symbol__inc_addr_samples(bx->from.sym,
+							       bx->from.map,
+							       evsel->idx,
+							       bx->from.al_addr);
+				if (err)
+					goto out;
+			}
+
+			if (bx->to.sym && use_browser > 0) {
+				notes = symbol__annotation(bx->to.sym);
+				if (!notes->src
+				    && symbol__alloc_hist(bx->to.sym) < 0)
+					goto out;
+
+				err = symbol__inc_addr_samples(bx->to.sym,
+							       bx->to.map,
+							       evsel->idx,
+							       bx->to.al_addr);
+				if (err)
+					goto out;
+			}
 			evsel->hists.stats.total_period += 1;
 			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
+			err = 0;
 		} else
 			return -ENOMEM;
 	}
+out:
 	return err;
 }
 
@@ -615,32 +647,19 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (sort__branch_mode == -1 && has_br_stack)
 		sort__branch_mode = 1;
 
+	/* sort__branch_mode could be 0 if --no-branch-stack */
 	if (sort__branch_mode == 1) {
-		if (use_browser)
-			fprintf(stderr, "Warning: TUI interface not supported"
-					" in branch mode\n");
-		if (symbol_conf.dso_list_str != NULL)
-			fprintf(stderr, "Warning: dso filtering not supported"
-					" in branch mode\n");
-		if (symbol_conf.sym_list_str != NULL)
-			fprintf(stderr, "Warning: symbol filtering not"
-					" supported in branch mode\n");
-
-		report.use_stdio = true;
-		use_browser = 0;
-		setup_browser(true);
-		symbol_conf.dso_list_str = NULL;
-		symbol_conf.sym_list_str = NULL;
-
 		/*
-		 * if no sort_order is provided, then specify branch-mode
-		 * specific order
+		 * if no sort_order is provided, then specify
+		 * branch-mode specific order
 		 */
 		if (sort_order == default_sort_order)
 			sort_order = "comm,dso_from,symbol_from,"
 				     "dso_to,symbol_to";
 
-	} else if (strcmp(report.input_name, "-") != 0) {
+	}
+
+	if (strcmp(report.input_name, "-") != 0) {
 		setup_browser(true);
 	} else {
 		use_browser = 0;
@@ -696,9 +715,17 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	if (argc)
 		usage_with_options(report_usage, options);
 
-	sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
-	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
+
+	if (sort__branch_mode == 1) {
+		sort_entry__setup_elide(&sort_dso_from, symbol_conf.dso_from_list, "dso_from", stdout);
+		sort_entry__setup_elide(&sort_dso_to, symbol_conf.dso_to_list, "dso_to", stdout);
+		sort_entry__setup_elide(&sort_sym_from, symbol_conf.sym_from_list, "sym_from", stdout);
+		sort_entry__setup_elide(&sort_sym_to, symbol_conf.sym_to_list, "sym_to", stdout);
+	} else {
+		sort_entry__setup_elide(&sort_dso, symbol_conf.dso_list, "dso", stdout);
+		sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
+	}
 
 	ret = __cmd_report(&report);
 error:
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index e650de8..002ebbf 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -263,6 +263,7 @@ static void ip__resolve_ams(struct machine *self, struct thread *thread,
 	}
 found:
 	ams->addr = ip;
+	ams->al_addr = al.addr;
 	ams->sym = al.sym;
 	ams->map = al.map;
 }
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 8505b9b..472aa5a 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -37,8 +37,10 @@ extern struct sort_entry sort_comm;
 extern struct sort_entry sort_dso;
 extern struct sort_entry sort_sym;
 extern struct sort_entry sort_parent;
-extern struct sort_entry sort_lbr_dso;
-extern struct sort_entry sort_lbr_sym;
+extern struct sort_entry sort_dso_from;
+extern struct sort_entry sort_dso_to;
+extern struct sort_entry sort_sym_from;
+extern struct sort_entry sort_sym_to;
 extern enum sort_type sort__first_dimension;
 
 /**
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 5866ce6..ac49ef2 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -97,7 +97,11 @@ struct symbol_conf {
 			*col_width_list_str;
        struct strlist	*dso_list,
 			*comm_list,
-			*sym_list;
+			*sym_list,
+			*dso_from_list,
+			*dso_to_list,
+			*sym_from_list,
+			*sym_to_list;
 	const char	*symfs;
 };
 
@@ -125,6 +129,7 @@ struct addr_map_symbol {
 	struct map    *map;
 	struct symbol *sym;
 	u64	      addr;
+	u64	      al_addr;
 };
 
 struct branch_info {
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index bfba049..951e2e9 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -805,8 +805,11 @@ static struct hist_browser *hist_browser__new(struct hists *hists)
 		self->hists = hists;
 		self->b.refresh = hist_browser__refresh;
 		self->b.seek = ui_browser__hists_seek;
-		self->b.use_navkeypressed = true,
-		self->has_symbols = sort_sym.list.next != NULL;
+		self->b.use_navkeypressed = true;
+		if (sort__branch_mode == 1)
+			self->has_symbols = sort_sym_from.list.next != NULL;
+		else
+			self->has_symbols = sort_sym.list.next != NULL;
 	}
 
 	return self;
@@ -861,6 +864,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 {
 	struct hists *self = &evsel->hists;
 	struct hist_browser *browser = hist_browser__new(self);
+	struct branch_info *bi;
 	struct pstack *fstack;
 	int key = -1;
 
@@ -879,7 +883,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		char *options[16];
 		int nr_options = 0, choice = 0, i,
 		    annotate = -2, zoom_dso = -2, zoom_thread = -2,
-		    browse_map = -2;
+		    annotate_f = -2, annotate_t = -2, browse_map = -2;
 
 		key = hist_browser__run(browser, ev_name, timer, arg, delay_secs);
 
@@ -887,7 +891,6 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			thread = hist_browser__selected_thread(browser);
 			dso = browser->selection->map ? browser->selection->map->dso : NULL;
 		}
-
 		switch (key) {
 		case K_TAB:
 		case K_UNTAB:
@@ -902,7 +905,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			if (!browser->has_symbols) {
 				ui_browser__warning(&browser->b, delay_secs * 2,
 			"Annotation is only available for symbolic views, "
-			"include \"sym\" in --sort to use it.");
+			"include \"sym*\" in --sort to use it.");
 				continue;
 			}
 
@@ -972,12 +975,32 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		if (!browser->has_symbols)
 			goto add_exit_option;
 
-		if (browser->selection != NULL &&
-		    browser->selection->sym != NULL &&
-		    !browser->selection->map->dso->annotate_warned &&
-		    asprintf(&options[nr_options], "Annotate %s",
-			     browser->selection->sym->name) > 0)
-			annotate = nr_options++;
+		if (sort__branch_mode == 1) {
+			bi = browser->he_selection->branch_info;
+			if (browser->selection != NULL &&
+			    bi &&
+			    bi->from.sym != NULL &&
+			    !bi->from.map->dso->annotate_warned &&
+				asprintf(&options[nr_options], "Annotate %s",
+					 bi->from.sym->name) > 0)
+				annotate_f = nr_options++;
+
+			if (browser->selection != NULL &&
+			    bi &&
+			    bi->to.sym != NULL &&
+			    !bi->to.map->dso->annotate_warned &&
+				asprintf(&options[nr_options], "Annotate %s",
+					 bi->to.sym->name) > 0)
+				annotate_t = nr_options++;
+		} else {
+
+			if (browser->selection != NULL &&
+			    browser->selection->sym != NULL &&
+			    !browser->selection->map->dso->annotate_warned &&
+				asprintf(&options[nr_options], "Annotate %s",
+					 browser->selection->sym->name) > 0)
+				annotate = nr_options++;
+		}
 
 		if (thread != NULL &&
 		    asprintf(&options[nr_options], "Zoom %s %s(%d) thread",
@@ -1010,13 +1033,28 @@ add_exit_option:
 		if (choice == -1)
 			continue;
 
-		if (choice == annotate) {
+		if (choice == annotate || choice == annotate_t || choice == annotate_f) {
 			struct hist_entry *he;
 			int err;
 do_annotate:
 			he = hist_browser__selected_entry(browser);
 			if (he == NULL)
 				continue;
+
+			/*
+			 * we stash the branch_info symbol + map into the
+			 * the ms so we don't have to rewrite all the annotation
+			 * code to use branch_info.
+			 * in branch mode, the ms struct is not used
+			 */
+			if (choice == annotate_f) {
+				he->ms.sym = he->branch_info->from.sym;
+				he->ms.map = he->branch_info->from.map;
+			}  else if (choice == annotate_t) {
+				he->ms.sym = he->branch_info->to.sym;
+				he->ms.map = he->branch_info->to.map;
+			}
+
 			/*
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
