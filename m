Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2BMHM1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 02:12:27 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49008 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755197Ab2BMHLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 02:11:37 -0500
X-AuditID: 9c930197-b7cdbae000001518-8b-4f38b7a4c80b
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Namhyung Kim <namhyung@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 11/11] perf record: Fix event grouping on forked task
Date: Mon, 13 Feb 2012 16:27:43 +0900
Message-Id: <1329118064-9412-12-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
References: <1329118064-9412-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When event group is enabled for forked task (i.e. no target task/cpu
was specified) all events were disabled and marked ->enable_on_exec.
However they wouldn't be counted at all since only group leader will
be enabled on exec actually.

In contrast to perf stat, perf record doesn't have a real problem
as it enables all the event before proceeding. But it needs to be
fixed anyway IMHO.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-test.c   |    2 +-
 tools/perf/util/evlist.c    |    5 +++--
 tools/perf/util/evlist.h    |    3 ++-
 tools/perf/util/evsel.c     |    5 +++--
 tools/perf/util/evsel.h     |    3 ++-
 6 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index fbf71edd31ba..a65b0a5a81ea 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -183,7 +183,7 @@ static void perf_record__open(struct perf_record *rec)
 
 	first = list_entry(evlist->entries.next, struct perf_evsel, node);
 
-	perf_evlist__config_attrs(evlist, opts);
+	perf_evlist__config_attrs(evlist, opts, first);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 91a6eba000f2..b72b12aedd29 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1083,7 +1083,7 @@ static int test__PERF_RECORD(void)
 	evsel->attr.sample_type |= PERF_SAMPLE_CPU;
 	evsel->attr.sample_type |= PERF_SAMPLE_TID;
 	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
-	perf_evlist__config_attrs(evlist, &opts);
+	perf_evlist__config_attrs(evlist, &opts, evsel);
 
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
 					    &cpu_mask_size);
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index aa0418034d82..7ab81906c1aa 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -49,7 +49,8 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 }
 
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts)
+			       struct perf_record_opts *opts,
+			       struct perf_evsel *first)
 {
 	struct perf_evsel *evsel;
 
@@ -57,7 +58,7 @@ void perf_evlist__config_attrs(struct perf_evlist *evlist,
 		opts->no_inherit = true;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		perf_evsel__config(evsel, opts);
+		perf_evsel__config(evsel, opts, first);
 
 		if (evlist->nr_entries > 1)
 			evsel->attr.sample_type |= PERF_SAMPLE_ID;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 7e99ac513893..7ebb6419e8d0 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -81,7 +81,8 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 int perf_evlist__open(struct perf_evlist *evlist, bool group);
 
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts);
+			       struct perf_record_opts *opts,
+			       struct perf_evsel *first);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_record_opts *opts,
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index e7ddf27f240b..cb5c18b66d06 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -63,7 +63,8 @@ struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 	return evsel;
 }
 
-void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
+void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts,
+			struct perf_evsel *first)
 {
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
@@ -130,7 +131,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (no_target_maps(&opts->maps)) {
+	if (no_target_maps(&opts->maps) && (!opts->group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 326b8e4d5035..3158ca3d69a1 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -80,7 +80,8 @@ void perf_evsel__exit(struct perf_evsel *evsel);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 void perf_evsel__config(struct perf_evsel *evsel,
-			struct perf_record_opts *opts);
+			struct perf_record_opts *opts,
+			struct perf_evsel *first);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads);
-- 
1.7.9

