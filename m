Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab1CXJBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:01:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:38254 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032Ab1CXJBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:01:14 -0400
Date: Thu, 24 Mar 2011 09:00:44 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, tzanussi@gmail.com,
        efault@gmx.de, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf session: Pass evsel in event_ops->sample()
Message-ID: <tip-9e69c210822c4035708a6111567c96364ca244d5@git.kernel.org>
Git-Commit-ID: 9e69c210822c4035708a6111567c96364ca244d5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 24 Mar 2011 09:00:45 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9e69c210822c4035708a6111567c96364ca244d5
Gitweb:     http://git.kernel.org/tip/9e69c210822c4035708a6111567c96364ca244d5
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 15 Mar 2011 15:44:01 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Mar 2011 19:28:58 -0300

perf session: Pass evsel in event_ops->sample()

Resolving the sample->id to an evsel since the most advanced tools,
report and annotate, and the others will too when they evolve to
properly support multi-event perf.data files.

Good also because it does an extra validation, checking that the ID is
valid when present. When that is not the case, the overhead is just a
branch + function call (perf_evlist__id2evsel).

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c                      |   18 +++-----------
 tools/perf/builtin-diff.c                          |    1 +
 tools/perf/builtin-inject.c                        |   11 ++++++++-
 tools/perf/builtin-kmem.c                          |    1 +
 tools/perf/builtin-lock.c                          |    4 ++-
 tools/perf/builtin-report.c                        |   19 +++------------
 tools/perf/builtin-sched.c                         |    1 +
 tools/perf/builtin-script.c                        |   15 +++--------
 tools/perf/builtin-timechart.c                     |   11 ++++++++
 tools/perf/util/build-id.c                         |    1 +
 tools/perf/util/hist.h                             |    1 +
 .../perf/util/scripting-engines/trace-event-perl.c |    1 +
 .../util/scripting-engines/trace-event-python.c    |    1 +
 tools/perf/util/session.c                          |   25 ++++++++++++++++++-
 tools/perf/util/session.h                          |    7 ++++-
 tools/perf/util/trace-event-scripting.c            |    1 +
 tools/perf/util/trace-event.h                      |    1 +
 17 files changed, 73 insertions(+), 46 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 695de4b..e18eb7e 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -42,9 +42,9 @@ static const char *sym_hist_filter;
 
 static int perf_evlist__add_sample(struct perf_evlist *evlist,
 				   struct perf_sample *sample,
+				   struct perf_evsel *evsel,
 				   struct addr_location *al)
 {
-	struct perf_evsel *evsel;
 	struct hist_entry *he;
 	int ret;
 
@@ -59,18 +59,6 @@ static int perf_evlist__add_sample(struct perf_evlist *evlist,
 		return 0;
 	}
 
-	evsel = perf_evlist__id2evsel(evlist, sample->id);
-	if (evsel == NULL) {
-		/*
-		 * FIXME: Propagate this back, but at least we're in a builtin,
-		 * where exit() is allowed. ;-)
-		 */
-		ui__warning("Invalid %s file, contains samples with id not in "
-			    "its header!\n", input_name);
-		exit_browser(0);
-		exit(1);
-	}
-
 	he = __hists__add_entry(&evsel->hists, al, NULL, 1);
 	if (he == NULL)
 		return -ENOMEM;
@@ -92,6 +80,7 @@ static int perf_evlist__add_sample(struct perf_evlist *evlist,
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
 	struct addr_location al;
@@ -103,7 +92,8 @@ static int process_sample_event(union perf_event *event,
 		return -1;
 	}
 
-	if (!al.filtered && perf_evlist__add_sample(session->evlist, sample, &al)) {
+	if (!al.filtered &&
+	    perf_evlist__add_sample(session->evlist, sample, evsel, &al)) {
 		pr_warning("problem incrementing symbol count, "
 			   "skipping event\n");
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6b7d911..e821999 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -32,6 +32,7 @@ static int hists__add_entry(struct hists *self,
 
 static int diff__process_sample_event(union perf_event *event,
 				      struct perf_sample *sample,
+				      struct perf_evsel *evsel __used,
 				      struct perf_session *session)
 {
 	struct addr_location al;
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index e29f04e..8dfc12b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -43,6 +43,14 @@ static int perf_event__repipe(union perf_event *event,
 	return perf_event__repipe_synth(event, session);
 }
 
+static int perf_event__repipe_sample(union perf_event *event,
+			      struct perf_sample *sample __used,
+			      struct perf_evsel *evsel __used,
+			      struct perf_session *session)
+{
+	return perf_event__repipe_synth(event, session);
+}
+
 static int perf_event__repipe_mmap(union perf_event *event,
 				   struct perf_sample *sample,
 				   struct perf_session *session)
@@ -124,6 +132,7 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 
 static int perf_event__inject_buildid(union perf_event *event,
 				      struct perf_sample *sample,
+				      struct perf_evsel *evsel __used,
 				      struct perf_session *session)
 {
 	struct addr_location al;
@@ -164,7 +173,7 @@ repipe:
 }
 
 struct perf_event_ops inject_ops = {
-	.sample		= perf_event__repipe,
+	.sample		= perf_event__repipe_sample,
 	.mmap		= perf_event__repipe,
 	.comm		= perf_event__repipe,
 	.fork		= perf_event__repipe,
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 7f618f4..225e963 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -305,6 +305,7 @@ static void process_raw_event(union perf_event *raw_event __used, void *data,
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 7a2a79d..9ac05aa 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -845,7 +845,9 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(union perf_event *event, struct perf_sample *sample,
+static int process_sample_event(union perf_event *event,
+				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *s)
 {
 	struct thread *thread = perf_session__findnew(s, sample->tid);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index b1b8200..498c6f7 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -50,12 +50,12 @@ static symbol_filter_t	annotate_init;
 
 static int perf_session__add_hist_entry(struct perf_session *session,
 					struct addr_location *al,
-					struct perf_sample *sample)
+					struct perf_sample *sample,
+					struct perf_evsel *evsel)
 {
 	struct symbol *parent = NULL;
 	int err = 0;
 	struct hist_entry *he;
-	struct perf_evsel *evsel;
 
 	if ((sort__has_parent || symbol_conf.use_callchain) && sample->callchain) {
 		err = perf_session__resolve_callchain(session, al->thread,
@@ -64,18 +64,6 @@ static int perf_session__add_hist_entry(struct perf_session *session,
 			return err;
 	}
 
-	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
-	if (evsel == NULL) {
-		/*
-		 * FIXME: Propagate this back, but at least we're in a builtin,
-		 * where exit() is allowed. ;-)
-		 */
-		ui__warning("Invalid %s file, contains samples with id %" PRIu64 " not in "
-			    "its header!\n", input_name, sample->id);
-		exit_browser(0);
-		exit(1);
-	}
-
 	he = __hists__add_entry(&evsel->hists, al, parent, sample->period);
 	if (he == NULL)
 		return -ENOMEM;
@@ -113,6 +101,7 @@ out:
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
 	struct addr_location al;
@@ -127,7 +116,7 @@ static int process_sample_event(union perf_event *event,
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
-	if (perf_session__add_hist_entry(session, &al, sample)) {
+	if (perf_session__add_hist_entry(session, &al, sample, evsel)) {
 		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index a32f411..dcfe887 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1603,6 +1603,7 @@ static void process_raw_event(union perf_event *raw_event __used,
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *session)
 {
 	struct thread *thread;
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9f5fc54..ac574ea 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -162,19 +162,11 @@ static void print_sample_start(struct perf_sample *sample,
 
 static void process_event(union perf_event *event __unused,
 			  struct perf_sample *sample,
+			  struct perf_evsel *evsel,
 			  struct perf_session *session,
 			  struct thread *thread)
 {
-	struct perf_event_attr *attr;
-	struct perf_evsel *evsel;
-
-	evsel = perf_evlist__id2evsel(session->evlist, sample->id);
-	if (evsel == NULL) {
-		pr_err("Invalid data. Contains samples with id not in "
-		       "its header!\n");
-		return;
-	}
-	attr = &evsel->attr;
+	struct perf_event_attr *attr = &evsel->attr;
 
 	if (output_fields[attr->type] == 0)
 		return;
@@ -244,6 +236,7 @@ static char const		*input_name = "perf.data";
 
 static int process_sample_event(union perf_event *event,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel,
 				struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, event->ip.pid);
@@ -264,7 +257,7 @@ static int process_sample_event(union perf_event *event,
 		last_timestamp = sample->time;
 		return 0;
 	}
-	scripting_ops->process_event(event, sample, session, thread);
+	scripting_ops->process_event(event, sample, evsel, session, thread);
 
 	session->hists.stats.total_period += sample->period;
 	return 0;
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 67c0459..aa26f4d 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -488,6 +488,7 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 
 static int process_sample_event(union perf_event *event __used,
 				struct perf_sample *sample,
+				struct perf_evsel *evsel __used,
 				struct perf_session *session)
 {
 	struct trace_entry *te;
@@ -506,6 +507,16 @@ static int process_sample_event(union perf_event *event __used,
 		struct power_entry_old *peo;
 		peo = (void *)te;
 #endif
+		/*
+		 * FIXME: use evsel, its already mapped from id to perf_evsel,
+		 * remove perf_header__find_event infrastructure bits.
+		 * Mapping all these "power:cpu_idle" strings to the tracepoint
+		 * ID and then just comparing against evsel->attr.config.
+		 *
+		 * e.g.:
+		 *
+		 * if (evsel->attr.config == power_cpu_idle_id)
+		 */
 		event_str = perf_header__find_event(te->type);
 
 		if (!event_str)
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 31f934a..a91cd99 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -16,6 +16,7 @@
 
 static int build_id__mark_dso_hit(union perf_event *event,
 				  struct perf_sample *sample __used,
+				  struct perf_evsel *evsel __used,
 				  struct perf_session *session)
 {
 	struct addr_location al;
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index cb6858a..3beb97c 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -29,6 +29,7 @@ struct events_stats {
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
 	u32 nr_unknown_events;
 	u32 nr_invalid_chains;
+	u32 nr_unknown_id;
 };
 
 enum hist_column {
diff --git a/tools/perf/util/scripting-engines/trace-event-perl.c b/tools/perf/util/scripting-engines/trace-event-perl.c
index 6214272..74350ff 100644
--- a/tools/perf/util/scripting-engines/trace-event-perl.c
+++ b/tools/perf/util/scripting-engines/trace-event-perl.c
@@ -247,6 +247,7 @@ static inline struct event *find_cache_event(int type)
 
 static void perl_process_event(union perf_event *pevent __unused,
 			       struct perf_sample *sample,
+			       struct perf_evsel *evsel,
 			       struct perf_session *session __unused,
 			       struct thread *thread)
 {
diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
index 1b85d60..6ccf70e 100644
--- a/tools/perf/util/scripting-engines/trace-event-python.c
+++ b/tools/perf/util/scripting-engines/trace-event-python.c
@@ -206,6 +206,7 @@ static inline struct event *find_cache_event(int type)
 
 static void python_process_event(union perf_event *pevent __unused,
 				 struct perf_sample *sample,
+				 struct perf_evsel *evsel __unused,
 				 struct perf_session *session __unused,
 				 struct thread *thread)
 {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index c68cf40..caa2245 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -280,6 +280,15 @@ static int process_event_synth_stub(union perf_event *event __used,
 	return 0;
 }
 
+static int process_event_sample_stub(union perf_event *event __used,
+				     struct perf_sample *sample __used,
+				     struct perf_evsel *evsel __used,
+				     struct perf_session *session __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 static int process_event_stub(union perf_event *event __used,
 			      struct perf_sample *sample __used,
 			      struct perf_session *session __used)
@@ -303,7 +312,7 @@ static int process_finished_round(union perf_event *event,
 static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 {
 	if (handler->sample == NULL)
-		handler->sample = process_event_stub;
+		handler->sample = process_event_sample_stub;
 	if (handler->mmap == NULL)
 		handler->mmap = process_event_stub;
 	if (handler->comm == NULL)
@@ -698,12 +707,19 @@ static int perf_session_deliver_event(struct perf_session *session,
 				      struct perf_event_ops *ops,
 				      u64 file_offset)
 {
+	struct perf_evsel *evsel;
+
 	dump_event(session, event, file_offset, sample);
 
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
 		dump_sample(session, event, sample);
-		return ops->sample(event, sample, session);
+		evsel = perf_evlist__id2evsel(session->evlist, sample->id);
+		if (evsel == NULL) {
+			++session->hists.stats.nr_unknown_id;
+			return -1;
+		}
+		return ops->sample(event, sample, evsel, session);
 	case PERF_RECORD_MMAP:
 		return ops->mmap(event, sample, session);
 	case PERF_RECORD_COMM:
@@ -845,6 +861,11 @@ static void perf_session__warn_about_errors(const struct perf_session *session,
 			    session->hists.stats.nr_unknown_events);
 	}
 
+	if (session->hists.stats.nr_unknown_id != 0) {
+		ui__warning("%u samples with id not present in the header\n",
+			    session->hists.stats.nr_unknown_id);
+	}
+
  	if (session->hists.stats.nr_invalid_chains != 0) {
  		ui__warning("Found invalid callchains!\n\n"
  			    "%u out of %u events were discarded for this reason.\n\n"
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 0b3c9af..1ac481f 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -55,8 +55,11 @@ struct perf_session {
 	char			filename[0];
 };
 
+struct perf_evsel;
 struct perf_event_ops;
 
+typedef int (*event_sample)(union perf_event *event, struct perf_sample *sample,
+			    struct perf_evsel *evsel, struct perf_session *session);
 typedef int (*event_op)(union perf_event *self, struct perf_sample *sample,
 			struct perf_session *session);
 typedef int (*event_synth_op)(union perf_event *self,
@@ -65,8 +68,8 @@ typedef int (*event_op2)(union perf_event *self, struct perf_session *session,
 			 struct perf_event_ops *ops);
 
 struct perf_event_ops {
-	event_op	sample,
-			mmap,
+	event_sample	sample;
+	event_op	mmap,
 			comm,
 			fork,
 			exit,
diff --git a/tools/perf/util/trace-event-scripting.c b/tools/perf/util/trace-event-scripting.c
index 66f4b78..c9dcbec 100644
--- a/tools/perf/util/trace-event-scripting.c
+++ b/tools/perf/util/trace-event-scripting.c
@@ -38,6 +38,7 @@ static int stop_script_unsupported(void)
 
 static void process_event_unsupported(union perf_event *event __unused,
 				      struct perf_sample *sample __unused,
+				      struct perf_evsel *evsel __unused,
 				      struct perf_session *session __unused,
 				      struct thread *thread __unused)
 {
diff --git a/tools/perf/util/trace-event.h b/tools/perf/util/trace-event.h
index b04da57..f674dda 100644
--- a/tools/perf/util/trace-event.h
+++ b/tools/perf/util/trace-event.h
@@ -280,6 +280,7 @@ struct scripting_ops {
 	int (*stop_script) (void);
 	void (*process_event) (union perf_event *event,
 			       struct perf_sample *sample,
+			       struct perf_evsel *evsel,
 			       struct perf_session *session,
 			       struct thread *thread);
 	int (*generate_script) (const char *outfile);
