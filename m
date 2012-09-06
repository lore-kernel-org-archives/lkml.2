Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759672Ab2IFTbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 15:31:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:50924 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629Ab2IFTbj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 15:31:39 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Joel Uckelman <joel@lightboxtechnologies.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 7/8] perf test: Add roundtrip test for hardware cache events
Date: Thu,  6 Sep 2012 16:31:20 -0300
Message-Id: <1346959881-22427-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1346959881-22427-1-git-send-email-acme@infradead.org>
References: <1346959881-22427-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

That nicely catches the problem reported by Joel Uckelman in
http://permalink.gmane.org/gmane.linux.kernel.perf.user/1016 :

  [root@sandy ~]# perf test
   1: vmlinux symtab matches kallsyms: Ok
   2: detect open syscall event: Ok
   3: detect open syscall event on all cpus: Ok
   4: read samples using the mmap interface: Ok
   5: parse events tests: Ok
   6: x86 rdpmc test: Ok
   7: Validate PERF_RECORD_* events & perf_sample fields: Ok
   8: Test perf pmu format parsing: Ok
   9: Test dso data interface: Ok
  10: roundtrip evsel->name check: FAILED!

  [root@sandy ~]# perf test -v 10
  10: roundtrip evsel->name check:
  --- start ---
  L1-dcache-misses != L1-dcache-load-misses
  L1-dcache-misses != L1-dcache-store-misses
  L1-dcache-misses != L1-dcache-prefetch-misses
  L1-icache-misses != L1-icache-load-misses
  L1-icache-misses != L1-icache-prefetch-misses
  LLC-misses != LLC-load-misses
  LLC-misses != LLC-store-misses
  LLC-misses != LLC-prefetch-misses
  dTLB-misses != dTLB-load-misses
  dTLB-misses != dTLB-store-misses
  dTLB-misses != dTLB-prefetch-misses
  iTLB-misses != iTLB-load-misses
  branch-misses != branch-load-misses
  node-misses != node-load-misses
  node-misses != node-store-misses
  node-misses != node-prefetch-misses
  ---- end ----
  roundtrip evsel->name check: FAILED!

  [root@sandy ~]#

Now lemme apply Jiri's fix and try it again...

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Joel Uckelman <joel@lightboxtechnologies.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-bbewtxw0rfipp5qy1j3jtg5d@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-test.c |   61 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 61 insertions(+)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index ba94fbe..cf33e50 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -1092,6 +1092,63 @@ static int test__perf_pmu(void)
 	return perf_pmu__test();
 }
 
+static int perf_evsel__roundtrip_cache_name_test(void)
+{
+	char name[128];
+	int type, op, err = 0, ret = 0, i, idx;
+	struct perf_evsel *evsel;
+        struct perf_evlist *evlist = perf_evlist__new(NULL, NULL);
+
+        if (evlist == NULL)
+                return -ENOMEM;
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!perf_evsel__is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
+									name, sizeof(name));
+				err = parse_events(evlist, name, 0);
+				if (err)
+					ret = err;
+			}
+		}
+	}
+
+	idx = 0;
+	evsel = perf_evlist__first(evlist);
+
+	for (type = 0; type < PERF_COUNT_HW_CACHE_MAX; type++) {
+		for (op = 0; op < PERF_COUNT_HW_CACHE_OP_MAX; op++) {
+			/* skip invalid cache type */
+			if (!perf_evsel__is_cache_op_valid(type, op))
+				continue;
+
+			for (i = 0; i < PERF_COUNT_HW_CACHE_RESULT_MAX; i++) {
+				__perf_evsel__hw_cache_type_op_res_name(type, op, i,
+									name, sizeof(name));
+				if (evsel->idx != idx)
+					continue;
+
+				++idx;
+
+				if (strcmp(perf_evsel__name(evsel), name)) {
+					pr_debug("%s != %s\n", perf_evsel__name(evsel), name);
+					ret = -1;
+				}
+
+				evsel = perf_evsel__next(evsel);
+			}
+		}
+	}
+
+	perf_evlist__delete(evlist);
+	return ret;
+}
+
 static int __perf_evsel__name_array_test(const char *names[], int nr_names)
 {
 	int i, err;
@@ -1138,6 +1195,10 @@ static int perf_evsel__roundtrip_name_test(void)
 	if (err)
 		ret = err;
 
+	err = perf_evsel__roundtrip_cache_name_test();
+	if (err)
+		ret = err;
+
 	return ret;
 }
 
-- 
1.7.9.2.358.g22243

