Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab0JTDU2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:20:28 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:11483 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757343Ab0JTDU1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:20:27 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAEj8vUx5LdoF/2dsb2JhbAChV3LCRoVKBA
Date: Wed, 20 Oct 2010 14:20:24 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Dave Chinner <david@fromorbit.com>, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 31/35] fs: icache per-zone inode LRU
Message-ID: <20101020032024.GA4134@amd>
References: <20101019034658.744504135@kernel.dk>
 <20101019123852.GA12506@dastard>
 <20101020115432.1821.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101020115432.1821.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 12:14:32PM +0900, KOSAKI Motohiro wrote:
> > On Tue, Oct 19, 2010 at 02:42:47PM +1100, npiggin@kernel.dk wrote:
> > Anyway, my main point is that tying the LRU and shrinker scaling to
> > the implementation of the VM is a one-off solution that doesn't work
> > for generic infrastructure. Other subsystems need the same
> > large-machine scaling treatment, and there's no way we should be
> > tying them all into the struct zone. It needs further abstraction.
> 
> I'm not sure what data structure is best. I can only say current
> zone unawareness slab shrinker might makes following sad scenario.
> 
>  o DMA zone shortage invoke and plenty icache in NORMAL zone dropping
>  o NUMA aware system enable zone_reclaim_mode, but shrink_slab() still
>    drop unrelated zone's icache
> 
> both makes performance degression. In other words, Linux does not have
> flat memory model. so, I don't think Nick's basic concept is wrong. 
> It's straight forward enhancement. but if it don't fit current shrinkers,
> I'd like to discuss how to make better data structure.
> 
> 
> 
> and I have dump question (sorry, I don't know xfs at all). current
> xfs_mount is below.
> 
> typedef struct xfs_mount {
>  ...
>         struct shrinker         m_inode_shrink; /* inode reclaim shrinker */
> } xfs_mount_t;
> 
> 
> Do you mean xfs can't convert shrinker to shrinker[ZONES]? If so, why?

Well if XFS were to use per-ZONE shrinkers, it would remain with a
single shrinker context per-sb like it has now, but it would divide
its object management into per-zone structures.

For subsystems that aren't important, don't take much memory or have
much reclaim throughput, they are free to ignore the zone argument
and keep using the global input to the shrinker.

