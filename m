Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663Ab0JTDOi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:14:38 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41493 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757510Ab0JTDOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:14:37 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: [patch 31/35] fs: icache per-zone inode LRU
Cc: kosaki.motohiro@jp.fujitsu.com, npiggin@kernel.dk,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <20101019123852.GA12506@dastard>
References: <20101019034658.744504135@kernel.dk> <20101019123852.GA12506@dastard>
Message-Id: <20101020115432.1821.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Oct 2010 12:14:32 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> On Tue, Oct 19, 2010 at 02:42:47PM +1100, npiggin@kernel.dk wrote:
> > Per-zone LRUs and shrinkers for inode cache.
> 
> Regardless of whether this is the right way to scale or not, I don't
> like the fact that this moves the cache LRUs into the memory
> management structures, and expands the use of MM specific structures
> throughout the code. It ties the cache implementation to the current
> VM implementation. That, IMO, goes against all the principle of
> modularisation at the source code level, and it means we have to tie
> all shrinker implemenations to the current internal implementation
> of the VM. I don't think that is wise thing to do because of the
> dependencies and impedance mismatches it introduces.
> 
> As an example: XFS inodes to be reclaimed are simply tagged in a
> radix tree so the shrinker can reclaim inodes in optimal IO order
> rather strict LRU order. It simply does not match a zone-based
> shrinker implementation in any way, shape or form, nor does it's
> inherent parallelism match that of the way shrinkers are called.
> 
> Any change in shrinker infrastructure needs to be able to handle
> these sorts of impedance mismatches between the VM and the cache
> subsystem. The current API doesn't handle this very well, either,
> so it's something that we need to fix so that scalability is easy
> for everyone.
> 
> Anyway, my main point is that tying the LRU and shrinker scaling to
> the implementation of the VM is a one-off solution that doesn't work
> for generic infrastructure. Other subsystems need the same
> large-machine scaling treatment, and there's no way we should be
> tying them all into the struct zone. It needs further abstraction.

I'm not sure what data structure is best. I can only say current
zone unawareness slab shrinker might makes following sad scenario.

 o DMA zone shortage invoke and plenty icache in NORMAL zone dropping
 o NUMA aware system enable zone_reclaim_mode, but shrink_slab() still
   drop unrelated zone's icache

both makes performance degression. In other words, Linux does not have
flat memory model. so, I don't think Nick's basic concept is wrong. 
It's straight forward enhancement. but if it don't fit current shrinkers,
I'd like to discuss how to make better data structure.



and I have dump question (sorry, I don't know xfs at all). current
xfs_mount is below.

typedef struct xfs_mount {
 ...
        struct shrinker         m_inode_shrink; /* inode reclaim shrinker */
} xfs_mount_t;


Do you mean xfs can't convert shrinker to shrinker[ZONES]? If so, why?


Thanks.



