Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab1GAPYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 11:24:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:57669 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1GAPYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 11:24:33 -0400
Date: Fri, 1 Jul 2011 15:23:57 GMT
From: tip-bot for Peter Zijlstra <peterz@infradead.org>
Message-ID: <tip-89d6c0b5bdbb1927775584dcf532d98b3efe1477@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, anton@samba.org,
        hpa@zytor.com, mingo@redhat.com, dengcheng.zhu@gmail.com,
        will.deacon@arm.com, a.p.zijlstra@chello.nl, peterz@infradead.org,
        lethal@linux-sh.org, davem@davemloft.net, robert.richter@amd.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, anton@samba.org, eranian@google.com,
        linux-kernel@vger.kernel.org, dengcheng.zhu@gmail.com,
        a.p.zijlstra@chello.nl, will.deacon@arm.com, peterz@infradead.org,
        lethal@linux-sh.org, davem@davemloft.net, robert.richter@amd.com,
        ddaney@caviumnetworks.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1303508226.4865.8.camel@laptop>
References: <1303508226.4865.8.camel@laptop>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf, arch: Add generic NODE cache events
Git-Commit-ID: 89d6c0b5bdbb1927775584dcf532d98b3efe1477
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 01 Jul 2011 15:23:59 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  89d6c0b5bdbb1927775584dcf532d98b3efe1477
Gitweb:     http://git.kernel.org/tip/89d6c0b5bdbb1927775584dcf532d98b3efe1477
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Fri, 22 Apr 2011 23:37:06 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 1 Jul 2011 11:06:38 +0200

perf, arch: Add generic NODE cache events

Add a NODE level to the generic cache events which is used to measure
local vs remote memory accesses. Like all other cache events, an
ACCESS is HIT+MISS, if there is no way to distinguish between reads
and writes do reads only etc..

The below needs filling out for !x86 (which I filled out with
unsupported events).

I'm fairly sure ARM can leave it like that since it doesn't strike me as
an architecture that even has NUMA support. SH might have something since
it does appear to have some NUMA bits.

Sparc64, PowerPC and MIPS certainly want a good look there since they
clearly are NUMA capable.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: David Miller <davem@davemloft.net>
Cc: Anton Blanchard <anton@samba.org>
Cc: David Daney <ddaney@caviumnetworks.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: Robert Richter <robert.richter@amd.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1303508226.4865.8.camel@laptop
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/arm/kernel/perf_event_v6.c        |   28 +++++++++++++++
 arch/arm/kernel/perf_event_v7.c        |   28 +++++++++++++++
 arch/arm/kernel/perf_event_xscale.c    |   14 +++++++
 arch/mips/kernel/perf_event_mipsxx.c   |   28 +++++++++++++++
 arch/powerpc/kernel/e500-pmu.c         |    5 +++
 arch/powerpc/kernel/mpc7450-pmu.c      |    5 +++
 arch/powerpc/kernel/power4-pmu.c       |    5 +++
 arch/powerpc/kernel/power5+-pmu.c      |    5 +++
 arch/powerpc/kernel/power5-pmu.c       |    5 +++
 arch/powerpc/kernel/power6-pmu.c       |    5 +++
 arch/powerpc/kernel/power7-pmu.c       |    5 +++
 arch/powerpc/kernel/ppc970-pmu.c       |    5 +++
 arch/sh/kernel/cpu/sh4/perf_event.c    |   15 ++++++++
 arch/sh/kernel/cpu/sh4a/perf_event.c   |   15 ++++++++
 arch/sparc/kernel/perf_event.c         |   42 ++++++++++++++++++++++
 arch/x86/kernel/cpu/perf_event_amd.c   |   14 +++++++
 arch/x86/kernel/cpu/perf_event_intel.c |   59 +++++++++++++++++++++++++++++++-
 arch/x86/kernel/cpu/perf_event_p4.c    |   14 +++++++
 include/linux/perf_event.h             |    3 +-
 19 files changed, 298 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v6.c b/arch/arm/kernel/perf_event_v6.c
