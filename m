Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752047Ab1KGSvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 13:51:04 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41842 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105Ab1KGSvA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 13:51:00 -0500
Date: Mon, 7 Nov 2011 19:49:13 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] perf fixes
Message-ID: <20111107184913.GA16947@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

This should finally solve the window resizing problem of the TUI: 
perf report and perf top will resize properly with xterm size 
changes.

 Thanks,

	Ingo

------------------>
Arnaldo Carvalho de Melo (16):
      perf evlist: Fix grouping of multiple events
      perf ui progress: Reimplement using slang
      perf ui: Improve handling sigwinch a bit
      perf ui: Reimplement ui_helpline using libslang
      perf ui: Reimplement ui__popup_menu using ui__browser
      perf ui: Reimplement the popup windows using libslang
      perf ui: Rename ui__warning_paranoid to ui__error_paranoid
      perf hists browser: Use K_TIMER
      perf ui browser: No need to switch char sets that often
      perf ui browser: Handle K_RESIZE in dialog windows
      perf header: Fix build on old systems
      perf hists: Fix recalculation of total_period when sorting entries
      perf hists browser: Warn about lost events
      perf report: Add progress bar when processing time ordered events
      perf top tui: Don't recalc column widths considering just the first page
      perf top: Fix live annotation in the --stdio interface

