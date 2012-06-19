Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab2FSSAW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:00:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:43333 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab2FSSAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:00:15 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 13/20] perf tools: Move all users of event_name to perf_evsel__name
Date: Tue, 19 Jun 2012 14:50:14 -0300
Message-Id: <1340128221-17348-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1340128221-17348-1-git-send-email-acme@infradead.org>
References: <1340128221-17348-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

So that we don't use global variables that could make us misreport event
names when having a multi window top, for instance.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-mccancovi1u0wdkg8ncth509@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-evlist.c    |    2 +-
 tools/perf/builtin-record.c    |    4 ++--
 tools/perf/builtin-report.c    |    6 +++---
 tools/perf/builtin-stat.c      |   12 ++++++------
 tools/perf/builtin-test.c      |    2 +-
 tools/perf/builtin-top.c       |   10 +++++-----
 tools/perf/ui/browsers/hists.c |   15 ++++-----------
 tools/perf/ui/gtk/browser.c    |    2 +-
 tools/perf/util/evsel.c        |   26 +++++++++++++-------------
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/header.c       |    2 +-
 tools/perf/util/parse-events.c |    7 -------
 tools/perf/util/parse-events.h |    1 -
 tools/perf/util/session.c      |    2 +-
 tools/perf/util/top.c          |    2 +-
 15 files changed, 40 insertions(+), 55 deletions(-)

