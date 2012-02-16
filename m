Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2BPSJN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 13:09:13 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:43825 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751178Ab2BPSJL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 13:09:11 -0500
Date: Thu, 16 Feb 2012 18:08:41 +0000
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
Message-ID: <20120216180841.GC31977@mudshark.cambridge.arm.com>
References: <CAMsRxfJVEgVJoHcaPQbMg5mwz=tZUce4oibDUxtnevSF8bGY9g@mail.gmail.com>
 <CAMQu2gxVUqDF2HkPD=QeX0N_tUd=9FTd+T+1LHCR0tsCgQxC8Q@mail.gmail.com>
 <CAMsRxfJH+9MS=Svmh0BvDSb8xqsPe2HPobkeKcn8JO35npjhwQ@mail.gmail.com>
 <CACVXFVMx9Zx3ZQr6Q-17x5NVL8iuBJjOjtw39FJiWX=fGkZNZA@mail.gmail.com>
 <1329323900.2293.150.camel@twins>
 <CACVXFVPce0A3LfL=mFo3UbN-Om7xLOo_d-LfKXDjdN5dFQdhiA@mail.gmail.com>
 <20120216150004.GE2641@mudshark.cambridge.arm.com>
 <CACVXFVM472hz+na7o2wJr1CPq-W=YB7i0UwtrsUf62+ryzWp8A@mail.gmail.com>
 <1329409183.2293.245.camel@twins>
 <CACVXFVOygObWqPMLjg6uOB6inBkvvUjsQncNW0fbmpa4Xspw0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACVXFVOygObWqPMLjg6uOB6inBkvvUjsQncNW0fbmpa4Xspw0Q@mail.gmail.com>
Thread-Topic: oprofile and ARM A9 hardware counter
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 04:37:35PM +0000, Ming Lei wrote:
> On Fri, Feb 17, 2012 at 12:19 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Fri, 2012-02-17 at 00:12 +0800, Ming Lei wrote:
> >> is triggered: u64 delta = 100 -  1000000 = 18446744073708551716.
> >
> > on x86 we do:
> >
> >  int shift = 64 - x86_pmu.cntval_bits;
> >  s64 delta;
> >
> >  delta = (new_raw_count << shift) - (prev_raw_count << shift);
> >  delta >>= shift;
> >
> > This deals with short overflows (on x86 the registers are typically 40
> > or 48 bits wide). If the arm register is 32 you can of course also get
> > there with some u32 casts.
> 
> Good idea, but it may not work if new_raw_count is bigger than prev_raw_count.

The more I think about this, the more I think that the overflow parameter to
armpmu_event_update needs to go. It was introduced to prevent massive event
loss in non-sampling mode, but I think we can get around that by changing
the default sample_period to be half of the max_period, therefore giving
ourselves a much better chance of handling the interrupt before new wraps
around past prev.

Ming Lei - can you try the following please? If it works for you, then I'll
do it properly and kill the overflow parameter altogether.

Thanks,

Will

git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
index 5bb91bf..ef597a3 100644
--- a/arch/arm/kernel/perf_event.c
+++ b/arch/arm/kernel/perf_event.c
@@ -193,13 +193,7 @@ again:
                             new_raw_count) != prev_raw_count)
                goto again;
 
-       new_raw_count &= armpmu->max_period;
-       prev_raw_count &= armpmu->max_period;
-
-       if (overflow)
-               delta = armpmu->max_period - prev_raw_count + new_raw_count + 1;
-       else
-               delta = new_raw_count - prev_raw_count;
+       delta = (new_raw_count - prev_raw_count) & armpmu->max_period;
 
        local64_add(delta, &event->count);
        local64_sub(delta, &hwc->period_left);
@@ -518,7 +512,7 @@ __hw_perf_event_init(struct perf_event *event)
        hwc->config_base            |= (unsigned long)mapping;
 
        if (!hwc->sample_period) {
-               hwc->sample_period  = armpmu->max_period;
+               hwc->sample_period  = armpmu->max_period >> 1;
                hwc->last_period    = hwc->sample_period;
                local64_set(&hwc->period_left, hwc->sample_period);
        }

