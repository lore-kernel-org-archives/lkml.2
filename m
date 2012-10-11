Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754220Ab2JKE0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 00:26:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43466 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753537Ab2JKEZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 00:25:58 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, peterz@infradead.org, fweisbec@gmail.com,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 8/9] perf stat: move to perf_evlist__open_counters
Date: Wed, 10 Oct 2012 22:25:34 -0600
Message-Id: <1349929535-92861-9-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
References: <1349929535-92861-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes a lot of duplicated code moving to the common
open method.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
---
 tools/perf/builtin-stat.c |  103 ++++++++++-----------------------------------
 1 file changed, 22 insertions(+), 81 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9727d217..affbada 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -122,55 +122,6 @@ static struct stats runtime_itlb_cache_stats[MAX_NR_CPUS];
 static struct stats runtime_dtlb_cache_stats[MAX_NR_CPUS];
 static struct stats walltime_nsecs_stats;
 
-static int create_perf_stat_counter(struct perf_evsel *evsel,
-				    struct perf_evsel *first,
-				    struct perf_record_opts *opts)
-{
-	struct perf_target *target = &opts->target;
-	struct perf_event_attr *attr = &evsel->attr;
-	bool exclude_guest_missing = false;
-	int ret;
-
-	if (scale)
-		attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
-				    PERF_FORMAT_TOTAL_TIME_RUNNING;
-
-	attr->inherit = !opts->no_inherit;
-
-retry:
-	if (exclude_guest_missing)
-		evsel->attr.exclude_guest = evsel->attr.exclude_host = 0;
-
-	if (perf_target__has_cpu(target)) {
-		ret = perf_evsel__open_per_cpu(evsel,
-					       perf_evsel__cpus(evsel, target));
-		if (ret)
-			goto check_ret;
-		return 0;
-	}
-
-	if (!perf_target__has_task(target) &&
-	    (!opts->group || evsel == first)) {
-		attr->disabled = 1;
-		attr->enable_on_exec = 1;
-	}
-
-	ret = perf_evsel__open_per_thread(evsel, evsel_list->threads);
-	if (!ret)
-		return 0;
-	/* fall through */
-check_ret:
-	if (ret && errno == EINVAL) {
-		if (!exclude_guest_missing &&
-		    (evsel->attr.exclude_guest || evsel->attr.exclude_host)) {
-			pr_debug("Old kernel, cannot exclude "
-				 "guest or host samples.\n");
-			exclude_guest_missing = true;
-			goto retry;
-		}
-	}
-	return ret;
-}
 
 /*
  * Does the counter have nsecs as a unit?
@@ -277,6 +228,7 @@ static int run_perf_stat(int argc __maybe_unused,
 	unsigned long long t0, t1;
 	struct perf_evsel *counter, *first;
 	struct cpu_map *cmap;
+	struct perf_target *target = &opts->target;
 	int status = 0;
 	int child_ready_pipe[2], go_pipe[2];
 	const bool forks = (argc > 0);
@@ -320,7 +272,7 @@ static int run_perf_stat(int argc __maybe_unused,
 			exit(-1);
 		}
 
-		if (perf_target__none(&opts->target))
+		if (perf_target__none(target))
 			evsel_list->threads->map[0] = child_pid;
 
 		/*
@@ -339,38 +291,27 @@ static int run_perf_stat(int argc __maybe_unused,
 	first = perf_evlist__first(evsel_list);
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
-		if (create_perf_stat_counter(counter, first, opts) < 0) {
-			/*
-			 * PPC returns ENXIO for HW counters until 2.6.37
-			 * (behavior changed with commit b0a873e).
-			 */
-			if (errno == EINVAL || errno == ENOSYS ||
-			    errno == ENOENT || errno == EOPNOTSUPP ||
-			    errno == ENXIO) {
-				if (verbose)
-					ui__warning("%s event is not supported by the kernel.\n",
-						    perf_evsel__name(counter));
-				counter->supported = false;
-				continue;
-			}
-
-			if (errno == EPERM || errno == EACCES) {
-				error("You may not have permission to collect %sstats.\n"
-				      "\t Consider tweaking"
-				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
-				      opts->target.system_wide ? "system-wide " : "");
-			} else {
-				error("open_counter returned with %d (%s). "
-				      "/bin/dmesg may provide additional information.\n",
-				       errno, strerror(errno));
-			}
-			if (child_pid != -1)
-				kill(child_pid, SIGTERM);
-
-			pr_err("Not all events could be opened.\n");
-			return -1;
+		struct perf_event_attr *attr = &counter->attr;
+
+		if (scale)
+			attr->read_format = PERF_FORMAT_TOTAL_TIME_ENABLED |
+					    PERF_FORMAT_TOTAL_TIME_RUNNING;
+
+		attr->inherit = !opts->no_inherit;
+
+		if (perf_target__none(target) &&
+		    (!opts->group || counter == first)) {
+			attr->disabled = 1;
+			attr->enable_on_exec = 1;
 		}
-		counter->supported = true;
+	}
+
+	if (perf_evlist__open_counters(evsel_list, opts, true) != 0) {
+		if (child_pid != -1)
+			kill(child_pid, SIGTERM);
+
+		pr_err("Not all events could be opened.\n");
+		return -1;
 	}
 
 	if (perf_evlist__apply_filters(evsel_list)) {
-- 
1.7.10.1

