Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1LULvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:51:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34134 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1LULvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:51:39 -0500
Date: Wed, 21 Dec 2011 03:51:17 -0800
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-evf5yii88ljdgmaihccbxxw1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu, asharma@fb.com
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, mingo@elte.hu, asharma@fb.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/fast] perf tools: Add x86 RDPMC, RDTSC test
Git-Commit-ID: 08aa0d1f376e9b966568316bd2019b3c1274d885
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:51:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  08aa0d1f376e9b966568316bd2019b3c1274d885
Gitweb:     http://git.kernel.org/tip/08aa0d1f376e9b966568316bd2019b3c1274d885
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 21 Nov 2011 14:42:47 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 12:21:42 +0100

perf tools: Add x86 RDPMC, RDTSC test

Implement a simple test for the self-monitoring data from the
perf mmap data area control page:

 6: x86 rdpmc test:

             0:           6053
             1:          60053
             2:         600059
             3:        6000059
             4:       60000075
             5:      600000247
    Ok

The counts are expected to increase monotonically - these
are recovered via RDPMC, without calling into the kernel.

It might be nice to add logic to automagically turn these numbers into OK/FAIL.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Arun Sharma <asharma@fb.com>
Link: http://lkml.kernel.org/n/tip-evf5yii88ljdgmaihccbxxw1@git.kernel.org
[ various small improvements ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/builtin-test.c |  177 ++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 175 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
index 2b9a7f4..439b5ed 100644
--- a/tools/perf/builtin-test.c
+++ b/tools/perf/builtin-test.c
@@ -15,6 +15,8 @@
 #include "util/thread_map.h"
 #include "../../include/linux/hw_breakpoint.h"
 
+#include <sys/mman.h>
+
 static int vmlinux_matches_kallsyms_filter(struct map *map __used, struct symbol *sym)
 {
 	bool *visited = symbol__priv(sym);
@@ -1296,6 +1298,173 @@ out:
 	return (err < 0 || errs > 0) ? -1 : 0;
 }
 
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
+static void segfault_handler(int sig __used, siginfo_t *info __used, void *uc __used)
+{
+	exit(-1);
+}
+
+static int __test__rdpmc(void)
+{
+	long page_size = sysconf(_SC_PAGE_SIZE);
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
+	fprintf(stderr, "\n\n");
+
+	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
+	if (fd < 0) {
+		die("Error: sys_perf_event_open() syscall returned "
+		    "with %d (%s)\n", fd, strerror(errno));
+	}
+
+	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
+	if (addr == (void *)(-1)) {
+		die("Error: mmap() syscall returned "
+		    "with (%s)\n", strerror(errno));
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
+		fprintf(stderr, "%14d: %14Lu\n", n, (long long)delta);
+
+		delta_sum += delta;
+	}
+
+	munmap(addr, page_size);
+	close(fd);
+
+	fprintf(stderr, "   ");
+
+	if (!delta_sum)
+		return -1;
+
+	return 0;
+}
+
+static int test__rdpmc(void)
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
+
 static struct test {
 	const char *desc;
 	int (*func)(void);
@@ -1320,6 +1489,12 @@ static struct test {
 		.desc = "parse events tests",
 		.func = test__parse_events,
 	},
+#if defined(__x86_64__) || defined(__i386__)
+	{
+		.desc = "x86 rdpmc test",
+		.func = test__rdpmc,
+	},
+#endif
 	{
 		.desc = "Validate PERF_RECORD_* events & perf_sample fields",
 		.func = test__PERF_RECORD,
@@ -1412,7 +1587,5 @@ int cmd_test(int argc, const char **argv, const char *prefix __used)
 	if (symbol__init() < 0)
 		return -1;
 
-	setup_pager();
-
 	return __cmd_test(argc, argv);
 }
