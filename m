Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417Ab1F2Okw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 10:40:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:48480 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1F2Okv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 10:40:51 -0400
Subject: Re: [tip:perf/core] perf: Ignore non-sampling overflows
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Robert Richter <robert.richter@amd.com>
Cc: Francis Moreau <francis.moro@gmail.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "mingo@redhat.com" <mingo@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
In-Reply-To: <20110629141056.GN4590@erda.amd.com>
References: <tip-963988262c3c8f4234f64a0dde59446a295e07bb@git.kernel.org>
	 <20110628105335.GA17199@erda.amd.com> <1309259105.6701.210.camel@twins>
	 <BANLkTimcxGWasWqgem=5EYDKGAM+dq26xQ@mail.gmail.com>
	 <20110629103714.GM4590@erda.amd.com> <1309344655.6701.1054.camel@twins>
	 <20110629141056.GN4590@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 29 Jun 2011 16:39:46 +0200
Message-ID: <1309358386.6701.1307.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-29 at 16:10 +0200, Robert Richter wrote:

> > I'm probably not quite getting what you mean, but how is
> > is_sampling_event() meaningless? the INT bit is enabled for _all_
> > events, whether they were configured as a sampling event or not.
> 
> Aren't all events that are mapped to counters via cpu_hw_events always
> sampling events? 

No. perf stat which only counts (has period==0) uses hardware counters
just fine but doesn't sample anything, yet has the INT bit set (as
explained a few emails back).

> Then, when calling perf_event_overflow() from an
> interrupt handler there are no other events than sampling events.

Thus false. (Also, even if we didn't always set the INT bit, it might
see the overflow of a non-sampling event while dealing with the PMI
triggered by another event).

> > Its just that for !sampling events we shouldn't attempt to generate any
> > output.
> 
> If attr.sample_type is null, there is no output to generate.

Arguably true, currently we would still write a rudimentary sample,
consisting of just the header with a 0-sized payload. This is, I'd
rather we do that than add yet another conditional on the sample fast
path. If the user doesn't want samples he should've set period==0, if
the does he had better set a non-zero sample_type. 

>  Better
> use this instead of attr.sample_type in is_sampling_event()?
> perf_event_overflow() could be used then to generate output also for
> samples where no period is specified.

But what for? period==0 is defined as: does not generate samples.

> > You're going to have to spell things out for me, I'm really not getting
> > your argument.
> 
> I was thinking about to change this check and haven't seen cases for
> that the check is for. What would happen if the check isn't there and
> perf_event_overflow() is called from the interrupt handler?

It might generate spurious samples, nothing too bad, just unexpected.

> > > Anyway, would the following extentension of the check above ok?
> > > 
> > > 	if (unlikely(!is_sampling_event(event) && !event->attr.sample_type))
> > > 		...
> > > 
> > > With no bits set in attr.sample_type the sample would be empty and
> > > nothing to report. Now, with this change, samples that have data to
> > > report wouldn't be dropped anymore.
> > 
> > Also, could you explain in what way data is dropped? Where do
> > non-sampling events need to write sample data?
> 
> I stumbled over this while rebasing my perf ibs patches:
> 
>  http://git.kernel.org/?p=linux/kernel/git/rric/oprofile.git;a=shortlog;h=refs/heads/perf-ibs
> 
> Hope I could explain this to you better now.

Could you point where exactly in the IBS code this happens? Even for
IBS, if period==0 it should not generate samples. Arguably IBS with
period==0 is pretty pointless, but that's another story.
