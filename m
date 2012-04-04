Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab2DDVQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 17:16:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8414 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753384Ab2DDVQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 17:16:52 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, andi@firstfloor.org,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 8/8] perf, tool: Enable sampling on specified event group leader
Date: Wed,  4 Apr 2012 23:16:16 +0200
Message-Id: <1333574176-11388-9-git-send-email-jolsa@redhat.com>
In-Reply-To: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
References: <1333574176-11388-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the functionality to 'group:modifier=...' event syntax.
Allowing user to select an event out of the defined group by
event index ( = event order placement in the group).

This selected event becomes group leader and will be the
only one which be sampling.

The rest of the events counts are being read on each leader
sample by PERF_SAMPLE_READ sample type.

Following example:
  perf record -e group:1=cycles,faults ls

  - creates a group with 'cycles' and 'faults' events
  - 'cycles' event is group leader and has sampling enabled
  - 'faults' event is read each time 'cycles' sample,
    the 'faults' count is attached to the 'cycles sample
    via PERF_SAMPLE_READ sample type.

It is possible to display the data by 'perf report -D' command.
For each sample the PERF_SAMPLE_READ data are displayed if it's
included. More sophisticated output comming shortly.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c            |   63 ++++++++++++++++++++++++++++------
 tools/perf/util/evlist.h            |    3 +-
 tools/perf/util/evsel.c             |   18 +++++++++-
 tools/perf/util/evsel.h             |    6 ++--
 tools/perf/util/parse-events-test.c |   20 +++++++----
 tools/perf/util/parse-events.c      |    5 +--
 6 files changed, 88 insertions(+), 27 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bd48bb3..b0d5038 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -48,18 +48,27 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 	return evlist;
 }
 
+static void update_leader_sample(struct perf_evlist *evlist)
+{
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		if (evsel->leader_sample)
+			evlist->leader_sample = true;
+}
+
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts)
 {
-	struct perf_evsel *evsel, *first;
+	struct perf_evsel *evsel;
+
+	update_leader_sample(evlist);
 
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
-	first = list_entry(evlist->entries.next, struct perf_evsel, node);
-
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		perf_evsel__config(evsel, opts, first);
+		perf_evsel__config(evlist, evsel, opts);
 
 		if (evlist->nr_entries > 1)
 			evsel->attr.sample_type |= PERF_SAMPLE_ID;
@@ -107,15 +116,48 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 	evlist->nr_entries += nr_entries;
 }
 
-void perf_evlist__group_list(struct list_head *list)
+static struct perf_evsel* get_evsel_nth_list(struct list_head *list, int n)
 {
-	struct perf_evsel *evsel, *first;
+	struct perf_evsel *evsel;
+	int i = 1;
 
-	first = list_entry(list->next, struct perf_evsel, node);
+	list_for_each_entry(evsel, list, node)
+		if (i++ == n)
+			return evsel;
+
+	return NULL;
+}
+
+int perf_evlist__group_list(struct list_head *list, int leader_sample)
+{
+	struct perf_evsel *evsel, *leader;
+
+	if (leader_sample) {
+		leader = get_evsel_nth_list(list, leader_sample);
+		if (!leader) {
+			fprintf(stderr,
+				"failed: leader number out of bounds\n");
+			return -EINVAL;
+		}
+
+		leader->leader_sample = true;
+
+		/*
+		 * Make the leader first in the list, because we need it
+		 * to be opened first, so we can use its fd for group fd.
+		 */
+		if (leader_sample != 1) {
+			list_del(&leader->node);
+			list_add(&leader->node, list);
+		}
+	} else
+		leader = list_entry(list->next, struct perf_evsel, node);
 
 	list_for_each_entry(evsel, list, node)
-		if (evsel != first)
-			evsel->leader = first;
+		if (evsel != leader)
+			evsel->leader = leader;
+
+	return 0;
 }
 
 int perf_evlist__group(struct perf_evlist *evlist)
@@ -123,8 +165,7 @@ int perf_evlist__group(struct perf_evlist *evlist)
 	if (!evlist->nr_entries)
 		return -EINVAL;
 
-	perf_evlist__group_list(&evlist->entries);
-	return 0;
+	return perf_evlist__group_list(&evlist->entries, 0);
 }
 
 int perf_evlist__add_default(struct perf_evlist *evlist)
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index c2fe77b..6fb380c 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -28,6 +28,7 @@ struct perf_evlist {
 		pid_t	pid;
 	} workload;
 	bool		 overwrite;
