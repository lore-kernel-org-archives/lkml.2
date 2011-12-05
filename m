Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab1LEM6u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 07:58:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56999 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932100Ab1LEM6s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 07:58:48 -0500
Date: Mon, 5 Dec 2011 04:57:41 -0800
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-wp4djox7x6w1i2bab1pt4xxp@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, peterz@infradead.org,
        efault@gmx.de, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Pass tool context in the the perf_event_ops functions
Git-Commit-ID: d20deb64e0490ee9442b5181bc08a62d2cadcb90
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 05 Dec 2011 04:57:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  d20deb64e0490ee9442b5181bc08a62d2cadcb90
Gitweb:     http://git.kernel.org/tip/d20deb64e0490ee9442b5181bc08a62d2cadcb90
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Fri, 25 Nov 2011 08:19:45 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 28 Nov 2011 10:38:56 -0200

perf tools: Pass tool context in the the perf_event_ops functions

So that we don't need to have that many globals.

Next steps will remove the 'session' pointer, that in most cases is
not needed.

Then we can rename perf_event_ops to 'perf_tool' that better describes
this class hierarchy.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-wp4djox7x6w1i2bab1pt4xxp@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |   62 ++++---
 tools/perf/builtin-diff.c      |    3 +-
 tools/perf/builtin-inject.c    |   55 ++++---
 tools/perf/builtin-kmem.c      |    3 +-
 tools/perf/builtin-lock.c      |    3 +-
 tools/perf/builtin-record.c    |  383 ++++++++++++++++++++++------------------
 tools/perf/builtin-report.c    |   97 ++++++-----
 tools/perf/builtin-sched.c     |    3 +-
 tools/perf/builtin-script.c    |    3 +-
 tools/perf/builtin-timechart.c |   12 +-
 tools/perf/builtin-top.c       |    6 +-
 tools/perf/util/build-id.c     |    7 +-
 tools/perf/util/callchain.h    |    3 +
 tools/perf/util/event.c        |   66 ++++---
 tools/perf/util/event.h        |   38 +++--
 tools/perf/util/header.c       |   36 +++--
 tools/perf/util/header.h       |   27 ++-
 tools/perf/util/session.c      |   60 ++++---
 tools/perf/util/session.h      |   23 ++-
 tools/perf/util/top.h          |    3 +-
 20 files changed, 520 insertions(+), 373 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 4f0c3d9..483cb94 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -30,7 +30,8 @@
 
 #include <linux/bitmap.h>
 
-static struct perf_annotate {
+struct perf_annotate {
+	struct perf_event_ops ops;
 	char const *input_name;
 	bool	   force, use_tui, use_stdio;
 	bool	   full_paths;
@@ -38,13 +39,12 @@ static struct perf_annotate {
 	const char *sym_hist_filter;
 	const char *cpu_list;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
-} annotate = {
-	.input_name = "perf.data",
-}, *ann = &annotate;
+};
 
 static int perf_evsel__add_sample(struct perf_evsel *evsel,
 				  struct perf_sample *sample,
-				  struct addr_location *al)
+				  struct addr_location *al,
+				  struct perf_annotate *ann)
 {
 	struct hist_entry *he;
 	int ret;
@@ -79,11 +79,13 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 	return ret;
 }
 
