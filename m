Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab2CMEtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 00:49:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35275 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753939Ab2CMEtX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 00:49:23 -0400
Date: Mon, 12 Mar 2012 21:49:06 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-tq73sxus35xmqpojf7ootxgs@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@redhat.com, a.p.zijlstra@chello.nl, stable@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        stable@kernel.org, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86:
  Fix local vs remote memory events for NHM/WSM
Git-Commit-ID: 87e24f4b67e68d9fd8df16e0bf9c66d1ad2a2533
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 12 Mar 2012 21:49:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  87e24f4b67e68d9fd8df16e0bf9c66d1ad2a2533
Gitweb:     http://git.kernel.org/tip/87e24f4b67e68d9fd8df16e0bf9c66d1ad2a2533
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Mon, 5 Mar 2012 23:59:25 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 12 Mar 2012 20:43:41 +0100

perf/x86: Fix local vs remote memory events for NHM/WSM

Verified using the below proglet.. before:

[root@westmere ~]# perf stat -e node-stores -e node-store-misses ./numa 0
remote write

 Performance counter stats for './numa 0':

         2,101,554 node-stores
         2,096,931 node-store-misses

       5.021546079 seconds time elapsed

[root@westmere ~]# perf stat -e node-stores -e node-store-misses ./numa 1
local write

 Performance counter stats for './numa 1':

           501,137 node-stores
               199 node-store-misses

       5.124451068 seconds time elapsed

After:

[root@westmere ~]# perf stat -e node-stores -e node-store-misses ./numa 0
remote write

 Performance counter stats for './numa 0':

         2,107,516 node-stores
         2,097,187 node-store-misses

       5.012755149 seconds time elapsed

[root@westmere ~]# perf stat -e node-stores -e node-store-misses ./numa 1
local write

 Performance counter stats for './numa 1':

         2,063,355 node-stores
               165 node-store-misses

       5.082091494 seconds time elapsed

#define _GNU_SOURCE

#include <sched.h>
#include <stdio.h>
#include <errno.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <dirent.h>
#include <signal.h>
#include <unistd.h>
#include <numaif.h>
#include <stdlib.h>

#define SIZE (32*1024*1024)

volatile int done;

void sig_done(int sig)
{
	done = 1;
}

int main(int argc, char **argv)
{
	cpu_set_t *mask, *mask2;
	size_t size;
	int i, err, t;
	int nrcpus = 1024;
	char *mem;
	unsigned long nodemask = 0x01; /* node 0 */
	DIR *node;
	struct dirent *de;
	int read = 0;
	int local = 0;

	if (argc < 2) {
		printf("usage: %s [0-3]\n", argv[0]);
		printf("  bit0 - local/remote\n");
		printf("  bit1 - read/write\n");
		exit(0);
	}

	switch (atoi(argv[1])) {
	case 0:
		printf("remote write\n");
		break;
	case 1:
		printf("local write\n");
		local = 1;
		break;
	case 2:
		printf("remote read\n");
		read = 1;
		break;
	case 3:
		printf("local read\n");
		local = 1;
		read = 1;
		break;
	}

	mask = CPU_ALLOC(nrcpus);
	size = CPU_ALLOC_SIZE(nrcpus);
	CPU_ZERO_S(size, mask);

	node = opendir("/sys/devices/system/node/node0/");
	if (!node)
		perror("opendir");
	while ((de = readdir(node))) {
		int cpu;

		if (sscanf(de->d_name, "cpu%d", &cpu) == 1)
			CPU_SET_S(cpu, size, mask);
	}
	closedir(node);

	mask2 = CPU_ALLOC(nrcpus);
	CPU_ZERO_S(size, mask2);
	for (i = 0; i < size; i++)
		CPU_SET_S(i, size, mask2);
	CPU_XOR_S(size, mask2, mask2, mask); // invert

	if (!local)
		mask = mask2;

	err = sched_setaffinity(0, size, mask);
	if (err)
		perror("sched_setaffinity");

	mem = mmap(0, SIZE, PROT_READ|PROT_WRITE,
			MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);
	err = mbind(mem, SIZE, MPOL_BIND, &nodemask, 8*sizeof(nodemask), MPOL_MF_MOVE);
	if (err)
		perror("mbind");

	signal(SIGALRM, sig_done);
	alarm(5);

	if (!read) {
		while (!done) {
			for (i = 0; i < SIZE; i++)
				mem[i] = 0x01;
		}
	} else {
		while (!done) {
			for (i = 0; i < SIZE; i++)
				t += *(volatile char *)(mem + i);
		}
	}

	return 0;
}

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: <stable@kernel.org>
Link: http://lkml.kernel.org/n/tip-tq73sxus35xmqpojf7ootxgs@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 3bd37bd..61d4f79 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -385,14 +385,15 @@ static __initconst const u64 westmere_hw_cache_event_ids
 #define NHM_LOCAL_DRAM		(1 << 14)
 #define NHM_NON_DRAM		(1 << 15)
 
-#define NHM_ALL_DRAM		(NHM_REMOTE_DRAM|NHM_LOCAL_DRAM)
+#define NHM_LOCAL		(NHM_LOCAL_DRAM|NHM_REMOTE_CACHE_FWD)
+#define NHM_REMOTE		(NHM_REMOTE_DRAM)
 
 #define NHM_DMND_READ		(NHM_DMND_DATA_RD)
 #define NHM_DMND_WRITE		(NHM_DMND_RFO|NHM_DMND_WB)
 #define NHM_DMND_PREFETCH	(NHM_PF_DATA_RD|NHM_PF_DATA_RFO)
 
 #define NHM_L3_HIT	(NHM_UNCORE_HIT|NHM_OTHER_CORE_HIT_SNP|NHM_OTHER_CORE_HITM)
-#define NHM_L3_MISS	(NHM_NON_DRAM|NHM_ALL_DRAM|NHM_REMOTE_CACHE_FWD)
+#define NHM_L3_MISS	(NHM_NON_DRAM|NHM_LOCAL_DRAM|NHM_REMOTE_DRAM|NHM_REMOTE_CACHE_FWD)
 #define NHM_L3_ACCESS	(NHM_L3_HIT|NHM_L3_MISS)
 
 static __initconst const u64 nehalem_hw_cache_extra_regs
@@ -416,16 +417,16 @@ static __initconst const u64 nehalem_hw_cache_extra_regs
  },
  [ C(NODE) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = NHM_DMND_READ|NHM_ALL_DRAM,
-		[ C(RESULT_MISS)   ] = NHM_DMND_READ|NHM_REMOTE_DRAM,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_READ|NHM_LOCAL|NHM_REMOTE,
+		[ C(RESULT_MISS)   ] = NHM_DMND_READ|NHM_REMOTE,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = NHM_DMND_WRITE|NHM_ALL_DRAM,
-		[ C(RESULT_MISS)   ] = NHM_DMND_WRITE|NHM_REMOTE_DRAM,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_WRITE|NHM_LOCAL|NHM_REMOTE,
+		[ C(RESULT_MISS)   ] = NHM_DMND_WRITE|NHM_REMOTE,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_ALL_DRAM,
-		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_REMOTE_DRAM,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_LOCAL|NHM_REMOTE,
+		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_REMOTE,
 	},
  },
 };
