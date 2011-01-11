Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915Ab1AKLMD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 06:12:03 -0500
Received: from hera.kernel.org ([140.211.167.34]:36264 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755728Ab1AKLMA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 06:12:00 -0500
Date: Tue, 11 Jan 2011 11:11:24 GMT
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: eranian@google.com, paulus@samba.org, linux-kernel@vger.kernel.org,
        acme@redhat.com, hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com,
        peterz@infradead.org, efault@gmx.de, fweisbec@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, eranian@google.com,
        tzanussi@gmail.com, efault@gmx.de, peterz@infradead.org,
        fweisbec@gmail.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf evsel: Support perf_evsel__open(cpus > 1 && threads > 1)
Message-ID: <tip-0252208eb52f6fe8731a47804eddc7ba93f60a87@git.kernel.org>
Git-Commit-ID: 0252208eb52f6fe8731a47804eddc7ba93f60a87
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 11 Jan 2011 11:11:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0252208eb52f6fe8731a47804eddc7ba93f60a87
Gitweb:     http://git.kernel.org/tip/0252208eb52f6fe8731a47804eddc7ba93f60a87
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Tue, 4 Jan 2011 11:55:27 -0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 10 Jan 2011 22:03:26 -0200

perf evsel: Support perf_evsel__open(cpus > 1 && threads > 1)

And a test for it:

[acme@felicio linux]$ perf test
 1: vmlinux symtab matches kallsyms: Ok
 2: detect open syscall event: Ok
 3: detect open syscall event on all cpus: Ok
[acme@felicio linux]$

Translating C the test does:

1. generates different number of open syscalls on each CPU
   by using sched_setaffinity
2. Verifies that the expected number of events is generated
   on each CPU

It works as expected.

LKML-Reference: <new-submission>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Tom Zanussi <tzanussi@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |  110 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.c   |   82 ++++++++++++++++++++-------------
 2 files changed, 159 insertions(+), 33 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index e12753f..ed56961 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -234,6 +234,7 @@ out:
 	return err;
 }
 
+#include "util/cpumap.h"
 #include "util/evsel.h"
 #include <sys/types.h>
 
@@ -321,6 +322,111 @@ out_thread_map_delete:
 	return err;
 }
 
+#include <sched.h>
+
+static int test__open_syscall_event_on_all_cpus(void)
+{
+	int err = -1, fd, cpu;
+	struct thread_map *threads;
+	struct cpu_map *cpus;
+	struct perf_evsel *evsel;
+	struct perf_event_attr attr;
+	unsigned int nr_open_calls = 111, i;
+	cpu_set_t *cpu_set;
+	size_t cpu_set_size;
+	int id = trace_event__id("sys_enter_open");
+
+	if (id < 0) {
+		pr_debug("is debugfs mounted on /sys/kernel/debug?\n");
+		return -1;
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
+		return -1;
+	}
+
+	cpu_set = CPU_ALLOC(cpus->nr);
+
+	if (cpu_set == NULL)
+		goto out_thread_map_delete;
+
+	cpu_set_size = CPU_ALLOC_SIZE(cpus->nr);
+	CPU_ZERO_S(cpu_set_size, cpu_set);
+
+	memset(&attr, 0, sizeof(attr));
+	attr.type = PERF_TYPE_TRACEPOINT;
+	attr.config = id;
+	evsel = perf_evsel__new(&attr, 0);
+	if (evsel == NULL) {
+		pr_debug("perf_evsel__new\n");
+		goto out_cpu_free;
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
+
+		CPU_SET(cpu, cpu_set);
+		sched_setaffinity(0, cpu_set_size, cpu_set);
+		for (i = 0; i < ncalls; ++i) {
+			fd = open("/etc/passwd", O_RDONLY);
+			close(fd);
+		}
+		CPU_CLR(cpu, cpu_set);
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
+	for (cpu = 0; cpu < cpus->nr; ++cpu) {
+		unsigned int expected;
+
+		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
+			pr_debug("perf_evsel__open_read_on_cpu\n");
+			goto out_close_fd;
+		}
+
+		expected = nr_open_calls + cpu;
+		if (evsel->counts->cpu[cpu].val != expected) {
+			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %Ld\n",
+				 expected, cpu, evsel->counts->cpu[cpu].val);
+			goto out_close_fd;
+		}
+	}
+
+	err = 0;
+out_close_fd:
+	perf_evsel__close_fd(evsel, 1, threads->nr);
+out_evsel_delete:
+	perf_evsel__delete(evsel);
+out_cpu_free:
+	CPU_FREE(cpu_set);
+out_thread_map_delete:
+	thread_map__delete(threads);
+	return err;
+}
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -334,6 +440,10 @@ static struct test {
 		.func = test__open_syscall_event,
 	},
 	{
+		.desc = "detect open syscall event on all cpus",
+		.func = test__open_syscall_event_on_all_cpus,
+	},
+	{
 		.func = NULL,
 	},
 };
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1a5591d..f5cfed6 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -127,59 +127,75 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	return 0;
 }
 