Masami Hiramatsu (1):
      perf tools: Fix a typo of command name as trace-cmd


 tools/perf/builtin-record.c            |   13 ++-
 tools/perf/builtin-stat.c              |   20 +++-
 tools/perf/builtin-test.c              |    6 +-
 tools/perf/builtin-top.c               |   54 +++++++---
 tools/perf/util/annotate.c             |    9 +-
 tools/perf/util/debug.c                |    7 +-
 tools/perf/util/debug.h                |   17 +--
 tools/perf/util/evlist.c               |   30 +++++
 tools/perf/util/evlist.h               |    2 +
 tools/perf/util/evsel.c                |   43 ++++++--
 tools/perf/util/evsel.h                |   10 ++-
 tools/perf/util/header.c               |    2 +-
 tools/perf/util/hist.c                 |    3 +-
 tools/perf/util/hist.h                 |    1 +
 tools/perf/util/python.c               |   31 +++++-
 tools/perf/util/session.c              |   46 ++++++--
 tools/perf/util/session.h              |    1 +
 tools/perf/util/top.h                  |    1 -
 tools/perf/util/trace-event-info.c     |    2 +-
 tools/perf/util/ui/browser.c           |  151 ++++++++++++++++++---------
 tools/perf/util/ui/browser.h           |    9 ++
 tools/perf/util/ui/browsers/annotate.c |   14 +--
 tools/perf/util/ui/browsers/hists.c    |   74 ++++++++++---
 tools/perf/util/ui/helpline.c          |   16 ++-
 tools/perf/util/ui/helpline.h          |    2 +
 tools/perf/util/ui/progress.c          |   65 +++---------
 tools/perf/util/ui/progress.h          |    7 +-
 tools/perf/util/ui/setup.c             |   83 ++++++++++++++-
 tools/perf/util/ui/ui.h                |    3 +
 tools/perf/util/ui/util.c              |  182 +++++++++++++++++++-------------
 tools/perf/util/ui/util.h              |    8 +-
 31 files changed, 624 insertions(+), 288 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f82480f..6ab58cc 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -262,13 +262,16 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 
 static void open_counters(struct perf_evlist *evlist)
 {
-	struct perf_evsel *pos;
+	struct perf_evsel *pos, *first;
 
 	if (evlist->cpus->map[0] < 0)
 		no_inherit = true;
 
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
+		struct xyarray *group_fd = NULL;
 		/*
 		 * Check if parse_single_tracepoint_event has already asked for
 		 * PERF_SAMPLE_TIME.
@@ -283,15 +286,19 @@ static void open_counters(struct perf_evlist *evlist)
 		 */
 		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
+		if (group && pos != first)
+			group_fd = first->fd;
+
 		config_attr(pos, evlist);
 retry_sample_id:
 		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 try_again:
-		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group) < 0) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads, group,
+				     group_fd) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
-				ui__warning_paranoid();
+				ui__error_paranoid();
 				exit(EXIT_FAILURE);
 			} else if (err ==  ENODEV && cpu_list) {
 				die("No such device - did you specify"
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7ce65f5..7d98676 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -278,9 +278,14 @@ struct stats			runtime_itlb_cache_stats[MAX_NR_CPUS];
 struct stats			runtime_dtlb_cache_stats[MAX_NR_CPUS];
 struct stats			walltime_nsecs_stats;
 
-static int create_perf_stat_counter(struct perf_evsel *evsel)
+static int create_perf_stat_counter(struct perf_evsel *evsel,
+				    struct perf_evsel *first)
 {
 	struct perf_event_attr *attr = &evsel->attr;
+	struct xyarray *group_fd = NULL;
+
+	if (group && evsel != first)
+		group_fd = first->fd;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -289,14 +294,15 @@ static int create_perf_stat_counter(struct perf_evsel *evsel)
 	attr->inherit = !no_inherit;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus, group);
-
+		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
+						group, group_fd);
 	if (target_pid == -1 && target_tid == -1) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads, group);
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads,
+					   group, group_fd);
 }
 
 /*
@@ -396,7 +402,7 @@ static int read_counter(struct perf_evsel *counter)
 static int run_perf_stat(int argc __used, const char **argv)
 {
 	unsigned long long t0, t1;
-	struct perf_evsel *counter;
+	struct perf_evsel *counter, *first;
 	int status = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
@@ -453,8 +459,10 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
+	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
+
 	list_for_each_entry(counter, &evsel_list->entries, node) {
-		if (create_perf_stat_counter(counter) < 0) {
+		if (create_perf_stat_counter(counter, first) < 0) {
 			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index efe696f..831d1ba 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -291,7 +291,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads, false, NULL) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -366,7 +366,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, false, NULL) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -531,7 +531,7 @@ static int test__basic_mmap(void)
 
 		perf_evlist__add(evlist, evsels[i]);
 
-		if (perf_evsel__open(evsels[i], cpus, threads, false) < 0) {
+		if (perf_evsel__open(evsels[i], cpus, threads, false, NULL) < 0) {
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 				 strerror(errno));
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 7a87171..c9cdedb 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -89,6 +89,7 @@ static bool			vmlinux_warned;
 static bool			inherit				=  false;
 static int			realtime_prio			=      0;
 static bool			group				=  false;
+static bool			sample_id_all_avail		=   true;
 static unsigned int		mmap_pages			=    128;
 
 static bool			dump_symtab                     =  false;
@@ -199,7 +200,8 @@ static void record_precise_ip(struct hist_entry *he, int counter, u64 ip)
 	struct symbol *sym;
 
 	if (he == NULL || he->ms.sym == NULL ||
-	    (he != top.sym_filter_entry && use_browser != 1))
+	    ((top.sym_filter_entry == NULL ||
+	      top.sym_filter_entry->ms.sym != he->ms.sym) && use_browser != 1))
 		return;
 
 	sym = he->ms.sym;
@@ -289,11 +291,13 @@ static void print_sym_table(void)
 
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
 
@@ -561,7 +565,6 @@ static void perf_top__sort_new_samples(void *arg)
 	hists__decay_entries_threaded(&t->sym_evsel->hists,
 				      top.hide_user_symbols,
 				      top.hide_kernel_symbols);
-	hists__output_recalc_col_len(&t->sym_evsel->hists, winsize.ws_row - 3);
 }
 
 static void *display_thread_tui(void *arg __used)
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
@@ -807,6 +807,7 @@ static void perf_event__process_sample(const union perf_event *event,
 static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 {
 	struct perf_sample sample;
+	struct perf_evsel *evsel;
 	union perf_event *event;
 	int ret;
 
@@ -817,10 +818,16 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 			continue;
 		}
 
+		evsel = perf_evlist__id2evsel(self->evlist, sample.id);
+		assert(evsel != NULL);
+
 		if (event->header.type == PERF_RECORD_SAMPLE)
-			perf_event__process_sample(event, &sample, self);
-		else
+			perf_event__process_sample(event, evsel, &sample, self);
+		else if (event->header.type < PERF_RECORD_MAX) {
+			hists__inc_nr_events(&evsel->hists, event->header.type);
 			perf_event__process(event, &sample, self);
+		} else
+			++self->hists.stats.nr_unknown_events;
 	}
 }
 
@@ -834,10 +841,16 @@ static void perf_session__mmap_read(struct perf_session *self)
 
 static void start_counters(struct perf_evlist *evlist)
 {
-	struct perf_evsel *counter;
+	struct perf_evsel *counter, *first;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
+		struct xyarray *group_fd = NULL;
+
+		if (group && counter != first)
+			group_fd = first->fd;
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
@@ -858,14 +871,23 @@ static void start_counters(struct perf_evlist *evlist)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = inherit;
+retry_sample_id:
+		attr->sample_id_all = sample_id_all_avail ? 1 : 0;
 try_again:
 		if (perf_evsel__open(counter, top.evlist->cpus,
-				     top.evlist->threads, group) < 0) {
+				     top.evlist->threads, group,
+				     group_fd) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
-				ui__warning_paranoid();
+				ui__error_paranoid();
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
diff --git a/tools/perf/util/annotate.c b/tools/perf/util/annotate.c
index bc8f477..119e996 100644
--- a/tools/perf/util/annotate.c
+++ b/tools/perf/util/annotate.c
@@ -310,9 +310,12 @@ fallback:
 		}
 		err = -ENOENT;
 		dso->annotate_warned = 1;
-		pr_err("Can't annotate %s: No vmlinux file%s was found in the "
-		       "path.\nPlease use 'perf buildid-cache -av vmlinux' or "
-		       "--vmlinux vmlinux.\n",
+		pr_err("Can't annotate %s:\n\n"
+		       "No vmlinux file%s\nwas found in the path.\n\n"
+		       "Please use:\n\n"
+		       "  perf buildid-cache -av vmlinux\n\n"
+		       "or:\n\n"
+		       "  --vmlinux vmlinux",
 		       sym->name, build_id_msg ?: "");
 		goto out_free_filename;
 	}
diff --git a/tools/perf/util/debug.c b/tools/perf/util/debug.c
index 155749d..26817da 100644
--- a/tools/perf/util/debug.c
+++ b/tools/perf/util/debug.c
@@ -47,19 +47,20 @@ int dump_printf(const char *fmt, ...)
 }
 
 #ifdef NO_NEWT_SUPPORT
-void ui__warning(const char *format, ...)
+int ui__warning(const char *format, ...)
 {
 	va_list args;
 
 	va_start(args, format);
 	vfprintf(stderr, format, args);
 	va_end(args);
+	return 0;
 }
 #endif
 
-void ui__warning_paranoid(void)
+int ui__error_paranoid(void)
 {
-	ui__warning("Permission error - are you root?\n"
+	return ui__error("Permission error - are you root?\n"
 		    "Consider tweaking /proc/sys/kernel/perf_event_paranoid:\n"
 		    " -1 - Not paranoid at all\n"
 		    "  0 - Disallow raw tracepoint access for unpriv\n"
diff --git a/tools/perf/util/debug.h b/tools/perf/util/debug.h
index fd53db4..f2ce88d 100644
--- a/tools/perf/util/debug.h
+++ b/tools/perf/util/debug.h
@@ -19,23 +19,18 @@ static inline int ui_helpline__show_help(const char *format __used, va_list ap _
 	return 0;
 }
 
-static inline struct ui_progress *ui_progress__new(const char *title __used,
-						   u64 total __used)
-{
-	return (struct ui_progress *)1;
-}
-
-static inline void ui_progress__update(struct ui_progress *self __used,
-				       u64 curr __used) {}
+static inline void ui_progress__update(u64 curr __used, u64 total __used,
+				       const char *title __used) {}
 
-static inline void ui_progress__delete(struct ui_progress *self __used) {}
+#define ui__error(format, arg...) ui__warning(format, ##arg)
 #else
 extern char ui_helpline__last_msg[];
 int ui_helpline__show_help(const char *format, va_list ap);
 #include "ui/progress.h"
+int ui__error(const char *format, ...) __attribute__((format(printf, 1, 2)));
 #endif
 
-void ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
-void ui__warning_paranoid(void);
+int ui__warning(const char *format, ...) __attribute__((format(printf, 1, 2)));
+int ui__error_paranoid(void);
 
 #endif	/* __PERF_DEBUG_H */
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2f6bc89..fbb4b4a 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -539,3 +539,33 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 {
 	evlist->selected = evsel;
 }
