Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0KIVzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:55:10 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:47488 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754832Ab0KIVzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:55:06 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFpR2Ux5LcZK/2dsb2JhbACiJ3K9bYVKBA
Date: Wed, 10 Nov 2010 08:55:00 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Dumazet <eric.dumazet@gmail.com>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [patch 1/6] fs: icache RCU free inodes
Message-ID: <20101109215500.GD3246@amd>
References: <20101109124610.GB11477@amd>
 <AANLkTi=b3dEmoTgrJ2xMTUzgM-mUQNNx6J9jeLq2=mtf@mail.gmail.com>
 <1289319698.2774.16.camel@edumazet-laptop>
 <AANLkTimJCgsPqB9ihbScr1RdZ+XGk2tq7LZNfh109Skv@mail.gmail.com>
 <20101109171522.GA4522@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101109171522.GA4522@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 12:15:22PM -0500, Christoph Hellwig wrote:
> On Tue, Nov 09, 2010 at 09:08:17AM -0800, Linus Torvalds wrote:
> > Again, this is only an issue for non-dentry lookup. For the dentry
> > case, we know that if the dentry still exists, then the inode still
> > exists. So we don't need to check a stable inode pointer if we just
> > verify the stability of the dentry - and we'll have to do that anyway
> > obviously.
> 
> If the dentry still exists we have a reference on the inode and never
> call into the inode hash.

That would be nice. Unfortuately I don't know if the dentry still
exists.


> > In other words: let's bite off the complexity in small chunks. Let's
> > keep the inode lock approach for now for the actual inode lists and
> > hash lookups. I think they are almost entirely independent issues from
> > the dentry path.
> 
> I'm defintively in favour of splitting things into small chunks.  I
> don't particularly care how we do it.  inode_lock scaling seems the
> most simple bit to me, and even that turned out to be a massive
> amount of work to do properly.

That is because the locking model was made much more complex and less
regular than it needed to be. If you have a model where i_lock ==
inode_lock for the context of that inode, it's simple and restructuring
the code can happen _in parallel_ rather than with dependencies on the
inode locking.

The several inode data structures are *trivial*. Simple structures,
trivial operations to insert/remove/lookup. The *hard* part is locking
the actual inode itself and ensuring it is not subject to unwanted
concurrency. If you make i_lock exclude everything withot exception,
then it's not hard to verify it.

> Doing the dentry_lock splitup last starts to look more and more
> interesting given how messy inode_lock is, though.

It's not actually, if the locking is done right. And it will need to
be this time because yes it is more complex than icache, so ad hoc
approach won't work.

