Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab2CHH2W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 02:28:22 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:64310 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab2CHH2T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 02:28:19 -0500
X-AuditID: 9c930179-b7c4fae0000073fb-36-4f585f90a644
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH/RFC] perf tools: Handle old kernels when opening perf event
Date: Thu,  8 Mar 2012 16:28:51 +0900
Message-Id: <1331191731-29541-1-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing default value of perf_guest back to false caused problems on old
kernels and its fix bc76efe64533 ("perf tools: Handle kernels that don't
support attr.exclude_{guest,host}") worked well for perf record/top.

But I've just realized that using specific events on perf stat makes same
kind of troubles too. It's because the parse_events calls event_attr_init
for all events so that it would have exclude_guest set.

Instead of fixing perf stat, I thought that changing perf_evsel__open()
is more appropriate. Please take a look and give comments - especially
on ->time_not_needed handling in builtin-record.c (I guess the original
code had a bug) and checking ->sample_id_all_missing inside of
perf_evsel__config (I believe checking it before perf_evsel__open is
meaningless since it will always have the same value - so I dropped it).

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |   32 ++++-----------------
 tools/perf/builtin-stat.c   |    5 ++-
 tools/perf/builtin-test.c   |   21 +++++++++++--
 tools/perf/builtin-top.c    |   25 +++-------------
 tools/perf/perf.h           |    8 ++++-
 tools/perf/util/evlist.c    |    5 ++-
 tools/perf/util/evlist.h    |    3 +-
 tools/perf/util/evsel.c     |   65 +++++++++++++++++++++++++++++++++++-------
 tools/perf/util/evsel.h     |    9 ++++--
 tools/perf/util/python.c    |   11 ++++++-
 10 files changed, 111 insertions(+), 73 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 75d230fef202..b926082012b8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -181,9 +181,11 @@ static void perf_record__open(struct perf_record *rec)
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
 	struct perf_record_opts *opts = &rec->opts;
+	struct perf_attr_conf attr_conf;
 
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
+	memset(&attr_conf, 0, sizeof(attr_conf));
 	perf_evlist__config_attrs(evlist, opts);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
@@ -201,18 +203,14 @@ static void perf_record__open(struct perf_record *rec)
 		 * We need to move counter creation to perf_session, support
 		 * different sample_types, etc.
 		 */
-		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
+		attr_conf.time_not_needed = !opts->sample_time &&
+					    !opts->raw_samples;
 
 		if (opts->group && pos != first)
 			group_fd = first->fd;
-fallback_missing_features:
-		if (opts->exclude_guest_missing)
-			attr->exclude_guest = attr->exclude_host = 0;
-retry_sample_id:
-		attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads,
-				     opts->group, group_fd) < 0) {
+				     opts->group, group_fd, &attr_conf) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
@@ -221,23 +219,6 @@ try_again:
 			} else if (err ==  ENODEV && opts->cpu_list) {
 				die("No such device - did you specify"
 					" an out-of-range profile CPU?\n");
-			} else if (err == EINVAL) {
-				if (!opts->exclude_guest_missing &&
-				    (attr->exclude_guest || attr->exclude_host)) {
-					pr_debug("Old kernel, cannot exclude "
-						 "guest or host samples.\n");
-					opts->exclude_guest_missing = true;
-					goto fallback_missing_features;
-				} else if (!opts->sample_id_all_missing) {
-					/*
-					 * Old kernel, no attr->sample_id_type_all field
-					 */
-					opts->sample_id_all_missing = true;
-					if (!opts->sample_time && !opts->raw_samples && !time_needed)
-						attr->sample_type &= ~PERF_SAMPLE_TIME;
-
-					goto retry_sample_id;
-				}
 			}
 
 			/*
@@ -245,8 +226,7 @@ try_again:
 			 * based cpu-clock-tick sw counter, which
 			 * is always available even if no PMU support:
 			 */
