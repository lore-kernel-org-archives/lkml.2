Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756939Ab1DVWzR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 18:55:17 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50047 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab1DVWzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 18:55:14 -0400
Subject: Re: [PATCH 1/1] perf tools: Add missing user space support for
 config1/config2
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Stephane Eranian <eranian@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1303509293.4865.10.camel@laptop>
References: <1303407662-15564-1-git-send-email-acme@infradead.org>
	 <1303407662-15564-2-git-send-email-acme@infradead.org>
	 <20110422063429.GA16643@elte.hu>  <20110422080604.GA22611@elte.hu>
	 <1303508226.4865.8.camel@laptop>  <1303509293.4865.10.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 23 Apr 2011 00:57:42 +0200
Message-ID: <1303513062.4865.20.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-22 at 23:54 +0200, Peter Zijlstra wrote:
> On Fri, 2011-04-22 at 23:37 +0200, Peter Zijlstra wrote:
> > The below needs filling out for !x86 (which I filled out with
> > unsupported events) and x86 needs the offcore bits fixed to auto select
> > between the two offcore events.
> 
> Urgh, so SNB has different MSR_OFFCORE_RESPONSE bits and needs another table.

Also, NHM offcore bits were wrong... it implemented _ACCESS as _HIT and
counted OTHER_CORE_HIT* as MISS even though its clearly documented as an
L3 hit.

Current scribblings below..

---
 arch/arm/kernel/perf_event_v6.c        |   28 ++++
 arch/arm/kernel/perf_event_v7.c        |   28 ++++
 arch/arm/kernel/perf_event_xscale.c    |   14 ++
 arch/mips/kernel/perf_event_mipsxx.c   |   28 ++++
 arch/powerpc/kernel/e500-pmu.c         |    5 +
 arch/powerpc/kernel/mpc7450-pmu.c      |    5 +
 arch/powerpc/kernel/power4-pmu.c       |    5 +
 arch/powerpc/kernel/power5+-pmu.c      |    5 +
 arch/powerpc/kernel/power5-pmu.c       |    5 +
 arch/powerpc/kernel/power6-pmu.c       |    5 +
 arch/powerpc/kernel/power7-pmu.c       |    5 +
 arch/powerpc/kernel/ppc970-pmu.c       |    5 +
 arch/sh/kernel/cpu/sh4/perf_event.c    |   15 ++
 arch/sh/kernel/cpu/sh4a/perf_event.c   |   15 ++
 arch/sparc/kernel/perf_event.c         |   42 ++++++
 arch/x86/kernel/cpu/perf_event_amd.c   |   14 ++
 arch/x86/kernel/cpu/perf_event_intel.c |  253 +++++++++++++++++++++++++++-----
 arch/x86/kernel/cpu/perf_event_p4.c    |   14 ++
 include/linux/perf_event.h             |    3 +-
 19 files changed, 458 insertions(+), 36 deletions(-)