index 38dc4da..dd7f3b9 100644
--- a/arch/arm/kernel/perf_event_v6.c
+++ b/arch/arm/kernel/perf_event_v6.c
@@ -173,6 +173,20 @@ static const unsigned armv6_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 enum armv6mpcore_perf_types {
@@ -310,6 +324,20 @@ static const unsigned armv6mpcore_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]  = CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]  = CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]  = CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]    = CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 static inline unsigned long
diff --git a/arch/arm/kernel/perf_event_v7.c b/arch/arm/kernel/perf_event_v7.c
index 6e5f875..e20ca9c 100644
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -255,6 +255,20 @@ static const unsigned armv7_a8_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 /*
@@ -371,6 +385,20 @@ static const unsigned armv7_a9_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 /*
diff --git a/arch/arm/kernel/perf_event_xscale.c b/arch/arm/kernel/perf_event_xscale.c
index 99b6b85..3c43974 100644
--- a/arch/arm/kernel/perf_event_xscale.c
+++ b/arch/arm/kernel/perf_event_xscale.c
@@ -144,6 +144,20 @@ static const unsigned xscale_perf_cache_map[PERF_COUNT_HW_CACHE_MAX]
 			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
 		},
 	},
+	[C(NODE)] = {
+		[C(OP_READ)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_WRITE)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+		[C(OP_PREFETCH)] = {
+			[C(RESULT_ACCESS)]	= CACHE_OP_UNSUPPORTED,
+			[C(RESULT_MISS)]	= CACHE_OP_UNSUPPORTED,
+		},
+	},
 };
 
 #define	XSCALE_PMU_ENABLE	0x001
diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 75266ff..e5ad09a 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -377,6 +377,20 @@ static const struct mips_perf_event mipsxxcore_cache_map
 		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
 };
 
 /* 74K core has completely different cache event map. */
@@ -480,6 +494,20 @@ static const struct mips_perf_event mipsxx74Kcore_cache_map
 		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_WRITE)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+	[C(OP_PREFETCH)] = {
+		[C(RESULT_ACCESS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+		[C(RESULT_MISS)]	= { UNSUPPORTED_PERF_EVENT_ID },
+	},
+},
 };
 
 #ifdef CONFIG_MIPS_MT_SMP
diff --git a/arch/powerpc/kernel/e500-pmu.c b/arch/powerpc/kernel/e500-pmu.c
index b150b51..cb2e294 100644
--- a/arch/powerpc/kernel/e500-pmu.c
+++ b/arch/powerpc/kernel/e500-pmu.c
@@ -75,6 +75,11 @@ static int e500_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1 	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static int num_events = 128;
diff --git a/arch/powerpc/kernel/mpc7450-pmu.c b/arch/powerpc/kernel/mpc7450-pmu.c
index 2cc5e03..845a584 100644
--- a/arch/powerpc/kernel/mpc7450-pmu.c
+++ b/arch/powerpc/kernel/mpc7450-pmu.c
@@ -388,6 +388,11 @@ static int mpc7450_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 struct power_pmu mpc7450_pmu = {
diff --git a/arch/powerpc/kernel/power4-pmu.c b/arch/powerpc/kernel/power4-pmu.c
index ead8b3c..e9dbc2d 100644
--- a/arch/powerpc/kernel/power4-pmu.c
+++ b/arch/powerpc/kernel/power4-pmu.c
@@ -587,6 +587,11 @@ static int power4_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static struct power_pmu power4_pmu = {
diff --git a/arch/powerpc/kernel/power5+-pmu.c b/arch/powerpc/kernel/power5+-pmu.c
index eca0ac5..f58a2bd 100644
--- a/arch/powerpc/kernel/power5+-pmu.c
+++ b/arch/powerpc/kernel/power5+-pmu.c
@@ -653,6 +653,11 @@ static int power5p_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1		},
 		[C(OP_PREFETCH)] = {	-1,		-1		},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
 };
 
 static struct power_pmu power5p_pmu = {
diff --git a/arch/powerpc/kernel/power5-pmu.c b/arch/powerpc/kernel/power5-pmu.c
index d5ff0f6..b1acab6 100644
--- a/arch/powerpc/kernel/power5-pmu.c
+++ b/arch/powerpc/kernel/power5-pmu.c
@@ -595,6 +595,11 @@ static int power5_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1		},
 		[C(OP_PREFETCH)] = {	-1,		-1		},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
 };
 
 static struct power_pmu power5_pmu = {
diff --git a/arch/powerpc/kernel/power6-pmu.c b/arch/powerpc/kernel/power6-pmu.c
index 3160392..b24a3a2 100644
--- a/arch/powerpc/kernel/power6-pmu.c
+++ b/arch/powerpc/kernel/power6-pmu.c
@@ -516,6 +516,11 @@ static int power6_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1		},
 		[C(OP_PREFETCH)] = {	-1,		-1		},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1		},
