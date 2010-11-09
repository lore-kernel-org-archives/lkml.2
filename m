Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab0KIWFS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:05:18 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:22630 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755006Ab0KIWFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:05:14 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANJU2Ux5LcZK/2dsb2JhbACiJnK9RYVKBJBQ
Date: Wed, 10 Nov 2010 09:05:06 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109220506.GE3246@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:08:17AM -0800, Linus Torvalds wrote:
> On Tue, Nov 9, 2010 at 8:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> > You can see problems using this fancy thing :
> >
> > - Need to use slab ctor() to not overwrite some sensitive fields of
> > reused inodes.
> >  (spinlock, next pointer)
> 
> Yes, the downside of using SLAB_DESTROY_BY_RCU is that you really
> cannot initialize some fields in the allocation path, because they may
> end up being still used while allocating a new (well, re-used) entry.
> 
> However, I think that in the long run we pretty much _have_ to do that
> anyway, because the "free each inode separately with RCU" is a real
> overhead (Nick reports 10-20% cost). So it just makes my skin crawl to
> go that way.

This is a creat/unlink loop on a tmpfs filesystem. Any real filesystem
is going to be *much* heavier in creat/unlink (so that 10-20% cost would
look more like a few %), and any real workload is going to have much
less intensive pattern.

Much of the performance hit comes from draining the allocator's queues
and going into slow paths there, the remainder is due to cache coldness
of the new objects being allocated, and rcu queueing.

But if you allocate and free in larger batches, RCU and non-RCU have
the same biggest problem of draining slab queues and getting cache
cold objects.

So that remaining few % I suspect goes down to a few points of a %.

Anyway, I actually have tried to measure a regression on slightly more
realistic inode heavy workloads like fs_mark, and couldn't measure any.
On the flip side, I could measure huge improvements with rcu-walk, so
I think it is a valid tradeoff, with an eye to having a few fallback
plans if we really need them.


> And I think SLAB_DESTROY_BY_RCU is the "normal" way to do
> these kinds of things anyway, so I actually think it's "simpler", if
> only because it's the common pattern.
> 
> (Put another way: it might not be less code, and it might have its own
> subtle issues, but they are _shared_ subtle issues with all the other
> SLAB_DESTROY_BY_RCU users, so we hopefully have a better understanding
> of them)
> 
> > - Fancy algo to detect an inode moved from one chain to another. Lookups
> > should be able to detect and restart their loop.
> 
> So this is where I think we should just use locks unless we have hard
> numbers to say that being clever is worth it.

Yeah, it's really not a bit deal.


> > - After a match, need to get a stable reference on inode (lock), then
> > recheck the keys to make sure the target inode is the right one.
> 
> Again, this is only an issue for non-dentry lookup. For the dentry
> case, we know that if the dentry still exists, then the inode still
> exists. So we don't need to check a stable inode pointer if we just
> verify the stability of the dentry - and we'll have to do that anyway
> obviously.

With rcu-walk, we don't know that a dentry still exists -- we can't
store anything to it to pin it. I come back and verify after the
fact that it hasn't changed or gone away, and that enables us to know
that the inode has not gone away too.

But in the intermediate stage of doing access verification on the inode,
it really sucks if it suddenly comes back as something else. Not saying
it is impossible, but the traditional easy model of "lock, re-check" for
DESTROY_BY_RCU does not work with rcu-walk. Believe me I've looked at
doing it.