diff --git a/arch/arm/kernel/perf_event_v6.c b/arch/arm/kernel/perf_event_v6.c
index f1e8dd9..02178da 100644
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
index 4960686..79ffc83 100644
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
index 39affbe..7ed1a55 100644
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
index ee8426e..d890e0f 100644
--- a/arch/sparc/kernel/perf_event.c
+++ b/arch/sparc/kernel/perf_event.c
@@ -245,6 +245,20 @@ static const cache_map_t ultra3_cache_map = {
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
@@ -360,6 +374,20 @@ static const cache_map_t niagara1_cache_map = {
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
@@ -472,6 +500,20 @@ static const cache_map_t niagara2_cache_map = {
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
index cf4e369..01c7dd3 100644
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
index 43fa20b..fe4e8b1 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -150,6 +150,86 @@ static u64 intel_pmu_event_map(int hw_event)
 	return intel_perfmon_event_map[hw_event];
 }
 
+/*
+ * Sandy Bridge MSR_OFFCORE_RESPONSE bits;
+ * See IA32 SDM Vol 3B 30.8.5
+ */
+
+#define SNB_DMND_DATA_RD	(1 << 0)
+#define SNB_DMND_RFO		(1 << 1)
+#define SNB_DMND_IFETCH		(1 << 2)
+#define SNB_DMND_WB		(1 << 3)
+#define SNB_PF_DATA_RD		(1 << 4)
+#define SNB_PF_DATA_RFO		(1 << 5)
+#define SNB_PF_IFETCH		(1 << 6)
+#define SNB_PF_LLC_DATA_RD	(1 << 7)
+#define SNB_PF_LLC_RFO		(1 << 8)
+#define SNB_PF_LLC_IFETCH	(1 << 9)
+#define SNB_BUS_LOCKS		(1 << 10)
+#define SNB_STRM_ST		(1 << 11)
+        			/* hole */
+#define SNB_OFFCORE_OTHER	(1 << 15)
+#define SNB_COMMON		(1 << 16)
+#define SNB_NO_SUPP		(1 << 17)
+#define SNB_LLC_HITM		(1 << 18)
+#define SNB_LLC_HITE		(1 << 19)
+#define SNB_LLC_HITS		(1 << 20)
+#define SNB_LLC_HITF		(1 << 21)
+				/* hole */
+#define SNB_SNP_NONE		(1 << 31)
+#define SNB_SNP_NOT_NEEDED	(1 << 32)
+#define SNB_SNP_MISS		(1 << 33)
+#define SNB_SNP_NO_FWD		(1 << 34)
+#define SNB_SNP_FWD		(1 << 35)
+#define SNB_HITM		(1 << 36)
+#define SNB_NON_DRAM		(1 << 37)
+
+#define SNB_DMND_READ		(SNB_DMND_DATA_RD)
+#define SNB_DMND_WRITE		(SNB_DMND_RFO|SNB_DMND_WB|SNB_STRM_ST)
+#define SNB_DMND_PREFETCH	(SNB_PF_DATA_RD|SNB_PF_DATA_RFO)
+
+#define SNB_L3_HIT		()
+#define SNB_L3_MISS		()
+#define SNB_L3_ACCESS		(SNB_L3_HIT|SNB_L3_MISS)
+
+#define SNB_ALL_DRAM		()
+#define SNB_REMOTE_DRAM		()
+
+static __initconst const u64 snb_hw_cache_extra_regs
+				[PERF_COUNT_HW_CACHE_MAX]
+				[PERF_COUNT_HW_CACHE_OP_MAX]
+				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
+{
+ [ C(LL  ) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_READ|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_READ|SNB_L3_MISS,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_WRITE|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_WRITE|SNB_L3_MISS,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_PREFETCH|SNB_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = SNB_DMND_PREFETCH|SNB_L3_MISS,
+	},
+ }
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_READ|SNB_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = SNB_DMND_READ|SNB_REMOTE_DRAM,
+	},
+	[ C(OP_WRITE) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_WRITE|SNB_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = SNB_DMND_WRITE|SNB_REMOTE_DRAM,
+	},
+	[ C(OP_PREFETCH) ] = {
+		[ C(RESULT_ACCESS) ] = SNB_DMND_PREFETCH|SNB_ALL_DRAM,
+		[ C(RESULT_MISS)   ] = SNB_DMND_PREFETCH|SNB_REMOTE_DRAM,
+	},
+ },
+};
+
 static __initconst const u64 snb_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
@@ -184,26 +264,23 @@ static __initconst const u64 snb_hw_cache_event_ids
 	},
  },
  [ C(LL  ) ] = {
-	/*
-	 * TBD: Need Off-core Response Performance Monitoring support
-	 */
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_WRITE) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_RFO.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_RFO.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -248,6 +325,20 @@ static __initconst const u64 snb_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7, /* OFFCORE_RESP */
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
 
 static __initconst const u64 westmere_hw_cache_event_ids