-			if (attr->type == PERF_TYPE_HARDWARE
-					&& attr->config == PERF_COUNT_HW_CPU_CYCLES) {
+			if (perf_evsel__match(pos, HARDWARE, HW_CPU_CYCLES)) {
 
 				if (verbose)
 					ui__warning("The cycles event is not supported, "
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index ea40e4e8b227..5e3cf43177f5 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -174,6 +174,7 @@ static struct perf_event_attr very_very_detailed_attrs[] = {
 
 
 struct perf_evlist		*evsel_list;
+struct perf_attr_conf 		attr_conf;
 
 static bool			system_wide			=  false;
 static int			run_idx				=  0;
@@ -295,14 +296,14 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 
 	if (system_wide)
 		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
-						group, group_fd);
+						group, group_fd, &attr_conf);
 	if (!target_pid && !target_tid) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
 	return perf_evsel__open_per_thread(evsel, evsel_list->threads,
-					   group, group_fd);
+					   group, group_fd, &attr_conf);
 }
 
 /*
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 3e087ce8daa6..6492bcfb0698 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -270,6 +270,7 @@ static int test__open_syscall_event(void)
 	struct thread_map *threads;
 	struct perf_evsel *evsel;
 	struct perf_event_attr attr;
+	struct perf_attr_conf attr_conf;
 	unsigned int nr_open_calls = 111, i;
 	int id = trace_event__id("sys_enter_open");
 
@@ -293,7 +294,9 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false, NULL) < 0) {
+	memset(&attr_conf, 0, sizeof(attr_conf));
+	if (perf_evsel__open_per_thread(evsel, threads, false, NULL,
+					&attr_conf) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -335,6 +338,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 	struct cpu_map *cpus;
 	struct perf_evsel *evsel;
 	struct perf_event_attr attr;
+	struct perf_attr_conf attr_conf;
 	unsigned int nr_open_calls = 111, i;
 	cpu_set_t cpu_set;
 	int id = trace_event__id("sys_enter_open");
@@ -368,7 +372,9 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false, NULL) < 0) {
+	memset(&attr_conf, 0, sizeof(attr_conf));
+	if (perf_evsel__open(evsel, cpus, threads, false, NULL,
+			     &attr_conf) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -467,6 +473,7 @@ static int test__basic_mmap(void)
 		.sample_type	= PERF_SAMPLE_ID,
 		.watermark	= 0,
 	};
+	struct perf_attr_conf attr_conf;
 	cpu_set_t cpu_set;
 	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
 					"getpgid", };
@@ -523,6 +530,8 @@ static int test__basic_mmap(void)
 	attr.wakeup_events = 1;
 	attr.sample_period = 1;
 
+	memset(&attr_conf, 0, sizeof(attr_conf));
+
 	for (i = 0; i < nsyscalls; ++i) {
 		attr.config = ids[i];
 		evsels[i] = perf_evsel__new(&attr, i);
@@ -533,7 +542,8 @@ static int test__basic_mmap(void)
 
 		perf_evlist__add(evlist, evsels[i]);
 
-		if (perf_evsel__open(evsels[i], cpus, threads, false, NULL) < 0) {
+		if (perf_evsel__open(evsels[i], cpus, threads, false, NULL,
+				     &attr_conf) < 0) {
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 				 strerror(errno));
@@ -1019,6 +1029,7 @@ static int test__PERF_RECORD(void)
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
 	struct perf_evsel *evsel;
 	struct perf_sample sample;
+	struct perf_attr_conf attr_conf;
 	const char *cmd = "sleep";
 	const char *argv[] = { cmd, "1", NULL, };
 	char *bname;
@@ -1097,11 +1108,13 @@ static int test__PERF_RECORD(void)
 		goto out_free_cpu_mask;
 	}
 
+	memset(&attr_conf, 0, sizeof(attr_conf));
+
 	/*
 	 * Call sys_perf_event_open on all the fds on all the evsels,
 	 * grouping them if asked to.
 	 */
