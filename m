Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab0LGQCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 11:02:00 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:53857 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab0LGQB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 11:01:59 -0500
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
        h.mitake@gmail.com, Miao Xie <miaox@cn.fujitsu.com>,
        Ma Ling <ling.ma@intel.com>, Zhao Yakui <yakui.zhao@intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Paul Mackerras <paulus@samba.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] perf bench: Add options for specifying access alignment to "mem memcpy"
Date: Wed,  8 Dec 2010 01:01:59 +0900
Message-Id: <1291737719-25836-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Alignment of memory access can cause performance degradation
in simple memory copy. So this patch adds the option to
specify access alignment used when calling memcpy().

Current maximum alignment is 8 byte, should this value
can be configurable?

I'll test Miao Xie's patch with this option later.

Example of use:
| mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB -r x86-64-unrolled
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes ...
|
|      748.866217 MB/Sec
|        4.521793 GB/Sec (with prefault)
| mitake@X201i:~/linux/.../tools/perf% ./perf bench mem memcpy -l 500MB -r x86-64-unrolled -d 3
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes ...
|
|      769.653487 MB/Sec
|        3.518181 GB/Sec (with prefault)

In latter case, access to destination memory ragion is shifted 3 bytes,
and performance degradation is observed in prefaulted copy.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>
---
 tools/perf/bench/mem-memcpy.c |   42 +++++++++++++++++++++++++++++-----------
 1 files changed, 30 insertions(+), 12 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index db82021..ac88f52 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -19,6 +19,7 @@
 #include <string.h>
 #include <sys/time.h>
 #include <errno.h>
+#include <unistd.h>
 
 #define K 1024
 
@@ -28,6 +29,8 @@ static bool		use_clock;
 static int		clock_fd;
 static bool		only_prefault;
 static bool		no_prefault;
+static int		src_align;
+static int		dst_align;
 
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
@@ -41,6 +44,10 @@ static const struct option options[] = {
 		    "Show only the result with page faults before memcpy()"),
 	OPT_BOOLEAN('n', "no-prefault", &no_prefault,
 		    "Show only the result without page faults before memcpy()"),
+	OPT_INTEGER('s', "src-alignment", &src_align,
+		    "Alignment of source memory region (in byte)"),
+	OPT_INTEGER('d', "dst-alignment", &dst_align,
+		    "Alignment of destination memory region (in byte)"),
 	OPT_END()
 };
 
@@ -79,6 +86,9 @@ static struct perf_event_attr clock_attr = {
 	.config		= PERF_COUNT_HW_CPU_CYCLES
 };
 
+/* Should this alignment be configurable? */
+#define ALIGNMENT 8
+
 static void init_clock(void)
 {
 	clock_fd = sys_perf_event_open(&clock_attr, getpid(), -1, -1, 0);
@@ -108,27 +118,29 @@ static double timeval2double(struct timeval *ts)
 
 static void alloc_mem(void **dst, void **src, size_t length)
 {
-	*dst = zalloc(length);
-	if (!dst)
+	int ret;
+
+	ret = posix_memalign(dst, ALIGNMENT, length + ALIGNMENT - 1);
+	if (ret)
 		die("memory allocation failed - maybe length is too large?\n");
 
-	*src = zalloc(length);
-	if (!src)
+	ret = posix_memalign(src, ALIGNMENT, length + ALIGNMENT - 1);
+	if (ret)
 		die("memory allocation failed - maybe length is too large?\n");
 }
 
 static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
 {
 	u64 clock_start = 0ULL, clock_end = 0ULL;
-	void *src = NULL, *dst = NULL;
+	char *src = NULL, *dst = NULL;
 
-	alloc_mem(&src, &dst, len);
+	alloc_mem((void **)&src, (void **)&dst, len);
 
 	if (prefault)
-		fn(dst, src, len);
+		fn(dst + dst_align, src + src_align, len);
 
 	clock_start = get_clock();
-	fn(dst, src, len);
+	fn(dst + dst_align, src + src_align, len);
 	clock_end = get_clock();
 
 	free(src);
@@ -139,15 +151,15 @@ static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
 static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
 {
 	struct timeval tv_start, tv_end, tv_diff;
-	void *src = NULL, *dst = NULL;
+	char *src = NULL, *dst = NULL;
 
-	alloc_mem(&src, &dst, len);
+	alloc_mem((void **)&src, (void **)&dst, len);
 
 	if (prefault)
-		fn(dst, src, len);
+		fn(dst + dst_align, src + src_align, len);
 
 	BUG_ON(gettimeofday(&tv_start, NULL));
-	fn(dst, src, len);
+	fn(dst + dst_align, src + src_align, len);
 	BUG_ON(gettimeofday(&tv_end, NULL));
 
 	timersub(&tv_end, &tv_start, &tv_diff);
@@ -198,6 +210,12 @@ int bench_mem_memcpy(int argc, const char **argv,
 	if (only_prefault && no_prefault)
 		only_prefault = no_prefault = false;
 
+	if (ALIGNMENT <= src_align || ALIGNMENT <= dst_align) {
+		fprintf(stderr, "Alignment is too large,"
+			"it should be shorter than %d Byte\n", ALIGNMENT);
+		return 1;
+	}
+
 	for (i = 0; routines[i].name; i++) {
 		if (!strcmp(routines[i].name, routine))
 			break;
-- 
1.7.1.1