@@ -285,26 +376,26 @@ static __initconst const u64 westmere_hw_cache_event_ids
  },
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		/* OFFCORE_RESPONSE_0.ANY_DATA.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.ANY_DATA.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.ANY_DATA.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.ANY_DATA.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	/*
 	 * Use RFO, not WRITEBACK, because a write miss would typically occur
 	 * on RFO.
 	 */
 	[ C(OP_WRITE) ] = {
-		/* OFFCORE_RESPONSE_1.ANY_RFO.LOCAL_CACHE */
-		[ C(RESULT_ACCESS) ] = 0x01bb,
-		/* OFFCORE_RESPONSE_0.ANY_RFO.ANY_LLC_MISS */
+		/* OFFCORE_RESPONSE.ANY_RFO.LOCAL_CACHE */
+		[ C(RESULT_ACCESS) ] = 0x01b7,
+		/* OFFCORE_RESPONSE.ANY_RFO.ANY_LLC_MISS */
 		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
 	[ C(OP_PREFETCH) ] = {
-		/* OFFCORE_RESPONSE_0.PREFETCH.LOCAL_CACHE */
+		/* OFFCORE_RESPONSE.PREFETCH.LOCAL_CACHE */
 		[ C(RESULT_ACCESS) ] = 0x01b7,
-		/* OFFCORE_RESPONSE_1.PREFETCH.ANY_LLC_MISS */
-		[ C(RESULT_MISS)   ] = 0x01bb,
+		/* OFFCORE_RESPONSE.PREFETCH.ANY_LLC_MISS */
+		[ C(RESULT_MISS)   ] = 0x01b7,
 	},
  },
  [ C(DTLB) ] = {
@@ -349,19 +440,53 @@ static __initconst const u64 westmere_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7, /* OFFCORE_RESP */
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
- * OFFCORE_RESPONSE MSR bits (subset), See IA32 SDM Vol 3 30.6.1.3
+ * Nehalem/Westmere MSR_OFFCORE_RESPONSE bits;
+ * See IA32 SDM Vol 3B 30.6.1.3
  */
 
-#define DMND_DATA_RD     (1 << 0)
-#define DMND_RFO         (1 << 1)
-#define DMND_WB          (1 << 3)
-#define PF_DATA_RD       (1 << 4)
-#define PF_DATA_RFO      (1 << 5)
-#define RESP_UNCORE_HIT  (1 << 8)
-#define RESP_MISS        (0xf600) /* non uncore hit */
+#define NHM_DMND_DATA_RD	(1 << 0)
+#define NHM_DMND_RFO		(1 << 1)
+#define NHM_DMND_IFETCH		(1 << 2)
+#define NHM_DMND_WB		(1 << 3)
+#define NHM_PF_DATA_RD		(1 << 4)
+#define NHM_PF_DATA_RFO		(1 << 5)
+#define NHM_PF_IFETCH		(1 << 6)
+#define NHM_OFFCORE_OTHER	(1 << 7)
+#define NHM_UNCORE_HIT		(1 << 8)
+#define NHM_OTHER_CORE_HIT_SNP	(1 << 9)
+#define NHM_OTHER_CORE_HITM	(1 << 10)
+        			/* reserved */
+#define NHM_REMOTE_CACHE_FWD	(1 << 12)
+#define NHM_REMOTE_DRAM		(1 << 13)
+#define NHM_LOCAL_DRAM		(1 << 14)
+#define NHM_NON_DRAM		(1 << 15)
+
+#define NHM_ALL_DRAM		(NHM_REMOTE_DRAM|NHM_LOCAL_DRAM)
+
+#define NHM_DMND_READ		(NHM_DMND_DATA_RD)
+#define NHM_DMND_WRITE		(NHM_DMND_RFO|NHM_DMND_WB)
+#define NHM_DMND_PREFETCH	(NHM_PF_DATA_RD|NHM_PF_DATA_RFO)
+
+#define NHM_L3_HIT	(NHM_UNCORE_HIT|NHM_OTHER_CORE_HIT_SNP|NHM_OTHER_CORE_HITM)
+#define NHM_L3_MISS	(NHM_NON_DRAM|NHM_ALL_DRAM|NHM_REMOTE_CACHE_FWD)
+#define NHM_L3_ACCESS	(NHM_L3_HIT|NHM_L3_MISS)
 
 static __initconst const u64 nehalem_hw_cache_extra_regs
 				[PERF_COUNT_HW_CACHE_MAX]
@@ -370,18 +495,32 @@ static __initconst const u64 nehalem_hw_cache_extra_regs
 {
  [ C(LL  ) ] = {
 	[ C(OP_READ) ] = {
-		[ C(RESULT_ACCESS) ] = DMND_DATA_RD|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = DMND_DATA_RD|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_READ|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_READ|NHM_L3_MISS,
 	},
 	[ C(OP_WRITE) ] = {
-		[ C(RESULT_ACCESS) ] = DMND_RFO|DMND_WB|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = DMND_RFO|DMND_WB|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_WRITE|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_WRITE|NHM_L3_MISS,
 	},
 	[ C(OP_PREFETCH) ] = {
-		[ C(RESULT_ACCESS) ] = PF_DATA_RD|PF_DATA_RFO|RESP_UNCORE_HIT,
-		[ C(RESULT_MISS)   ] = PF_DATA_RD|PF_DATA_RFO|RESP_MISS,
+		[ C(RESULT_ACCESS) ] = NHM_DMND_PREFETCH|NHM_L3_ACCESS,
+		[ C(RESULT_MISS)   ] = NHM_DMND_PREFETCH|NHM_L3_MISS,
 	},
  }
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
@@ -483,6 +622,20 @@ static __initconst const u64 nehalem_hw_cache_event_ids
 		[ C(RESULT_MISS)   ] = -1,
 	},
  },
