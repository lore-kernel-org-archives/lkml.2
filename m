Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631Ab0KSL1v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 06:27:51 -0500
Received: from casper.infradead.org ([85.118.1.10]:46874 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab0KSL1u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 06:27:50 -0500
Subject: Re: [PATCH 3/5] MIPS/Perf-events: Check event state in
 validate_event()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Will Deacon <will.deacon@arm.com>
Cc: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>, ralf@linux-mips.org,
        fweisbec@gmail.com, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, paulus@samba.org,
        mingo@elte.hu, acme@redhat.com
In-Reply-To: <1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
References: <1290063401-25440-1-git-send-email-dengcheng.zhu@gmail.com>
	 <1290063401-25440-4-git-send-email-dengcheng.zhu@gmail.com>
	 <1290159806.9342.7.camel@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 19 Nov 2010 12:27:31 +0100
Message-ID: <1290166051.2109.1539.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-11-19 at 09:43 +0000, Will Deacon wrote:
> Hi Deng-Cheng,
> 
> On Thu, 2010-11-18 at 06:56 +0000, Deng-Cheng Zhu wrote:
> > Ignore events that are not for this PMU or are in off/error state.
> > 
> Sorry I didn't see this before, thanks for pointing out that you
> had included it for MIPS.
> 
> > Signed-off-by: Deng-Cheng Zhu <dengcheng.zhu@gmail.com>
> > ---
> >  arch/mips/kernel/perf_event.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/mips/kernel/perf_event.c b/arch/mips/kernel/perf_event.c
> > index 1ee44a3..9c6442a 100644
> > --- a/arch/mips/kernel/perf_event.c
> > +++ b/arch/mips/kernel/perf_event.c
> > @@ -486,7 +486,7 @@ static int validate_event(struct cpu_hw_events *cpuc,
> >  {
> >         struct hw_perf_event fake_hwc = event->hw;
> > 
> > -       if (event->pmu && event->pmu != &pmu)
> > +       if (event->pmu != &pmu || event->state <= PERF_EVENT_STATE_OFF)
> >                 return 0;
> > 
> >         return mipspmu->alloc_counter(cpuc, &fake_hwc) >= 0;
> 
> So this is the opposite of what we're doing on ARM. Our
> approach is to ignore events that are OFF (or in the ERROR
> state) or that belong to a different PMU. We do this by
> allowing them to *pass* validation (i.e. by returning 1 above).
> This means that we won't unconditionally fail a mixed event group.
> 
> x86 does something similar in the collect_events function.

Right, note that the generic code only allows mixing with software
events, so simply accepting them is ok as software events give the
guarantee they're always schedulable.
