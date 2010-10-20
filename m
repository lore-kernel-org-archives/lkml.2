Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753106Ab0JTKl2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 06:41:28 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:60374 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752936Ab0JTKl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 06:41:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMJhvkx5LdoF/2dsb2JhbAChV3K+CoVKBA
Date: Wed, 20 Oct 2010 21:41:21 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 31/35] fs: icache per-zone inode LRU
Message-ID: <20101020104121.GA5999@amd>
References: <20101019034658.744504135@kernel.dk>
 <20101019123852.GA12506@dastard>
 <20101020115432.1821.A69D9226@jp.fujitsu.com>
 <20101020032024.GA4134@amd>
 <20101020101906.GM32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020101906.GM32255@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 09:19:06PM +1100, Dave Chinner wrote:
> On Wed, Oct 20, 2010 at 02:20:24PM +1100, Nick Piggin wrote:
> > 
> > Well if XFS were to use per-ZONE shrinkers, it would remain with a
> > single shrinker context per-sb like it has now, but it would divide
> > its object management into per-zone structures.
> 
> <sigh>
> 
> I don't think anyone wants per-ag X per-zone reclaim lists on a 1024
> node machine with a 1,000 AG (1PB) filesystem.

Maybe not, but a 1024 node machine will *definitely* need to minimise
interconnect traffic and remote memory access. So if each node can't
spare enough memory for a couple of thousand LRU list heads, then
XFS's per-ag LRUs may need rethinking (they may provide reasonable
scalability on well partitioned workloads, but they can not help
the reclaimers to do the right thing -- remote memory accesses will
still dominate the inode LRU scanning there).


> As I have already said, the XFS inode caches are optimised in
> structure to minimise IO and maximise internal filesystem
> parallelism. They are not optimised for per-cpu or NUMA scalability
> because if you don't have filesystem level parallelism, you can't
> scale to large numbers of concurrent operations across large numbers
> of CPUs in the first place.

And as I have already said, nothing in my patches changes that.
What it provides is *opportunity* for shrinkers to take advantage
of per-zone scalability and improved reclaim patterns. Nothing
forces it, though.

 
> In the case of XFS, per-allocation group is the way we scale
> internal parallelism and as long as you have more AGs than you have
> CPUs, there is very good per-CPU scalability through the filesystem
> because most operations are isolated to a single AG.  That is how we
> scale parallelism in XFS, and it has proven to scale pretty well for
> even the largest of NUMA machines. 
> 
> This is what I mean about there being an impedence mismatch between
> the way the VM and the VFS/filesystem caches scale. Fundamentally,
> the way filesystems want their caches to operate for optimal
> performance can be vastly different to the way you want shrinkers to
> operate for VM scalability. Forcing the MM way of doing stuff down
> into the LRUs and shrinkers is not a good way of solving this
> problem.

It isn't forcing anything. Maybe you didn't understand the patch
because you keep repeating this.

 
> > For subsystems that aren't important, don't take much memory or have
> > much reclaim throughput, they are free to ignore the zone argument
> > and keep using the global input to the shrinker.
> 
> Having a global lock in a shrinker is already a major point of
> contention because shrinkers have unbound parallelism.  Hence all
> shrinkers need to be converted to use scalable structures. What we
> need _first_ is the infrastructure to do this in a sane manner, not
> tie a couple of shrinkers tightly into the mm structures and then
> walk away.

Per zone is the way to do it. Shrinkers and reclaim concept is
already tightly coupled with the mm. Memory pressure and the need
to reclaim occurs solely and only as a function of a zone (or zones).
Adding the zone argument to the shrinker does nothing more than adding
that previously missing input to the shrinker.

"I have a memory shortage in this zone, so I need to free reclaimable
objects from this zone"

This is a pretty core memory managementy idea. If you "decouple"
shrinkers from mm any further, then you end up with something that
doesn't give shrinkers the required information.
 

> And FWIW, most subsystems that use shrinkers can be compiled in as
> modules or not compiled in at all. That'll probably leave #ifdef
> CONFIG_ crap all through the struct zone definition as they are
> converted to use your current method....

I haven't thought about how random drivers will do per-zone things.
Obviously not an all out dumping ground in struct zone, but it does
fit for critical central caches like page, inode, and dentry.

Even if they aren't compiled out, we don't want their size bloating
things too much if they aren't loaded or in use. Probably dynamic
allocation would be the best way to go for them. Pretty simple really.

