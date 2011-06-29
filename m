Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755138Ab1F2OLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:11:09 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:2277 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752279Ab1F2OLE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:11:04 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz936eK146fK179dN1432N98dKzz1202hzz8275dhz32i668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNK229-02-435-02
X-M-MSG: 
Date: Wed, 29 Jun 2011 16:10:56 +0200
From: Robert Richter <robert.richter@amd.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Francis Moreau <francis.moro@gmail.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
Message-ID: <20110629141056.GN4590@erda.amd.com>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
 <20110628105335.GA17199@erda.amd.com>
 <1309259105.6701.210.camel@twins>
 <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
 <20110629103714.GM4590@erda.amd.com>
 <1309344655.6701.1054.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309344655.6701.1054.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.06.11 06:50:55, Peter Zijlstra wrote:
> On Wed, 2011-06-29 at 12:37 +0200, Robert Richter wrote:
> 
> > I looked at the interrupt handlers. The events are always determined
> > from a per-cpu array:
> > 
> > 	cpuc = &__get_cpu_var(cpu_hw_events);
> > 	...
> > 	event = cpuc->events[idx];
> > 
> > In case of interrupts the event should then always be a hw event (or
> > uninitialized).  Even if the interrupt was triggered by a different
> > source, it would always be mapped to the same event and the check
> > is_sampling_event() would be meaningless.
> 
> I'm probably not quite getting what you mean, but how is
> is_sampling_event() meaningless? the INT bit is enabled for _all_
> events, whether they were configured as a sampling event or not.

Aren't all events that are mapped to counters via cpu_hw_events always
sampling events? Then, when calling perf_event_overflow() from an
interrupt handler there are no other events than sampling events.

> 
> Its just that for !sampling events we shouldn't attempt to generate any
> output.

If attr.sample_type is null, there is no output to generate. Better
use this instead of attr.sample_type in is_sampling_event()?
perf_event_overflow() could be used then to generate output also for
samples where no period is specified.

> 
> > There are other occurrences of perf_event_overflow() in
> > kernel/events/core.c for events of type PERF_TYPE_SOFTWARE. These
> > events are initialized with sample_period set and a check would always
> > be true too.
> 
> I'm failing to see what you mean, where do we always set
> event->attr.sample_period for software events?

Hmm, I read the code wrong and the check in perf_event_overflow()
might be needed for swevents.

> 
> > For both cases I stil don't see a reason for the check.
> 
> You're going to have to spell things out for me, I'm really not getting
> your argument.

I was thinking about to change this check and haven't seen cases for
that the check is for. What would happen if the check isn't there and
perf_event_overflow() is called from the interrupt handler?

> 
> > Anyway, would the following extentension of the check above ok?
> > 
> > 	if (unlikely(!is_sampling_event(event) && !event->attr.sample_type))
> > 		...
> > 
> > With no bits set in attr.sample_type the sample would be empty and
> > nothing to report. Now, with this change, samples that have data to
> > report wouldn't be dropped anymore.
> 
> Also, could you explain in what way data is dropped? Where do
> non-sampling events need to write sample data?

I stumbled over this while rebasing my perf ibs patches:

 http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=shortlog;h=refs/heads/perf-ibs

Hope I could explain this to you better now.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

