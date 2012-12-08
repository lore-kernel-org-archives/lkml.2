Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933244Ab2LHOkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2012 09:40:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49279 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754968Ab2LHOka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2012 09:40:30 -0500
Date: Sat, 8 Dec 2012 06:40:01 -0800
From: tip-bot for Jiri Olsa <jolsa@redhat.com>
Message-ID: <tip-bd90517b374b1d6381a5509f55df1a9b7c33a6b1@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1352508412-16914-4-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tests:
  Move test__open_syscall_event_on_all_cpus into separate object
Git-Commit-ID: bd90517b374b1d6381a5509f55df1a9b7c33a6b1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Sat, 08 Dec 2012 06:40:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bd90517b374b1d6381a5509f55df1a9b7c33a6b1
Gitweb:     http://git.kernel.org/tip/bd90517b374b1d6381a5509f55df1a9b7c33a6b1
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Sat, 10 Nov 2012 01:46:43 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 14 Nov 2012 16:49:25 -0300

perf tests: Move test__open_syscall_event_on_all_cpus into separate object

Separating test__open_syscall_event_on_all_cpus test from the
builtin-test into open-syscall-all-cpus object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1352508412-16914-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile                      |   1 +
 tools/perf/tests/builtin-test.c          | 114 -----------------------------
 tools/perf/tests/open-syscall-all-cpus.c | 120 +++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h                 |   1 +
 4 files changed, 122 insertions(+), 114 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 69f582c..d413e89 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -433,6 +433,7 @@ LIB_OBJS += $(OUTPUT)tests/dso-data.o
 LIB_OBJS += $(OUTPUT)tests/attr.o
 LIB_OBJS += $(OUTPUT)tests/vmlinux-kallsyms.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall.o
+LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b6b1e46..98e883b 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -29,120 +29,6 @@
 
 #include <sched.h>
 