+
+int perf_evlist__open(struct perf_evlist *evlist, bool group)
+{
+	struct perf_evsel *evsel, *first;
+	int err, ncpus, nthreads;
+
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		struct xyarray *group_fd = NULL;
+
+		if (group && evsel != first)
+			group_fd = first->fd;
+
+		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads,
+				       group, group_fd);
+		if (err < 0)
+			goto out_err;
+	}
+
+	return 0;
+out_err:
+	ncpus = evlist->cpus ? evlist->cpus->nr : 1;
+	nthreads = evlist->threads ? evlist->threads->nr : 1;
+
+	list_for_each_entry_reverse(evsel, &evlist->entries, node)
+		perf_evsel__close(evsel, ncpus, nthreads);
+
+	return err;
+}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 6be71fc..1779ffe 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -50,6 +50,8 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
+int perf_evlist__open(struct perf_evlist *evlist, bool group);
+
 int perf_evlist__alloc_mmap(struct perf_evlist *evlist);
 int perf_evlist__mmap(struct perf_evlist *evlist, int pages, bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b46f6e4..e426264 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -16,6 +16,7 @@
 #include "thread_map.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
+#define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
 
 int __perf_evsel__sample_size(u64 sample_type)
 {
@@ -204,15 +205,16 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 }
 
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group)
+			      struct thread_map *threads, bool group,
+			      struct xyarray *group_fds)
 {
 	int cpu, thread;
 	unsigned long flags = 0;
-	int pid = -1;
+	int pid = -1, err;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
-		return -1;
+		return -ENOMEM;
 
 	if (evsel->cgrp) {
 		flags = PERF_FLAG_PID_CGROUP;
@@ -220,7 +222,7 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		int group_fd = -1;
+		int group_fd = group_fds ? GROUP_FD(group_fds, cpu) : -1;
 
 		for (thread = 0; thread < threads->nr; thread++) {
 
@@ -231,8 +233,10 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 								     pid,
 								     cpus->map[cpu],
 								     group_fd, flags);
-			if (FD(evsel, cpu, thread) < 0)
+			if (FD(evsel, cpu, thread) < 0) {
+				err = -errno;
 				goto out_close;
+			}
 
 			if (group && group_fd == -1)
 				group_fd = FD(evsel, cpu, thread);
@@ -249,7 +253,17 @@ out_close:
 		}
 		thread = threads->nr;
 	} while (--cpu >= 0);
-	return -1;
+	return err;
+}
+
+void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
+{
+	if (evsel->fd == NULL)
+		return;
+
+	perf_evsel__close_fd(evsel, ncpus, nthreads);
+	perf_evsel__free_fd(evsel);
+	evsel->fd = NULL;
 }
 
 static struct {
@@ -269,7 +283,8 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group)
+		     struct thread_map *threads, bool group,
+		     struct xyarray *group_fd)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -279,19 +294,23 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group);
+	return __perf_evsel__open(evsel, cpus, threads, group, group_fd);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group)
+			     struct cpu_map *cpus, bool group,
+			     struct xyarray *group_fd)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group,
+				  group_fd);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group)
+				struct thread_map *threads, bool group,
+				struct xyarray *group_fd)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group,
+				  group_fd);
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index e9a3155..b1d15e6 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -82,11 +82,15 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group);
+			     struct cpu_map *cpus, bool group,
+			     struct xyarray *group_fds);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group);
+				struct thread_map *threads, bool group,
+				struct xyarray *group_fds);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group);
+		     struct thread_map *threads, bool group,
+		     struct xyarray *group_fds);
+void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 #define perf_evsel__match(evsel, t, c)		\
 	(evsel->attr.type == PERF_TYPE_##t &&	\
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 76c0b2c..bcd05d0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,5 +1,6 @@
 #define _FILE_OFFSET_BITS 64
 
+#include "util.h"
 #include <sys/types.h>
 #include <byteswap.h>
 #include <unistd.h>
@@ -11,7 +12,6 @@
 
 #include "evlist.h"
 #include "evsel.h"
-#include "util.h"
 #include "header.h"
 #include "../perf.h"
 #include "trace-event.h"
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f6a9939..a36a3fa 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -365,7 +365,6 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 
 	root = hists__get_rotate_entries_in(hists);
 	next = rb_first(root);
-	hists->stats.total_period = 0;
 
 	while (next) {
 		n = rb_entry(next, struct hist_entry, rb_node_in);
@@ -379,7 +378,6 @@ static void __hists__collapse_resort(struct hists *hists, bool threaded)
 			 * been set by, say, the hist_browser.
 			 */
 			hists__apply_filters(hists, n);
-			hists__inc_nr_entries(hists, n);
 		}
 	}
 }
