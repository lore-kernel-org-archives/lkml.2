Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab0KIRJT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:09:19 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49592 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752122Ab0KIRJQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:09:16 -0500
MIME-Version: 1.0
In-Reply-To: <1289319698.2774.16.camel@edumazet-laptop>
References: <20101109124610.GB11477@amd> <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 9 Nov 2010 09:08:17 -0800
Message-ID: <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
Subject: Re: [patch 1/6] fs: icache RCU free inodes
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 9, 2010 at 8:21 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> You can see problems using this fancy thing :
>
> - Need to use slab ctor() to not overwrite some sensitive fields of
> reused inodes.
>  (spinlock, next pointer)

Yes, the downside of using SLAB_DESTROY_BY_RCU is that you really
cannot initialize some fields in the allocation path, because they may
end up being still used while allocating a new (well, re-used) entry.

However, I think that in the long run we pretty much _have_ to do that
anyway, because the "free each inode separately with RCU" is a real
overhead (Nick reports 10-20% cost). So it just makes my skin crawl to
go that way. And I think SLAB_DESTROY_BY_RCU is the "normal" way to do
these kinds of things anyway, so I actually think it's "simpler", if
only because it's the common pattern.

(Put another way: it might not be less code, and it might have its own
subtle issues, but they are _shared_ subtle issues with all the other
SLAB_DESTROY_BY_RCU users, so we hopefully have a better understanding
of them)

> - Fancy algo to detect an inode moved from one chain to another. Lookups
> should be able to detect and restart their loop.

So this is where I think we should just use locks unless we have hard
numbers to say that being clever is worth it.

I do realize that some loads look up inodes directly, but at the same
time I really think that we should absolutely target the whole "RCU
path lookup" first. And that one has no inode lookup at all, it's just
a dentry->d_inode pointer derefeence.

So let's not mix in NFSD loads into the discussion yet - it's a
separate thing, and if we want to make that whole code use RCU later,
that's fine. But let's really keep it "later", because it's not
_nearly_ as important as the path walking.

> - After a match, need to get a stable reference on inode (lock), then
> recheck the keys to make sure the target inode is the right one.

Again, this is only an issue for non-dentry lookup. For the dentry
case, we know that if the dentry still exists, then the inode still
exists. So we don't need to check a stable inode pointer if we just
verify the stability of the dentry - and we'll have to do that anyway
obviously.

So I really think that the dentry lookup is the thing that should
primarily drive this. And that will not in any way preclude us from
looking at the non-dentry case _later_, and worrying about the details
there at some later date.

In other words: let's bite off the complexity in small chunks. Let's
keep the inode lock approach for now for the actual inode lists and
hash lookups. I think they are almost entirely independent issues from
the dentry path.

                     Linus
