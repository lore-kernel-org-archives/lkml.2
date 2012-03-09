Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759397Ab2CIUQg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 15:16:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53292 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031008Ab2CITt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:28 -0500
Message-Id: <20120309190207.900560356@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ming Lei <tom.leiming@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 69/95] ARM: 7356/1: perf: check that we have an event in the PMU IRQ handlers
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit f6f5a30c834135c9f2fa10400c59ebbdd9188567 upstream.

The PMU IRQ handlers in perf assume that if a counter has overflowed
then perf must be responsible. In the paranoid world of crazy hardware,
this could be false, so check that we do have a valid event before
attempting to dereference NULL in the interrupt path.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event_v6.c     |   20 ++------------------
 arch/arm/kernel/perf_event_v7.c     |    4 ++++
 arch/arm/kernel/perf_event_xscale.c |    6 ++++++
 3 files changed, 12 insertions(+), 18 deletions(-)

--- a/arch/arm/kernel/perf_event_v6.c
+++ b/arch/arm/kernel/perf_event_v6.c
@@ -463,23 +463,6 @@ armv6pmu_enable_event(struct hw_perf_eve
 	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
 }
 
-static int counter_is_active(unsigned long pmcr, int idx)
-{
-	unsigned long mask = 0;
-	if (idx == ARMV6_CYCLE_COUNTER)
-		mask = ARMV6_PMCR_CCOUNT_IEN;
-	else if (idx == ARMV6_COUNTER0)
-		mask = ARMV6_PMCR_COUNT0_IEN;
-	else if (idx == ARMV6_COUNTER1)
-		mask = ARMV6_PMCR_COUNT1_IEN;
-
-	if (mask)
-		return pmcr & mask;
-
-	WARN_ONCE(1, "invalid counter number (%d)\n", idx);
-	return 0;
-}
-
 static irqreturn_t
 armv6pmu_handle_irq(int irq_num,
 		    void *dev)
@@ -509,7 +492,8 @@ armv6pmu_handle_irq(int irq_num,
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
 
-		if (!counter_is_active(pmcr, idx))
+		/* Ignore if we don't have an event. */
+		if (!event)
 			continue;
 
 		/*
--- a/arch/arm/kernel/perf_event_v7.c
+++ b/arch/arm/kernel/perf_event_v7.c
@@ -1029,6 +1029,10 @@ static irqreturn_t armv7pmu_handle_irq(i
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
 
+		/* Ignore if we don't have an event. */
+		if (!event)
+			continue;
+
 		/*
 		 * We have a single interrupt for all counters. Check that
 		 * each counter has overflowed before we process it.
--- a/arch/arm/kernel/perf_event_xscale.c
+++ b/arch/arm/kernel/perf_event_xscale.c
@@ -253,6 +253,9 @@ xscale1pmu_handle_irq(int irq_num, void
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
 
+		if (!event)
+			continue;
+
 		if (!xscale1_pmnc_counter_has_overflowed(pmnc, idx))
 			continue;
 
@@ -590,6 +593,9 @@ xscale2pmu_handle_irq(int irq_num, void
 		struct perf_event *event = cpuc->events[idx];
 		struct hw_perf_event *hwc;
 
+		if (!event)
+			continue;
+
 		if (!xscale2_pmnc_counter_has_overflowed(pmnc, idx))
 			continue;
 


