Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441Ab2LKWyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 17:54:24 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53839
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755212Ab2LKWsm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 17:48:42 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 31/37] perf evlist: Set the leader in the perf_evlist__config method
Date: Tue, 11 Dec 2012 19:48:17 -0300
Message-Id: <1355266103-17238-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1355266103-17238-1-git-send-email-acme@infradead.org>
References: <1355266103-17238-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Since we need to ensure the leader is set before configuring the
evsel perf_event_attrs.

Reducing the boilerplate needed by tools, helping, for instance,
'perf trace', that wasn't setting the leader.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-22shm0ptkch2kgl7rtqlligx@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c    |    9 +--------
 tools/perf/builtin-trace.c     |    2 +-
 tools/perf/tests/perf-record.c |    2 +-
 tools/perf/util/evlist.c       |   10 ++++++++--
 tools/perf/util/evlist.h       |    4 ++--
 5 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 0be6605..fc4f080 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -230,14 +230,7 @@ static int perf_record__open(struct perf_record *rec)
 	struct perf_record_opts *opts = &rec->opts;
 	int rc = 0;
 
-	/*
-	 * Set the evsel leader links before we configure attributes,
-	 * since some might depend on this info.
-	 */
-	if (opts->group)
-		perf_evlist__set_leader(evlist);
-
-	perf_evlist__config_attrs(evlist, opts);
+	perf_evlist__config(evlist, opts);
 
 	list_for_each_entry(pos, &evlist->entries, node) {
 		struct perf_event_attr *attr = &pos->attr;
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 7932ffa..d222d7f 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -455,7 +455,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out_delete_evlist;
 	}
 
-	perf_evlist__config_attrs(evlist, &trace->opts);
+	perf_evlist__config(evlist, &trace->opts);
 
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
diff --git a/tools/perf/tests/perf-record.c b/tools/perf/tests/perf-record.c
index 5902772..6ea66cf 100644
--- a/tools/perf/tests/perf-record.c
+++ b/tools/perf/tests/perf-record.c
@@ -106,7 +106,7 @@ int test__PERF_RECORD(void)
 	perf_evsel__set_sample_bit(evsel, CPU);
 	perf_evsel__set_sample_bit(evsel, TID);
 	perf_evsel__set_sample_bit(evsel, TIME);
-	perf_evlist__config_attrs(evlist, &opts);
+	perf_evlist__config(evlist, &opts);
 
 	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 5a0878d..dc8aee9 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -49,10 +49,16 @@ struct perf_evlist *perf_evlist__new(struct cpu_map *cpus,
 	return evlist;
 }
 
-void perf_evlist__config_attrs(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts)
+void perf_evlist__config(struct perf_evlist *evlist,
+			struct perf_record_opts *opts)
 {
 	struct perf_evsel *evsel;
+	/*
+	 * Set the evsel leader links before we configure attributes,
+	 * since some might depend on this info.
+	 */
+	if (opts->group)
+		perf_evlist__set_leader(evlist);
 
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 56003f7..457e235 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -76,8 +76,8 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *self, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
 
-void perf_evlist__config_attrs(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts);
+void perf_evlist__config(struct perf_evlist *evlist,
+			 struct perf_record_opts *opts);
 
 int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 				  struct perf_record_opts *opts,
-- 
1.7.9.2.358.g22243

