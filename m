Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab0KURo0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 12:44:26 -0500
Received: from canuck.infradead.org ([134.117.69.58]:47782 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab0KURoY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 12:44:24 -0500
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1290348259.2245.172.camel@localhost>
References: <1290340877.2245.124.camel@localhost>
	 <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
	 <1290348259.2245.172.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Sun, 21 Nov 2010 18:44:33 +0100
Message-ID: <1290361473.2153.39.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-21 at 22:04 +0800, Lin Ming wrote:
> On Sun, 2010-11-21 at 20:46 +0800, Andi Kleen wrote:
> > >
> > > 2. Uncore pmu NMI handling
> > >
> > > All the 4 cores are programmed to receive uncore counter overflow
> > > interrupt. The NMI handler(running on 1 of the 4 cores) handle all
> > > counters enabled by all 4 cores.
> > 
> > Really for uncore monitoring there is no need to use an NMI handler.
> > You can't profile a core anyways, so you can just delay the reporting
> > a little bit. It may simplify the code to not use one here
> > and just use an ordinary handler.
> 
> OK, I can use on ordinary interrupt handler here.

Does the hardware actually allow using a different interrupt source?

> > 
> > In general since there is already much trouble with overloaded
> > NMI events avoiding new NMIs is a good idea.
> > 
> > 
> > 
> > > +
> > > +static struct node_hw_events *uncore_events[MAX_NUMNODES];
> > 
> > Don't declare static arrays with MAX_NUMNODES, that number can be
> > very large and cause unnecessary bloat. Better use per CPU data or similar
> > (e.g. with  alloc_percpu)
> 
> I really need is a per physical cpu data here, is alloc_percpu enough?

Nah, simply manually allocate bits using kmalloc_node(), that's
something I still need to fix in Andi's patches as well.

> > > +	/*
> > > +	 * The hw event starts counting from this event offset,
> > > +	 * mark it to be able to extra future deltas:
> > > +	 */
> > > +	local64_set(&hwc->prev_count, (u64)-left);
> > 
> > Your use of local* seems dubious. That is only valid if it's really
> > all on the same CPU. Is that really true?
> 
> Good catch! That is not true.
> 
> The interrupt handler is running on one core and the
> data(hwc->prev_count) maybe on another core.
> 
> Any idea to set this cross-core data?

IIRC you can steer the uncore interrupts (it has a mask somewhere)
simply steer everything to the first cpu in the nodemask?



