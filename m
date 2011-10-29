Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933709Ab1J2R0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:26:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36997 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933496Ab1J2R0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:26:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf hists browser: Warn about lost events
Date: Sat, 29 Oct 2011 15:25:50 -0200
Message-Id: <1319909151-11432-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319909151-11432-1-git-send-email-acme@infradead.org>
References: <1319909151-11432-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Just like the old perf top --tui and the --stdio version.

But because we have the initial menu to choose which event to show in a
session with multiple events we can see how many chunks were lost in
each of the event types, clarifying which events are being affected the
most.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-todvhe1xle9f0z2gf8jiyvxj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-top.c            |   41 +++++++++++++++++++++--------
 tools/perf/util/hist.h              |    1 +
 tools/perf/util/session.c           |   29 ++++++++++++++++----
 tools/perf/util/top.h               |    1 -
 tools/perf/util/ui/browser.c        |   21 ++++++++++++---
 tools/perf/util/ui/browser.h        |    3 +-
 tools/perf/util/ui/browsers/hists.c |   49 ++++++++++++++++++++++++++++++----
 7 files changed, 116 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 31aa82c..c8d31d9 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -89,6 +89,7 @@ static bool			vmlinux_warned;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
+static bool			sample_id_all_avail		=   true;
 static unsigned int		mmap_pages			=    128;
 
 static bool			dump_symtab                     =  false;
@@ -289,11 +290,13 @@ static void print_sym_table(void)
 
 	printf("%-*.*s\n", win_width, win_width, graph_dotted_line);
 
-	if (top.total_lost_warned != top.session->hists.stats.total_lost) {
-		top.total_lost_warned = top.session->hists.stats.total_lost;
-		color_fprintf(stdout, PERF_COLOR_RED, "WARNING:");
-		printf(" LOST %" PRIu64 " events, Check IO/CPU overload\n",
-		       top.total_lost_warned);
+	if (top.sym_evsel->hists.stats.nr_lost_warned !=
+	    top.sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST]) {
+		top.sym_evsel->hists.stats.nr_lost_warned =
+			top.sym_evsel->hists.stats.nr_events[PERF_RECORD_LOST];
+		color_fprintf(stdout, PERF_COLOR_RED,
+			      "WARNING: LOST %d chunks, Check IO/CPU overload",
+			      top.sym_evsel->hists.stats.nr_lost_warned);
 		++printed;
 	}
 
