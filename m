Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab1AWB4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 20:56:36 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:59183 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab1AWB4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 20:56:33 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 1/6] perf test: Fix build on older glibcs
Date: Sat, 22 Jan 2011 23:56:13 -0200
Message-Id: <1295747778-26186-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295747778-26186-1-git-send-email-acme@infradead.org>
References: <1295747778-26186-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Where we don't have CPU_ALLOC & friends. As the tools are being used in older
distros where the only allowed change are to replace the kernel, like RHEL4 and
5.

Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   33 +++++++++++++++++++--------------
 1 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 02958d6..0e01834 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -332,8 +332,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 	struct perf_evsel *evsel;
 	struct perf_event_attr attr;
 	unsigned int nr_open_calls = 111, i;
-	cpu_set_t *cpu_set;
-	size_t cpu_set_size;
+	cpu_set_t cpu_set;
 	int id = trace_event__id("sys_enter_open");
 
 	if (id < 0) {
@@ -353,13 +352,8 @@ static int test__open_syscall_event_on_all_cpus(void)
 		return -1;
 	}
 
-	cpu_set = CPU_ALLOC(cpus->nr);
 
-	if (cpu_set == NULL)
-		goto out_thread_map_delete;
-
-	cpu_set_size = CPU_ALLOC_SIZE(cpus->nr);
-	CPU_ZERO_S(cpu_set_size, cpu_set);
+	CPU_ZERO(&cpu_set);
 
 	memset(&attr, 0, sizeof(attr));
 	attr.type = PERF_TYPE_TRACEPOINT;
@@ -367,7 +361,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 	evsel = perf_evsel__new(&attr, 0);
 	if (evsel == NULL) {
 		pr_debug("perf_evsel__new\n");
-		goto out_cpu_free;
+		goto out_thread_map_delete;
 	}
 
 	if (perf_evsel__open(evsel, cpus, threads) < 0) {
@@ -379,9 +373,19 @@ static int test__open_syscall_event_on_all_cpus(void)
 
 	for (cpu = 0; cpu < cpus->nr; ++cpu) {
 		unsigned int ncalls = nr_open_calls + cpu;
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
 
-		CPU_SET_S(cpus->map[cpu], cpu_set_size, cpu_set);
-		if (sched_setaffinity(0, cpu_set_size, cpu_set) < 0) {
+		CPU_SET(cpus->map[cpu], &cpu_set);
+		if (sched_setaffinity(0, sizeof(cpu_set), &cpu_set) < 0) {
 			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
 				 cpus->map[cpu],
 				 strerror(errno));
@@ -391,7 +395,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 			fd = open("/etc/passwd", O_RDONLY);
 			close(fd);
 		}
-		CPU_CLR_S(cpus->map[cpu], cpu_set_size, cpu_set);
+		CPU_CLR(cpus->map[cpu], &cpu_set);
 	}
 
 	/*
@@ -407,6 +411,9 @@ static int test__open_syscall_event_on_all_cpus(void)
 	for (cpu = 0; cpu < cpus->nr; ++cpu) {
 		unsigned int expected;
 
+		if (cpus->map[cpu] >= CPU_SETSIZE)
+			continue;
+
 		if (perf_evsel__read_on_cpu(evsel, cpu, 0) < 0) {
 			pr_debug("perf_evsel__open_read_on_cpu\n");
 			goto out_close_fd;
@@ -425,8 +432,6 @@ out_close_fd:
 	perf_evsel__close_fd(evsel, 1, threads->nr);
 out_evsel_delete:
 	perf_evsel__delete(evsel);
-out_cpu_free:
-	CPU_FREE(cpu_set);
 out_thread_map_delete:
 	thread_map__delete(threads);
 	return err;
-- 
1.6.2.5

