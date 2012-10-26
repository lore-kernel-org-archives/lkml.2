Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab2JZIzj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:55:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51631 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932162Ab2JZIzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:55:33 -0400
Date: Fri, 26 Oct 2012 01:55:10 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ksutaz0mtejnf7e6az3ca1td@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace:
  Count number of events for each thread and globally
Git-Commit-ID: efd5745e43f3aabd95d521289e0caa0e30668cf4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 01:55:16 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  efd5745e43f3aabd95d521289e0caa0e30668cf4
Gitweb:     http://git.kernel.org/tip/efd5745e43f3aabd95d521289e0caa0e30668cf4
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 17 Oct 2012 17:09:46 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 25 Oct 2012 10:40:37 -0200

perf trace: Count number of events for each thread and globally

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
 
