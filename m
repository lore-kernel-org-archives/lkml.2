Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab2ARNaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 08:30:06 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:30114 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397Ab2ARNaE convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:5:1>);
	Wed, 18 Jan 2012 08:30:04 -0500
Message-Id: <4F16D767020000780006D738@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 18 Jan 2012 13:29:59 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <acme@ghostprotocols.net>,
        <paulus@samba.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: [PATCH 4/4] perf/x86-64: allow passing an iteration count to
 "bench mem mem{cpy,set}"
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"perf stat ... perf bench mem mem..." is pretty meaningless when using
small block sizes (as the overhead of the invocation of each test run
basically hides the actual test result in the noise). Repeating the
actually interesting function's invocation a number of times allows the
results to become meaningful.

Signed-off-by: Jan Beulich <jbeulich@suse.com>

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
@@ -121,6 +124,7 @@ static u64 do_memcpy_clock(memcpy_t fn, 
 {
 	u64 clock_start = 0ULL, clock_end = 0ULL;
 	void *src = NULL, *dst = NULL;
+	int i;
 
 	alloc_mem(&src, &dst, len);
 
@@ -128,7 +132,8 @@ static u64 do_memcpy_clock(memcpy_t fn, 
 		fn(dst, src, len);
 
 	clock_start = get_clock();
-	fn(dst, src, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
 	clock_end = get_clock();
 
 	free(src);
@@ -140,6 +145,7 @@ static double do_memcpy_gettimeofday(mem
 {
 	struct timeval tv_start, tv_end, tv_diff;
 	void *src = NULL, *dst = NULL;
+	int i;
 
 	alloc_mem(&src, &dst, len);
 
@@ -147,7 +153,8 @@ static double do_memcpy_gettimeofday(mem
 		fn(dst, src, len);
 
 	BUG_ON(gettimeofday(&tv_start, NULL));
-	fn(dst, src, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, src, len);
 	BUG_ON(gettimeofday(&tv_end, NULL));
 
 	timersub(&tv_end, &tv_start, &tv_diff);
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
@@ -117,6 +120,7 @@ static u64 do_memset_clock(memset_t fn, 
 {
 	u64 clock_start = 0ULL, clock_end = 0ULL;
 	void *dst = NULL;
+	int i;
 
 	alloc_mem(&dst, len);
 
@@ -124,7 +128,8 @@ static u64 do_memset_clock(memset_t fn, 
 		fn(dst, -1, len);
 
 	clock_start = get_clock();
-	fn(dst, 0, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
 	clock_end = get_clock();
 
 	free(dst);
@@ -135,6 +140,7 @@ static double do_memset_gettimeofday(mem
 {
 	struct timeval tv_start, tv_end, tv_diff;
 	void *dst = NULL;
+	int i;
 
 	alloc_mem(&dst, len);
 
@@ -142,7 +148,8 @@ static double do_memset_gettimeofday(mem
 		fn(dst, -1, len);
 
 	BUG_ON(gettimeofday(&tv_start, NULL));
-	fn(dst, 0, len);
+	for (i = 0; i < iterations; ++i)
+		fn(dst, i, len);
 	BUG_ON(gettimeofday(&tv_end, NULL));
 
 	timersub(&tv_end, &tv_start, &tv_diff);



