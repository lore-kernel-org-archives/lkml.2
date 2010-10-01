Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab0JARSK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 13:18:10 -0400
Received: from relay3.sgi.com ([192.48.152.1]:43862 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753188Ab0JARSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 13:18:08 -0400
Subject: Re: [patch] xfs: properly account for reclaimed inodes
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: xfs@oss.sgi.com, John Hawley <warthog9@kernel.org>,
        linux-kernel@vger.kernel.org, stable@kernel.org
In-Reply-To: <20101001074354.GF2618@cmpxchg.org>
References: <20101001074354.GF2618@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 01 Oct 2010 12:17:23 -0500
Message-ID: <1285953443.2422.4.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 01 Oct 2010 17:17:24.0195 (UTC) FILETIME=[83A22B30:01CB618C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-01 at 09:43 +0200, Johannes Weiner wrote:
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

Yes, this looks right to me.  The state was correctly
adjusted in xfs_iget_cache_hit() when a RECLAIMABLE
inode is found in the cache, but it was not done when
reclaim completes.

Reviewed-by: Alex Elder <aelder@sgi.com>


