Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab1C2Ovt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:51:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59748 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1C2Ovs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:51:48 -0400
From: Eric B Munson <emunson@mgebm.net>
To: benh@kernel.crashing.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org,
        Eric B Munson <emunson@mgebm.net>, stable@kernel.org
Subject: [PATCH V2] POWER: perf_event: Skip updating kernel counters if register value shrinks
Date: Tue, 29 Mar 2011 10:51:42 -0400
Message-Id: <1301410302-7270-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because of speculative event roll back, it is possible for some event coutners
to decrease between reads on POWER7.  This causes a problem with the way that
counters are updated.  Delta calues are calculated in a 64 bit value and the
top 32 bits are masked.  If the register value has decreased, this leaves us
with a very large positive value added to the kernel counters.  This patch
protects against this by skipping the update if the delta would be negative.
This can lead to a lack of precision in the coutner values, but from my testing
the value is typcially fewer than 10 samples at a time.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Cc: stable@kernel.org
---
Changes from V1:
 Updated patch leader
 Added stable CC
 Use an s32 to hold delta values and discard any values that are less than 0

 arch/powerpc/kernel/perf_event.c |   34 +++++++++++++++++++++++++++-------
 1 files changed, 27 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 97e0ae4..0a5178f 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -416,6 +416,15 @@ static void power_pmu_read(struct perf_event *event)
 		prev = local64_read(&event->hw.prev_count);
 		barrier();
 		val = read_pmc(event->hw.idx);
+		/*
+		 * POWER7 can roll back counter values, if the new value is
+		 * smaller than the previous value it will cause the delta
+		 * and the counter to have bogus values.  If this is the
+		 * case skip updating anything until the counter grows again.
+		 * This can lead to a small lack of precision in the counters.
+		 */
+		if (val < prev)
+			return;
 	} while (local64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
 
 	/* The counters are only 32 bits wide */
@@ -439,7 +448,8 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
 				    unsigned long pmc5, unsigned long pmc6)
 {
 	struct perf_event *event;
-	u64 val, prev, delta;
+	u64 val, prev;
+	s32 delta;
 	int i;
 
 	for (i = 0; i < cpuhw->n_limited; ++i) {
@@ -449,8 +459,13 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
 		prev = local64_read(&event->hw.prev_count);
 		event->hw.idx = 0;
-		delta = (val - prev) & 0xfffffffful;
-		local64_add(delta, &event->count);
+		/*
+		 * The PerfMon registers are only 32 bits wide so the
+		 * delta should not overflow.
+		 */
+		delta = val - prev;
+		if (delta > 0)
+			local64_add(delta, &event->count);
 	}
 }
 
@@ -458,14 +473,16 @@ static void thaw_limited_counters(struct cpu_hw_events *cpuhw,
 				  unsigned long pmc5, unsigned long pmc6)
 {
 	struct perf_event *event;
-	u64 val;
+	u64 val, prev;
 	int i;
 
 	for (i = 0; i < cpuhw->n_limited; ++i) {
 		event = cpuhw->limited_counter[i];
 		event->hw.idx = cpuhw->limited_hwidx[i];
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
-		local64_set(&event->hw.prev_count, val);
+		prev = local64_read(&event->hw.prev_count);
+		if (val > prev)
+			local64_set(&event->hw.prev_count, val);
 		perf_event_update_userpage(event);
 	}
 }
@@ -1187,7 +1204,8 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 			       struct pt_regs *regs, int nmi)
 {
 	u64 period = event->hw.sample_period;
-	s64 prev, delta, left;
+	s64 prev, left;
+	s32 delta;
 	int record = 0;
 
 	if (event->hw.state & PERF_HES_STOPPED) {
@@ -1197,7 +1215,9 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 
 	/* we don't have to worry about interrupts here */
 	prev = local64_read(&event->hw.prev_count);
-	delta = (val - prev) & 0xfffffffful;
+	delta = val - prev;
+	if (delta < 0)
+		delta = 0;
 	local64_add(delta, &event->count);
 
 	/*
-- 
1.7.1