@@ -671,6 +674,7 @@ static int symbol_filter(struct map *map __used, struct symbol *sym)
 }
 
 static void perf_event__process_sample(const union perf_event *event,
+				       struct perf_evsel *evsel,
 				       struct perf_sample *sample,
 				       struct perf_session *session)
 {
@@ -770,12 +774,8 @@ static void perf_event__process_sample(const union perf_event *event,
 	}
 
 	if (al.sym == NULL || !al.sym->ignore) {
-		struct perf_evsel *evsel;
 		struct hist_entry *he;
 
-		evsel = perf_evlist__id2evsel(top.evlist, sample->id);
-		assert(evsel != NULL);
-
 		if ((sort__has_parent || symbol_conf.use_callchain) &&
 		    sample->callchain) {
 			err = perf_session__resolve_callchain(session, al.thread,
@@ -807,10 +807,13 @@ static void perf_event__process_sample(const union perf_event *event,
 static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 {
 	struct perf_sample sample;
+	struct perf_evsel *evsel;
 	union perf_event *event;
 	int ret;
 
 	while ((event = perf_evlist__mmap_read(top.evlist, idx)) != NULL) {
+		u64 id;
+
 		ret = perf_session__parse_sample(self, event, &sample);
 		if (ret) {
 			pr_err("Can't parse sample, err = %d\n", ret);
@@ -818,9 +821,17 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 		}
 
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			perf_event__process_sample(event, &sample, self);
-		else
+			id = sample.id;
+		evsel = perf_evlist__id2evsel(self->evlist, sample.id);
+		assert(evsel != NULL);
+
+		if (event->header.type == PERF_RECORD_SAMPLE)
+			perf_event__process_sample(event, evsel, &sample, self);
+		else if (event->header.type < PERF_RECORD_MAX) {
+			hists__inc_nr_events(&evsel->hists, event->header.type);
 			perf_event__process(event, &sample, self);
+		} else
+			++self->hists.stats.nr_unknown_events;
 	}
 }
 
@@ -864,6 +875,8 @@ static void start_counters(struct perf_evlist *evlist)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = inherit;
+retry_sample_id:
+		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 try_again:
 		if (perf_evsel__open(counter, top.evlist->cpus,
 				     top.evlist->threads, group,
@@ -873,6 +886,12 @@ try_again:
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				goto out_err;
+			} else if (err == EINVAL && sample_id_all_avail) {
+				/*
+				 * Old kernel, no attr->sample_id_type_all field
+				 */
+				sample_id_all_avail = false;
+				goto retry_sample_id;
 			}
 			/*
 			 * If it's cycles then fall back to hrtimer
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index ff93ddc..c86c1d2 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -28,6 +28,7 @@ struct events_stats {
 	u64 total_lost;
 	u64 total_invalid_chains;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
+	u32 nr_lost_warned;
 	u32 nr_unknown_events;
 	u32 nr_invalid_chains;
 	u32 nr_unknown_id;
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 91c6442..da354fe 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -738,10 +738,27 @@ static int perf_session_deliver_event(struct perf_session *session,
 
 	dump_event(session, event, file_offset, sample);
 
+	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
+	if (evsel != NULL && event->header.type != PERF_RECORD_SAMPLE) {
+		/*
+		 * XXX We're leaving PERF_RECORD_SAMPLE unnacounted here
+		 * because the tools right now may apply filters, discarding
+		 * some of the samples. For consistency, in the future we
+		 * should have something like nr_filtered_samples and remove
+		 * the sample->period from total_sample_period, etc, KISS for
+		 * now tho.
+		 *
+		 * Also testing against NULL allows us to handle files without
+		 * attr.sample_id_all and/or without PERF_SAMPLE_ID. In the
+		 * future probably it'll be a good idea to restrict event
+		 * processing via perf_session to files with both set.
+		 */
+		hists__inc_nr_events(&evsel->hists, event->header.type);
+	}
+
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
 		dump_sample(session, event, sample);
-		evsel = perf_evlist__id2evsel(session->evlist, sample->id);
 		if (evsel == NULL) {
 			++session->hists.stats.nr_unknown_id;
 			return -1;
@@ -874,11 +891,11 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 					    const struct perf_event_ops *ops)
 {
 	if (ops->lost == perf_event__process_lost &&
-	    session->hists.stats.total_lost != 0) {
-		ui__warning("Processed %" PRIu64 " events and LOST %" PRIu64
-			    "!\n\nCheck IO/CPU overload!\n\n",
-			    session->hists.stats.total_period,
-			    session->hists.stats.total_lost);
+	    session->hists.stats.nr_events[PERF_RECORD_LOST] != 0) {
+		ui__warning("Processed %d events and lost %d chunks!\n\n"
+			    "Check IO/CPU overload!\n\n",
+			    session->hists.stats.nr_events[0],
+			    session->hists.stats.nr_events[PERF_RECORD_LOST]);
 	}
 
 	if (session->hists.stats.nr_unknown_events != 0) {
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 01d1057..3996509 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -19,7 +19,6 @@ struct perf_top {
 	u64		   kernel_samples, us_samples;
 	u64		   exact_samples;
 	u64		   guest_us_samples, guest_kernel_samples;
-	u64		   total_lost_warned;
 	int		   print_entries, count_filter, delay_secs;
 	int		   freq;
 	pid_t		   target_pid, target_tid;
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index d2051be..5568291 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -176,16 +176,29 @@ void ui_browser__handle_resize(struct ui_browser *browser)
 	ui_browser__refresh(browser);
 }
 
-int ui_browser__warning(struct ui_browser *browser, const char *format, ...)
+int ui_browser__warning(struct ui_browser *browser, int timeout,
+			const char *format, ...)
 {
 	va_list args;
-	int key;
+	char *text;
+	int key = 0, err;
 
 	va_start(args, format);
-	while ((key = __ui__warning("Warning!", format, args)) == K_RESIZE)
-		ui_browser__handle_resize(browser);
+	err = vasprintf(&text, format, args);
 	va_end(args);
 
+	if (err < 0) {
+		va_start(args, format);
+		ui_helpline__vpush(format, args);
+		va_end(args);
+	} else {
+		while ((key == ui__question_window("Warning!", text,
+						   "Press any key...",
+						   timeout)) == K_RESIZE)
+			ui_browser__handle_resize(browser);
+		free(text);
+	}
+
 	return key;
 }
 
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index fb1c598..84d761b 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -45,7 +45,8 @@ int ui_browser__run(struct ui_browser *browser, int delay_secs);
 void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
 void ui_browser__handle_resize(struct ui_browser *browser);
 
-int ui_browser__warning(struct ui_browser *browser, const char *format, ...);
+int ui_browser__warning(struct ui_browser *browser, int timeout,
+			const char *format, ...);
 int ui_browser__help_window(struct ui_browser *browser, const char *text);
 bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index b8733c0..d0c94b4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -295,6 +295,15 @@ static void hist_browser__set_folding(struct hist_browser *self, bool unfold)
 	ui_browser__reset_index(&self->b);
 }
 
+static void ui_browser__warn_lost_events(struct ui_browser *browser)
+{
+	ui_browser__warning(browser, 4,
+		"Events are being lost, check IO/CPU overload!\n\n"
+		"You may want to run 'perf' using a RT scheduler policy:\n\n"
+		" perf top -r 80\n\n"
+		"Or reduce the sampling frequency.");
+}
+
 static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 			     void(*timer)(void *arg), void *arg, int delay_secs)
 {
@@ -318,8 +327,15 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 		case K_TIMER:
 			timer(arg);
 			ui_browser__update_nr_entries(&self->b, self->hists->nr_entries);
-			hists__browser_title(self->hists, title, sizeof(title),
-					     ev_name);
+
+			if (self->hists->stats.nr_lost_warned !=
+			    self->hists->stats.nr_events[PERF_RECORD_LOST]) {
+				self->hists->stats.nr_lost_warned =
+					self->hists->stats.nr_events[PERF_RECORD_LOST];
+				ui_browser__warn_lost_events(&self->b);
+			}
+
+			hists__browser_title(self->hists, title, sizeof(title), ev_name);
 			ui_browser__show_title(&self->b, title);
 			continue;
 		case 'D': { /* Debug */
@@ -883,7 +899,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 			goto out_free_stack;
 		case 'a':
 			if (!browser->has_symbols) {
-				ui_browser__warning(&browser->b,
+				ui_browser__warning(&browser->b, delay_secs * 2,
 			"Annotation is only available for symbolic views, "
 			"include \"sym\" in --sort to use it.");
 				continue;
@@ -1061,6 +1077,7 @@ out:
 struct perf_evsel_menu {
 	struct ui_browser b;
 	struct perf_evsel *selection;
+	bool lost_events, lost_events_warned;
 };
 
 static void perf_evsel_menu__write(struct ui_browser *browser,
@@ -1073,14 +1090,29 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
 	unsigned long nr_events = evsel->hists.stats.nr_events[PERF_RECORD_SAMPLE];
 	const char *ev_name = event_name(evsel);
 	char bf[256], unit;
+	const char *warn = " ";
+	size_t printed;
 
 	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
 						       HE_COLORSET_NORMAL);
 
 	nr_events = convert_unit(nr_events, &unit);
-	snprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
-		 unit, unit == ' ' ? "" : " ", ev_name);
-	slsmg_write_nstring(bf, browser->width);
+	printed = snprintf(bf, sizeof(bf), "%lu%c%s%s", nr_events,
+			   unit, unit == ' ' ? "" : " ", ev_name);
+	slsmg_printf("%s", bf);
+
+	nr_events = evsel->hists.stats.nr_events[PERF_RECORD_LOST];
+	if (nr_events != 0) {
+		menu->lost_events = true;
+		if (!current_entry)
+			ui_browser__set_color(browser, HE_COLORSET_TOP);
+		nr_events = convert_unit(nr_events, &unit);
+		snprintf(bf, sizeof(bf), ": %ld%c%schunks LOST!", nr_events,
+			 unit, unit == ' ' ? "" : " ");
+		warn = bf;
+	}
+
+	slsmg_write_nstring(warn, browser->width - printed);
 
 	if (current_entry)
 		menu->selection = evsel;
@@ -1105,6 +1137,11 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
 		switch (key) {
 		case K_TIMER:
 			timer(arg);
+
+			if (!menu->lost_events_warned && menu->lost_events) {
+				ui_browser__warn_lost_events(&menu->b);
+				menu->lost_events_warned = true;
+			}
 			continue;
 		case K_RIGHT:
 		case K_ENTER:
-- 
1.6.2.5

