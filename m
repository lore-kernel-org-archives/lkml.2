Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab0GIPMY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 11:12:24 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:54699 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751332Ab0GIPMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 11:12:21 -0400
Subject: Re: [RFC][PATCH 00/13] perf pmu interface changes -v3
From: Will Deacon <will.deacon@arm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: paulus <paulus@samba.org>, stephane eranian <eranian@googlemail.com>,
       Robert Richter <robert.richter@amd.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Cyrill Gorcunov <gorcunov@gmail.com>, Lin Ming <ming.m.lin@intel.com>,
       Yanmin <yanmin_zhang@linux.intel.com>,
       Deng-Cheng Zhu <dengcheng.zhu@gmail.com>,
       David Miller <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100709082117.631541128@chello.nl>
References: <20100709082117.631541128@chello.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 09 Jul 2010 16:11:42 +0100
Message-ID: <1278688302.9864.9.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Jul 2010 15:11:46.0497 (UTC) FILETIME=[0C1DBB10:01CB1F79]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Fri, 2010-07-09 at 09:21 +0100, Peter Zijlstra wrote:
> The patches are boot tested on x86_64 and compile tested on: powerpc,
> ppc-fsl,
> sparc and arm and SH (by courtesy of Matt Fleming).
> 
> X86 -- appears to be fully functional.
> FSL -- should, after the initial few fixes, at least compile again.
> ARM -- is known to have grown some issues, Will was looking into that.

I've been looking at this and after fixing atomic64 operations and a
sign-extension bug, I'm getting closer to finding the *real* cause of
the problem! It appears that the PMU isn't being enabled for pinned
events. The following patch fixes that, but I'm not sure that it's the
correct thing to do:

diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index c440ae1..a946a77 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -304,6 +304,8 @@ armpmu_add(struct perf_event *event, int flags)
        int idx;
        int err = 0;
 
+       perf_pmu_disable(event->pmu);
+
        /* If we don't have a space for the counter then finish early.
*/
        idx = armpmu->get_event_idx(cpuc, hwc);
        if (idx < 0) {
@@ -328,6 +330,7 @@ armpmu_add(struct perf_event *event, int flags)
        perf_event_update_userpage(event);
 
 out:
+       perf_pmu_enable(event->pmu);
        return err;
 }

Because only pinned events seem to be broken, I'm worried that this is
just hiding the problem... or is pmu->add(...) supposed to enable the
PMU as well as installing the event?

The function names aren't especially helpful here either:
armpmu_{start,stop} call armpmu->{enable,disable} and
armpmu_{enable,disable} call armpmu->{start,stop}!

Any thoughts?

Will

