Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074Ab0KKTZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:25:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:58817 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754631Ab0KKTZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:25:53 -0500
Date: Thu, 11 Nov 2010 20:25:51 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, mingo@elte.hu, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] perf-events: Add support for supplementary event
 registers
Message-ID: <20101111192551.GI18718@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
 <1289502554.2084.153.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289502554.2084.153.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 08:09:14PM +0100, Peter Zijlstra wrote:

Thanks for the review. I discovered another problem on my own too.

> > +	int 				percore_used;
> > +	struct intel_percore		*per_core;
> 
> Either per_core != NULL implies percore_used or it should be state
> inside the struct.

It does not, I'll clarify.

> > +#define INTEL_EVENT_EXTRA_REG(event, msr, vm) \
> > +	EVENT_EXTRA_REG(event, msr, ARCH_PERFMON_EVENTSEL_EVENT, vm)
> > +#define EVENT_EXTRA_END {}
> 
> Does that imply a zero filled struct?

Yes.

> > +++ b/arch/x86/kernel/cpu/perf_event_intel.c
> > @@ -1,5 +1,14 @@
> >  #ifdef CONFIG_CPU_SUP_INTEL
> >  
> > +struct intel_percore {
> > +	raw_spinlock_t lock;
> > +	int ref;
> > +	u64 config;
> > +	unsigned extra_reg;
> > +	u64 extra_config;
> > +};
> > +static DEFINE_PER_CPU(struct intel_percore, intel_percore);
> 
> Please dynamically allocate these when needed, just like the AMD
> north-bridge structure.

Fully dynamic is difficult because the topology discovery does not 
really handle that nicely.

I can allocate at boot, but it will not save a lot of memory
(just one entry per core)

To be honest I would prefer not to do that change, are you sure
you want it?

> I think I like Stephane's suggestion better, frob them into the existing
> u64 word, since its model specific and we still have 33 empty bits in
> the control register there's plenty space.

Ok. I'll see how many changes that needs.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