+		[C(OP_WRITE)] = {	-1,		-1		},
+		[C(OP_PREFETCH)] = {	-1,		-1		},
+	},
 };
 
 static struct power_pmu power6_pmu = {
diff --git a/arch/powerpc/kernel/power7-pmu.c b/arch/powerpc/kernel/power7-pmu.c
index 593740f..6d9dccb 100644
--- a/arch/powerpc/kernel/power7-pmu.c
+++ b/arch/powerpc/kernel/power7-pmu.c
@@ -342,6 +342,11 @@ static int power7_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static struct power_pmu power7_pmu = {
diff --git a/arch/powerpc/kernel/ppc970-pmu.c b/arch/powerpc/kernel/ppc970-pmu.c
index 9a6e093..b121de9 100644
--- a/arch/powerpc/kernel/ppc970-pmu.c
+++ b/arch/powerpc/kernel/ppc970-pmu.c
@@ -467,6 +467,11 @@ static int ppc970_cache_events[C(MAX)][C(OP_MAX)][C(RESULT_MAX)] = {
 		[C(OP_WRITE)] = {	-1,		-1	},
 		[C(OP_PREFETCH)] = {	-1,		-1	},
 	},
+	[C(NODE)] = {		/* 	RESULT_ACCESS	RESULT_MISS */
+		[C(OP_READ)] = {	-1,		-1	},
+		[C(OP_WRITE)] = {	-1,		-1	},
+		[C(OP_PREFETCH)] = {	-1,		-1	},
+	},
 };
 
 static struct power_pmu ppc970_pmu = {
diff --git a/arch/sh/kernel/cpu/sh4/perf_event.c b/arch/sh/kernel/cpu/sh4/perf_event.c
index 748955d..fa4f724 100644
--- a/arch/sh/kernel/cpu/sh4/perf_event.c
+++ b/arch/sh/kernel/cpu/sh4/perf_event.c
@@ -180,6 +180,21 @@ static const int sh7750_cache_events
 			[ C(RESULT_MISS)   ] = -1,
 		},
 	},
+
+	[ C(NODE) ] = {
+		[ C(OP_READ) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_WRITE) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_PREFETCH) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+	},
 };
 
 static int sh7750_event_map(int event)
diff --git a/arch/sh/kernel/cpu/sh4a/perf_event.c b/arch/sh/kernel/cpu/sh4a/perf_event.c
index 17e6beb..84a2c39 100644
--- a/arch/sh/kernel/cpu/sh4a/perf_event.c
+++ b/arch/sh/kernel/cpu/sh4a/perf_event.c
@@ -205,6 +205,21 @@ static const int sh4a_cache_events
 			[ C(RESULT_MISS)   ] = -1,
 		},
 	},
+
+	[ C(NODE) ] = {
+		[ C(OP_READ) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_WRITE) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+		[ C(OP_PREFETCH) ] = {
+			[ C(RESULT_ACCESS) ] = -1,
+			[ C(RESULT_MISS)   ] = -1,
+		},
+	},
 };
 
 static int sh4a_event_map(int event)
