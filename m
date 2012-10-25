Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760211Ab2JYTsa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:48:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:59174 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab2JYTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:48:27 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/3] perf trace: Count number of events for each thread and globally
Date: Thu, 25 Oct 2012 17:47:44 -0200
Message-Id: <1351194465-29083-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1351194465-29083-1-git-send-email-acme@infradead.org>
References: <1351194465-29083-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The nr_events in trace__run was local, but we will need it in other
trace methods, move it to struct trace.

We'll also need the number of events per thread, so introduce a
nr_events method for that in struct thread_trace.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ksutaz0mtejnf7e6az3ca1td@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   20 ++++++++++++++------
 1 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index ba05510..c95a3e9 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -67,6 +67,7 @@ struct thread_trace {
 	u64		  entry_time;
 	u64		  exit_time;
 	bool		  entry_pending;
+	unsigned long	  nr_events;
 	char		  *entry_str;
 };
 
@@ -77,16 +78,21 @@ static struct thread_trace *thread_trace__new(void)
 
 static struct thread_trace *thread__trace(struct thread *thread)
 {
+	struct thread_trace *ttrace;
+
 	if (thread == NULL)
 		goto fail;
 
 	if (thread->priv == NULL)
 		thread->priv = thread_trace__new();
-
+		
 	if (thread->priv == NULL)
 		goto fail;
 
-	return thread->priv;
+	ttrace = thread->priv;
+	++ttrace->nr_events;
+
+	return ttrace;
 fail:
 	color_fprintf(stdout, PERF_COLOR_RED,
 		      "WARNING: not enough memory, dropping samples!\n");
@@ -102,6 +108,7 @@ struct trace {
 	struct perf_record_opts opts;
 	struct machine		host;
 	u64			base_time;
+	unsigned long		nr_events;
 	bool			multiple_threads;
 	double			duration_filter;
 };
@@ -386,7 +393,8 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 {
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
 	struct perf_evsel *evsel;
-	int err = -1, i, nr_events = 0, before;
+	int err = -1, i;
+	unsigned long before;
 	const bool forks = argc > 0;
 
 	if (evlist == NULL) {
@@ -444,7 +452,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 
 	trace->multiple_threads = evlist->threads->map[0] == -1 || evlist->threads->nr > 1;
 again:
-	before = nr_events;
+	before = trace->nr_events;
 
 	for (i = 0; i < evlist->nr_mmaps; i++) {
 		union perf_event *event;
@@ -454,7 +462,7 @@ again:
 			tracepoint_handler handler;
 			struct perf_sample sample;
 
-			++nr_events;
+			++trace->nr_events;
 
 			err = perf_evlist__parse_sample(evlist, event, &sample);
 			if (err) {
@@ -495,7 +503,7 @@ again:
 		}
 	}
 
-	if (nr_events == before) {
+	if (trace->nr_events == before) {
 		if (done)
 			goto out_delete_evlist;
 
-- 
1.7.1