-	err = perf_evlist__open(evlist, opts.group);
+	err = perf_evlist__open(evlist, opts.group, &attr_conf);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
 		goto out_delete_evlist;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63aef8efc..b3fd28a573dd 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -843,6 +843,9 @@ static void perf_top__start_counters(struct perf_top *top)
 {
 	struct perf_evsel *counter, *first;
 	struct perf_evlist *evlist = top->evlist;
+	struct perf_attr_conf attr_conf;
+
+	memset(&attr_conf, 0, sizeof(attr_conf));
 
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
@@ -872,34 +875,16 @@ static void perf_top__start_counters(struct perf_top *top)
 		attr->mmap = 1;
 		attr->comm = 1;
 		attr->inherit = top->inherit;
-fallback_missing_features:
-		if (top->exclude_guest_missing)
-			attr->exclude_guest = attr->exclude_host = 0;
-retry_sample_id:
-		attr->sample_id_all = top->sample_id_all_missing ? 0 : 1;
+
 try_again:
 		if (perf_evsel__open(counter, top->evlist->cpus,
 				     top->evlist->threads, top->group,
-				     group_fd) < 0) {
+				     group_fd, &attr_conf) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				goto out_err;
-			} else if (err == EINVAL) {
-				if (!top->exclude_guest_missing &&
-				    (attr->exclude_guest || attr->exclude_host)) {
-					pr_debug("Old kernel, cannot exclude "
-						 "guest or host samples.\n");
-					top->exclude_guest_missing = true;
-					goto fallback_missing_features;
-				} else if (!top->sample_id_all_missing) {
-					/*
-					 * Old kernel, no attr->sample_id_type_all field
-					 */
-					top->sample_id_all_missing = true;
-					goto retry_sample_id;
-				}
 			}
 			/*
 			 * If it's cycles then fall back to hrtimer
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index f0227e93665d..60c3fcab384a 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -198,8 +198,6 @@ struct perf_record_opts {
 	bool	     raw_samples;
 	bool	     sample_address;
 	bool	     sample_time;
-	bool	     sample_id_all_missing;
-	bool	     exclude_guest_missing;
 	bool	     system_wide;
 	bool	     period;
 	unsigned int freq;
@@ -210,4 +208,10 @@ struct perf_record_opts {
 	const char   *cpu_list;
 };
 
+struct perf_attr_conf {
+	bool	     sample_id_all_missing;
+	bool	     exclude_guest_missing;
+	bool	     time_not_needed;
+};
+
 #endif
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 159263d17c2d..eee83a0e6231 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -738,7 +738,8 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 	evlist->selected = evsel;
 }
 
-int perf_evlist__open(struct perf_evlist *evlist, bool group)
+int perf_evlist__open(struct perf_evlist *evlist, bool group,
+		      struct perf_attr_conf *attr_conf)
 {
 	struct perf_evsel *evsel, *first;
 	int err, ncpus, nthreads;
@@ -752,7 +753,7 @@ int perf_evlist__open(struct perf_evlist *evlist, bool group)
 			group_fd = first->fd;
 
 		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads,
-				       group, group_fd);
+				       group, group_fd, attr_conf);
 		if (err < 0)
 			goto out_err;
 	}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 21f1c9e57f13..84676747d945 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -78,7 +78,8 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
-int perf_evlist__open(struct perf_evlist *evlist, bool group);
+int perf_evlist__open(struct perf_evlist *evlist, bool group,
+		      struct perf_attr_conf *attr_conf);
 
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 302d49a9f985..b8154e873e6d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -68,7 +68,6 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
-	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
 	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
 			      PERF_FORMAT_TOTAL_TIME_RUNNING |
@@ -111,9 +110,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	if (opts->period)
 		attr->sample_type	|= PERF_SAMPLE_PERIOD;
 
-	if (!opts->sample_id_all_missing &&
-	    (opts->sample_time || opts->system_wide ||
-	     !opts->no_inherit || opts->cpu_list))
+	if (opts->sample_time || opts->system_wide ||
+	     !opts->no_inherit || opts->cpu_list)
 		attr->sample_type	|= PERF_SAMPLE_TIME;
 
 	if (opts->raw_samples) {
@@ -287,7 +285,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	return 0;
 }
 
-static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
+static int ___perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads, bool group,
 			      struct xyarray *group_fds)
 {
@@ -339,6 +337,47 @@ out_close:
 	return err;
 }
 
+static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
+			      struct thread_map *threads, bool group,
+			      struct xyarray *group_fds,
+			      struct perf_attr_conf *attr_conf)
+{
+	int ret;
+	struct perf_event_attr *attr = &evsel->attr;
+
+retry:
+	if (attr_conf->exclude_guest_missing)
+		attr->exclude_guest = attr->exclude_host = 0;
+
+	attr->sample_id_all = attr_conf->sample_id_all_missing ? 0 : 1;
+
+	ret = ___perf_evsel__open(evsel, cpus, threads, group, group_fds);
+	if (ret == -EINVAL) {
+		/*
+		 * The order of checking is important since it reflects when
+		 * the new bit was included to kernel. The recent feature bit
+		 * should be checked earlier so that it cannot disable the
+		 * unintended feature(s).
+		 */
+		if (!attr_conf->exclude_guest_missing &&
+		    (attr->exclude_guest || attr->exclude_host)) {
+			pr_debug("Old kernel, cannot exclude "
+				 "guest or host samples.\n");
+			attr_conf->exclude_guest_missing = true;
+			goto retry;
+		} else if (!attr_conf->sample_id_all_missing) {
+			pr_debug("Old kernel, cannot set sample_id_all.\n");
+
+			attr_conf->sample_id_all_missing = true;
+			if (attr_conf->time_not_needed)
+				attr->sample_type &= ~PERF_SAMPLE_TIME;
+			goto retry;
+		}
+	}
+
+	return ret;
+}
+
 void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	if (evsel->fd == NULL)
