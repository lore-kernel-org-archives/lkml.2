Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031045Ab2CITta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 14:49:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:61197 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030906Ab2CITtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 14:49:25 -0500
Message-Id: <20120309190207.970552231@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 09 Mar 2012 11:03:12 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: [ 70/95] ARM: 7357/1: perf: fix overflow handling for xscale2 PMUs
In-Reply-To: <20120309194424.GA2134@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will.deacon@arm.com>

commit 3f31ae121348afd9ed39700ea2a63c17cd7eeed1 upstream.

xscale2 PMUs indicate overflow not via the PMU control register, but by
a separate overflow FLAG register instead.

This patch fixes the xscale2 PMU code to use this register to detect
to overflow and ensures that we clear any pending overflow when
disabling a counter.

Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/kernel/perf_event_xscale.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/arch/arm/kernel/perf_event_xscale.c
+++ b/arch/arm/kernel/perf_event_xscale.c
@@ -596,7 +596,7 @@ xscale2pmu_handle_irq(int irq_num, void
 		if (!event)
 			continue;
 
-		if (!xscale2_pmnc_counter_has_overflowed(pmnc, idx))
+		if (!xscale2_pmnc_counter_has_overflowed(of_flags, idx))
 			continue;
 
 		hwc = &event->hw;
@@ -667,7 +667,7 @@ xscale2pmu_enable_event(struct hw_perf_e
 static void
 xscale2pmu_disable_event(struct hw_perf_event *hwc, int idx)
 {
-	unsigned long flags, ien, evtsel;
+	unsigned long flags, ien, evtsel, of_flags;
 	struct pmu_hw_events *events = cpu_pmu->get_hw_events();
 
 	ien = xscale2pmu_read_int_enable();
@@ -676,26 +676,31 @@ xscale2pmu_disable_event(struct hw_perf_
 	switch (idx) {
 	case XSCALE_CYCLE_COUNTER:
 		ien &= ~XSCALE2_CCOUNT_INT_EN;
+		of_flags = XSCALE2_CCOUNT_OVERFLOW;
 		break;
 	case XSCALE_COUNTER0:
 		ien &= ~XSCALE2_COUNT0_INT_EN;
 		evtsel &= ~XSCALE2_COUNT0_EVT_MASK;
 		evtsel |= XSCALE_PERFCTR_UNUSED << XSCALE2_COUNT0_EVT_SHFT;
+		of_flags = XSCALE2_COUNT0_OVERFLOW;
 		break;
 	case XSCALE_COUNTER1:
 		ien &= ~XSCALE2_COUNT1_INT_EN;
 		evtsel &= ~XSCALE2_COUNT1_EVT_MASK;
 		evtsel |= XSCALE_PERFCTR_UNUSED << XSCALE2_COUNT1_EVT_SHFT;
+		of_flags = XSCALE2_COUNT1_OVERFLOW;
 		break;
 	case XSCALE_COUNTER2:
 		ien &= ~XSCALE2_COUNT2_INT_EN;
 		evtsel &= ~XSCALE2_COUNT2_EVT_MASK;
 		evtsel |= XSCALE_PERFCTR_UNUSED << XSCALE2_COUNT2_EVT_SHFT;
+		of_flags = XSCALE2_COUNT2_OVERFLOW;
 		break;
 	case XSCALE_COUNTER3:
 		ien &= ~XSCALE2_COUNT3_INT_EN;
 		evtsel &= ~XSCALE2_COUNT3_EVT_MASK;
 		evtsel |= XSCALE_PERFCTR_UNUSED << XSCALE2_COUNT3_EVT_SHFT;
+		of_flags = XSCALE2_COUNT3_OVERFLOW;
 		break;
 	default:
 		WARN_ONCE(1, "invalid counter number (%d)\n", idx);
@@ -705,6 +710,7 @@ xscale2pmu_disable_event(struct hw_perf_
 	raw_spin_lock_irqsave(&events->pmu_lock, flags);
 	xscale2pmu_write_event_select(evtsel);
 	xscale2pmu_write_int_enable(ien);
+	xscale2pmu_write_overflow_flags(of_flags);
 	raw_spin_unlock_irqrestore(&events->pmu_lock, flags);
 }
 


