Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140Ab2CMQ47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:56:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:49660 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757570Ab2CMQ4s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:56:48 -0400
Date: Tue, 13 Mar 2012 17:56:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [GIT PULL] perf fixes
Message-ID: <20120313165641.GA6871@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest perf-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-urgent-for-linus

   HEAD: 8aa8a7c80ccdfac2df5ee48a51a4a7bee2143d4f perf record: Fix buffer overrun bug in tracepoint_id_to_path()

 Thanks,

	Ingo

------------------>
Peter Zijlstra (1):
      perf/x86: Fix local vs remote memory events for NHM/WSM

Stephane Eranian (1):
      perf record: Fix buffer overrun bug in tracepoint_id_to_path()


 arch/x86/kernel/cpu/perf_event_intel.c |   17 +++++++++--------
 tools/perf/util/parse-events.c         |    2 +-
 2 files changed, 10 insertions(+), 9 deletions(-)

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
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index b029296..c7a6f6f 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -165,7 +165,7 @@ struct tracepoint_path *tracepoint_id_to_path(u64 config)
 	struct tracepoint_path *path = NULL;
 	DIR *sys_dir, *evt_dir;
 	struct dirent *sys_next, *evt_next, sys_dirent, evt_dirent;
-	char id_buf[4];
+	char id_buf[24];
 	int fd;
 	u64 id;
 	char evt_path[MAXPATHLEN];