@@ -367,7 +406,8 @@ static struct {
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads, bool group,
-		     struct xyarray *group_fd)
+		     struct xyarray *group_fd,
+		     struct perf_attr_conf *attr_conf)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -377,23 +417,26 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group, group_fd);
+	return __perf_evsel__open(evsel, cpus, threads, group, group_fd,
+				  attr_conf);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 			     struct cpu_map *cpus, bool group,
-			     struct xyarray *group_fd)
+			     struct xyarray *group_fd,
+			     struct perf_attr_conf *attr_conf)
 {
 	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group,
-				  group_fd);
+				  group_fd, attr_conf);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads, bool group,
-				struct xyarray *group_fd)
+				struct xyarray *group_fd,
+				struct perf_attr_conf *attr_conf)
 {
 	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group,
-				  group_fd);
+				  group_fd, attr_conf);
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 326b8e4d5035..2c72e805e7ed 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -91,13 +91,16 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 			     struct cpu_map *cpus, bool group,
-			     struct xyarray *group_fds);
+			     struct xyarray *group_fds,
+			     struct perf_attr_conf *attr_conf);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 				struct thread_map *threads, bool group,
-				struct xyarray *group_fds);
+				struct xyarray *group_fds,
+				struct perf_attr_conf *attr_conf);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads, bool group,
-		     struct xyarray *group_fds);
+		     struct xyarray *group_fds,
+		     struct perf_attr_conf *attr_conf);
 void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 #define perf_evsel__match(evsel, t, c)		\
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e03b58a48424..b9fd7ec4ce18 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -611,6 +611,7 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	PyObject *pcpus = NULL, *pthreads = NULL;
 	int group = 0, inherit = 0;
 	static char *kwlist[] = { "cpus", "threads", "group", "inherit", NULL };
+	struct perf_attr_conf attr_conf;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist,
 					 &pcpus, &pthreads, &group, &inherit))
@@ -623,11 +624,15 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 		cpus = ((struct pyrf_cpu_map *)pcpus)->cpus;
 
 	evsel->attr.inherit = inherit;
+
+	memset(&attr_conf, 0, sizeof(attr_conf));
+
 	/*
 	 * This will group just the fds for this single evsel, to group
 	 * multiple events, use evlist.open().
 	 */
-	if (perf_evsel__open(evsel, cpus, threads, group, NULL) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads, group, NULL,
+			     &attr_conf) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
@@ -824,11 +829,13 @@ static PyObject *pyrf_evlist__open(struct pyrf_evlist *pevlist,
 	struct perf_evlist *evlist = &pevlist->evlist;
 	int group = 0;
 	static char *kwlist[] = { "group", NULL };
+	struct perf_attr_conf attr_conf;
 
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist, &group))
 		return NULL;
 
-	if (perf_evlist__open(evlist, group) < 0) {
+	memset(&attr_conf, 0, sizeof(attr_conf));
+	if (perf_evlist__open(evlist, group, &attr_conf) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
-- 
1.7.9

