Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753519Ab1AOPlO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 10:41:14 -0500
Received: from casper.infradead.org ([85.118.1.10]:37071 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312Ab1AOPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 10:41:03 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>
Subject: [PATCH 16/16] perf test: Add test for the evlist mmap routines
Date: Sat, 15 Jan 2011 13:40:45 -0200
Message-Id: <1295106045-31192-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295106045-31192-1-git-send-email-acme@infradead.org>
References: <1295106045-31192-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

This test will generate random numbers of calls to some getpid syscalls,
then establish an mmap for a group of events that are created to monitor
these syscalls.

It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
sample.id field to map back to its respective perf_evsel instance.

Then it checks if the number of syscalls reported as perf events by the
kernel corresponds to the number of syscalls made.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |  175 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 173 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index b03cb3a..4b0ef5f 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -7,7 +7,9 @@
 
 #include "util/cache.h"
 #include "util/debug.h"
+#include "util/evlist.h"
 #include "util/parse-options.h"
+#include "util/parse-events.h"
 #include "util/session.h"
 #include "util/symbol.h"
 #include "util/thread.h"
@@ -238,14 +240,14 @@ out:
 #include "util/evsel.h"
 #include <sys/types.h>
 
-static int trace_event__id(const char *event_name)
+static int trace_event__id(const char *evname)
 {
 	char *filename;
 	int err = -1, fd;
 
 	if (asprintf(&filename,
 		     "/sys/kernel/debug/tracing/events/syscalls/%s/id",
-		     event_name) < 0)
+		     evname) < 0)
 		return -1;
 
 	fd = open(filename, O_RDONLY);
@@ -429,6 +431,171 @@ out_thread_map_delete:
 	return err;
 }
 
+/*
+ * This test will generate random numbers of calls to some getpid syscalls,
+ * then establish an mmap for a group of events that are created to monitor
+ * the syscalls.
+ *
+ * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
+ * sample.id field to map back to its respective perf_evsel instance.
+ *
+ * Then it checks if the number of syscalls reported as perf events by
+ * the kernel corresponds to the number of syscalls made.
+ */
+static int test__basic_mmap(void)
+{
+	int err = -1;
+	event_t *event;
+	struct thread_map *threads;
+	struct perf_session session;
+	struct cpu_map *cpus;
+	struct perf_evlist *evlist;
+	struct perf_event_attr attr = {
+		.type		= PERF_TYPE_TRACEPOINT,
+		.read_format	= PERF_FORMAT_ID,
+		.sample_type	= PERF_SAMPLE_ID,
+		.watermark	= 0,
+	};
+	cpu_set_t *cpu_set;
+	size_t cpu_set_size;
+	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
+					"getpgid", };
+	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
+				      (void*)getpgid };
+#define nsyscalls ARRAY_SIZE(syscall_names)
+	int ids[nsyscalls];
+	unsigned int nr_events[nsyscalls],
+		     expected_nr_events[nsyscalls], i, j;
+	struct perf_evsel *evsels[nsyscalls], *evsel;
+
+	for (i = 0; i < nsyscalls; ++i) {
+		char name[64];
+
+		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
+		ids[i] = trace_event__id(name);
+		if (ids[i] < 0) {
+			pr_debug("Is debugfs mounted on /sys/kernel/debug?\n");
+			return -1;
+		}
+		nr_events[i] = 0;
+		expected_nr_events[i] = random() % 257;
+	}
+
+	threads = thread_map__new(-1, getpid());
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		goto out_free_threads;
+	}
+
+	cpu_set = CPU_ALLOC(cpus->nr);
+
+	if (cpu_set == NULL) {
+		pr_debug("thread_map__new\n");
+		goto out_free_cpus;
+	}
+
+	cpu_set_size = CPU_ALLOC_SIZE(cpus->nr);
+	CPU_ZERO_S(cpu_set_size, cpu_set);
+	CPU_SET(cpus->map[0], cpu_set);
+	sched_setaffinity(0, cpu_set_size, cpu_set);
+	CPU_FREE(cpu_set);
+
+	evlist = perf_evlist__new();
+	if (threads == NULL) {
+		pr_debug("perf_evlist__new\n");
+		goto out_free_cpus;
+	}
+
+	/* anonymous union fields, can't be initialized above */
+	attr.wakeup_events = 1;
+	attr.sample_period = 1;
+
+	/*
+ 	 * FIXME: use evsel->attr.sample_type in event__parse_sample.
+ 	 * 	  This will nicely remove the requirement that we have
+ 	 * 	  all the events with the same sample_type.
+ 	 */
+	session.sample_type = attr.sample_type;
+
+	for (i = 0; i < nsyscalls; ++i) {
+		attr.config = ids[i];
+		evsels[i] = perf_evsel__new(&attr, i);
+		if (evsels[i] == NULL) {
+			pr_debug("perf_evsel__new\n");
+			goto out_free_evlist;
+		}
+
+		perf_evlist__add(evlist, evsels[i]);
+
+		if (perf_evsel__open(evsels[i], cpus, threads, false, false) < 0) {
+			pr_debug("failed to open counter: %s, "
+				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+				 strerror(errno));
+			goto out_close_fd;
+		}
+	}
+
+	if (perf_evlist__mmap(evlist, cpus, threads, 128, true) < 0) {
+		pr_debug("failed to mmap events: %d (%s)\n", errno,
+			 strerror(errno));
+		goto out_close_fd;
+	}
+
+	for (i = 0; i < nsyscalls; ++i)
+		for (j = 0; j < expected_nr_events[i]; ++j) {
+			int foo = syscalls[i]();
+			++foo;
+		}
+
+	while ((event = perf_evlist__read_on_cpu(evlist, 0)) != NULL) {
+		struct sample_data sample;
+
+		if (event->header.type != PERF_RECORD_SAMPLE) {
+			pr_debug("unexpected %s event\n",
+				 event__get_event_name(event->header.type));
+			goto out_munmap;
+		}
+
+		event__parse_sample(event, &session, &sample);
+		evsel = perf_evlist__id2evsel(evlist, sample.id);
+		if (evsel == NULL) {
+			pr_debug("event with id %Ld doesn't map to an evsel\n", sample.id);
+			goto out_munmap;
+		}
+		nr_events[evsel->idx]++;
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
+			pr_debug("expected %d %s events, got %d\n",
+				 expected_nr_events[evsel->idx],
+				 event_name(evsel), nr_events[evsel->idx]);
+			goto out_munmap;
+		}
+	}
+
+	err = 0;
+out_munmap:
+	perf_evlist__munmap(evlist, 1);
+out_close_fd:
+	for (i = 0; i < nsyscalls; ++i)
+		perf_evsel__close_fd(evsels[i], 1, threads->nr);
+out_free_evlist:
+	perf_evlist__delete(evlist);
+out_free_cpus:
+	cpu_map__delete(cpus);
+out_free_threads:
+	thread_map__delete(threads);
+	return err;
+#undef nsyscalls
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -446,6 +613,10 @@ static struct test {
 		.func = test__open_syscall_event_on_all_cpus,
 	},
 	{
+		.desc = "read samples using the mmap interface",
+		.func = test__basic_mmap,
+	},
+	{
 		.func = NULL,
 	},
 };
-- 
1.6.2.5

