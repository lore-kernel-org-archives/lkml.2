Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759959Ab2IGF6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 01:58:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54946 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756671Ab2IGF6W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 01:58:22 -0400
Date: Thu, 6 Sep 2012 22:58:03 -0700
From: tip-bot for David Ahern <dsahern@gmail.com>
Message-ID: <tip-33d6aef5136075930f7e9a05175bf4f772d8428e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1346005487-62961-4-git-send-email-dsahern@gmail.com>
References: <1346005487-62961-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf lock: Remove use of die and handle errors
Git-Commit-ID: 33d6aef5136075930f7e9a05175bf4f772d8428e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 22:58:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  33d6aef5136075930f7e9a05175bf4f772d8428e
Gitweb:     http://git.kernel.org/tip/33d6aef5136075930f7e9a05175bf4f772d8428e
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Sun, 26 Aug 2012 12:24:43 -0600
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 5 Sep 2012 17:19:38 -0300

perf lock: Remove use of die and handle errors

Allows perf to clean up properly on exit.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1346005487-62961-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c |  181 +++++++++++++++++++++++++++++++--------------
 1 files changed, 124 insertions(+), 57 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 585aae2..75153c8 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -161,8 +161,10 @@ static struct thread_stat *thread_stat_findnew_after_first(u32 tid)
 		return st;
 
 	st = zalloc(sizeof(struct thread_stat));
-	if (!st)
-		die("memory allocation failed\n");
+	if (!st) {
+		pr_err("memory allocation failed\n");
+		return NULL;
+	}
 
 	st->tid = tid;
 	INIT_LIST_HEAD(&st->seq_list);
@@ -181,8 +183,10 @@ static struct thread_stat *thread_stat_findnew_first(u32 tid)
 	struct thread_stat *st;
 
 	st = zalloc(sizeof(struct thread_stat));
-	if (!st)
-		die("memory allocation failed\n");
+	if (!st) {
+		pr_err("memory allocation failed\n");
+		return NULL;
+	}
 	st->tid = tid;
 	INIT_LIST_HEAD(&st->seq_list);
 
@@ -248,18 +252,20 @@ struct lock_key keys[] = {
 	{ NULL, NULL }
 };
 
-static void select_key(void)
+static int select_key(void)
 {
 	int i;
 
 	for (i = 0; keys[i].name; i++) {
 		if (!strcmp(keys[i].name, sort_key)) {
 			compare = keys[i].key;
-			return;
+			return 0;
 		}
 	}
 
-	die("Unknown compare key:%s\n", sort_key);
+	pr_err("Unknown compare key: %s\n", sort_key);
+
+	return -1;
 }
 
 static void insert_to_result(struct lock_stat *st,
@@ -324,7 +330,8 @@ static struct lock_stat *lock_stat_findnew(void *addr, const char *name)
 	return new;
 
 alloc_failed:
-	die("memory allocation failed\n");
+	pr_err("memory allocation failed\n");
+	return NULL;
 }
 
 static const char *input_name;
