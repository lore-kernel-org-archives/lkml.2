Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab0JAOCr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:02:47 -0400
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:37332 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756791Ab0JAOCq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:02:46 -0400
Date: Sat, 2 Oct 2010 00:02:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: xfs@oss.sgi.com, John Hawley <warthog9@kernel.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [patch] xfs: properly account for reclaimed inodes
Message-ID: <20101001140237.GC4681@dastard>
References: <20101001074354.GF2618@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101001074354.GF2618@cmpxchg.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 09:43:54AM +0200, Johannes Weiner wrote:
> When marking an inode reclaimable, a per-AG counter is increased, the
> inode is tagged reclaimable in its per-AG tree, and, when this is the
> first reclaimable inode in the AG, the AG entry in the per-mount tree
> is also tagged.
> 
> When an inode is finally reclaimed, however, it is only deleted from
> the per-AG tree.  Neither the counter is decreased, nor is the parent
> tree's AG entry untagged properly.
> 
> Since the tags in the per-mount tree are not cleared, the inode
> shrinker iterates over all AGs that have had reclaimable inodes at one
> point in time.
> 
> The counters on the other hand signal an increasing amount of slab
> objects to reclaim.  Since "70e60ce xfs: convert inode shrinker to
> per-filesystem context" this is not a real issue anymore because the
> shrinker bails out after one iteration.
> 
> But the problem was observable on a machine running v2.6.34, where the
> reclaimable work increased and each process going into direct reclaim
> eventually got stuck on the xfs inode shrinking path, trying to scan
> several million objects.
> 
> Fix this by properly unwinding the reclaimable-state tracking of an
> inode when it is reclaimed.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: stable@kernel.org

Looks OK to me, and has run through a few hours of testing without
problems.

Reviewed-by: Dave Chinner <dchinner@redhat.com>

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
