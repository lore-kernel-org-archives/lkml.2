Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751978Ab1HQFnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 01:43:52 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:56713 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751145Ab1HQFnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 01:43:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0DAHtRS055LbABgWdsb2JhbABBqFAVAQEWJiWBQAEBBScTHCMQCAMOCi4UJQMhExvBXQ6GOgSkGQ
Date: Wed, 17 Aug 2011 15:43:43 +1000
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH v3 0/4] Per-container dcache limitation
Message-ID: <20110817054343.GM26978@dastard>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313334832-1150-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 07:13:48PM +0400, Glauber Costa wrote:
> Hello,
> 
> This series is just like v2, except it addresses
> Eric's comments regarding percpu variables.
> 
> Let me know if there are further comments, and
> I'll promply address them as well. Otherwise,
> I feel this is ready for inclusion

Just out of couriousity, one thing I've noticed about dentries is
that in general at any given point in time most dentries are unused.
Under the workloads I'm testing, even when I have a million cached
dentries, I only have roughly 7,000 accounted as used.  That is, most
of the dentries in the system are on a LRU and accounted in
sb->s_nr_dentry_unused of their owner superblock.

So rather than introduce a bunch of new infrastructure to track the
number of dentries allocated, why not simply limit the number of
dentries allowed on the LRU? We already track that, and the shrinker
already operates on the LRU, so we don't really need any new
infrastructure.

The limiting can be lazily - we don't need to limit the growth of
dentries until we start to run out of memory. If the superblock
shrinker is aware of the limits, then when it gets called by memory
reclaim it can do all the work of reducing the number of items on
the LRU down to the threshold at that time.

IOWs, the limit has no impact on performance until memory is scarce,
at which time memory reclaim enforces the limits on LRU size and
clean up happens automatically.

This also avoids all the problems of setting a limit lower than the
number of active dentries required for the workload (i.e. avoids
spurious ENOMEM errors trying to allocate dentries), allows
overcommitment when memory is plentiful (which will benefit
performance) but it brings the caches back to defined limits when
memory is not plentiful (which solves the problem you are having).

That seems like a much better solution to me, because it doesn't
impact the normal working of workloads in the containers and avoids
having to work out what the correct minimum size of the cache for
each workload is. It's much easier to work out how many extra cached
dentries you want the container to be able to have when memory is
scarce...

What do you think?

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
