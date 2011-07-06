Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab1GFQmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:42:14 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:46294 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811Ab1GFQmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:42:12 -0400
Date: Wed, 6 Jul 2011 22:11:46 +0530
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: Ankita Garg <ankita@in.ibm.com>, linux-arm-kernel@lists.infradead.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, thomas.abraham@linaro.org,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Arjan van de Ven <arjan@infradead.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH 00/10] mm: Linux VM Infrastructure to support Memory
 Power Management
Message-ID: <20110706164146.GD4356@dirshya.in.ibm.com>
Reply-To: svaidy@linux.vnet.ibm.com
References: <1306499498-14263-1-git-send-email-ankita@in.ibm.com>
 <20110629130038.GA7909@in.ibm.com>
 <CAOJsxLHQP=-srK_uYYBsPb7+rUBnPZG7bzwtCd-rRaQa4ikUFg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOJsxLHQP=-srK_uYYBsPb7+rUBnPZG7bzwtCd-rRaQa4ikUFg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pekka Enberg <penberg@kernel.org> [2011-07-06 11:45:41]:

> Hi Ankita,
> 
> [ I don't really know anything about memory power management but
>   here's my two cents since you asked for it. ]
> 
> On Wed, Jun 29, 2011 at 4:00 PM, Ankita Garg <ankita@in.ibm.com> wrote:
> > I) Dynamic Power Transition
> >
> > The goal here is to ensure that as much as possible, on an idle system,
> > the memory references do not get spread across the entire RAM, a problem
> > similar to memory fragmentation. The proposed approach is as below:
> >
> > 1) One of the first things is to ensure that the memory allocations do
> > not spill over to more number of regions. Thus the allocator needs to
> > be aware of the address boundary of the different regions.
> 
> Why does the allocator need to know about address boundaries? Why
> isn't it enough to make the page allocator and reclaim policies favor using
> memory from lower addresses as aggressively as possible? That'd mean
> we'd favor the first memory banks and could keep the remaining ones
> powered off as much as possible.

Yes, this will work to a limited extent when we have few regions to
account for.  However if applications start and stop leaving large
holes in the address map, it may not worth the effort of migrating
pages to lower addresses to pack the holes.

> IOW, why do we need to support scenarios such as this:
> 
>    bank 0     bank 1   bank 2    bank3
>  | online  | offline | online  | offline |
> 
> instead of using memory compaction and possibly something like the
> SLUB defragmentation patches to turn the memory map into this:
> 
>    bank 0     bank 1   bank 2   bank3
>  | online  | online  | offline | offline |

Yes, this is what we need, but also have a notion of how many pages
are used in each bank so that we can pack pages from under utilized
banks into a reasonably used bank and thereby free more banks.

Freeing more banks + clustering all used or free banks gives us more
power saving benefits.

> > 2) At the time of allocation, before spilling over allocations to the
> > next logical region, the allocator needs to make a best attempt to
> > reclaim some memory from within the existing region itself first. The
> > reclaim here needs to be in LRU order within the region.  However, if
> > it is ascertained that the reclaim would take a lot of time, like there
> > are quite a fe write-backs needed, then we can spill over to the next
> > memory region (just like our NUMA node allocation policy now).
> 
> I think a much more important question is what happens _after_ we've
> allocated and free'd tons of memory few times. AFAICT, memory
> regions don't help with that kind of fragmentation that will eventually
> happen anyway.
 
Memory regions allow us to have a zone per-region.  This helps in the
cases were allocations are fragments into multiple regions by
potentially reclaiming very low utilized regions and packing the pages
into higher utilized regions.  The requirement is a standard
de-fragmentation approach, except that the cluster of allocations
should fall within a region (any region) as much as possible.

--Vaidy

