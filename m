Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab0LHNwo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 08:52:44 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:12960 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755048Ab0LHNwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 08:52:43 -0500
Subject: Re: [06/44] numa: fix slab_node(MPOL_BIND)
From: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org, stable@kernel.org,
        stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Mel Gorman <mel@csn.ul.ie>, Christoph Lameter <cl@linux.com>
In-Reply-To: <1291782782.5324.54.camel@edumazet-laptop>
References: <20101208000640.115606851@clark.site>
	 <1291777422.26147.70.camel@zaphod>
	 <1291782782.5324.54.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Organization: HP/LKTT
Date: Wed, 08 Dec 2010 08:53:09 -0500
Message-ID: <1291816389.3941.17.camel@zaphod>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 05:33 +0100, Eric Dumazet wrote:
> Le mardi 07 décembre 2010 à 22:03 -0500, Lee Schermerhorn a écrit :
> > On Tue, 2010-12-07 at 16:04 -0800, Greg KH wrote:
> > > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> > > 
> > > ------------------
> > > 
> > > From: Eric Dumazet <eric.dumazet@gmail.com>
> > > 
> > > commit 800416f799e0723635ac2d720ad4449917a1481c upstream.
> > > 
> 
> > > 
> > > --- a/mm/mempolicy.c
> > > +++ b/mm/mempolicy.c
> > > @@ -1404,7 +1404,7 @@ unsigned slab_node(struct mempolicy *pol
> > >  		(void)first_zones_zonelist(zonelist, highest_zoneidx,
> > >  							&policy->v.nodes,
> > >  							&zone);
> > > -		return zone->node;
> > > +		return zone ? zone->node : numa_node_id();
> > 
> > I think this should be numa_mem_id().  Given the documented purpose of
> > slab_node(), we want a node from which page allocation is likely to
> > succeed.  numa_node_id() can return a memoryless node for, e.g.,  some
> > configurations of some HP ia64 platforms.  numa_mem_id() was introduced
> > to return that same node from which "local" mempolicy would allocate
> > pages.
> 
> Hmm... numa_mem_id() was introduced in 2.6.35 as an optimization.
> 
> When I did this patch (to fix a bug), mm/mempolicy.c only contained
> calls to numa_node_id() (and still is today)

Sometimes you want numa_node_id()--e.g., for use with a mempolicy-based
allocation that allows fallback.  When the node id will be used for a
'_THIS_NODE allocation, numa_mem_id() is preferred as it will always
return a node that contains or contained--maybe now oom--memory.  It's
the same as numa_node_id() on platforms that don't expose memoryless
nodes.  

> 
> By the way, anybody knows how I can emulate a memoryless node on a dual
> node x86_64 machine (with memory present on both nodes) ?
> 

You can use the mem= boot parameter and specify the amount of memory on
the 1st/boot node.  Or you can use the memmap parameter to reserve the
memory on the 2nd/non-boot node.  With the memmap parameter, you can
reserve the memory of nodes other than the highest numbered
one[s]--e.g., on a >2 node platform.  However, you'll probably a patch
to see the cpus on any node that you hide using memmap.  I have such a
patch if you're interested in going that route.

You can also reduce the amount of memory on any/each node by reserving
ranges of physical memory with memmap.  Use the 'SRAT.*PXM' boot
messages to find the nodes' physical memory ranges and reserve how ever
much you want off the top of the nodes.

Lee



