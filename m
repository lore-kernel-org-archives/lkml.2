Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753602Ab2F2JJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:09:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49427 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753086Ab2F2JJB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:09:01 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        drepper@gmail.com, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 2/3] perf, tool: Enable grouping logic for parsed events
Date: Fri, 29 Jun 2012 11:08:26 +0200
Message-Id: <1340960907-3725-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
References: <1340960907-3725-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a functionality that allows to create event groups
based on the way they are specified on the command line. Adding
functionality to the '{}' group syntax introduced in earlier patch.

The current '--group/-g' option behaviour remains intact.  If you
specify it for record/stat/top command, all the specified events
become members of a single group with the first event as a group
leader.

With the new '{}' group syntax you can create group like:
  # perf record -e '{cycles,faults}' ls

resulting in single event group containing 'cycles' and 'faults'
events, with cycles event as group leader.

All groups are created with regards to threads and cpus. Thus
recording an event group within a 2 threads on server with
4 CPUs will create 8 separate groups.

Examples (first event in brackets is group leader):

  # 1 group (cpu-clock,task-clock)
  perf record --group -e cpu-clock,task-clock ls
  perf record -e '{cpu-clock,task-clock}' ls

  # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
  perf record -e '{cpu-clock,task-clock},{minor-faults,major-faults}' ls

  # 1 group (cpu-clock,task-clock,minor-faults,major-faults)
  perf record --group -e cpu-clock,task-clock -e minor-faults,major-faults ls
  perf record -e '{cpu-clock,task-clock,minor-faults,major-faults}' ls

  # 2 groups (cpu-clock,task-clock) (minor-faults,major-faults)
  perf record -e '{cpu-clock,task-clock} -e '{minor-faults,major-faults}' \
   -e instructions ls

  # 1 group (cpu-clock,task-clock,minor-faults,major-faults,instructions)
  perf record --group -e cpu-clock,task-clock \
   -e minor-faults,major-faults -e instructions ls
  perf record -e '{cpu-clock,task-clock,minor-faults,major-faults,instructions}' ls

It's possible to use standard event modifier for a group, which spans
over all events in the group and overrides any event modifier settings,
for example:

  # perf record -r '{faults:k,cache-references}:u'

resulting in ':u' modifier being used for both 'faults' and 'cache-references'
events, regardless of their modifier setup (':k' for faults event).

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/builtin-record.c    |   13 ++++------
 tools/perf/builtin-stat.c      |   13 ++++------
 tools/perf/builtin-test.c      |    8 +++---
 tools/perf/builtin-top.c       |   12 +++------
 tools/perf/util/evlist.c       |   20 +++++++--------
 tools/perf/util/evlist.h       |    3 +-
 tools/perf/util/evsel.c        |   51 ++++++++++++++++++++++++++-------------
 tools/perf/util/evsel.h        |   11 ++++----
 tools/perf/util/parse-events.c |   26 +++++++++++++++++---
 tools/perf/util/parse-events.h |    1 +
 tools/perf/util/python.c       |    7 ++++-
 11 files changed, 96 insertions(+), 69 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index f5a6452..94d6b12 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -176,18 +176,18 @@ static bool perf_evlist__equal(struct perf_evlist *evlist,
 
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
@@ -202,16 +202,13 @@ static void perf_record__open(struct perf_record *rec)
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
index 861f0ae..23908a8 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -281,13 +281,9 @@ static int create_perf_stat_counter(struct perf_evsel *evsel,
 				    struct perf_evsel *first)
 {
 	struct perf_event_attr *attr = &evsel->attr;
-	struct xyarray *group_fd = NULL;
 	bool exclude_guest_missing = false;
 	int ret;
 
-	if (group && evsel != first)
-		group_fd = first->fd;
-
 	if (scale)
 		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
 				    PERF_FORMAT_TOTAL_TIME_RUNNING;
@@ -299,8 +295,7 @@ retry:
 		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
 
 	if (perf_target__has_cpu(&target)) {
-		ret = perf_evsel__open_per_cpu(evsel, evsel_list->cpus,
-					       group, group_fd);
+		ret = perf_evsel__open_per_cpu(evsel, evsel_list->cpus);
 		if (ret)
 			goto check_ret;
 		return 0;
@@ -311,8 +306,7 @@ retry:
 		attr->enable_on_exec = 1;
 	}
 
-	ret = perf_evsel__open_per_thread(evsel, evsel_list->threads,
-					  group, group_fd);
+	ret = perf_evsel__open_per_thread(evsel, evsel_list->threads);
 	if (!ret)
 		return 0;
 	/* fall through */
@@ -483,6 +477,9 @@ static int run_perf_stat(int argc __used, const char **argv)
 		close(child_ready_pipe[0]);
 	}
 
+	if (group)
+		perf_evlist__group(evsel_list);
+
 	first = list_entry(evsel_list->entries.next, struct perf_evsel, node);
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 5ce3030..03568b8 100644
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
@@ -739,7 +739,7 @@ static int test__PERF_RECORD(void)
 	 * Call sys_perf_event_open on all the fds on all the evsels,
 	 * grouping them if asked to.
 	 */
-	err = perf_evlist__open(evlist, opts.group);
+	err = perf_evlist__open(evlist);
 	if (err < 0) {
 		pr_debug("perf_evlist__open: %s\n", strerror(errno));
 		goto out_delete_evlist;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index e3cab5f..c5cc2ab 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -875,17 +875,14 @@ static void perf_top__mmap_read(struct perf_top *top)
 
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
 
@@ -916,8 +913,7 @@ retry_sample_id:
 		attr->sample_id_all = top->sample_id_all_missing ? 0 : 1;
 try_again:
 		if (perf_evsel__open(counter, top->evlist->cpus,
-				     top->evlist->threads, top->group,
-				     group_fd) < 0) {
+				     top->evlist->threads) < 0) {
 			int err = errno;
 
 			if (err == EPERM || err == EACCES) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 7400fb3..5fa9257 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -108,6 +108,12 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 	evlist->nr_entries += nr_entries;
 }
 
+void perf_evlist__group(struct perf_evlist *evlist)
+{
+	if (evlist->nr_entries)
+		parse_events__group_leader(&evlist->entries);
+}
+
 int perf_evlist__add_default(struct perf_evlist *evlist)
 {
 	struct perf_event_attr attr = {
@@ -757,21 +763,13 @@ void perf_evlist__set_selected(struct perf_evlist *evlist,
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
index 989bee9..d842931 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -82,7 +82,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
-int perf_evlist__open(struct perf_evlist *evlist, bool group);
+int perf_evlist__open(struct perf_evlist *evlist);
 
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts);
@@ -126,4 +126,5 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries);
 
+void perf_evlist__group(struct perf_evlist *evlist);
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 876f639..7e8cc31 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -18,7 +18,6 @@
 #include "../../include/linux/perf_event.h"
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
-#define GROUP_FD(group_fd, cpu) (*(int *)xyarray__entry(group_fd, cpu, 0))
 
 int __perf_evsel__sample_size(u64 sample_type)
 {
@@ -451,6 +450,7 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 {
 	perf_evsel__exit(evsel);
 	close_cgroup(evsel->cgrp);
+	free(evsel->group_name);
 	free(evsel->name);
 	free(evsel);
 }
@@ -526,9 +526,28 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	return 0;
 }
 
+static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
+{
+	struct perf_evsel *leader = evsel->leader;
+	int fd;
+
+	if (!leader)
+		return -1;
+
+	/*
+	 * Leader must be already processed/open,
+	 * if not it's a bug.
+	 */
+	BUG_ON(!leader->fd);
+
+	fd = FD(leader, cpu, thread);
+	BUG_ON(fd == -1);
+
+	return fd;
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-			      struct thread_map *threads, bool group,
-			      struct xyarray *group_fds)
+			      struct thread_map *threads)
 {
 	int cpu, thread;
 	unsigned long flags = 0;
@@ -544,13 +563,15 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
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
@@ -560,8 +581,9 @@ static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 				goto out_close;
 			}
 
-			if (group && group_fd == -1)
-				group_fd = FD(evsel, cpu, thread);
+			pr_debug("event cpu %d, thread %d, fd %d, group %d\n",
+				 cpu, pid, FD(evsel, cpu, thread),
+				 group_fd);
 		}
 	}
 
