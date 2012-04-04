Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756510Ab2DDVS2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:18:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44854 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753135Ab2DDVQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/8] perf, tool: Enable grouping logic for parsed events
Date: Wed,  4 Apr 2012 23:16:10 +0200
Message-Id: <1333574176-11388-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current event grouping is basic. If you specify the '--group'
option for record/stat/top command, all the specified events become
members of a single group with the first event as a group leader.

This patch adds a functionality that allows to create event groups
based on the way they are specified on the command line. The 'group='
syntax introduced in earlier patch is used. The current '--group/-g'
option behaviour remains intact.

It is possible to create a group with following:
  perf record -e group=cycles,faults ls

creating single event group containing 'cycles' and 'faults' events,
and with cycles event as a leader.

All groups are created with regards to threads and cpus. Thus
recording an event group within a 2 threads on server with
4 CPUs will create 8 separate groups.

Examples (first event in brackets is group leader):

  # 1 group (cpu-clock,task-clock)
  perf record --group -e cpu-clock,task-clock ls
  perf record -e group=cpu-clock,task-clock ls

  # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
  perf record -e "group=cpu-clock,task-clock;group=minor-faults,major-faults" ls

  # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
  perf record --group -e cpu-clock,task-clock \
   -e minor-faults,major-faults ls

  # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
  perf record -v -e group=cpu-clock,task-clock \
   -e group=minor-faults,major-faults -e instructions ls

  # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
  perf record --group -e cpu-clock,task-clock \
   -e minor-faults,major-faults -e instructions ls

Updated automated test to check on group_leader settings.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c         |   13 +++----
 tools/perf/builtin-stat.c           |   13 +++----
 tools/perf/builtin-test.c           |    8 ++--
 tools/perf/builtin-top.c            |   12 ++----
 tools/perf/util/evlist.c            |   34 +++++++++++++------
 tools/perf/util/evlist.h            |    5 ++-
 tools/perf/util/evsel.c             |   46 ++++++++++++++++----------
 tools/perf/util/evsel.h             |   10 ++---
 tools/perf/util/parse-events-test.c |   61 +++++++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.c      |    3 +-
 tools/perf/util/python.c            |    7 +++-
 11 files changed, 144 insertions(+), 68 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 87fc68d..3e0ef7d 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -177,18 +177,18 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 
 static void perf_record__open(struct perf_record *rec)
 {
-	struct perf_evsel *pos, *first;
+	struct perf_evsel *pos;
 	struct perf_evlist *evlist = rec->evlist;
 	struct perf_session *session = rec->session;
 	struct perf_record_opts *opts = &rec->opts;
 
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
-
 	perf_evlist__config_attrs(evlist, opts);
 
+	if (opts->group)
+		perf_evlist__group(evlist);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
-		struct xyarray *group_fd = NULL;
 		/*
 		 * Check if parse_single_tracepoint_event has already asked for
 		 * PERF_SAMPLE_TIME.
@@ -203,16 +203,13 @@ static void perf_record__open(struct perf_record *rec)
 		 */
 		bool time_needed = attr->sample_type & PERF_SAMPLE_TIME;
 
-		if (opts->group && pos != first)
-			group_fd = first->fd;
 fallback_missing_features:
 		if (opts->exclude_guest_missing)
 			attr->exclude_guest = attr->exclude_host = 0;
 retry_sample_id:
 		attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 try_again:
-		if (perf_evsel__open(pos, evlist->cpus, evlist->threads,
-				     opts->group, group_fd) < 0) {
+		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index c941bb6..9dffc8f 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -282,10 +282,6 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 				    struct perf_evsel *first)
 {
 	struct perf_event_attr *attr = &evsel->attr;
-	struct xyarray *group_fd = NULL;
-
-	if (group && evsel != first)
-		group_fd = first->fd;
 
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
@@ -294,15 +290,13 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 	attr->inherit = !no_inherit;
 
 	if (system_wide)
-		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
-						group, group_fd);
+		return perf_evsel__open_per_cpu(evsel, evsel_list->cpus);
 	if (!target_pid && !target_tid && (!group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
 
-	return perf_evsel__open_per_thread(evsel, evsel_list->threads,
-					   group, group_fd);
+	return perf_evsel__open_per_thread(evsel, evsel_list->threads);
 }
 
 /*
@@ -459,6 +453,9 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
+	if (group)
+		perf_evlist__group(evsel_list);
+
 	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 7c61eef..c19d2d7 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -294,7 +294,7 @@ static int test__open_syscall_event(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open_per_thread(evsel, threads, false, NULL) < 0) {
+	if (perf_evsel__open_per_thread(evsel, threads) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -369,7 +369,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		goto out_thread_map_delete;
 	}
 
-	if (perf_evsel__open(evsel, cpus, threads, false, NULL) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads) < 0) {
 		pr_debug("failed to open counter: %s, "
 			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 			 strerror(errno));
@@ -534,7 +534,7 @@ static int test__basic_mmap(void)
 
 		perf_evlist__add(evlist, evsels[i]);
 
-		if (perf_evsel__open(evsels[i], cpus, threads, false, NULL) < 0) {
+		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
 			pr_debug("failed to open counter: %s, "
 				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
 				 strerror(errno));
@@ -736,7 +736,7 @@ static int test__PERF_RECORD(void)
 	 * Call sys_perf_event_open on all the fds on all the evsels,
 	 * grouping them if asked to.
 	 */
-	err = perf_evlist__open(evlist, opts.group);
+	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
 		goto out_delete_evlist;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3c63ae..38944a2 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -841,17 +841,14 @@ static void perf_top__mmap_read(struct perf_top *top)
 
 static void perf_top__start_counters(struct perf_top *top)
 {
-	struct perf_evsel *counter, *first;
+	struct perf_evsel *counter;
 	struct perf_evlist *evlist = top->evlist;
 
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+	if (top->group)
+		perf_evlist__group(evlist);
 
 	list_for_each_entry(counter, &evlist->entries, node) {
 		struct perf_event_attr *attr = &counter->attr;
-		struct xyarray *group_fd = NULL;
-
-		if (top->group && counter != first)
-			group_fd = first->fd;
 
 		attr->sample_type = PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
@@ -879,8 +876,7 @@ retry_sample_id:
 		attr->sample_id_all = top->sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(counter, top->evlist->cpus,
-				     top->evlist->threads, top->group,
-				     group_fd) < 0) {
+				     top->evlist->threads) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 1986d80..486f939 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -107,6 +107,26 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 	evlist->nr_entries += nr_entries;
 }
 
+void perf_evlist__group_list(struct list_head *list)
+{
+	struct perf_evsel *evsel, *first;
+
+	first = list_entry(list->next, struct perf_evsel, node);
+
+	list_for_each_entry(evsel, list, node)
+		if (evsel != first)
+			evsel->leader = first;
+}
+
+int perf_evlist__group(struct perf_evlist *evlist)
+{
+	if (!evlist->nr_entries)
+		return -EINVAL;
+
+	perf_evlist__group_list(&evlist->entries);
+	return 0;
+}
+
 int perf_evlist__add_default(struct perf_evlist *evlist)
 {
 	struct perf_event_attr attr = {
@@ -740,21 +760,13 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
 	evlist->selected = evsel;
 }
 
-int perf_evlist__open(struct perf_evlist *evlist, bool group)
+int perf_evlist__open(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel, *first;
+	struct perf_evsel *evsel;
 	int err, ncpus, nthreads;
 
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
-
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		struct xyarray *group_fd = NULL;
-
-		if (group && evsel != first)
-			group_fd = first->fd;
-
-		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads,
-				       group, group_fd);
+		err = perf_evsel__open(evsel, evlist->cpus, evlist->threads);
 		if (err < 0)
 			goto out_err;
 	}
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 21f1c9e..863789a 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -78,7 +78,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
-int perf_evlist__open(struct perf_evlist *evlist, bool group);
+int perf_evlist__open(struct perf_evlist *evlist);
 
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts);
@@ -122,4 +122,7 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries);
 
