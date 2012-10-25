Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161019Ab2JYIEP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 04:04:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38387 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965425Ab2JYIEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 04:04:00 -0400
Date: Thu, 25 Oct 2012 01:03:29 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-ly9ulroru4my5isn0xe9gr0m@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Support interrupted syscalls
Git-Commit-ID: 752fde44fd1c4a411d709c7d4ad0f121f427f234
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 25 Oct 2012 01:03:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  752fde44fd1c4a411d709c7d4ad0f121f427f234
Gitweb:     http://git.kernel.org/tip/752fde44fd1c4a411d709c7d4ad0f121f427f234
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Sat, 6 Oct 2012 18:43:19 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 24 Oct 2012 17:23:03 -0200

perf trace: Support interrupted syscalls

Using the same strategies as in the tmp.perf/trace2, i.e. the 'trace'
tool implemented by tglx, just updated to the current codebase.

Example:

[root@sandy linux]# perf trace usleep 1  | tail
     2.003: mmap(addr: 0, len: 4096, prot: 3, flags: 34, fd: 4294967295, off: 0   ) = -2128396288
     2.017: mmap(addr: 0, len: 4096, prot: 3, flags: 34, fd: 4294967295, off: 0   ) = -2128400384
     2.029: arch_prctl(option: 4098, arg2: 140146949441280, arg3: 140146949435392, arg4: 34, arg5: 4294967295) = 0
     2.084: mprotect(start: 208741634048, len: 16384, prot: 1                     ) = 0
     2.098: mprotect(start: 208735956992, len: 4096, prot: 1                      ) = 0
     2.122: munmap(addr: 140146949447680, len: 91882                              ) = 0
     2.359: brk(brk: 0                                                            ) = 28987392
     2.371: brk(brk: 29122560                                                     ) = 29122560
     2.490: nanosleep(rqtp: 140735694241504, rmtp: 0                              ) = 0
     2.507: exit_group(error_code: 0
[root@sandy linux]#

For now the timestamp and duration are always on, will be selectable.

Also if multiple threads are being monitored, its tid will appear.

The ret output continues to be interpreted a la strace.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-ly9ulroru4my5isn0xe9gr0m@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c |  199 +++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/util.h     |    4 +
 2 files changed, 181 insertions(+), 22 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 14b3229..873f50b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1,5 +1,8 @@
 #include "builtin.h"
+#include "util/color.h"
 #include "util/evlist.h"
+#include "util/machine.h"
+#include "util/thread.h"
 #include "util/parse-options.h"
 #include "util/thread_map.h"
 #include "event-parse.h"
@@ -43,6 +46,36 @@ struct syscall {
 	struct syscall_fmt  *fmt;
 };
 
+struct thread_trace {
+	u64		  entry_time;
+	u64		  exit_time;
+	bool		  entry_pending;
+	char		  *entry_str;
+};
+
+static struct thread_trace *thread_trace__new(void)
+{
+	return zalloc(sizeof(struct thread_trace));
+}
+
+static struct thread_trace *thread__trace(struct thread *thread)
+{
+	if (thread == NULL)
+		goto fail;
+
+	if (thread->priv == NULL)
+		thread->priv = thread_trace__new();
+
+	if (thread->priv == NULL)
+		goto fail;
+
+	return thread->priv;
+fail:
+	color_fprintf(stdout, PERF_COLOR_RED,
+		      "WARNING: not enough memory, dropping samples!\n");
+	return NULL;
+}
+
 struct trace {
 	int			audit_machine;
 	struct {
@@ -50,8 +83,18 @@ struct trace {
 		struct syscall  *table;
 	} syscalls;
 	struct perf_record_opts opts;
+	struct machine		host;
+	u64			base_time;
+	bool			multiple_threads;
 };
 
+static size_t trace__fprintf_tstamp(struct trace *trace, u64 tstamp, FILE *fp)
+{
+	double ts = (double)(tstamp - trace->base_time) / NSEC_PER_MSEC;
+
+	return fprintf(fp, "%10.3f: ", ts);
+}
+
 static bool done = false;
 
 static void sig_handler(int sig __maybe_unused)
@@ -59,6 +102,67 @@ static void sig_handler(int sig __maybe_unused)
 	done = true;
 }
 
+static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thread,
+					u64 tstamp, FILE *fp)
+{
+	size_t printed = trace__fprintf_tstamp(trace, tstamp, fp);
+
+	if (trace->multiple_threads)
+		printed += fprintf(fp, "%d ", thread->pid);
+
+	return printed;
+}
+
+static int trace__process_event(struct machine *machine, union perf_event *event)
+{
+	int ret = 0;
+
+	switch (event->header.type) {
+	case PERF_RECORD_LOST:
+		color_fprintf(stdout, PERF_COLOR_RED,
+			      "LOST %" PRIu64 " events!\n", event->lost.lost);
+		ret = machine__process_lost_event(machine, event);
+	default:
+		ret = machine__process_event(machine, event);
+		break;
+	}
+
+	return ret;
+}
+
+static int trace__tool_process(struct perf_tool *tool __maybe_unused,
+			       union perf_event *event,
+			       struct perf_sample *sample __maybe_unused,
+			       struct machine *machine)
+{
+	return trace__process_event(machine, event);
+}
+
+static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
+{
+	int err = symbol__init();
+
+	if (err)
+		return err;
+
+	machine__init(&trace->host, "", HOST_KERNEL_ID);
+	machine__create_kernel_maps(&trace->host);
+
+	if (perf_target__has_task(&trace->opts.target)) {
+		err = perf_event__synthesize_thread_map(NULL, evlist->threads,
+							trace__tool_process,
+							&trace->host);
+	} else {
+		err = perf_event__synthesize_threads(NULL, trace__tool_process,
+						     &trace->host);
+	}
+
+	if (err)
+		symbol__exit();
+
+	return err;
+}
+
 static int trace__read_syscall_info(struct trace *trace, int id)
 {
 	char tp_name[128];
@@ -100,7 +204,8 @@ static int trace__read_syscall_info(struct trace *trace, int id)
 	return sc->tp_format != NULL ? 0 : -1;
 }
 