@@ -356,16 +363,16 @@ struct trace_release_event {
 };
 
 struct trace_lock_handler {
-	void (*acquire_event)(struct trace_acquire_event *,
+	int (*acquire_event)(struct trace_acquire_event *,
 			      const struct perf_sample *sample);
 
-	void (*acquired_event)(struct trace_acquired_event *,
+	int (*acquired_event)(struct trace_acquired_event *,
 			       const struct perf_sample *sample);
 
-	void (*contended_event)(struct trace_contended_event *,
+	int (*contended_event)(struct trace_contended_event *,
 				const struct perf_sample *sample);
 
-	void (*release_event)(struct trace_release_event *,
+	int (*release_event)(struct trace_release_event *,
 			      const struct perf_sample *sample);
 };
 
@@ -379,8 +386,10 @@ static struct lock_seq_stat *get_seq(struct thread_stat *ts, void *addr)
 	}
 
 	seq = zalloc(sizeof(struct lock_seq_stat));
-	if (!seq)
-		die("Not enough memory\n");
+	if (!seq) {
+		pr_err("memory allocation failed\n");
+		return NULL;
+	}
 	seq->state = SEQ_STATE_UNINITIALIZED;
 	seq->addr = addr;
 
@@ -403,7 +412,7 @@ enum acquire_flags {
 	READ_LOCK = 2,
 };
 
-static void
+static int
 report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 			  const struct perf_sample *sample)
 {
@@ -412,11 +421,18 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 	struct lock_seq_stat *seq;
 
 	ls = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+	if (!ls)
+		return -1;
 	if (ls->discard)
-		return;
+		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
+	if (!ts)
+		return -1;
+
 	seq = get_seq(ts, acquire_event->addr);
+	if (!seq)
+		return -1;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
@@ -461,10 +477,10 @@ broken:
 	ls->nr_acquire++;
 	seq->prev_event_time = sample->time;
 end:
-	return;
+	return 0;
 }
 
-static void
+static int
 report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 			   const struct perf_sample *sample)
 {
@@ -475,16 +491,23 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 	u64 contended_term;
 
 	ls = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+	if (!ls)
+		return -1;
 	if (ls->discard)
-		return;
+		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
+	if (!ts)
+		return -1;
+
 	seq = get_seq(ts, acquired_event->addr);
+	if (!seq)
+		return -1;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
 		/* orphan event, do nothing */
-		return;
+		return 0;
 	case SEQ_STATE_ACQUIRING:
 		break;
 	case SEQ_STATE_CONTENDED:
@@ -515,10 +538,10 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 	ls->nr_acquired++;
 	seq->prev_event_time = timestamp;
 end:
-	return;
+	return 0;
 }
 
-static void
+static int
 report_lock_contended_event(struct trace_contended_event *contended_event,
 			    const struct perf_sample *sample)
 {
@@ -527,16 +550,23 @@ report_lock_contended_event(struct trace_contended_event *contended_event,
 	struct lock_seq_stat *seq;
 
 	ls = lock_stat_findnew(contended_event->addr, contended_event->name);
+	if (!ls)
+		return -1;
 	if (ls->discard)
-		return;
+		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
+	if (!ts)
+		return -1;
+
 	seq = get_seq(ts, contended_event->addr);
+	if (!seq)
+		return -1;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
 		/* orphan event, do nothing */
-		return;
+		return 0;
 	case SEQ_STATE_ACQUIRING:
 		break;
 	case SEQ_STATE_RELEASED:
@@ -559,10 +589,10 @@ report_lock_contended_event(struct trace_contended_event *contended_event,
 	ls->nr_contended++;
 	seq->prev_event_time = sample->time;
 end:
-	return;
+	return 0;
 }
 
-static void
+static int
 report_lock_release_event(struct trace_release_event *release_event,
 			  const struct perf_sample *sample)
 {
@@ -571,11 +601,18 @@ report_lock_release_event(struct trace_release_event *release_event,
 	struct lock_seq_stat *seq;
 
 	ls = lock_stat_findnew(release_event->addr, release_event->name);
+	if (!ls)
+		return -1;
 	if (ls->discard)
-		return;
+		return 0;
 
 	ts = thread_stat_findnew(sample->tid);
+	if (!ts)
+		return -1;
+
 	seq = get_seq(ts, release_event->addr);
+	if (!seq)
+		return -1;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
@@ -609,7 +646,7 @@ free_seq:
 	list_del(&seq->list);
 	free(seq);
 end:
-	return;
+	return 0;
 }
 
 /* lock oriented handlers */
@@ -623,13 +660,14 @@ static struct trace_lock_handler report_lock_ops  = {
 
 static struct trace_lock_handler *trace_handler;
 
-static void perf_evsel__process_lock_acquire(struct perf_evsel *evsel,
+static int perf_evsel__process_lock_acquire(struct perf_evsel *evsel,
 					     struct perf_sample *sample)
 {
 	struct trace_acquire_event acquire_event;
 	struct event_format *event = evsel->tp_format;
 	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
+	int rc = 0;
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquire_event.addr, &tmp, sizeof(void *));
@@ -637,70 +675,84 @@ static void perf_evsel__process_lock_acquire(struct perf_evsel *evsel,
 	acquire_event.flag = (int)raw_field_value(event, "flag", data);
 
 	if (trace_handler->acquire_event)
-		trace_handler->acquire_event(&acquire_event, sample);
+		rc = trace_handler->acquire_event(&acquire_event, sample);
+
+	return rc;
 }
 
-static void perf_evsel__process_lock_acquired(struct perf_evsel *evsel,
+static int perf_evsel__process_lock_acquired(struct perf_evsel *evsel,
 					      struct perf_sample *sample)
 {
 	struct trace_acquired_event acquired_event;
 	struct event_format *event = evsel->tp_format;
 	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
+	int rc = 0;
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&acquired_event.addr, &tmp, sizeof(void *));
 	acquired_event.name = (char *)raw_field_ptr(event, "name", data);
 
-	if (trace_handler->acquire_event)
-		trace_handler->acquired_event(&acquired_event, sample);
+	if (trace_handler->acquired_event)
+		rc = trace_handler->acquired_event(&acquired_event, sample);
+
+	return rc;
 }
 
-static void perf_evsel__process_lock_contended(struct perf_evsel *evsel,
+static int perf_evsel__process_lock_contended(struct perf_evsel *evsel,
 					       struct perf_sample *sample)
 {
 	struct trace_contended_event contended_event;
 	struct event_format *event = evsel->tp_format;
 	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
+	int rc = 0;
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&contended_event.addr, &tmp, sizeof(void *));
 	contended_event.name = (char *)raw_field_ptr(event, "name", data);
 
-	if (trace_handler->acquire_event)
-		trace_handler->contended_event(&contended_event, sample);
+	if (trace_handler->contended_event)
+		rc = trace_handler->contended_event(&contended_event, sample);
+
+	return rc;
 }
 
-static void perf_evsel__process_lock_release(struct perf_evsel *evsel,
+static int perf_evsel__process_lock_release(struct perf_evsel *evsel,
 					     struct perf_sample *sample)
 {
 	struct trace_release_event release_event;
 	struct event_format *event = evsel->tp_format;
 	void *data = sample->raw_data;
 	u64 tmp;		/* this is required for casting... */
+	int rc = 0;
 
 	tmp = raw_field_value(event, "lockdep_addr", data);
 	memcpy(&release_event.addr, &tmp, sizeof(void *));
 	release_event.name = (char *)raw_field_ptr(event, "name", data);
 
-	if (trace_handler->acquire_event)
-		trace_handler->release_event(&release_event, sample);
+	if (trace_handler->release_event)
+		rc = trace_handler->release_event(&release_event, sample);
+
+	return rc;
 }
 
-static void perf_evsel__process_lock_event(struct perf_evsel *evsel,
+static int perf_evsel__process_lock_event(struct perf_evsel *evsel,
 					   struct perf_sample *sample)
 {
 	struct event_format *event = evsel->tp_format;
+	int rc = 0;
 
 	if (!strcmp(event->name, "lock_acquire"))
-		perf_evsel__process_lock_acquire(evsel, sample);
+		rc = perf_evsel__process_lock_acquire(evsel, sample);
 	if (!strcmp(event->name, "lock_acquired"))
-		perf_evsel__process_lock_acquired(evsel, sample);
+		rc = perf_evsel__process_lock_acquired(evsel, sample);
 	if (!strcmp(event->name, "lock_contended"))
-		perf_evsel__process_lock_contended(evsel, sample);
+		rc = perf_evsel__process_lock_contended(evsel, sample);
 	if (!strcmp(event->name, "lock_release"))
-		perf_evsel__process_lock_release(evsel, sample);
+		rc = perf_evsel__process_lock_release(evsel, sample);
+
+	return rc;
 }
 
 static void print_bad_events(int bad, int total)
@@ -802,14 +854,20 @@ static void dump_map(void)
 	}
 }
 
-static void dump_info(void)
+static int dump_info(void)
 {
+	int rc = 0;
+
 	if (info_threads)
 		dump_threads();
 	else if (info_map)
 		dump_map();
-	else
-		die("Unknown type of information\n");
+	else {
+		rc = -1;
+		pr_err("Unknown type of information\n");
+	}
+
+	return rc;
 }
 
 static int process_sample_event(struct perf_tool *tool __used,
@@ -826,8 +884,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 		return -1;
 	}
 
-	perf_evsel__process_lock_event(evsel, sample);
-	return 0;
+	return perf_evsel__process_lock_event(evsel, sample);
 }
 
 static struct perf_tool eops = {
@@ -839,8 +896,10 @@ static struct perf_tool eops = {
 static int read_events(void)
 {
 	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
-	if (!session)
-		die("Initializing perf session failed\n");
+	if (!session) {
+		pr_err("Initializing perf session failed\n");
+		return -1;
+	}
 
 	return perf_session__process_events(session, &eops);
 }
@@ -857,13 +916,18 @@ static void sort_result(void)
 	}
 }
 
-static void __cmd_report(void)
+static int __cmd_report(void)
 {
 	setup_pager();
-	select_key();
-	read_events();
+
+	if ((select_key() != 0) ||
+	    (read_events() != 0))
+		return -1;
+
 	sort_result();
 	print_result();
+
+	return 0;
 }
 
 static const char * const report_usage[] = {
@@ -959,6 +1023,7 @@ static int __cmd_record(int argc, const char **argv)
 int cmd_lock(int argc, const char **argv, const char *prefix __used)
 {
 	unsigned int i;
+	int rc = 0;
 
 	symbol__init();
 	for (i = 0; i < LOCKHASH_SIZE; i++)
@@ -993,11 +1058,13 @@ int cmd_lock(int argc, const char **argv, const char *prefix __used)
 		/* recycling report_lock_ops */
 		trace_handler = &report_lock_ops;
 		setup_pager();
-		read_events();
-		dump_info();
+		if (read_events() != 0)
+			rc = -1;
+		else
+			rc = dump_info();
 	} else {
 		usage_with_options(lock_usage, lock_options);
 	}
 
-	return 0;
+	return rc;
 }
