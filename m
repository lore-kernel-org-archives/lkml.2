Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab1AVPUP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Jan 2011 10:20:15 -0500
Received: from hera.kernel.org ([140.211.167.34]:48576 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab1AVPUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Jan 2011 10:20:14 -0500
Date: Sat, 22 Jan 2011 15:19:55 GMT
From: tip-bot for Han Pingtian <phan@redhat.com>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, phan@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, phan@redhat.com, tglx@linutronix.de
In-Reply-To: <20110120114707.GA11781@hpt.nay.redhat.com>
References: <20110120114707.GA11781@hpt.nay.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf test: Use cpu_map->[cpu] when setting affinity
Message-ID: <tip-ffb5e0fb44d0829021a51f972df90166bc9b700e@git.kernel.org>
Git-Commit-ID: ffb5e0fb44d0829021a51f972df90166bc9b700e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 22 Jan 2011 15:19:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ffb5e0fb44d0829021a51f972df90166bc9b700e
Gitweb:     http://git.kernel.org/tip/ffb5e0fb44d0829021a51f972df90166bc9b700e
Author:     Han Pingtian <phan@redhat.com>
AuthorDate: Thu, 20 Jan 2011 19:47:07 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 21 Jan 2011 16:44:14 -0200

perf test: Use cpu_map->[cpu] when setting affinity

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
