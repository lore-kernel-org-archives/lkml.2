Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757015Ab1E0TxN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 15:53:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:41801 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808Ab1E0TxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 15:53:12 -0400
Subject: Re: [PATCH 2/3] introduce intel_rapl driver
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Zhang Rui <rui.zhang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-pm <linux-pm@lists.linux-foundation.org>,
        "mingo@elte.hu" <mingo@elte.hu>, "acme@redhat.com" <acme@redhat.com>,
        "Lin, Ming M" <ming.m.lin@intel.com>, "Brown, Len" <lenb@kernel.org>,
        Matt Fleming <matt@console-pimps.org>
In-Reply-To: <1306484810.16581.375.camel@rui>
References: <1306398857.2207.157.camel@rui> <1306403003.1200.41.camel@twins>
	 <1306484810.16581.375.camel@rui>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 May 2011 21:56:33 +0200
Message-ID: <1306526193.2497.474.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-27 at 16:26 +0800, Zhang Rui wrote:
> > > +static void rapl_event_update(struct perf_event *event)
> > > +{
> > > +   s64 prev;
> > > +   u64 now;
> > > +   struct rapl_domain *domain = to_rapl_domain(event->pmu);
> > > +
> > > +   now = rapl_read_energy(domain);
> > 
> > So I had to get the Intel SDM because your driver lacks all useful
> > information, and I learned that the RAPL status MSRs contain 32 bits.
> > 
> > So you get those 32 bits, divide them by some number,
> > 
> > > +   prev = local64_xchg(&event->hw.prev_count, now);
> > > +   local64_add(now - prev, &event->count);
> > 
> > And then expect that to work?
> > 
> rapl_read_energy first reads energy status from MSR and then invokes
> rapl_unit_xlate to translate it into Joules.
> For example, on the laptop I tested, the energy unit bits is 0x10, which
> means that the energy unit is 1/65536 Joule.
> So I need to divide the value read from MSR by 65536 to calculate how
> many Joules of energy are cost. 
> 
> But this reveals a problem. If the task is scheduled out with energy
> consumption less than 1 Joule, we failed to record it.
> 
> IMO, a new callback should be introduced so that I can save the MSR
> value first and translate it to Joule when the task exits. Or just do
> the translation in user space.
> 
> what do you think? 

That's not the problem I meant, but lets start with that, you can solve
that differently, just keep a fraction somewhere in hw_perf_event.

Anyway, the problem you missed is what happens when those 32 bits roll
over, at that point you get now < prev and the value added to
event->count is a _HUGE_ 64 bit number.


