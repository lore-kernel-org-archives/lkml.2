Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757171Ab2KIVrm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 16:47:42 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48164 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab2KIVn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 16:43:27 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Zheng Liu <gnehzuil.liu@gmail.com>,
        Vinson Lee <vlee@twitter.com>, Zheng Liu <wenqing.lz@taobao.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, stable@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/21] perf test: fix a build error on builtin-test
Date: Fri,  9 Nov 2012 18:43:02 -0300
Message-Id: <1352497390-17716-14-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1352497390-17716-1-git-send-email-acme@infradead.org>
References: <1352497390-17716-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="utf-8"
X-MIME-Error: demime acl condition: double headers (content-type, content-disposition or content-transfer-encoding)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zheng Liu <gnehzuil.liu@gmail.com>

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

Signed-off-by: Vinson Lee <vlee@twitter.com>
Signed-off-by: Zheng Liu <wenqing.lz@taobao.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Vinson Lee <vlee@twitter.com>
Cc: Zheng Liu <wenqing.lz@taobao.com>
Cc: stable@vger.kernel.org
Link: http://lkml.kernel.org/r/1352422726-31114-1-git-send-email-vlee@twitter.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/tests/builtin-test.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index b5a544d..5d4354e 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -605,19 +605,13 @@ out_free_threads:
 #undef nsyscalls
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
@@ -627,19 +621,14 @@ realloc:
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
 
@@ -654,8 +643,8 @@ static int test__PERF_RECORD(void)
 		.freq	    = 10,
 		.mmap_pages = 256,
 	};
-	cpu_set_t *cpu_mask = NULL;
-	size_t cpu_mask_size = 0;
+	cpu_set_t cpu_mask;
+	size_t cpu_mask_size = sizeof(cpu_mask);
 	struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
 	struct perf_evsel *evsel;
 	struct perf_sample sample;
@@ -719,8 +708,7 @@ static int test__PERF_RECORD(void)
 	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
 	perf_evlist__config_attrs(evlist, &opts);
 
-	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
-					    &cpu_mask_size);
+	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
 		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
 		goto out_delete_evlist;
@@ -731,9 +719,9 @@ static int test__PERF_RECORD(void)
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
@@ -917,8 +905,6 @@ found_exit:
 	}
 out_err:
 	perf_evlist__munmap(evlist);
-out_free_cpu_mask:
-	CPU_FREE(cpu_mask);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:
-- 
1.7.9.2.358.g22243

