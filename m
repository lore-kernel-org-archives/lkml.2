Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755388Ab2JHWfg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 18:35:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:41429 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932097Ab2JHWdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 18:33:37 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 14/25] perf event: No need to create a thread when handling PERF_RECORD_EXIT
Date: Mon,  8 Oct 2012 19:32:39 -0300
Message-Id: <1349735570-19339-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1349735570-19339-1-git-send-email-acme@infradead.org>
References: <1349735570-19339-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

When we were processing a PERF_RECORD_EXIT event we first used
machine__findnew_thread for both the thread exiting and for its parent,
only to use just the thread struct associated with the one exiting, and
to just delete it.

If it existed, i.e. not created at this very moment in
machine__findnew_thread, it will be moved to the machine->dead_threads
linked list, because we may have hist_entries pointing to it, but if it
was created just do be deleted, it will just sit there with no
references at all.

Use the new machine__find_thread() method so that if it is not there, we
don't create it.

As a bonus the parent thread will also not be created at this point.

Create process_fork() and process_exit() helpers to use this and make
the builtins use it instead of the generic process_task(), ditched by
this patch.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-z7n2y98ebjyrvmytaope4vdl@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |    2 +-
 tools/perf/builtin-diff.c     |    4 ++--
 tools/perf/builtin-inject.c   |    6 +++---
 tools/perf/builtin-report.c   |    4 ++--
 tools/perf/builtin-sched.c    |    2 +-
 tools/perf/builtin-script.c   |    4 ++--
 tools/perf/util/build-id.c    |    2 +-
 tools/perf/util/event.c       |   30 ++++++++++++++++++++++--------
 tools/perf/util/event.h       |    6 +++++-
 9 files changed, 39 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 9ea3854..cca2fb5 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -246,7 +246,7 @@ int cmd_annotate(int argc, const char **argv, const char *prefix __maybe_unused)
 			.sample	= process_sample_event,
 			.mmap	= perf_event__process_mmap,
 			.comm	= perf_event__process_comm,