+	bool		 leader_sample;
 	union perf_event event_copy;
 	struct perf_mmap *mmap;
 	struct pollfd	 *pollfd;
@@ -124,7 +125,7 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries);
 
-void perf_evlist__group_list(struct list_head *list);
+int perf_evlist__group_list(struct list_head *list, int leader_sample);
 int perf_evlist__group(struct perf_evlist *evlist);
 
 #endif /* __PERF_EVLIST_H */
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 42f5256..0e0756a 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -62,18 +62,27 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
-void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
-			struct perf_evsel *first)
+void perf_evsel__config(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			struct perf_record_opts *opts)
 {
+	struct perf_evsel *first, *leader = evsel->leader;
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	attr->sample_id_all = opts->sample_id_all_missing ? 0 : 1;
 	attr->inherit	    = !opts->no_inherit;
 	attr->read_format   = PERF_FORMAT_TOTAL_TIME_ENABLED |
 			      PERF_FORMAT_TOTAL_TIME_RUNNING |
 			      PERF_FORMAT_ID;
 
+	if (evlist->leader_sample) {
+		attr->read_format |= PERF_FORMAT_GROUP;
+		attr->sample_type |= PERF_SAMPLE_READ;
+		attr->inherit = 0;
+	}
+
 	attr->sample_type  |= PERF_SAMPLE_IP | PERF_SAMPLE_TID;
 
 	/*
@@ -91,6 +100,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 		}
 	}
 
+	if (leader && leader->leader_sample) {
+		attr->sample_freq   = 0;
+		attr->sample_period = 0;
+	}
+
 	if (opts->no_samples)
 		attr->sample_freq = 0;
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index e749d5c..e40c5ff 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -67,6 +67,7 @@ struct perf_evsel {
 	} handler;
 	bool 			supported;
 	struct perf_evsel	*leader;
+	bool			leader_sample;
 };
 
 struct cpu_map;
@@ -80,9 +81,8 @@ void perf_evsel__init(struct perf_evsel *evsel,
 void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
-void perf_evsel__config(struct perf_evsel *evsel,
-			struct perf_record_opts *opts,
-			struct perf_evsel *first);
+void perf_evsel__config(struct perf_evlist *evlist, struct perf_evsel *evsel,
+			struct perf_record_opts *opts);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
diff --git a/tools/perf/util/parse-events-test.c b/tools/perf/util/parse-events-test.c
index c2f7bd1..15a8c4d 100644
--- a/tools/perf/util/parse-events-test.c
+++ b/tools/perf/util/parse-events-test.c
@@ -490,22 +490,28 @@ static int test__checkevent_group_mod(struct perf_evlist *evlist)
 
 	TEST_ASSERT_VAL("wrong number of entries", 2 == evlist->nr_entries);
 
-	/* cycles */
+	/*
+	 * With modifier :2 we have 'faults leading the list
+	 * and being the leader
+	 */
+
+	/* faults */
 	evsel = leader = list_entry(evlist->entries.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
+			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == NULL);
 
-	/* faults */
+	/* cycles */
 	evsel = list_entry(evsel->node.next, struct perf_evsel, node);
-	TEST_ASSERT_VAL("wrong type", PERF_TYPE_SOFTWARE == evsel->attr.type);
+	TEST_ASSERT_VAL("wrong type", PERF_TYPE_HARDWARE == evsel->attr.type);
 	TEST_ASSERT_VAL("wrong config",
-			PERF_COUNT_SW_PAGE_FAULTS == evsel->attr.config);
+			PERF_COUNT_HW_CPU_CYCLES == evsel->attr.config);
 	TEST_ASSERT_VAL("wrong leader", evsel->leader == leader);
 
 	return 0;
 }
+
 static struct test__event_st {
 	const char *name;
 	__u32 type;
@@ -624,7 +630,7 @@ static struct test__event_st {
 		.check = test__checkevent_group,
 	},
 	[28] = {
-		.name  = "group:1=cycles,faults",
+		.name  = "group:2=cycles,faults",
 		.check = test__checkevent_group_mod,
 	},
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index d7812bd..afec4d0 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -791,10 +791,9 @@ int parse_events_add_pmu(struct list_head **list, int *idx,
 	return add_event(list, idx, &attr, name);
 }
 
-int parse_events__group(struct list_head *list, int mod __used)
+int parse_events__group(struct list_head *list, int leader_sample)
 {
-	perf_evlist__group_list(list);
-	return 0;
+	return perf_evlist__group_list(list, leader_sample);
 }
 
 void parse_events_update_lists(struct list_head *list_event,
-- 
1.7.7.6