@@ -605,8 +627,7 @@ static struct {
 };
 
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
-		     struct thread_map *threads, bool group,
-		     struct xyarray *group_fd)
+		     struct thread_map *threads)
 {
 	if (cpus == NULL) {
 		/* Work around old compiler warnings about strict aliasing */
@@ -616,23 +637,19 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
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
index 67cc503..b39f3db 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -66,6 +66,8 @@ struct perf_evsel {
 		void		*data;
 	} handler;
 	bool 			supported;
+	struct perf_evsel	*leader;
+	char			*group_name;
 };
 
 struct cpu_map;
@@ -105,14 +107,11 @@ void perf_evsel__free_id(struct perf_evsel *evsel);
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
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index f62cbee..40ad468 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -547,14 +547,32 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 			 pmu_event_name(head_config));
 }
 
-int parse_events__modifier_group(struct list_head *list __used,
-				 char *event_mod __used)
+struct perf_evsel *parse_events__group_leader(struct list_head *list)
 {
-	return 0;
+	struct perf_evsel *evsel, *leader;
+
+	leader = list_entry(list->next, struct perf_evsel, node);
+	leader->leader = NULL;
+
+	list_for_each_entry(evsel, list, node)
+		if (evsel != leader)
+			evsel->leader = leader;
+
+	return leader;
 }
 
-void parse_events__group(char *name __used, struct list_head *list __used)
+int parse_events__modifier_group(struct list_head *list,
+				 char *event_mod)
 {
+	return parse_events__modifier_event(list, event_mod);
+}
+
+void parse_events__group(char *name, struct list_head *list)
+{
+	struct perf_evsel *leader;
+
+	leader = parse_events__group_leader(list);
+	leader->group_name = name ? strdup(name) : NULL;
 }
 
 void parse_events_update_lists(struct list_head *list_event,
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index c2f2ed9..fdbc72a 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -92,6 +92,7 @@ int parse_events_add_breakpoint(struct list_head **list, int *idx,
 				void *ptr, char *type);
 int parse_events_add_pmu(struct list_head **list, int *idx,
 			 char *pmu , struct list_head *head_config);
+struct perf_evsel *parse_events__group_leader(struct list_head *list);
 void parse_events__group(char *name, struct list_head *list);
 void parse_events_update_lists(struct list_head *list_event,
 			       struct list_head *list_all);
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

