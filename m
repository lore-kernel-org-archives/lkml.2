Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752527Ab1CYN2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:28:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61132 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752104Ab1CYN2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:28:22 -0400
From: Eric B Munson <emunson@mgebm.net>
To: benh@kernel.crashing.org
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, anton@samba.org,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH] POWER: perf_event: Skip updating kernel counters if register value shrinks
Date: Fri, 25 Mar 2011 09:28:09 -0400
Message-Id: <1301059689-4556-1-git-send-email-emunson@mgebm.net>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible on POWER7 for some perf events to have values decrease.  This
causes a problem with the way the kernel counters are updated.  Deltas are
computed and then stored in a 64 bit value while the registers are 32 bits
wide so if new value is smaller than previous value, the delta is a very
large positive value.  As a work around this patch skips updating the kernel
counter in when the new value is smaller than the previous.  This can lead to
a lack of precision in the coutner values, but from my testing the value is
typcially fewer than 10 samples at a time.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
---
 arch/powerpc/kernel/perf_event.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/kernel/perf_event.c b/arch/powerpc/kernel/perf_event.c
index 97e0ae4..6752dc1 100644
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
@@ -449,8 +458,10 @@ static void freeze_limited_counters(struct cpu_hw_events *cpuhw,
 		val = (event->hw.idx == 5) ? pmc5 : pmc6;
 		prev = local64_read(&event->hw.prev_count);
 		event->hw.idx = 0;
-		delta = (val - prev) & 0xfffffffful;
-		local64_add(delta, &event->count);
+		if (val >= prev) {
+			delta = (val - prev) & 0xfffffffful;
+			local64_add(delta, &event->count);
+		}
 	}
 }
 
@@ -458,14 +469,16 @@ static void thaw_limited_counters(struct cpu_hw_events *cpuhw,
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
@@ -1197,7 +1210,10 @@ static void record_and_restart(struct perf_event *event, unsigned long val,
 
 	/* we don't have to worry about interrupts here */
 	prev = local64_read(&event->hw.prev_count);
-	delta = (val - prev) & 0xfffffffful;
+	if (val < prev)
+		delta = 0;
+	else
+		delta = (val - prev) & 0xfffffffful;
 	local64_add(delta, &event->count);
 
 	/*
-- 
1.7.1

