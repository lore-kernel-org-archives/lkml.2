Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab0KXJyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:54:00 -0500
Received: from mga02.intel.com ([134.134.136.20]:10343 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0KXJx7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:53:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,247,1288594800"; 
   d="scan'208";a="577090329"
Subject: Re: [RFC PATCH 2/3 v2] perf: Implement Nehalem uncore pmu
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1290361473.2153.39.camel@laptop>
References: <1290340877.2245.124.camel@localhost>
	 <8e9ff9280b0c4a059bc82b5c4a629897.squirrel@www.firstfloor.org>
	 <1290348259.2245.172.camel@localhost>  <1290361473.2153.39.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Nov 2010 17:55:13 +0800
Message-ID: <1290592513.2405.78.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 01:44 +0800, Peter Zijlstra wrote:
> On Sun, 2010-11-21 at 22:04 +0800, Lin Ming wrote:
> > On Sun, 2010-11-21 at 20:46 +0800, Andi Kleen wrote:
> > > >
> > > > 2. Uncore pmu NMI handling
> > > >
> > > > All the 4 cores are programmed to receive uncore counter overflow
> > > > interrupt. The NMI handler(running on 1 of the 4 cores) handle all
> > > > counters enabled by all 4 cores.
> > > 
> > > Really for uncore monitoring there is no need to use an NMI handler.
> > > You can't profile a core anyways, so you can just delay the reporting
> > > a little bit. It may simplify the code to not use one here
> > > and just use an ordinary handler.
> > 
> > OK, I can use on ordinary interrupt handler here.
> 
> Does the hardware actually allow using a different interrupt source?
> 
> > > 
> > > In general since there is already much trouble with overloaded
> > > NMI events avoiding new NMIs is a good idea.
> > > 
> > > 
> > > 
> > > > +
> > > > +static struct node_hw_events *uncore_events[MAX_NUMNODES];
> > > 
> > > Don't declare static arrays with MAX_NUMNODES, that number can be
> > > very large and cause unnecessary bloat. Better use per CPU data or similar
> > > (e.g. with  alloc_percpu)
> > 
> > I really need is a per physical cpu data here, is alloc_percpu enough?
> 
> Nah, simply manually allocate bits using kmalloc_node(), that's
> something I still need to fix in Andi's patches as well.

I'm writing this like AMD NB events allocation.

Thanks,
Lin Ming

> 
> > > > +	/*
> > > > +	 * The hw event starts counting from this event offset,
> > > > +	 * mark it to be able to extra future deltas:
> > > > +	 */
> > > > +	local64_set(&hwc->prev_count, (u64)-left);
> > > 
> > > Your use of local* seems dubious. That is only valid if it's really
> > > all on the same CPU. Is that really true?
> > 
> > Good catch! That is not true.
> > 
> > The interrupt handler is running on one core and the
> > data(hwc->prev_count) maybe on another core.
> > 
> > Any idea to set this cross-core data?
> 
> IIRC you can steer the uncore interrupts (it has a mask somewhere)
> simply steer everything to the first cpu in the nodemask?
> 
> 
> 


