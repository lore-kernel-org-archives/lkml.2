Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103Ab1AXXiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 18:38:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615Ab1AXXiI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 18:38:08 -0500
Date: Tue, 25 Jan 2011 07:39:00 +0800
From: Han Pingtian <phan@redhat.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perftools: Fix return values checking and build on older
 glibc
Message-ID: <20110124233900.GA3443@epc900.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just like 57b84e53171ce, port the fixing to test__open_syscall_event_on_all_cpus() to
test__basic_mmap(). And check to right return values.

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 tools/perf/builtin-test.c |   24 +++++++-----------------
 1 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 4b0ef5f..4fac856 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -456,8 +456,7 @@ static int test__basic_mmap(void)
 		.sample_type	= PERF_SAMPLE_ID,
 		.watermark	= 0,
 	};
-	cpu_set_t *cpu_set;
-	size_t cpu_set_size;
+	cpu_set_t cpu_set;
 	const char *syscall_names[] = { "getsid", "getppid", "getpgrp",
 					"getpgid", };
 	pid_t (*syscalls[])(void) = { (void *)getsid, getppid, getpgrp,
@@ -488,26 +487,17 @@ static int test__basic_mmap(void)
 	}
 
 	cpus = cpu_map__new(NULL);
-	if (threads == NULL) {
-		pr_debug("thread_map__new\n");
+	if (cpus == NULL) {
+		pr_debug("cpu_map__new\n");
 		goto out_free_threads;
 	}
 
-	cpu_set = CPU_ALLOC(cpus->nr);
-
-	if (cpu_set == NULL) {
-		pr_debug("thread_map__new\n");
-		goto out_free_cpus;
-	}
-
-	cpu_set_size = CPU_ALLOC_SIZE(cpus->nr);
-	CPU_ZERO_S(cpu_set_size, cpu_set);
-	CPU_SET(cpus->map[0], cpu_set);
-	sched_setaffinity(0, cpu_set_size, cpu_set);
-	CPU_FREE(cpu_set);
+	CPU_ZERO(&cpu_set);
+	CPU_SET(cpus->map[0], &cpu_set);
+	sched_setaffinity(0, sizeof(cpu_set), &cpu_set);
 
 	evlist = perf_evlist__new();
-	if (threads == NULL) {
+	if (evlist == NULL) {
 		pr_debug("perf_evlist__new\n");
 		goto out_free_cpus;
 	}
-- 
1.7.3.4