+ [ C(NODE) ] = {
+	[ C(OP_READ) ] = {
+		[ C(RESULT_ACCESS) ] = 0x01b7, /* OFFCORE_RESP */
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
@@ -574,6 +727,20 @@ static __initconst const u64 core2_hw_cache_event_ids
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
 
 static __initconst const u64 atom_hw_cache_event_ids
@@ -665,6 +832,20 @@ static __initconst const u64 atom_hw_cache_event_ids
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
 
 static void intel_pmu_disable_all(void)
@@ -1444,6 +1625,8 @@ static __init int intel_pmu_init(void)
 	case 42: /* SandyBridge */
 		memcpy(hw_cache_event_ids, snb_hw_cache_event_ids,
 		       sizeof(hw_cache_event_ids));
+		memcpy(hw_cache_extra_regs, snb_hw_cache_extra_regs,
+		       sizeof(hw_cache_extra_regs));
 
 		intel_pmu_lbr_init_nhm();
 
diff --git a/arch/x86/kernel/cpu/perf_event_p4.c b/arch/x86/kernel/cpu/perf_event_p4.c
index 74507c1..e802c7e 100644
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
index ee9f1e7..df4a841 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -59,7 +59,7 @@ enum perf_hw_id {
 /*
  * Generalized hardware cache events:
  *
- *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU } x
+ *       { L1-D, L1-I, LLC, ITLB, DTLB, BPU, NODE } x
  *       { read, write, prefetch } x
  *       { accesses, misses }
  */
@@ -70,6 +70,7 @@ enum perf_hw_cache_id {
 	PERF_COUNT_HW_CACHE_DTLB		= 3,
 	PERF_COUNT_HW_CACHE_ITLB		= 4,
 	PERF_COUNT_HW_CACHE_BPU			= 5,
+	PERF_COUNT_HW_CACHE_NODE		= 6,
 
 	PERF_COUNT_HW_CACHE_MAX,		/* non-ABI */
 };


