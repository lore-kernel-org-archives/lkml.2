Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab1ATLoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 06:44:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755056Ab1ATLoB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 06:44:01 -0500
Date: Thu, 20 Jan 2011 19:47:07 +0800
From: Han Pingtian <phan@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf tools: use cpu_map->[cpu] when setting affinity
Message-ID: <20110120114707.GA11781@hpt.nay.redhat.com>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 tools/perf/builtin-test.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 4b0ef5f..66a334f 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -382,13 +382,18 @@ static int test__open_syscall_event_on_all_cpus(void)
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
@@ -415,7 +420,7 @@ static int test__open_syscall_event_on_all_cpus(void)
 		expected = nr_open_calls + cpu;
 		if (evsel->counts->cpu[cpu].val != expected) {
 			pr_debug("perf_evsel__read_on_cpu: expected to intercept %d calls on cpu %d, got %Ld\n",
-				 expected, cpu, evsel->counts->cpu[cpu].val);
+				 expected, cpus->map[cpu], evsel->counts->cpu[cpu].val);
 			err = -1;
 		}
 	}
-- 
1.7.1
