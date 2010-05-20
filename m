Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755286Ab0ETKiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 06:38:13 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51934 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab0ETKiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 06:38:11 -0400
Subject: Re: [PATCH 1/7] perf: introduce raw_type attribute to specify the 
 type of a raw sample
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       David Miller <davem@davemloft.net>, Will Deacon <will.deacon@arm.com>,
       Paul Mundt <lethal@linux-sh.org>
In-Reply-To: <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
References: <1274304024-6551-1-git-send-email-robert.richter@amd.com>
	 <1274304024-6551-2-git-send-email-robert.richter@amd.com>
	 <AANLkTiniEWKJIrbTSZQ0jBXps75WVQbvGSXVyUVttJ7P@mail.gmail.com>
	 <1274347413.5605.13636.camel@twins>
	 <AANLkTikWSOPpHsvJGht7c7QnwcOk-nMyBNhY-g6QpNzg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 20 May 2010 12:37:39 +0200
Message-ID: <1274351859.5605.13961.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-20 at 11:42 +0200, Stephane Eranian wrote:

> > For Instruction-Fetch:

> >  32:47 latency       (r/w)

> Your are mixing output and input parameters.
> 
> The only input parameters you have are:
> - sample-period, enable, random
> The rest is output only.

Ah, my bad, I thought it was a r/w field.

> > encode these IBS things as:
> >
> >  0x87 Instruction Fetch Stall -- Ins-Fetch
> >  0xC0 Retired Instructions    -- Ins-Exec
> >
> I think those events do not map to the behavior of IBS. We have
> add that discussion before.

Hrm,. so there are no regular events that count the same thing as the
IBS things? That really sucks.

So yeah, you might as well expose it as a whole separate PMU using Lin's
stuff.

> > The Ins-Exec will have to re-construct the actual event->count by adding
> > sample-period on each interrupt, as it seems we lack an actual counter
> > in hardware.
> >
> For what? counting mode?

Yeah, events are supposed to count.

> > Furthermore, these counters will have to deal with sample-period > 2^16
> > by 'ignoring' interrupts until we get ->period_left down to 0.
> >
> Well, it's not 2^16, it's 2^20 but bottom 4 bits must be zero.
> What about simply failing perf_event_open() is sample_period does not fit the
> constraint?

Why, its simple enough to ignore a few interrupts, we do the same for
all other implementations.

> > The extra data could possibly be exposed through attaching non-sampling
> > group events and using SAMPLE_READ, like L1-misses, although
> > reconstructing the count from just one bit seems 'interesting'.
> >
> > The IbsFetchLinAd/IbsOpRip would go straight into PERF_SAMPLE_IP by
> > replacing pt_regs->ip I guess.
> >
> > IbsDcLinAd goes into PERF_SAMPLE_ADDR
> >
> What about the rest, the TLB, alignment, data sources?

Dunno, reconstruct sensible counters? Surely the software that uses IBS
does something useful with that data? What does libpfm do with the IBS
data?
