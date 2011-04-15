Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989Ab1DOSMo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 14:12:44 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:39469 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1DOSMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 14:12:43 -0400
From: Eric B Munson <emunson@mgebm.net>
To: benh@kernel.crashing.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org, David.Laight@ACULAB.COM,
        Eric B Munson <emunson@mgebm.net>, stable@kernel.org
Subject: [PATCH V4] POWER: perf_event: Skip updating kernel counters if register value shrinks
Date: Fri, 15 Apr 2011 14:12:30 -0400
Message-Id: <1302891150-8121-1-git-send-email-emunson@mgebm.net>
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
Changes from V3:
 Fix delta checking so that only roll backs are discarded
Changes from V2:
 Create a helper that should handle counter roll back as well as registers that
might be allowed to roll over
Changes from V1:
 Updated patch leader
 Added stable CC
 Use an s32 to hold delta values and discard any values that are less than 0

 arch/powerpc/kernel/perf_event.c |   37 ++++++++++++++++++++++++++++++-------
 1 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index c4063b7..822f630 100644
--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -398,6 +398,25 @@ static int check_excludes(struct perf_event **ctrs, unsigned int cflags[],
 	return 0;
 }
 
+static u64 check_and_compute_delta(u64 prev, u64 val)
+{
+	u64 delta = (val - prev) & 0xfffffffful;
+
+	/*
+	 * POWER7 can roll back counter values, if the new value is smaller
+	 * than the previous value it will cause the delta and the counter to
+	 * have bogus values unless we rolled a counter over.  If a coutner is
+	 * rolled back, it will be smaller, but within 256, which is the maximum
+	 * number of events to rollback at once.  If we dectect a rollback
+	 * return 0.  This can lead to a small lack of precision in the
+	 * counters.
+	 */
+	if (prev > val && (prev - val) < 256)
+		delta = 0;
+
+	return delta;
+}
+
 static void power_pmu_read(struct perf_event *event)
 {
 	s64 val, delta, prev;
@@ -416,10 +435,11 @@ static void power_pmu_read(struct perf_event *event)
 		prev = local64_read(&event->hw.prev_count);
 		barrier();
 		val = read_pmc(event->hw.idx);
+		delta = check_and_compute_delta(prev, val);
+		if (!delta)
+			return;
 	} while (local64_cmpxchg(&event->hw.prev_count, prev, val) != prev);
 
-	/* The counters are only 32 bits wide */
-	delta = (val - prev) & 0xfffffffful;
 	local64_add(delta, &event->count);
 	local64_sub(delta, &event->hw.period_left);
 }
@@ -449,8 +469,9 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
 		prev = local64_read(&event->hw.prev_count);
 		event->hw.idx = 0;
-		delta = (val - prev) & 0xfffffffful;
-		local64_add(delta, &event->count);
+		delta = check_and_compute_delta(prev, val);
+		if (delta)
+			local64_add(delta, &event->count);
 	}
 }
 
@@ -458,14 +479,16 @@ static void thaw_limited_counters(struct cpu_hw_events *cpuhw,
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
+		if (check_and_compute_delta(prev, val))
+			local64_set(&event->hw.prev_count, val);
 		perf_event_update_userpage(event);
 	}
 }
@@ -1197,7 +1220,7 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 
 	/* we don't have to worry about interrupts here */
 	prev = local64_read(&event->hw.prev_count);
-	delta = (val - prev) & 0xfffffffful;
+	delta = check_and_compute_delta(prev, val);
 	local64_add(delta, &event->count);
 
 	/*
-- 
1.7.1

