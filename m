Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab1F3Mse (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 08:48:34 -0400
Received: from am1ehsobe005.messaging.microsoft.com ([213.199.154.208]:53603
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159Ab1F3Ms1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 08:48:27 -0400
X-SpamScore: -19
X-BigFish: VPS-19(zz936eK146fK148cM1432N98dKzz1202hzz8275dhz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LNLSWI-01-00S-02
X-M-MSG: 
Date: Thu, 30 Jun 2011 14:47:52 +0200
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
Message-ID: <20110630124752.GS4590@erda.amd.com>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
 <20110628105335.GA17199@erda.amd.com>
 <1309259105.6701.210.camel@twins>
 <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
 <20110629103714.GM4590@erda.amd.com>
 <1309344655.6701.1054.camel@twins>
 <20110629141056.GN4590@erda.amd.com>
 <1309358386.6701.1307.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1309358386.6701.1307.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.06.11 10:39:46, Peter Zijlstra wrote:
> On Wed, 2011-06-29 at 16:10 +0200, Robert Richter wrote:
> 
> > > I'm probably not quite getting what you mean, but how is
> > > is_sampling_event() meaningless? the INT bit is enabled for _all_
> > > events, whether they were configured as a sampling event or not.
> > 
> > Aren't all events that are mapped to counters via cpu_hw_events always
> > sampling events? 
> 
> No. perf stat which only counts (has period==0) uses hardware counters
> just fine but doesn't sample anything, yet has the INT bit set (as
> explained a few emails back).

Ah, this makes sense.

> 
> > Then, when calling perf_event_overflow() from an
> > interrupt handler there are no other events than sampling events.
> 
> Thus false. (Also, even if we didn't always set the INT bit, it might
> see the overflow of a non-sampling event while dealing with the PMI
> triggered by another event).
> 
> > > Its just that for !sampling events we shouldn't attempt to generate any
> > > output.
> > 
> > If attr.sample_type is null, there is no output to generate.
> 
> Arguably true, currently we would still write a rudimentary sample,
> consisting of just the header with a 0-sized payload. This is, I'd
> rather we do that than add yet another conditional on the sample fast
> path. If the user doesn't want samples he should've set period==0, if
> the does he had better set a non-zero sample_type. 
> 
> >  Better
> > use this instead of attr.sample_type in is_sampling_event()?
> > perf_event_overflow() could be used then to generate output also for
> > samples where no period is specified.
> 
> But what for? period==0 is defined as: does not generate samples.
> 
> > > You're going to have to spell things out for me, I'm really not getting
> > > your argument.
> > 
> > I was thinking about to change this check and haven't seen cases for
> > that the check is for. What would happen if the check isn't there and
> > perf_event_overflow() is called from the interrupt handler?
> 
> It might generate spurious samples, nothing too bad, just unexpected.

Ok, I see its better to check for period==0. I found a solution that
works without changing this check. See below.

> 
> > > > Anyway, would the following extentension of the check above ok?
> > > > 
> > > > 	if (unlikely(!is_sampling_event(event) && !event->attr.sample_type))
> > > > 		...
> > > > 
> > > > With no bits set in attr.sample_type the sample would be empty and
> > > > nothing to report. Now, with this change, samples that have data to
> > > > report wouldn't be dropped anymore.
> > > 
> > > Also, could you explain in what way data is dropped? Where do
> > > non-sampling events need to write sample data?
> > 
> > I stumbled over this while rebasing my perf ibs patches:
> > 
> >  http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=shortlog;h=refs/heads/perf-ibs
> > 
> > Hope I could explain this to you better now.
> 
> Could you point where exactly in the IBS code this happens? Even for
> IBS, if period==0 it should not generate samples. Arguably IBS with
> period==0 is pretty pointless, but that's another story.

The original code is this:

 http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=blob;f=arch/x86/kernel/cpu/perf_event_amd.c;h=d79d295692d148b4408b26cfeb265cf4dc2e75aa;hb=2ded5ae9883974fb8f0358c6b2434410b5e9e83c#l273

It covers the case there the sampling period may be specified in the
raw config register (line 286). I know, this is not the preferred way,
but this way you can directly set the config value in perf without
bypassing some bits through event->attr. As IBS events are sampling
events I will change the code so that it writes back the specified
period to event->attr.sample_period/event->hw.sample_period. Something
like:

        if (event->hw.sample_period) {
		...
        } else {
                max_cnt = event->attr.config & map->cnt_mask;
                event->attr.sample_period = max_cnt << 4;
                event->hw.sample_period = event->attr.sample_period;
        }

This will then proper identify IBS samples as samling event.

Thanks for taking your time.

-Robert

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Advanced Micro Devices, Inc.
Operating System Research Center

