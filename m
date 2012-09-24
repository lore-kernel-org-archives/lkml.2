Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757352Ab2IXQGA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:06:00 -0400
Received: from casper.infradead.org ([85.118.1.10]:41440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756679Ab2IXP76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:59:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/30] perf lock: Use perf_evsel__intval and perf_session__set_tracepoints_handlers
Date: Mon, 24 Sep 2012 12:59:23 -0300
Message-Id: <1348502384-14442-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Following the model of 'perf sched':

. raw_field_value searches first on the common fields, that are unused
  in this tool

. Leave using perf_evsel__intval to the actual handlers, some may not
  need to incur some of the cost because they may not need all the
  fields values.

. Using perf_session__set_tracepoints_handlers will save all those
  strcmp to find the right handler at sample processing time, do it just
  once and get the handler from evsel->handler.func.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-v9x3q9rv4caxtox7wtjpchq5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-lock.c |  233 +++++++++++++++++----------------------------
 1 files changed, 87 insertions(+), 146 deletions(-)

diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index a803520..7d6e099 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -1,6 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
+#include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/util.h"
 #include "util/cache.h"
@@ -41,7 +42,7 @@ struct lock_stat {
 	struct rb_node		rb;		/* used for sorting */
 
 	/*
-	 * FIXME: raw_field_value() returns unsigned long long,
+	 * FIXME: perf_evsel__intval() returns u64,
 	 * so address of lockdep_map should be dealed as 64bit.
 	 * Is there more better solution?
 	 */
@@ -336,44 +337,18 @@ alloc_failed:
 
 static const char *input_name;
 
-struct raw_event_sample {
-	u32			size;
-	char			data[0];
-};
-
-struct trace_acquire_event {
-	void			*addr;
-	const char		*name;
-	int			flag;
-};
-
-struct trace_acquired_event {
-	void			*addr;
-	const char		*name;
-};
-
-struct trace_contended_event {
-	void			*addr;
-	const char		*name;
-};
-
-struct trace_release_event {
-	void			*addr;
-	const char		*name;
-};
-
 struct trace_lock_handler {
-	int (*acquire_event)(struct trace_acquire_event *,
-			      const struct perf_sample *sample);
+	int (*acquire_event)(struct perf_evsel *evsel,
+			     struct perf_sample *sample);
 
-	int (*acquired_event)(struct trace_acquired_event *,
-			       const struct perf_sample *sample);
+	int (*acquired_event)(struct perf_evsel *evsel,
+			      struct perf_sample *sample);
 
-	int (*contended_event)(struct trace_contended_event *,
-				const struct perf_sample *sample);
+	int (*contended_event)(struct perf_evsel *evsel,
+			       struct perf_sample *sample);
 
-	int (*release_event)(struct trace_release_event *,
-			      const struct perf_sample *sample);
+	int (*release_event)(struct perf_evsel *evsel,
+			     struct perf_sample *sample);
 };
 
 static struct lock_seq_stat *get_seq(struct thread_stat *ts, void *addr)
@@ -412,15 +387,20 @@ enum acquire_flags {
 	READ_LOCK = 2,
 };
 
-static int
-report_lock_acquire_event(struct trace_acquire_event *acquire_event,
-			  const struct perf_sample *sample)
+static int report_lock_acquire_event(struct perf_evsel *evsel,
+				     struct perf_sample *sample)
 {
+	void *addr;
 	struct lock_stat *ls;
 	struct thread_stat *ts;
 	struct lock_seq_stat *seq;
+	const char *name = perf_evsel__strval(evsel, sample, "name");
+	u64 tmp = perf_evsel__intval(evsel, sample, "lockdep_addr");
+	int flag = perf_evsel__intval(evsel, sample, "flag");
 
-	ls = lock_stat_findnew(acquire_event->addr, acquire_event->name);
+	memcpy(&addr, &tmp, sizeof(void *));
+
+	ls = lock_stat_findnew(addr, name);
 	if (!ls)
 		return -1;
 	if (ls->discard)
@@ -430,19 +410,19 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 	if (!ts)
 		return -1;
 
-	seq = get_seq(ts, acquire_event->addr);
+	seq = get_seq(ts, addr);
 	if (!seq)
 		return -1;
 
 	switch (seq->state) {
 	case SEQ_STATE_UNINITIALIZED:
 	case SEQ_STATE_RELEASED:
-		if (!acquire_event->flag) {
+		if (!flag) {
 			seq->state = SEQ_STATE_ACQUIRING;
 		} else {
-			if (acquire_event->flag & TRY_LOCK)
+			if (flag & TRY_LOCK)
 				ls->nr_trylock++;
-			if (acquire_event->flag & READ_LOCK)
+			if (flag & READ_LOCK)
 				ls->nr_readlock++;
 			seq->state = SEQ_STATE_READ_ACQUIRED;
 			seq->read_count = 1;
@@ -450,7 +430,7 @@ report_lock_acquire_event(struct trace_acquire_event *acquire_event,
 		}
 		break;
 	case SEQ_STATE_READ_ACQUIRED:
-		if (acquire_event->flag & READ_LOCK) {
+		if (flag & READ_LOCK) {
 			seq->read_count++;
 			ls->nr_acquired++;
 			goto end;
@@ -480,17 +460,20 @@ end:
 	return 0;
 }
 
-static int
-report_lock_acquired_event(struct trace_acquired_event *acquired_event,
-			   const struct perf_sample *sample)
+static int report_lock_acquired_event(struct perf_evsel *evsel,
+				      struct perf_sample *sample)
 {
-	u64 timestamp = sample->time;
+	void *addr;
 	struct lock_stat *ls;
 	struct thread_stat *ts;
 	struct lock_seq_stat *seq;
 	u64 contended_term;
+	const char *name = perf_evsel__strval(evsel, sample, "name");
+	u64 tmp = perf_evsel__intval(evsel, sample, "lockdep_addr");
+
+	memcpy(&addr, &tmp, sizeof(void *));
 
-	ls = lock_stat_findnew(acquired_event->addr, acquired_event->name);
+	ls = lock_stat_findnew(addr, name);
 	if (!ls)
 		return -1;
 	if (ls->discard)
@@ -500,7 +483,7 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 	if (!ts)
 		return -1;
 
-	seq = get_seq(ts, acquired_event->addr);
+	seq = get_seq(ts, addr);
 	if (!seq)
 		return -1;
 
@@ -511,7 +494,7 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 	case SEQ_STATE_ACQUIRING:
 		break;
 	case SEQ_STATE_CONTENDED:
-		contended_term = timestamp - seq->prev_event_time;
+		contended_term = sample->time - seq->prev_event_time;
 		ls->wait_time_total += contended_term;
 		if (contended_term < ls->wait_time_min)
 			ls->wait_time_min = contended_term;
@@ -536,20 +519,24 @@ report_lock_acquired_event(struct trace_acquired_event *acquired_event,
 
 	seq->state = SEQ_STATE_ACQUIRED;
 	ls->nr_acquired++;
-	seq->prev_event_time = timestamp;
+	seq->prev_event_time = sample->time;
 end:
 	return 0;
 }
 
-static int
-report_lock_contended_event(struct trace_contended_event *contended_event,
-			    const struct perf_sample *sample)
+static int report_lock_contended_event(struct perf_evsel *evsel,
+				       struct perf_sample *sample)
 {
+	void *addr;
 	struct lock_stat *ls;
 	struct thread_stat *ts;
 	struct lock_seq_stat *seq;
+	const char *name = perf_evsel__strval(evsel, sample, "name");
+	u64 tmp = perf_evsel__intval(evsel, sample, "lockdep_addr");
+
+	memcpy(&addr, &tmp, sizeof(void *));
 
-	ls = lock_stat_findnew(contended_event->addr, contended_event->name);
+	ls = lock_stat_findnew(addr, name);
 	if (!ls)
 		return -1;
 	if (ls->discard)
@@ -559,7 +546,7 @@ report_lock_contended_event(struct trace_contended_event *contended_event,
 	if (!ts)
 		return -1;
 
-	seq = get_seq(ts, contended_event->addr);
+	seq = get_seq(ts, addr);
 	if (!seq)
 		return -1;
 
@@ -592,15 +579,19 @@ end:
 	return 0;
 }
 
-static int
-report_lock_release_event(struct trace_release_event *release_event,
-			  const struct perf_sample *sample)
+static int report_lock_release_event(struct perf_evsel *evsel,
+				     struct perf_sample *sample)
 {
+	void *addr;
 	struct lock_stat *ls;
 	struct thread_stat *ts;
 	struct lock_seq_stat *seq;
+	const char *name = perf_evsel__strval(evsel, sample, "name");
+	u64 tmp = perf_evsel__intval(evsel, sample, "lockdep_addr");
 
-	ls = lock_stat_findnew(release_event->addr, release_event->name);
+	memcpy(&addr, &tmp, sizeof(void *));
+
+	ls = lock_stat_findnew(addr, name);
 	if (!ls)
 		return -1;
 	if (ls->discard)
@@ -610,7 +601,7 @@ report_lock_release_event(struct trace_release_event *release_event,
 	if (!ts)
 		return -1;
 
-	seq = get_seq(ts, release_event->addr);
+	seq = get_seq(ts, addr);
 	if (!seq)
 		return -1;
 
@@ -663,96 +654,33 @@ static struct trace_lock_handler *trace_handler;
 static int perf_evsel__process_lock_acquire(struct perf_evsel *evsel,
 					     struct perf_sample *sample)
 {
-	struct trace_acquire_event acquire_event;
-	struct event_format *event = evsel->tp_format;
-	void *data = sample->raw_data;
-	u64 tmp;		/* this is required for casting... */
-	int rc = 0;
-
-	tmp = raw_field_value(event, "lockdep_addr", data);
-	memcpy(&acquire_event.addr, &tmp, sizeof(void *));
-	acquire_event.name = (char *)raw_field_ptr(event, "name", data);
-	acquire_event.flag = (int)raw_field_value(event, "flag", data);
-
 	if (trace_handler->acquire_event)
-		rc = trace_handler->acquire_event(&acquire_event, sample);
-
-	return rc;
+		return trace_handler->acquire_event(evsel, sample);
+	return 0;
 }
 
 static int perf_evsel__process_lock_acquired(struct perf_evsel *evsel,
 					      struct perf_sample *sample)
 {
-	struct trace_acquired_event acquired_event;
-	struct event_format *event = evsel->tp_format;
-	void *data = sample->raw_data;
-	u64 tmp;		/* this is required for casting... */
-	int rc = 0;
-
-	tmp = raw_field_value(event, "lockdep_addr", data);
-	memcpy(&acquired_event.addr, &tmp, sizeof(void *));
-	acquired_event.name = (char *)raw_field_ptr(event, "name", data);
-
 	if (trace_handler->acquired_event)
-		rc = trace_handler->acquired_event(&acquired_event, sample);
-
-	return rc;
+		return trace_handler->acquired_event(evsel, sample);
+	return 0;
 }
 
 static int perf_evsel__process_lock_contended(struct perf_evsel *evsel,
-					       struct perf_sample *sample)
+					      struct perf_sample *sample)
 {
-	struct trace_contended_event contended_event;
-	struct event_format *event = evsel->tp_format;
-	void *data = sample->raw_data;
-	u64 tmp;		/* this is required for casting... */
-	int rc = 0;
-
-	tmp = raw_field_value(event, "lockdep_addr", data);
-	memcpy(&contended_event.addr, &tmp, sizeof(void *));
-	contended_event.name = (char *)raw_field_ptr(event, "name", data);
-
 	if (trace_handler->contended_event)
-		rc = trace_handler->contended_event(&contended_event, sample);
-
-	return rc;
+		return trace_handler->contended_event(evsel, sample);
+	return 0;
 }
 
 static int perf_evsel__process_lock_release(struct perf_evsel *evsel,
-					     struct perf_sample *sample)
+					    struct perf_sample *sample)
 {
-	struct trace_release_event release_event;
-	struct event_format *event = evsel->tp_format;
-	void *data = sample->raw_data;
-	u64 tmp;		/* this is required for casting... */
-	int rc = 0;
-
-	tmp = raw_field_value(event, "lockdep_addr", data);
-	memcpy(&release_event.addr, &tmp, sizeof(void *));
-	release_event.name = (char *)raw_field_ptr(event, "name", data);
-
 	if (trace_handler->release_event)
-		rc = trace_handler->release_event(&release_event, sample);
-
-	return rc;
-}
-
-static int perf_evsel__process_lock_event(struct perf_evsel *evsel,
-					   struct perf_sample *sample)
-{
-	struct event_format *event = evsel->tp_format;
-	int rc = 0;
-
-	if (!strcmp(event->name, "lock_acquire"))
-		rc = perf_evsel__process_lock_acquire(evsel, sample);
-	if (!strcmp(event->name, "lock_acquired"))
-		rc = perf_evsel__process_lock_acquired(evsel, sample);
-	if (!strcmp(event->name, "lock_contended"))
-		rc = perf_evsel__process_lock_contended(evsel, sample);
-	if (!strcmp(event->name, "lock_release"))
-		rc = perf_evsel__process_lock_release(evsel, sample);
-
-	return rc;
+		return trace_handler->release_event(evsel, sample);
+	return 0;
 }
 
 static void print_bad_events(int bad, int total)
@@ -870,6 +798,9 @@ static int dump_info(void)
 	return rc;
 }
 
+typedef int (*tracepoint_handler)(struct perf_evsel *evsel,
+				  struct perf_sample *sample);
+
 static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -884,7 +815,12 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	return perf_evsel__process_lock_event(evsel, sample);
+	if (evsel->handler.func != NULL) {
+		tracepoint_handler f = evsel->handler.func;
+		return f(evsel, sample);
+	}
+
+	return 0;
 }
 
 static struct perf_tool eops = {
@@ -893,6 +829,13 @@ static struct perf_tool eops = {
 	.ordered_samples	= true,
 };
 
+static const struct perf_evsel_str_handler lock_tracepoints[] = {
+	{ "lock:lock_acquire",	 perf_evsel__process_lock_acquire,   }, /* CONFIG_LOCKDEP */
+	{ "lock:lock_acquired",	 perf_evsel__process_lock_acquired,  }, /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
+	{ "lock:lock_contended", perf_evsel__process_lock_contended, }, /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
+	{ "lock:lock_release",	 perf_evsel__process_lock_release,   }, /* CONFIG_LOCKDEP */
+};
+
 static int read_events(void)
 {
 	session = perf_session__new(input_name, O_RDONLY, 0, false, &eops);
@@ -901,6 +844,11 @@ static int read_events(void)
 		return -1;
 	}
 
+	if (perf_session__set_tracepoints_handlers(session, lock_tracepoints)) {
+		pr_err("Initializing perf session tracepoint handlers failed\n");
+		return -1;
+	}
+
 	return perf_session__process_events(session, &eops);
 }
 
@@ -967,13 +915,6 @@ static const struct option lock_options[] = {
 	OPT_END()
 };
 
-static const char * const lock_tracepoints[] = {
-	"lock:lock_acquire",    /* CONFIG_LOCKDEP */
-	"lock:lock_acquired",   /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
-	"lock:lock_contended",  /* CONFIG_LOCKDEP, CONFIG_LOCK_STAT */
-	"lock:lock_release",    /* CONFIG_LOCKDEP */
-};
-
 static const char *record_args[] = {
 	"record",
 	"-R",
@@ -988,10 +929,10 @@ static int __cmd_record(int argc, const char **argv)
 	const char **rec_argv;
 
 	for (i = 0; i < ARRAY_SIZE(lock_tracepoints); i++) {
-		if (!is_valid_tracepoint(lock_tracepoints[i])) {
+		if (!is_valid_tracepoint(lock_tracepoints[i].name)) {
 				pr_err("tracepoint %s is not enabled. "
 				       "Are CONFIG_LOCKDEP and CONFIG_LOCK_STAT enabled?\n",
-				       lock_tracepoints[i]);
+				       lock_tracepoints[i].name);
 				return 1;
 		}
 	}
@@ -1009,7 +950,7 @@ static int __cmd_record(int argc, const char **argv)
 
 	for (j = 0; j < ARRAY_SIZE(lock_tracepoints); j++) {
 		rec_argv[i++] = "-e";
-		rec_argv[i++] = strdup(lock_tracepoints[j]);
+		rec_argv[i++] = strdup(lock_tracepoints[j].name);
 	}
 
 	for (j = 1; j < (unsigned int)argc; j++, i++)
-- 
1.7.1

