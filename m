Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748Ab1GFFr7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 01:47:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:18204 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751940Ab1GFFr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 01:47:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,484,1304319600"; 
   d="scan'208";a="23055705"
Subject: Re: [PATCH 1/4] perf: Add memory load/store events generic code
From: Lin Ming <ming.m.lin@intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>
In-Reply-To: <1309875468.3282.210.camel@twins>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	 <1309766525-14089-2-git-send-email-ming.m.lin@intel.com>
	 <1309778192.3282.27.camel@twins>  <1309866860.2381.1.camel@localhost>
	 <1309875468.3282.210.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 06 Jul 2011 13:53:41 +0800
Message-ID: <1309931621.18875.130.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-07-05 at 22:17 +0800, Peter Zijlstra wrote:
> On Tue, 2011-07-05 at 19:54 +0800, Lin Ming wrote:
> > On Mon, 2011-07-04 at 19:16 +0800, Peter Zijlstra wrote:
> > > On Mon, 2011-07-04 at 08:02 +0000, Lin Ming wrote:
> > > > +#define MEM_STORE_DCU_HIT              (1ULL << 0)
> > > 
> > > I'm pretty sure that's not Dublin City University, but what is it?
> > > Data-Cache-Unit? what does that mean, L1/L2 or also L3? 
> > > 
> > > > +#define MEM_STORE_STLB_HIT             (1ULL << 1)
> > > 
> > > What's an sTLB? I know iTLB and dTLB's but sTLBs I've not heard of yet.
> > > 
> > > > +#define MEM_STORE_LOCKED_ACCESS                (1ULL << 2) 
> > > 
> > > Presumably that's about LOCK'ed ops?
> > > 
> > > So now you're just tacking bits on the end without even attempting to
> > > generalize/unify things, not charmed at all.
> > 
> > Any idea on the more useful store bits encoding?
> 
> For two of them, sure:
> 
> {load, store} x {atomic} x
> 	{hasSRC} x {l1, l2, l3, ram, unkown, io, uncached, reserved} x
> 	{hasLRS} x {local, remote, snoop} x 
> 	{hasMESI} x {MESI}
> 
> that would make MEM_STORE_DCU_HIT: store-l1 and MEM_STORE_LOCKED:
> store-atomic.
> 
> Now this is needed for load-latency as well, since SNB extended the src
> information with the same STLB/LOCK bits.
> 
> The SDM is somewhat inconsistent on what an STLB_MISS means:
> 
> Table 30-22 says: 0 - did not miss STLB (hit the DTLB/STLB), 1 - missed
> the STLB. 
> 
> Table 30-23 says: "the store missed the STLB if set, otherwise the store
> hit the STLB", which simply cannot be true. 
> 
> So I'm sticking with 30-22.
> 
> Now the above doesn't yet deal with TLBs nor can it map the IBS data
> source bits because afaict that can report a u-op as both a store and a
> load, but does not mention if a data-cache miss means L1 or L1/L2,
> Robert?
> 
> One way to sort all that is not use enumerated spaces like above but
> simply explode the whole thing like: load x store x atomic x l1 x l2
> x ... that would of course give rise to a load of impossible
> combinations but would do away with the hasFOO bits.
> 
> If the AMD data-cache means L1/L2 it can simply set both bits, same with
> the Intel STLB miss, it can set TLB1/TLB2 bits (AMD does split those
> nicely).
> 
> With all those bits exploded we can also express the inverse of
> MEM_STORE_DCU_HIT as: store-l2-l3-dram, we simply set ~l1 for the
> appropriate submask (which should arguably include IO/uncached/unknown
> as well).

Do you mean to use the "impossible combinations" to express the inverse?
MEM_STORE_DCU_MISS as: store-l2-l3-dram
MEM_STORE_STLB_MISS as: store-itlb-dtlb

How about below code?

#define PERF_MEM_LOAD                   (1ULL << 0)
#define PERF_MEM_STORE                  (1ULL << 1)
#define PERF_MEM_ATOMIC                 (1ULL << 2)
#define PERF_MEM_L1                     (1ULL << 3)
#define PERF_MEM_L2                     (1ULL << 4)
#define PERF_MEM_L3                     (1ULL << 5)
#define PERF_MEM_RAM                    (1ULL << 6)
#define PERF_MEM_UNKNOWN                (1ULL << 7)
#define PERF_MEM_IO                     (1ULL << 8)
#define PERF_MEM_UNCACHED               (1ULL << 9)
#define PERF_MEM_RESERVED               (1ULL << 10)
#define PERF_MEM_LOCAL                  (1ULL << 11)
#define PERF_MEM_REMOTE                 (1ULL << 12)
#define PERF_MEM_SNOOP                  (1ULL << 13)
#define PERF_MEM_MODIFIED               (1ULL << 14)
#define PERF_MEM_EXCLUSIVE              (1ULL << 15)
#define PERF_MEM_SHARED                 (1ULL << 16)
#define PERF_MEM_INVALID                (1ULL << 17)
#define PERF_MEM_ITLB                   (1ULL << 18)
#define PERF_MEM_DTLB                   (1ULL << 19)
#define PERF_MEM_STLB                   (1ULL << 20)

#define PERF_MEM_STORE_L1D_HIT  \
        (PERF_MEM_STORE | PERF_MEM_L1)

#define PERF_MEM_STORE_L1D_MISS \
        (PERF_MEM_STORE | PERF_MEM_L2 | PERF_MEM_L3 | PERF_MEM_RAM)

#define PERF_MEM_STORE_STLB_HIT \
        (PERF_MEM_STORE | PERF_MEM_STLB)
        
#define PERF_MEM_STORE_STLB_MISS \
        (PERF_MEM_STORE | PERF_MEM_ITLB | PERF_MEM_DTLB)

#define PERF_MEM_STORE_ATOMIC \
        (PERF_MEM_STORE | PERF_MEM_ATOMIC)

#define PERF_MEM_LOAD_STLB_HIT  \
        (PERF_MEM_LOAD | PERF_MEM_STLB)
   
#define PERF_MEM_LOAD_STLB_MISS \
        (PERF_MEM_LOAD | PERF_MEM_ITLB | PERF_MEM_DTLB)

#define PERF_MEM_LOAD_ATOMIC \
        (PERF_MEM_LOAD | PERF_MEM_ATOMIC)

