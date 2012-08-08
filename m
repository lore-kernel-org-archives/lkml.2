Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757269Ab2HHDVN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:21:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:34520 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab2HHDVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:21:10 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andrey Wagin <avagin@gmail.com>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf kmem: Use evsel->tp_format and perf_sample
Date: Wed,  8 Aug 2012 00:20:54 -0300
Message-Id: <1344396057-10540-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1344396057-10540-1-git-send-email-acme@infradead.org>
References: <1344396057-10540-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

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
 1 file changed, 17 insertions(+), 24 deletions(-)

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
 
-- 
1.7.9.2.358.g22243

