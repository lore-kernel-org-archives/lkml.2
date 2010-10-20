Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab0JTKTW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:19:22 -0400
Received: from bld-mail18.adl2.internode.on.net ([150.101.137.103]:48156 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751251Ab0JTKTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:19:20 -0400
Date: Wed, 20 Oct 2010 21:19:06 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 31/35] fs: icache per-zone inode LRU
Message-ID: <20101020101906.GM32255@dastard>
References: <20101019034658.744504135@kernel.dk>
 <20101019123852.GA12506@dastard>
 <20101020115432.1821.A69D9226@jp.fujitsu.com>
 <20101020032024.GA4134@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020032024.GA4134@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 02:20:24PM +1100, Nick Piggin wrote:
> On Wed, Oct 20, 2010 at 12:14:32PM +0900, KOSAKI Motohiro wrote:
> > > On Tue, Oct 19, 2010 at 02:42:47PM +1100, npiggin@kernel.dk wrote:
> > > Anyway, my main point is that tying the LRU and shrinker scaling to
> > > the implementation of the VM is a one-off solution that doesn't work
> > > for generic infrastructure. Other subsystems need the same
> > > large-machine scaling treatment, and there's no way we should be
> > > tying them all into the struct zone. It needs further abstraction.
> > 
> > I'm not sure what data structure is best. I can only say current
> > zone unawareness slab shrinker might makes following sad scenario.
> > 
> >  o DMA zone shortage invoke and plenty icache in NORMAL zone dropping
> >  o NUMA aware system enable zone_reclaim_mode, but shrink_slab() still
> >    drop unrelated zone's icache
> > 
> > both makes performance degression. In other words, Linux does not have
> > flat memory model. so, I don't think Nick's basic concept is wrong. 
> > It's straight forward enhancement. but if it don't fit current shrinkers,
> > I'd like to discuss how to make better data structure.
> > 
> > 
> > 
> > and I have dump question (sorry, I don't know xfs at all). current
> > xfs_mount is below.
> > 
> > typedef struct xfs_mount {
> >  ...
> >         struct shrinker         m_inode_shrink; /* inode reclaim shrinker */
> > } xfs_mount_t;
> > 
> > 
> > Do you mean xfs can't convert shrinker to shrinker[ZONES]? If so, why?
> 
> Well if XFS were to use per-ZONE shrinkers, it would remain with a
> single shrinker context per-sb like it has now, but it would divide
> its object management into per-zone structures.

<sigh>

I don't think anyone wants per-ag X per-zone reclaim lists on a 1024
node machine with a 1,000 AG (1PB) filesystem.

As I have already said, the XFS inode caches are optimised in
structure to minimise IO and maximise internal filesystem
parallelism. They are not optimised for per-cpu or NUMA scalability
because if you don't have filesystem level parallelism, you can't
scale to large numbers of concurrent operations across large numbers
of CPUs in the first place.

In the case of XFS, per-allocation group is the way we scale
internal parallelism and as long as you have more AGs than you have
CPUs, there is very good per-CPU scalability through the filesystem
because most operations are isolated to a single AG.  That is how we
scale parallelism in XFS, and it has proven to scale pretty well for
even the largest of NUMA machines. 

This is what I mean about there being an impedence mismatch between
the way the VM and the VFS/filesystem caches scale. Fundamentally,
the way filesystems want their caches to operate for optimal
performance can be vastly different to the way you want shrinkers to
operate for VM scalability. Forcing the MM way of doing stuff down
into the LRUs and shrinkers is not a good way of solving this
problem.

> For subsystems that aren't important, don't take much memory or have
> much reclaim throughput, they are free to ignore the zone argument
> and keep using the global input to the shrinker.

Having a global lock in a shrinker is already a major point of
contention because shrinkers have unbound parallelism.  Hence all
shrinkers need to be converted to use scalable structures. What we
need _first_ is the infrastructure to do this in a sane manner, not
tie a couple of shrinkers tightly into the mm structures and then
walk away.

And FWIW, most subsystems that use shrinkers can be compiled in as
modules or not compiled in at all. That'll probably leave #ifdef
CONFIG_ crap all through the struct zone definition as they are
converted to use your current method....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
