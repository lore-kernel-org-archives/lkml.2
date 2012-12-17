Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513Ab2LQHZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:25:18 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64820 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218Ab2LQHZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:25:17 -0500
X-AuditID: 9c930197-b7c5bae000000e31-17-50cec8db663c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH] perf test: Check python path on attr test
Date: Mon, 17 Dec 2012 16:25:01 +0900
Message-Id: <1355729101-31317-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current perf test code tries to execute python version 2 in order to
test attributes on perf_event_open syscall.  However it's not default
python version anymore a system can have python v3 only or v2 with a
different name (e.g. python2).  So if there's no such python
interpreter with the name 'python', the test would fail like this
(yes, it's happened on my new archlinux laptop :).

13: struct perf_event_attr setup                 :sh: python: command not found
 FAILED!

As we can pass name of the python interpreter on make, use it for
the attr test also.

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile     | 2 +-
 tools/perf/tests/attr.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 7d6d2846477b..2e9a287b3a23 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -952,7 +952,7 @@ $(OUTPUT)util/exec_cmd.o: util/exec_cmd.c $(OUTPUT)PERF-CFLAGS
 
 $(OUTPUT)tests/attr.o: tests/attr.c $(OUTPUT)PERF-CFLAGS
 	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
-		'-DBINDIR="$(bindir_SQ)"' \
+		'-DBINDIR="$(bindir_SQ)"' -DPYTHON='"$(PYTHON_WORD)"' \
 		$<
 
 $(OUTPUT)util/config.o: util/config.c $(OUTPUT)PERF-CFLAGS
diff --git a/tools/perf/tests/attr.c b/tools/perf/tests/attr.c
index 25638a986257..6a6be5ea1311 100644
--- a/tools/perf/tests/attr.c
+++ b/tools/perf/tests/attr.c
@@ -146,7 +146,7 @@ static int run_dir(const char *d, const char *perf)
 {
 	char cmd[3*PATH_MAX];
 
-	snprintf(cmd, 3*PATH_MAX, "python %s/attr.py -d %s/attr/ -p %s %s",
+	snprintf(cmd, 3*PATH_MAX, PYTHON " %s/attr.py -d %s/attr/ -p %s %s",
 		 d, d, perf, verbose ? "-v" : "");
 
 	return system(cmd);
-- 
1.7.11.7