-			.fork	= perf_event__process_task,
+			.fork	= perf_event__process_fork,
 			.ordered_samples = true,
 			.ordering_requires_timestamps = true,
 		},
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index b4db513..380683d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -285,8 +285,8 @@ static struct perf_tool tool = {
 	.sample	= diff__process_sample_event,
 	.mmap	= perf_event__process_mmap,
 	.comm	= perf_event__process_comm,
-	.exit	= perf_event__process_task,
-	.fork	= perf_event__process_task,
+	.exit	= perf_event__process_exit,
+	.fork	= perf_event__process_fork,
 	.lost	= perf_event__process_lost,
 	.ordered_samples = true,
 	.ordering_requires_timestamps = true,
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 4688bea..386a5c0 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -102,14 +102,14 @@ static int perf_event__repipe_mmap(struct perf_tool *tool,
 	return err;
 }
 
-static int perf_event__repipe_task(struct perf_tool *tool,
+static int perf_event__repipe_fork(struct perf_tool *tool,
 				   union perf_event *event,
 				   struct perf_sample *sample,
 				   struct machine *machine)
 {
 	int err;
 
-	err = perf_event__process_task(tool, event, sample, machine);
+	err = perf_event__process_fork(tool, event, sample, machine);
 	perf_event__repipe(tool, event, sample, machine);
 
 	return err;
@@ -227,7 +227,7 @@ static int __cmd_inject(struct perf_inject *inject)
 	if (inject->build_ids) {
 		inject->tool.sample	  = perf_event__inject_buildid;
 		inject->tool.mmap	  = perf_event__repipe_mmap;
-		inject->tool.fork	  = perf_event__repipe_task;
+		inject->tool.fork	  = perf_event__repipe_fork;
 		inject->tool.tracing_data = perf_event__repipe_tracing_data;
 	}
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a61725d..5104a40 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -556,8 +556,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 			.sample		 = process_sample_event,
 			.mmap		 = perf_event__process_mmap,
 			.comm		 = perf_event__process_comm,
-			.exit		 = perf_event__process_task,
-			.fork		 = perf_event__process_task,
+			.exit		 = perf_event__process_exit,
+			.fork		 = perf_event__process_fork,
 			.lost		 = perf_event__process_lost,
 			.read		 = process_read_event,
 			.attr		 = perf_event__process_attr,
diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 3488ead..3a25cd8 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1672,7 +1672,7 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 			.sample		 = perf_sched__process_tracepoint_sample,
 			.comm		 = perf_event__process_comm,
 			.lost		 = perf_event__process_lost,
-			.fork		 = perf_event__process_task,
+			.fork		 = perf_event__process_fork,
 			.ordered_samples = true,
 		},
 		.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index fb96250..04ceb07 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -520,8 +520,8 @@ static struct perf_tool perf_script = {
 	.sample		 = process_sample_event,
 	.mmap		 = perf_event__process_mmap,
 	.comm		 = perf_event__process_comm,
-	.exit		 = perf_event__process_task,
-	.fork		 = perf_event__process_task,
+	.exit		 = perf_event__process_exit,
+	.fork		 = perf_event__process_fork,
 	.attr		 = perf_event__process_attr,
 	.event_type	 = perf_event__process_event_type,
 	.tracing_data	 = perf_event__process_tracing_data,
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 8e3a740..6a63999 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -64,7 +64,7 @@ static int perf_event__exit_del_thread(struct perf_tool *tool __maybe_unused,
 struct perf_tool build_id__mark_dso_hit_ops = {
 	.sample	= build_id__mark_dso_hit,
 	.mmap	= perf_event__process_mmap,
-	.fork	= perf_event__process_task,
+	.fork	= perf_event__process_fork,
 	.exit	= perf_event__exit_del_thread,
 	.attr		 = perf_event__process_attr,
 	.build_id	 = perf_event__process_build_id,
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 6715b19..eaaee22 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -1,6 +1,7 @@
 #include <linux/types.h>
 #include "event.h"
 #include "debug.h"
+#include "machine.h"
 #include "sort.h"
 #include "string.h"
 #include "strlist.h"
@@ -702,10 +703,10 @@ size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 		       event->fork.ppid, event->fork.ptid);
 }
 
-int perf_event__process_task(struct perf_tool *tool __maybe_unused,
+int perf_event__process_fork(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
 			     struct perf_sample *sample __maybe_unused,
-			      struct machine *machine)
+			     struct machine *machine)
 {
 	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
@@ -713,11 +714,6 @@ int perf_event__process_task(struct perf_tool *tool __maybe_unused,
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
 
-	if (event->header.type == PERF_RECORD_EXIT) {
-		machine__remove_thread(machine, thread);
-		return 0;
-	}
-
 	if (thread == NULL || parent == NULL ||
 	    thread__fork(thread, parent) < 0) {
 		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
@@ -727,6 +723,22 @@ int perf_event__process_task(struct perf_tool *tool __maybe_unused,
 	return 0;
 }
 
+int perf_event__process_exit(struct perf_tool *tool __maybe_unused,
+			     union perf_event *event,
+			     struct perf_sample *sample __maybe_unused,
+			     struct machine *machine)
+{
+	struct thread *thread = machine__find_thread(machine, event->fork.tid);
+
+	if (dump_trace)
+		perf_event__fprintf_task(event, stdout);
+
+	if (thread != NULL)
+		machine__remove_thread(machine, thread);
+
+	return 0;
+}
+
 size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 {
 	size_t ret = fprintf(fp, "PERF_RECORD_%s",
@@ -761,8 +773,10 @@ int perf_event__process(struct perf_tool *tool, union perf_event *event,
 		perf_event__process_mmap(tool, event, sample, machine);
 		break;
 	case PERF_RECORD_FORK:
+		perf_event__process_fork(tool, event, sample, machine);
+		break;
 	case PERF_RECORD_EXIT:
-		perf_event__process_task(tool, event, sample, machine);
+		perf_event__process_exit(tool, event, sample, machine);
 		break;
 	case PERF_RECORD_LOST:
 		perf_event__process_lost(tool, event, sample, machine);
diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
index 21b99e7..da97aff 100644
--- a/tools/perf/util/event.h
+++ b/tools/perf/util/event.h
@@ -191,7 +191,11 @@ int perf_event__process_mmap(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
-int perf_event__process_task(struct perf_tool *tool,
+int perf_event__process_fork(struct perf_tool *tool,
+			     union perf_event *event,
+			     struct perf_sample *sample,
+			     struct machine *machine);
+int perf_event__process_exit(struct perf_tool *tool,
 			     union perf_event *event,
 			     struct perf_sample *sample,
 			     struct machine *machine);
-- 
1.7.9.2.358.g22243

