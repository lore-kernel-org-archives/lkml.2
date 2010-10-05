Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932736Ab0JEJ1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 05:27:06 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53201 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab0JEJ1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 05:27:03 -0400
From: "Hans-Peter Jansen" <hpj@urpla.net>
To: xfs@oss.sgi.com
Subject: Re: [patch] xfs: properly account for reclaimed inodes
Date: Tue, 5 Oct 2010 11:26:46 +0200
User-Agent: KMail/1.9.10
Cc: Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <david@fromorbit.com>,
        stable@kernel.org, John Hawley <warthog9@kernel.org>,
        linux-kernel@vger.kernel.org, Alex Elder <aelder@sgi.com>
References: <20101001074354.GF2618@cmpxchg.org> <20101004071904.GH4681@dastard> <20101004102213.GJ2618@cmpxchg.org>
In-Reply-To: <20101004102213.GJ2618@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010051126.47537.hpj@urpla.net>
X-Provags-ID: V02:K0:SZeMBl0FgehY9mxeqo+G8AOsz+IHMGDqSwfQzoJqXds
 8FqLq+Qshs3boli8YQ9C+7qnRpYfrb3FaoftU0VZK1S1DrwPpF
 /MMKYPaeCJCNvcTv1LVFP7VEMpFcaYH+PGluMQm442iCaWbXmH
 enb1ufmGq6vvBSEDwXLeRHoCv6hrYGt8nWwKVC78nKR3M9DLQw
 A6m5xvmosF5dLOxcFMy11DNJ51sqhMtytDqAGyzdBQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 October 2010, 12:22:13 Johannes Weiner wrote:
> Hi,
>
> On Mon, Oct 04, 2010 at 06:19:04PM +1100, Dave Chinner wrote:
> > On Fri, Oct 01, 2010 at 12:17:23PM -0500, Alex Elder wrote:
> > > On Fri, 2010-10-01 at 09:43 +0200, Johannes Weiner wrote:
> > > > When marking an inode reclaimable, a per-AG counter is increased,
> > > > the inode is tagged reclaimable in its per-AG tree, and, when this
> > > > is the first reclaimable inode in the AG, the AG entry in the
> > > > per-mount tree is also tagged.
> > > >
> > > > When an inode is finally reclaimed, however, it is only deleted
> > > > from the per-AG tree.  Neither the counter is decreased, nor is the
> > > > parent tree's AG entry untagged properly.
> > > >
> > > > Since the tags in the per-mount tree are not cleared, the inode
> > > > shrinker iterates over all AGs that have had reclaimable inodes at
> > > > one point in time.
> > > >
> > > > The counters on the other hand signal an increasing amount of slab
> > > > objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
> > > > per-filesystem context" this is not a real issue anymore because
> > > > the shrinker bails out after one iteration.
> > > >
> > > > But the problem was observable on a machine running v2.6.34, where
> > > > the reclaimable work increased and each process going into direct
> > > > reclaim eventually got stuck on the xfs inode shrinking path,
> > > > trying to scan several million objects.
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
>
>

Ping?

Masters of xfs, please raise your voices!

Pete
