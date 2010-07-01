Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756493Ab0GAOgY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 10:36:24 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:32925 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756466Ab0GAOgV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 10:36:21 -0400
Subject: Re: [RFC][PATCH 00/11] perf pmu interface -v2
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
In-Reply-To: <1277477401.32034.670.camel@twins>
References: <20100624142804.431553874@chello.nl>
	 <1277464288.26786.3.camel@e102144-lin.cambridge.arm.com>
	 <1277464589.32034.276.camel@twins>
	 <1277476604.24751.8.camel@e102144-lin.cambridge.arm.com>
	 <1277477401.32034.670.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 01 Jul 2010 16:36:10 +0200
Message-ID: <1277994970.1917.184.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-06-25 at 16:50 +0200, Peter Zijlstra wrote:

> Not exactly sure how I could have messed up the ARM architecture code to
> make this happen though... will have a peek. 

I did find a bug in there, not sure it could have been responsible for
this but who knows...

Pushed out a new git tree with the below delta folded in.

---
Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -221,27 +221,6 @@ again:
 }
 
 static void
-armpmu_del(struct perf_event *event, int flags)
-{
-	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
-	struct hw_perf_event *hwc = &event->hw;
-	int idx = hwc->idx;
-
-	WARN_ON(idx < 0);
-
-	clear_bit(idx, cpuc->active_mask);
-	armpmu->disable(hwc, idx);
-
-	barrier();
-
-	armpmu_event_update(event, hwc, idx);
-	cpuc->events[idx] = NULL;
-	clear_bit(idx, cpuc->used_mask);
-
-	perf_event_update_userpage(event);
-}
-
-static void
 armpmu_read(struct perf_event *event)
 {
 	struct hw_perf_event *hwc = &event->hw;
@@ -267,6 +246,8 @@ armpmu_stop(struct perf_event *event, in
 	 */
 	if (!(hwc->state & PERF_HES_STOPPED)) {
 		armpmu->disable(hwc, hwc->idx);
+		barrier(); /* why? */
+		armpmu_event_update(event, hwc, hwc->idx);
 		hwc->state |= PERF_HES_STOPPED | PERF_HES_UPTODATE;
 	}
 }
@@ -289,7 +270,7 @@ armpmu_start(struct perf_event *event, i
 	hwc->state = 0;
 	/*
 	 * Set the period again. Some counters can't be stopped, so when we
-	 * were throttled we simply disabled the IRQ source and the counter
+	 * were stopped we simply disabled the IRQ source and the counter
 	 * may have been left counting. If we don't do this step then we may
 	 * get an interrupt too soon or *way* too late if the overflow has
 	 * happened since disabling.
@@ -298,6 +279,23 @@ armpmu_start(struct perf_event *event, i
 	armpmu->enable(hwc, hwc->idx);
 }
 
+static void
+armpmu_del(struct perf_event *event, int flags)
+{
+	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
+	struct hw_perf_event *hwc = &event->hw;
+	int idx = hwc->idx;
+
+	WARN_ON(idx < 0);
+
+	clear_bit(idx, cpuc->active_mask);
+	armpmu_stop(event, PERF_EF_UPDATE);
+	cpuc->events[idx] = NULL;
+	clear_bit(idx, cpuc->used_mask);
+
+	perf_event_update_userpage(event);
+}
+
 static int
 armpmu_add(struct perf_event *event, int flags)
 {
@@ -1075,7 +1073,7 @@ armv6pmu_handle_irq(int irq_num,
 			continue;
 
 		if (perf_event_overflow(event, 0, &data, regs))
-			armpmu_stop(event, 0);
+			armpmu->disable(hwc, idx);
 	}
 
 	/*

