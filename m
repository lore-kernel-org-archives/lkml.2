Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161351Ab2CPUDf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 16:03:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:41802 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932618Ab2CPUC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 16:02:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/13] perf tools: Do not disable members of group event
Date: Fri, 16 Mar 2012 17:02:05 -0300
Message-Id: <1331928130-16243-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1331928130-16243-1-git-send-email-acme@infradead.org>
References: <1331928130-16243-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

When event group is enabled for forked task (i.e. no target task/cpu
was specified) all events were disabled and marked ->enable_on_exec.
However they wouldn't be counted at all since only group leader will
be enabled on exec actually.

In contrast to perf stat, perf record doesn't have a real problem
as it enables all the event before proceeding. But it needs to be
fixed anyway IMHO.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1331887340-32448-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c |    6 ++++--
 tools/perf/util/evsel.c  |    6 ++++--
 tools/perf/util/evsel.h  |    3 ++-
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 159263d..1986d80 100644
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
index f421f7c..0221700 100644
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
@@ -134,7 +135,8 @@ void perf_evsel__config(struct perf_evsel *evsel, struct perf_record_opts *opts)
 	attr->mmap = track;
 	attr->comm = track;
 
-	if (!opts->target_pid && !opts->target_tid && !opts->system_wide) {
+	if (!opts->target_pid && !opts->target_tid && !opts->system_wide &&
+	    (!opts->group || evsel == first)) {
 		attr->disabled = 1;
 		attr->enable_on_exec = 1;
 	}
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 326b8e4..3158ca3 100644
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
1.7.9.2.358.g22243

