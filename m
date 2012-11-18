Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592Ab2KROfB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:35:01 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36571 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162Ab2KROaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/32] perf tools: Fix attributes for '{}' defined event groups
Date: Sun, 18 Nov 2012 11:29:43 -0300
Message-Id: <1353248997-30763-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Fixing events attributes for groups defined via '{}'.

Currently 'enable_on_exec' attribute in record command and both
'disabled ' and 'enable_on_exec' attributes in stat command are set
based on the 'group' option. This eliminates proper setup for '{}'
defined groups as they don't set 'group' option.

Making above attributes values based on the 'evsel->leader' as this is
common to both group definition.

Moving perf_evlist__set_leader call within builtin-record ahead
perf_evlist__config_attrs call, because the latter needs possible group
leader links in place.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352741644-16809-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c               |    8 ++++++--
 tools/perf/builtin-stat.c                 |   11 ++++-------
 tools/perf/tests/attr/test-record-group1  |    4 +---
 tools/perf/tests/attr/test-stat-group1    |    6 ++----
 tools/perf/tests/open-syscall-tp-fields.c |    2 +-
 tools/perf/util/evlist.c                  |    6 ++----
 tools/perf/util/evsel.c                   |    8 +++-----
 tools/perf/util/evsel.h                   |    3 +--
 8 files changed, 20 insertions(+), 28 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 5783c32..3717027 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -230,11 +230,15 @@ static int perf_record__open(struct perf_record *rec)
 	struct perf_record_opts *opts = &rec->opts;
 	int rc = 0;
 
-	perf_evlist__config_attrs(evlist, opts);
-
+	/*
+	 * Set the evsel leader links before we configure attributes,
+	 * since some might depend on this info.
+	 */
 	if (opts->group)
 		perf_evlist__set_leader(evlist);
 
+	perf_evlist__config_attrs(evlist, opts);
+
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
 		/*
diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 6888960..557081e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -129,8 +129,7 @@ static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
 
-static int create_perf_stat_counter(struct perf_evsel *evsel,
-				    struct perf_evsel *first)
+static int create_perf_stat_counter(struct perf_evsel *evsel)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	bool exclude_guest_missing = false;
@@ -153,7 +152,7 @@ retry:
 		return 0;
 	}
 
-	if (!perf_target__has_task(&target) && (!group || evsel == first)) {
+	if (!perf_target__has_task(&target) && (!evsel->leader)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
@@ -272,7 +271,7 @@ static int read_counter(struct perf_evsel *counter)
 static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 {
 	unsigned long long t0, t1;
-	struct perf_evsel *counter, *first;
+	struct perf_evsel *counter;
 	int status = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
@@ -332,10 +331,8 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 	if (group)
 		perf_evlist__set_leader(evsel_list);
 
-	first = perf_evlist__first(evsel_list);
-
 	list_for_each_entry(counter, &evsel_list->entries, node) {
-		if (create_perf_stat_counter(counter, first) < 0) {
+		if (create_perf_stat_counter(counter) < 0) {
 			/*
 			 * PPC returns ENXIO for HW counters until 2.6.37
 			 * (behavior changed with commit b0a873e).
diff --git a/tools/perf/tests/attr/test-record-group1 b/tools/perf/tests/attr/test-record-group1
index 39bf860..013572f 100644
--- a/tools/perf/tests/attr/test-record-group1
+++ b/tools/perf/tests/attr/test-record-group1
@@ -15,6 +15,4 @@ config=1
 sample_type=327
 mmap=0
 comm=0
-# TODO this is disabled for --group option, enabled otherwise
-#      check why..
-enable_on_exec=1
+enable_on_exec=0
diff --git a/tools/perf/tests/attr/test-stat-group1 b/tools/perf/tests/attr/test-stat-group1
index 5ae2718..2a1f86e 100644
--- a/tools/perf/tests/attr/test-stat-group1
+++ b/tools/perf/tests/attr/test-stat-group1
@@ -11,7 +11,5 @@ group_fd=-1
 fd=2
 group_fd=1
 config=1
-# TODO both disabled and enable_on_exec are disabled for --group option,
-#      enabled otherwise, check why..
-disabled=1
-enable_on_exec=1
+disabled=0
+enable_on_exec=0
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index b05b6a6..1c52fdc 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -41,7 +41,7 @@ int test__syscall_open_tp_fields(void)
 		goto out_delete_evlist;
 	}
 
-	perf_evsel__config(evsel, &opts, evsel);
+	perf_evsel__config(evsel, &opts);
 
 	evlist->threads->map[0] = getpid();
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a41dc4a..04acae0 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -52,15 +52,13 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts)
 {
-	struct perf_evsel *evsel, *first;
+	struct perf_evsel *evsel;
 
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
-	first = perf_evlist__first(evlist);
-
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		perf_evsel__config(evsel, opts, first);
+		perf_evsel__config(evsel, opts);
 
 		if (evlist->nr_entries > 1)
 			evsel->attr.sample_type |= PERF_SAMPLE_ID;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 618d411..6d4a5f6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -404,8 +404,8 @@ const char *perf_evsel__name(struct perf_evsel *evsel)
 	return evsel->name ?: "unknown";
 }
 
-void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
-			struct perf_evsel *first)
+void perf_evsel__config(struct perf_evsel *evsel,
+			struct perf_record_opts *opts)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
@@ -486,10 +486,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (perf_target__none(&opts->target) &&
-	    (!opts->group || evsel == first)) {
+	if (perf_target__none(&opts->target) && (!evsel->leader))
 		attr->enable_on_exec = 1;
-	}
 }
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6f94d6d..32d7ec7 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -92,8 +92,7 @@ void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 void perf_evsel__config(struct perf_evsel *evsel,
-			struct perf_record_opts *opts,
-			struct perf_evsel *first);
+			struct perf_record_opts *opts);
 
 bool perf_evsel__is_cache_op_valid(u8 type, u8 op);
 
-- 
1.7.9.2.358.g22243

