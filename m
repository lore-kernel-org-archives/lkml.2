Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755855Ab2ICAE5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:04:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64259 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755799Ab2ICAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:04:53 -0400
MIME-Version: 1.0
From: Irina Tirdea <irina.tirdea@gmail.com>
Date: Mon, 3 Sep 2012 03:04:32 +0300
Message-ID: <CANg8OWLL6gzUpZuq8YT2bSbT5=EVWejbpCX0TM8dt7mKXyZ9Yg@mail.gmail.com>
Subject: [PATCH] perf bench: fix assert when NDEBUG is defined
To: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Irina Tirdea <irina.tirdea@intel.com>

When NDEBUG is defined, the assert macro will be expanded to nothing.
Some assert calls used in perf are also including some functionality
(e.g. system calls), not only validity checks. Therefore, if NDEBUG is
defined, these functionality will be removed along with the assert.

The functionality of the program needs to be separated from the assert checks.
In perf, BUG_ON is also defined on assert, so we need to fix these statements
too.

Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
---
 tools/perf/bench/mem-memcpy.c |    8 +++++---
 tools/perf/bench/mem-memset.c |    8 +++++---
 tools/perf/bench/sched-pipe.c |    6 ++++--
 3 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index 02dad5d..bccb783 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -144,17 +144,19 @@ static double do_memcpy_gettimeofday(memcpy_t
fn, size_t len, bool prefault)
 {
 	struct timeval tv_start, tv_end, tv_diff;
 	void *src = NULL, *dst = NULL;
-	int i;
+	int i, ret;

 	alloc_mem(&src, &dst, len);

 	if (prefault)
 		fn(dst, src, len);

-	BUG_ON(gettimeofday(&tv_start, NULL));
+	ret = gettimeofday(&tv_start, NULL);
+	BUG_ON(ret);
 	for (i = 0; i < iterations; ++i)
 		fn(dst, src, len);
-	BUG_ON(gettimeofday(&tv_end, NULL));
+	ret = gettimeofday(&tv_end, NULL);
+	BUG_ON(ret);

 	timersub(&tv_end, &tv_start, &tv_diff);

diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 350cc95..e0702d2 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -139,17 +139,19 @@ static double do_memset_gettimeofday(memset_t
fn, size_t len, bool prefault)
 {
 	struct timeval tv_start, tv_end, tv_diff;
 	void *dst = NULL;
-	int i;
+	int i, ret;

 	alloc_mem(&dst, len);

 	if (prefault)
 		fn(dst, -1, len);

-	BUG_ON(gettimeofday(&tv_start, NULL));
+	ret = gettimeofday(&tv_start, NULL);
+	BUG_ON(ret);
 	for (i = 0; i < iterations; ++i)
 		fn(dst, i, len);
-	BUG_ON(gettimeofday(&tv_end, NULL));
+	ret = gettimeofday(&tv_end, NULL);
+	BUG_ON(ret);

 	timersub(&tv_end, &tv_start, &tv_diff);

diff --git a/tools/perf/bench/sched-pipe.c b/tools/perf/bench/sched-pipe.c
index 0c7454f..b35c94b 100644
--- a/tools/perf/bench/sched-pipe.c
+++ b/tools/perf/bench/sched-pipe.c
@@ -61,8 +61,10 @@ int bench_sched_pipe(int argc, const char **argv,
 	argc = parse_options(argc, argv, options,
 			     bench_sched_pipe_usage, 0);

-	assert(!pipe(pipe_1));
-	assert(!pipe(pipe_2));
+	ret = pipe(pipe_1);
+	assert(!ret);
+	ret = !pipe(pipe_2);
+	assert(!ret);

 	pid = fork();
 	assert(pid >= 0);
-- 
1.7.9.5
