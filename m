Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab1AGPcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 10:32:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:54855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753896Ab1AGPcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 10:32:00 -0500
Date: Fri, 7 Jan 2011 15:31:31 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, peterz@infradead.org, fweisbec@gmail.com,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, peterz@infradead.org,
        ming.m.lin@intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1294369869.20563.19.camel@minggr.sh.intel.com>
References: <1294369869.20563.19.camel@minggr.sh.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Pass whole attr to event selectors
Message-ID: <tip-23a2f3ab46596d9fd0b0e592d2101bea90970594@git.kernel.org>
Git-Commit-ID: 23a2f3ab46596d9fd0b0e592d2101bea90970594
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 07 Jan 2011 15:31:32 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  23a2f3ab46596d9fd0b0e592d2101bea90970594
Gitweb:     http://git.kernel.org/tip/23a2f3ab46596d9fd0b0e592d2101bea90970594
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 7 Jan 2011 11:11:09 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 7 Jan 2011 01:44:36 -0200

perf tools: Pass whole attr to event selectors

Since commit 69aad6f1(perf tools: Introduce event selectors), only
perf_event_attr::type and ::config are passed to event selector, which
makes perf tool not work correctly.

For example, PEBS does not work because perf_event_attr::precise_ip is
not passed to the syscall.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <1294369869.20563.19.camel@minggr.sh.intel.com>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c      |    3 +--
 tools/perf/builtin-test.c      |    6 +++++-
 tools/perf/util/evsel.c        |    5 ++---
 tools/perf/util/evsel.h        |    2 +-
 tools/perf/util/parse-events.c |   13 ++++++++++---
 5 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 02b2d80..2dfcb61 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -683,8 +683,7 @@ int cmd_stat(int argc, const char **argv, const char *prefix __used)
 		nr_counters = ARRAY_SIZE(default_attrs);
 
 		for (c = 0; c < ARRAY_SIZE(default_attrs); ++c) {
-			pos = perf_evsel__new(default_attrs[c].type,
-					      default_attrs[c].config,
+			pos = perf_evsel__new(&default_attrs[c],
 					      nr_counters);
 			if (pos == NULL)
 				goto out;
diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 1c98434..e12753f 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -264,6 +264,7 @@ static int test__open_syscall_event(void)
 	int err = -1, fd;
 	struct thread_map *threads;
 	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
 	unsigned int nr_open_calls = 111, i;
 	int id = trace_event__id("sys_enter_open");
 
@@ -278,7 +279,10 @@ static int test__open_syscall_event(void)
 		return -1;
 	}
 
-	evsel = perf_evsel__new(PERF_TYPE_TRACEPOINT, id, 0);
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
 		goto out_thread_map_delete;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c95267e..1a5591d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -6,14 +6,13 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 
-struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx)
+struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx)
 {
 	struct perf_evsel *evsel = zalloc(sizeof(*evsel));
 
 	if (evsel != NULL) {
 		evsel->idx	   = idx;
-		evsel->attr.type   = type;
-		evsel->attr.config = config;
+		evsel->attr	   = *attr;
 		INIT_LIST_HEAD(&evsel->node);
 	}
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index a0ccd69..b2d755f 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -37,7 +37,7 @@ struct perf_evsel {
 struct cpu_map;
 struct thread_map;
 
-struct perf_evsel *perf_evsel__new(u32 type, u64 config, int idx);
+struct perf_evsel *perf_evsel__new(struct perf_event_attr *attr, int idx);
 void perf_evsel__delete(struct perf_evsel *evsel);
 
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 917a0ca..5cb6f4b 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -823,7 +823,7 @@ int parse_events(const struct option *opt __used, const char *str, int unset __u
 
 		if (ret != EVT_HANDLED_ALL) {
 			struct perf_evsel *evsel;
-			evsel = perf_evsel__new(attr.type, attr.config,
+			evsel = perf_evsel__new(&attr,
 						nr_counters);
 			if (evsel == NULL)
 				return -1;
@@ -1013,8 +1013,15 @@ void print_events(void)
 
 int perf_evsel_list__create_default(void)
 {
-	struct perf_evsel *evsel = perf_evsel__new(PERF_TYPE_HARDWARE,
-						   PERF_COUNT_HW_CPU_CYCLES, 0);
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_HARDWARE;
+	attr.config = PERF_COUNT_HW_CPU_CYCLES;
+
+	evsel = perf_evsel__new(&attr, 0);
+
 	if (evsel == NULL)
 		return -ENOMEM;
 