diff --git a/arch/sparc/kernel/perf_event.c b/arch/sparc/kernel/perf_event.c
index 0b32f2e..62a0343 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -246,6 +246,20 @@ static const cache_map_t ultra3_cache_map = {
 		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = { CACHE_OP_UNSUPPORTED },
+		[C(RESULT_MISS)  ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+},
 };
 
 static const struct sparc_pmu ultra3_pmu = {
@@ -361,6 +375,20 @@ static const cache_map_t niagara1_cache_map = {
 		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = { CACHE_OP_UNSUPPORTED },
+		[C(RESULT_MISS)  ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+},
 };
 
 static const struct sparc_pmu niagara1_pmu = {
@@ -473,6 +501,20 @@ static const cache_map_t niagara2_cache_map = {
 		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
 	},
 },
+[C(NODE)] = {
+	[C(OP_READ)] = {
+		[C(RESULT_ACCESS)] = { CACHE_OP_UNSUPPORTED },
+		[C(RESULT_MISS)  ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = { CACHE_OP_UNSUPPORTED },
+		[ C(RESULT_MISS)   ] = { CACHE_OP_UNSUPPORTED },
+	},
+},
 };
 
 static const struct sparc_pmu niagara2_pmu = {
diff --git a/arch/x86/kernel/cpu/perf_event_amd.c b/arch/x86/kernel/cpu/perf_event_amd.c
index fe29c1d..941caa2 100644
--- a/arch/x86/kernel/cpu/perf_event_amd.c
+++ b/arch/x86/kernel/cpu/perf_event_amd.c
@@ -89,6 +89,20 @@ static __initconst const u64 amd_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0xb8e9, /* CPU Request to Memory, l+r */
+		[ C(RESULT_MISS)   ] = 0x98e9, /* CPU Request to Memory, r   */
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
 };
 
 /*
diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 5c44862..bf6f92f 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -226,6 +226,21 @@ static __initconst const u64 snb_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
+
 };
 
 static __initconst const u64 westmere_hw_cache_event_ids
@@ -327,6 +342,20 @@ static __initconst const u64 westmere_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+ },
 };
 
 /*
@@ -379,7 +408,21 @@ static __initconst const u64 nehalem_hw_cache_extra_regs
 		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_L3_ACCESS,
 		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_L3_MISS,
 	},
- }
+ },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = NHM_DMND_READ|NHM_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = NHM_DMND_READ|NHM_REMOTE_DRAM,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = NHM_DMND_WRITE|NHM_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = NHM_DMND_WRITE|NHM_REMOTE_DRAM,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_REMOTE_DRAM,
+	},
+ },
 };
 
 static __initconst const u64 nehalem_hw_cache_event_ids
@@ -481,6 +524,20 @@ static __initconst const u64 nehalem_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		[ C(RESULT_MISS)   ] = 0x01b7,
+	},
+ },
 };
 
 static __initconst const u64 core2_hw_cache_event_ids
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index d6e6a67..fb901c5 100644
--- a/arch/x86/kernel/cpu/perf_event_p4.c
+++ b/arch/x86/kernel/cpu/perf_event_p4.c
@@ -554,6 +554,20 @@ static __initconst const u64 p4_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = -1,
+		[ C(RESULT_MISS)   ] = -1,
+	},
+ },
 };
 
 static u64 p4_general_events[PERF_COUNT_HW_MAX] = {
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 069315e..a5f54b9 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -61,7 +61,7 @@ enum perf_hw_id {
 /*
  * Generalized hardware cache events:
  *
- *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU } x
+ *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU, NODE } x
  *       { read, write, prefetch } x
  *       { accesses, misses }
  */
@@ -72,6 +72,7 @@ enum perf_hw_cache_id {
 	PERF_COUNT_HW_CACHE_DTLB		= 3,
 	PERF_COUNT_HW_CACHE_ITLB		= 4,
 	PERF_COUNT_HW_CACHE_BPU			= 5,
+	PERF_COUNT_HW_CACHE_NODE		= 6,
 
 	PERF_COUNT_HW_CACHE_MAX,		/* non-ABI */
 };