-static int test__open_syscall_event_on_all_cpus(void)
-{
-	int err = -1, fd, cpu;
-	struct thread_map *threads;
-	struct cpu_map *cpus;
-	struct perf_evsel *evsel;
-	struct perf_event_attr attr;
-	unsigned int nr_open_calls = 111, i;
-	cpu_set_t cpu_set;
-	int id = trace_event__id("sys_enter_open");
-
-	if (id < 0) {
-		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
-		return -1;
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
-		goto out_thread_map_delete;
-	}
-
-
-	CPU_ZERO(&cpu_set);
-
-	memset(&attr, 0, sizeof(attr));
-	attr.type = PERF_TYPE_TRACEPOINT;
-	attr.config = id;
-	evsel = perf_evsel__new(&attr, 0);
-	if (evsel == NULL) {
-		pr_debug("perf_evsel__new\n");
-		goto out_thread_map_delete;
-	}
-
-	if (perf_evsel__open(evsel, cpus, threads) < 0) {
-		pr_debug("failed to open counter: %s, "
-			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
-			 strerror(errno));
-		goto out_evsel_delete;
-	}
-
-	for (cpu = 0; cpu < cpus->nr; ++cpu) {
-		unsigned int ncalls = nr_open_calls + cpu;
-		/*
-		 * XXX eventually lift this restriction in a way that
-		 * keeps perf building on older glibc installations
-		 * without CPU_ALLOC. 1024 cpus in 2010 still seems
-		 * a reasonable upper limit tho :-)
-		 */
-		if (cpus->map[cpu] >= CPU_SETSIZE) {
-			pr_debug("Ignoring CPU %d\n", cpus->map[cpu]);
-			continue;
-		}
-
-		CPU_SET(cpus->map[cpu], &cpu_set);
-		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
-			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
-				 cpus->map[cpu],
-				 strerror(errno));
-			goto out_close_fd;
-		}
-		for (i = 0; i < ncalls; ++i) {
-			fd = open("/etc/passwd", O_RDONLY);
-			close(fd);
-		}
-		CPU_CLR(cpus->map[cpu], &cpu_set);
-	}
-
-	/*
-	 * Here we need to explicitely preallocate the counts, as if
-	 * we use the auto allocation it will allocate just for 1 cpu,
-	 * as we start by cpu 0.
-	 */
-	if (perf_evsel__alloc_counts(evsel, cpus->nr) < 0) {
-		pr_debug("perf_evsel__alloc_counts(ncpus=%d)\n", cpus->nr);
-		goto out_close_fd;
-	}
-
-	err = 0;
-
-	for (cpu = 0; cpu < cpus->nr; ++cpu) {
-		unsigned int expected;
-
-		if (cpus->map[cpu] >= CPU_SETSIZE)
-			continue;
-
-		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
-			pr_debug("perf_evsel__read_on_cpu\n");
-			err = -1;
-			break;
-		}
-
-		expected = nr_open_calls + cpu;
-		if (evsel->counts->cpu[cpu].val != expected) {
-			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
-				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
-			err = -1;
-		}
-	}
-
-out_close_fd:
-	perf_evsel__close_fd(evsel, 1, threads->nr);
-out_evsel_delete:
-	perf_evsel__delete(evsel);
-out_thread_map_delete:
-	thread_map__delete(threads);
-	return err;
-}
 
 /*
  * This test will generate random numbers of calls to some getpid syscalls,
diff --git a/tools/perf/tests/open-syscall-all-cpus.c b/tools/perf/tests/open-syscall-all-cpus.c
new file mode 100644
index 0000000..31072ab
--- /dev/null
+++ b/tools/perf/tests/open-syscall-all-cpus.c
@@ -0,0 +1,120 @@
+#include "evsel.h"
+#include "tests.h"
+#include "thread_map.h"
+#include "cpumap.h"
+#include "debug.h"
+
+int test__open_syscall_event_on_all_cpus(void)
+{
+	int err = -1, fd, cpu;
+	struct thread_map *threads;
+	struct cpu_map *cpus;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+	unsigned int nr_open_calls = 111, i;
+	cpu_set_t cpu_set;
+	int id = trace_event__id("sys_enter_open");
+
+	if (id < 0) {
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		return -1;
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
+		goto out_thread_map_delete;
+	}
+
+
+	CPU_ZERO(&cpu_set);
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_thread_map_delete;
+	}
+
+	if (perf_evsel__open(evsel, cpus, threads) < 0) {
+		pr_debug("failed to open counter: %s, "
+			 "tweak /proc/sys/kernel/perf_event_paranoid?\n",
+			 strerror(errno));
+		goto out_evsel_delete;
+	}
+
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		unsigned int ncalls = nr_open_calls + cpu;
+		/*
+		 * XXX eventually lift this restriction in a way that
+		 * keeps perf building on older glibc installations
+		 * without CPU_ALLOC. 1024 cpus in 2010 still seems
+		 * a reasonable upper limit tho :-)
+		 */
+		if (cpus->map[cpu] >= CPU_SETSIZE) {
+			pr_debug("Ignoring CPU %d\n", cpus->map[cpu]);
+			continue;
+		}
+
+		CPU_SET(cpus->map[cpu], &cpu_set);
+		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
+			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
+				 cpus->map[cpu],
+				 strerror(errno));
+			goto out_close_fd;
+		}
+		for (i = 0; i < ncalls; ++i) {
+			fd = open("/etc/passwd", O_RDONLY);
+			close(fd);
+		}
+		CPU_CLR(cpus->map[cpu], &cpu_set);
+	}
+
+	/*
+	 * Here we need to explicitely preallocate the counts, as if
+	 * we use the auto allocation it will allocate just for 1 cpu,
+	 * as we start by cpu 0.
+	 */
+	if (perf_evsel__alloc_counts(evsel, cpus->nr) < 0) {
+		pr_debug("perf_evsel__alloc_counts(ncpus=%d)\n", cpus->nr);
+		goto out_close_fd;
+	}
+
+	err = 0;
+
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		unsigned int expected;
+
+		if (cpus->map[cpu] >= CPU_SETSIZE)
+			continue;
+
+		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
+			pr_debug("perf_evsel__read_on_cpu\n");
+			err = -1;
+			break;
+		}
+
+		expected = nr_open_calls + cpu;
+		if (evsel->counts->cpu[cpu].val != expected) {
+			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %" PRIu64 "\n",
+				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
+			err = -1;
+		}
+	}
+
+out_close_fd:
+	perf_evsel__close_fd(evsel, 1, threads->nr);
+out_evsel_delete:
+	perf_evsel__delete(evsel);
+out_thread_map_delete:
+	thread_map__delete(threads);
+	return err;
+}
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index bac133e..c2887f2 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -4,6 +4,7 @@
 /* Tests */
 int test__vmlinux_matches_kallsyms(void);
 int test__open_syscall_event(void);
+int test__open_syscall_event_on_all_cpus(void);
 
 /* Util */
 int trace_event__id(const char *evname);
