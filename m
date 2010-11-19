Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750960Ab0KSFFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 00:05:15 -0500
Received: from ipmail07.adl2.internode.on.net ([150.101.137.131]:7330 "EHLO
	ipmail07.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750730Ab0KSFFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 00:05:13 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEABCU5Ux5LdBa/2dsb2JhbACiVnK9HIVLBI9q
Date: Fri, 19 Nov 2010 16:05:07 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: David Miller <davem@davemloft.net>
Cc: npiggin@kernel.dk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 01/28] fs: d_validate fixes
Message-ID: <20101119050507.GC3284@amd>
References: <20101116140900.039761100@kernel.dk>
 <20101116142028.254946611@kernel.dk>
 <20101118.125123.241932424.davem@davemloft.net>
 <20101118.125913.13739447.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101118.125913.13739447.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 12:59:13PM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Thu, 18 Nov 2010 12:51:23 -0800 (PST)
> 
> > From: Nick Piggin <npiggin@kernel.dk>
> > Date: Wed, 17 Nov 2010 01:09:01 +1100
> > 
> >> d_validate has been broken for a long time.
> >> 
> >> kmem_ptr_validate does not guarantee that a pointer can be dereferenced
> >> if it can go away at any time. Even rcu_read_lock doesn't help, because
> >> the pointer might be queued in RCU callbacks but not executed yet.
> >> 
> >> So the parent cannot be checked, nor the name hashed. The dentry pointer
> >> can not be touched until it can be verified under lock. Hashing simply
> >> cannot be used.
> >> 
> >> Instead, verify the parent/child relationship by traversing parent's
> >> d_child list. It's slow, but only ncpfs and the destaged smbfs care
> >> about it, at this point.
> >> 
> >> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> > 
> > This won't apply because is conflicts with Christoph Hellwig's
> > RCU conversion of d_validate().
> > 
> > Which is a change that went in more than a month ago.
> 
> In fact the conflicts of your patch set are even more pervasive, since
> all dcache hash traversals are essentially RCU protected instead of
> dcache_lock protected right now.

Not sure what you mean there. The patches are against upstream+revert of
the last d_validate patch.

dcache_lock splitup of this series is to split the lock out of all the
other paths, and importantly allow d_lock to protect the complete
dcache state of the dentry.

Next 2 steps (that depend on this series but not on each other) are
fine grained locking of the split locks, and rcu-walk. rcu-walk is what
I called store-free path walking, because we extend RCU not only to the
hash lookup but the entire path walk.

I'll get all that out when I get a bit of time to work on it again.

Thanks,
Nick