-static size_t syscall__fprintf_args(struct syscall *sc, unsigned long *args, FILE *fp)
+static size_t syscall__scnprintf_args(struct syscall *sc, char *bf, size_t size,
+				      unsigned long *args)
 {
 	int i = 0;
 	size_t printed = 0;
@@ -109,12 +214,15 @@ static size_t syscall__fprintf_args(struct syscall *sc, unsigned long *args, FIL
 		struct format_field *field;
 
 		for (field = sc->tp_format->format.fields->next; field; field = field->next) {
-			printed += fprintf(fp, "%s%s: %ld", printed ? ", " : "",
-					   field->name, args[i++]);
+			printed += scnprintf(bf + printed, size - printed,
+					     "%s%s: %ld", printed ? ", " : "",
+					     field->name, args[i++]);
 		}
 	} else {
 		while (i < 6) {
-			printed += fprintf(fp, "%sarg%d: %ld", printed ? ", " : "", i, args[i]);
+			printed += scnprintf(bf + printed, size - printed,
+					     "%sarg%d: %ld",
+					     printed ? ", " : "", i, args[i]);
 			++i;
 		}
 	}
@@ -153,10 +261,14 @@ out_cant_read:
 static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 			    struct perf_sample *sample)
 {
+	char *msg;
 	void *args;
+	size_t printed = 0;
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
+	struct thread_trace *ttrace = thread__trace(thread);
 
-	if (sc == NULL)
+	if (ttrace == NULL || sc == NULL)
 		return -1;
 
 	args = perf_evsel__rawptr(evsel, sample, "args");
@@ -165,8 +277,25 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 		return -1;
 	}
 
-	printf("%s(", sc->name);
-	syscall__fprintf_args(sc, args, stdout);
+	ttrace = thread->priv;
+
+	if (ttrace->entry_str == NULL) {
+		ttrace->entry_str = malloc(1024);
+		if (!ttrace->entry_str)
+			return -1;
+	}
+
+	ttrace->entry_time = sample->time;
+	msg = ttrace->entry_str;
+	printed += scnprintf(msg + printed, 1024 - printed, "%s(", sc->name);
+
+	printed += syscall__scnprintf_args(sc, msg + printed, 1024 - printed,  args);
+
+	if (!strcmp(sc->name, "exit_group") || !strcmp(sc->name, "exit")) {
+		trace__fprintf_entry_head(trace, thread, sample->time, stdout);
+		printf("%-70s\n", ttrace->entry_str);
+	} else
+		ttrace->entry_pending = true;
 
 	return 0;
 }
