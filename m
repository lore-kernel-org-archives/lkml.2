Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab2KJAra (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 19:47:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751959Ab2KJArS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 19:47:18 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/12] perf tests: Move test__rdpmc into separate object
Date: Sat, 10 Nov 2012 01:46:46 +0100
Message-Id: <1352508412-16914-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
References: <1352508412-16914-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating test__rdpmc test from the builtin-test
into rdpmc object.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile             |   1 +
 tools/perf/tests/builtin-test.c | 168 --------------------------------------
 tools/perf/tests/rdpmc.c        | 175 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/tests/tests.h        |   1 +
 4 files changed, 177 insertions(+), 168 deletions(-)
 create mode 100644 tools/perf/tests/rdpmc.c

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2d6153..2e5197a 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -436,6 +436,7 @@ LIB_OBJS += $(OUTPUT)tests/open-syscall.o
 LIB_OBJS += $(OUTPUT)tests/open-syscall-all-cpus.o
 LIB_OBJS += $(OUTPUT)tests/mmap-basic.o
 LIB_OBJS += $(OUTPUT)tests/perf-record.o
+LIB_OBJS += $(OUTPUT)tests/rdpmc.o
 LIB_OBJS += $(OUTPUT)tests/util.o
 
 BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
diff --git a/tools/perf/tests/builtin-test.c b/tools/perf/tests/builtin-test.c
index 7cb3928..1e9a0ea 100644
--- a/tools/perf/tests/builtin-test.c
+++ b/tools/perf/tests/builtin-test.c
@@ -30,174 +30,6 @@
 #include <sched.h>
 
 
