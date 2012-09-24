Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab2IXQAF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 12:00:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58686 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755650Ab2IXP76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:59:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 08/30] perf kmem: Use perf_evsel__intval and perf_session__set_tracepoints_handlers
Date: Mon, 24 Sep 2012 12:59:22 -0300
Message-Id: <1348502384-14442-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1348502384-14442-1-git-send-email-acme@infradead.org>
References: <1348502384-14442-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Following the model of 'perf sched':

. raw_field_value searches first on the common fields, that are unused
  in this tool

. Using perf_session__set_tracepoints_handlers will save all those
  strcmp to find the right handler at sample processing time, do it just
  once and get the handler from evsel->handler.func.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-v9x3q9rv4caxtox7wtjpchq5@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c |   90 ++++++++++++++++++++++----------------------
 1 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index f5f8a6b..bc912c6 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -1,6 +1,7 @@
 #include "builtin.h"
 #include "perf.h"
 
+#include "util/evlist.h"
 #include "util/evsel.h"
 #include "util/util.h"
 #include "util/cache.h"
@@ -212,36 +213,38 @@ static int insert_caller_stat(unsigned long call_site,
 }
 
 static int perf_evsel__process_alloc_event(struct perf_evsel *evsel,
-					   struct perf_sample *sample, int node)
+					   struct perf_sample *sample)
 {
-	struct event_format *event = evsel->tp_format;
-	void *data = sample->raw_data;
-	unsigned long call_site;
-	unsigned long ptr;
-	int bytes_req, cpu = sample->cpu;
-	int bytes_alloc;
-	int node1, node2;
-
-	ptr = raw_field_value(event, "ptr", data);
-	call_site = raw_field_value(event, "call_site", data);
-	bytes_req = raw_field_value(event, "bytes_req", data);
-	bytes_alloc = raw_field_value(event, "bytes_alloc", data);
-
-	if (insert_alloc_stat(call_site, ptr, bytes_req, bytes_alloc, cpu) ||
+	unsigned long ptr = perf_evsel__intval(evsel, sample, "ptr"),
+		      call_site = perf_evsel__intval(evsel, sample, "call_site");
+	int bytes_req = perf_evsel__intval(evsel, sample, "bytes_req"),
+	    bytes_alloc = perf_evsel__intval(evsel, sample, "bytes_alloc");
+
+	if (insert_alloc_stat(call_site, ptr, bytes_req, bytes_alloc, sample->cpu) ||
 	    insert_caller_stat(call_site, bytes_req, bytes_alloc))
 		return -1;
 
 	total_requested += bytes_req;
 	total_allocated += bytes_alloc;
 
-	if (node) {
-		node1 = cpunode_map[cpu];
-		node2 = raw_field_value(event, "node", data);
+	nr_allocs++;
+	return 0;
+}
+
+static int perf_evsel__process_alloc_node_event(struct perf_evsel *evsel,
+						struct perf_sample *sample)
+{
+	int ret = perf_evsel__process_alloc_event(evsel, sample);
+
+	if (!ret) {
+		int node1 = cpunode_map[sample->cpu],
+		    node2 = perf_evsel__intval(evsel, sample, "node");
+
 		if (node1 != node2)
 			nr_cross_allocs++;
 	}
-	nr_allocs++;
-	return 0;
+
+	return ret;
 }
 
 static int ptr_cmp(struct alloc_stat *, struct alloc_stat *);
@@ -275,8 +278,7 @@ static struct alloc_stat *search_alloc_stat(unsigned long ptr,
 static int perf_evsel__process_free_event(struct perf_evsel *evsel,
 					  struct perf_sample *sample)
 {
-	unsigned long ptr = raw_field_value(evsel->tp_format, "ptr",
-					    sample->raw_data);
+	unsigned long ptr = perf_evsel__intval(evsel, sample, "ptr");
 	struct alloc_stat *s_alloc, *s_caller;
 
 	s_alloc = search_alloc_stat(ptr, 0, &root_alloc_stat, ptr_cmp);
@@ -297,28 +299,8 @@ static int perf_evsel__process_free_event(struct perf_evsel *evsel,
 	return 0;
 }
 
-static int perf_evsel__process_kmem_event(struct perf_evsel *evsel,
-					  struct perf_sample *sample)
-{
-	struct event_format *event = evsel->tp_format;
-
-	if (!strcmp(event->name, "kmalloc") ||
-	    !strcmp(event->name, "kmem_cache_alloc")) {
-		return perf_evsel__process_alloc_event(evsel, sample, 0);
-	}
-
-	if (!strcmp(event->name, "kmalloc_node") ||
-	    !strcmp(event->name, "kmem_cache_alloc_node")) {
-		return perf_evsel__process_alloc_event(evsel, sample, 1);
-	}
-
-	if (!strcmp(event->name, "kfree") ||
-	    !strcmp(event->name, "kmem_cache_free")) {
-		return perf_evsel__process_free_event(evsel, sample);
-	}
-
-	return 0;
-}
+typedef int (*tracepoint_handler)(struct perf_evsel *evsel,
+				  struct perf_sample *sample);
 
 static int process_sample_event(struct perf_tool *tool __maybe_unused,
 				union perf_event *event,
@@ -336,7 +318,12 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 
 	dump_printf(" ... thread: %s:%d\n", thread->comm, thread->pid);
 
-	return perf_evsel__process_kmem_event(evsel, sample);
+	if (evsel->handler.func != NULL) {
+		tracepoint_handler f = evsel->handler.func;
+		return f(evsel, sample);
+	}
+
+	return 0;
 }
 
 static struct perf_tool perf_kmem = {
@@ -498,6 +485,14 @@ static int __cmd_kmem(void)
 {
 	int err = -EINVAL;
 	struct perf_session *session;
+	const struct perf_evsel_str_handler kmem_tracepoints[] = {
+		{ "kmem:kmalloc",		perf_evsel__process_alloc_event, },
+    		{ "kmem:kmem_cache_alloc",	perf_evsel__process_alloc_event, },
+		{ "kmem:kmalloc_node",		perf_evsel__process_alloc_node_event, },
+    		{ "kmem:kmem_cache_alloc_node", perf_evsel__process_alloc_node_event, },
+		{ "kmem:kfree",			perf_evsel__process_free_event, },
+    		{ "kmem:kmem_cache_free",	perf_evsel__process_free_event, },
+	};
 
 	session = perf_session__new(input_name, O_RDONLY, 0, false, &perf_kmem);
 	if (session == NULL)
@@ -509,6 +504,11 @@ static int __cmd_kmem(void)
 	if (!perf_session__has_traces(session, "kmem record"))
 		goto out_delete;
 
+	if (perf_session__set_tracepoints_handlers(session, kmem_tracepoints)) {
+		pr_err("Initializing perf session tracepoint handlers failed\n");
+		return -1;
+	}
+
 	setup_pager();
 	err = perf_session__process_events(session, &perf_kmem);
 	if (err != 0)
-- 
1.7.1

