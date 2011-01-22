Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab1AVBQP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 20:16:15 -0500
Received: from casper.infradead.org ([85.118.1.10]:47632 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927Ab1AVBQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 20:16:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Han Pingtian <phan@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/2] perf test: Use cpu_map->[cpu] when setting affinity
Date: Fri, 21 Jan 2011 23:16:08 -0200
Message-Id: <1295658968-23217-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1295658968-23217-1-git-send-email-acme@infradead.org>
References: <1295658968-23217-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Han Pingtian <phan@redhat.com>

When some of CPUs are offline:

 # cat /sys/devices/system/cpu/online
 0,6-31

perf test will fail on #3 testcase:

   3: detect open syscall event on all cpus:
   --- start ---
   perf_evsel__read_on_cpu: expected to intercept 111 calls on cpu 0, got 681
   perf_evsel__read_on_cpu: expected to intercept 112 calls on cpu 1, got 117
   perf_evsel__read_on_cpu: expected to intercept 113 calls on cpu 2, got 118
   perf_evsel__read_on_cpu: expected to intercept 114 calls on cpu 3, got 119
   perf_evsel__read_on_cpu: expected to intercept 115 calls on cpu 4, got 120
   perf_evsel__read_on_cpu: expected to intercept 116 calls on cpu 5, got 121
   perf_evsel__read_on_cpu: expected to intercept 117 calls on cpu 6, got 122
   perf_evsel__read_on_cpu: expected to intercept 118 calls on cpu 7, got 123
   perf_evsel__read_on_cpu: expected to intercept 119 calls on cpu 8, got 124
   perf_evsel__read_on_cpu: expected to intercept 120 calls on cpu 9, got 125
   perf_evsel__read_on_cpu: expected to intercept 121 calls on cpu 10, got 126
   ....

This patch try to use 'cpus->map[cpu]' when setting cpu affinity, and
will check the return code of sched_setaffinity()

LKML-Reference: <20110120114707.GA11781@hpt.nay.redhat.com>
Signed-off-by: Han Pingtian <phan@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index ed56961..02958d6 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -380,13 +380,18 @@ static int test__open_syscall_event_on_all_cpus(void)
 	for (cpu = 0; cpu < cpus->nr; ++cpu) {
 		unsigned int ncalls = nr_open_calls + cpu;
 
-		CPU_SET(cpu, cpu_set);
-		sched_setaffinity(0, cpu_set_size, cpu_set);
+		CPU_SET_S(cpus->map[cpu], cpu_set_size, cpu_set);
+		if (sched_setaffinity(0, cpu_set_size, cpu_set) < 0) {
+			pr_debug("sched_setaffinity() failed on CPU %d: %s ",
+				 cpus->map[cpu],
+				 strerror(errno));
+			goto out_close_fd;
+		}
 		for (i = 0; i < ncalls; ++i) {
 			fd = open("/etc/passwd", O_RDONLY);
 			close(fd);
 		}
-		CPU_CLR(cpu, cpu_set);
+		CPU_CLR_S(cpus->map[cpu], cpu_set_size, cpu_set);
 	}
 
 	/*
@@ -410,7 +415,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		expected = nr_open_calls + cpu;
 		if (evsel->counts->cpu[cpu].val != expected) {
 			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %Ld\n",
-				 expected, cpu, evsel->counts->cpu[cpu].val);
+				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
 			goto out_close_fd;
 		}
 	}
-- 
1.6.2.5

