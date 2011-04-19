Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1DSUUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:20:53 -0400
Received: from kroah.org ([198.145.64.141]:35712 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754949Ab1DSURk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:17:40 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:10:49 2011
Message-Id: <20110419201049.398380594@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:09:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Eric B Munson <emunson@mgebm.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [58/70] powerpc/perf_event: Skip updating kernel counters if register value shrinks
In-Reply-To: <20110419201501.GA8865@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.38-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Eric B Munson <emunson@mgebm.net>

commit 86c74ab317c1ef4d37325e0d7ca8a01a796b0bd7 upstream.

Because of speculative event roll back, it is possible for some event coutners
to decrease between reads on POWER7.  This causes a problem with the way that
counters are updated.  Delta calues are calculated in a 64 bit value and the
top 32 bits are masked.  If the register value has decreased, this leaves us
with a very large positive value added to the kernel counters.  This patch
protects against this by skipping the update if the delta would be negative.
This can lead to a lack of precision in the coutner values, but from my testing
the value is typcially fewer than 10 samples at a time.

Signed-off-by: Eric B Munson <emunson@mgebm.net>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/kernel/perf_event.c |   37 ++++++++++++++++++++++++++++++-------
 1 file changed, 30 insertions(+), 7 deletions(-)

--- a/arch/powerpc/kernel/perf_event.c
+++ b/arch/powerpc/kernel/perf_event.c
@@ -398,6 +398,25 @@ static int check_excludes(struct perf_ev
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
@@ -416,10 +435,11 @@ static void power_pmu_read(struct perf_e
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
@@ -449,8 +469,9 @@ static void freeze_limited_counters(stru
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
 
@@ -458,14 +479,16 @@ static void thaw_limited_counters(struct
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
@@ -1197,7 +1220,7 @@ static void record_and_restart(struct pe
 
 	/* we don't have to worry about interrupts here */
 	prev = local64_read(&event->hw.prev_count);
-	delta = (val - prev) & 0xfffffffful;
+	delta = check_and_compute_delta(prev, val);
 	local64_add(delta, &event->count);
 
 	/*


