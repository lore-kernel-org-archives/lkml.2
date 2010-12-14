Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0LNFrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 00:47:08 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:60077 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0LNFrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 00:47:05 -0500
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
Subject: [RFC PATCH 2/2] perf bench: more fine grain monitoring for prefault memcpy()
Date: Tue, 14 Dec 2010 14:46:59 +0900
Message-Id: <1292305619-29627-2-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <4D0659D6.7000803@dcl.info.waseda.ac.jp>
References: <4D0659D6.7000803@dcl.info.waseda.ac.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes perf bench mem memcpy to use the new feature of perf stat.

New option --wake-up requires path name of unix domain socket.
If --only-prefault or --no-prefault is specified, the pid of itself is written
to this socket before actual memcpy() to be monitored. And the pid of perf stat
is read from it. The pid of perf stat is used for signaling perf stat
to terminate monitoring.

With this feature, the detailed performance monitoring of prefaulted
(or non prefaulted only) memcpy() will be possible.

Example of use, non prefaulted version:
| mitake@x201i:~/linux/.../tools/perf% sudo ./perf stat -w /tmp/perf-stat-wait
|

After execution, perf stat waits the pid...

|  Performance counter stats for process id '27109':
|
|         440.534943 task-clock-msecs         #      0.997 CPUs
|                 44 context-switches         #      0.000 M/sec
|                  5 CPU-migrations           #      0.000 M/sec
|            256,002 page-faults              #      0.581 M/sec
|        934,443,072 cycles                   #   2121.155 M/sec
|        780,408,435 instructions             #      0.835 IPC
|        111,756,558 branches                 #    253.684 M/sec
|            392,170 branch-misses            #      0.351 %
|          8,611,308 cache-references         #     19.547 M/sec
|          8,533,588 cache-misses             #     19.371 M/sec
|
|         0.441803031  seconds time elapsed

in another shell,

| mitake@x201i:~/linux/.../tools/perf% sudo ./perf bench mem memcpy -l 500MB --no-prefault -w /tmp/perf-stat-wait
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes ...
|
|        1.105722 GB/Sec

Example of use, prefaulted version:

| mitake@x201i:~/linux/.../tools/perf% sudo ./perf stat -w /tmp/perf-stat-wait
| Performance counter stats for process id '27112':
|
|         105.001542 task-clock-msecs         #      0.997 CPUs
|                 11 context-switches         #      0.000 M/sec
|                  0 CPU-migrations           #      0.000 M/sec
|                  2 page-faults              #      0.000 M/sec
|        223,273,425 cycles                   #   2126.382 M/sec
|        197,992,585 instructions             #      0.887 IPC
|         16,657,288 branches                 #    158.639 M/sec
|              1,942 branch-misses            #      0.012 %
|          3,105,619 cache-references         #     29.577 M/sec
|          3,082,390 cache-misses             #     29.356 M/sec
|
|         0.105316101  seconds time elapsed

in another shell,

| mitake@x201i:~/linux/.../tools/perf% sudo ./perf bench mem memcpy -l 500MB --only-prefault -w /tmp/perf-stat-wait
| # Running mem/memcpy benchmark...
| # Copying 500MB Bytes ...
|
|        4.640927 GB/Sec (with prefault)

The result shows that the difference between non-prefaulted memcpy() and prefaulted one.
And this will be useful for detailed performance analysis of various memcpy()s
like Miao Xie's one and rep prefix version.