+void perf_evlist__group_list(struct list_head *list);
+int perf_evlist__group(struct perf_evlist *evlist);
+
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 8c13dbc..445ba60 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -16,7 +16,6 @@
 #include "thread_map.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-#define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
 
 int __perf_evsel__sample_size(u64 sample_type)
 {
@@ -293,9 +292,24 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	return 0;
 }
 
+static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
+{
+	struct perf_evsel *leader = evsel->leader;
+
+	if (!leader)
+		return -1;
+
+	/*
+	 * Leader must be already processed/open,
+	 * if not it's a bug.
+	 */
+	assert(leader->fd);
+
+	return FD(leader, cpu, thread);
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group,
-			      struct xyarray *group_fds)
+			      struct thread_map *threads)
 {
 	int cpu, thread;
 	unsigned long flags = 0;
@@ -311,13 +325,15 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		int group_fd = group_fds ? GROUP_FD(group_fds, cpu) : -1;
 
 		for (thread = 0; thread < threads->nr; thread++) {
+			int group_fd;
 
 			if (!evsel->cgrp)
 				pid = threads->map[thread];
 
+			group_fd = get_group_fd(evsel, cpu, thread);
+
 			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
 								     pid,
 								     cpus->map[cpu],
@@ -327,8 +343,9 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 				goto out_close;
 			}
 
-			if (group && group_fd == -1)
-				group_fd = FD(evsel, cpu, thread);
+			pr_debug("event cpu %d, thread %d, fd %d, group %d\n",
+				 cpu, pid, FD(evsel, cpu, thread),
+				 group_fd);
 		}
 	}
 
