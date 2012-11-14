Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624Ab2KNHlk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:41:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44328 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab2KNHli (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:41:38 -0500
Date: Tue, 13 Nov 2012 23:41:09 -0800
From: tip-bot for Zheng Liu <gnehzuil.liu@gmail.com>
Message-ID: <tip-12f8f74b2a4d26c4facfa7ef99487cf0930f6ef7@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, efault@gmx.de, gnehzuil.liu@gmail.com,
        wenqing.lz@taobao.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, vlee@twitter.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        efault@gmx.de, peterz@infradead.org, gnehzuil.liu@gmail.com,
        wenqing.lz@taobao.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, vlee@twitter.com
In-Reply-To: <1352422726-31114-1-git-send-email-vlee@twitter.com>
References: <1352422726-31114-1-git-send-email-vlee@twitter.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test: fix a build error on builtin-test
Git-Commit-ID: 12f8f74b2a4d26c4facfa7ef99487cf0930f6ef7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 13 Nov 2012 23:41:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  12f8f74b2a4d26c4facfa7ef99487cf0930f6ef7
Gitweb:     http://git.kernel.org/tip/12f8f74b2a4d26c4facfa7ef99487cf0930f6ef7
Author:     Zheng Liu <gnehzuil.liu@gmail.com>
AuthorDate: Thu, 8 Nov 2012 16:58:46 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 9 Nov 2012 11:34:49 -0300

perf test: fix a build error on builtin-test

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
 1 files changed, 12 insertions(+), 26 deletions(-)

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
