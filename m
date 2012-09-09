Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705Ab2IIIxA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 04:53:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab2IIIw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 04:52:58 -0400
Date: Sun, 9 Sep 2012 01:52:28 -0700
From: tip-bot for Irina Tirdea <irina.tirdea@intel.com>
Message-ID: <tip-8bf98b89688c3d7ec071bf26d49761e38d846b47@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, rostedt@goodmis.org, irina.tirdea@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        penberg@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        rostedt@goodmis.org, irina.tirdea@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1347082551-2394-1-git-send-email-irina.tirdea@intel.com>
References: <1347082551-2394-1-git-send-email-irina.tirdea@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench: fix assert when NDEBUG is defined
Git-Commit-ID: 8bf98b89688c3d7ec071bf26d49761e38d846b47
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 09 Sep 2012 01:52:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8bf98b89688c3d7ec071bf26d49761e38d846b47
Gitweb:     http://git.kernel.org/tip/8bf98b89688c3d7ec071bf26d49761e38d846b47
Author:     Irina Tirdea <irina.tirdea@intel.com>
AuthorDate: Sat, 8 Sep 2012 08:35:51 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 8 Sep 2012 13:18:54 -0300

perf bench: fix assert when NDEBUG is defined

When NDEBUG is defined, the assert macro will be expanded to nothing.
Some assert calls used in perf are also including some functionality
(e.g. system calls), not only validity checks. Therefore, if NDEBUG is
defined, this functionality will be removed along with the assert.  Perf
also defines BUG_ON based on assert, so it has the same problem.

Define BUG_ON so that the condition will be executed when NDEBUG is
defined.  Replace the assert statements that have these side effects
with BUG_ON.

For defining BUG_ON, use "if (cond) {}" insted of "if (cond) ;" because
in the latter case build fails with "error: suggest braces around empty
body in an ‘if’ statement [-Werror=empty-body]"

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Reviewed-by: Pekka Enberg <penberg@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347082551-2394-1-git-send-email-irina.tirdea@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
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
