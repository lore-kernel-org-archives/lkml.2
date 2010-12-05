Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0LEWeW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 17:34:22 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50394 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166Ab0LEWeV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 17:34:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=hNhTqq/APB794MnUxVwU5EHfov9/qP61rpZ1378W+tOWZwmQfPdaK2y/iXEhQUIEc7
         h3wfFQQHqTNwtRqK3/EYad5r3bV70/GOAAkU2HofgctxQcezEkmvo7kXfFODwnDNwRc4
         RoUR5l0AffT/BK5QoN7II65XYxOhjdgSxBBMQ=
Date: Mon, 6 Dec 2010 01:34:19 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        Lin Ming <ming.m.lin@intel.com>,
        Jason Wessel <jason.wessel@windriver.com>
Cc: Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] perf, x86: P4 PMU - Fix unflagged overflows handling v4
Message-ID: <20101205223419.GE7799@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don found that P4 PMU reads CCCR register instead of counter
itself (in attempt to catch unflagged event) this makes P4
NMI handler to consume all NMIs it observes. So the other
NMI users such as kgdb simply have no chance to get NMI
on their hands.

v2: Call checking_wrmsrl only if needed.
v3: Check the valuable bits.
v4: Leave p4_pmu_clear_cccr_ovf early if P4_CCCR_OVF flag is set.

Reported-by: Jason Wessel <jason.wessel@windriver.com>
Reported-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
---

Ming, Jason, mind to give this patch a shot? Note that it
seems you have to disable nmi-watchdog at bootstrap to be
able to run perf top. I believe it's a different issue
unrelated to this particular nit.

 arch/x86/include/asm/perf_event_p4.h |    3 +++
 arch/x86/kernel/cpu/perf_event_p4.c  |   28 +++++++++++++++-------------
 2 files changed, 18 insertions(+), 13 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -20,6 +20,9 @@
 #define ARCH_P4_MAX_ESCR	(ARCH_P4_TOTAL_ESCR - ARCH_P4_RESERVED_ESCR)
 #define ARCH_P4_MAX_CCCR	(18)
 
+#define ARCH_P4_CNTRVAL_BITS	(40)
+#define ARCH_P4_CNTRVAL_MASK	((1ULL << ARCH_P4_CNTRVAL_BITS) - 1)
+
 #define P4_ESCR_EVENT_MASK	0x7e000000U
 #define P4_ESCR_EVENT_SHIFT	25
 #define P4_ESCR_EVENTMASK_MASK	0x01fffe00U
Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -753,19 +753,21 @@ out:
 
 static inline int p4_pmu_clear_cccr_ovf(struct hw_perf_event *hwc)
 {
-	int overflow = 0;
-	u32 low, high;
+	u64 v;
 
-	rdmsr(hwc->config_base + hwc->idx, low, high);
-
-	/* we need to check high bit for unflagged overflows */
-	if ((low & P4_CCCR_OVF) || !(high & (1 << 31))) {
-		overflow = 1;
-		(void)checking_wrmsrl(hwc->config_base + hwc->idx,
-			((u64)low) & ~P4_CCCR_OVF);
+	/* an official way for overflow indication */
+	rdmsrl(hwc->config_base + hwc->idx, v);
+	if (v & P4_CCCR_OVF) {
+		wrmsrl(hwc->config_base + hwc->idx, v & ~P4_CCCR_OVF);
+		return 1;
 	}
 
-	return overflow;
+	/* it might be unflagged overflow */
+	rdmsrl(hwc->event_base + hwc->idx, v);
+	if (!(v & ARCH_P4_CNTRVAL_MASK))
+		return 1;
+
+	return 0;
 }
 
 static void p4_pmu_disable_pebs(void)
@@ -1152,9 +1154,9 @@ static __initconst const struct x86_pmu 
 	 */
 	.num_counters		= ARCH_P4_MAX_CCCR,
 	.apic			= 1,
-	.cntval_bits		= 40,
-	.cntval_mask		= (1ULL << 40) - 1,
-	.max_period		= (1ULL << 39) - 1,
+	.cntval_bits		= ARCH_P4_CNTRVAL_BITS,
+	.cntval_mask		= ARCH_P4_CNTRVAL_MASK,
+	.max_period		= (1ULL << (ARCH_P4_CNTRVAL_BITS - 1)) - 1,
 	.hw_config		= p4_hw_config,
 	.schedule_events	= p4_pmu_schedule_events,
 	/*
