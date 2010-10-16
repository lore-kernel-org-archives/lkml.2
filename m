Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753358Ab0JPRzV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 13:55:21 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:31920 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752673Ab0JPRzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 13:55:20 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmQEAD+BuUx5LcB2gWdsb2JhbAChMBYBARYiIsBrhUkE
Date: Sun, 17 Oct 2010 04:55:15 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Inode Lock Scalability V4
Message-ID: <20101016175515.GA6868@amd>
References: <1287216853-17634-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287216853-17634-1-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 07:13:54PM +1100, Dave Chinner wrote:
> Version 2 of this series is a complete rework of the original patch
> series.  Nick's original code nested list locks inside the the
> inode->i_lock, resulting in a large mess of trylock operations to
> get locks out of order all over the place. In many cases, the reason
> fo this lock ordering is removed later on in Nick's series as
> cleanups are introduced.

I think you must misunderstand how my patchset is structured. It is not
that it was simply thrown together with cleanups piled on top of crap as
I discovered new ways to fix trylocks.

It is structured so that for the first steps, each (semi-)independent
aspect of inode_lock's concurrency protection is taken over by a new
lock. I've just made these locks dumb globals for simplicity at this
point.

Often, the required locking of these different aspects of the icache
overlap. Also inode_lock remains in place until the end. This makes lock
ordering get ugly.

But the point is that once we get past the trylocks and actually have
the locks held, it is relatively easy to demonstrate that the protection
provided is exactly what inode_lock provided.

After inode_lock is removed, I start to scale the locks properly and
introduce more complicated transforms to the code to improve the
locking. I really like how I split it up.

In your patch set you've basically pulled all these steps into the
inode_lock splitting itself. This is my first big objection.

Second I actually prefer how I cover all the icache state of an inode
with i_lock. You have avoided some coverage in the interest of reducing
lock ordering complexity, but as I have demonstrated RCU tends to work
as well for this too (and is mostly all solved in the second half of my
series).


> This patch set is just the basic inode_lock breakup patches plus a
> few more simple changes to the inode code. It stops short of
> introducing RCU inode freeing because those changes are not
> completely baked yet.

It also doesn't contain per-zone locking and lrus, or scalability of
superblock list locking.

And while the rcu-walk path walking is not fully baked, it has been
reviewed by Linus and is in pretty good shape. So I prefer to utilise
RCU locking here too, seeing as we know it will go in.

I much prefer to fix all of the problematic global locks in icache up
front and do the icache merge in a single release so we don't have
locking changes there stringing out over several releases.

