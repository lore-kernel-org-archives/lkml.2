Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab0JFEyA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 00:54:00 -0400
Received: from bld-mail14.adl6.internode.on.net ([150.101.137.99]:38227 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752019Ab0JFEx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 00:53:59 -0400
Date: Wed, 6 Oct 2010 15:53:49 +1100
From: Dave Chinner <david@fromorbit.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Elder <aelder@sgi.com>, xfs@oss.sgi.com,
        John Hawley <warthog9@kernel.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: Re: [patch] xfs: properly account for reclaimed inodes
Message-ID: <20101006045349.GA13191@dastard>
References: <20101001074354.GF2618@cmpxchg.org>
 <1285953443.2422.4.camel@doink>
 <20101004071904.GH4681@dastard>
 <20101004102213.GJ2618@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004102213.GJ2618@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 12:22:13PM +0200, Johannes Weiner wrote:
> Hi,
> 
> On Mon, Oct 04, 2010 at 06:19:04PM +1100, Dave Chinner wrote:
> > On Fri, Oct 01, 2010 at 12:17:23PM -0500, Alex Elder wrote:
> > > On Fri, 2010-10-01 at 09:43 +0200, Johannes Weiner wrote:
> > > > When marking an inode reclaimable, a per-AG counter is increased, the
> > > > inode is tagged reclaimable in its per-AG tree, and, when this is the
> > > > first reclaimable inode in the AG, the AG entry in the per-mount tree
> > > > is also tagged.
> > > > 
> > > > When an inode is finally reclaimed, however, it is only deleted from
> > > > the per-AG tree.  Neither the counter is decreased, nor is the parent
> > > > tree's AG entry untagged properly.
> > > > 
> > > > Since the tags in the per-mount tree are not cleared, the inode
> > > > shrinker iterates over all AGs that have had reclaimable inodes at one
> > > > point in time.
> > > > 
> > > > The counters on the other hand signal an increasing amount of slab
> > > > objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
> > > > per-filesystem context" this is not a real issue anymore because the
> > > > shrinker bails out after one iteration.
> > > > 
> > > > But the problem was observable on a machine running v2.6.34, where the
> > > > reclaimable work increased and each process going into direct reclaim
> > > > eventually got stuck on the xfs inode shrinking path, trying to scan
> > > > several million objects.
> > > > 
> > > > Fix this by properly unwinding the reclaimable-state tracking of an
> > > > inode when it is reclaimed.
> > > > 
> > > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > > Cc: stable@kernel.org
> > > 
> > > Yes, this looks right to me.  The state was correctly
> > > adjusted in xfs_iget_cache_hit() when a RECLAIMABLE
> > > inode is found in the cache, but it was not done when
> > > reclaim completes.
> > > 
> > > Reviewed-by: Alex Elder <aelder@sgi.com>
> > 
> > Alex, can you push this to Linus ASAP? This needs to go back to
> > stable kernels as well..
> 
> Here is my suggestion of a backport to .34.  Dave, Alex, do you
> approve?
> 
> 	Hannes
> 
> diff --git a/fs/xfs/xfs_iget.c b/fs/xfs/xfs_iget.c
> index 6845db9..3314f2a 100644
> --- a/fs/xfs/xfs_iget.c
> +++ b/fs/xfs/xfs_iget.c
> @@ -499,6 +499,7 @@ xfs_ireclaim(
>  	write_lock(&pag->pag_ici_lock);
>  	if (!radix_tree_delete(&pag->pag_ici_root, agino))
>  		ASSERT(0);
> +	pag->pag_ici_reclaimable--;
>  	write_unlock(&pag->pag_ici_lock);
>  	xfs_perag_put(pag);

Looks good to me.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
