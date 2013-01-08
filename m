Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab3AHJjf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 04:39:35 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:42067 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3AHJjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 04:39:32 -0500
X-AuditID: 9c93016f-b7b54ae000000e9e-0d-50ebe9525312
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Subject: [PATCH] perf bench: Flush stdout before starting bench suite
Date: Tue,  8 Jan 2013 18:39:26 +0900
Message-Id: <1357637966-8216-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

perf bench prints header message for bench suite before starting the
benchmark.  However if the stdout is redirected to a file and bench
suite forks child processes this (and possibly other debugging
messages too) will be repeated multiple times.

  $ perf bench sched messaging
  # Running sched/messaging benchmark...
  # 20 sender and receiver processes per group
  # 10 groups == 400 processes run

       Total time: 0.100 [sec]

  $ perf bench sched messaging > result.txt
  $ wc -l result.txt
  391

In this file, there were so many "Running sched/messaging benchmark..."
lines.  This was because stdout is converted to fully-buffered due to
the redirection and inherited child processes.  Other lines are printed
after reaping all those tasks.

So fix it by flushing stdout before starting bench suites.

Cc: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-bench.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/builtin-bench.c b/tools/perf/builtin-bench.c
index cae9a5fd2ecf..afd1255a632f 100644
--- a/tools/perf/builtin-bench.c
+++ b/tools/perf/builtin-bench.c
@@ -159,6 +159,7 @@ static void all_suite(struct bench_subsys *subsys)	  /* FROM HERE */
 		printf("# Running %s/%s benchmark...\n",
 		       subsys->name,
 		       suites[i].name);
+		fflush(stdout);
 
 		argv[1] = suites[i].name;
 		suites[i].fn(1, argv, NULL);
@@ -225,6 +226,7 @@ int cmd_bench(int argc, const char **argv, const char *prefix __maybe_unused)
 				printf("# Running %s/%s benchmark...\n",
 				       subsystems[i].name,
 				       subsystems[i].suites[j].name);
+			fflush(stdout);
 			status = subsystems[i].suites[j].fn(argc - 1,
 							    argv + 1, prefix);
 			goto end;
-- 
1.7.11.7