@@ -442,6 +440,7 @@ static void __hists__output_resort(struct hists *hists, bool threaded)
 	hists->entries = RB_ROOT;
 
 	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next) {
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
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 7624324..9dd47a4 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -623,7 +623,11 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
 
 	evsel->attr.inherit = inherit;
-	if (perf_evsel__open(evsel, cpus, threads, group) < 0) {
+	/*
+	 * This will group just the fds for this single evsel, to group
+	 * multiple events, use evlist.open().
+	 */
+	if (perf_evsel__open(evsel, cpus, threads, group, NULL) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
@@ -814,6 +818,25 @@ static PyObject *pyrf_evlist__read_on_cpu(struct pyrf_evlist *pevlist,
 	return Py_None;
 }
 
+static PyObject *pyrf_evlist__open(struct pyrf_evlist *pevlist,
+				   PyObject *args, PyObject *kwargs)
+{
+	struct perf_evlist *evlist = &pevlist->evlist;
+	int group = 0;
+	static char *kwlist[] = { "group", NULL };
+
+	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist, &group))
+		return NULL;
+
+	if (perf_evlist__open(evlist, group) < 0) {
+		PyErr_SetFromErrno(PyExc_OSError);
+		return NULL;
+	}
+
+	Py_INCREF(Py_None);
+	return Py_None;
+}
+
 static PyMethodDef pyrf_evlist__methods[] = {
 	{
 		.ml_name  = "mmap",
@@ -822,6 +845,12 @@ static PyMethodDef pyrf_evlist__methods[] = {
 		.ml_doc	  = PyDoc_STR("mmap the file descriptor table.")
 	},
 	{
+		.ml_name  = "open",
+		.ml_meth  = (PyCFunction)pyrf_evlist__open,
+		.ml_flags = METH_VARARGS | METH_KEYWORDS,
+		.ml_doc	  = PyDoc_STR("open the file descriptors.")
+	},
+	{
 		.ml_name  = "poll",
 		.ml_meth  = (PyCFunction)pyrf_evlist__poll,
 		.ml_flags = METH_VARARGS | METH_KEYWORDS,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 20e011c..85c1e6b7 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -502,6 +502,7 @@ static void flush_sample_queue(struct perf_session *s,
 	struct perf_sample sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
+	unsigned idx = 0, progress_next = os->nr_samples / 16;
 	int ret;
 
 	if (!ops->ordered_samples || !limit)
@@ -521,6 +522,11 @@ static void flush_sample_queue(struct perf_session *s,
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
 		list_add(&iter->list, &os->sample_cache);
+		if (++idx >= progress_next) {
+			progress_next += os->nr_samples / 16;
+			ui_progress__update(idx, os->nr_samples,
+					    "Processing time ordered events...");
+		}
 	}
 
 	if (list_empty(head)) {
@@ -529,6 +535,8 @@ static void flush_sample_queue(struct perf_session *s,
 		os->last_sample =
 			list_entry(head->prev, struct sample_queue, list);
 	}
+
+	os->nr_samples = 0;
 }
 
 /*
@@ -588,6 +596,7 @@ static void __queue_event(struct sample_queue *new, struct perf_session *s)
 	u64 timestamp = new->timestamp;
 	struct list_head *p;
 
+	++os->nr_samples;
 	os->last_sample = new;
 
 	if (!sample) {
@@ -738,10 +747,27 @@ static int perf_session_deliver_event(struct perf_session *session,
 
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
@@ -874,11 +900,11 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
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
@@ -1012,7 +1038,6 @@ int __perf_session__process_events(struct perf_session *session,
 {
 	u64 head, page_offset, file_offset, file_pos, progress_next;
 	int err, mmap_prot, mmap_flags, map_idx = 0;
-	struct ui_progress *progress;
 	size_t	page_size, mmap_size;
 	char *buf, *mmaps[8];
 	union perf_event *event;
@@ -1030,9 +1055,6 @@ int __perf_session__process_events(struct perf_session *session,
 		file_size = data_offset + data_size;
 
 	progress_next = file_size / 16;
-	progress = ui_progress__new("Processing events...", file_size);
-	if (progress == NULL)
-		return -1;
 
 	mmap_size = session->mmap_window;
 	if (mmap_size > file_size)
@@ -1095,7 +1117,8 @@ more:
 
 	if (file_pos >= progress_next) {
 		progress_next += file_size / 16;
-		ui_progress__update(progress, file_pos);
+		ui_progress__update(file_pos, file_size,
+				    "Processing events...");
 	}
 
 	if (file_pos < file_size)
@@ -1106,7 +1129,6 @@ more:
 	session->ordered_samples.next_flush = ULLONG_MAX;
 	flush_sample_queue(session, ops);
 out_err:
-	ui_progress__delete(progress);
 	perf_session__warn_about_errors(session, ops);
 	perf_session_free_sample_buffers(session);
 	return err;
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 514b06d..6e393c9 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -23,6 +23,7 @@ struct ordered_samples {
 	struct sample_queue	*sample_buffer;
 	struct sample_queue	*last_sample;
 	int			sample_buffer_idx;
+	unsigned int		nr_samples;
 };
 
 struct perf_session {
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
diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index 2d530cf..d2655f0 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -80,7 +80,7 @@ static void die(const char *fmt, ...)
 	int ret = errno;
 
 	if (errno)
-		perror("trace-cmd");
+		perror("perf");
 	else
 		ret = -1;
 
diff --git a/tools/perf/util/ui/browser.c b/tools/perf/util/ui/browser.c
index 5359f37..5568291 100644
--- a/tools/perf/util/ui/browser.c
+++ b/tools/perf/util/ui/browser.c
@@ -4,6 +4,7 @@
 #include "libslang.h"
 #include <newt.h>
 #include "ui.h"
+#include "util.h"
 #include <linux/compiler.h>
 #include <linux/list.h>
 #include <linux/rbtree.h>
@@ -168,6 +169,59 @@ void ui_browser__refresh_dimensions(struct ui_browser *self)
 	self->x = 0;
 }
 
+void ui_browser__handle_resize(struct ui_browser *browser)
+{
+	ui__refresh_dimensions(false);
+	ui_browser__show(browser, browser->title, ui_helpline__current);
+	ui_browser__refresh(browser);
+}
+
+int ui_browser__warning(struct ui_browser *browser, int timeout,
+			const char *format, ...)
+{
+	va_list args;
+	char *text;
+	int key = 0, err;
+
+	va_start(args, format);
+	err = vasprintf(&text, format, args);
+	va_end(args);
+
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
+	return key;
+}
+
+int ui_browser__help_window(struct ui_browser *browser, const char *text)
+{
+	int key;
+
+	while ((key = ui__help_window(text)) == K_RESIZE)
+		ui_browser__handle_resize(browser);
+
+	return key;
+}
+
+bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text)
+{
+	int key;
+
+	while ((key = ui__dialog_yesno(text)) == K_RESIZE)
+		ui_browser__handle_resize(browser);
+
+	return key == K_ENTER || toupper(key) == 'Y';
+}
+
 void ui_browser__reset_index(struct ui_browser *self)
 {
 	self->index = self->top_idx = 0;
@@ -230,13 +284,15 @@ static void ui_browser__scrollbar_set(struct ui_browser *browser)
 		       (browser->nr_entries - 1));
 	}
 
+	SLsmg_set_char_set(1);
+
 	while (h < height) {
 	        ui_browser__gotorc(browser, row++, col);
-		SLsmg_set_char_set(1);
-		SLsmg_write_char(h == pct ? SLSMG_DIAMOND_CHAR : SLSMG_BOARD_CHAR);
-		SLsmg_set_char_set(0);
+		SLsmg_write_char(h == pct ? SLSMG_DIAMOND_CHAR : SLSMG_CKBRD_CHAR);
 		++h;
 	}
+
+	SLsmg_set_char_set(0);
 }
 
 static int __ui_browser__refresh(struct ui_browser *browser)
@@ -291,53 +347,10 @@ void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries)
 	browser->seek(browser, browser->top_idx, SEEK_SET);
 }
 
-static int ui__getch(int delay_secs)
-{
-	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
-	fd_set read_set;
-	int err, key;
-
-	FD_ZERO(&read_set);
-	FD_SET(0, &read_set);
-
-	if (delay_secs) {
-		timeout.tv_sec = delay_secs;
-		timeout.tv_usec = 0;
-	}
-
-        err = select(1, &read_set, NULL, NULL, ptimeout);
-
-	if (err == 0)
-		return K_TIMER;
-
-	if (err == -1) {
-		if (errno == EINTR)
-			return K_RESIZE;
-		return K_ERROR;
-	}
-
-	key = SLang_getkey();
-	if (key != K_ESC)
-		return key;
-
-	FD_ZERO(&read_set);
-	FD_SET(0, &read_set);
-	timeout.tv_sec = 0;
-	timeout.tv_usec = 20;
-        err = select(1, &read_set, NULL, NULL, &timeout);
-	if (err == 0)
-		return K_ESC;
-
-	SLang_ungetkey(key);
-	return SLkp_getkey();
-}
-
 int ui_browser__run(struct ui_browser *self, int delay_secs)
 {
 	int err, key;
 
-	pthread__unblock_sigwinch();
-
 	while (1) {
 		off_t offset;
 
@@ -351,10 +364,7 @@ int ui_browser__run(struct ui_browser *self, int delay_secs)
 		key = ui__getch(delay_secs);
 
 		if (key == K_RESIZE) {
-			pthread_mutex_lock(&ui__lock);
-			SLtt_get_screen_size();
-			SLsmg_reinit_smg();
-			pthread_mutex_unlock(&ui__lock);
+			ui__refresh_dimensions(false);
 			ui_browser__refresh_dimensions(self);
 			__ui_browser__show_title(self, self->title);
 			ui_helpline__puts(self->helpline);
@@ -533,6 +543,47 @@ static int ui_browser__color_config(const char *var, const char *value,
 	return -1;
 }
 
+void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence)
+{
+	switch (whence) {
+	case SEEK_SET:
+		browser->top = browser->entries;
+		break;
+	case SEEK_CUR:
+		browser->top = browser->top + browser->top_idx + offset;
+		break;
+	case SEEK_END:
+		browser->top = browser->top + browser->nr_entries + offset;
+		break;
+	default:
+		return;
+	}
+}
+
+unsigned int ui_browser__argv_refresh(struct ui_browser *browser)
+{
+	unsigned int row = 0, idx = browser->top_idx;
+	char **pos;
+
+	if (browser->top == NULL)
+		browser->top = browser->entries;
+
+	pos = (char **)browser->top;
+	while (idx < browser->nr_entries) {
+		if (!browser->filter || !browser->filter(browser, *pos)) {
+			ui_browser__gotorc(browser, row, 0);
+			browser->write(browser, pos, row);
+			if (++row == browser->height)
+				break;
+		}
+
+		++idx;
+		++pos;
+	}
+
+	return row;
+}
+
 void ui_browser__init(void)
 {
 	int i = 0;
diff --git a/tools/perf/util/ui/browser.h b/tools/perf/util/ui/browser.h
index a2c707d..84d761b 100644
--- a/tools/perf/util/ui/browser.h
+++ b/tools/perf/util/ui/browser.h
@@ -43,6 +43,15 @@ void ui_browser__hide(struct ui_browser *self);
 int ui_browser__refresh(struct ui_browser *self);
 int ui_browser__run(struct ui_browser *browser, int delay_secs);
 void ui_browser__update_nr_entries(struct ui_browser *browser, u32 nr_entries);
+void ui_browser__handle_resize(struct ui_browser *browser);
+
+int ui_browser__warning(struct ui_browser *browser, int timeout,
+			const char *format, ...);
+int ui_browser__help_window(struct ui_browser *browser, const char *text);
+bool ui_browser__dialog_yesno(struct ui_browser *browser, const char *text);
+
+void ui_browser__argv_seek(struct ui_browser *browser, off_t offset, int whence);
+unsigned int ui_browser__argv_refresh(struct ui_browser *browser);
 
 void ui_browser__rb_tree_seek(struct ui_browser *self, off_t offset, int whence);
 unsigned int ui_browser__rb_tree_refresh(struct ui_browser *self);
diff --git a/tools/perf/util/ui/browsers/annotate.c b/tools/perf/util/ui/browsers/annotate.c
index 4e0cb7fe..0575905 100644
--- a/tools/perf/util/ui/browsers/annotate.c
+++ b/tools/perf/util/ui/browsers/annotate.c
@@ -1,6 +1,9 @@
+#include "../../util.h"
 #include "../browser.h"
 #include "../helpline.h"
 #include "../libslang.h"
+#include "../ui.h"
+#include "../util.h"
 #include "../../annotate.h"
 #include "../../hist.h"
 #include "../../sort.h"
@@ -8,15 +11,6 @@
 #include <pthread.h>
 #include <newt.h>
 
-static void ui__error_window(const char *fmt, ...)
-{
-	va_list ap;
-
-	va_start(ap, fmt);
-	newtWinMessagev((char *)"Error", (char *)"Ok", (char *)fmt, ap);
-	va_end(ap);
-}
-
 struct annotate_browser {
 	struct ui_browser b;
 	struct rb_root	  entries;
@@ -400,7 +394,7 @@ int symbol__tui_annotate(struct symbol *sym, struct map *map, int evidx,
 		return -1;
 
 	if (symbol__annotate(sym, map, sizeof(struct objdump_line_rb_node)) < 0) {
-		ui__error_window(ui_helpline__last_msg);
+		ui__error("%s", ui_helpline__last_msg);
 		return -1;
 	}
 
diff --git a/tools/perf/util/ui/browsers/hists.c b/tools/perf/util/ui/browsers/hists.c
index 4663dcb..d0c94b4 100644
--- a/tools/perf/util/ui/browsers/hists.c
+++ b/tools/perf/util/ui/browsers/hists.c
@@ -17,6 +17,7 @@
 #include "../browser.h"
 #include "../helpline.h"
 #include "../util.h"
+#include "../ui.h"
 #include "map.h"
 
 struct hist_browser {
@@ -294,6 +295,15 @@ static void hist_browser__set_folding(struct hist_browser *self, bool unfold)
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
@@ -314,12 +324,18 @@ static int hist_browser__run(struct hist_browser *self, const char *ev_name,
 		key = ui_browser__run(&self->b, delay_secs);
 
 		switch (key) {
-		case -1:
-			/* FIXME we need to check if it was es.reason == NEWT_EXIT_TIMER */
+		case K_TIMER:
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
-				ui__warning(
+				ui_browser__warning(&browser->b, delay_secs * 2,
 			"Annotation is only available for symbolic views, "
 			"include \"sym\" in --sort to use it.");
 				continue;
@@ -901,7 +917,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		case K_F1:
 		case 'h':
 		case '?':
-			ui__help_window("h/?/F1        Show this window\n"
+			ui_browser__help_window(&browser->b,
+					"h/?/F1        Show this window\n"
 					"UP/DOWN/PGUP\n"
 					"PGDN/SPACE    Navigate\n"
 					"q/ESC/CTRL+C  Exit browser\n\n"
@@ -914,7 +931,7 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 					"C             Collapse all callchains\n"
 					"E             Expand all callchains\n"
 					"d             Zoom into current DSO\n"
-					"t             Zoom into current Thread\n");
+					"t             Zoom into current Thread");
 			continue;
 		case K_ENTER:
 		case K_RIGHT:
@@ -940,7 +957,8 @@ static int perf_evsel__hists_browse(struct perf_evsel *evsel, int nr_events,
 		}
 		case K_ESC:
 			if (!left_exits &&
-			    !ui__dialog_yesno("Do you really want to exit?"))
+			    !ui_browser__dialog_yesno(&browser->b,
+					       "Do you really want to exit?"))
 				continue;
 			/* Fall thru */
 		case 'q':
@@ -993,6 +1011,7 @@ add_exit_option:
 
 		if (choice == annotate) {
 			struct hist_entry *he;
+			int err;
 do_annotate:
 			he = hist_browser__selected_entry(browser);
 			if (he == NULL)
@@ -1001,10 +1020,12 @@ do_annotate:
 			 * Don't let this be freed, say, by hists__decay_entry.
 			 */
 			he->used = true;
-			hist_entry__tui_annotate(he, evsel->idx, nr_events,
-						 timer, arg, delay_secs);
+			err = hist_entry__tui_annotate(he, evsel->idx, nr_events,
+						       timer, arg, delay_secs);
 			he->used = false;
 			ui_browser__update_nr_entries(&browser->b, browser->hists->nr_entries);
+			if (err)
+				ui_browser__handle_resize(&browser->b);
 		} else if (choice == browse_map)
 			map__browse(browser->selection->map);
 		else if (choice == zoom_dso) {
@@ -1056,6 +1077,7 @@ out:
 struct perf_evsel_menu {
 	struct ui_browser b;
 	struct perf_evsel *selection;
+	bool lost_events, lost_events_warned;
 };
 
 static void perf_evsel_menu__write(struct ui_browser *browser,
@@ -1068,14 +1090,29 @@ static void perf_evsel_menu__write(struct ui_browser *browser,
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
@@ -1100,6 +1137,11 @@ static int perf_evsel_menu__run(struct perf_evsel_menu *menu,
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
@@ -1133,7 +1175,8 @@ browse_hists:
 					pos = list_entry(pos->node.prev, struct perf_evsel, node);
 				goto browse_hists;
 			case K_ESC:
-				if (!ui__dialog_yesno("Do you really want to exit?"))
+				if (!ui_browser__dialog_yesno(&menu->b,
+						"Do you really want to exit?"))
 					continue;
 				/* Fall thru */
 			case 'q':
@@ -1145,7 +1188,8 @@ browse_hists:
 		case K_LEFT:
 			continue;
 		case K_ESC:
-			if (!ui__dialog_yesno("Do you really want to exit?"))
+			if (!ui_browser__dialog_yesno(&menu->b,
+					       "Do you really want to exit?"))
 				continue;
 			/* Fall thru */
 		case 'q':
diff --git a/tools/perf/util/ui/helpline.c b/tools/perf/util/ui/helpline.c
index f36d2ff..6ef3c56 100644
--- a/tools/perf/util/ui/helpline.c
+++ b/tools/perf/util/ui/helpline.c
@@ -1,20 +1,28 @@
 #define _GNU_SOURCE
 #include <stdio.h>
 #include <stdlib.h>
-#include <newt.h>
+#include <string.h>
 
 #include "../debug.h"
 #include "helpline.h"
 #include "ui.h"
+#include "libslang.h"
 
 void ui_helpline__pop(void)
 {
-	newtPopHelpLine();
 }
 
+char ui_helpline__current[512];
+
 void ui_helpline__push(const char *msg)
 {
-	newtPushHelpLine(msg);
+	const size_t sz = sizeof(ui_helpline__current);
+
+	SLsmg_gotorc(SLtt_Screen_Rows - 1, 0);
+	SLsmg_set_color(0);
+	SLsmg_write_nstring((char *)msg, SLtt_Screen_Cols);
+	SLsmg_refresh();
+	strncpy(ui_helpline__current, msg, sz)[sz - 1] = '\0';
 }
 
 void ui_helpline__vpush(const char *fmt, va_list ap)
@@ -63,7 +71,7 @@ int ui_helpline__show_help(const char *format, va_list ap)
 
 	if (ui_helpline__last_msg[backlog - 1] == '\n') {
 		ui_helpline__puts(ui_helpline__last_msg);
-		newtRefresh();
+		SLsmg_refresh();
 		backlog = 0;
 	}
 	pthread_mutex_unlock(&ui__lock);
diff --git a/tools/perf/util/ui/helpline.h b/tools/perf/util/ui/helpline.h
index fdcbc02..7bab6b3 100644
--- a/tools/perf/util/ui/helpline.h
+++ b/tools/perf/util/ui/helpline.h
@@ -11,4 +11,6 @@ void ui_helpline__vpush(const char *fmt, va_list ap);
 void ui_helpline__fpush(const char *fmt, ...);
 void ui_helpline__puts(const char *msg);
 
+extern char ui_helpline__current[];
+
 #endif /* _PERF_UI_HELPLINE_H_ */
diff --git a/tools/perf/util/ui/progress.c b/tools/perf/util/ui/progress.c
index d7fc399..295e366 100644
--- a/tools/perf/util/ui/progress.c
+++ b/tools/perf/util/ui/progress.c
@@ -1,60 +1,29 @@
-#include <stdlib.h>
-#include <newt.h>
 #include "../cache.h"
 #include "progress.h"
+#include "libslang.h"
+#include "ui.h"
+#include "browser.h"
 
-struct ui_progress {
-	newtComponent form, scale;
-};
-
-struct ui_progress *ui_progress__new(const char *title, u64 total)
-{
-	struct ui_progress *self = malloc(sizeof(*self));
-
-	if (self != NULL) {
-		int cols;
-
-		if (use_browser <= 0)
-			return self;
-		newtGetScreenSize(&cols, NULL);
-		cols -= 4;
-		newtCenteredWindow(cols, 1, title);
-		self->form  = newtForm(NULL, NULL, 0);
-		if (self->form == NULL)
-			goto out_free_self;
-		self->scale = newtScale(0, 0, cols, total);
-		if (self->scale == NULL)
-			goto out_free_form;
-		newtFormAddComponent(self->form, self->scale);
-		newtRefresh();
-	}
-
-	return self;
-
-out_free_form:
-	newtFormDestroy(self->form);
-out_free_self:
-	free(self);
-	return NULL;
-}
-
-void ui_progress__update(struct ui_progress *self, u64 curr)
+void ui_progress__update(u64 curr, u64 total, const char *title)
 {
+	int bar, y;
 	/*
 	 * FIXME: We should have a per UI backend way of showing progress,
 	 * stdio will just show a percentage as NN%, etc.
 	 */
 	if (use_browser <= 0)
 		return;
-	newtScaleSet(self->scale, curr);
-	newtRefresh();
-}
 
-void ui_progress__delete(struct ui_progress *self)
-{
-	if (use_browser > 0) {
-		newtFormDestroy(self->form);
-		newtPopWindow();
-	}
-	free(self);
+	ui__refresh_dimensions(true);
+	pthread_mutex_lock(&ui__lock);
+	y = SLtt_Screen_Rows / 2 - 2;
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, 0, 3, SLtt_Screen_Cols);
+	SLsmg_gotorc(y++, 1);
+	SLsmg_write_string((char *)title);
+	SLsmg_set_color(HE_COLORSET_SELECTED);
+	bar = ((SLtt_Screen_Cols - 2) * curr) / total;
+	SLsmg_fill_region(y, 1, 1, bar, ' ');
+	SLsmg_refresh();
+	pthread_mutex_unlock(&ui__lock);
 }
diff --git a/tools/perf/util/ui/progress.h b/tools/perf/util/ui/progress.h
index a3820a0..d9c205b 100644
--- a/tools/perf/util/ui/progress.h
+++ b/tools/perf/util/ui/progress.h
@@ -1,11 +1,8 @@
 #ifndef _PERF_UI_PROGRESS_H_
 #define _PERF_UI_PROGRESS_H_ 1
 
-struct ui_progress;
+#include <../types.h>
 
-struct ui_progress *ui_progress__new(const char *title, u64 total);
-void ui_progress__delete(struct ui_progress *self);
-
-void ui_progress__update(struct ui_progress *self, u64 curr);
+void ui_progress__update(u64 curr, u64 total, const char *title);
 
 #endif
diff --git a/tools/perf/util/ui/setup.c b/tools/perf/util/ui/setup.c
index 1e6ba06..85a69fa 100644
--- a/tools/perf/util/ui/setup.c
+++ b/tools/perf/util/ui/setup.c
@@ -7,10 +7,85 @@
 #include "browser.h"
 #include "helpline.h"
 #include "ui.h"
+#include "util.h"
 #include "libslang.h"
+#include "keysyms.h"
 
 pthread_mutex_t ui__lock = PTHREAD_MUTEX_INITIALIZER;
 
+static volatile int ui__need_resize;
+
+void ui__refresh_dimensions(bool force)
+{
+	if (force || ui__need_resize) {
+		ui__need_resize = 0;
+		pthread_mutex_lock(&ui__lock);
+		SLtt_get_screen_size();
+		SLsmg_reinit_smg();
+		pthread_mutex_unlock(&ui__lock);
+	}
+}
+
+static void ui__sigwinch(int sig __used)
+{
+	ui__need_resize = 1;
+}
+
+static void ui__setup_sigwinch(void)
+{
+	static bool done;
+
+	if (done)
+		return;
+
+	done = true;
+	pthread__unblock_sigwinch();
+	signal(SIGWINCH, ui__sigwinch);
+}
+
+int ui__getch(int delay_secs)
+{
+	struct timeval timeout, *ptimeout = delay_secs ? &timeout : NULL;
+	fd_set read_set;
+	int err, key;
+
+	ui__setup_sigwinch();
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+
+	if (delay_secs) {
+		timeout.tv_sec = delay_secs;
+		timeout.tv_usec = 0;
+	}
+
+        err = select(1, &read_set, NULL, NULL, ptimeout);
+
+	if (err == 0)
+		return K_TIMER;
+
+	if (err == -1) {
+		if (errno == EINTR)
+			return K_RESIZE;
+		return K_ERROR;
+	}
+
+	key = SLang_getkey();
+	if (key != K_ESC)
+		return key;
+
+	FD_ZERO(&read_set);
+	FD_SET(0, &read_set);
+	timeout.tv_sec = 0;
+	timeout.tv_usec = 20;
+        err = select(1, &read_set, NULL, NULL, &timeout);
+	if (err == 0)
+		return K_ESC;
+
+	SLang_ungetkey(key);
+	return SLkp_getkey();
+}
+
 static void newt_suspend(void *d __used)
 {
 	newtSuspend();
@@ -71,10 +146,10 @@ void setup_browser(bool fallback_to_pager)
 void exit_browser(bool wait_for_ok)
 {
 	if (use_browser > 0) {
-		if (wait_for_ok) {
-			char title[] = "Fatal Error", ok[] = "Ok";
-			newtWinMessage(title, ok, ui_helpline__last_msg);
-		}
+		if (wait_for_ok)
+			ui__question_window("Fatal Error",
+					    ui_helpline__last_msg,
+					    "Press any key...", 0);
 		ui__exit();
 	}
 }
diff --git a/tools/perf/util/ui/ui.h b/tools/perf/util/ui/ui.h
index d264e05..7b67045 100644
--- a/tools/perf/util/ui/ui.h
+++ b/tools/perf/util/ui/ui.h
@@ -2,7 +2,10 @@
 #define _PERF_UI_H_ 1
 
 #include <pthread.h>
+#include <stdbool.h>
 
 extern pthread_mutex_t ui__lock;
 
+void ui__refresh_dimensions(bool force);
+
 #endif /* _PERF_UI_H_ */
diff --git a/tools/perf/util/ui/util.c b/tools/perf/util/ui/util.c
index fdf1fc8..45daa7c 100644
--- a/tools/perf/util/ui/util.c
+++ b/tools/perf/util/ui/util.c
@@ -1,6 +1,5 @@
-#include <newt.h>
+#include "../util.h"
 #include <signal.h>
-#include <stdio.h>
 #include <stdbool.h>
 #include <string.h>
 #include <sys/ttydefaults.h>
@@ -8,72 +7,75 @@
 #include "../cache.h"
 #include "../debug.h"
 #include "browser.h"
+#include "keysyms.h"
 #include "helpline.h"
 #include "ui.h"
 #include "util.h"
+#include "libslang.h"
 
-static void newt_form__set_exit_keys(newtComponent self)
+static void ui_browser__argv_write(struct ui_browser *browser,
+				   void *entry, int row)
 {
-	newtFormAddHotKey(self, NEWT_KEY_LEFT);
-	newtFormAddHotKey(self, NEWT_KEY_ESCAPE);
-	newtFormAddHotKey(self, 'Q');
-	newtFormAddHotKey(self, 'q');
-	newtFormAddHotKey(self, CTRL('c'));
-}
+	char **arg = entry;
+	bool current_entry = ui_browser__is_current_entry(browser, row);
 
-static newtComponent newt_form__new(void)
-{
-	newtComponent self = newtForm(NULL, NULL, 0);
-	if (self)
-		newt_form__set_exit_keys(self);
-	return self;
+	ui_browser__set_color(browser, current_entry ? HE_COLORSET_SELECTED :
+						       HE_COLORSET_NORMAL);
+	slsmg_write_nstring(*arg, browser->width);
 }
 
-int ui__popup_menu(int argc, char * const argv[])
+static int popup_menu__run(struct ui_browser *menu)
 {
-	struct newtExitStruct es;
-	int i, rc = -1, max_len = 5;
-	newtComponent listbox, form = newt_form__new();
+	int key;
 
-	if (form == NULL)
+	if (ui_browser__show(menu, " ", "ESC: exit, ENTER|->: Select option") < 0)
 		return -1;
 
-	listbox = newtListbox(0, 0, argc, NEWT_FLAG_RETURNEXIT);
-	if (listbox == NULL)
-		goto out_destroy_form;
+	while (1) {
+		key = ui_browser__run(menu, 0);
 
-	newtFormAddComponent(form, listbox);
+		switch (key) {
+		case K_RIGHT:
+		case K_ENTER:
+			key = menu->index;
+			break;
+		case K_LEFT:
+		case K_ESC:
+		case 'q':
+		case CTRL('c'):
+			key = -1;
+			break;
+		default:
+			continue;
+		}
 
-	for (i = 0; i < argc; ++i) {
-		int len = strlen(argv[i]);
-		if (len > max_len)
-			max_len = len;
-		if (newtListboxAddEntry(listbox, argv[i], (void *)(long)i))
-			goto out_destroy_form;
+		break;
 	}
 
-	newtCenteredWindow(max_len, argc, NULL);
-	newtFormRun(form, &es);
-	rc = newtListboxGetCurrent(listbox) - NULL;
-	if (es.reason == NEWT_EXIT_HOTKEY)
-		rc = -1;
-	newtPopWindow();
-out_destroy_form:
-	newtFormDestroy(form);
-	return rc;
+	ui_browser__hide(menu);
+	return key;
 }
 
-int ui__help_window(const char *text)
+int ui__popup_menu(int argc, char * const argv[])
 {
-	struct newtExitStruct es;
-	newtComponent tb, form = newt_form__new();
-	int rc = -1;
+	struct ui_browser menu = {
+		.entries    = (void *)argv,
+		.refresh    = ui_browser__argv_refresh,
+		.seek	    = ui_browser__argv_seek,
+		.write	    = ui_browser__argv_write,
+		.nr_entries = argc,
+	};
+
+	return popup_menu__run(&menu);
+}
+
+int ui__question_window(const char *title, const char *text,
+			const char *exit_msg, int delay_secs)
+{
+	int x, y;
 	int max_len = 0, nr_lines = 0;
 	const char *t;
 
-	if (form == NULL)
-		return -1;
-
 	t = text;
 	while (1) {
 		const char *sep = strchr(t, '\n');
@@ -90,41 +92,77 @@ int ui__help_window(const char *text)
 		t = sep + 1;
 	}
 
-	tb = newtTextbox(0, 0, max_len, nr_lines, 0);
-	if (tb == NULL)
-		goto out_destroy_form;
-
-	newtTextboxSetText(tb, text);
-	newtFormAddComponent(form, tb);
-	newtCenteredWindow(max_len, nr_lines, NULL);
-	newtFormRun(form, &es);
-	newtPopWindow();
-	rc = 0;
-out_destroy_form:
-	newtFormDestroy(form);
-	return rc;
+	max_len += 2;
+	nr_lines += 4;
+	y = SLtt_Screen_Rows / 2 - nr_lines / 2,
+	x = SLtt_Screen_Cols / 2 - max_len / 2;
+
+	SLsmg_set_color(0);
+	SLsmg_draw_box(y, x++, nr_lines, max_len);
+	if (title) {
+		SLsmg_gotorc(y, x + 1);
+		SLsmg_write_string((char *)title);
+	}
+	SLsmg_gotorc(++y, x);
+	nr_lines -= 2;
+	max_len -= 2;
+	SLsmg_write_wrapped_string((unsigned char *)text, y, x,
+				   nr_lines, max_len, 1);
+	SLsmg_gotorc(y + nr_lines - 2, x);
+	SLsmg_write_nstring((char *)" ", max_len);
+	SLsmg_gotorc(y + nr_lines - 1, x);
+	SLsmg_write_nstring((char *)exit_msg, max_len);
+	SLsmg_refresh();
+	return ui__getch(delay_secs);
 }
 
-static const char yes[] = "Yes", no[] = "No",
-		  warning_str[] = "Warning!", ok[] = "Ok";
+int ui__help_window(const char *text)
+{
+	return ui__question_window("Help", text, "Press any key...", 0);
+}
 
-bool ui__dialog_yesno(const char *msg)
+int ui__dialog_yesno(const char *msg)
 {
-	/* newtWinChoice should really be accepting const char pointers... */
-	return newtWinChoice(NULL, (char *)yes, (char *)no, (char *)msg) == 1;
+	return ui__question_window(NULL, msg, "Enter: Yes, ESC: No", 0);
 }
 
-void ui__warning(const char *format, ...)
+int __ui__warning(const char *title, const char *format, va_list args)
 {
-	va_list args;
+	char *s;
+
+	if (use_browser > 0 && vasprintf(&s, format, args) > 0) {
+		int key;
 
-	va_start(args, format);
-	if (use_browser > 0) {
 		pthread_mutex_lock(&ui__lock);
-		newtWinMessagev((char *)warning_str, (char *)ok,
-				(char *)format, args);
+		key = ui__question_window(title, s, "Press any key...", 0);
 		pthread_mutex_unlock(&ui__lock);
-	} else
-		vfprintf(stderr, format, args);
+		free(s);
+		return key;
+	}
+
+	fprintf(stderr, "%s:\n", title);
+	vfprintf(stderr, format, args);
+	return K_ESC;
+}
+
+int ui__warning(const char *format, ...)
+{
+	int key;
+	va_list args;
+
+	va_start(args, format);
+	key = __ui__warning("Warning", format, args);
+	va_end(args);
+	return key;
+}
+
+int ui__error(const char *format, ...)
+{
+	int key;
+	va_list args;
+
+	va_start(args, format);
+	key = __ui__warning("Error", format, args);
 	va_end(args);
+	return key;
 }
diff --git a/tools/perf/util/ui/util.h b/tools/perf/util/ui/util.h
index afcbc1d..2d1738b 100644
--- a/tools/perf/util/ui/util.h
+++ b/tools/perf/util/ui/util.h
@@ -1,10 +1,14 @@
 #ifndef _PERF_UI_UTIL_H_
 #define _PERF_UI_UTIL_H_ 1
 
-#include <stdbool.h>
+#include <stdarg.h>
 
+int ui__getch(int delay_secs);
 int ui__popup_menu(int argc, char * const argv[]);
 int ui__help_window(const char *text);
-bool ui__dialog_yesno(const char *msg);
+int ui__dialog_yesno(const char *msg);
+int ui__question_window(const char *title, const char *text,
+			const char *exit_msg, int delay_secs);
+int __ui__warning(const char *title, const char *format, va_list args);
 
 #endif /* _PERF_UI_UTIL_H_ */