@@ -175,13 +304,29 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 			   struct perf_sample *sample)
 {
 	int ret;
+	struct thread *thread = machine__findnew_thread(&trace->host, sample->tid);
+	struct thread_trace *ttrace = thread__trace(thread);
 	struct syscall *sc = trace__syscall_info(trace, evsel, sample);
 
-	if (sc == NULL)
+	if (ttrace == NULL || sc == NULL)
 		return -1;
 
 	ret = perf_evsel__intval(evsel, sample, "ret");
 
+	ttrace = thread->priv;
+
+	ttrace->exit_time = sample->time;
+
+	trace__fprintf_entry_head(trace, thread, sample->time, stdout);
+
+	if (ttrace->entry_pending) {
+		printf("%-70s", ttrace->entry_str);
+	} else {
+		printf(" ... [");
+		color_fprintf(stdout, PERF_COLOR_YELLOW, "continued");
+		printf("]: %s()", sc->name);
+	}
+
 	if (ret < 0 && sc->fmt && sc->fmt->errmsg) {
 		char bf[256];
 		const char *emsg = strerror_r(-ret, bf, sizeof(bf)),
@@ -194,6 +339,9 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 		printf(") = %d", ret);
 
 	putchar('\n');
+
+	ttrace->entry_pending = false;
+
 	return 0;
 }
 
@@ -221,6 +369,12 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 		goto out_delete_evlist;
 	}
 
+	err = trace__symbols_init(trace, evlist);
+	if (err < 0) {
+		printf("Problems initializing symbol libraries!\n");
+		goto out_delete_evlist;
+	}
+
 	perf_evlist__config_attrs(evlist, &trace->opts);
 
 	signal(SIGCHLD, sig_handler);
@@ -251,6 +405,7 @@ static int trace__run(struct trace *trace, int argc, const char **argv)
 	if (forks)
 		perf_evlist__start_workload(evlist);
 
+	trace->multiple_threads = evlist->threads->map[0] == -1 || evlist->threads->nr > 1;
 again:
 	before = nr_events;
 
@@ -264,32 +419,32 @@ again:
 
 			++nr_events;
 
-			switch (type) {
-			case PERF_RECORD_SAMPLE:
-				break;
-			case PERF_RECORD_LOST:
-				printf("LOST %" PRIu64 " events!\n", event->lost.lost);
-				continue;
-			default:
-				printf("Unexpected %s event, skipping...\n",
-					perf_event__name(type));
-				continue;
-			}
-
 			err = perf_evlist__parse_sample(evlist, event, &sample);
 			if (err) {
 				printf("Can't parse sample, err = %d, skipping...\n", err);
 				continue;
 			}
 
+			if (trace->base_time == 0)
+				trace->base_time = sample.time;
+
+			if (type != PERF_RECORD_SAMPLE) {
+				trace__process_event(&trace->host, event);
+				continue;
+			}
+
 			evsel = perf_evlist__id2evsel(evlist, sample.id);
 			if (evsel == NULL) {
 				printf("Unknown tp ID %" PRIu64 ", skipping...\n", sample.id);
 				continue;
 			}
 
-			if (evlist->threads->map[0] == -1 || evlist->threads->nr > 1)
-				printf("%d ", sample.tid);
+			if (sample.raw_data == NULL) {
+				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
+				       perf_evsel__name(evsel), sample.tid,
+				       sample.cpu, sample.raw_size);
+				continue;
+			}
 
 			if (sample.raw_data == NULL) {
 				printf("%s sample with no payload for tid: %d, cpu %d, raw_size=%d, skipping...\n",
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index a6b83f8..0d85209 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -198,6 +198,10 @@ static inline int has_extension(const char *filename, const char *ext)
 #undef tolower
 #undef toupper
 
+#ifndef NSEC_PER_MSEC
+#define NSEC_PER_MSEC	1000000L
+#endif
+
 extern unsigned char sane_ctype[256];
 #define GIT_SPACE		0x01
 #define GIT_DIGIT		0x02
