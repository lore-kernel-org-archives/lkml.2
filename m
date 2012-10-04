Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab2JDSMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:12:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:39818 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865Ab2JDSJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:09:35 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 31/42] perf evlist: Introduce add_newtp method
Date: Thu,  4 Oct 2012 15:08:31 -0300
Message-Id: <1349374122-27806-32-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349374122-27806-1-git-send-email-acme@infradead.org>
References: <1349374122-27806-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

To reduce the boilerplate of creating and adding a new tracepoint to an
evlist.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-4z90i79gnmsza2czv2dhdrb7@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   18 +++---------------
 tools/perf/util/evlist.c   |   14 ++++++++++++++
 tools/perf/util/evlist.h   |    3 +++
 3 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 76b1202..dec8ced 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -200,24 +200,12 @@ static int trace__run(struct trace *trace)
 		goto out;
 	}
 
-	evsel = perf_evsel__newtp("raw_syscalls", "sys_enter", 0);
-	if (evsel == NULL) {
-		printf("Couldn't read the raw_syscalls:sys_enter tracepoint information!\n");
+	if (perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_enter", trace__sys_enter) ||
+	    perf_evlist__add_newtp(evlist, "raw_syscalls", "sys_exit", trace__sys_exit)) {
+		printf("Couldn't read the raw_syscalls tracepoints information!\n");
 		goto out_delete_evlist;
 	}
 
-	evsel->handler.func = trace__sys_enter;
-	perf_evlist__add(evlist, evsel);
-
-	evsel = perf_evsel__newtp("raw_syscalls", "sys_exit", 1);
-	if (evsel == NULL) {
-		printf("Couldn't read the raw_syscalls:sys_exit tracepoint information!\n");
-		goto out_delete_evlist;
-	}
-
-	evsel->handler.func = trace__sys_exit;
-	perf_evlist__add(evlist, evsel);
-
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
 		printf("Problems parsing the target to trace, check your options!\n");
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index ae89686..6a2809f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -285,6 +285,20 @@ out:
 	return err;
 }
 
+int perf_evlist__add_newtp(struct perf_evlist *evlist,
+			   const char *sys, const char *name, void *handler)
+{
+	struct perf_evsel *evsel;
+
+	evsel = perf_evsel__newtp(sys, name, evlist->nr_entries);
+	if (evsel == NULL)
+		return -1;
+
+	evsel->handler.func = handler;
+	perf_evlist__add(evlist, evsel);
+	return 0;
+}
+
 void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 3f1fb66..ac98b01 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -72,6 +72,9 @@ int perf_evlist__set_tracepoints_handlers(struct perf_evlist *evlist,
 #define perf_evlist__set_tracepoints_handlers_array(evlist, array) \
 	perf_evlist__set_tracepoints_handlers(evlist, array, ARRAY_SIZE(array))
 
+int perf_evlist__add_newtp(struct perf_evlist *evlist,
+			   const char *sys, const char *name, void *handler);
+
 int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter);
 
 struct perf_evsel *
-- 
1.7.1

