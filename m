Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758424Ab2CUAoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 20:44:44 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:7190 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757105Ab2CUAon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 20:44:43 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAKIjaU95LbP2/2dsb2JhbABEtm+BCIIJAQEEATocIwULCAMOCi4UJQMhE4gFBLcgE5BuBJVdkCiCe4FCFw
Date: Wed, 21 Mar 2012 11:44:39 +1100
From: Dave Chinner <david@fromorbit.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/11] XFS: Fix lock ASSERT on UP
Message-ID: <20120321004439.GU5091@dastard>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
 <1331924464-18023-6-git-send-email-andi@firstfloor.org>
 <20120319224753.GC3592@dastard>
 <20120320022812.GA30406@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120320022812.GA30406@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 07:28:12PM -0700, Andi Kleen wrote:
> > So this means we only ever check that the spinlock is held when
> > lockdep is turned on instead of whenever CONFIG_XFS_DEBUG is set?
> 
> You should regularly test with lockdep anyways.

I do. Once or twice a release cycle I'll do a test cycle with
lockdep enabled. i don't use it on day-to-day tst cycles because of
it's overhead, and well, I understand the lock ordering of most of
the code I'm modifying....

> If you don't you clearly
> have a testing gap. lockdep is likely to find many more locking bugs
> than any of your very sparse manual annotations.

That's not true. Lockdep validates lock order but it doesn't find
race conditions. Nor does lockdep tell us that the correct lock is
held when entering the function. Nor does it tell us that the state
of a RCU freed object is correct when it is reallocated out of the
kmem_cache it belongs to. These things need manual annotations, and
they find more problems during development than lockdep does.

Not to mention that we have to annotate our read/write locks with
extra state when CONFIG_XFS_DEBUG is enabled to ensure that the lock
mode is correct because rwsems can't tell us the difference between
a read hold and a write hold.

Hell, we only check the inode lock state in about 40 different
locations via xfs_isilocked(), but many of these locations have
multiple callers. e.g.  there's a check in xfs_trans_ijoin(), and it
has about 60 callers.  So the "very sparse manual annotations" for
locking behaviour in XFS are far more comprehensive than you claim
and catch many more problems early in development under
CONFIG_XFS_DEBUG than lockdep is even aware exists....

> > That means it will rarely get checked during development instead of
> > all the time. That's not an improvement IMO....
> 
> It's an improvement that an !CONFIG_SMP && CONFIG_XFS_DEBUG kernel
> will not blow up anymore.

<shrug>

Whatever, it's not worth arguing over. There's only two places that
XFS uses spin_is_locked(), and there are other checks around it that
will catch the same race conditions with CONFIG_XFS_DEBUG enabled,
so go ahead and use lockdep for them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
