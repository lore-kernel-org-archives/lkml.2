Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752745Ab2BQK1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 05:27:06 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48547 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751814Ab2BQK1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 05:27:04 -0500
Date: Fri, 17 Feb 2012 10:26:43 +0000
From: Will Deacon <will.deacon@arm.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "eranian@gmail.com" <eranian@gmail.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        David Long <dave.long@linaro.org>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "mans@mansr.com" <mans@mansr.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: oprofile and ARM A9 hardware counter
Message-ID: <20120217102643.GA17909@mudshark.cambridge.arm.com>
References: <CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
 <CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
 <1329323900.2293.150.camel@twins>
 <CACVXFVPce0A3LfL=mFo3UbN-Om7xLOo_d-LfKXDjdN5dFQdhiA@mail.gmail.com>
 <20120216150004.GE2641@mudshark.cambridge.arm.com>
 <CACVXFVM472hz+na7o2wJr1CPq-W=YB7i0UwtrsUf62+ryzWp8A@mail.gmail.com>
 <1329409183.2293.245.camel@twins>
 <CACVXFVOygObWqPMLjg6uOB6inBkvvUjsQncNW0fbmpa4Xspw0Q@mail.gmail.com>
 <20120216180841.GC31977@mudshark.cambridge.arm.com>
 <CACVXFVO4eexVK-S5TdRk2T6pyKRzpW1HxBQxo0Yfk_ziaO_U4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVO4eexVK-S5TdRk2T6pyKRzpW1HxBQxo0Yfk_ziaO_U4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 17, 2012 at 05:24:02AM +0000, Ming Lei wrote:
> On Fri, Feb 17, 2012 at 2:08 AM, Will Deacon <will.deacon@arm.com> wrote:
> 
> >
> > The more I think about this, the more I think that the overflow parameter to
> > armpmu_event_update needs to go. It was introduced to prevent massive event
> > loss in non-sampling mode, but I think we can get around that by changing
> > the default sample_period to be half of the max_period, therefore giving
> > ourselves a much better chance of handling the interrupt before new wraps
> > around past prev.
> >
> > Ming Lei - can you try the following please? If it works for you, then I'll
> > do it properly and kill the overflow parameter altogether.
> 
> Of course, it does work for the problem reported by Stephane since
> it changes the delta computation basically as I did, but I am afraid that
> it may be not good enough for the issue fixed in a737823d ("ARM: 6835/1:
> perf: ensure overflows aren't missed due to IRQ latency").

I think it does solve that problem.

> >
> >        if (!hwc->sample_period) {
> > -               hwc->sample_period  = armpmu->max_period;
> > +               hwc->sample_period  = armpmu->max_period >> 1;
> 
> If you assume that the issue addressed by a737823d can only happen in
> non-sample situation, Peter's idea of u32 cast is OK and maybe simpler.

I don't want to assume that the counters are 32-bit in this code as we may
want to plug in some other PMU with 16-bit counters, for example. That's why
we have max_period defined for each PMU. Furthermore, it still doesn't help us
in the stat case where prev will typically be quite small after we've had an
overflow and new may well overtake it.

> But I am afraid that the issue still can be triggered in sample-based situation,
> especially in very high frequency case: suppose the sample freq is 10000,
> 100us IRQ delay may trigger the issue.

Not sure I follow. If the frequency is 10000, then we write 0xffffd8f0 to
the counter. That means we have a 0xffffd8f0 event window to read the
counter after it overflows before new overtakes prev and we get confused.
If this passed in 100us then either your clock speed is 4.3*10^12Hz or you
have a seriously wide issue :)

> So we may use the overflow information to make perf more robust, IMO.

There's a trade off between allowing the counter to wrap back around past
its previous value or being able to handle overflow on a non-interrupt path.
Given that the former problem is only a real issue for non-sampling runs,
halving the period in that case should sort it (and it does stop my simple
test case from exploding).

Will
