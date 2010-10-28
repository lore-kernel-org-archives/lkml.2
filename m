Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932761Ab0J1Qpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 12:45:33 -0400
Received: from gir.skynet.ie ([193.1.99.77]:60809 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759370Ab0J1Qp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 12:45:28 -0400
Date: Thu, 28 Oct 2010 17:45:14 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Christoph Lameter <cl@linux.com>,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Brian Gerst <brgerst@gmail.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: [PATCH] numa: fix slab_node(MPOL_BIND)
Message-ID: <20101028164514.GE4896@csn.ul.ie>
References: <1288187870.2709.128.camel@edumazet-laptop> <4CC83067.5000009@kernel.org> <1288189461.2709.144.camel@edumazet-laptop> <1288190387.2709.147.camel@edumazet-laptop> <4CC83A85.3070608@kernel.org> <1288192868.2709.152.camel@edumazet-laptop> <4CC846D5.50106@kernel.org> <1288195668.2709.167.camel@edumazet-laptop> <1288200823.5619.46.camel@edumazet-laptop> <AANLkTikmNc7qqDzoff_3i_FRbG=pmOC7TG3eeZnmvaTD@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTikmNc7qqDzoff_3i_FRbG=pmOC7TG3eeZnmvaTD@mail.gmail.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 08:59:42AM -0700, Linus Torvalds wrote:
> Hmm. More people added to the discussion..
> 
> This code seems to go back all the way to commit 19770b32609b: "mm:
> filter based on a nodemask as well as a gfp_mask". Which was back in
> April 2008. and got merged into 2.6.26.
> 

I am about to run out the door so I didn't read the thread but
first_zones_zonelist() can indeed return NULL. It happens when the
zonelist is empty (unlikely) or when a nodemask is applied restricting
the allowable nodes and that results in no valid zones (more likely).

> And I'd be happy to commit it (in fact, I was going to), but when
> looking for other uses of first_zones_zonelist(), I found
> local_memory_node() which does the exact same thing: ignore the return
> value, and unconditionally dereference the resulting 'zone' variable.
> 

That does look unsafe.

> And so does - although less obviously - mm/vmscan.c for the
> wait_iff_confgested() thing.
> 

It should be implicitly safe although it is non-obvious.  wait_iff_congested
in mm/vmscan.c is called from do_try_to_free_pages() which is in the direct
reclaim path. To get there, it must have passed this check in page_alloc.c

        first_zones_zonelist(zonelist, high_zoneidx, nodemask, &preferred_zone);
        if (!preferred_zone) {
                put_mems_allowed();
                return NULL;
        }

Did I miss anything?

The memory controller also can end up there but for it to get into
trouble, they would have to be trying to shrink a cgroup with an invalid
zonelist. Is that possible?

> So are those buggy too, since first_zones_zonelist() can apparently return NULL?
> 

Yes, it can.

> Please advise...
> 

Callers need to check for NULL or be sure they are not dealing with an
empty zonelist.

>                   Linus
> 
> On Wed, Oct 27, 2010 at 10:33 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le mercredi 27 octobre 2010 à 18:07 +0200, Eric Dumazet a écrit :
> >
> >> So I tried following experiment :
> >>
> >> # swapoff
> >> # numactl --membind=0 swapon -a
> >> # grep swap /proc/vmallocinfo
> >> 0xf9bf3000-0xf9cf4000 1052672 sys_swapon+0x4aa/0xb24 pages=256 vmalloc N0=256
> >> # swapoff -a
> >> # numactl --membind=1 swapon -a
> >>
> >> <<FREEZE>>
> >>
> >
> > Crash in fact, not freeze, in slab_node()
> >
> > Problem is : we dereference a NULL zone pointer.
> >
> > (node 1 has HighMem only)
> >
> > Following patch seems to solve the problem for me
> >
> > # swapoff -a
> > # numactl --membind=1 swapon -a
> > # grep swap /proc/vmallocinfo
> > 0xf9da5000-0xf9ea6000 1052672 sys_swapon+0x3f9/0xa34 pages=256 vmalloc N1=256
> >
> >
> > Thanks
> >
> >
> > [PATCH] numa: fix slab_node(MPOL_BIND)
> >
> > When a node contains only HighMem memory, slab_node(MPOL_BIND)
> > dereferences a NULL pointer.
> >
> > Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> > ---
> >  mm/mempolicy.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index 81a1276..4a57f13 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -1597,7 +1597,7 @@ unsigned slab_node(struct mempolicy *policy)
> >                (void)first_zones_zonelist(zonelist, highest_zoneidx,
> >                                                        &policy->v.nodes,
> >                                                        &zone);
> > -               return zone->node;
> > +               return zone ? zone->node : numa_node_id();
> >        }
> >
> >        default:
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
