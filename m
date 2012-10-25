Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934771Ab2JYIFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:05:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38409 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934104Ab2JYIFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:05:01 -0400
Date: Thu, 25 Oct 2012 01:04:29 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-g9akh5hjw2kvjerpo9xror6f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add an event duration column
Git-Commit-ID: 60c907abc635622964f7862c8f2977182124f89d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 01:04:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  60c907abc635622964f7862c8f2977182124f89d
Gitweb:     http://git.kernel.org/tip/60c907abc635622964f7862c8f2977182124f89d
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Wed, 24 Oct 2012 17:24:47 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 17:24:47 -0200

perf trace: Add an event duration column

 # perf trace usleep 1 | tail -10
     0.453 ( 0.002 ms): mmap(addr: 0, len: 4096, prot: 3, flags: 34, fd: 4294967295, off: 0   ) = -763342848
     0.456 ( 0.001 ms): mmap(addr: 0, len: 4096, prot: 3, flags: 34, fd: 4294967295, off: 0   ) = -763346944
     0.459 ( 0.001 ms): arch_prctl(option: 4098, arg2: 140126839658240, arg3: 140126839652352, arg4: 34, arg5: 4294967295) = 0
     0.473 ( 0.003 ms): mprotect(start: 208741634048, len: 16384, prot: 1                     ) = 0
     0.477 ( 0.003 ms): mprotect(start: 208735956992, len: 4096, prot: 1                      ) = 0
     0.483 ( 0.004 ms): munmap(addr: 140126839664640, len: 91882                              ) = 0
     0.540 ( 0.001 ms): brk(brk: 0                                                            ) = 31928320
     0.542 ( 0.002 ms): brk(brk: 32063488                                                     ) = 32063488
     1.456 ( 0.901 ms): nanosleep(rqtp: 140735472817168, rmtp: 0                              ) = 0
     1.462 ( 0.000 ms): exit_group(error_code: 0
 #

This also comes from the tmp.perf/trace2 branch.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/n/tip-g9akh5hjw2kvjerpo9xror6f@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |   27 +++++++++++++++++++++++----
 1 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 873f50b..ddb6e37 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -46,6 +46,20 @@ struct syscall {
 	struct syscall_fmt  *fmt;
 };
 
+static size_t fprintf_duration(unsigned long t, FILE *fp)
+{
+	double duration = (double)t / NSEC_PER_MSEC;
+	size_t printed = fprintf(fp, "(");
+
+	if (duration >= 1.0)
+		printed += color_fprintf(fp, PERF_COLOR_RED, "%6.3f ms", duration);
+	else if (duration >= 0.01)
+		printed += color_fprintf(fp, PERF_COLOR_YELLOW, "%6.3f ms", duration);
+	else
+		printed += color_fprintf(fp, PERF_COLOR_NORMAL, "%6.3f ms", duration);
+	return printed + fprintf(stdout, "): ");
+}
+
 struct thread_trace {
 	u64		  entry_time;
 	u64		  exit_time;
@@ -92,7 +106,7 @@ static size_t trace__fprintf_tstamp(struct trace *trace, u64 tstamp, FILE *fp)
 {
 	double ts = (double)(tstamp - trace->base_time) / NSEC_PER_MSEC;
 
-	return fprintf(fp, "%10.3f: ", ts);
+	return fprintf(fp, "%10.3f ", ts);
 }
 
 static bool done = false;
@@ -103,9 +117,10 @@ static void sig_handler(int sig __maybe_unused)
 }
 
 static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thread,
-					u64 tstamp, FILE *fp)
+					u64 duration, u64 tstamp, FILE *fp)
 {
 	size_t printed = trace__fprintf_tstamp(trace, tstamp, fp);
+	printed += fprintf_duration(duration, fp);
 
 	if (trace->multiple_threads)
 		printed += fprintf(fp, "%d ", thread->pid);
@@ -292,7 +307,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	printed += syscall__scnprintf_args(sc, msg + printed, 1024 - printed,  args);
 
 	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
-		trace__fprintf_entry_head(trace, thread, sample->time, stdout);
+		trace__fprintf_entry_head(trace, thread, 1, sample->time, stdout);
 		printf("%-70s\n", ttrace->entry_str);
 	} else
 		ttrace->entry_pending = true;
@@ -304,6 +319,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 			   struct perf_sample *sample)
 {
 	int ret;
+	u64 duration = 0;
 	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
 	struct thread_trace *ttrace = thread__trace(thread);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
@@ -317,7 +333,10 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 
 	ttrace->exit_time = sample->time;
 
-	trace__fprintf_entry_head(trace, thread, sample->time, stdout);
+	if (ttrace->entry_time)
+		duration = sample->time - ttrace->entry_time;
+
+	trace__fprintf_entry_head(trace, thread, duration, sample->time, stdout);
 
 	if (ttrace->entry_pending) {
 		printf("%-70s", ttrace->entry_str);
