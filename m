Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab1F2Kh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 06:37:28 -0400
Received: from am1ehsobe004.messaging.microsoft.com ([213.199.154.207]:40048
	"EHLO AM1EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753247Ab1F2KhZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 06:37:25 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz936eK9371M146fK1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNJS63-02-0BG-02
X-M-MSG: 
Date: Wed, 29 Jun 2011 12:37:14 +0200
From: Robert Richter <robert.richter@amd.com>
To: Francis Moreau <francis.moro@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
Message-ID: <20110629103714.GM4590@erda.amd.com>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
 <20110628105335.GA17199@erda.amd.com>
 <1309259105.6701.210.camel@twins>
 <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.06.11 07:56:03, Francis Moreau wrote:
> On Tue, Jun 28, 2011 at 1:05 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Tue, 2011-06-28 at 12:53 +0200, Robert Richter wrote:
> >> > --- a/kernel/perf_event.c
> >> > +++ b/kernel/perf_event.c
> >> > @@ -4240,6 +4240,13 @@ static int __perf_event_overflow(struct perf_event *event, int nmi,
> >> >     struct hw_perf_event *hwc = &event->hw;
> >> >     int ret = 0;
> >> >
> >> > +   /*
> >> > +    * Non-sampling counters might still use the PMI to fold short
> >> > +    * hardware counters, ignore those.
> >> > +    */
> >> > +   if (unlikely(!is_sampling_event(event)))
> >> > +           return 0;
> >> > +
> >
> >> do you remember the background of this change. This check silently
> >> drops data of non-sampling events. I want to use perf_event_overflow()
> >> to write to the buffer and want to modify the check, but don't see
> >> which 'accidentally' interrupts may occur that must be ignored.
> >
> > IIRC this is because we always program the interrupt bit, such that when
> > the counter overflows we can account and reprogram the thing. This is
> > needed because no hardware counter is in fact 64 bits wide. Therefore we
> > have to program the counter to its max width and properly account the
> > state and reprogram on overflow.
> >
> > Imagine a 32bit cycle counter (@1GHz), if we were not to program that as
> > taking interrupts and nobody would read that counter for about 4.2
> > seconds, we'd have overflowed and lost the actual count value for the
> > thing.
> >
> > So what we do is program is at 31bits (so that the msb can toggle and
> > trigger the interrupt), and on interrupt add to event->count, and reset
> > the hardware to start counting again.
> >
> > Now some arch/*/perf_event.c implementations unconditionally called
> > perf_event_overflow() from their IRQ handler, even for such non-sampling
> > counters.

I looked at the interrupt handlers. The events are always determined
from a per-cpu array:

	cpuc = &__get_cpu_var(cpu_hw_events);
	...
	event = cpuc->events[idx];

In case of interrupts the event should then always be a hw event (or
uninitialized).  Even if the interrupt was triggered by a different
source, it would always be mapped to the same event and the check
is_sampling_event() would be meaningless.

There are other occurrences of perf_event_overflow() in
kernel/events/core.c for events of type PERF_TYPE_SOFTWARE. These
events are initialized with sample_period set and a check would always
be true too.

For both cases I stil don't see a reason for the check.

Anyway, would the following extentension of the check above ok?

	if (unlikely(!is_sampling_event(event) && !event->attr.sample_type))
		...

With no bits set in attr.sample_type the sample would be empty and
nothing to report. Now, with this change, samples that have data to
report wouldn't be dropped anymore.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