diff --git a/tools/perf/builtin-evlist.c b/tools/perf/builtin-evlist.c
index acd78dc..0dd5a05 100644
--- a/tools/perf/builtin-evlist.c
+++ b/tools/perf/builtin-evlist.c
@@ -60,7 +60,7 @@ static int __cmd_evlist(const char *input_name, struct perf_attr_details *detail
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		bool first = true;
 
-		printf("%s", event_name(pos));
+		printf("%s", perf_evsel__name(pos));
 
 		if (details->verbose || details->freq) {
 			comma_printf(&first, " sample_freq=%" PRIu64,
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f95840d..f5a6452 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -265,7 +265,7 @@ try_again:
 
 			if (err == ENOENT) {
 				ui__error("The %s event is not supported.\n",
-					    event_name(pos));
+					  perf_evsel__name(pos));
 				exit(EXIT_FAILURE);
 			}
 
@@ -916,7 +916,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
-		if (perf_header__push_event(pos->attr.config, event_name(pos)))
+		if (perf_header__push_event(pos->attr.config, perf_evsel__name(pos)))
 			goto out_free_fd;
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 25249f7..ea8ce8e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -230,7 +230,7 @@ static int process_read_event(struct perf_tool *tool,
 	struct perf_report *rep = container_of(tool, struct perf_report, tool);
 
 	if (rep->show_threads) {
-		const char *name = evsel ? event_name(evsel) : "unknown";
+		const char *name = evsel ? perf_evsel__name(evsel) : "unknown";
 		perf_read_values_add_value(&rep->show_threads_values,
 					   event->read.pid, event->read.tid,
 					   event->read.id,
@@ -239,7 +239,7 @@ static int process_read_event(struct perf_tool *tool,
 	}
 
 	dump_printf(": %d %d %s %" PRIu64 "\n", event->read.pid, event->read.tid,
-		    evsel ? event_name(evsel) : "FAIL",
+		    evsel ? perf_evsel__name(evsel) : "FAIL",
 		    event->read.value);
 
 	return 0;
@@ -314,7 +314,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct hists *hists = &pos->hists;
-		const char *evname = event_name(pos);
+		const char *evname = perf_evsel__name(pos);
 
 		hists__fprintf_nr_sample_events(hists, evname, stdout);
 		hists__fprintf(hists, NULL, false, true, 0, 0, stdout);
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2625899..875bf26 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -391,7 +391,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 
 	if (verbose) {
 		fprintf(output, "%s: %" PRIu64 " %" PRIu64 " %" PRIu64 "\n",
-			event_name(counter), count[0], count[1], count[2]);
+			perf_evsel__name(counter), count[0], count[1], count[2]);
 	}
 
 	/*
@@ -496,7 +496,7 @@ static int run_perf_stat(int argc __used, const char **argv)
 			    errno == ENXIO) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
-						    event_name(counter));
+						    perf_evsel__name(counter));
 				counter->supported = false;
 				continue;
 			}
@@ -594,7 +594,7 @@ static void nsec_printout(int cpu, struct perf_evsel *evsel, double avg)
 			csv_output ? 0 : -4,
 			evsel_list->cpus->map[cpu], csv_sep);
 
-	fprintf(output, fmt, cpustr, msecs, csv_sep, event_name(evsel));
+	fprintf(output, fmt, cpustr, msecs, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -792,7 +792,7 @@ static void abs_printout(int cpu, struct perf_evsel *evsel, double avg)
 	else
 		cpu = 0;
 
-	fprintf(output, fmt, cpustr, avg, csv_sep, event_name(evsel));
+	fprintf(output, fmt, cpustr, avg, csv_sep, perf_evsel__name(evsel));
 
 	if (evsel->cgrp)
 		fprintf(output, "%s%s", csv_sep, evsel->cgrp->name);
@@ -908,7 +908,7 @@ static void print_counter_aggr(struct perf_evsel *counter)
 			counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 			csv_sep,
 			csv_output ? 0 : -24,
-			event_name(counter));
+			perf_evsel__name(counter));
 
 		if (counter->cgrp)
 			fprintf(output, "%s%s", csv_sep, counter->cgrp->name);
@@ -961,7 +961,7 @@ static void print_counter(struct perf_evsel *counter)
 				counter->supported ? CNTR_NOT_COUNTED : CNTR_NOT_SUPPORTED,
 				csv_sep,
 				csv_output ? 0 : -24,
-				event_name(counter));
+				perf_evsel__name(counter));
 
 			if (counter->cgrp)
 				fprintf(output, "%s%s",
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5a8727c..5ce3030 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -583,7 +583,7 @@ static int test__basic_mmap(void)
 		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
 			pr_debug("expected %d %s events, got %d\n",
 				 expected_nr_events[evsel->idx],
-				 event_name(evsel), nr_events[evsel->idx]);
+				 perf_evsel__name(evsel), nr_events[evsel->idx]);
 			goto out_munmap;
 		}
 	}
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 6bb0277..8090a28 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -245,7 +245,7 @@ static void perf_top__show_details(struct perf_top *top)
 	if (notes->src == NULL)
 		goto out_unlock;
 
-	printf("Showing %s for %s\n", event_name(top->sym_evsel), symbol->name);
+	printf("Showing %s for %s\n", perf_evsel__name(top->sym_evsel), symbol->name);
 	printf("  Events  Pcnt (>=%d%%)\n", top->sym_pcnt_filter);
 
 	more = symbol__annotate_printf(symbol, he->ms.map, top->sym_evsel->idx,
@@ -408,7 +408,7 @@ static void perf_top__print_mapped_keys(struct perf_top *top)
 	fprintf(stdout, "\t[e]     display entries (lines).           \t(%d)\n", top->print_entries);
 
 	if (top->evlist->nr_entries > 1)
-		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", event_name(top->sym_evsel));
+		fprintf(stdout, "\t[E]     active event counter.              \t(%s)\n", perf_evsel__name(top->sym_evsel));
 
 	fprintf(stdout, "\t[f]     profile display filter (count).    \t(%d)\n", top->count_filter);
 
@@ -503,13 +503,13 @@ static void perf_top__handle_keypress(struct perf_top *top, int c)
 				fprintf(stderr, "\nAvailable events:");
 
 				list_for_each_entry(top->sym_evsel, &top->evlist->entries, node)
-					fprintf(stderr, "\n\t%d %s", top->sym_evsel->idx, event_name(top->sym_evsel));
+					fprintf(stderr, "\n\t%d %s", top->sym_evsel->idx, perf_evsel__name(top->sym_evsel));
 
 				prompt_integer(&counter, "Enter details event counter");
 
 				if (counter >= top->evlist->nr_entries) {
 					top->sym_evsel = list_entry(top->evlist->entries.next, struct perf_evsel, node);
-					fprintf(stderr, "Sorry, no such event, using %s.\n", event_name(top->sym_evsel));
+					fprintf(stderr, "Sorry, no such event, using %s.\n", perf_evsel__name(top->sym_evsel));
 					sleep(1);
 					break;
 				}
@@ -960,7 +960,7 @@ try_again:
 
 			if (err == ENOENT) {
 				ui__error("The %s event is not supported.\n",
-					    event_name(counter));
+					  perf_evsel__name(counter));
 				goto out_err;
 			} else if (err == EMFILE) {
 				ui__error("Too many events are opened.\n"
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index f556e5f..482f051 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -1367,7 +1367,7 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	struct perf_evsel *evsel = list_entry(entry, struct perf_evsel, node);
 	bool current_entry = ui_browser__is_current_entry(browser, row);
 	unsigned long nr_events = evsel->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-	const char *ev_name = event_name(evsel);
+	const char *ev_name = perf_evsel__name(evsel);
 	char bf[256], unit;
 	const char *warn = " ";
 	size_t printed;
@@ -1435,7 +1435,7 @@ browse_hists:
 			 */
 			if (timer)
 				timer(arg);
-			ev_name = event_name(pos);
+			ev_name = perf_evsel__name(pos);
 			key = perf_evsel__hists_browse(pos, nr_events, help,
 						       ev_name, true, timer,
 						       arg, delay_secs);
@@ -1504,17 +1504,11 @@ static int __perf_evlist__tui_browse_hists(struct perf_evlist *evlist,
 	ui_helpline__push("Press ESC to exit");
 
 	list_for_each_entry(pos, &evlist->entries, node) {
-		const char *ev_name = event_name(pos);
+		const char *ev_name = perf_evsel__name(pos);
 		size_t line_len = strlen(ev_name) + 7;
 
 		if (menu.b.width < line_len)
 			menu.b.width = line_len;
-		/*
-		 * Cache the evsel name, tracepoints have a _high_ cost per
-		 * event_name() call.
-		 */
-		if (pos->name == NULL)
-			pos->name = strdup(ev_name);
 	}
 
 	return perf_evsel_menu__run(&menu, evlist->nr_entries, help, timer,
@@ -1525,11 +1519,10 @@ int perf_evlist__tui_browse_hists(struct perf_evlist *evlist, const char *help,
 				  void(*timer)(void *arg), void *arg,
 				  int delay_secs)
 {
-
 	if (evlist->nr_entries == 1) {
 		struct perf_evsel *first = list_entry(evlist->entries.next,
 						      struct perf_evsel, node);
-		const char *ev_name = event_name(first);
+		const char *ev_name = perf_evsel__name(first);
 		return perf_evsel__hists_browse(first, evlist->nr_entries, help,
 						ev_name, false, timer, arg,
 						delay_secs);
diff --git a/tools/perf/ui/gtk/browser.c b/tools/perf/ui/gtk/browser.c
index fd41e8d..ec12e0b 100644
--- a/tools/perf/ui/gtk/browser.c
+++ b/tools/perf/ui/gtk/browser.c
@@ -199,7 +199,7 @@ int perf_evlist__gtk_browse_hists(struct perf_evlist *evlist,
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct hists *hists = &pos->hists;
-		const char *evname = event_name(pos);
+		const char *evname = perf_evsel__name(pos);
 		GtkWidget *scrolled_window;
 		GtkWidget *tab_label;
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2ddc812..236bdf2 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -252,42 +252,42 @@ static int perf_evsel__hw_cache_name(struct perf_evsel *evsel, char *bf, size_t
 	return ret + perf_evsel__add_modifiers(evsel, bf + ret, size - ret);
 }
 
-static int perf_evsel__tracepoint_name(struct perf_evsel *evsel, char *bf, size_t size)
+const char *perf_evsel__name(struct perf_evsel *evsel)
 {
-	return scnprintf(bf, size, "%s", evsel->name ?: "unknown tracepoint");
-}
+	char bf[128];
 
-int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size)
-{
-	int ret;
+	if (evsel->name)
+		return evsel->name;
 
 	switch (evsel->attr.type) {
 	case PERF_TYPE_RAW:
-		ret = scnprintf(bf, size, "raw 0x%" PRIx64, evsel->attr.config);
+		scnprintf(bf, sizeof(bf), "raw 0x%" PRIx64, evsel->attr.config);
 		break;
 
 	case PERF_TYPE_HARDWARE:
-		ret = perf_evsel__hw_name(evsel, bf, size);
+		perf_evsel__hw_name(evsel, bf, sizeof(bf));
 		break;
 
 	case PERF_TYPE_HW_CACHE:
-		ret = perf_evsel__hw_cache_name(evsel, bf, size);
+		perf_evsel__hw_cache_name(evsel, bf, sizeof(bf));
 		break;
 
 	case PERF_TYPE_SOFTWARE:
-		ret = perf_evsel__sw_name(evsel, bf, size);
+		perf_evsel__sw_name(evsel, bf, sizeof(bf));
 		break;
 
 	case PERF_TYPE_TRACEPOINT:
-		ret = perf_evsel__tracepoint_name(evsel, bf, size);
+		scnprintf(bf, sizeof(bf), "%s", "unknown tracepoint");
 		break;
 
 	default:
-		ret = scnprintf(bf, size, "%s", "unknown attr type");
+		scnprintf(bf, sizeof(bf), "%s", "unknown attr type");
 		break;
 	}
 
-	return ret;
+	evsel->name = strdup(bf);
+
+	return evsel->name ?: "unknown";
 }
 
 void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 9ae64d9..c936feb 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -100,7 +100,7 @@ int __perf_evsel__hw_cache_name(u64 config, char *bf, size_t size);
 const char *__perf_evsel__hw_name(u64 config);
 const char *__perf_evsel__sw_name(u64 config);
 
-int perf_evsel__name(struct perf_evsel *evsel, char *bf, size_t size);
+const char *perf_evsel__name(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 2dd5edf..07c8f37 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -641,7 +641,7 @@ static int write_event_desc(int fd, struct perf_header *h __used,
 		/*
 		 * write event string as passed on cmdline
 		 */
-		ret = do_write_string(fd, event_name(attr));
+		ret = do_write_string(fd, perf_evsel__name(attr));
 		if (ret < 0)
 			return ret;
 		/*
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d73690b..517e647 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -201,13 +201,6 @@ const char *event_type(int type)
 	return "unknown";
 }
 
-const char *event_name(struct perf_evsel *evsel)
-{
-	static char bf[128];
-	perf_evsel__name(evsel, bf, sizeof(bf));
-	return bf;
-}
-
 const char *__event_name(int type, u64 config)
 {
 	static char buf[32];
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 8cac57a..d7eb070 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -26,7 +26,6 @@ extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
 extern bool have_tracepoints(struct list_head *evlist);
 
 const char *event_type(int type);
-const char *event_name(struct perf_evsel *event);
 extern const char *__event_name(int type, u64 config);
 
 extern int parse_events_option(const struct option *opt, const char *str,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 2600916..582ee38 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1439,7 +1439,7 @@ size_t perf_session__fprintf_nr_events(struct perf_session *session, FILE *fp)
 	ret += hists__fprintf_nr_events(&session->hists, fp);
 
 	list_for_each_entry(pos, &session->evlist->entries, node) {
-		ret += fprintf(fp, "%s stats:\n", event_name(pos));
+		ret += fprintf(fp, "%s stats:\n", perf_evsel__name(pos));
 		ret += hists__fprintf_nr_events(&pos->hists, fp);
 	}
 
diff --git a/tools/perf/util/top.c b/tools/perf/util/top.c
index abe0e8e..7eeebce 100644
--- a/tools/perf/util/top.c
+++ b/tools/perf/util/top.c
@@ -65,7 +65,7 @@ size_t perf_top__header_snprintf(struct perf_top *top, char *bf, size_t size)
 				top->freq ? "Hz" : "");
 	}
 
-	ret += SNPRINTF(bf + ret, size - ret, "%s", event_name(top->sym_evsel));
+	ret += SNPRINTF(bf + ret, size - ret, "%s", perf_evsel__name(top->sym_evsel));
 
 	ret += SNPRINTF(bf + ret, size - ret, "], ");
 
-- 
1.7.1

