Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306Ab2HUPXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:23:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59669 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292Ab2HUPXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:23:07 -0400
Date: Tue, 21 Aug 2012 08:22:37 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-bipk647rzq357yot9ao6ih73@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        avagin@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        avagin@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Use evsel->tp_format and perf_sample
Git-Commit-ID: 01d955244b99827814570ed4b675271ca7b8af02
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:22:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  01d955244b99827814570ed4b675271ca7b8af02
Gitweb:     http://git.kernel.org/tip/01d955244b99827814570ed4b675271ca7b8af02
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 7 Aug 2012 10:59:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Aug 2012 23:45:53 -0300

perf lock: Use evsel->tp_format and perf_sample

To reduce the number of parameters passed to the various event handling
functions.

Cc: Andrey Wagin <avagin@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bipk647rzq357yot9ao6ih73@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c |  116 ++++++++++++++++----------------------------
 1 files changed, 42 insertions(+), 74 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 142b303..3f8b955 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -357,28 +357,16 @@ struct trace_release_event {
 
 struct trace_lock_handler {
 	void (*acquire_event)(struct trace_acquire_event *,
-			      struct event_format *,
-			      int cpu,
-			      u64 timestamp,
-			      struct thread *thread);
+			      const struct perf_sample *sample);
 
 	void (*acquired_event)(struct trace_acquired_event *,
-			       struct event_format *,
-			       int cpu,
-			       u64 timestamp,
-			       struct thread *thread);
+			       const struct perf_sample *sample);
 
 	void (*contended_event)(struct trace_contended_event *,
-				struct event_format *,
-				int cpu,
-				u64 timestamp,
-				struct thread *thread);
+				const struct perf_sample *sample);
 
 	void (*release_event)(struct trace_release_event *,
-			      struct event_format *,
-			      int cpu,
-			      u64 timestamp,
-			      struct thread *thread);
+			      const struct perf_sample *sample);
 };
 
 static struct lock_seq_stat *get_seq(struct thread_stat *ts, void *addr)
