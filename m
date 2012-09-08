Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321Ab2IHFgZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 01:36:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:57192 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2IHFgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 01:36:23 -0400
From: Irina Tirdea <irina.tirdea@gmail.com>
To: mingo@redhat.com, acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        rostedt@goodmis.org
Cc: paulus@samba.org, dsahern@gmail.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, Irina Tirdea <irina.tirdea@intel.com>
Subject: [PATCH v3] perf bench: fix assert when NDEBUG is defined
Date: Sat,  8 Sep 2012 08:35:51 +0300
Message-Id: <1347082551-2394-1-git-send-email-irina.tirdea@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

When NDEBUG is defined, the assert macro will be expanded to nothing.
Some assert calls used in perf are also including some functionality
(e.g. system calls), not only validity checks. Therefore, if NDEBUG is
defined, this functionality will be removed along with the assert.
Perf also defines BUG_ON based on assert, so it has the same problem.

Define BUG_ON so that the condition will be executed when NDEBUG is defined.
Replace the assert statements that have these side effects with BUG_ON.

For defining BUG_ON, use "if (cond) {}" insted of "if (cond) ;" because in
the latter case build fails with "error: suggest braces around empty body in
an ‘if’ statement [-Werror=empty-body]"

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---

Changes in v3:
() ammend commit message with Suggested-by line

Changes in v2:
() redefine BUG_ON for NDEBUG instead of avoiding side-effects
() replace assert with BUG_ON

v1 change:
() https://lkml.org/lkml/2012/9/2/189 

 tools/perf/bench/sched-pipe.c          |    6 +++---
 tools/perf/util/include/linux/kernel.h |    4 ++++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 0c7454f..15911e9 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -56,13 +56,13 @@ int bench_sched_pipe(int argc, const char **argv,
 	 * causes error in building environment for perf
 	 */
 	int __used ret, wait_stat;
-	pid_t pid, retpid;
+	pid_t pid, retpid __used;
 
 	argc = parse_options(argc, argv, options,
 			     bench_sched_pipe_usage, 0);
 
-	assert(!pipe(pipe_1));
-	assert(!pipe(pipe_2));
+	BUG_ON(pipe(pipe_1));
+	BUG_ON(pipe(pipe_2));
 
 	pid = fork();
 	assert(pid >= 0);
diff --git a/tools/perf/util/include/linux/kernel.h b/tools/perf/util/include/linux/kernel.h
index b6842c1..4af9a10 100644
--- a/tools/perf/util/include/linux/kernel.h
+++ b/tools/perf/util/include/linux/kernel.h
@@ -47,8 +47,12 @@
 #endif
 
 #ifndef BUG_ON
+#ifdef NDEBUG
+#define BUG_ON(cond) do { if (cond) {} } while (0)
+#else
 #define BUG_ON(cond) assert(!(cond))
 #endif
+#endif
 
 /*
  * Both need more care to handle endianness
-- 
1.7.9.5

