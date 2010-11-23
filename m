Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753640Ab0KWWsM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:48:12 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57394 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752975Ab0KWWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:48:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=HnTy8Shba+REUHggAidhIb50jcsXw8pXhoa+oYT3acdw1oz63Q00XxKXUrsJKM58wN
         TF4SSSTJAAnvczkXQcExpxopYN7LVIxNi6k6pOG4iCpiZXxxeVF5mWDpYhxqSx/0f1CB
         tVOcuqyNrnwrMZltVp/4GcnHHx5mvRpcya0hI=
Message-Id: <20101123224800.485217113@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 24 Nov 2010 01:46:03 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: ming.m.lin@intel.com, eranian@google.com, peterz@infradead.org,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 2/3] perf, x86: P4 PMU - Fix unflagged overflows handling v4
References: <20101123224601.766827604@openvz.org>
Content-Disposition: inline; filename=perf-x86-p4-nmi-4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason pointed out that kgdb no longer works with new
nmi-watchdog. Don found that P4 PMU reads CCCR register
instead of counter itself (in attempt to catch unflagged
event).

Testing high bit of counter didn't resolve the situation
in a complete way, the kgdb became working but perf top
still fails.

Lets read the all valuable bits from the counter and check them
for being oveflowed.

At least this patch eliminates wrong read operation though
perf top failure still requires to be investigated.

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

Don, I know this one still doesn't improve the situation on real p4 cpu
with perf top if nmi-watchdog enabled, but at least lets put it public
for more wide review, maybe some idea will appear :)

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

