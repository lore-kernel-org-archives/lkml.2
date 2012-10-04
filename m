Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415Ab2JDSYk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 14:24:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:39664 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab2JDSI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 14:08:58 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/42] perf trace: Use evsel->handler.func
Date: Thu,  4 Oct 2012 15:08:09 -0300
Message-Id: <1349374122-27806-10-git-send-email-acme@infradead.org>
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

I.e. we don't need to resolve the evsel via the id and then check if it
is this or that event, just stash the right handler at evsel creation
time, then use evsel->handler.func() straight away.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bpz3axzr4f2cjppf4egm28wf@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |  132 +++++++++++++++++++++++++++++---------------
 1 files changed, 87 insertions(+), 45 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 8f113da..76b1202 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -114,10 +114,85 @@ static size_t syscall__fprintf_args(struct syscall *sc, unsigned long *args, FIL
 	return printed;
 }
 
+typedef int (*tracepoint_handler)(struct trace *trace, struct perf_evsel *evsel,
+				  struct perf_sample *sample);
+
+static struct syscall *trace__syscall_info(struct trace *trace,
+					   struct perf_evsel *evsel,
+					   struct perf_sample *sample)
+{
+	int id = perf_evsel__intval(evsel, sample, "id");
+
+	if (id < 0) {
+		printf("Invalid syscall %d id, skipping...\n", id);
+		return NULL;
+	}
+
+	if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL) &&
+	    trace__read_syscall_info(trace, id))
+		goto out_cant_read;
+
+	if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL))
+		goto out_cant_read;
+
+	return &trace->syscalls.table[id];
+
+out_cant_read:
+	printf("Problems reading syscall %d information\n", id);
+	return NULL;
+}
+
+static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
+			    struct perf_sample *sample)
+{
+	void *args;
+	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+
+	if (sc == NULL)
+		return -1;
+
+	args = perf_evsel__rawptr(evsel, sample, "args");
+	if (args == NULL) {
+		printf("Problems reading syscall arguments\n");
+		return -1;
+	}
+
+	printf("%s(", sc->name);
+	syscall__fprintf_args(sc, args, stdout);
+
+	return 0;
+}
+
+static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
+			   struct perf_sample *sample)
+{
+	int ret;
+	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+
+	if (sc == NULL)
+		return -1;
+
+	ret = perf_evsel__intval(evsel, sample, "ret");
+
+	if (ret < 0 && sc->fmt && sc->fmt->errmsg) {
+		char bf[256];
+		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
+			   *e = audit_errno_to_name(-ret);
+
+		printf(") = -1 %s %s", e, emsg);
+	} else if (ret == 0 && sc->fmt && sc->fmt->timeout)
+		printf(") = 0 Timeout");
+	else
+		printf(") = %d", ret);
+
+	putchar('\n');
+	return 0;
+}
+
 static int trace__run(struct trace *trace)
 {
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
-	struct perf_evsel *evsel, *evsel_enter, *evsel_exit;
+	struct perf_evsel *evsel;
 	int err = -1, i, nr_events = 0, before;
 
 	if (evlist == NULL) {
@@ -125,21 +200,23 @@ static int trace__run(struct trace *trace)
 		goto out;
 	}
 
-	evsel_enter = perf_evsel__newtp("raw_syscalls", "sys_enter", 0);
-	if (evsel_enter == NULL) {
+	evsel = perf_evsel__newtp("raw_syscalls", "sys_enter", 0);
+	if (evsel == NULL) {
 		printf("Couldn't read the raw_syscalls:sys_enter tracepoint information!\n");
 		goto out_delete_evlist;
 	}
 
-	perf_evlist__add(evlist, evsel_enter);
+	evsel->handler.func = trace__sys_enter;
+	perf_evlist__add(evlist, evsel);
 
-	evsel_exit = perf_evsel__newtp("raw_syscalls", "sys_exit", 1);
-	if (evsel_exit == NULL) {
+	evsel = perf_evsel__newtp("raw_syscalls", "sys_exit", 1);
+	if (evsel == NULL) {
 		printf("Couldn't read the raw_syscalls:sys_exit tracepoint information!\n");
 		goto out_delete_evlist;
 	}
 
-	perf_evlist__add(evlist, evsel_exit);
+	evsel->handler.func = trace__sys_exit;
+	perf_evlist__add(evlist, evsel);
 
 	err = perf_evlist__create_maps(evlist, &trace->opts.target);
 	if (err < 0) {
@@ -170,9 +247,8 @@ again:
 
 		while ((event = perf_evlist__mmap_read(evlist, i)) != NULL) {
 			const u32 type = event->header.type;
-			struct syscall *sc;
+			tracepoint_handler handler;
 			struct perf_sample sample;
-			int id;
 
 			++nr_events;
 
@@ -200,45 +276,11 @@ again:
 				continue;
 			}
 
-			id = perf_evsel__intval(evsel, &sample, "id");
-			if (id < 0) {
-				printf("Invalid syscall %d id, skipping...\n", id);
-				continue;
-			}
-
-			if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL) &&
-			    trace__read_syscall_info(trace, id))
-				continue;
-
-			if ((id > trace->syscalls.max || trace->syscalls.table[id].name == NULL))
-				continue;
-
-			sc = &trace->syscalls.table[id];
-
 			if (evlist->threads->map[0] == -1 || evlist->threads->nr > 1)
 				printf("%d ", sample.tid);
 
-			if (evsel == evsel_enter) {
-				void *args = perf_evsel__rawptr(evsel, &sample, "args");
-
-				printf("%s(", sc->name);
-				syscall__fprintf_args(sc, args, stdout);
-			} else if (evsel == evsel_exit) {
-				int ret = perf_evsel__intval(evsel, &sample, "ret");
-
-				if (ret < 0 && sc->fmt && sc->fmt->errmsg) {
-					char bf[256];
-					const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
-						   *e = audit_errno_to_name(-ret);
-
-					printf(") = -1 %s %s", e, emsg);
-				} else if (ret == 0 && sc->fmt && sc->fmt->timeout)
-					printf(") = 0 Timeout");
-				else
-					printf(") = %d", ret);
-
-				putchar('\n');
-			}
+			handler = evsel->handler.func;
+			handler(trace, evsel, &sample);
 		}
 	}
 
-- 
1.7.1