But this is too adhoc and dirty... :(

Cc: Miao Xie <miaox@cn.fujitsu.com>
Cc: Ma Ling <ling.ma@intel.com>
Cc: Zhao Yakui <yakui.zhao@intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
---
 tools/perf/bench/mem-memcpy.c |   56 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 56 insertions(+), 0 deletions(-)

diff --git a/tools/perf/bench/mem-memcpy.c b/tools/perf/bench/mem-memcpy.c
index ac88f52..7d0bcea 100644
--- a/tools/perf/bench/mem-memcpy.c
+++ b/tools/perf/bench/mem-memcpy.c
@@ -21,6 +21,10 @@
 #include <errno.h>
 #include <unistd.h>
 
+#include <sys/types.h>
+#include <sys/socket.h>
+#include <sys/un.h>
+
 #define K 1024
 
 static const char	*length_str	= "1MB";
@@ -31,6 +35,7 @@ static bool		only_prefault;
 static bool		no_prefault;
 static int		src_align;
 static int		dst_align;
+static const char	*wake_path;
 
 static const struct option options[] = {
 	OPT_STRING('l', "length", &length_str, "1MB",
@@ -48,6 +53,9 @@ static const struct option options[] = {
 		    "Alignment of source memory region (in byte)"),
 	OPT_INTEGER('d', "dst-alignment", &dst_align,
 		    "Alignment of destination memory region (in byte)"),
+	OPT_STRING('w', "wake-up", &wake_path, "default",
+		    "Path of unix domain socket for waking up perf stat"
+		    " (use with only_prefault option)"),
 	OPT_END()
 };
 
@@ -116,6 +124,33 @@ static double timeval2double(struct timeval *ts)
 		(double)ts->tv_usec / (double)1000000;
 }
 
+static pid_t perf_stat_pid;
+
+static void wake_up_perf_stat(void)
+{
+	int wake_fd;
+	struct sockaddr_un wake_addr;
+	pid_t myself = getpid();
+
+	wake_fd = socket(PF_UNIX, SOCK_STREAM, 0);
+	if (wake_fd < 0)
+		die("unable to create socket for sync\n");
+
+	memset(&wake_addr, 0, sizeof(wake_addr));
+	wake_addr.sun_family = PF_UNIX;
+	strncpy(wake_addr.sun_path, wake_path, sizeof(wake_addr.sun_path));
+
+	if (connect(wake_fd, (struct sockaddr *)&wake_addr, sizeof(wake_addr)))
+		die("connect() failed\n");
+
+	if (write(wake_fd, &myself, sizeof(myself)) != sizeof(myself))
+		die("write() my pid to socket failed\n");
+
+	if (read(wake_fd, &perf_stat_pid, sizeof(perf_stat_pid))
+		!= sizeof(perf_stat_pid))
+		die("read() pid of perf stat from socket\n");
+}
+
 static void alloc_mem(void **dst, void **src, size_t length)
 {
 	int ret;
@@ -139,10 +174,16 @@ static u64 do_memcpy_clock(memcpy_t fn, size_t len, bool prefault)
 	if (prefault)
 		fn(dst + dst_align, src + src_align, len);
 
+	if (wake_path)
+		wake_up_perf_stat();
+
 	clock_start = get_clock();
 	fn(dst + dst_align, src + src_align, len);
 	clock_end = get_clock();
 
+	if (wake_path)		/* kill perf stat */
+		kill(perf_stat_pid, SIGINT);
+
 	free(src);
 	free(dst);
 	return clock_end - clock_start;
@@ -158,12 +199,18 @@ static double do_memcpy_gettimeofday(memcpy_t fn, size_t len, bool prefault)
 	if (prefault)
 		fn(dst + dst_align, src + src_align, len);
 
+	if (wake_path)
+		wake_up_perf_stat();
+
 	BUG_ON(gettimeofday(&tv_start, NULL));
 	fn(dst + dst_align, src + src_align, len);
 	BUG_ON(gettimeofday(&tv_end, NULL));
 
 	timersub(&tv_end, &tv_start, &tv_diff);
 
+	if (wake_path)		/* kill perf stat */
+		kill(perf_stat_pid, SIGINT);
+
 	free(src);
 	free(dst);
 	return (double)((double)len / timeval2double(&tv_diff));
@@ -235,6 +282,15 @@ int bench_mem_memcpy(int argc, const char **argv,
 
 	if (!only_prefault && !no_prefault) {
 		/* show both of results */
+		if (wake_path) {
+			fprintf(stderr, "Meaningless combination of option, "
+				"you should not use wake_path alone.\n"
+				"Use it with --only-prefault"
+				" or --no-prefault\n");
+			return 1;
+		}
+
+
 		if (use_clock) {
 			result_clock[0] =
 				do_memcpy_clock(routines[i].fn, len, false);
-- 
1.7.3.3

