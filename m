Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933109Ab2IGGRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 02:17:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55290 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932381Ab2IGGRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 02:17:03 -0400
Date: Thu, 6 Sep 2012 23:16:41 -0700
From: tip-bot for Arnaldo Carvalho de Melo <acme@redhat.com>
Message-ID: <tip-bbewtxw0rfipp5qy1j3jtg5d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        acme@redhat.com, hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        efault@gmx.de, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        joel@lightboxtechnologies.com
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, efault@gmx.de,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        joel@lightboxtechnologies.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf test:
  Add roundtrip test for hardware cache events
Git-Commit-ID: 49f20d723e25a221fbcf1cbf4e51bb2942326e4f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 06 Sep 2012 23:16:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  49f20d723e25a221fbcf1cbf4e51bb2942326e4f
Gitweb:     http://git.kernel.org/tip/49f20d723e25a221fbcf1cbf4e51bb2942326e4f
Author:     Arnaldo Carvalho de Melo <acme@redhat.com>
AuthorDate: Thu, 6 Sep 2012 14:55:44 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 6 Sep 2012 14:55:44 -0300

perf test: Add roundtrip test for hardware cache events

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
 1 files changed, 61 insertions(+), 0 deletions(-)

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
 
