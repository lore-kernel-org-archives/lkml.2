Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987Ab2IJHy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:54:26 -0400
Received: from mga03.intel.com ([143.182.124.21]:38569 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab2IJHyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:54:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,396,1344236400"; 
   d="scan'208";a="190784714"
From: "Yan, Zheng" <zheng.z.yan@intel.com>
To: eranian@google.com, a.p.zijlstra@chello.nl, mingo@elte.hu,
        andi@firstfloor.org, jolsa@redhat.com, linux-kernel@vger.kernel.org
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>
Subject: [RFC PATCH 3/3] perf tool: Allow wildcard in PMU name
Date: Mon, 10 Sep 2012 15:53:51 +0800
Message-Id: <1347263631-23175-4-git-send-email-zheng.z.yan@intel.com>
X-Mailer: git-send-email 1.7.11.4
In-Reply-To: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
References: <1347263631-23175-1-git-send-email-zheng.z.yan@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Yan, Zheng" <zheng.z.yan@intel.com>

Allow wildcard in PMU name, so we can measure events on all
uncore boxes of same type. For example:

Signed-off-by: Yan, Zheng <zheng.z.yan@intel.com>
---
 tools/perf/builtin-stat.c      |   8 ++-
 tools/perf/util/evsel.c        |  31 ++++++++--
 tools/perf/util/evsel.h        |   2 +
 tools/perf/util/parse-events.c | 126 ++++++++++++++++++++++++++++++-----------
 4 files changed, 128 insertions(+), 39 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index acdfd24..bebfd8c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -557,7 +557,8 @@ static int run_perf_stat(int argc __used, const char **argv)
 		}
 	} else {
 		list_for_each_entry(counter, &evsel_list->entries, node) {
-			read_counter_aggr(counter);
+			if (!counter->aggr_slave)
+				read_counter_aggr(counter);
 			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
 					     evsel_list->threads->nr);
 		}
@@ -1023,8 +1024,11 @@ static void print_stat(int argc, const char **argv)
 		list_for_each_entry(counter, &evsel_list->entries, node)
 			print_counter(counter);
 	} else {
-		list_for_each_entry(counter, &evsel_list->entries, node)
+		list_for_each_entry(counter, &evsel_list->entries, node) {
+			if (counter->aggr_slave)
+				continue;
 			print_counter_aggr(counter);
+		}
 	}
 
 	if (!csv_output) {
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 7ff3c8f..b99b892 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -54,6 +54,7 @@ void perf_evsel__init(struct perf_evsel *evsel,
 	evsel->idx	   = idx;
 	evsel->attr	   = *attr;
 	INIT_LIST_HEAD(&evsel->node);
+	INIT_LIST_HEAD(&evsel->sibling);
 	hists__init(&evsel->hists);
 	evsel->sample_size = __perf_evsel__sample_size(attr->sample_type);
 }
@@ -525,14 +526,13 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	return 0;
 }
 
-int __perf_evsel__read(struct perf_evsel *evsel,
-		       int ncpus, int nthreads, bool scale)
+static int read_evsel(struct perf_counts_values *aggr,
+		      struct perf_evsel *evsel,
+		      int ncpus, int nthreads, bool scale)
 {
+	struct perf_counts_values count;
 	size_t nv = scale ? 3 : 1;
 	int cpu, thread;
-	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
-
-	aggr->val = aggr->ena = aggr->run = 0;
 
 	for (cpu = 0; cpu < ncpus; cpu++) {
 		for (thread = 0; thread < nthreads; thread++) {
@@ -550,6 +550,27 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 			}
 		}
 	}
