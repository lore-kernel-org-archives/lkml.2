Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717Ab2JEI5s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 04:57:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32886 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754572Ab2JEI5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 04:57:45 -0400
Date: Fri, 5 Oct 2012 01:57:20 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-4z90i79gnmsza2czv2dhdrb7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evlist: Introduce add_newtp method
Git-Commit-ID: 39876e7dd385e0f0a438ee0ab13cf75a4f5e0e3b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 05 Oct 2012 01:57:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  39876e7dd385e0f0a438ee0ab13cf75a4f5e0e3b
Gitweb:     http://git.kernel.org/tip/39876e7dd385e0f0a438ee0ab13cf75a4f5e0e3b
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 3 Oct 2012 11:40:22 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 3 Oct 2012 11:41:22 -0300

perf evlist: Introduce add_newtp method

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