-int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus)
+static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
+			      struct thread_map *threads)
 {
-	int cpu;
+	int cpu, thread;
 
-	if (evsel->fd == NULL && perf_evsel__alloc_fd(evsel, cpus->nr, 1) < 0)
+	if (evsel->fd == NULL &&
+	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
 		return -1;
 
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
-		FD(evsel, cpu, 0) = sys_perf_event_open(&evsel->attr, -1,
-							cpus->map[cpu], -1, 0);
-		if (FD(evsel, cpu, 0) < 0)
-			goto out_close;
+		for (thread = 0; thread < threads->nr; thread++) {
+			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
+								     threads->map[thread],
+								     cpus->map[cpu], -1, 0);
+			if (FD(evsel, cpu, thread) < 0)
+				goto out_close;
+		}
 	}
 
 	return 0;
 
 out_close:
-	while (--cpu >= 0) {
-		close(FD(evsel, cpu, 0));
-		FD(evsel, cpu, 0) = -1;
-	}
+	do {
+		while (--thread >= 0) {
+			close(FD(evsel, cpu, thread));
+			FD(evsel, cpu, thread) = -1;
+		}
+		thread = threads->nr;
+	} while (--cpu >= 0);
 	return -1;
 }
 
-int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads)
+static struct {
+	struct cpu_map map;
+	int cpus[1];
+} empty_cpu_map = {
+	.map.nr	= 1,
+	.cpus	= { -1, },
+};
+
+static struct {
+	struct thread_map map;
+	int threads[1];
+} empty_thread_map = {
+	.map.nr	 = 1,
+	.threads = { -1, },
+};
+
+int perf_evsel__open(struct perf_evsel *evsel,
+		     struct cpu_map *cpus, struct thread_map *threads)
 {
-	int thread;
-
-	if (evsel->fd == NULL && perf_evsel__alloc_fd(evsel, 1, threads->nr))
-		return -1;
 
-	for (thread = 0; thread < threads->nr; thread++) {
-		FD(evsel, 0, thread) = sys_perf_event_open(&evsel->attr,
-							   threads->map[thread], -1, -1, 0);
-		if (FD(evsel, 0, thread) < 0)
-			goto out_close;
+	if (cpus == NULL) {
+		/* Work around old compiler warnings about strict aliasing */
+		cpus = &empty_cpu_map.map;
 	}
 
-	return 0;
+	if (threads == NULL)
+		threads = &empty_thread_map.map;
 
-out_close:
-	while (--thread >= 0) {
-		close(FD(evsel, 0, thread));
-		FD(evsel, 0, thread) = -1;
-	}
-	return -1;
+	return __perf_evsel__open(evsel, cpus, threads);
 }
 
-int perf_evsel__open(struct perf_evsel *evsel, 
-		     struct cpu_map *cpus, struct thread_map *threads)
+int perf_evsel__open_per_cpu(struct perf_evsel *evsel, struct cpu_map *cpus)
 {
-	if (threads == NULL)
-		return perf_evsel__open_per_cpu(evsel, cpus);
+	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
+}
 
-	return perf_evsel__open_per_thread(evsel, threads);
+int perf_evsel__open_per_thread(struct perf_evsel *evsel, struct thread_map *threads)
+{
+	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads);
 }
