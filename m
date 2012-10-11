Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab2JKE0u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:26:50 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:36790 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab2JKEZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:25:57 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 7/9] perf evlist: add stat unique code to open_counters method
Date: Wed, 10 Oct 2012 22:25:33 -0600
Message-Id: <1349929535-92861-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
References: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mainly the addition is an argument to keep going for some open
failures.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-record.c |    2 +-
 tools/perf/builtin-top.c    |    2 +-
 tools/perf/util/evlist.c    |   16 ++++++++++++++--
 tools/perf/util/evlist.h    |    3 ++-
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index b9dcc01..663ccc8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -234,7 +234,7 @@ static int perf_record__open(struct perf_record *rec)
 	if (opts->group)
 		perf_evlist__set_leader(evlist);
 
-	rc = perf_evlist__open_counters(evlist, opts);
+	rc = perf_evlist__open_counters(evlist, opts, false);
 	if (rc != 0)
 			goto out;
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2ffc32e..2c3b3c7 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -921,7 +921,7 @@ static void perf_top__start_counters(struct perf_top *top)
 		attr->inherit = !top->opts.no_inherit;
 	}
 
-	if (perf_evlist__open_counters(evlist, &top->opts) != 0)
+	if (perf_evlist__open_counters(evlist, &top->opts, false) != 0)
 		goto out_err;
 
 	if (perf_evlist__mmap(evlist, top->opts.mmap_pages, false) < 0) {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bce2f58..fa0daac 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -840,7 +840,8 @@ size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp)
 }
 
 int perf_evlist__open_counters(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts)
+			       struct perf_record_opts *opts,
+			       bool continue_on_fail)
 {
 	struct perf_evsel *pos;
 	int rc = 0;
@@ -872,6 +873,16 @@ try_again:
 		if (perf_evsel__open(pos, evlist->cpus, evlist->threads) < 0) {
 			int err = errno;
 
+			if (continue_on_fail &&
+			    (err == EINVAL || err == ENOSYS || err == ENXIO ||
+			     err == ENOENT || err == EOPNOTSUPP)) {
+				if (verbose)
+					ui__warning("%s event is not supported by the kernel.\n",
+						    perf_evsel__name(pos));
+				pos->supported = false;
+				continue;
+			}
+
 			if (err == EPERM || err == EACCES) {
 				ui__error_paranoid();
 				rc = -err;
@@ -958,7 +969,8 @@ try_again:
 			pr_err("No CONFIG_PERF_EVENTS=y kernel support configured?\n");
 			rc = -err;
 			goto out;
-		}
+		} else
+			pos->supported = true;
 	}
 out:
 	return rc;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 270e546..0747b6f 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -137,5 +137,6 @@ static inline struct perf_evsel *perf_evlist__last(struct perf_evlist *evlist)
 size_t perf_evlist__fprintf(struct perf_evlist *evlist, FILE *fp);
 
 int perf_evlist__open_counters(struct perf_evlist *evlist,
-			       struct perf_record_opts *opts);
+			       struct perf_record_opts *opts,
+			       bool continue_on_fail);
 #endif /* __PERF_EVLIST_H */
-- 
1.7.10.1

