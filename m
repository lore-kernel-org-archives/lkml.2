Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488Ab0KUOE3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 09:04:29 -0500
Received: from mga14.intel.com ([143.182.124.37]:6883 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753346Ab0KUOE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 09:04:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,231,1288594800"; 
   d="scan'208";a="351427644"
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
References: <1290340877.2245.124.camel@localhost>
	 <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 21 Nov 2010 22:04:19 +0800
Message-Id: <1290348259.2245.172.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 20:46 +0800, Andi Kleen wrote:
> >
> > 2. Uncore pmu NMI handling
> >
> > All the 4 cores are programmed to receive uncore counter overflow
> > interrupt. The NMI handler(running on 1 of the 4 cores) handle all
> > counters enabled by all 4 cores.
> 
> Really for uncore monitoring there is no need to use an NMI handler.
> You can't profile a core anyways, so you can just delay the reporting
> a little bit. It may simplify the code to not use one here
> and just use an ordinary handler.

OK, I can use on ordinary interrupt handler here.

> 
> In general since there is already much trouble with overloaded
> NMI events avoiding new NMIs is a good idea.
> 
> 
> 
> > +
> > +static struct node_hw_events *uncore_events[MAX_NUMNODES];
> 
> Don't declare static arrays with MAX_NUMNODES, that number can be
> very large and cause unnecessary bloat. Better use per CPU data or similar
> (e.g. with  alloc_percpu)

I really need is a per physical cpu data here, is alloc_percpu enough?

> 
> > +	/*
> > +	 * The hw event starts counting from this event offset,
> > +	 * mark it to be able to extra future deltas:
> > +	 */
> > +	local64_set(&hwc->prev_count, (u64)-left);
> 
> Your use of local* seems dubious. That is only valid if it's really
> all on the same CPU. Is that really true?

Good catch! That is not true.

The interrupt handler is running on one core and the
data(hwc->prev_count) maybe on another core.

Any idea to set this cross-core data?

> 
> > +static int uncore_pmu_add(struct perf_event *event, int flags)
> > +{
> > +	int node = numa_node_id();
> 
> this should be still package id

Understand, this is in my TODO.

> 
> > +	/* Check CPUID signatures: 06_1AH, 06_1EH, 06_1FH */
> > +	model = eax.split.model | (eax.split.ext_model << 4);
> > +	if (eax.split.family != 6 || (model != 0x1A && model != 0x1E && model !=
> > 0x1F))
> > +		return;
> 
> You can just get that from boot_cpu_data, no need to call cpuid

Nice, will use it.

> 
> > +#include <linux/perf_event.h>
> > +#include <linux/capability.h>
> > +#include <linux/notifier.h>
> > +#include <linux/hardirq.h>
> > +#include <linux/kprobes.h>
> > +#include <linux/module.h>
> > +#include <linux/kdebug.h>
> > +#include <linux/sched.h>
> > +#include <linux/uaccess.h>
> > +#include <linux/slab.h>
> > +#include <linux/highmem.h>
> > +#include <linux/cpu.h>
> > +#include <linux/bitops.h>
> 
> Do you really need all these includes?

Only

#include <linux/perf_event.h>
#include <linux/kprobes.h>
#include <linux/hardirq.h>
#include <linux/slab.h>

are needed.

Thanks for the comments.
Lin Ming


