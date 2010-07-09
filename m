Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab0GIIme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 04:42:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:60784 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138Ab0GIIjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 04:39:51 -0400
Message-Id: <20100709083248.276496857@chello.nl>
User-Agent: quilt/0.47-1
Date: Fri, 09 Jul 2010 10:21:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Will Deacon <will.deacon@arm.com>, Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 12/13] perf: Shrink hw_perf_event
References: <20100709082117.631541128@chello.nl>
Content-Disposition: inline; filename=perf-swtimer-period_left.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use hw_perf_event::period_left instead of hw_perf_event::remaning and
win back 8 bytes.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 include/linux/perf_event.h |    1 -
 kernel/perf_event.c        |   13 ++++++-------
 2 files changed, 6 insertions(+), 8 deletions(-)

Index: linux-2.6/include/linux/perf_event.h
===================================================================
--- linux-2.6.orig/include/linux/perf_event.h
+++ linux-2.6/include/linux/perf_event.h
@@ -529,7 +529,6 @@ struct hw_perf_event {
 			int		last_cpu;
 		};
 		struct { /* software */
-			s64		remaining;
 			struct hrtimer	hrtimer;
 		};
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
Index: linux-2.6/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/kernel/perf_event.c
+++ linux-2.6/kernel/perf_event.c
@@ -4590,14 +4590,13 @@ static void perf_swevent_start_hrtimer(s
 	hrtimer_init(&hwc->hrtimer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	hwc->hrtimer.function = perf_swevent_hrtimer;
 	if (hwc->sample_period) {
-		u64 period;
+		s64 period = local64_read(&hwc->period_left);
 
-		if (hwc->remaining) {
-			if (hwc->remaining < 0)
+		if (period) {
+			if (period < 0)
 				period = 10000;
-			else
-				period = hwc->remaining;
-			hwc->remaining = 0;
+
+			local64_set(&hwc->period_left, 0);
 		} else {
 			period = max_t(u64, 10000, hwc->sample_period);
 		}
@@ -4613,7 +4612,7 @@ static void perf_swevent_cancel_hrtimer(
 
 	if (hwc->sample_period) {
 		ktime_t remaining = hrtimer_get_remaining(&hwc->hrtimer);
-		hwc->remaining = ktime_to_ns(remaining);
+		local64_set(&hwc->period_left, ktime_to_ns(remaining));
 
 		hrtimer_cancel(&hwc->hrtimer);
 	}


