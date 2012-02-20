Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab2BTBrP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 20:47:15 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64601 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751893Ab2BTBq5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 20:46:57 -0500
X-AuditID: 9c930197-b7cdbae000001518-12-4f41a60db473
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] perf tools: Do not disable members of group event
Date: Mon, 20 Feb 2012 11:04:58 +0900
Message-Id: <1329703498-25192-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329703498-25192-1-git-send-email-namhyung.kim@lge.com>
References: <1329703498-25192-1-git-send-email-namhyung.kim@lge.com>
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
 tools/perf/util/evlist.c |    6 ++++--
 tools/perf/util/evsel.c  |    6 ++++--
 tools/perf/util/evsel.h  |    3 ++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index f8da9fada002..ec4e338ee291 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -51,13 +51,15 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 void perf_evlist__config_attrs(struct perf_evlist *evlist,
 			       struct perf_record_opts *opts)
 {
-	struct perf_evsel *evsel;
+	struct perf_evsel *evsel, *first;
 
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
+	first = list_entry(evlist->entries.next, struct perf_evsel, node);
+
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		perf_evsel__config(evsel, opts);
+		perf_evsel__config(evsel, opts, first);
 
 		if (evlist->nr_entries > 1)
 			evsel->attr.sample_type |= PERF_SAMPLE_ID;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 302d49a9f985..c92693c3d108 100644
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
@@ -130,7 +131,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (!opts->target_pid && !opts->target_tid && !opts->system_wide) {
+	if (!opts->target_pid && !opts->target_tid && !opts->system_wide &&
+	    (!opts->group || evsel == first)) {
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

