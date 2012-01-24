Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2AXXI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:08:26 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59161 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752716Ab2AXXIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:08:14 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jan Beulich <JBeulich@suse.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jan Beulich <jbeulich@suse.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/9] perf bench: Allow passing an iteration count to "bench mem mem{cpy,set}"
Date: Tue, 24 Jan 2012 21:07:58 -0200
Message-Id: <1327446481-5505-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.rc2.1.g69204
In-Reply-To: <1327446481-5505-1-git-send-email-acme@infradead.org>
References: <1327446481-5505-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

"perf stat ... perf bench mem mem..." is pretty meaningless when using
small block sizes (as the overhead of the invocation of each test run
basically hides the actual test result in the noise). Repeating the
actually interesting function's invocation a number of times allows the
results to become meaningful.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/4F16D767020000780006D738@nat28.tlf.novell.com
Signed-off-by: Jan Beulich <jbeulich@suse.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/mem-memcpy.c |   11 +++++++++--
 tools/perf/bench/mem-memset.c |   11 +++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index db82021..6ad2b1c 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -24,6 +24,7 @@
 
 static const char	*length_str	= "1MB";
 static const char	*routine	= "default";
+static int		iterations	= 1;
 static bool		use_clock;
 static int		clock_fd;
 static bool		only_prefault;
@@ -35,6 +36,8 @@ static const struct option options[] = {
 		    "available unit: B, MB, GB (upper and lower)"),
 	OPT_STRING('r', "routine", &routine, "default",
 		    "Specify routine to copy"),
+	OPT_INTEGER('i', "iterations", &iterations,
+		    "repeat memcpy() invocation this number of times"),
 	OPT_BOOLEAN('c', "clock", &use_clock,
 		    "Use CPU clock for measuring"),
 	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
@@ -121,6 +124,7 @@ static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
 {
 	u64 clock_start = 0ULL, clock_end = 0ULL;
 	void *src = NULL, *dst = NULL;
+	int i;
 
 	alloc_mem(&src, &dst, len);
 
@@ -128,7 +132,8 @@ static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
 		fn(dst, src, len);
 
 	clock_start = get_clock();
-	fn(dst, src, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
 	clock_end = get_clock();
 
 	free(src);
@@ -140,6 +145,7 @@ static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
 {
 	struct timeval tv_start, tv_end, tv_diff;
 	void *src = NULL, *dst = NULL;
+	int i;
 
 	alloc_mem(&src, &dst, len);
 
@@ -147,7 +153,8 @@ static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
 		fn(dst, src, len);
 
 	BUG_ON(gettimeofday(&tv_start, NULL));
-	fn(dst, src, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
 	BUG_ON(gettimeofday(&tv_end, NULL));
 
 	timersub(&tv_end, &tv_start, &tv_diff);
diff --git a/tools/perf/bench/mem-memset.c b/tools/perf/bench/mem-memset.c
index 9c0c6f0..59d4933 100644
--- a/tools/perf/bench/mem-memset.c
+++ b/tools/perf/bench/mem-memset.c
@@ -24,6 +24,7 @@
 
 static const char	*length_str	= "1MB";
 static const char	*routine	= "default";
+static int		iterations	= 1;
 static bool		use_clock;
 static int		clock_fd;
 static bool		only_prefault;
@@ -35,6 +36,8 @@ static const struct option options[] = {
 		    "available unit: B, MB, GB (upper and lower)"),
 	OPT_STRING('r', "routine", &routine, "default",
 		    "Specify routine to copy"),
+	OPT_INTEGER('i', "iterations", &iterations,
+		    "repeat memset() invocation this number of times"),
 	OPT_BOOLEAN('c', "clock", &use_clock,
 		    "Use CPU clock for measuring"),
 	OPT_BOOLEAN('o', "only-prefault", &only_prefault,
@@ -117,6 +120,7 @@ static u64 do_memset_clock(memset_t fn, size_t len, bool prefault)
 {
 	u64 clock_start = 0ULL, clock_end = 0ULL;
 	void *dst = NULL;
+	int i;
 
 	alloc_mem(&dst, len);
 
@@ -124,7 +128,8 @@ static u64 do_memset_clock(memset_t fn, size_t len, bool prefault)
 		fn(dst, -1, len);
 
 	clock_start = get_clock();
-	fn(dst, 0, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
 	clock_end = get_clock();
 
 	free(dst);
@@ -135,6 +140,7 @@ static double do_memset_gettimeofday(memset_t fn, size_t len, bool prefault)
 {
 	struct timeval tv_start, tv_end, tv_diff;
 	void *dst = NULL;
+	int i;
 
 	alloc_mem(&dst, len);
 
@@ -142,7 +148,8 @@ static double do_memset_gettimeofday(memset_t fn, size_t len, bool prefault)
 		fn(dst, -1, len);
 
 	BUG_ON(gettimeofday(&tv_start, NULL));
-	fn(dst, 0, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
 	BUG_ON(gettimeofday(&tv_end, NULL));
 
 	timersub(&tv_end, &tv_start, &tv_diff);
-- 
1.7.9.rc2.1.g69204

