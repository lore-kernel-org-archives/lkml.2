Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243Ab2HUPWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:22:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59657 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755488Ab2HUPWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:22:13 -0400
Date: Tue, 21 Aug 2012 08:21:41 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-p936ngz06yo5h797ggsm7xru@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        avagin@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        avagin@gmail.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kmem: Use evsel->tp_format and perf_sample
Git-Commit-ID: 22ad798c37cb554afae79a72c1d420ecb4d27b86
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:21:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  22ad798c37cb554afae79a72c1d420ecb4d27b86
Gitweb:     http://git.kernel.org/tip/22ad798c37cb554afae79a72c1d420ecb4d27b86
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 7 Aug 2012 10:56:43 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 7 Aug 2012 23:44:20 -0300

perf kmem: Use evsel->tp_format and perf_sample

To reduce the number of parameters passed to the various event handling
functions.

Cc: Andrey Wagin <avagin@gmail.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-p936ngz06yo5h797ggsm7xru@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |   41 +++++++++++++++++------------------------
 1 files changed, 17 insertions(+), 24 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index ffb93f4..fc6607b 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -192,16 +192,15 @@ static void insert_caller_stat(unsigned long call_site,
 	}
 }
 
-static void process_alloc_event(void *data,
-				struct event_format *event,
-				int cpu,
-				u64 timestamp __used,
-				struct thread *thread __used,
-				int node)
+static void perf_evsel__process_alloc_event(struct perf_evsel *evsel,
+					    struct perf_sample *sample,
+					    int node)
 {
+	struct event_format *event = evsel->tp_format;
+	void *data = sample->raw_data;
 	unsigned long call_site;
 	unsigned long ptr;
-	int bytes_req;
+	int bytes_req, cpu = sample->cpu;
 	int bytes_alloc;
 	int node1, node2;
 
@@ -253,22 +252,18 @@ static struct alloc_stat *search_alloc_stat(unsigned long ptr,
 	return NULL;
 }
 
-static void process_free_event(void *data,
-			       struct event_format *event,
-			       int cpu,
-			       u64 timestamp __used,
-			       struct thread *thread __used)
+static void perf_evsel__process_free_event(struct perf_evsel *evsel,
+					   struct perf_sample *sample)
 {
-	unsigned long ptr;
+	unsigned long ptr = raw_field_value(evsel->tp_format, "ptr",
+					    sample->raw_data);
 	struct alloc_stat *s_alloc, *s_caller;
 
-	ptr = raw_field_value(event, "ptr", data);
-
 	s_alloc = search_alloc_stat(ptr, 0, &root_alloc_stat, ptr_cmp);
 	if (!s_alloc)
 		return;
 
-	if (cpu != s_alloc->alloc_cpu) {
+	if ((short)sample->cpu != s_alloc->alloc_cpu) {
 		s_alloc->pingpong++;
 
 		s_caller = search_alloc_stat(0, s_alloc->call_site,
@@ -279,26 +274,26 @@ static void process_free_event(void *data,
 	s_alloc->alloc_cpu = -1;
 }
 
-static void process_raw_event(struct perf_evsel *evsel, void *data,
-			      int cpu, u64 timestamp, struct thread *thread)
+static void perf_evsel__process_kmem_event(struct perf_evsel *evsel,
+					   struct perf_sample *sample)
 {
 	struct event_format *event = evsel->tp_format;
 
 	if (!strcmp(event->name, "kmalloc") ||
 	    !strcmp(event->name, "kmem_cache_alloc")) {
-		process_alloc_event(data, event, cpu, timestamp, thread, 0);
+		perf_evsel__process_alloc_event(evsel, sample, 0);
 		return;
 	}
 
 	if (!strcmp(event->name, "kmalloc_node") ||
 	    !strcmp(event->name, "kmem_cache_alloc_node")) {
-		process_alloc_event(data, event, cpu, timestamp, thread, 1);
+		perf_evsel__process_alloc_event(evsel, sample, 1);
 		return;
 	}
 
 	if (!strcmp(event->name, "kfree") ||
 	    !strcmp(event->name, "kmem_cache_free")) {
-		process_free_event(data, event, cpu, timestamp, thread);
+		perf_evsel__process_free_event(evsel, sample);
 		return;
 	}
 }
@@ -319,9 +314,7 @@ static int process_sample_event(struct perf_tool *tool __used,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	process_raw_event(evsel, sample->raw_data, sample->cpu,
-			  sample->time, thread);
-
+	perf_evsel__process_kmem_event(evsel, sample);
 	return 0;
 }
 
