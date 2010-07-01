Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab0GARws (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 13:52:48 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753209Ab0GARwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 13:52:45 -0400
Date: Fri, 2 Jul 2010 03:52:30 +1000
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 00/52] vfs scalability patches updated
Message-ID: <20100701175230.GC1830@laptop>
References: <20100624030212.676457061@suse.de>
 <20100630113054.GL24712@dastard>
 <20100630124049.GH21358@laptop>
 <AANLkTilZHnTiTJRYtYAkAChvAZKy-ZD-7M0y5o3hvRr1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTilZHnTiTJRYtYAkAChvAZKy-ZD-7M0y5o3hvRr1@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 01, 2010 at 10:35:35AM -0700, Linus Torvalds wrote:
> On Wed, Jun 30, 2010 at 5:40 AM, Nick Piggin <npiggin@suse.de> wrote:
> >>
> >> That's a pretty big ouch. Why does RCU freeing of inodes cause that
> >> much regression? The RCU freeing is out of line, so where does the big
> >> impact come from?
> >
> > That comes mostly from inability to reuse the cache-hot inode structure,
> > and the cost to go over the deferred RCU list and free them after they
> > get cache cold.
> 
> I do wonder if this isn't a big design bug.

It's possible, yes. Although a lot of that drop does come from
hitting RCU and overruning slab allocator queues. It was what,
closer to 10% when doing small numbers of creat/unlink loops.

 
> Most of the time with RCU, we don't need to wait to actually do the
> _freeing_ of the individual data structure, we only need to make sure
> that the data structure remains of the same _type_. IOW, we can free
> it (and re-use it), but the backing storage cannot be released to the
> page cache. That's what SLAB_DESTROY_BY_RCU should give us.
> 
> Is that not possible in this situation? Do we really need to keep the
> inode _identity_ around for RCU?
> 
> If you use just SLAB_DESTROY_BY_RCU, then inode re-use remains, and
> cache behavior would be much improved. The usual requirement for
> SLAB_DESTROY_BY_RCU is that you only touch a lock (and perhaps
> re-validate the identity) in the RCU-reader paths. Could that be made
> to work?

I definitely thought of that. I actually thought it would not
be possible with the store-free path walk patches though, because
we need to check some inode properties (eg. permission). So I was
thinking the usual approach of taking a per-entry lock defeats
the whole purpose of store-free path walk.

But you've got me to think about it again and it should be possible to
do just using the dentry seqlock. IOW, if the inode gets disconnected
from the dentry (and then can get possibly freed and reused) then just
retry the lookup.

It may be a little tricky. I'll wait until the path-walk code is
more polished first.

> 
> Because that 27% drop really is pretty distressing.
> 
> That said, open (of the non-creating kind), close, and stat are
> certainly more important than creating and freeing files. So as a
> trade-off, it's probably the right thing to do. But if we can get all
> the improvement _without_ that big downside, that would obviously be
> better yet.

We have actually bigger regressions than that for other code
paths. The RCU freeing for files structs causes similar, about
20-30% regression in open/close.

I actually have a (proper) patch to make that use DESTROY_BY_RCU
too. It actually slows down fd lookup by a tiny bit, though
(lock, load, branch, increment, unlock versus atomic inc). But
same number of atomic ops.

