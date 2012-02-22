Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab2BVIxY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 03:53:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:37319 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab2BVIxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 03:53:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gnehzuil.liu@gmail.com designates 10.50.15.129 as permitted sender) smtp.mail=gnehzuil.liu@gmail.com; dkim=pass header.i=gnehzuil.liu@gmail.com
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Zheng Liu <wenqing.lz@taobao.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: =?UTF-8?q?=5BPATCH=5D=20perf=20test=3A=20fix=20a=20build=20error=20on=20builtin-test?=
Date: Wed, 22 Feb 2012 16:57:45 +0800
Message-Id: <1329901065-16313-1-git-send-email-wenqing.lz@taobao.com>
X-Mailer: git-send-email 1.7.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently I build perf and get a build error on builtin-test.c. The error is as
following:

$ make
    CC perf.o
    CC builtin-test.o
cc1: warnings being treated as errors
builtin-test.c: In function ‘sched__get_first_possible_cpu’:
builtin-test.c:977: warning: implicit declaration of function ‘CPU_ALLOC’
builtin-test.c:977: warning: nested extern declaration of ‘CPU_ALLOC’
builtin-test.c:977: warning: assignment makes pointer from integer without a cast
builtin-test.c:978: warning: implicit declaration of function ‘CPU_ALLOC_SIZE’
builtin-test.c:978: warning: nested extern declaration of ‘CPU_ALLOC_SIZE’
builtin-test.c:979: warning: implicit declaration of function ‘CPU_ZERO_S’
builtin-test.c:979: warning: nested extern declaration of ‘CPU_ZERO_S’
builtin-test.c:982: warning: implicit declaration of function ‘CPU_FREE’
builtin-test.c:982: warning: nested extern declaration of ‘CPU_FREE’
builtin-test.c:992: warning: implicit declaration of function ‘CPU_ISSET_S’
builtin-test.c:992: warning: nested extern declaration of ‘CPU_ISSET_S’
builtin-test.c:998: warning: implicit declaration of function ‘CPU_CLR_S’
builtin-test.c:998: warning: nested extern declaration of ‘CPU_CLR_S’
make: *** [builtin-test.o] Error 1

This problem is introduced in 3e7c439a. CPU_ALLOC and related macros are
missing in sched__get_first_possible_cpu function. In 54489c18, commiter
mentioned that CPU_ALLOC has been removed. So CPU_ALLOC calls in this
function are removed to let perf to be built.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
---
 tools/perf/builtin-test.c |   38 ++++++++++++--------------------------
 1 files changed, 12 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 3854e86..ade59e1 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -967,19 +967,13 @@ static int test__parse_events(void)
 	return ret;
 }
 
-static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t **maskp,
-					 size_t *sizep)
+static int sched__get_first_possible_cpu(pid_t pid, cpu_set_t *maskp)
 {
-	cpu_set_t *mask;
-	size_t size;
 	int i, cpu = -1, nrcpus = 1024;
 realloc:
-	mask = CPU_ALLOC(nrcpus);
-	size = CPU_ALLOC_SIZE(nrcpus);
-	CPU_ZERO_S(size, mask);
+	CPU_ZERO(maskp);
 
-	if (sched_getaffinity(pid, size, mask) == -1) {
-		CPU_FREE(mask);
+	if (sched_getaffinity(pid, sizeof(*maskp), maskp) == -1) {
 		if (errno == EINVAL && nrcpus < (1024 << 8)) {
 			nrcpus = nrcpus << 2;
 			goto realloc;
@@ -989,19 +983,14 @@ realloc:
 	}
 
 	for (i = 0; i < nrcpus; i++) {
-		if (CPU_ISSET_S(i, size, mask)) {
-			if (cpu == -1) {
+		if (CPU_ISSET(i, maskp)) {
+			if (cpu == -1)
 				cpu = i;
-				*maskp = mask;
-				*sizep = size;
-			} else
-				CPU_CLR_S(i, size, mask);
+			else
+				CPU_CLR(i, maskp);
 		}
 	}
 
-	if (cpu == -1)
-		CPU_FREE(mask);
-
 	return cpu;
 }
 
@@ -1015,8 +1004,8 @@ static int test__PERF_RECORD(void)
 		.mmap_pages = 256,
 		.sample_id_all_avail = true,
 	};
-	cpu_set_t *cpu_mask = NULL;
-	size_t cpu_mask_size = 0;
+	cpu_set_t cpu_mask;
+	size_t cpu_mask_size = sizeof(cpu_mask);
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
 	struct perf_evsel *evsel;
 	struct perf_sample sample;
@@ -1081,8 +1070,7 @@ static int test__PERF_RECORD(void)
 	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
 	perf_evlist__config_attrs(evlist, &opts);
 
-	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
-					    &cpu_mask_size);
+	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
 		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
 		goto out_delete_evlist;
@@ -1093,9 +1081,9 @@ static int test__PERF_RECORD(void)
 	/*
 	 * So that we can check perf_sample.cpu on all the samples.
 	 */
-	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, cpu_mask) < 0) {
+	if (sched_setaffinity(evlist->workload.pid, cpu_mask_size, &cpu_mask) < 0) {
 		pr_debug("sched_setaffinity: %s\n", strerror(errno));
-		goto out_free_cpu_mask;
+		goto out_delete_evlist;
 	}
 
 	/*
@@ -1288,8 +1276,6 @@ found_exit:
 	}
 out_err:
 	perf_evlist__munmap(evlist);
-out_free_cpu_mask:
-	CPU_FREE(cpu_mask);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
-- 
1.7.4.1