-
-#if defined(__x86_64__) || defined(__i386__)
-
-#define barrier() asm volatile("" ::: "memory")
-
-static u64 rdpmc(unsigned int counter)
-{
-	unsigned int low, high;
-
-	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
-
-	return low | ((u64)high) << 32;
-}
-
-static u64 rdtsc(void)
-{
-	unsigned int low, high;
-
-	asm volatile("rdtsc" : "=a" (low), "=d" (high));
-
-	return low | ((u64)high) << 32;
-}
-
-static u64 mmap_read_self(void *addr)
-{
-	struct perf_event_mmap_page *pc = addr;
-	u32 seq, idx, time_mult = 0, time_shift = 0;
-	u64 count, cyc = 0, time_offset = 0, enabled, running, delta;
-
-	do {
-		seq = pc->lock;
-		barrier();
-
-		enabled = pc->time_enabled;
-		running = pc->time_running;
-
-		if (enabled != running) {
-			cyc = rdtsc();
-			time_mult = pc->time_mult;
-			time_shift = pc->time_shift;
-			time_offset = pc->time_offset;
-		}
-
-		idx = pc->index;
-		count = pc->offset;
-		if (idx)
-			count += rdpmc(idx - 1);
-
-		barrier();
-	} while (pc->lock != seq);
-
-	if (enabled != running) {
-		u64 quot, rem;
-
-		quot = (cyc >> time_shift);
-		rem = cyc & ((1 << time_shift) - 1);
-		delta = time_offset + quot * time_mult +
-			((rem * time_mult) >> time_shift);
-
-		enabled += delta;
-		if (idx)
-			running += delta;
-
-		quot = count / running;
-		rem = count % running;
-		count = quot * enabled + (rem * enabled) / running;
-	}
-
-	return count;
-}
-
-/*
- * If the RDPMC instruction faults then signal this back to the test parent task:
- */
-static void segfault_handler(int sig __maybe_unused,
-			     siginfo_t *info __maybe_unused,
-			     void *uc __maybe_unused)
-{
-	exit(-1);
-}
-
-static int __test__rdpmc(void)
-{
-	volatile int tmp = 0;
-	u64 i, loops = 1000;
-	int n;
-	int fd;
-	void *addr;
-	struct perf_event_attr attr = {
-		.type = PERF_TYPE_HARDWARE,
-		.config = PERF_COUNT_HW_INSTRUCTIONS,
-		.exclude_kernel = 1,
-	};
-	u64 delta_sum = 0;
-        struct sigaction sa;
-
-	sigfillset(&sa.sa_mask);
-	sa.sa_sigaction = segfault_handler;
-	sigaction(SIGSEGV, &sa, NULL);
-
-	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
-	if (fd < 0) {
-		pr_err("Error: sys_perf_event_open() syscall returned "
-		       "with %d (%s)\n", fd, strerror(errno));
-		return -1;
-	}
-
-	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
-	if (addr == (void *)(-1)) {
-		pr_err("Error: mmap() syscall returned with (%s)\n",
-		       strerror(errno));
-		goto out_close;
-	}
-
-	for (n = 0; n < 6; n++) {
-		u64 stamp, now, delta;
-
-		stamp = mmap_read_self(addr);
-
-		for (i = 0; i < loops; i++)
-			tmp++;
-
-		now = mmap_read_self(addr);
-		loops *= 10;
-
-		delta = now - stamp;
-		pr_debug("%14d: %14Lu\n", n, (long long)delta);
-
-		delta_sum += delta;
-	}
-
-	munmap(addr, page_size);
-	pr_debug("   ");
-out_close:
-	close(fd);
-
-	if (!delta_sum)
-		return -1;
-
-	return 0;
-}
-
-static int test__rdpmc(void)
-{
-	int status = 0;
-	int wret = 0;
-	int ret;
-	int pid;
-
-	pid = fork();
-	if (pid < 0)
-		return -1;
-
-	if (!pid) {
-		ret = __test__rdpmc();
-
-		exit(ret);
-	}
-
-	wret = waitpid(pid, &status, 0);
-	if (wret < 0 || status)
-		return -1;
-
-	return 0;
-}
-
-#endif
-
 static int test__perf_pmu(void)
 {
 	return perf_pmu__test();
diff --git a/tools/perf/tests/rdpmc.c b/tools/perf/tests/rdpmc.c
new file mode 100644
index 0000000..ff94886
--- /dev/null
+++ b/tools/perf/tests/rdpmc.c
@@ -0,0 +1,175 @@
+#include <unistd.h>
+#include <stdlib.h>
+#include <signal.h>
+#include <sys/mman.h>
+#include "types.h"
+#include "perf.h"
+#include "debug.h"
+#include "tests.h"
+
+#if defined(__x86_64__) || defined(__i386__)
+
+#define barrier() asm volatile("" ::: "memory")
+
+static u64 rdpmc(unsigned int counter)
+{
+	unsigned int low, high;
+
+	asm volatile("rdpmc" : "=a" (low), "=d" (high) : "c" (counter));
+
+	return low | ((u64)high) << 32;
+}
+
+static u64 rdtsc(void)
+{
+	unsigned int low, high;
+
+	asm volatile("rdtsc" : "=a" (low), "=d" (high));
+
+	return low | ((u64)high) << 32;
+}
+
+static u64 mmap_read_self(void *addr)
+{
+	struct perf_event_mmap_page *pc = addr;
+	u32 seq, idx, time_mult = 0, time_shift = 0;
+	u64 count, cyc = 0, time_offset = 0, enabled, running, delta;
+
+	do {
+		seq = pc->lock;
+		barrier();
+
+		enabled = pc->time_enabled;
+		running = pc->time_running;
+
+		if (enabled != running) {
+			cyc = rdtsc();
+			time_mult = pc->time_mult;
+			time_shift = pc->time_shift;
+			time_offset = pc->time_offset;
+		}
+
+		idx = pc->index;
+		count = pc->offset;
+		if (idx)
+			count += rdpmc(idx - 1);
+
+		barrier();
+	} while (pc->lock != seq);
+
+	if (enabled != running) {
+		u64 quot, rem;
+
+		quot = (cyc >> time_shift);
+		rem = cyc & ((1 << time_shift) - 1);
+		delta = time_offset + quot * time_mult +
+			((rem * time_mult) >> time_shift);
+
+		enabled += delta;
+		if (idx)
+			running += delta;
+
+		quot = count / running;
+		rem = count % running;
+		count = quot * enabled + (rem * enabled) / running;
+	}
+
+	return count;
+}
+
+/*
+ * If the RDPMC instruction faults then signal this back to the test parent task:
+ */
+static void segfault_handler(int sig __maybe_unused,
+			     siginfo_t *info __maybe_unused,
+			     void *uc __maybe_unused)
+{
+	exit(-1);
+}
+
+static int __test__rdpmc(void)
+{
+	volatile int tmp = 0;
+	u64 i, loops = 1000;
+	int n;
+	int fd;
+	void *addr;
+	struct perf_event_attr attr = {
+		.type = PERF_TYPE_HARDWARE,
+		.config = PERF_COUNT_HW_INSTRUCTIONS,
+		.exclude_kernel = 1,
+	};
+	u64 delta_sum = 0;
+        struct sigaction sa;
+
+	sigfillset(&sa.sa_mask);
+	sa.sa_sigaction = segfault_handler;
+	sigaction(SIGSEGV, &sa, NULL);
+
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	if (fd < 0) {
+		pr_err("Error: sys_perf_event_open() syscall returned "
+		       "with %d (%s)\n", fd, strerror(errno));
+		return -1;
+	}
+
+	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (addr == (void *)(-1)) {
+		pr_err("Error: mmap() syscall returned with (%s)\n",
+		       strerror(errno));
+		goto out_close;
+	}
+
+	for (n = 0; n < 6; n++) {
+		u64 stamp, now, delta;
+
+		stamp = mmap_read_self(addr);
+
+		for (i = 0; i < loops; i++)
+			tmp++;
+
+		now = mmap_read_self(addr);
+		loops *= 10;
+
+		delta = now - stamp;
+		pr_debug("%14d: %14Lu\n", n, (long long)delta);
+
+		delta_sum += delta;
+	}
+
+	munmap(addr, page_size);
+	pr_debug("   ");
+out_close:
+	close(fd);
+
+	if (!delta_sum)
+		return -1;
+
+	return 0;
+}
+
+int test__rdpmc(void)
+{
+	int status = 0;
+	int wret = 0;
+	int ret;
+	int pid;
+
+	pid = fork();
+	if (pid < 0)
+		return -1;
+
+	if (!pid) {
+		ret = __test__rdpmc();
+
+		exit(ret);
+	}
+
+	wret = waitpid(pid, &status, 0);
+	if (wret < 0 || status)
+		return -1;
+
+	return 0;
+}
+
+#endif
diff --git a/tools/perf/tests/tests.h b/tools/perf/tests/tests.h
index 374b039..03d428d 100644
--- a/tools/perf/tests/tests.h
+++ b/tools/perf/tests/tests.h
@@ -7,6 +7,7 @@ int test__open_syscall_event(void);
 int test__open_syscall_event_on_all_cpus(void);
 int test__basic_mmap(void);
 int test__PERF_RECORD(void);
+int test__rdpmc(void);
 
 /* Util */
 int trace_event__id(const char *evname);
-- 
1.7.11.7