+	return 0;
+}
+
+int __perf_evsel__read(struct perf_evsel *evsel,
+		       int ncpus, int nthreads, bool scale)
+{
+	int ret;
+	struct perf_counts_values *aggr = &evsel->counts->aggr;
+	struct perf_evsel *child;
+
+	aggr->val = aggr->ena = aggr->run = 0;
+
+	ret = read_evsel(aggr, evsel, ncpus, nthreads, scale);
+	if (ret)
+		return ret;
+
+	list_for_each_entry(child, &evsel->sibling, node) {
+		ret = read_evsel(aggr, evsel, ncpus, nthreads, scale);
+		if (ret)
+			return ret;
+	}
 
 	evsel->counts->scaled = 0;
 	if (scale) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 956c0a0..bcb5a8a 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -46,6 +46,7 @@ struct perf_sample_id {
  */
 struct perf_evsel {
 	struct list_head	node;
+	struct list_head	sibling;
 	struct perf_event_attr	attr;
 	char			*filter;
 	struct xyarray		*fd;
@@ -69,6 +70,7 @@ struct perf_evsel {
 	struct cpu_map		*cpus;
 	unsigned int		sample_size;
 	bool 			supported;
+	bool			aggr_slave;
 	/* parse modifier helper */
 	int			exclude_GH;
 	struct perf_evsel	*leader;
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3aa9be4..32288f2 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -239,14 +239,40 @@ const char *event_type(int type)
 	return "unknown";
 }
 
+static void free_event_list(struct list_head *list)
+{
+	struct perf_evsel *evsel;
 
+	while (!list_empty(list)) {
+		evsel = list_entry(list->next, struct perf_evsel, node);
+		list_del(&evsel->node);
+		perf_evsel__delete(evsel);
+	}
+	free(list);
+}
 
-static int __add_event(struct list_head **_list, int *idx,
-		       struct perf_event_attr *attr,
-		       char *name, struct cpu_map *cpus)
+static struct perf_evsel *__add_event(int *idx, struct perf_event_attr *attr,
+				      char *name, struct cpu_map *cpus)
 {
 	struct perf_evsel *evsel;
+
+	event_attr_init(attr);
+
+	evsel = perf_evsel__new(attr, (*idx)++);
+	if (!evsel)
+		return NULL;
+
+	evsel->cpus = cpus;
+	if (name)
+		evsel->name = strdup(name);
+	return evsel;
+}
+
+static int add_event(struct list_head **_list, int *idx,
+		     struct perf_event_attr *attr, char *name)
+{
 	struct list_head *list = *_list;
+	struct perf_evsel *evsel;
 
 	if (!list) {
 		list = malloc(sizeof(*list));
@@ -255,28 +281,17 @@ static int __add_event(struct list_head **_list, int *idx,
 		INIT_LIST_HEAD(list);
 	}
 
-	event_attr_init(attr);
-
-	evsel = perf_evsel__new(attr, (*idx)++);
+	evsel = __add_event(idx, attr, name, NULL);
 	if (!evsel) {
 		free(list);
 		return -ENOMEM;
 	}
 
-	evsel->cpus = cpus;
-	if (name)
-		evsel->name = strdup(name);
 	list_add_tail(&evsel->node, list);
 	*_list = list;
 	return 0;
 }
 
-static int add_event(struct list_head **_list, int *idx,
-		     struct perf_event_attr *attr, char *name)
-{
-	return __add_event(_list, idx, attr, name, NULL);
-}
-
 static int parse_aliases(char *str, const char *names[][PERF_EVSEL__MAX_ALIASES], int size)
 {
 	int i, j;
@@ -593,32 +608,79 @@ static char *pmu_event_name(struct list_head *head_terms)
 	return NULL;
 }
 
-int parse_events_add_pmu(struct list_head **list, int *idx,
+static int pmu_name_match(char *name, char *pattern)
+{
+	int idx;
+	char *c;
+
+	if (!strcasecmp(name, pattern))
+		return 0;
+
+	c = strchr(pattern, '*');
+	if (!c || c[1] != '\0')
+		return 1;
+
+	idx = c - pattern;
+	if (strncasecmp(name, pattern, idx))
+		return 1;
+
+	for (; name[idx]; idx++) {
+		if (name[idx] < '0' || name[idx] > '9')
+			return 1;
+	}
+	return 0;
+}
+
+int parse_events_add_pmu(struct list_head **_list, int *idx,
 			 char *name, struct list_head *head_config)
 {
 	struct perf_event_attr attr;
-	struct perf_pmu *pmu;
+	struct list_head *list;
+	struct perf_pmu *pmu = NULL;
+	struct perf_evsel *evsel, *first = NULL;
+	int orig_idx = *idx;
 
-	pmu = perf_pmu__find(name);
-	if (!pmu)
-		return -EINVAL;
+	list = malloc(sizeof(*list));
+	if (!list)
+		return -ENOMEM;
+	INIT_LIST_HEAD(list);
 
-	memset(&attr, 0, sizeof(attr));
+	while ((pmu = perf_pmu__scan(pmu))) {
+		if (pmu_name_match(pmu->name, name))
+			continue;
 
-	if (perf_pmu__check_alias(pmu, head_config))
-		return -EINVAL;
+		memset(&attr, 0, sizeof(attr));
 
-	/*
-	 * Configure hardcoded terms first, no need to check
-	 * return value when called with fail == 0 ;)
-	 */
-	config_attr(&attr, head_config, 0);
+		if (perf_pmu__check_alias(pmu, head_config))
+			return -EINVAL;
 
-	if (perf_pmu__config(pmu, &attr, head_config))
-		return -EINVAL;
+		/*
+		 * Configure hardcoded terms first, no need to check
+		 * return value when called with fail == 0 ;)
+		 */
+		config_attr(&attr, head_config, 0);
+
+		if (perf_pmu__config(pmu, &attr, head_config))
+			return -EINVAL;
 
-	return __add_event(list, idx, &attr, pmu_event_name(head_config),
-			   pmu->cpus);
+		evsel = __add_event(idx, &attr, pmu_event_name(head_config),
+				    pmu->cpus);
+		if (!evsel) {
+			*idx = orig_idx;
+			free_event_list(list);
+			return -ENOMEM;
+		}
+		list_add_tail(&evsel->node, list);
+		if (first) {
+			list_add_tail(&evsel->sibling, &first->sibling);
+			evsel->aggr_slave = true;
+		} else {
+			first = evsel;
+		}
+	}
+
+	*_list = list;
+	return 0;
 }
 
 int parse_events__modifier_group(struct list_head *list,
-- 
1.7.11.4