@@ -417,10 +405,7 @@ enum acquire_flags {
 
 static void
 report_lock_acquire_event(struct trace_acquire_event *acquire_event,
-			struct event_format *__event __used,
-			int cpu __used,
-			u64 timestamp __used,
-			struct thread *thread __used)
+			  const struct perf_sample *sample)
 {
 	struct lock_stat *ls;
 	struct thread_stat *ts;
@@ -430,7 +415,7 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 	if (ls->discard)
 		return;
 
-	ts = thread_stat_findnew(thread->pid);
+	ts = thread_stat_findnew(sample->tid);
 	seq = get_seq(ts, acquire_event->addr);
 
 	switch (seq->state) {
@@ -474,18 +459,16 @@ broken:
 	}
 
 	ls->nr_acquire++;
-	seq->prev_event_time = timestamp;
+	seq->prev_event_time = sample->time;
 end:
 	return;
 }
 
 static void
 report_lock_acquired_event(struct trace_acquired_event *acquired_event,
-			 struct event_format *__event __used,
-			 int cpu __used,
-			 u64 timestamp __used,
-			 struct thread *thread __used)
+			   const struct perf_sample *sample)
 {
+	u64 timestamp = sample->time;
 	struct lock_stat *ls;
 	struct thread_stat *ts;
 	struct lock_seq_stat *seq;
@@ -495,7 +478,7 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 	if (ls->discard)
 		return;
 
-	ts = thread_stat_findnew(thread->pid);
+	ts = thread_stat_findnew(sample->tid);
 	seq = get_seq(ts, acquired_event->addr);
 
 	switch (seq->state) {
@@ -537,10 +520,7 @@ end:
 
 static void
 report_lock_contended_event(struct trace_contended_event *contended_event,
-			  struct event_format *__event __used,
-			  int cpu __used,
-			  u64 timestamp __used,
-			  struct thread *thread __used)
+			    const struct perf_sample *sample)
 {
 	struct lock_stat *ls;
 	struct thread_stat *ts;
@@ -550,7 +530,7 @@ report_lock_contended_event(struct trace_contended_event *contended_event,
 	if (ls->discard)
 		return;
 
-	ts = thread_stat_findnew(thread->pid);
+	ts = thread_stat_findnew(sample->tid);
 	seq = get_seq(ts, contended_event->addr);
 
 	switch (seq->state) {
@@ -577,17 +557,14 @@ report_lock_contended_event(struct trace_contended_event *contended_event,
 
 	seq->state = SEQ_STATE_CONTENDED;
 	ls->nr_contended++;
-	seq->prev_event_time = timestamp;
+	seq->prev_event_time = sample->time;
 end:
 	return;
 }
 
 static void
 report_lock_release_event(struct trace_release_event *release_event,
-			struct event_format *__event __used,
-			int cpu __used,
-			u64 timestamp __used,
-			struct thread *thread __used)
+			  const struct perf_sample *sample)
 {
 	struct lock_stat *ls;
 	struct thread_stat *ts;
@@ -597,7 +574,7 @@ report_lock_release_event(struct trace_release_event *release_event,
 	if (ls->discard)
 		return;
 
-	ts = thread_stat_findnew(thread->pid);
+	ts = thread_stat_findnew(sample->tid);
 	seq = get_seq(ts, release_event->addr);
 
 	switch (seq->state) {
@@ -646,14 +623,12 @@ static struct trace_lock_handler report_lock_ops  = {
 
 static struct trace_lock_handler *trace_handler;
 
-static void
-process_lock_acquire_event(void *data,
-			   struct event_format *event __used,
-			   int cpu __used,
-			   u64 timestamp __used,
-			   struct thread *thread __used)
+static void perf_evsel__process_lock_acquire(struct perf_evsel *evsel,
+					     struct perf_sample *sample)
 {
 	struct trace_acquire_event acquire_event;
+	struct event_format *event = evsel->tp_format;
+	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
@@ -662,17 +637,15 @@ process_lock_acquire_event(void *data,
 	acquire_event.flag = (int)raw_field_value(event, "flag", data);
 
 	if (trace_handler->acquire_event)
-		trace_handler->acquire_event(&acquire_event, event, cpu, timestamp, thread);
+		trace_handler->acquire_event(&acquire_event, sample);
 }
 
-static void
-process_lock_acquired_event(void *data,
-			    struct event_format *event __used,
-			    int cpu __used,
-			    u64 timestamp __used,
-			    struct thread *thread __used)
+static void perf_evsel__process_lock_acquired(struct perf_evsel *evsel,
+					      struct perf_sample *sample)
 {
 	struct trace_acquired_event acquired_event;
+	struct event_format *event = evsel->tp_format;
+	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
@@ -680,17 +653,15 @@ process_lock_acquired_event(void *data,
 	acquired_event.name = (char *)raw_field_ptr(event, "name", data);
 
 	if (trace_handler->acquire_event)
-		trace_handler->acquired_event(&acquired_event, event, cpu, timestamp, thread);
+		trace_handler->acquired_event(&acquired_event, sample);
 }
 
-static void
-process_lock_contended_event(void *data,
-			     struct event_format *event __used,
-			     int cpu __used,
-			     u64 timestamp __used,
-			     struct thread *thread __used)
+static void perf_evsel__process_lock_contended(struct perf_evsel *evsel,
+					       struct perf_sample *sample)
 {
 	struct trace_contended_event contended_event;
+	struct event_format *event = evsel->tp_format;
+	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
@@ -698,17 +669,15 @@ process_lock_contended_event(void *data,
 	contended_event.name = (char *)raw_field_ptr(event, "name", data);
 
 	if (trace_handler->acquire_event)
-		trace_handler->contended_event(&contended_event, event, cpu, timestamp, thread);
+		trace_handler->contended_event(&contended_event, sample);
 }
 
-static void
-process_lock_release_event(void *data,
-			   struct event_format *event __used,
-			   int cpu __used,
-			   u64 timestamp __used,
-			   struct thread *thread __used)
+static void perf_evsel__process_lock_release(struct perf_evsel *evsel,
+					     struct perf_sample *sample)
 {
 	struct trace_release_event release_event;
+	struct event_format *event = evsel->tp_format;
+	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
@@ -716,22 +685,22 @@ process_lock_release_event(void *data,
 	release_event.name = (char *)raw_field_ptr(event, "name", data);
 
 	if (trace_handler->acquire_event)
-		trace_handler->release_event(&release_event, event, cpu, timestamp, thread);
+		trace_handler->release_event(&release_event, sample);
 }
 
-static void process_raw_event(struct perf_evsel *evsel, void *data, int cpu,
-			      u64 timestamp, struct thread *thread)
+static void perf_evsel__process_lock_event(struct perf_evsel *evsel,
+					   struct perf_sample *sample)
 {
 	struct event_format *event = evsel->tp_format;
 
 	if (!strcmp(event->name, "lock_acquire"))
-		process_lock_acquire_event(data, event, cpu, timestamp, thread);
+		perf_evsel__process_lock_acquire(evsel, sample);
 	if (!strcmp(event->name, "lock_acquired"))
-		process_lock_acquired_event(data, event, cpu, timestamp, thread);
+		perf_evsel__process_lock_acquired(evsel, sample);
 	if (!strcmp(event->name, "lock_contended"))
-		process_lock_contended_event(data, event, cpu, timestamp, thread);
+		perf_evsel__process_lock_contended(evsel, sample);
 	if (!strcmp(event->name, "lock_release"))
-		process_lock_release_event(data, event, cpu, timestamp, thread);
+		perf_evsel__process_lock_release(evsel, sample);
 }
 
 static void print_bad_events(int bad, int total)
@@ -857,8 +826,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 		return -1;
 	}
 
-	process_raw_event(evsel, sample->raw_data, sample->cpu, sample->time, thread);
-
+	perf_evsel__process_lock_event(evsel, sample);
 	return 0;
 }
 