@@ -372,8 +389,7 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group,
-		     struct xyarray *group_fd)
+		     struct thread_map *threads)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -383,23 +399,19 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	if (threads == NULL)
 		threads = &empty_thread_map.map;
 
-	return __perf_evsel__open(evsel, cpus, threads, group, group_fd);
+	return __perf_evsel__open(evsel, cpus, threads);
 }
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group,
-			     struct xyarray *group_fd)
+			     struct cpu_map *cpus)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map, group,
-				  group_fd);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group,
-				struct xyarray *group_fd)
+				struct thread_map *threads)
 {
-	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads, group,
-				  group_fd);
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads);
 }
 
 static int perf_event__parse_id_sample(const union perf_event *event, u64 type,
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3d6b3e4..e749d5c 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -66,6 +66,7 @@ struct perf_evsel {
 		void		*data;
 	} handler;
 	bool 			supported;
+	struct perf_evsel	*leader;
 };
 
 struct cpu_map;
@@ -91,14 +92,11 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
 void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
-			     struct cpu_map *cpus, bool group,
-			     struct xyarray *group_fds);
+			     struct cpu_map *cpus);
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
-				struct thread_map *threads, bool group,
-				struct xyarray *group_fds);
+				struct thread_map *threads);
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group,
-		     struct xyarray *group_fds);
+		     struct thread_map *threads);
 void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 
 #define perf_evsel__match(evsel, t, c)		\
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index 73ff0af..baa4caf 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -388,8 +388,7 @@ static int test__checkevent_list(struct perf_evlist *evlist)
 
 static int test__checkevent_pmu_name(struct perf_evlist *evlist)
 {
-	struct perf_evsel *evsel = list_entry(evlist->entries.next,
-					      struct perf_evsel, node);
+	struct perf_evsel *evsel;
 
 	/* cpu/config=1,name=krava1/u */
 	evsel = list_entry(evlist->entries.next, struct perf_evsel, node);
@@ -431,6 +430,60 @@ static int test__checkevent_pmu_branch_type(struct perf_evlist *evlist)
 	return 0;
 }
 
+static int test__checkevent_group(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel, *leader;
+
+	TEST_ASSERT_VAL("wrong number of entries", 6 == evlist->nr_entries);
+
+	/* cycles */
+	evsel = leader = list_entry(evlist->entries.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* faults */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	/* r1 */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 1 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* mem:0 */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_BREAKPOINT == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config", 0 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong bp_type", (HW_BREAKPOINT_R | HW_BREAKPOINT_W) ==
+					 evsel->attr.bp_type);
+	TEST_ASSERT_VAL("wrong bp_len", HW_BREAKPOINT_LEN_4 ==
+					evsel->attr.bp_len);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* cpu/config=2,period=1000/u */
+	evsel = leader = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_RAW == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",  2 == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong sample_period",
+			1000 == evsel->attr.sample_period);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
+
+	/* instructions:h" */
+	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong config",
+			PERF_COUNT_HW_INSTRUCTIONS == evsel->attr.config);
+	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
+
+	return 0;
+}
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -544,6 +597,10 @@ static struct test__event_st {
 		.name  = "cpu/config=1,branch_type=hv|any_ret|1,config2=2/u",
 		.check = test__checkevent_pmu_branch_type,
 	},
+	[27] = {
+		.name  = "group=cycles,faults;r1,mem:0:u;group=cpu/config=2,period=1000/u,instructions:h",
+		.check = test__checkevent_group,
+	},
 };
 
 #define TEST__EVENTS_CNT (sizeof(test__events) / sizeof(struct test__event_st))
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 53c7505..5110916 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -791,8 +791,9 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-int parse_events__group(struct list_head *list __used)
+int parse_events__group(struct list_head *list)
 {
+	perf_evlist__group_list(list);
 	return 0;
 }
 
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index e03b58a..419c29e 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -627,7 +627,7 @@ static PyObject *pyrf_evsel__open(struct pyrf_evsel *pevsel,
 	 * This will group just the fds for this single evsel, to group
 	 * multiple events, use evlist.open().
 	 */
-	if (perf_evsel__open(evsel, cpus, threads, group, NULL) < 0) {
+	if (perf_evsel__open(evsel, cpus, threads) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
@@ -828,7 +828,10 @@ static PyObject *pyrf_evlist__open(struct pyrf_evlist *pevlist,
 	if (!PyArg_ParseTupleAndKeywords(args, kwargs, "|OOii", kwlist, &group))
 		return NULL;
 
-	if (perf_evlist__open(evlist, group) < 0) {
+	if (group)
+		perf_evlist__group(evlist);
+
+	if (perf_evlist__open(evlist) < 0) {
 		PyErr_SetFromErrno(PyExc_OSError);
 		return NULL;
 	}
-- 
1.7.7.6

