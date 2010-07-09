Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757586Ab0GIPwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:52:30 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45787 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757292Ab0GIPw3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:52:29 -0400
Subject: Re: [RFC][PATCH 00/13] perf pmu interface changes -v3
From: Peter Zijlstra <peterz@infradead.org>
To: Will Deacon <will.deacon@arm.com>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <1278688302.9864.9.camel@e102144-lin.cambridge.arm.com>
References: <20100709082117.631541128@chello.nl>
	 <1278688302.9864.9.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 09 Jul 2010 17:52:14 +0200
Message-ID: <1278690734.1900.232.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-07-09 at 16:11 +0100, Will Deacon wrote:
> 
> I've been looking at this and after fixing atomic64 operations and a
> sign-extension bug, I'm getting closer to finding the *real* cause of
> the problem! It appears that the PMU isn't being enabled for pinned
> events. The following patch fixes that, but I'm not sure that it's the
> correct thing to do:

> Because only pinned events seem to be broken, I'm worried that this is
> just hiding the problem... or is pmu->add(...) supposed to enable the
> PMU as well as installing the event?
> 
> The function names aren't especially helpful here either:
> armpmu_{start,stop} call armpmu->{enable,disable} and
> armpmu_{enable,disable} call armpmu->{start,stop}!
> 
> Any thoughts? 

Ah yes.. Silly me..

We used to only call ->enable() [ now called ->add() ] inside
perf_disable()/perf_enable() regions.

But due to patch 9/13 that is no longer the case. I did move it inside
several ->enable methods, but not for ARM (and SH) as it wasn't evident
they needed it (that'll teach me to assume things).

Once we get context per pmu we can move it outside again.

So yes, your patch looks good and I added the SH bit as well. I'll push
it out to the git tree as and worry about rebasing the whole series once
I get back.

Thanks!

(new HEAD 0a20dff8474e5738f086e9acc38649f56938c0ad)

---
 arch/arm/kernel/perf_event.c |    3 +++
 arch/sh/kernel/perf_event.c  |   10 ++++++++--
 2 files changed, 11 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/arm/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/arm/kernel/perf_event.c
+++ linux-2.6/arch/arm/kernel/perf_event.c
@@ -304,6 +304,8 @@ armpmu_add(struct perf_event *event, int
 	int idx;
 	int err = 0;
 
+	perf_pmu_disable(event->pmu);
+
 	/* If we don't have a space for the counter then finish early. */
 	idx = armpmu->get_event_idx(cpuc, hwc);
 	if (idx < 0) {
@@ -328,6 +330,7 @@ armpmu_add(struct perf_event *event, int
 	perf_event_update_userpage(event);
 
 out:
+	perf_pmu_enable(event->pmu);
 	return err;
 }
 
Index: linux-2.6/arch/sh/kernel/perf_event.c
===================================================================
--- linux-2.6.orig/arch/sh/kernel/perf_event.c
+++ linux-2.6/arch/sh/kernel/perf_event.c
@@ -256,11 +256,14 @@ static int sh_pmu_add(struct perf_event 
 	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
 	struct hw_perf_event *hwc = &event->hw;
 	int idx = hwc->idx;
+	int ret = -EAGAIN;
+
+	perf_pmu_disable(event->pmu);
 
 	if (__test_and_set_bit(idx, cpuc->used_mask)) {
 		idx = find_first_zero_bit(cpuc->used_mask, sh_pmu->num_events);
 		if (idx == sh_pmu->num_events)
-			return -EAGAIN;
+			goto ret;
 
 		__set_bit(idx, cpuc->used_mask);
 		hwc->idx = idx;
@@ -273,8 +276,11 @@ static int sh_pmu_add(struct perf_event 
 		sh_pmu_start(event, PERF_EF_RELOAD);
 
 	perf_event_update_userpage(event);
+	ret = 0;
 
-	return 0;
+out:
+	perf_pmu_enable(event->pmu);
+	return ret;
 }
 
 static void sh_pmu_read(struct perf_event *event)

