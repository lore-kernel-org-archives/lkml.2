Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab2KROfG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 09:35:06 -0500
Received: from casper.infradead.org ([85.118.1.10]:59378 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2KROaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 09:30:17 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/32] perf tests: Move test__basic_mmap into separate object
Date: Sun, 18 Nov 2012 11:29:29 -0300
Message-Id: <1353248997-30763-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1353248997-30763-1-git-send-email-acme@infradead.org>
References: <1353248997-30763-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Separating test__basic_mmap test from the builtin-test into mmap-basic
object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |    1 +
 tools/perf/tests/builtin-test.c |  157 -------------------------------------
 tools/perf/tests/mmap-basic.c   |  162 +++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |    1 +
 4 files changed, 164 insertions(+), 157 deletions(-)
 create mode 100644 tools/perf/tests/mmap-basic.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d413e89c..337489e 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -434,6 +434,7 @@ LIB_OBJS += $(OUTPUT)tests/attr.o
 LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
+LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 98e883b..609f592 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -30,163 +30,6 @@
 #include <sched.h>
 
 
-/*
- * This test will generate random numbers of calls to some getpid syscalls,
- * then establish an mmap for a group of events that are created to monitor
- * the syscalls.
- *
- * It will receive the events, using mmap, use its PERF_SAMPLE_ID generated
- * sample.id field to map back to its respective perf_evsel instance.
- *
- * Then it checks if the number of syscalls reported as perf events by
- * the kernel corresponds to the number of syscalls made.
- */
-static int test__basic_mmap(void)
-{
-	int err = -1;
-	union perf_event *event;
-	struct thread_map *threads;
-	struct cpu_map *cpus;
-	struct perf_evlist *evlist;
-	struct perf_event_attr attr = {
-		.type		= PERF_TYPE_TRACEPOINT,
-		.read_format	= PERF_FORMAT_ID,
-		.sample_type	= PERF_SAMPLE_ID,
-		.watermark	= 0,
-	};
-	cpu_set_t cpu_set;
-	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
-					"getpgid", };
-	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
-				      (void*)getpgid };
-#define nsyscalls ARRAY_SIZE(syscall_names)
-	int ids[nsyscalls];
-	unsigned int nr_events[nsyscalls],
-		     expected_nr_events[nsyscalls], i, j;
-	struct perf_evsel *evsels[nsyscalls], *evsel;
-
-	for (i = 0; i < nsyscalls; ++i) {
-		char name[64];
-
-		snprintf(name, sizeof(name), "sys_enter_%s", syscall_names[i]);
-		ids[i] = trace_event__id(name);
-		if (ids[i] < 0) {
-			pr_debug("Is debugfs mounted on /sys/kernel/debug?\n");
-			return -1;
-		}
-		nr_events[i] = 0;
-		expected_nr_events[i] = random() % 257;
-	}
-
-	threads = thread_map__new(-1, getpid(), UINT_MAX);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
-		return -1;
-	}
-
-	cpus = cpu_map__new(NULL);
-	if (cpus == NULL) {
-		pr_debug("cpu_map__new\n");
-		goto out_free_threads;
-	}
-
-	CPU_ZERO(&cpu_set);
-	CPU_SET(cpus->map[0], &cpu_set);
-	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
-	if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
-		pr_debug("sched_setaffinity() failed on CPU %d: %s ",
-			 cpus->map[0], strerror(errno));
-		goto out_free_cpus;
-	}
-
-	evlist = perf_evlist__new(cpus, threads);
-	if (evlist == NULL) {
-		pr_debug("perf_evlist__new\n");
-		goto out_free_cpus;
-	}
-
-	/* anonymous union fields, can't be initialized above */
-	attr.wakeup_events = 1;
-	attr.sample_period = 1;
-
-	for (i = 0; i < nsyscalls; ++i) {
-		attr.config = ids[i];
-		evsels[i] = perf_evsel__new(&attr, i);
-		if (evsels[i] == NULL) {
-			pr_debug("perf_evsel__new\n");
-			goto out_free_evlist;
-		}
-
-		perf_evlist__add(evlist, evsels[i]);
-
-		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
-			pr_debug("failed to open counter: %s, "
-				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-				 strerror(errno));
-			goto out_close_fd;
-		}
-	}
-
-	if (perf_evlist__mmap(evlist, 128, true) < 0) {
-		pr_debug("failed to mmap events: %d (%s)\n", errno,
-			 strerror(errno));
-		goto out_close_fd;
-	}
-
-	for (i = 0; i < nsyscalls; ++i)
-		for (j = 0; j < expected_nr_events[i]; ++j) {
-			int foo = syscalls[i]();
-			++foo;
-		}
-
-	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
-		struct perf_sample sample;
-
-		if (event->header.type != PERF_RECORD_SAMPLE) {
-			pr_debug("unexpected %s event\n",
-				 perf_event__name(event->header.type));
-			goto out_munmap;
-		}
-
-		err = perf_evlist__parse_sample(evlist, event, &sample);
-		if (err) {
-			pr_err("Can't parse sample, err = %d\n", err);
-			goto out_munmap;
-		}
-
-		evsel = perf_evlist__id2evsel(evlist, sample.id);
-		if (evsel == NULL) {
-			pr_debug("event with id %" PRIu64
-				 " doesn't map to an evsel\n", sample.id);
-			goto out_munmap;
-		}
-		nr_events[evsel->idx]++;
-	}
-
-	list_for_each_entry(evsel, &evlist->entries, node) {
-		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
-			pr_debug("expected %d %s events, got %d\n",
-				 expected_nr_events[evsel->idx],
-				 perf_evsel__name(evsel), nr_events[evsel->idx]);
-			goto out_munmap;
-		}
-	}
-
-	err = 0;
-out_munmap:
-	perf_evlist__munmap(evlist);
-out_close_fd:
-	for (i = 0; i < nsyscalls; ++i)
-		perf_evsel__close_fd(evsels[i], 1, threads->nr);
-out_free_evlist:
-	perf_evlist__delete(evlist);
-out_free_cpus:
-	cpu_map__delete(cpus);
-out_free_threads:
-	thread_map__delete(threads);
-	return err;
-#undef nsyscalls
-}
 
 static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t *maskp)
 {
diff --git a/tools/perf/tests/mmap-basic.c b/tools/perf/tests/mmap-basic.c
new file mode 100644
index 0000000..e174681
--- /dev/null
+++ b/tools/perf/tests/mmap-basic.c
@@ -0,0 +1,162 @@
+#include "evlist.h"
+#include "evsel.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "tests.h"
+
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
+int test__basic_mmap(void)
+{
+	int err = -1;
+	union perf_event *event;
+	struct thread_map *threads;
+	struct cpu_map *cpus;
+	struct perf_evlist *evlist;
+	struct perf_event_attr attr = {
+		.type		= PERF_TYPE_TRACEPOINT,
+		.read_format	= PERF_FORMAT_ID,
+		.sample_type	= PERF_SAMPLE_ID,
+		.watermark	= 0,
+	};
+	cpu_set_t cpu_set;
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
+	threads = thread_map__new(-1, getpid(), UINT_MAX);
+	if (threads == NULL) {
+		pr_debug("thread_map__new\n");
+		return -1;
+	}
+
+	cpus = cpu_map__new(NULL);
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
+		goto out_free_threads;
+	}
+
+	CPU_ZERO(&cpu_set);
+	CPU_SET(cpus->map[0], &cpu_set);
+	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
+	if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
+		pr_debug("sched_setaffinity() failed on CPU %d: %s ",
+			 cpus->map[0], strerror(errno));
+		goto out_free_cpus;
+	}
+
+	evlist = perf_evlist__new(cpus, threads);
+	if (evlist == NULL) {
+		pr_debug("perf_evlist__new\n");
+		goto out_free_cpus;
+	}
+
+	/* anonymous union fields, can't be initialized above */
+	attr.wakeup_events = 1;
+	attr.sample_period = 1;
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
+		if (perf_evsel__open(evsels[i], cpus, threads) < 0) {
+			pr_debug("failed to open counter: %s, "
+				 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+				 strerror(errno));
+			goto out_close_fd;
+		}
+	}
+
+	if (perf_evlist__mmap(evlist, 128, true) < 0) {
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
+	while ((event = perf_evlist__mmap_read(evlist, 0)) != NULL) {
+		struct perf_sample sample;
+
+		if (event->header.type != PERF_RECORD_SAMPLE) {
+			pr_debug("unexpected %s event\n",
+				 perf_event__name(event->header.type));
+			goto out_munmap;
+		}
+
+		err = perf_evlist__parse_sample(evlist, event, &sample);
+		if (err) {
+			pr_err("Can't parse sample, err = %d\n", err);
+			goto out_munmap;
+		}
+
+		evsel = perf_evlist__id2evsel(evlist, sample.id);
+		if (evsel == NULL) {
+			pr_debug("event with id %" PRIu64
+				 " doesn't map to an evsel\n", sample.id);
+			goto out_munmap;
+		}
+		nr_events[evsel->idx]++;
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (nr_events[evsel->idx] != expected_nr_events[evsel->idx]) {
+			pr_debug("expected %d %s events, got %d\n",
+				 expected_nr_events[evsel->idx],
+				 perf_evsel__name(evsel), nr_events[evsel->idx]);
+			goto out_munmap;
+		}
+	}
+
+	err = 0;
+out_munmap:
+	perf_evlist__munmap(evlist);
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
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index c2887f2..1a925dd 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -5,6 +5,7 @@
 int test__vmlinux_matches_kallsyms(void);
 int test__open_syscall_event(void);
 int test__open_syscall_event_on_all_cpus(void);
+int test__basic_mmap(void);
 
 /* Util */
 int trace_event__id(const char *evname);
-- 
1.7.9.2.358.g22243

