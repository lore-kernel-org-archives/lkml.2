Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab0LDW1k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 17:27:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:40559 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab0LDW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 17:27:36 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 4/5] perf session: Parse sample earlier
Date: Sat,  4 Dec 2010 20:26:56 -0200
Message-Id: <1291501617-6966-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291501617-6966-1-git-send-email-acme@infradead.org>
References: <1291501617-6966-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

At perf_session__process_event, so that we reduce the number of lines in eache
tool sample processing routine that now receives a sample_data pointer already
parsed.

This will also be useful in the next patch, where we'll allow sample the
identity fields in MMAP, FORK, EXIT, etc, when it will be possible to see (cpu,
timestamp) just after before every event.

Also validate callchains in perf_session__process_event, i.e. as early as
possible, and keep a counter of the number of events discarded due to invalid
callchains, warning the user about it if it happens.

There is an assumption that was kept that all events have the same sample_type,
that will be dealt with in the future, when this preexisting limitation will be
removed.

Tested-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Ian Munsie <imunsie@au1.ibm.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <1291318772-30880-4-git-send-email-acme@infradead.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c  |    6 +-
 tools/perf/builtin-diff.c      |   11 ++--
 tools/perf/builtin-inject.c    |   39 +++++++++------
 tools/perf/builtin-kmem.c      |   21 ++------
 tools/perf/builtin-lock.c      |   12 ++---
 tools/perf/builtin-record.c    |    7 +++
 tools/perf/builtin-report.c    |   15 +++---
 tools/perf/builtin-sched.c     |   21 ++------
 tools/perf/builtin-script.c    |   34 +++++---------
 tools/perf/builtin-timechart.c |   40 ++++++++--------
 tools/perf/builtin-top.c       |    4 +-
 tools/perf/util/build-id.c     |    7 ++-
 tools/perf/util/event.c        |   66 +++++++++++---------------
 tools/perf/util/event.h        |   20 +++++--
 tools/perf/util/header.c       |   11 ++--
 tools/perf/util/hist.h         |    2 +
 tools/perf/util/session.c      |  103 ++++++++++++++++++++++++++++++----------
 tools/perf/util/session.h      |    9 ++-
 18 files changed, 236 insertions(+), 192 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 6d5604d..569a276 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -58,12 +58,12 @@ static int hists__add_entry(struct hists *self, struct addr_location *al)
 	return hist_entry__inc_addr_samples(he, al->addr);
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session)
+static int process_sample_event(event_t *event, struct sample_data *sample,
+				struct perf_session *session)
 {
 	struct addr_location al;
-	struct sample_data data;
 
-	if (event__preprocess_sample(event, session, &al, &data, NULL) < 0) {
+	if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 221b823..5e1a043 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -30,12 +30,13 @@ static int hists__add_entry(struct hists *self,
 	return -ENOMEM;
 }
 
-static int diff__process_sample_event(event_t *event, struct perf_session *session)
+static int diff__process_sample_event(event_t *event,
+				      struct sample_data *sample,
+				      struct perf_session *session)
 {
 	struct addr_location al;
-	struct sample_data data = { .period = 1, };
 
-	if (event__preprocess_sample(event, session, &al, &data, NULL) < 0) {
+	if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
 		pr_warning("problem processing %d event, skipping it.\n",
 			   event->header.type);
 		return -1;
@@ -44,12 +45,12 @@ static int diff__process_sample_event(event_t *event, struct perf_session *sessi
 	if (al.filtered || al.sym == NULL)
 		return 0;
 
-	if (hists__add_entry(&session->hists, &al, data.period)) {
+	if (hists__add_entry(&session->hists, &al, sample->period)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
-	session->hists.stats.total_period += data.period;
+	session->hists.stats.total_period += sample->period;
 	return 0;
 }
 
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 8e3e47b..4b66b85 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -16,8 +16,8 @@
 static char		const *input_name = "-";
 static bool		inject_build_ids;
 
-static int event__repipe(event_t *event __used,
-			 struct perf_session *session __used)
+static int event__repipe_synth(event_t *event,
+			       struct perf_session *session __used)
 {
 	uint32_t size;
 	void *buf = event;
@@ -36,22 +36,30 @@ static int event__repipe(event_t *event __used,
 	return 0;
 }
 
-static int event__repipe_mmap(event_t *self, struct perf_session *session)
+static int event__repipe(event_t *event, struct sample_data *sample __used,
+			 struct perf_session *session)
+{
+	return event__repipe_synth(event, session);
+}
+
+static int event__repipe_mmap(event_t *self, struct sample_data *sample,
+			      struct perf_session *session)
 {
 	int err;
 
-	err = event__process_mmap(self, session);
-	event__repipe(self, session);
+	err = event__process_mmap(self, sample, session);
+	event__repipe(self, sample, session);
 
 	return err;
 }
 
-static int event__repipe_task(event_t *self, struct perf_session *session)
+static int event__repipe_task(event_t *self, struct sample_data *sample,
+			      struct perf_session *session)
 {
 	int err;
 
-	err = event__process_task(self, session);
-	event__repipe(self, session);
+	err = event__process_task(self, sample, session);
+	event__repipe(self, sample, session);
 
 	return err;
 }
@@ -61,7 +69,7 @@ static int event__repipe_tracing_data(event_t *self,
 {
 	int err;
 
-	event__repipe(self, session);
+	event__repipe_synth(self, session);
 	err = event__process_tracing_data(self, session);
 
 	return err;
@@ -111,7 +119,8 @@ static int dso__inject_build_id(struct dso *self, struct perf_session *session)
 	return 0;
 }
 
-static int event__inject_buildid(event_t *event, struct perf_session *session)
+static int event__inject_buildid(event_t *event, struct sample_data *sample,
+				 struct perf_session *session)
 {
 	struct addr_location al;
 	struct thread *thread;
@@ -146,7 +155,7 @@ static int event__inject_buildid(event_t *event, struct perf_session *session)
 	}
 
 repipe:
-	event__repipe(event, session);
+	event__repipe(event, sample, session);
 	return 0;
 }
 
@@ -160,10 +169,10 @@ struct perf_event_ops inject_ops = {
 	.read		= event__repipe,
 	.throttle	= event__repipe,
 	.unthrottle	= event__repipe,
-	.attr		= event__repipe,
-	.event_type 	= event__repipe,
-	.tracing_data 	= event__repipe,
-	.build_id 	= event__repipe,
+	.attr		= event__repipe_synth,
+	.event_type 	= event__repipe_synth,
+	.tracing_data 	= event__repipe_synth,
+	.build_id 	= event__repipe_synth,
 };
 
 extern volatile int session_done;
diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 31f60a2..d0a652e 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -304,22 +304,11 @@ process_raw_event(event_t *raw_event __used, void *data,
 	}
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session)
+static int process_sample_event(event_t *event, struct sample_data *sample,
+				struct perf_session *session)
 {
-	struct sample_data data;
-	struct thread *thread;
+	struct thread *thread = perf_session__findnew(session, event->ip.pid);
 
-	memset(&data, 0, sizeof(data));
-	data.time = -1;
-	data.cpu = -1;
-	data.period = 1;
-
-	event__parse_sample(event, session->sample_type, &data);
-
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-		    data.pid, data.tid, data.ip, data.period);
-
-	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -328,8 +317,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(event, data.raw_data, data.cpu,
-			  data.time, thread);
+	process_raw_event(event, sample->raw_data, sample->cpu,
+			  sample->time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-lock.c b/tools/perf/builtin-lock.c
index 8452a2a..92d3da5 100644
--- a/tools/perf/builtin-lock.c
+++ b/tools/perf/builtin-lock.c
@@ -834,22 +834,18 @@ static void dump_info(void)
 		die("Unknown type of information\n");
 }
 
-static int process_sample_event(event_t *self, struct perf_session *s)
+static int process_sample_event(event_t *self, struct sample_data *sample,
+				struct perf_session *s)
 {
-	struct sample_data data;
-	struct thread *thread;
+	struct thread *thread = perf_session__findnew(s, sample->tid);
 
-	bzero(&data, sizeof(data));
-	event__parse_sample(self, s->sample_type, &data);
-
-	thread = perf_session__findnew(s, data.tid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			self->header.type);
 		return -1;
 	}
 
-	process_raw_event(data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(sample->raw_data, sample->cpu, sample->time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 024e144..b34de92 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -36,6 +36,7 @@ static int			*fd[MAX_NR_CPUS][MAX_COUNTERS];
 
 static u64			user_interval			= ULLONG_MAX;
 static u64			default_interval		=      0;
+static u64			sample_type;
 
 static int			nr_cpus				=      0;
 static unsigned int		page_size;
@@ -129,6 +130,7 @@ static void write_output(void *buf, size_t size)
 }
 
 static int process_synthesized_event(event_t *event,
+				     struct sample_data *sample __used,
 				     struct perf_session *self __used)
 {
 	write_output(event, event->header.size);
@@ -287,6 +289,9 @@ static void create_counter(int counter, int cpu)
 		attr->sample_type	|= PERF_SAMPLE_CPU;
 	}
 
+	if (!sample_type)
+		sample_type = attr->sample_type;
+
 	attr->mmap		= track;
 	attr->comm		= track;
 	attr->inherit		= !no_inherit;
@@ -642,6 +647,8 @@ static int __cmd_record(int argc, const char **argv)
 			open_counters(cpumap[i]);
 	}
 
+	perf_session__set_sample_type(session, sample_type);
+
 	if (pipe_output) {
 		err = perf_header__write_pipe(output);
 		if (err < 0)
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 5de405d..904519f 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -150,13 +150,13 @@ static int add_event_total(struct perf_session *session,
 	return 0;
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session)
+static int process_sample_event(event_t *event, struct sample_data *sample,
+				struct perf_session *session)
 {
-	struct sample_data data = { .period = 1, };
 	struct addr_location al;
 	struct perf_event_attr *attr;
 
-	if (event__preprocess_sample(event, session, &al, &data, NULL) < 0) {
+	if (event__preprocess_sample(event, session, &al, sample, NULL) < 0) {
 		fprintf(stderr, "problem processing %d event, skipping it.\n",
 			event->header.type);
 		return -1;
@@ -165,14 +165,14 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	if (al.filtered || (hide_unresolved && al.sym == NULL))
 		return 0;
 
-	if (perf_session__add_hist_entry(session, &al, &data)) {
+	if (perf_session__add_hist_entry(session, &al, sample)) {
 		pr_debug("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
-	attr = perf_header__find_attr(data.id, &session->header);
+	attr = perf_header__find_attr(sample->id, &session->header);
 
-	if (add_event_total(session, &data, attr)) {
+	if (add_event_total(session, sample, attr)) {
 		pr_debug("problem adding event period\n");
 		return -1;
 	}
@@ -180,7 +180,8 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int process_read_event(event_t *event, struct perf_session *session __used)
+static int process_read_event(event_t *event, struct sample_data *sample __used,
+			      struct perf_session *session __used)
 {
 	struct perf_event_attr *attr;
 
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 26523c9..73d1e30 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1606,25 +1606,15 @@ process_raw_event(event_t *raw_event __used, struct perf_session *session,
 		process_sched_migrate_task_event(data, session, event, cpu, timestamp, thread);
 }
 
-static int process_sample_event(event_t *event, struct perf_session *session)
+static int process_sample_event(event_t *event, struct sample_data *sample,
+				struct perf_session *session)
 {
-	struct sample_data data;
 	struct thread *thread;
 
 	if (!(session->sample_type & PERF_SAMPLE_RAW))
 		return 0;
 
-	memset(&data, 0, sizeof(data));
-	data.time = -1;
-	data.cpu = -1;
-	data.period = -1;
-
-	event__parse_sample(event, session->sample_type, &data);
-
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-		    data.pid, data.tid, data.ip, data.period);
-
-	thread = perf_session__findnew(session, data.pid);
+	thread = perf_session__findnew(session, sample->pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -1633,10 +1623,11 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	if (profile_cpu != -1 && profile_cpu != (int)data.cpu)
+	if (profile_cpu != -1 && profile_cpu != (int)sample->cpu)
 		return 0;
 
-	process_raw_event(event, session, data.raw_data, data.cpu, data.time, thread);
+	process_raw_event(event, session, sample->raw_data, sample->cpu,
+			  sample->time, thread);
 
 	return 0;
 }
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 4539551..683a305 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -63,22 +63,11 @@ static int cleanup_scripting(void)
 
 static char const		*input_name = "perf.data";
 
-static int process_sample_event(event_t *event, struct perf_session *session)
+static int process_sample_event(event_t *event, struct sample_data *sample,
+				struct perf_session *session)
 {
-	struct sample_data data;
-	struct thread *thread;
+	struct thread *thread = perf_session__findnew(session, event->ip.pid);
 
-	memset(&data, 0, sizeof(data));
-	data.time = -1;
-	data.cpu = -1;
-	data.period = 1;
-
-	event__parse_sample(event, session->sample_type, &data);
-
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
-		    data.pid, data.tid, data.ip, data.period);
-
-	thread = perf_session__findnew(session, event->ip.pid);
 	if (thread == NULL) {
 		pr_debug("problem processing %d event, skipping it.\n",
 			 event->header.type);
@@ -87,13 +76,13 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 
 	if (session->sample_type & PERF_SAMPLE_RAW) {
 		if (debug_mode) {
-			if (data.time < last_timestamp) {
+			if (sample->time < last_timestamp) {
 				pr_err("Samples misordered, previous: %llu "
 					"this: %llu\n", last_timestamp,
-					data.time);
+					sample->time);
 				nr_unordered++;
 			}
-			last_timestamp = data.time;
+			last_timestamp = sample->time;
 			return 0;
 		}
 		/*
@@ -101,18 +90,19 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 		 * field, although it should be the same than this perf
 		 * event pid
 		 */
-		scripting_ops->process_event(data.cpu, data.raw_data,
-					     data.raw_size,
-					     data.time, thread->comm);
+		scripting_ops->process_event(sample->cpu, sample->raw_data,
+					     sample->raw_size,
+					     sample->time, thread->comm);
 	}
 
-	session->hists.stats.total_period += data.period;
+	session->hists.stats.total_period += sample->period;
 	return 0;
 }
 
 static u64 nr_lost;
 
-static int process_lost_event(event_t *event, struct perf_session *session __used)
+static int process_lost_event(event_t *event, struct sample_data *sample __used,
+			      struct perf_session *session __used)
 {
 	nr_lost += event->lost.lost;
 
diff --git a/tools/perf/builtin-timechart.c b/tools/perf/builtin-timechart.c
index 9bcc38f..1f158dc 100644
--- a/tools/perf/builtin-timechart.c
+++ b/tools/perf/builtin-timechart.c
@@ -272,19 +272,22 @@ static int cpus_cstate_state[MAX_CPUS];
 static u64 cpus_pstate_start_times[MAX_CPUS];
 static u64 cpus_pstate_state[MAX_CPUS];
 
-static int process_comm_event(event_t *event, struct perf_session *session __used)
+static int process_comm_event(event_t *event, struct sample_data *sample __used,
+			      struct perf_session *session __used)
 {
 	pid_set_comm(event->comm.tid, event->comm.comm);
 	return 0;
 }
 
-static int process_fork_event(event_t *event, struct perf_session *session __used)
+static int process_fork_event(event_t *event, struct sample_data *sample __used,
+			      struct perf_session *session __used)
 {
 	pid_fork(event->fork.pid, event->fork.ppid, event->fork.time);
 	return 0;
 }
 
-static int process_exit_event(event_t *event, struct perf_session *session __used)
+static int process_exit_event(event_t *event, struct sample_data *sample __used,
+			      struct perf_session *session __used)
 {
 	pid_exit(event->fork.pid, event->fork.time);
 	return 0;
@@ -470,24 +473,21 @@ static void sched_switch(int cpu, u64 timestamp, struct trace_entry *te)
 }
 
 
-static int process_sample_event(event_t *event, struct perf_session *session)
+static int process_sample_event(event_t *event __used,
+				struct sample_data *sample,
+				struct perf_session *session)
 {
-	struct sample_data data;
 	struct trace_entry *te;
 
-	memset(&data, 0, sizeof(data));
-
-	event__parse_sample(event, session->sample_type, &data);
-
 	if (session->sample_type & PERF_SAMPLE_TIME) {
-		if (!first_time || first_time > data.time)
-			first_time = data.time;
-		if (last_time < data.time)
-			last_time = data.time;
+		if (!first_time || first_time > sample->time)
+			first_time = sample->time;
+		if (last_time < sample->time)
+			last_time = sample->time;
 	}
 
-	te = (void *)data.raw_data;
-	if (session->sample_type & PERF_SAMPLE_RAW && data.raw_size > 0) {
+	te = (void *)sample->raw_data;
+	if (session->sample_type & PERF_SAMPLE_RAW && sample->raw_size > 0) {
 		char *event_str;
 		struct power_entry *pe;
 
@@ -499,19 +499,19 @@ static int process_sample_event(event_t *event, struct perf_session *session)
 			return 0;
 
 		if (strcmp(event_str, "power:power_start") == 0)
-			c_state_start(pe->cpu_id, data.time, pe->value);
+			c_state_start(pe->cpu_id, sample->time, pe->value);
 
 		if (strcmp(event_str, "power:power_end") == 0)
-			c_state_end(pe->cpu_id, data.time);
+			c_state_end(pe->cpu_id, sample->time);
 
 		if (strcmp(event_str, "power:power_frequency") == 0)
-			p_state_change(pe->cpu_id, data.time, pe->value);
+			p_state_change(pe->cpu_id, sample->time, pe->value);
 
 		if (strcmp(event_str, "sched:sched_wakeup") == 0)
-			sched_wakeup(data.cpu, data.time, data.pid, te);
+			sched_wakeup(sample->cpu, sample->time, sample->pid, te);
 
 		if (strcmp(event_str, "sched:sched_switch") == 0)
-			sched_switch(data.cpu, data.time, te);
+			sched_switch(sample->cpu, sample->time, te);
 	}
 	return 0;
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 3d2b47d..5aa29e1 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1025,6 +1025,8 @@ static void event__process_sample(const event_t *self,
 	if (self->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		exact_samples++;
 
+	event__parse_sample(self, session->sample_type, &data);
+
 	if (event__preprocess_sample(self, session, &al, &data,
 				     symbol_filter) < 0 ||
 	    al.filtered)
@@ -1155,7 +1157,7 @@ static void perf_session__mmap_read_counter(struct perf_session *self,
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			event__process_sample(event, self, md->counter);
 		else
-			event__process(event, self);
+			event__process(event, NULL, self);
 		old += size;
 	}
 
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index e437edb..deffb8c 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -14,7 +14,9 @@
 #include <linux/kernel.h>
 #include "debug.h"
 
-static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
+static int build_id__mark_dso_hit(event_t *event,
+				  struct sample_data *sample __used,
+				  struct perf_session *session)
 {
 	struct addr_location al;
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
@@ -35,7 +37,8 @@ static int build_id__mark_dso_hit(event_t *event, struct perf_session *session)
 	return 0;
 }
 
-static int event__exit_del_thread(event_t *self, struct perf_session *session)
+static int event__exit_del_thread(event_t *self, struct sample_data *sample __used,
+				  struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->fork.tid);
 
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 7260db7..34510f4 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -24,6 +24,15 @@ const char *event__name[] = {
 	[PERF_RECORD_HEADER_BUILD_ID]	 = "BUILD_ID",
 };
 
+static struct sample_data synth_sample = {
+	.pid	   = -1,
+	.tid	   = -1,
+	.time	   = -1,
+	.stream_id = -1,
+	.cpu	   = -1,
+	.period	   = 1,
+};
+
 static pid_t event__synthesize_comm(pid_t pid, int full,
 				    event__handler_t process,
 				    struct perf_session *session)
@@ -75,7 +84,7 @@ out_race:
 	if (!full) {
 		ev.comm.tid = pid;
 
-		process(&ev, session);
+		process(&ev, &synth_sample, session);
 		goto out_fclose;
 	}
 
@@ -93,7 +102,7 @@ out_race:
 
 		ev.comm.tid = pid;
 
-		process(&ev, session);
+		process(&ev, &synth_sample, session);
 	}
 	closedir(tasks);
 
@@ -173,7 +182,7 @@ static int event__synthesize_mmap_events(pid_t pid, pid_t tgid,
 			ev.mmap.pid = tgid;
 			ev.mmap.tid = pid;
 
-			process(&ev, session);
+			process(&ev, &synth_sample, session);
 		}
 	}
 
@@ -219,7 +228,7 @@ int event__synthesize_modules(event__handler_t process,
 
 		memcpy(ev.mmap.filename, pos->dso->long_name,
 		       pos->dso->long_name_len + 1);
-		process(&ev, session);
+		process(&ev, &synth_sample, session);
 	}
 
 	return 0;
@@ -331,7 +340,7 @@ int event__synthesize_kernel_mmap(event__handler_t process,
 	ev.mmap.len   = map->end - ev.mmap.start;
 	ev.mmap.pid   = machine->pid;
 
-	return process(&ev, session);
+	return process(&ev, &synth_sample, session);
 }
 
 static void thread__comm_adjust(struct thread *self, struct hists *hists)
@@ -361,7 +370,8 @@ static int thread__set_comm_adjust(struct thread *self, const char *comm,
 	return 0;
 }
 
-int event__process_comm(event_t *self, struct perf_session *session)
+int event__process_comm(event_t *self, struct sample_data *sample __used,
+			struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->comm.tid);
 
@@ -376,7 +386,8 @@ int event__process_comm(event_t *self, struct perf_session *session)
 	return 0;
 }
 
-int event__process_lost(event_t *self, struct perf_session *session)
+int event__process_lost(event_t *self, struct sample_data *sample __used,
+			struct perf_session *session)
 {
 	dump_printf(": id:%Ld: lost:%Ld\n", self->lost.id, self->lost.lost);
 	session->hists.stats.total_lost += self->lost.lost;
@@ -485,7 +496,8 @@ out_problem:
 	return -1;
 }
 
-int event__process_mmap(event_t *self, struct perf_session *session)
+int event__process_mmap(event_t *self, struct sample_data *sample __used,
+			struct perf_session *session)
 {
 	struct machine *machine;
 	struct thread *thread;
@@ -526,7 +538,8 @@ out_problem:
 	return 0;
 }
 
-int event__process_task(event_t *self, struct perf_session *session)
+int event__process_task(event_t *self, struct sample_data *sample __used,
+			struct perf_session *session)
 {
 	struct thread *thread = perf_session__findnew(session, self->fork.tid);
 	struct thread *parent = perf_session__findnew(session, self->fork.ptid);
@@ -548,18 +561,19 @@ int event__process_task(event_t *self, struct perf_session *session)
 	return 0;
 }
 
-int event__process(event_t *event, struct perf_session *session)
+int event__process(event_t *event, struct sample_data *sample,
+		   struct perf_session *session)
 {
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		event__process_comm(event, session);
+		event__process_comm(event, sample, session);
 		break;
 	case PERF_RECORD_MMAP:
-		event__process_mmap(event, session);
+		event__process_mmap(event, sample, session);
 		break;
 	case PERF_RECORD_FORK:
 	case PERF_RECORD_EXIT:
-		event__process_task(event, session);
+		event__process_task(event, sample, session);
 		break;
 	default:
 		break;
@@ -674,32 +688,8 @@ int event__preprocess_sample(const event_t *self, struct perf_session *session,
 			     symbol_filter_t filter)
 {
 	u8 cpumode = self->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
-	struct thread *thread;
-
-	event__parse_sample(self, session->sample_type, data);
+	struct thread *thread = perf_session__findnew(session, self->ip.pid);
 
-	dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld cpu:%d\n",
-		    self->header.misc, data->pid, data->tid, data->ip,
-		    data->period, data->cpu);
-
-	if (session->sample_type & PERF_SAMPLE_CALLCHAIN) {
-		unsigned int i;
-
-		dump_printf("... chain: nr:%Lu\n", data->callchain->nr);
-
-		if (!ip_callchain__valid(data->callchain, self)) {
-			pr_debug("call-chain problem with event, "
-				 "skipping it.\n");
-			goto out_filtered;
-		}
-
-		if (dump_trace) {
-			for (i = 0; i < data->callchain->nr; i++)
-				dump_printf("..... %2d: %016Lx\n",
-					    i, data->callchain->ips[i]);
-		}
-	}
-	thread = perf_session__findnew(session, self->ip.pid);
 	if (thread == NULL)
 		return -1;
 
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 8e790da..08c400b 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -135,7 +135,10 @@ void event__print_totals(void);
 
 struct perf_session;
 
-typedef int (*event__handler_t)(event_t *event, struct perf_session *session);
+typedef int (*event__handler_synth_t)(event_t *event, 
+				      struct perf_session *session);
+typedef int (*event__handler_t)(event_t *event, struct sample_data *sample,
+				struct perf_session *session);
 
 int event__synthesize_thread(pid_t pid, event__handler_t process,
 			     struct perf_session *session);
@@ -150,11 +153,16 @@ int event__synthesize_modules(event__handler_t process,
 			      struct perf_session *session,
 			      struct machine *machine);
 
-int event__process_comm(event_t *self, struct perf_session *session);
-int event__process_lost(event_t *self, struct perf_session *session);
-int event__process_mmap(event_t *self, struct perf_session *session);
-int event__process_task(event_t *self, struct perf_session *session);
-int event__process(event_t *event, struct perf_session *session);
+int event__process_comm(event_t *self, struct sample_data *sample,
+			struct perf_session *session);
+int event__process_lost(event_t *self, struct sample_data *sample,
+			struct perf_session *session);
+int event__process_mmap(event_t *self, struct sample_data *sample,
+			struct perf_session *session);
+int event__process_task(event_t *self, struct sample_data *sample,
+			struct perf_session *session);
+int event__process(event_t *event, struct sample_data *sample,
+		   struct perf_session *session);
 
 struct addr_location;
 int event__preprocess_sample(const event_t *self, struct perf_session *session,
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f65d7dc..fe652f3 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -993,15 +993,14 @@ int event__synthesize_attr(struct perf_event_attr *attr, u16 ids, u64 *id,
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
 	ev->attr.header.size = size;
 
-	err = process(ev, session);
+	err = process(ev, NULL, session);
 
 	free(ev);
 
 	return err;
 }
 
-int event__synthesize_attrs(struct perf_header *self,
-			    event__handler_t process,
+int event__synthesize_attrs(struct perf_header *self, event__handler_t process,
 			    struct perf_session *session)
 {
 	struct perf_header_attr	*attr;
@@ -1071,7 +1070,7 @@ int event__synthesize_event_type(u64 event_id, char *name,
 	ev.event_type.header.size = sizeof(ev.event_type) -
 		(sizeof(ev.event_type.event_type.name) - size);
 
-	err = process(&ev, session);
+	err = process(&ev, NULL, session);
 
 	return err;
 }
@@ -1126,7 +1125,7 @@ int event__synthesize_tracing_data(int fd, struct perf_event_attr *pattrs,
 	ev.tracing_data.header.size = sizeof(ev.tracing_data);
 	ev.tracing_data.size = aligned_size;
 
-	process(&ev, session);
+	process(&ev, NULL, session);
 
 	err = read_tracing_data(fd, pattrs, nb_events);
 	write_padded(fd, NULL, 0, padding);
@@ -1186,7 +1185,7 @@ int event__synthesize_build_id(struct dso *pos, u16 misc,
 	ev.build_id.header.size = sizeof(ev.build_id) + len;
 	memcpy(&ev.build_id.filename, pos->long_name, pos->long_name_len);
 
-	err = process(&ev, session);
+	err = process(&ev, NULL, session);
 
 	return err;
 }
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 587d375..ee78985 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -52,8 +52,10 @@ struct sym_priv {
 struct events_stats {
 	u64 total_period;
 	u64 total_lost;
+	u64 total_invalid_chains;
 	u32 nr_events[PERF_RECORD_HEADER_MAX];
 	u32 nr_unknown_events;
+	u32 nr_invalid_chains;
 };
 
 enum hist_column {
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 52672da..08ec018 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -70,6 +70,11 @@ void perf_session__update_sample_type(struct perf_session *self)
 	self->sample_type = perf_header__sample_type(&self->header);
 }
 
+void perf_session__set_sample_type(struct perf_session *session, u64 type)
+{
+	session->sample_type = type;
+}
+
 int perf_session__create_kernel_maps(struct perf_session *self)
 {
 	int ret = machine__create_kernel_maps(&self->host_machine);
@@ -240,7 +245,15 @@ struct map_symbol *perf_session__resolve_callchain(struct perf_session *self,
 	return syms;
 }
 
+static int process_event_synth_stub(event_t *event __used,
+				    struct perf_session *session __used)
+{
+	dump_printf(": unhandled!\n");
+	return 0;
+}
+
 static int process_event_stub(event_t *event __used,
+			      struct sample_data *sample __used,
 			      struct perf_session *session __used)
 {
 	dump_printf(": unhandled!\n");
@@ -280,13 +293,13 @@ static void perf_event_ops__fill_defaults(struct perf_event_ops *handler)
 	if (handler->unthrottle == NULL)
 		handler->unthrottle = process_event_stub;
 	if (handler->attr == NULL)
-		handler->attr = process_event_stub;
+		handler->attr = process_event_synth_stub;
 	if (handler->event_type == NULL)
-		handler->event_type = process_event_stub;
+		handler->event_type = process_event_synth_stub;
 	if (handler->tracing_data == NULL)
-		handler->tracing_data = process_event_stub;
+		handler->tracing_data = process_event_synth_stub;
 	if (handler->build_id == NULL)
-		handler->build_id = process_event_stub;
+		handler->build_id = process_event_synth_stub;
 	if (handler->finished_round == NULL) {
 		if (handler->ordered_samples)
 			handler->finished_round = process_finished_round;
@@ -419,6 +432,7 @@ static void flush_sample_queue(struct perf_session *s,
 	struct ordered_samples *os = &s->ordered_samples;
 	struct list_head *head = &os->samples;
 	struct sample_queue *tmp, *iter;
+	struct sample_data sample;
 	u64 limit = os->next_flush;
 	u64 last_ts = os->last_sample ? os->last_sample->timestamp : 0ULL;
 
@@ -429,7 +443,8 @@ static void flush_sample_queue(struct perf_session *s,
 		if (iter->timestamp > limit)
 			break;
 
-		ops->sample(iter->event, s);
+		event__parse_sample(iter->event, s->sample_type, &sample);
+		ops->sample(iter->event, &sample, s);
 
 		os->last_flush = iter->timestamp;
 		list_del(&iter->list);
@@ -578,20 +593,29 @@ static int queue_sample_event(event_t *event, struct sample_data *data,
 	return 0;
 }
 
-static int perf_session__process_sample(event_t *event, struct perf_session *s,
+static int perf_session__process_sample(event_t *event,
+					struct sample_data *sample,
+					struct perf_session *s,
 					struct perf_event_ops *ops)
 {
-	struct sample_data data;
-
 	if (!ops->ordered_samples)
-		return ops->sample(event, s);
+		return ops->sample(event, sample, s);
+
+	queue_sample_event(event, sample, s);
+	return 0;
+}
 
-	bzero(&data, sizeof(struct sample_data));
-	event__parse_sample(event, s->sample_type, &data);
+static void callchain__dump(struct sample_data *sample)
+{
+	unsigned int i;
 
-	queue_sample_event(event, &data, s);
+	if (!dump_trace)
+		return;
 
-	return 0;
+	printf("... chain: nr:%Lu\n", sample->callchain->nr);
+
+	for (i = 0; i < sample->callchain->nr; i++)
+		printf("..... %2d: %016Lx\n", i, sample->callchain->ips[i]);
 }
 
 static int perf_session__process_event(struct perf_session *self,
@@ -599,8 +623,16 @@ static int perf_session__process_event(struct perf_session *self,
 				       struct perf_event_ops *ops,
 				       u64 file_offset)
 {
+	struct sample_data sample;
+
 	trace_event(event);
 
+	if (self->header.needs_swap && event__swap_ops[event->header.type])
+		event__swap_ops[event->header.type](event);
+
+	if (event->header.type == PERF_RECORD_SAMPLE)
+		event__parse_sample(event, self->sample_type, &sample);
+
 	if (event->header.type < PERF_RECORD_HEADER_MAX) {
 		dump_printf("%#Lx [%#x]: PERF_RECORD_%s",
 			    file_offset, event->header.size,
@@ -608,28 +640,41 @@ static int perf_session__process_event(struct perf_session *self,
 		hists__inc_nr_events(&self->hists, event->header.type);
 	}
 
-	if (self->header.needs_swap && event__swap_ops[event->header.type])
-		event__swap_ops[event->header.type](event);
-
 	switch (event->header.type) {
 	case PERF_RECORD_SAMPLE:
-		return perf_session__process_sample(event, self, ops);
+		dump_printf("(IP, %d): %d/%d: %#Lx period: %Ld\n", event->header.misc,
+			    sample.pid, sample.tid, sample.ip, sample.period);
+
+		if (self->sample_type & PERF_SAMPLE_CALLCHAIN) {
+			if (!ip_callchain__valid(sample.callchain, event)) {
+				pr_debug("call-chain problem with event, "
+					 "skipping it.\n");
+				++self->hists.stats.nr_invalid_chains;
+				self->hists.stats.total_invalid_chains += sample.period;
+				return 0;
+			}
+
+			callchain__dump(&sample);
+		}
+
+		return perf_session__process_sample(event, &sample, self, ops);
+
 	case PERF_RECORD_MMAP:
-		return ops->mmap(event, self);
+		return ops->mmap(event, &sample, self);
 	case PERF_RECORD_COMM:
-		return ops->comm(event, self);
+		return ops->comm(event, &sample, self);
 	case PERF_RECORD_FORK:
-		return ops->fork(event, self);
+		return ops->fork(event, &sample, self);
 	case PERF_RECORD_EXIT:
-		return ops->exit(event, self);
+		return ops->exit(event, &sample, self);
 	case PERF_RECORD_LOST:
-		return ops->lost(event, self);
+		return ops->lost(event, &sample, self);
 	case PERF_RECORD_READ:
-		return ops->read(event, self);
+		return ops->read(event, &sample, self);
 	case PERF_RECORD_THROTTLE:
-		return ops->throttle(event, self);
+		return ops->throttle(event, &sample, self);
 	case PERF_RECORD_UNTHROTTLE:
-		return ops->unthrottle(event, self);
+		return ops->unthrottle(event, &sample, self);
 	case PERF_RECORD_HEADER_ATTR:
 		return ops->attr(event, self);
 	case PERF_RECORD_HEADER_EVENT_TYPE:
@@ -894,6 +939,14 @@ out_err:
 			    session->hists.stats.nr_unknown_events);
 	}
 
+ 	if (session->hists.stats.nr_invalid_chains != 0) {
+ 		ui__warning("Found invalid callchains!\n\n"
+ 			    "%u out of %u events were discarded for this reason.\n\n"
+ 			    "Consider reporting to linux-kernel@vger.kernel.org.\n\n",
+ 			    session->hists.stats.nr_invalid_chains,
+ 			    session->hists.stats.nr_events[PERF_RECORD_SAMPLE]);
+ 	}
+
 	perf_session_free_sample_buffers(session);
 	return err;
 }
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 5bf6efa..4578f86 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -54,7 +54,9 @@ struct perf_session {
 
 struct perf_event_ops;
 
-typedef int (*event_op)(event_t *self, struct perf_session *session);
+typedef int (*event_op)(event_t *self, struct sample_data *sample,
+			struct perf_session *session);
+typedef int (*event_synth_op)(event_t *self, struct perf_session *session);
 typedef int (*event_op2)(event_t *self, struct perf_session *session,
 			 struct perf_event_ops *ops);
 
@@ -67,8 +69,8 @@ struct perf_event_ops {
 			lost,
 			read,
 			throttle,
-			unthrottle,
-			attr,
+			unthrottle;
+	event_synth_op	attr,
 			event_type,
 			tracing_data,
 			build_id;
@@ -104,6 +106,7 @@ int perf_session__create_kernel_maps(struct perf_session *self);
 
 int do_read(int fd, void *buf, size_t size);
 void perf_session__update_sample_type(struct perf_session *self);
+void perf_session__set_sample_type(struct perf_session *session, u64 type);
 void perf_session__remove_thread(struct perf_session *self, struct thread *th);
 
 static inline
-- 
1.6.2.5

