Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab0JXCS0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 22:18:26 -0400
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:39351 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439Ab0JXCSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 22:18:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEADc0w0x5Ldx0/2dsb2JhbAChbXK6OYJ2glIEj1E
Date: Sun, 24 Oct 2010 13:18:15 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Dave Chinner <david@fromorbit.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101024021815.GA4820@amd>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022031431.GK12506@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 02:14:31PM +1100, Dave Chinner wrote:
> AFAICT, moving the inode_lru_lock inside i_lock doesn't affect the
> locking order of anything else, and I agree that putting a single
> trylock in the prune_icache loop is definitely cleaner than anything
> else I've been able to think of that retains the current locking
> order. It will also remove the wart in sync_inode().
> 
> So, I'll swallow my rhetoric and agree with you that inode_lru_lock
> inside the i_lock is the natural and easiest way to nest these
> locks. I'll rework the series to do this. 

I don't know what's so unclean or wrong about the locking order.  I'm
still leaning much further than Al as to putting locks inside i_lock.

With inode-rcu, we _always_ arrive at the inode _first_, before taking
_any_ other locks (because we either come in via an external reference,
or we can find the inode from any of the data structures using RCU
rather than taking their locks).

[The exception is hash insertion uniqueness enforcement, because we have
 no inode to lock, by definition. But in that case we're OK because the
 new inode we're about to insert has no concurrency on its i_lock so that
 can be initialised locked.]

So what we have is an inode, which we need to do stuff to. That stuff
involves moving it on or off data structures, and updating its refcount
and state, etc.

That suggests the i_lock -> data-structure-lock locking order.

And look at the flexibility -- I could implement that without changing
any other code or ordering in the icache. Sure you can reorder things
around to cope with different locking strategies, but I'm not actually
given a good reason _why_ i_lock first is not the "natural" ordering.
Doing that means we simply don't _need_ to change any ordering or
concurrency rules (although it doesn't prevent changes).

