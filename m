Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726Ab1GEOSt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 10:18:49 -0400
Received: from casper.infradead.org ([85.118.1.10]:41945 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115Ab1GEOSs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 10:18:48 -0400
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1309866860.2381.1.camel@localhost>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309778192.3282.27.camel@twins>  <1309866860.2381.1.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 05 Jul 2011 16:17:48 +0200
Message-ID: <1309875468.3282.210.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 19:54 +0800, Lin Ming wrote:
> On Mon, 2011-07-04 at 19:16 +0800, Peter Zijlstra wrote:
> > On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> > > +#define MEM_STORE_DCU_HIT              (1ULL << 0)
> > 
> > I'm pretty sure that's not Dublin City University, but what is it?
> > Data-Cache-Unit? what does that mean, L1/L2 or also L3? 
> > 
> > > +#define MEM_STORE_STLB_HIT             (1ULL << 1)
> > 
> > What's an sTLB? I know iTLB and dTLB's but sTLBs I've not heard of yet.
> > 
> > > +#define MEM_STORE_LOCKED_ACCESS                (1ULL << 2) 
> > 
> > Presumably that's about LOCK'ed ops?
> > 
> > So now you're just tacking bits on the end without even attempting to
> > generalize/unify things, not charmed at all.
> 
> Any idea on the more useful store bits encoding?

For two of them, sure:

{load, store} x {atomic} x
	{hasSRC} x {l1, l2, l3, ram, unkown, io, uncached, reserved} x
	{hasLRS} x {local, remote, snoop} x 
	{hasMESI} x {MESI}

that would make MEM_STORE_DCU_HIT: store-l1 and MEM_STORE_LOCKED:
store-atomic.

Now this is needed for load-latency as well, since SNB extended the src
information with the same STLB/LOCK bits.

The SDM is somewhat inconsistent on what an STLB_MISS means:

Table 30-22 says: 0 - did not miss STLB (hit the DTLB/STLB), 1 - missed
the STLB. 

Table 30-23 says: "the store missed the STLB if set, otherwise the store
hit the STLB", which simply cannot be true. 

So I'm sticking with 30-22.

Now the above doesn't yet deal with TLBs nor can it map the IBS data
source bits because afaict that can report a u-op as both a store and a
load, but does not mention if a data-cache miss means L1 or L1/L2,
Robert?

One way to sort all that is not use enumerated spaces like above but
simply explode the whole thing like: load x store x atomic x l1 x l2
x ... that would of course give rise to a load of impossible
combinations but would do away with the hasFOO bits.

If the AMD data-cache means L1/L2 it can simply set both bits, same with
the Intel STLB miss, it can set TLB1/TLB2 bits (AMD does split those
nicely).

With all those bits exploded we can also express the inverse of
MEM_STORE_DCU_HIT as: store-l2-l3-dram, we simply set ~l1 for the
appropriate submask (which should arguably include IO/uncached/unknown
as well).

Now if anybody knows of another arch that has similar features (IA64,
ppc64?) can we get links to their PMU docs so that we can see if we can
map them as well?


Comments?