-static int process_sample_event(union perf_event *event,
+static int process_sample_event(struct perf_event_ops *ops,
+				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
+	struct perf_annotate *ann = container_of(ops, struct perf_annotate, ops);
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, session, &al, sample,
@@ -96,7 +98,7 @@ static int process_sample_event(union perf_event *event,
 	if (ann->cpu_list && !test_bit(sample->cpu, ann->cpu_bitmap))
 		return 0;
 
-	if (!al.filtered && perf_evsel__add_sample(evsel, sample, &al)) {
+	if (!al.filtered && perf_evsel__add_sample(evsel, sample, &al, ann)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
@@ -105,13 +107,15 @@ static int process_sample_event(union perf_event *event,
 	return 0;
 }
 
-static int hist_entry__tty_annotate(struct hist_entry *he, int evidx)
+static int hist_entry__tty_annotate(struct hist_entry *he, int evidx,
+				    struct perf_annotate *ann)
 {
 	return symbol__tty_annotate(he->ms.sym, he->ms.map, evidx,
 				    ann->print_line, ann->full_paths, 0, 0);
 }
 
-static void hists__find_annotations(struct hists *self, int evidx)
+static void hists__find_annotations(struct hists *self, int evidx,
+				    struct perf_annotate *ann)
 {
 	struct rb_node *nd = rb_first(&self->entries), *next;
 	int key = K_RIGHT;
@@ -149,7 +153,7 @@ find_next:
 			if (next != NULL)
 				nd = next;
 		} else {
-			hist_entry__tty_annotate(he, evidx);
+			hist_entry__tty_annotate(he, evidx, ann);
 			nd = rb_next(nd);
 			/*
 			 * Since we have a hist_entry per IP for the same
@@ -162,16 +166,7 @@ find_next:
 	}
 }
 
-static struct perf_event_ops event_ops = {
-	.sample	= process_sample_event,
-	.mmap	= perf_event__process_mmap,
-	.comm	= perf_event__process_comm,
-	.fork	= perf_event__process_task,
-	.ordered_samples = true,
-	.ordering_requires_timestamps = true,
-};
-
-static int __cmd_annotate(void)
+static int __cmd_annotate(struct perf_annotate *ann)
 {
 	int ret;
 	struct perf_session *session;
@@ -179,7 +174,7 @@ static int __cmd_annotate(void)
 	u64 total_nr_samples;
 
 	session = perf_session__new(ann->input_name, O_RDONLY,
-				    ann->force, false, &event_ops);
+				    ann->force, false, &ann->ops);
 	if (session == NULL)
 		return -ENOMEM;
 
@@ -190,7 +185,7 @@ static int __cmd_annotate(void)
 			goto out_delete;
 	}
 
-	ret = perf_session__process_events(session, &event_ops);
+	ret = perf_session__process_events(session, &ann->ops);
 	if (ret)
 		goto out_delete;
 
@@ -214,7 +209,7 @@ static int __cmd_annotate(void)
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists);
 			hists__output_resort(hists);
-			hists__find_annotations(hists, pos->idx);
+			hists__find_annotations(hists, pos->idx, ann);
 		}
 	}
 
@@ -243,7 +238,20 @@ static const char * const annotate_usage[] = {
 	NULL
 };
 
-static const struct option options[] = {
+int cmd_annotate(int argc, const char **argv, const char *prefix __used)
+{
+	struct perf_annotate annotate = {
+		.ops = {
+			.sample	= process_sample_event,
+			.mmap	= perf_event__process_mmap,
+			.comm	= perf_event__process_comm,
+			.fork	= perf_event__process_task,
+			.ordered_samples = true,
+			.ordering_requires_timestamps = true,
+		},
+		.input_name = "perf.data",
+	};
+	const struct option options[] = {
 	OPT_STRING('i', "input", &annotate.input_name, "file",
 		    "input file name"),
 	OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
@@ -275,10 +283,8 @@ static const struct option options[] = {
 	OPT_STRING('M', "disassembler-style", &disassembler_style, "disassembler style",
 		   "Specify disassembler style (e.g. -M intel for intel syntax)"),
 	OPT_END()
-};
+	};
 
-int cmd_annotate(int argc, const char **argv, const char *prefix __used)
-{
 	argc = parse_options(argc, argv, options, annotate_usage, 0);
 
 	if (annotate.use_stdio)
@@ -312,5 +318,5 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __used)
 		return -1;
 	}
 
-	return __cmd_annotate();
+	return __cmd_annotate(&annotate);
 }
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b39f3a1..9a0872f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -30,7 +30,8 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(union perf_event *event,
+static int diff__process_sample_event(struct perf_event_ops *ops __used,
+				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
 				      struct perf_session *session)
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 978751e..6ce6d80 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -16,7 +16,8 @@
 static char		const *input_name = "-";
 static bool		inject_build_ids;
 
-static int perf_event__repipe_synth(union perf_event *event,
+static int perf_event__repipe_synth(struct perf_event_ops *ops __used,
+				    union perf_event *event,
 				    struct perf_session *session __used)
 {
 	uint32_t size;
@@ -36,47 +37,57 @@ static int perf_event__repipe_synth(union perf_event *event,
 	return 0;
 }
 
+static int perf_event__repipe_tracing_data_synth(union perf_event *event,
+						 struct perf_session *session)
+{
+	return perf_event__repipe_synth(NULL, event, session);
+}
+
 static int perf_event__repipe_attr(union perf_event *event,
 				   struct perf_evlist **pevlist __used)
 {
-	return perf_event__repipe_synth(event, NULL);
+	return perf_event__repipe_synth(NULL, event, NULL);
 }
 
-static int perf_event__repipe(union perf_event *event,
+static int perf_event__repipe(struct perf_event_ops *ops,
+			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session)
 {
-	return perf_event__repipe_synth(event, session);
+	return perf_event__repipe_synth(ops, event, session);
 }
 
-static int perf_event__repipe_sample(union perf_event *event,
+static int perf_event__repipe_sample(struct perf_event_ops *ops,
+				     union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_evsel *evsel __used,
 			      struct perf_session *session)
 {
-	return perf_event__repipe_synth(event, session);
+	return perf_event__repipe_synth(ops, event, session);
 }
 
-static int perf_event__repipe_mmap(union perf_event *event,
+static int perf_event__repipe_mmap(struct perf_event_ops *ops,
+				   union perf_event *event,
 				   struct perf_sample *sample,
 				   struct perf_session *session)
 {
 	int err;
 
-	err = perf_event__process_mmap(event, sample, session);
-	perf_event__repipe(event, sample, session);
+	err = perf_event__process_mmap(ops, event, sample, session);
+	perf_event__repipe(ops, event, sample, session);
 
 	return err;
 }
 
-static int perf_event__repipe_task(union perf_event *event,
+static int perf_event__repipe_task(struct perf_event_ops *ops,
+				   union perf_event *event,
 				   struct perf_sample *sample,
 				   struct perf_session *session)
 {
 	int err;
 
-	err = perf_event__process_task(event, sample, session);
-	perf_event__repipe(event, sample, session);
+	err = perf_event__process_task(ops, event, sample, session);
+	perf_event__repipe(ops, event, sample, session);
 
 	return err;
 }
@@ -86,7 +97,7 @@ static int perf_event__repipe_tracing_data(union perf_event *event,
 {
 	int err;
 
-	perf_event__repipe_synth(event, session);
+	perf_event__repipe_synth(NULL, event, session);
 	err = perf_event__process_tracing_data(event, session);
 
 	return err;
@@ -106,7 +117,8 @@ static int dso__read_build_id(struct dso *self)
 	return -1;
 }
 
-static int dso__inject_build_id(struct dso *self, struct perf_session *session)
+static int dso__inject_build_id(struct dso *self, struct perf_event_ops *ops,
+				struct perf_session *session)
 {
 	u16 misc = PERF_RECORD_MISC_USER;
 	struct machine *machine;
@@ -126,7 +138,7 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 	if (self->kernel)
 		misc = PERF_RECORD_MISC_KERNEL;
 
-	err = perf_event__synthesize_build_id(self, misc, perf_event__repipe,
+	err = perf_event__synthesize_build_id(ops, self, misc, perf_event__repipe,
 					      machine, session);
 	if (err) {
 		pr_err("Can't synthesize build_id event for %s\n", self->long_name);
@@ -136,7 +148,8 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 	return 0;
 }
 
-static int perf_event__inject_buildid(union perf_event *event,
+static int perf_event__inject_buildid(struct perf_event_ops *ops,
+				      union perf_event *event,
 				      struct perf_sample *sample,
 				      struct perf_evsel *evsel __used,
 				      struct perf_session *session)
@@ -161,7 +174,7 @@ static int perf_event__inject_buildid(union perf_event *event,
 		if (!al.map->dso->hit) {
 			al.map->dso->hit = 1;
 			if (map__load(al.map, NULL) >= 0) {
-				dso__inject_build_id(al.map->dso, session);
+				dso__inject_build_id(al.map->dso, ops, session);
 				/*
 				 * If this fails, too bad, let the other side
 				 * account this as unresolved.
@@ -174,7 +187,7 @@ static int perf_event__inject_buildid(union perf_event *event,
 	}
 
 repipe:
-	perf_event__repipe(event, sample, session);
+	perf_event__repipe(ops, event, sample, session);
 	return 0;
 }
 
@@ -189,9 +202,9 @@ struct perf_event_ops inject_ops = {
 	.throttle	= perf_event__repipe,
 	.unthrottle	= perf_event__repipe,
 	.attr		= perf_event__repipe_attr,
-	.event_type 	= perf_event__repipe_synth,
-	.tracing_data 	= perf_event__repipe_synth,
-	.build_id 	= perf_event__repipe_synth,
+	.event_type	= perf_event__repipe_synth,
+	.tracing_data	= perf_event__repipe_tracing_data_synth,
+	.build_id	= perf_event__repipe_synth,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 225e963..5d01218 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -303,7 +303,8 @@ static void process_raw_event(union perf_event *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(union perf_event *event,
+static int process_sample_event(struct perf_event_ops *ops __used,
+				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel __used,
 				struct perf_session *session)
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 899080a..f06b0a4 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -845,7 +845,8 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(union perf_event *event,
+static int process_sample_event(struct perf_event_ops *ops __used,
+				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel __used,
 				struct perf_session *s)
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ba6777a..4642d38 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -35,43 +35,36 @@ enum write_mode_t {
 	WRITE_APPEND
 };
 
-struct perf_record_opts record_opts = {
-	.target_pid	     = -1,
-	.target_tid	     = -1,
-	.mmap_pages	     = UINT_MAX,
-	.user_freq	     = UINT_MAX,
-	.user_interval	     = ULLONG_MAX,
-	.freq		     = 1000,
-	.sample_id_all_avail = true,
+struct perf_record {
+	struct perf_event_ops	ops;
+	struct perf_record_opts	opts;
+	u64			bytes_written;
+	const char		*output_name;
+	struct perf_evlist	*evlist;
+	struct perf_session	*session;
+	const char		*progname;
+	int			output;
+	unsigned int		page_size;
+	int			realtime_prio;
+	enum write_mode_t	write_mode;
+	bool			no_buildid;
+	bool			no_buildid_cache;
+	bool			force;
+	bool			file_new;
+	bool			append_file;
+	long			samples;
+	off_t			post_processing_offset;
 };
 
-static unsigned int		page_size;
-static int			output;
-static const char		*output_name			= NULL;
-static int			realtime_prio			=      0;
-static enum write_mode_t	write_mode			= WRITE_FORCE;
-static bool			no_buildid			=  false;
-static bool			no_buildid_cache		=  false;
-static struct perf_evlist	*evsel_list;
-
-static long			samples				=      0;
-static u64			bytes_written			=      0;
-
-static int			file_new			=      1;
-static off_t			post_processing_offset;
-
-static struct perf_session	*session;
-static const char               *progname;
-
-static void advance_output(size_t size)
+static void advance_output(struct perf_record *rec, size_t size)
 {
-	bytes_written += size;
+	rec->bytes_written += size;
 }
 
-static void write_output(void *buf, size_t size)
+static void write_output(struct perf_record *rec, void *buf, size_t size)
 {
 	while (size) {
-		int ret = write(output, buf, size);
+		int ret = write(rec->output, buf, size);
 
 		if (ret < 0)
 			die("failed to write");
@@ -79,30 +72,33 @@ static void write_output(void *buf, size_t size)
 		size -= ret;
 		buf += ret;
 
-		bytes_written += ret;
+		rec->bytes_written += ret;
 	}
 }
 
-static int process_synthesized_event(union perf_event *event,
+static int process_synthesized_event(struct perf_event_ops *ops,
+				     union perf_event *event,
 				     struct perf_sample *sample __used,
 				     struct perf_session *self __used)
 {
-	write_output(event, event->header.size);
+	struct perf_record *rec = container_of(ops, struct perf_record, ops);
+	write_output(rec, event, event->header.size);
 	return 0;
 }
 
-static void mmap_read(struct perf_mmap *md)
+static void perf_record__mmap_read(struct perf_record *rec,
+				   struct perf_mmap *md)
 {
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
-	unsigned char *data = md->base + page_size;
+	unsigned char *data = md->base + rec->page_size;
 	unsigned long size;
 	void *buf;
 
 	if (old == head)
 		return;
 
-	samples++;
+	rec->samples++;
 
 	size = head - old;
 
@@ -111,14 +107,14 @@ static void mmap_read(struct perf_mmap *md)
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		write_output(buf, size);
+		write_output(rec, buf, size);
 	}
 
 	buf = &data[old & md->mask];
 	size = head - old;
 	old += size;
 
-	write_output(buf, size);
+	write_output(rec, buf, size);
 
 	md->prev = old;
 	perf_mmap__write_tail(md, old);
@@ -137,17 +133,18 @@ static void sig_handler(int sig)
 	signr = sig;
 }
 
-static void sig_atexit(void)
+static void perf_record__sig_exit(int exit_status __used, void *arg)
 {
+	struct perf_record *rec = arg;
 	int status;
 
-	if (evsel_list->workload.pid > 0) {
+	if (rec->evlist->workload.pid > 0) {
 		if (!child_finished)
-			kill(evsel_list->workload.pid, SIGTERM);
+			kill(rec->evlist->workload.pid, SIGTERM);
 
 		wait(&status);
 		if (WIFSIGNALED(status))
-			psignal(WTERMSIG(status), progname);
+			psignal(WTERMSIG(status), rec->progname);
 	}
 
 	if (signr == -1 || signr == SIGUSR1)
@@ -176,13 +173,16 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 	return true;
 }
 
-static void open_counters(struct perf_evlist *evlist)
+static void perf_record__open(struct perf_record *rec)
 {
 	struct perf_evsel *pos, *first;
+	struct perf_evlist *evlist = rec->evlist;
+	struct perf_session *session = rec->session;
+	struct perf_record_opts *opts = &rec->opts;
 
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
-	perf_evlist__config_attrs(evlist, &record_opts);
+	perf_evlist__config_attrs(evlist, opts);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
@@ -201,27 +201,27 @@ static void open_counters(struct perf_evlist *evlist)
 		 */
 		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
-		if (record_opts.group && pos != first)
+		if (opts->group && pos != first)
 			group_fd = first->fd;
 retry_sample_id:
-		attr->sample_id_all = record_opts.sample_id_all_avail ? 1 : 0;
+		attr->sample_id_all = opts->sample_id_all_avail ? 1 : 0;
 try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads,
-				     record_opts.group, group_fd) < 0) {
+				     opts->group, group_fd) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				exit(EXIT_FAILURE);
-			} else if (err ==  ENODEV && record_opts.cpu_list) {
+			} else if (err ==  ENODEV && opts->cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
-			} else if (err == EINVAL && record_opts.sample_id_all_avail) {
+			} else if (err == EINVAL && opts->sample_id_all_avail) {
 				/*
 				 * Old kernel, no attr->sample_id_type_all field
 				 */
-				record_opts.sample_id_all_avail = false;
-				if (!record_opts.sample_time && !record_opts.raw_samples && !time_needed)
+				opts->sample_id_all_avail = false;
+				if (!opts->sample_time && !opts->raw_samples && !time_needed)
 					attr->sample_type &= ~PERF_SAMPLE_TIME;
 
 				goto retry_sample_id;
@@ -271,10 +271,10 @@ try_again:
 		exit(-1);
 	}
 
-	if (perf_evlist__mmap(evlist, record_opts.mmap_pages, false) < 0)
+	if (perf_evlist__mmap(evlist, opts->mmap_pages, false) < 0)
 		die("failed to mmap with %d (%s)\n", errno, strerror(errno));
 
-	if (file_new)
+	if (rec->file_new)
 		session->evlist = evlist;
 	else {
 		if (!perf_evlist__equal(session->evlist, evlist)) {
@@ -286,29 +286,32 @@ try_again:
 	perf_session__update_sample_type(session);
 }
 
-static int process_buildids(void)
+static int process_buildids(struct perf_record *rec)
 {
-	u64 size = lseek(output, 0, SEEK_CUR);
+	u64 size = lseek(rec->output, 0, SEEK_CUR);
 
 	if (size == 0)
 		return 0;
 
-	session->fd = output;
-	return __perf_session__process_events(session, post_processing_offset,
-					      size - post_processing_offset,
+	rec->session->fd = rec->output;
+	return __perf_session__process_events(rec->session, rec->post_processing_offset,
+					      size - rec->post_processing_offset,
 					      size, &build_id__mark_dso_hit_ops);
 }
 
-static void atexit_header(void)
+static void perf_record__exit(int status __used, void *arg)
 {
-	if (!record_opts.pipe_output) {
-		session->header.data_size += bytes_written;
-
-		if (!no_buildid)
-			process_buildids();
-		perf_session__write_header(session, evsel_list, output, true);
-		perf_session__delete(session);
-		perf_evlist__delete(evsel_list);
+	struct perf_record *rec = arg;
+
+	if (!rec->opts.pipe_output) {
+		rec->session->header.data_size += rec->bytes_written;
+
+		if (!rec->no_buildid)
+			process_buildids(rec);
+		perf_session__write_header(rec->session, rec->evlist,
+					   rec->output, true);
+		perf_session__delete(rec->session);
+		perf_evlist__delete(rec->evlist);
 		symbol__exit();
 	}
 }
@@ -316,7 +319,9 @@ static void atexit_header(void)
 static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 {
 	int err;
-	struct perf_session *psession = data;
+	struct perf_event_ops *ops = data;
+	struct perf_record *rec = container_of(ops, struct perf_record, ops);
+	struct perf_session *psession = rec->session;
 
 	if (machine__is_host(machine))
 		return;
@@ -329,7 +334,7 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 *method is used to avoid symbol missing when the first addr is
 	 *in module instead of in guest kernel.
 	 */
-	err = perf_event__synthesize_modules(process_synthesized_event,
+	err = perf_event__synthesize_modules(ops, process_synthesized_event,
 					     psession, machine);
 	if (err < 0)
 		pr_err("Couldn't record guest kernel [%d]'s reference"
@@ -339,10 +344,10 @@ static void perf_event__synthesize_guest_os(struct machine *machine, void *data)
 	 * We use _stext for guest kernel because guest kernel's /proc/kallsyms
 	 * have no _text sometimes.
 	 */
-	err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+	err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
 						 psession, machine, "_text");
 	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+		err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
 							 psession, machine,
 							 "_stext");
 	if (err < 0)
@@ -355,66 +360,71 @@ static struct perf_event_header finished_round_event = {
 	.type = PERF_RECORD_FINISHED_ROUND,
 };
 
-static void mmap_read_all(void)
+static void perf_record__mmap_read_all(struct perf_record *rec)
 {
 	int i;
 
-	for (i = 0; i < evsel_list->nr_mmaps; i++) {
-		if (evsel_list->mmap[i].base)
-			mmap_read(&evsel_list->mmap[i]);
+	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
+		if (rec->evlist->mmap[i].base)
+			perf_record__mmap_read(rec, &rec->evlist->mmap[i]);
 	}
 
-	if (perf_header__has_feat(&session->header, HEADER_TRACE_INFO))
-		write_output(&finished_round_event, sizeof(finished_round_event));
+	if (perf_header__has_feat(&rec->session->header, HEADER_TRACE_INFO))
+		write_output(rec, &finished_round_event, sizeof(finished_round_event));
 }
 
-static int __cmd_record(int argc, const char **argv)
+static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
 	struct stat st;
 	int flags;
-	int err;
+	int err, output;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
+	struct perf_event_ops *ops = &rec->ops;
+	struct perf_record_opts *opts = &rec->opts;
+	struct perf_evlist *evsel_list = rec->evlist;
+	const char *output_name = rec->output_name;
+	struct perf_session *session;
 
-	progname = argv[0];
+	rec->progname = argv[0];
 
-	page_size = sysconf(_SC_PAGE_SIZE);
+	rec->page_size = sysconf(_SC_PAGE_SIZE);
 
-	atexit(sig_atexit);
+	on_exit(perf_record__sig_exit, rec);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
 	signal(SIGUSR1, sig_handler);
 
 	if (!output_name) {
 		if (!fstat(STDOUT_FILENO, &st) && S_ISFIFO(st.st_mode))
-			record_opts.pipe_output = true;
+			opts->pipe_output = true;
 		else
-			output_name = "perf.data";
+			rec->output_name = output_name = "perf.data";
 	}
 	if (output_name) {
 		if (!strcmp(output_name, "-"))
-			record_opts.pipe_output = true;
+			opts->pipe_output = true;
 		else if (!stat(output_name, &st) && st.st_size) {
-			if (write_mode == WRITE_FORCE) {
+			if (rec->write_mode == WRITE_FORCE) {
 				char oldname[PATH_MAX];
 				snprintf(oldname, sizeof(oldname), "%s.old",
 					 output_name);
 				unlink(oldname);
 				rename(output_name, oldname);
 			}
-		} else if (write_mode == WRITE_APPEND) {
-			write_mode = WRITE_FORCE;
+		} else if (rec->write_mode == WRITE_APPEND) {
+			rec->write_mode = WRITE_FORCE;
 		}
 	}
 
 	flags = O_CREAT|O_RDWR;
-	if (write_mode == WRITE_APPEND)
-		file_new = 0;
+	if (rec->write_mode == WRITE_APPEND)
+		rec->file_new = 0;
 	else
 		flags |= O_TRUNC;
 
-	if (record_opts.pipe_output)
+	if (opts->pipe_output)
 		output = STDOUT_FILENO;
 	else
 		output = open(output_name, flags, S_IRUSR | S_IWUSR);
@@ -423,17 +433,21 @@ static int __cmd_record(int argc, const char **argv)
 		exit(-1);
 	}
 
+	rec->output = output;
+
 	session = perf_session__new(output_name, O_WRONLY,
-				    write_mode == WRITE_FORCE, false, NULL);
+				    rec->write_mode == WRITE_FORCE, false, NULL);
 	if (session == NULL) {
 		pr_err("Not enough memory for reading perf file header\n");
 		return -1;
 	}
 
-	if (!no_buildid)
+	rec->session = session;
+
+	if (!rec->no_buildid)
 		perf_header__set_feat(&session->header, HEADER_BUILD_ID);
 
-	if (!file_new) {
+	if (!rec->file_new) {
 		err = perf_session__read_header(session, output);
 		if (err < 0)
 			goto out_delete_session;
@@ -456,42 +470,42 @@ static int __cmd_record(int argc, const char **argv)
 	perf_header__set_feat(&session->header, HEADER_CPUID);
 
 	if (forks) {
-		err = perf_evlist__prepare_workload(evsel_list, &record_opts, argv);
+		err = perf_evlist__prepare_workload(evsel_list, opts, argv);
 		if (err < 0) {
 			pr_err("Couldn't run the workload!\n");
 			goto out_delete_session;
 		}
 	}
 
-	open_counters(evsel_list);
+	perf_record__open(rec);
 
 	/*
-	 * perf_session__delete(session) will be called at atexit_header()
+	 * perf_session__delete(session) will be called at perf_record__exit()
 	 */
-	atexit(atexit_header);
+	on_exit(perf_record__exit, rec);
 
-	if (record_opts.pipe_output) {
+	if (opts->pipe_output) {
 		err = perf_header__write_pipe(output);
 		if (err < 0)
 			return err;
-	} else if (file_new) {
+	} else if (rec->file_new) {
 		err = perf_session__write_header(session, evsel_list,
 						 output, false);
 		if (err < 0)
 			return err;
 	}
 
-	post_processing_offset = lseek(output, 0, SEEK_CUR);
+	rec->post_processing_offset = lseek(output, 0, SEEK_CUR);
 
-	if (record_opts.pipe_output) {
-		err = perf_session__synthesize_attrs(session,
-						     process_synthesized_event);
+	if (opts->pipe_output) {
+		err = perf_event__synthesize_attrs(ops, session,
+						   process_synthesized_event);
 		if (err < 0) {
 			pr_err("Couldn't synthesize attrs.\n");
 			return err;
 		}
 
-		err = perf_event__synthesize_event_types(process_synthesized_event,
+		err = perf_event__synthesize_event_types(ops, process_synthesized_event,
 							 session);
 		if (err < 0) {
 			pr_err("Couldn't synthesize event_types.\n");
@@ -507,14 +521,14 @@ static int __cmd_record(int argc, const char **argv)
 			 * return this more properly and also
 			 * propagate errors that now are calling die()
 			 */
-			err = perf_event__synthesize_tracing_data(output, evsel_list,
+			err = perf_event__synthesize_tracing_data(ops, output, evsel_list,
 								  process_synthesized_event,
 								  session);
 			if (err <= 0) {
 				pr_err("Couldn't record tracing data.\n");
 				return err;
 			}
-			advance_output(err);
+			advance_output(rec, err);
 		}
 	}
 
@@ -524,17 +538,17 @@ static int __cmd_record(int argc, const char **argv)
 		return -1;
 	}
 
-	err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+	err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
 						 session, machine, "_text");
 	if (err < 0)
-		err = perf_event__synthesize_kernel_mmap(process_synthesized_event,
+		err = perf_event__synthesize_kernel_mmap(ops, process_synthesized_event,
 							 session, machine, "_stext");
 	if (err < 0)
 		pr_err("Couldn't record kernel reference relocation symbol\n"
 		       "Symbol resolution may be skewed if relocation was used (e.g. kexec).\n"
 		       "Check /proc/kallsyms permission or run as root.\n");
 
-	err = perf_event__synthesize_modules(process_synthesized_event,
+	err = perf_event__synthesize_modules(ops, process_synthesized_event,
 					     session, machine);
 	if (err < 0)
 		pr_err("Couldn't record kernel module information.\n"
@@ -542,21 +556,21 @@ static int __cmd_record(int argc, const char **argv)
 		       "Check /proc/modules permission or run as root.\n");
 
 	if (perf_guest)
-		perf_session__process_machines(session,
+		perf_session__process_machines(session, ops,
 					       perf_event__synthesize_guest_os);
 
-	if (!record_opts.system_wide)
-		perf_event__synthesize_thread_map(evsel_list->threads,
+	if (!opts->system_wide)
+		perf_event__synthesize_thread_map(ops, evsel_list->threads,
 						  process_synthesized_event,
 						  session);
 	else
-		perf_event__synthesize_threads(process_synthesized_event,
+		perf_event__synthesize_threads(ops, process_synthesized_event,
 					       session);
 
-	if (realtime_prio) {
+	if (rec->realtime_prio) {
 		struct sched_param param;
 
-		param.sched_priority = realtime_prio;
+		param.sched_priority = rec->realtime_prio;
 		if (sched_setscheduler(0, SCHED_FIFO, &param)) {
 			pr_err("Could not set realtime priority.\n");
 			exit(-1);
@@ -572,11 +586,11 @@ static int __cmd_record(int argc, const char **argv)
 		perf_evlist__start_workload(evsel_list);
 
 	for (;;) {
-		int hits = samples;
+		int hits = rec->samples;
 
-		mmap_read_all();
+		perf_record__mmap_read_all(rec);
 
-		if (hits == samples) {
+		if (hits == rec->samples) {
 			if (done)
 				break;
 			err = poll(evsel_list->pollfd, evsel_list->nr_fds, -1);
@@ -597,9 +611,9 @@ static int __cmd_record(int argc, const char **argv)
 	 */
 	fprintf(stderr,
 		"[ perf record: Captured and wrote %.3f MB %s (~%" PRIu64 " samples) ]\n",
-		(double)bytes_written / 1024.0 / 1024.0,
+		(double)rec->bytes_written / 1024.0 / 1024.0,
 		output_name,
-		bytes_written / 24);
+		rec->bytes_written / 24);
 
 	return 0;
 
@@ -614,59 +628,88 @@ static const char * const record_usage[] = {
 	NULL
 };
 
-static bool force, append_file;
+/*
+ * XXX Ideally would be local to cmd_record() and passed to a perf_record__new
+ * because we need to have access to it in perf_record__exit, that is called
+ * after cmd_record() exits, but since record_options need to be accessible to
+ * builtin-script, leave it here.
+ *
+ * At least we don't ouch it in all the other functions here directly.
+ *
+ * Just say no to tons of global variables, sigh.
+ */
+static struct perf_record record = {
+	.opts = {
+		.target_pid	     = -1,
+		.target_tid	     = -1,
+		.mmap_pages	     = UINT_MAX,
+		.user_freq	     = UINT_MAX,
+		.user_interval	     = ULLONG_MAX,
+		.freq		     = 1000,
+		.sample_id_all_avail = true,
+	},
+	.write_mode = WRITE_FORCE,
+	.file_new   = true,
+};
 
+/*
+ * XXX Will stay a global variable till we fix builtin-script.c to stop messing
+ * with it and switch to use the library functions in perf_evlist that came
+ * from builtin-record.c, i.e. use perf_record_opts,
+ * perf_evlist__prepare_workload, etc instead of fork+exec'in 'perf record',
+ * using pipes, etc.
+ */
 const struct option record_options[] = {
-	OPT_CALLBACK('e', "event", &evsel_list, "event",
+	OPT_CALLBACK('e', "event", &record.evlist, "event",
 		     "event selector. use 'perf list' to list available events",
 		     parse_events_option),
-	OPT_CALLBACK(0, "filter", &evsel_list, "filter",
+	OPT_CALLBACK(0, "filter", &record.evlist, "filter",
 		     "event filter", parse_filter),
-	OPT_INTEGER('p', "pid", &record_opts.target_pid,
+	OPT_INTEGER('p', "pid", &record.opts.target_pid,
 		    "record events on existing process id"),
-	OPT_INTEGER('t', "tid", &record_opts.target_tid,
+	OPT_INTEGER('t', "tid", &record.opts.target_tid,
 		    "record events on existing thread id"),
-	OPT_INTEGER('r', "realtime", &realtime_prio,
+	OPT_INTEGER('r', "realtime", &record.realtime_prio,
 		    "collect data with this RT SCHED_FIFO priority"),
-	OPT_BOOLEAN('D', "no-delay", &record_opts.no_delay,
+	OPT_BOOLEAN('D', "no-delay", &record.opts.no_delay,
 		    "collect data without buffering"),
-	OPT_BOOLEAN('R', "raw-samples", &record_opts.raw_samples,
+	OPT_BOOLEAN('R', "raw-samples", &record.opts.raw_samples,
 		    "collect raw sample records from all opened counters"),
-	OPT_BOOLEAN('a', "all-cpus", &record_opts.system_wide,
+	OPT_BOOLEAN('a', "all-cpus", &record.opts.system_wide,
 			    "system-wide collection from all CPUs"),
-	OPT_BOOLEAN('A', "append", &append_file,
+	OPT_BOOLEAN('A', "append", &record.append_file,
 			    "append to the output file to do incremental profiling"),
-	OPT_STRING('C', "cpu", &record_opts.cpu_list, "cpu",
+	OPT_STRING('C', "cpu", &record.opts.cpu_list, "cpu",
 		    "list of cpus to monitor"),
-	OPT_BOOLEAN('f', "force", &force,
+	OPT_BOOLEAN('f', "force", &record.force,
 			"overwrite existing data file (deprecated)"),
-	OPT_U64('c', "count", &record_opts.user_interval, "event period to sample"),
-	OPT_STRING('o', "output", &output_name, "file",
+	OPT_U64('c', "count", &record.opts.user_interval, "event period to sample"),
+	OPT_STRING('o', "output", &record.output_name, "file",
 		    "output file name"),
-	OPT_BOOLEAN('i', "no-inherit", &record_opts.no_inherit,
+	OPT_BOOLEAN('i', "no-inherit", &record.opts.no_inherit,
 		    "child tasks do not inherit counters"),
-	OPT_UINTEGER('F', "freq", &record_opts.user_freq, "profile at this frequency"),
-	OPT_UINTEGER('m', "mmap-pages", &record_opts.mmap_pages,
+	OPT_UINTEGER('F', "freq", &record.opts.user_freq, "profile at this frequency"),
+	OPT_UINTEGER('m', "mmap-pages", &record.opts.mmap_pages,
 		     "number of mmap data pages"),
-	OPT_BOOLEAN(0, "group", &record_opts.group,
+	OPT_BOOLEAN(0, "group", &record.opts.group,
 		    "put the counters into a counter group"),
-	OPT_BOOLEAN('g', "call-graph", &record_opts.call_graph,
+	OPT_BOOLEAN('g', "call-graph", &record.opts.call_graph,
 		    "do call-graph (stack chain/backtrace) recording"),
 	OPT_INCR('v', "verbose", &verbose,
 		    "be more verbose (show counter open errors, etc)"),
 	OPT_BOOLEAN('q', "quiet", &quiet, "don't print any message"),
-	OPT_BOOLEAN('s', "stat", &record_opts.inherit_stat,
+	OPT_BOOLEAN('s', "stat", &record.opts.inherit_stat,
 		    "per thread counts"),
-	OPT_BOOLEAN('d', "data", &record_opts.sample_address,
+	OPT_BOOLEAN('d', "data", &record.opts.sample_address,
 		    "Sample addresses"),
-	OPT_BOOLEAN('T', "timestamp", &record_opts.sample_time, "Sample timestamps"),
-	OPT_BOOLEAN('n', "no-samples", &record_opts.no_samples,
+	OPT_BOOLEAN('T', "timestamp", &record.opts.sample_time, "Sample timestamps"),
+	OPT_BOOLEAN('n', "no-samples", &record.opts.no_samples,
 		    "don't sample"),
-	OPT_BOOLEAN('N', "no-buildid-cache", &no_buildid_cache,
+	OPT_BOOLEAN('N', "no-buildid-cache", &record.no_buildid_cache,
 		    "do not update the buildid cache"),
-	OPT_BOOLEAN('B', "no-buildid", &no_buildid,
+	OPT_BOOLEAN('B', "no-buildid", &record.no_buildid,
 		    "do not collect buildids in perf.data"),
-	OPT_CALLBACK('G', "cgroup", &evsel_list, "name",
+	OPT_CALLBACK('G', "cgroup", &record.evlist, "name",
 		     "monitor event in cgroup name only",
 		     parse_cgroups),
 	OPT_END()
@@ -676,6 +719,8 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 {
 	int err = -ENOMEM;
 	struct perf_evsel *pos;
+	struct perf_evlist *evsel_list;
+	struct perf_record *rec = &record;
 
 	perf_header__set_cmdline(argc, argv);
 
@@ -683,23 +728,25 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (evsel_list == NULL)
 		return -ENOMEM;
 
+	rec->evlist = evsel_list;
+
 	argc = parse_options(argc, argv, record_options, record_usage,
 			    PARSE_OPT_STOP_AT_NON_OPTION);
-	if (!argc && record_opts.target_pid == -1 && record_opts.target_tid == -1 &&
-		!record_opts.system_wide && !record_opts.cpu_list)
+	if (!argc && rec->opts.target_pid == -1 && rec->opts.target_tid == -1 &&
+		!rec->opts.system_wide && !rec->opts.cpu_list)
 		usage_with_options(record_usage, record_options);
 
-	if (force && append_file) {
+	if (rec->force && rec->append_file) {
 		fprintf(stderr, "Can't overwrite and append at the same time."
 				" You need to choose between -f and -A");
 		usage_with_options(record_usage, record_options);
-	} else if (append_file) {
-		write_mode = WRITE_APPEND;
+	} else if (rec->append_file) {
+		rec->write_mode = WRITE_APPEND;
 	} else {
-		write_mode = WRITE_FORCE;
+		rec->write_mode = WRITE_FORCE;
 	}
 
-	if (nr_cgroups && !record_opts.system_wide) {
+	if (nr_cgroups && !rec->opts.system_wide) {
 		fprintf(stderr, "cgroup monitoring only available in"
 			" system-wide mode\n");
 		usage_with_options(record_usage, record_options);
@@ -717,7 +764,7 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 "If some relocation was applied (e.g. kexec) symbols may be misresolved\n"
 "even with a suitable vmlinux or kallsyms file.\n\n");
 
-	if (no_buildid_cache || no_buildid)
+	if (rec->no_buildid_cache || rec->no_buildid)
 		disable_buildid_cache();
 
 	if (evsel_list->nr_entries == 0 &&
@@ -726,11 +773,11 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 		goto out_symbol_exit;
 	}
 
-	if (record_opts.target_pid != -1)
-		record_opts.target_tid = record_opts.target_pid;
+	if (rec->opts.target_pid != -1)
+		rec->opts.target_tid = rec->opts.target_pid;
 
-	if (perf_evlist__create_maps(evsel_list, record_opts.target_pid,
-				     record_opts.target_tid, record_opts.cpu_list) < 0)
+	if (perf_evlist__create_maps(evsel_list, rec->opts.target_pid,
+				     rec->opts.target_tid, rec->opts.cpu_list) < 0)
 		usage_with_options(record_usage, record_options);
 
 	list_for_each_entry(pos, &evsel_list->entries, node) {
@@ -744,25 +791,25 @@ int cmd_record(int argc, const char **argv, const char *prefix __used)
 	if (perf_evlist__alloc_pollfd(evsel_list) < 0)
 		goto out_free_fd;
 
-	if (record_opts.user_interval != ULLONG_MAX)
-		record_opts.default_interval = record_opts.user_interval;
-	if (record_opts.user_freq != UINT_MAX)
-		record_opts.freq = record_opts.user_freq;
+	if (rec->opts.user_interval != ULLONG_MAX)
+		rec->opts.default_interval = rec->opts.user_interval;
+	if (rec->opts.user_freq != UINT_MAX)
+		rec->opts.freq = rec->opts.user_freq;
 
 	/*
 	 * User specified count overrides default frequency.
 	 */
-	if (record_opts.default_interval)
-		record_opts.freq = 0;
-	else if (record_opts.freq) {
-		record_opts.default_interval = record_opts.freq;
+	if (rec->opts.default_interval)
+		rec->opts.freq = 0;
+	else if (rec->opts.freq) {
+		rec->opts.default_interval = rec->opts.freq;
 	} else {
 		fprintf(stderr, "frequency and count are zero, aborting\n");
 		err = -EINVAL;
 		goto out_free_fd;
 	}
 
-	err = __cmd_record(argc, argv);
+	err = __cmd_record(&record, argc, argv);
 out_free_fd:
 	perf_evlist__delete_maps(evsel_list);
 out_symbol_exit:
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5d2e819..8795520 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -35,7 +35,9 @@
 
 #include <linux/bitmap.h>
 
-static struct perf_report {
+struct perf_report {
+	struct perf_event_ops	ops;
+	struct perf_session	*session;
 	char const		*input_name;
 	bool			force, use_tui, use_stdio;
 	bool			hide_unresolved;
@@ -48,12 +50,7 @@ static struct perf_report {
 	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
-} report = {
-	.input_name	       = "perf.data",
-	.pretty_printing_style = "normal",
-}, *rep = &report;
-
-static char callchain_default_opt[] = "fractal,0.5,callee";
+};
 
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
@@ -106,11 +103,13 @@ out:
 }
 
 
-static int process_sample_event(union perf_event *event,
+static int process_sample_event(struct perf_event_ops *ops,
+				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
+	struct perf_report *rep = container_of(ops, struct perf_report, ops);
 	struct addr_location al;
 
 	if (perf_event__preprocess_sample(event, session, &al, sample,
@@ -137,10 +136,12 @@ static int process_sample_event(union perf_event *event,
 	return 0;
 }
 
-static int process_read_event(union perf_event *event,
+static int process_read_event(struct perf_event_ops *ops,
+			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session)
 {
+	struct perf_report *rep = container_of(ops, struct perf_report, ops);
 	struct perf_evsel *evsel = perf_evlist__id2evsel(session->evlist,
 							 event->read.id);
 	if (rep->show_threads) {
@@ -159,8 +160,10 @@ static int process_read_event(union perf_event *event,
 	return 0;
 }
 
-static int perf_session__setup_sample_type(struct perf_session *self)
+static int perf_report__setup_sample_type(struct perf_report *rep)
 {
+	struct perf_session *self = rep->session;
+
 	if (!(self->sample_type & PERF_SAMPLE_CALLCHAIN)) {
 		if (sort__has_parent) {
 			ui__warning("Selected --sort parent, but no "
@@ -187,22 +190,6 @@ static int perf_session__setup_sample_type(struct perf_session *self)
 	return 0;
 }
 
-static struct perf_event_ops event_ops = {
-	.sample		 = process_sample_event,
-	.mmap		 = perf_event__process_mmap,
-	.comm		 = perf_event__process_comm,
-	.exit		 = perf_event__process_task,
-	.fork		 = perf_event__process_task,
-	.lost		 = perf_event__process_lost,
-	.read		 = process_read_event,
-	.attr		 = perf_event__process_attr,
-	.event_type	 = perf_event__process_event_type,
-	.tracing_data	 = perf_event__process_tracing_data,
-	.build_id	 = perf_event__process_build_id,
-	.ordered_samples = true,
-	.ordering_requires_timestamps = true,
-};
-
 extern volatile int session_done;
 
 static void sig_handler(int sig __used)
@@ -225,6 +212,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *self,
 }
 
 static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
+					 struct perf_report *rep,
 					 const char *help)
 {
 	struct perf_evsel *pos;
@@ -253,7 +241,7 @@ static int perf_evlist__tty_browse_hists(struct perf_evlist *evlist,
 	return 0;
 }
 
-static int __cmd_report(void)
+static int __cmd_report(struct perf_report *rep)
 {
 	int ret = -EINVAL;
 	u64 nr_samples;
@@ -266,10 +254,12 @@ static int __cmd_report(void)
 	signal(SIGINT, sig_handler);
 
 	session = perf_session__new(rep->input_name, O_RDONLY,
-				    rep->force, false, &event_ops);
+				    rep->force, false, &rep->ops);
 	if (session == NULL)
 		return -ENOMEM;
 
+	rep->session = session;
+
 	if (rep->cpu_list) {
 		ret = perf_session__cpu_bitmap(session, rep->cpu_list,
 					       rep->cpu_bitmap);
@@ -283,11 +273,11 @@ static int __cmd_report(void)
 	if (rep->show_threads)
 		perf_read_values_init(&rep->show_threads_values);
 
-	ret = perf_session__setup_sample_type(session);
+	ret = perf_report__setup_sample_type(rep);
 	if (ret)
 		goto out_delete;
 
-	ret = perf_session__process_events(session, &event_ops);
+	ret = perf_session__process_events(session, &rep->ops);
 	if (ret)
 		goto out_delete;
 
@@ -339,7 +329,7 @@ static int __cmd_report(void)
 		perf_evlist__tui_browse_hists(session->evlist, help,
 					      NULL, NULL, 0);
 	} else
-		perf_evlist__tty_browse_hists(session->evlist, help);
+		perf_evlist__tty_browse_hists(session->evlist, rep, help);
 
 out_delete:
 	/*
@@ -358,9 +348,9 @@ out_delete:
 }
 
 static int
-parse_callchain_opt(const struct option *opt __used, const char *arg,
-		    int unset)
+parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 {
+	struct perf_report *rep = (struct perf_report *)opt->value;
 	char *tok, *tok2;
 	char *endptr;
 
@@ -437,12 +427,33 @@ setup:
 	return 0;
 }
 
-static const char * const report_usage[] = {
-	"perf report [<options>] <command>",
-	NULL
-};
-
-static const struct option options[] = {
+int cmd_report(int argc, const char **argv, const char *prefix __used)
+{
+	char callchain_default_opt[] = "fractal,0.5,callee";
+	const char * const report_usage[] = {
+		"perf report [<options>] <command>",
+		NULL
+	};
+	struct perf_report report = {
+		.ops = {
+			.sample		 = process_sample_event,
+			.mmap		 = perf_event__process_mmap,
+			.comm		 = perf_event__process_comm,
+			.exit		 = perf_event__process_task,
+			.fork		 = perf_event__process_task,
+			.lost		 = perf_event__process_lost,
+			.read		 = process_read_event,
+			.attr		 = perf_event__process_attr,
+			.event_type	 = perf_event__process_event_type,
+			.tracing_data	 = perf_event__process_tracing_data,
+			.build_id	 = perf_event__process_build_id,
+			.ordered_samples = true,
+			.ordering_requires_timestamps = true,
+		},
+		.input_name		 = "perf.data",
+		.pretty_printing_style	 = "normal",
+	};
+	const struct option options[] = {
 	OPT_STRING('i', "input", &report.input_name, "file",
 		    "input file name"),
 	OPT_INCR('v', "verbose", &verbose,
@@ -473,7 +484,7 @@ static const struct option options[] = {
 		   "regex filter to identify parent, see: '--sort parent'"),
 	OPT_BOOLEAN('x', "exclude-other", &symbol_conf.exclude_other,
 		    "Only display entries with parent-match"),
-	OPT_CALLBACK_DEFAULT('g', "call-graph", NULL, "output_type,min_percent, call_order",
+	OPT_CALLBACK_DEFAULT('g', "call-graph", &report, "output_type,min_percent, call_order",
 		     "Display callchains using output_type (graph, flat, fractal, or none) , min percent threshold and callchain order. "
 		     "Default: fractal,0.5,callee", &parse_callchain_opt, callchain_default_opt),
 	OPT_BOOLEAN('G', "inverted", &report.inverted_callchain,
@@ -507,10 +518,8 @@ static const struct option options[] = {
 	OPT_BOOLEAN(0, "show-total-period", &symbol_conf.show_total_period,
 		    "Show a column with the sum of periods"),
 	OPT_END()
-};
+	};
 
-int cmd_report(int argc, const char **argv, const char *prefix __used)
-{
 	argc = parse_options(argc, argv, options, report_usage, 0);
 
 	if (report.use_stdio)
@@ -579,5 +588,5 @@ int cmd_report(int argc, const char **argv, const char *prefix __used)
 	sort_entry__setup_elide(&sort_comm, symbol_conf.comm_list, "comm", stdout);
 	sort_entry__setup_elide(&sort_sym, symbol_conf.sym_list, "symbol", stdout);
 
-	return __cmd_report();
+	return __cmd_report(&report);
 }
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index d51af0b..b11d628 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1602,7 +1602,8 @@ static void process_raw_event(union perf_event *raw_event __used,
 		process_sched_migrate_task_event(data, session, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(union perf_event *event,
+static int process_sample_event(struct perf_event_ops *ops __used,
+				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct perf_session *session)
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 47545e9..3b78206 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -434,7 +434,8 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static int process_sample_event(union perf_event *event,
+static int process_sample_event(struct perf_event_ops *ops __used,
+				union perf_event *event,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct perf_session *session)
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 3fc52b1..62298a0 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -274,7 +274,8 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int process_comm_event(union perf_event *event,
+static int process_comm_event(struct perf_event_ops *ops __used,
+			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
@@ -282,7 +283,8 @@ static int process_comm_event(union perf_event *event,
 	return 0;
 }
 
-static int process_fork_event(union perf_event *event,
+static int process_fork_event(struct perf_event_ops *ops __used,
+			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
@@ -290,7 +292,8 @@ static int process_fork_event(union perf_event *event,
 	return 0;
 }
 
-static int process_exit_event(union perf_event *event,
+static int process_exit_event(struct perf_event_ops *ops __used,
+			      union perf_event *event,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
@@ -487,7 +490,8 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 }
 
 
-static int process_sample_event(union perf_event *event __used,
+static int process_sample_event(struct perf_event_ops *ops __used,
+				union perf_event *event __used,
 				struct perf_sample *sample,
 				struct perf_evsel *evsel,
 				struct perf_session *session __used)
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 9b3bbb4..e8e3320 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -824,7 +824,7 @@ static void perf_session__mmap_read_idx(struct perf_session *self, int idx)
 			perf_event__process_sample(event, evsel, &sample, self);
 		else if (event->header.type < PERF_RECORD_MAX) {
 			hists__inc_nr_events(&evsel->hists, event->header.type);
-			perf_event__process(event, &sample, self);
+			perf_event__process(&top.ops, event, &sample, self);
 		} else
 			++self->hists.stats.nr_unknown_events;
 	}
@@ -966,10 +966,10 @@ static int __cmd_top(void)
 		goto out_delete;
 
 	if (top.target_tid != -1)
-		perf_event__synthesize_thread_map(top.evlist->threads,
+		perf_event__synthesize_thread_map(&top.ops, top.evlist->threads,
 						  perf_event__process, top.session);
 	else
-		perf_event__synthesize_threads(perf_event__process, top.session);
+		perf_event__synthesize_threads(&top.ops, perf_event__process, top.session);
 
 	start_counters(top.evlist);
 	top.session->evlist = top.evlist;
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index f2fe6ec..0e4de18 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -13,8 +13,10 @@
 #include "symbol.h"
 #include <linux/kernel.h>
 #include "debug.h"
+#include "session.h"
 
-static int build_id__mark_dso_hit(union perf_event *event,
+static int build_id__mark_dso_hit(struct perf_event_ops *ops __used,
+				  union perf_event *event,
 				  struct perf_sample *sample __used,
 				  struct perf_evsel *evsel __used,
 				  struct perf_session *session)
@@ -38,7 +40,8 @@ static int build_id__mark_dso_hit(union perf_event *event,
 	return 0;
 }
 
-static int perf_event__exit_del_thread(union perf_event *event,
+static int perf_event__exit_del_thread(struct perf_event_ops *ops __used,
+				       union perf_event *event,
 				       struct perf_sample *sample __used,
 				       struct perf_session *session)
 {
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 9b4ff16..7f9c0f1 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -101,6 +101,9 @@ int callchain_append(struct callchain_root *root,
 int callchain_merge(struct callchain_cursor *cursor,
 		    struct callchain_root *dst, struct callchain_root *src);
 
+struct ip_callchain;
+union perf_event;
+
 bool ip_callchain__valid(struct ip_callchain *chain,
 			 const union perf_event *event);
 /*
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 437f8ca..4800f38 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -44,7 +44,8 @@ static struct perf_sample synth_sample = {
 	.period	   = 1,
 };
 
-static pid_t perf_event__synthesize_comm(union perf_event *event, pid_t pid,
+static pid_t perf_event__synthesize_comm(struct perf_event_ops *ops,
+					 union perf_event *event, pid_t pid,
 					 int full, perf_event__handler_t process,
 					 struct perf_session *session)
 {
@@ -99,7 +100,7 @@ out_race:
 	if (!full) {
 		event->comm.tid = pid;
 
-		process(event, &synth_sample, session);
+		process(ops, event, &synth_sample, session);
 		goto out;
 	}
 
@@ -117,7 +118,7 @@ out_race:
 
 		event->comm.tid = pid;
 
-		process(event, &synth_sample, session);
+		process(ops, event, &synth_sample, session);
 	}
 
 	closedir(tasks);
@@ -127,7 +128,8 @@ out:
 	return tgid;
 }
 
-static int perf_event__synthesize_mmap_events(union perf_event *event,
+static int perf_event__synthesize_mmap_events(struct perf_event_ops *ops,
+					      union perf_event *event,
 					      pid_t pid, pid_t tgid,
 					      perf_event__handler_t process,
 					      struct perf_session *session)
@@ -198,7 +200,7 @@ static int perf_event__synthesize_mmap_events(union perf_event *event,
 			event->mmap.pid = tgid;
 			event->mmap.tid = pid;
 
-			process(event, &synth_sample, session);
+			process(ops, event, &synth_sample, session);
 		}
 	}
 
@@ -206,7 +208,8 @@ static int perf_event__synthesize_mmap_events(union perf_event *event,
 	return 0;
 }
 
-int perf_event__synthesize_modules(perf_event__handler_t process,
+int perf_event__synthesize_modules(struct perf_event_ops *ops,
+				   perf_event__handler_t process,
 				   struct perf_session *session,
 				   struct machine *machine)
 {
@@ -251,7 +254,7 @@ int perf_event__synthesize_modules(perf_event__handler_t process,
 
 		memcpy(event->mmap.filename, pos->dso->long_name,
 		       pos->dso->long_name_len + 1);
-		process(event, &synth_sample, session);
+		process(ops, event, &synth_sample, session);
 	}
 
 	free(event);
@@ -261,17 +264,19 @@ int perf_event__synthesize_modules(perf_event__handler_t process,
 static int __event__synthesize_thread(union perf_event *comm_event,
 				      union perf_event *mmap_event,
 				      pid_t pid, perf_event__handler_t process,
+				      struct perf_event_ops *ops,
 				      struct perf_session *session)
 {
-	pid_t tgid = perf_event__synthesize_comm(comm_event, pid, 1, process,
+	pid_t tgid = perf_event__synthesize_comm(ops, comm_event, pid, 1, process,
 					    session);
 	if (tgid == -1)
 		return -1;
-	return perf_event__synthesize_mmap_events(mmap_event, pid, tgid,
+	return perf_event__synthesize_mmap_events(ops, mmap_event, pid, tgid,
 					     process, session);
 }
 
-int perf_event__synthesize_thread_map(struct thread_map *threads,
+int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
+				      struct thread_map *threads,
 				      perf_event__handler_t process,
 				      struct perf_session *session)
 {
@@ -290,7 +295,7 @@ int perf_event__synthesize_thread_map(struct thread_map *threads,
 	for (thread = 0; thread < threads->nr; ++thread) {
 		if (__event__synthesize_thread(comm_event, mmap_event,
 					       threads->map[thread],
-					       process, session)) {
+					       process, ops, session)) {
 			err = -1;
 			break;
 		}
@@ -302,7 +307,8 @@ out:
 	return err;
 }
 
-int perf_event__synthesize_threads(perf_event__handler_t process,
+int perf_event__synthesize_threads(struct perf_event_ops *ops,
+				   perf_event__handler_t process,
 				   struct perf_session *session)
 {
 	DIR *proc;
@@ -330,7 +336,7 @@ int perf_event__synthesize_threads(perf_event__handler_t process,
 			continue;
 
 		__event__synthesize_thread(comm_event, mmap_event, pid,
-					   process, session);
+					   process, ops, session);
 	}
 
 	closedir(proc);
@@ -365,7 +371,8 @@ static int find_symbol_cb(void *arg, const char *name, char type,
 	return 1;
 }
 
-int perf_event__synthesize_kernel_mmap(perf_event__handler_t process,
+int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
+				       perf_event__handler_t process,
 				       struct perf_session *session,
 				       struct machine *machine,
 				       const char *symbol_name)
@@ -423,13 +430,14 @@ int perf_event__synthesize_kernel_mmap(perf_event__handler_t process,
 	event->mmap.len   = map->end - event->mmap.start;
 	event->mmap.pid   = machine->pid;
 
-	err = process(event, &synth_sample, session);
+	err = process(ops, event, &synth_sample, session);
 	free(event);
 
 	return err;
 }
 
-int perf_event__process_comm(union perf_event *event,
+int perf_event__process_comm(struct perf_event_ops *ops __used,
+			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct perf_session *session)
 {
@@ -445,7 +453,8 @@ int perf_event__process_comm(union perf_event *event,
 	return 0;
 }
 
-int perf_event__process_lost(union perf_event *event,
+int perf_event__process_lost(struct perf_event_ops *ops __used,
+			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct perf_session *session)
 {
@@ -468,7 +477,8 @@ static void perf_event__set_kernel_mmap_len(union perf_event *event,
 		maps[MAP__FUNCTION]->end = ~0ULL;
 }
 
-static int perf_event__process_kernel_mmap(union perf_event *event,
+static int perf_event__process_kernel_mmap(struct perf_event_ops *ops __used,
+					   union perf_event *event,
 					   struct perf_session *session)
 {
 	struct map *map;
@@ -567,7 +577,8 @@ out_problem:
 	return -1;
 }
 
-int perf_event__process_mmap(union perf_event *event,
+int perf_event__process_mmap(struct perf_event_ops *ops,
+			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct perf_session *session)
 {
@@ -583,7 +594,7 @@ int perf_event__process_mmap(union perf_event *event,
 
 	if (cpumode == PERF_RECORD_MISC_GUEST_KERNEL ||
 	    cpumode == PERF_RECORD_MISC_KERNEL) {
-		ret = perf_event__process_kernel_mmap(event, session);
+		ret = perf_event__process_kernel_mmap(ops, event, session);
 		if (ret < 0)
 			goto out_problem;
 		return 0;
@@ -610,7 +621,8 @@ out_problem:
 	return 0;
 }
 
-int perf_event__process_task(union perf_event *event,
+int perf_event__process_task(struct perf_event_ops *ops __used,
+			     union perf_event *event,
 			     struct perf_sample *sample __used,
 			     struct perf_session *session)
 {
@@ -634,22 +646,22 @@ int perf_event__process_task(union perf_event *event,
 	return 0;
 }
 
-int perf_event__process(union perf_event *event, struct perf_sample *sample,
-			struct perf_session *session)
+int perf_event__process(struct perf_event_ops *ops, union perf_event *event,
+			struct perf_sample *sample, struct perf_session *session)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		perf_event__process_comm(event, sample, session);
+		perf_event__process_comm(ops, event, sample, session);
 		break;
 	case PERF_RECORD_MMAP:
-		perf_event__process_mmap(event, sample, session);
+		perf_event__process_mmap(ops, event, sample, session);
 		break;
 	case PERF_RECORD_FORK:
 	case PERF_RECORD_EXIT:
-		perf_event__process_task(event, sample, session);
+		perf_event__process_task(ops, event, sample, session);
 		break;
 	case PERF_RECORD_LOST:
-		perf_event__process_lost(event, sample, session);
+		perf_event__process_lost(ops, event, sample, session);
 	default:
 		break;
 	}
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 357a85b..669409d 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -141,38 +141,52 @@ union perf_event {
 
 void perf_event__print_totals(void);
 
+struct perf_event_ops;
 struct perf_session;
 struct thread_map;
 
-typedef int (*perf_event__handler_synth_t)(union perf_event *event, 
-					   struct perf_session *session);
-typedef int (*perf_event__handler_t)(union perf_event *event,
+typedef int (*perf_event__handler_t)(struct perf_event_ops *ops,
+				     union perf_event *event,
 				     struct perf_sample *sample,
 				      struct perf_session *session);
 
-int perf_event__synthesize_thread_map(struct thread_map *threads,
+int perf_event__synthesize_thread_map(struct perf_event_ops *ops,
+				      struct thread_map *threads,
 				      perf_event__handler_t process,
 				      struct perf_session *session);
-int perf_event__synthesize_threads(perf_event__handler_t process,
+int perf_event__synthesize_threads(struct perf_event_ops *ops,
+				   perf_event__handler_t process,
 				   struct perf_session *session);
-int perf_event__synthesize_kernel_mmap(perf_event__handler_t process,
+int perf_event__synthesize_kernel_mmap(struct perf_event_ops *ops,
+				       perf_event__handler_t process,
 				       struct perf_session *session,
 				       struct machine *machine,
 				       const char *symbol_name);
 
-int perf_event__synthesize_modules(perf_event__handler_t process,
+int perf_event__synthesize_modules(struct perf_event_ops *ops,
+				   perf_event__handler_t process,
 				   struct perf_session *session,
 				   struct machine *machine);
 
-int perf_event__process_comm(union perf_event *event, struct perf_sample *sample,
+int perf_event__process_comm(struct perf_event_ops *ops,
+			     union perf_event *event,
+			     struct perf_sample *sample,
 			     struct perf_session *session);
-int perf_event__process_lost(union perf_event *event, struct perf_sample *sample,
+int perf_event__process_lost(struct perf_event_ops *ops,
+			     union perf_event *event,
+			     struct perf_sample *sample,
 			     struct perf_session *session);
-int perf_event__process_mmap(union perf_event *event, struct perf_sample *sample,
+int perf_event__process_mmap(struct perf_event_ops *ops,
+			     union perf_event *event,
+			     struct perf_sample *sample,
 			     struct perf_session *session);
-int perf_event__process_task(union perf_event *event, struct perf_sample *sample,
+int perf_event__process_task(struct perf_event_ops *ops,
+			     union perf_event *event,
+			     struct perf_sample *sample,
 			     struct perf_session *session);
-int perf_event__process(union perf_event *event, struct perf_sample *sample,
+int perf_event__process(struct perf_event_ops *ops,
+			union perf_event *event,
+			struct perf_sample *sample,
 			struct perf_session *session);
 
 struct addr_location;
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 1fa97dd..ab3a2b0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -2070,7 +2070,8 @@ out_delete_evlist:
 	return -ENOMEM;
 }
 
-int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+int perf_event__synthesize_attr(struct perf_event_ops *ops,
+				struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process,
 				struct perf_session *session)
 {
@@ -2094,21 +2095,22 @@ int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
 	ev->attr.header.size = size;
 
-	err = process(ev, NULL, session);
+	err = process(ops, ev, NULL, session);
 
 	free(ev);
 
 	return err;
 }
 
-int perf_session__synthesize_attrs(struct perf_session *session,
+int perf_event__synthesize_attrs(struct perf_event_ops *ops,
+				   struct perf_session *session,
 				   perf_event__handler_t process)
 {
 	struct perf_evsel *attr;
 	int err = 0;
 
 	list_for_each_entry(attr, &session->evlist->entries, node) {
-		err = perf_event__synthesize_attr(&attr->attr, attr->ids,
+		err = perf_event__synthesize_attr(ops, &attr->attr, attr->ids,
 						  attr->id, process, session);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
@@ -2156,7 +2158,8 @@ int perf_event__process_attr(union perf_event *event,
 	return 0;
 }
 
-int perf_event__synthesize_event_type(u64 event_id, char *name,
+int perf_event__synthesize_event_type(struct perf_event_ops *ops,
+				      u64 event_id, char *name,
 				      perf_event__handler_t process,
 				      struct perf_session *session)
 {
@@ -2176,12 +2179,13 @@ int perf_event__synthesize_event_type(u64 event_id, char *name,
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
 
-	err = process(&ev, NULL, session);
+	err = process(ops, &ev, NULL, session);
 
 	return err;
 }
 
-int perf_event__synthesize_event_types(perf_event__handler_t process,
+int perf_event__synthesize_event_types(struct perf_event_ops *ops,
+				       perf_event__handler_t process,
 				       struct perf_session *session)
 {
 	struct perf_trace_event_type *type;
@@ -2190,7 +2194,7 @@ int perf_event__synthesize_event_types(perf_event__handler_t process,
 	for (i = 0; i < event_count; i++) {
 		type = &events[i];
 
-		err = perf_event__synthesize_event_type(type->event_id,
+		err = perf_event__synthesize_event_type(ops, type->event_id,
 							type->name, process,
 							session);
 		if (err) {
@@ -2202,7 +2206,8 @@ int perf_event__synthesize_event_types(perf_event__handler_t process,
 	return err;
 }
 
-int perf_event__process_event_type(union perf_event *event,
+int perf_event__process_event_type(struct perf_event_ops *ops __unused,
+				   union perf_event *event,
 				   struct perf_session *session __unused)
 {
 	if (perf_header__push_event(event->event_type.event_type.event_id,
@@ -2212,7 +2217,8 @@ int perf_event__process_event_type(union perf_event *event,
 	return 0;
 }
 
-int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
+int perf_event__synthesize_tracing_data(struct perf_event_ops *ops, int fd,
+					struct perf_evlist *evlist,
 					 perf_event__handler_t process,
 				   struct perf_session *session __unused)
 {
@@ -2245,7 +2251,7 @@ int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
 	ev.tracing_data.size = aligned_size;
 
-	process(&ev, NULL, session);
+	process(ops, &ev, NULL, session);
 
 	/*
 	 * The put function will copy all the tracing data
@@ -2287,7 +2293,8 @@ int perf_event__process_tracing_data(union perf_event *event,
 	return size_read + padding;
 }
 
-int perf_event__synthesize_build_id(struct dso *pos, u16 misc,
+int perf_event__synthesize_build_id(struct perf_event_ops *ops,
+				    struct dso *pos, u16 misc,
 				    perf_event__handler_t process,
 				    struct machine *machine,
 				    struct perf_session *session)
@@ -2310,12 +2317,13 @@ int perf_event__synthesize_build_id(struct dso *pos, u16 misc,
 	ev.build_id.header.size = sizeof(ev.build_id) + len;
 	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
 
-	err = process(&ev, NULL, session);
+	err = process(ops, &ev, NULL, session);
 
 	return err;
 }
 
-int perf_event__process_build_id(union perf_event *event,
+int perf_event__process_build_id(struct perf_event_ops *ops __used,
+				 union perf_event *event,
 				 struct perf_session *session)
 {
 	__event_process_build_id(&event->build_id,
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index 0a88982..54dae5f 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -68,6 +68,7 @@ struct perf_header {
 };
 
 struct perf_evlist;
+struct perf_session;
 
 int perf_session__read_header(struct perf_session *session, int fd);
 int perf_session__write_header(struct perf_session *session,
@@ -96,32 +97,40 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
-int perf_event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
+int perf_event__synthesize_attr(struct perf_event_ops *ops,
+				struct perf_event_attr *attr, u16 ids, u64 *id,
 				perf_event__handler_t process,
 				struct perf_session *session);
-int perf_session__synthesize_attrs(struct perf_session *session,
-				   perf_event__handler_t process);
+int perf_event__synthesize_attrs(struct perf_event_ops *ops,
+				 struct perf_session *session,
+				 perf_event__handler_t process);
 int perf_event__process_attr(union perf_event *event, struct perf_evlist **pevlist);
 
-int perf_event__synthesize_event_type(u64 event_id, char *name,
+int perf_event__synthesize_event_type(struct perf_event_ops *ops,
+				      u64 event_id, char *name,
 				      perf_event__handler_t process,
 				      struct perf_session *session);
-int perf_event__synthesize_event_types(perf_event__handler_t process,
+int perf_event__synthesize_event_types(struct perf_event_ops *ops,
+				       perf_event__handler_t process,
 				       struct perf_session *session);
-int perf_event__process_event_type(union perf_event *event,
+int perf_event__process_event_type(struct perf_event_ops *ops,
+				   union perf_event *event,
 				   struct perf_session *session);
 
-int perf_event__synthesize_tracing_data(int fd, struct perf_evlist *evlist,
+int perf_event__synthesize_tracing_data(struct perf_event_ops *ops,
+					int fd, struct perf_evlist *evlist,
 					perf_event__handler_t process,
 					struct perf_session *session);
 int perf_event__process_tracing_data(union perf_event *event,
 				     struct perf_session *session);
 
-int perf_event__synthesize_build_id(struct dso *pos, u16 misc,
+int perf_event__synthesize_build_id(struct perf_event_ops *ops,
+				    struct dso *pos, u16 misc,
 				    perf_event__handler_t process,
 				    struct machine *machine,
 				    struct perf_session *session);
-int perf_event__process_build_id(union perf_event *event,
+int perf_event__process_build_id(struct perf_event_ops *ops,
+				 union perf_event *event,
 				 struct perf_session *session);
 
 /*
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 734358b..a36023a 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -270,13 +270,21 @@ int perf_session__resolve_callchain(struct perf_session *self, struct perf_evsel
 	return 0;
 }
 
-static int process_event_synth_stub(union perf_event *event __used,
+static int process_event_synth_stub(struct perf_event_ops *ops __used,
+				    union perf_event *event __used,
 				    struct perf_session *session __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
 }
 
+static int process_event_synth_tracing_data_stub(union perf_event *event __used,
+						 struct perf_session *session __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 static int process_event_synth_attr_stub(union perf_event *event __used,
 					 struct perf_evlist **pevlist __used)
 {
@@ -284,7 +292,8 @@ static int process_event_synth_attr_stub(union perf_event *event __used,
 	return 0;
 }
 
-static int process_event_sample_stub(union perf_event *event __used,
+static int process_event_sample_stub(struct perf_event_ops *ops __used,
+				     union perf_event *event __used,
 				     struct perf_sample *sample __used,
 				     struct perf_evsel *evsel __used,
 				     struct perf_session *session __used)
@@ -293,7 +302,8 @@ static int process_event_sample_stub(union perf_event *event __used,
 	return 0;
 }
 
-static int process_event_stub(union perf_event *event __used,
+static int process_event_stub(struct perf_event_ops *ops __used,
+			      union perf_event *event __used,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
 {
@@ -301,17 +311,17 @@ static int process_event_stub(union perf_event *event __used,
 	return 0;
 }
 
-static int process_finished_round_stub(union perf_event *event __used,
-				       struct perf_session *session __used,
-				       struct perf_event_ops *ops __used)
+static int process_finished_round_stub(struct perf_event_ops *ops __used,
+				       union perf_event *event __used,
+				       struct perf_session *session __used)
 {
 	dump_printf(": unhandled!\n");
 	return 0;
 }
 
-static int process_finished_round(union perf_event *event,
-				  struct perf_session *session,
-				  struct perf_event_ops *ops);
+static int process_finished_round(struct perf_event_ops *ops,
+				  union perf_event *event,
+				  struct perf_session *session);
 
 static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 {
@@ -338,7 +348,7 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->event_type == NULL)
 		handler->event_type = process_event_synth_stub;
 	if (handler->tracing_data == NULL)
-		handler->tracing_data = process_event_synth_stub;
+		handler->tracing_data = process_event_synth_tracing_data_stub;
 	if (handler->build_id == NULL)
 		handler->build_id = process_event_synth_stub;
 	if (handler->finished_round == NULL) {
@@ -565,9 +575,9 @@ static void flush_sample_queue(struct perf_session *s,
  *      Flush every events below timestamp 7
  *      etc...
  */
-static int process_finished_round(union perf_event *event __used,
-				  struct perf_session *session,
-				  struct perf_event_ops *ops)
+static int process_finished_round(struct perf_event_ops *ops,
+				  union perf_event *event __used,
+				  struct perf_session *session)
 {
 	flush_sample_queue(session, ops);
 	session->ordered_samples.next_flush = session->ordered_samples.max_timestamp;
@@ -759,23 +769,23 @@ static int perf_session_deliver_event(struct perf_session *session,
 			++session->hists.stats.nr_unknown_id;
 			return -1;
 		}
-		return ops->sample(event, sample, evsel, session);
+		return ops->sample(ops, event, sample, evsel, session);
 	case PERF_RECORD_MMAP:
-		return ops->mmap(event, sample, session);
+		return ops->mmap(ops, event, sample, session);
 	case PERF_RECORD_COMM:
-		return ops->comm(event, sample, session);
+		return ops->comm(ops, event, sample, session);
 	case PERF_RECORD_FORK:
-		return ops->fork(event, sample, session);
+		return ops->fork(ops, event, sample, session);
 	case PERF_RECORD_EXIT:
-		return ops->exit(event, sample, session);
+		return ops->exit(ops, event, sample, session);
 	case PERF_RECORD_LOST:
-		return ops->lost(event, sample, session);
+		return ops->lost(ops, event, sample, session);
 	case PERF_RECORD_READ:
-		return ops->read(event, sample, session);
+		return ops->read(ops, event, sample, session);
 	case PERF_RECORD_THROTTLE:
-		return ops->throttle(event, sample, session);
+		return ops->throttle(ops, event, sample, session);
 	case PERF_RECORD_UNTHROTTLE:
-		return ops->unthrottle(event, sample, session);
+		return ops->unthrottle(ops, event, sample, session);
 	default:
 		++session->hists.stats.nr_unknown_events;
 		return -1;
@@ -813,15 +823,15 @@ static int perf_session__process_user_event(struct perf_session *session, union
 			perf_session__update_sample_type(session);
 		return err;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
-		return ops->event_type(event, session);
+		return ops->event_type(ops, event, session);
 	case PERF_RECORD_HEADER_TRACING_DATA:
 		/* setup for reading amidst mmap */
 		lseek(session->fd, file_offset, SEEK_SET);
 		return ops->tracing_data(event, session);
 	case PERF_RECORD_HEADER_BUILD_ID:
-		return ops->build_id(event, session);
+		return ops->build_id(ops, event, session);
 	case PERF_RECORD_FINISHED_ROUND:
-		return ops->finished_round(event, session, ops);
+		return ops->finished_round(ops, event, session);
 	default:
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index d2f4303..6de3d13 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -56,16 +56,18 @@ struct perf_session {
 struct perf_evsel;
 struct perf_event_ops;
 
-typedef int (*event_sample)(union perf_event *event, struct perf_sample *sample,
+typedef int (*event_sample)(struct perf_event_ops *ops,
+			    union perf_event *event, struct perf_sample *sample,
 			    struct perf_evsel *evsel, struct perf_session *session);
-typedef int (*event_op)(union perf_event *self, struct perf_sample *sample,
+typedef int (*event_op)(struct perf_event_ops *ops, union perf_event *event,
+			struct perf_sample *sample,
 			struct perf_session *session);
 typedef int (*event_synth_op)(union perf_event *self,
 			      struct perf_session *session);
 typedef int (*event_attr_op)(union perf_event *event,
 			     struct perf_evlist **pevlist);
-typedef int (*event_op2)(union perf_event *self, struct perf_session *session,
-			 struct perf_event_ops *ops);
+typedef int (*event_op2)(struct perf_event_ops *ops, union perf_event *event,
+			 struct perf_session *session);
 
 struct perf_event_ops {
 	event_sample	sample;
@@ -78,10 +80,10 @@ struct perf_event_ops {
 			throttle,
 			unthrottle;
 	event_attr_op	attr;
-	event_synth_op	event_type,
-			tracing_data,
-			build_id;
-	event_op2	finished_round;
+	event_synth_op	tracing_data;
+	event_op2	event_type,
+			build_id,
+			finished_round;
 	bool		ordered_samples;
 	bool		ordering_requires_timestamps;
 };
@@ -142,10 +144,11 @@ struct machine *perf_session__findnew_machine(struct perf_session *self, pid_t p
 
 static inline
 void perf_session__process_machines(struct perf_session *self,
+				    struct perf_event_ops *ops,
 				    machine__process_t process)
 {
-	process(&self->host_machine, self);
-	return machines__process(&self->machines, process, self);
+	process(&self->host_machine, ops);
+	return machines__process(&self->machines, process, ops);
 }
 
 size_t perf_session__fprintf_dsos(struct perf_session *self, FILE *fp);
diff --git a/tools/perf/util/top.h b/tools/perf/util/top.h
index 3996509..44eda6f 100644
--- a/tools/perf/util/top.h
+++ b/tools/perf/util/top.h
@@ -2,14 +2,15 @@
 #define __PERF_TOP_H 1
 
 #include "types.h"
+#include "session.h"
 #include "../perf.h"
 #include <stddef.h>
 
 struct perf_evlist;
 struct perf_evsel;
-struct perf_session;
 
 struct perf_top {
+	struct perf_event_ops ops;
 	struct perf_evlist *evlist;
 	/*
 	 * Symbols will be added here in perf_event__process_sample and will
