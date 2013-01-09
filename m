Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757942Ab3AIWM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 17:12:28 -0500
Received: from mail.digium.com ([216.207.245.2]:47711 "EHLO mail.digium.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752199Ab3AIWM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 17:12:27 -0500
Date: Wed, 9 Jan 2013 15:59:42 -0600
From: Shaun Ruffell <sruffell@digium.com>
To: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Ingo Molnar <mingo@kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Rob Landley <rob@landley.net>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] x86/perf_events: Fix "section type conflict" build error.
Message-ID: <20130109215942.GA20350@digium.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130109172255.GA17631@digium.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan Beulich <JBeulich@suse.com>

This patch fixes a build regression first introduced in 3.7 with
(e09df47 "perf/x86: Update/fix generic events on P6 PMU").

At least some older versions of gcc, like (GCC) 4.1.2 20080704 (Red Hat
4.1.2-51), dislike mixing constant and non-const data in the same
section. Without this patch a build will fail with the following error:

    CC      arch/x86/kernel/cpu/perf_event_p6.o
  arch/x86/kernel/cpu/perf_event_p6.c:22: error: p6_hw_cache_event_ids causes a section type conflict
  make[3]: *** [arch/x86/kernel/cpu/perf_event_p6.o] Error 1

Newer versions of gcc simply emits the section as writable (which isn't what
we want, but also is not a big problem as it gets discarded post-init anyway).

Also get the Knight's Corner definitions in sync.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Cc: stable@vger.kernel.org # 3.7.x only
[sruffell@digium.com: Added details to the commit message.]
Signed-off-by: Shaun Ruffell <sruffell@digium.com>

---

[I had the wrong stable email address when I previously sent this.
Sorry about the extra noise.]

Hans, Thomas,

Any chance of picking this up for 3.8? This doesn't seem too
controversial since it only makes sure that data in the __initconst
section is const.

Rob Landley also reported this to the list here:
https://lkml.org/lkml/2012/12/14/511. 

Thanks,
Shaun

 arch/x86/kernel/cpu/perf_event_knc.c | 4 ++--
 arch/x86/kernel/cpu/perf_event_p6.c  | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_knc.c b/arch/x86/kernel/cpu/perf_event_knc.c
index 4b7731b..838fa87 100644
--- a/arch/x86/kernel/cpu/perf_event_knc.c
+++ b/arch/x86/kernel/cpu/perf_event_knc.c
@@ -17,7 +17,7 @@ static const u64 knc_perfmon_event_map[] =
   [PERF_COUNT_HW_BRANCH_MISSES]		= 0x002b,
 };
 
-static __initconst u64 knc_hw_cache_event_ids
+static const u64 __initconst knc_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
@@ -284,7 +284,7 @@ static struct attribute *intel_knc_formats_attr[] = {
 	NULL,
 };
 
-static __initconst struct x86_pmu knc_pmu = {
+static const struct x86_pmu knc_pmu __initconst = {
 	.name			= "knc",
 	.handle_irq		= knc_pmu_handle_irq,
 	.disable_all		= knc_pmu_disable_all,
diff --git a/arch/x86/kernel/cpu/perf_event_p6.c b/arch/x86/kernel/cpu/perf_event_p6.c
index f2af39f..b1e2fe1 100644
--- a/arch/x86/kernel/cpu/perf_event_p6.c
+++ b/arch/x86/kernel/cpu/perf_event_p6.c
@@ -19,7 +19,7 @@ static const u64 p6_perfmon_event_map[] =
 
 };
 
-static __initconst u64 p6_hw_cache_event_ids
+static const u64 __initconst p6_hw_cache_event_ids
 				[PERF_COUNT_HW_CACHE_MAX]
 				[PERF_COUNT_HW_CACHE_OP_MAX]
 				[PERF_COUNT_HW_CACHE_RESULT_MAX] =
-- 
1.8.1
