Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946071Ab2LNXHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:07:49 -0500
Received: from mail.kernel.org ([198.145.19.201]:41402 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946057Ab2LNXHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:07:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Vinson Lee <vlee@twitter.com>, Zheng Liu <wenqing.lz@taobao.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [ 24/27] perf test: fix a build error on builtin-test
Date: Fri, 14 Dec 2012 15:01:37 -0800
Message-Id: <20121214222256.437181250@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222251.229078963@linuxfoundation.org>
References: <20121214222251.229078963@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zheng Liu <gnehzuil.liu@gmail.com>

commit 12f8f74b2a4d26c4facfa7ef99487cf0930f6ef7 upstream.

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
Link: http://lkml.kernel.org/r/1352422726-31114-1-git-send-email-vlee@twitter.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/builtin-test.c |   38 ++++++++++++--------------------------
 1 file changed, 12 insertions(+), 26 deletions(-)

--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -604,19 +604,13 @@ out_free_threads:
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
@@ -626,19 +620,14 @@ realloc:
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
 
@@ -653,8 +642,8 @@ static int test__PERF_RECORD(void)
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
@@ -718,8 +707,7 @@ static int test__PERF_RECORD(void)
 	evsel->attr.sample_type |= PERF_SAMPLE_TIME;
 	perf_evlist__config_attrs(evlist, &opts);
 
-	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask,
-					    &cpu_mask_size);
+	err = sched__get_first_possible_cpu(evlist->workload.pid, &cpu_mask);
 	if (err < 0) {
 		pr_debug("sched__get_first_possible_cpu: %s\n", strerror(errno));
 		goto out_delete_evlist;
@@ -730,9 +718,9 @@ static int test__PERF_RECORD(void)
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
@@ -916,8 +904,6 @@ found_exit:
 	}
 out_err:
 	perf_evlist__munmap(evlist);
-out_free_cpu_mask:
-	CPU_FREE(cpu_mask);
 out_delete_evlist:
 	perf_evlist__delete(evlist);
 out:


