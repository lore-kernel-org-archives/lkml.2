Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0JNJNJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 05:13:09 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:36827 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755009Ab0JNJNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 05:13:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEALZmtkx5Lc/f/2dsb2JhbAChInK7Q4VIBI9A
Date: Thu, 14 Oct 2010 20:13:01 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Nick Piggin <npiggin@kernel.dk>
Cc: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101014091301.GC3144@amd>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
 <20101013072058.GA3121@amd>
 <20101013112552.GB16422@infradead.org>
 <20101013123008.GA6067@amd>
 <20101013232319.GZ4681@dastard>
 <20101014090609.GB3144@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101014090609.GB3144@amd>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 08:06:09PM +1100, Nick Piggin wrote:
> On Thu, Oct 14, 2010 at 10:23:19AM +1100, Dave Chinner wrote:

> Shrinker and zone reclaim is definitely needed. It is needed for NUMA
> scalability and locality of reclaim, and also for container and directed
> dentry/inode reclaim. Google have a very similar patch and they've said
> this is needed (and I already know it is needed for scalability on
> large NUMA -- SGI were complaining about this nearly 5 years ago IIRC).
> So that is _definitely_ going to be needed.
> 
> Store-free path walking is definitely needed, so we need to do RCU inodes.
> With RCU inodes, the optimal locking protocols change quite a bit --

[...]
 
> It's much past a prototype. While the patches need some more cleanup
> and review still, the final end result gives a tree with almost no
> global cachelines in the entire vfs, including path walking. Things
> like path walks are nearly 50% faster single threaded, and perfectly
> scalable. Linus actually wants the store-free path walk stuff
> _before_ any of the other things, if that gives you an idea of where
> other people are putting the priority of the patches.

With this said, I think you're probably not quite aware of the bigger
picture with the vfs-scale series. Yes it will be important to help
your XFS inode contention, but there are many other people having other
problems, and other big improvements that will benefit desktops and
more common workloads than big-IO ones in the series.

So yes I'll definitely keep the vfs-scale series together. Most of the
inode scaling work is at the bottom of it and should be able to go in
soon. But for example, the inode RCU work is going to go in -- Linus
has acked my strategy for it (and plan for mitigating/avoiding possible
regressions if needed). So with that, it makes more sense to design
the locking with the RCU available.

If we _know_ it will be needed in future anyway, it doesn't make sense
to a different non-RCU approach, and then rework that again down the
line IMO. That just gives a larger burden of locking models that need
to be supported/debugged.

Ditto for other things like per zone locking.

