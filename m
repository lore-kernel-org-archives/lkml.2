Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0KIVo2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:44:28 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:14634 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752278Ab0KIVoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:44:25 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAMtN2Ux5LcZK/2dsb2JhbACiJ3K+AoVKBA
Date: Wed, 10 Nov 2010 08:44:20 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109214420.GB3246@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 08:02:38AM -0800, Linus Torvalds wrote:
> On Tue, Nov 9, 2010 at 4:46 AM, Nick Piggin <npiggin@kernel.dk> wrote:
> > So here is the inode RCU code. It's obviously not worth doing until the
> > actual rcu-walk path walking is in, but I'd like to get opinions on it.
> > It would be nice to merge it in Al's tree at some point, though.
> 
> Remind me why it wasn't sufficient to just use SLAB_DESTROY_BY_RCU?
> 
> Especially if we still lock things for the actual (few) inode list
> operations, the added complexity of actually freeing _individual_
> inodes by RCU seems to be a bad thing.

Oh yes, the list operations themselves do not need RCU at all. Not
even rapid hash lookups if you have fine grained hash locking --
it just doesn't matter.


> The only thing we care about is the pathname walk - there are no other
> inode operations that are common enough to worry about. And the only
> thing _that_ needs is the ability to look at the inode under RCU, and
> SLAB_DESTROY_BY_RCU should be entirely sufficient for that.
> 
> But we had some discussion about this long ago, and I may have
> forgotten some of the context.

Yes, dentry->inode resolution is *the* only inode lookup we really
care about, definitely.

The big problem with SLAB_DESTROY_BY_RCU there is that we don't
have a reference on the dentry, so inode can go away. And we don't
have anything to speculatively pin the inode and recheck it, because
we're not allowed to store into it.

When we *do* have an inode, it's really hairy inspecting the inode and
calling i_ops etc. with no idea if it is there, in the middle of
being freed, or allocated for someone else.

What the plan was is to do the plain RCU approach, and get everybody
happy with the concept of rcu-walk path walking (which is already
enough complexity). At the _very_ worst case that DESTROY_BY_RCU
must be implemented and no other viable alternatives, we can use
i_lock for that. It takes away some benefit, but there would still
be much fewer atomics and less contention on common paths.

But I don't think RCU is actually going to hurt noticably. Definitely
we need numbers before committing to such complexity off the bat.

