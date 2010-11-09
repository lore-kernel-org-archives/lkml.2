Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559Ab0KIDno (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 22:43:44 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:59685 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab0KIDnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 22:43:42 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEANZR2Ex5LcZK/2dsb2JhbACiG3K8ZoJ8gkwEj2E
Date: Tue, 9 Nov 2010 14:43:35 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: fs: break out inode operations from inode_lock V4
Message-ID: <20101109034334.GA3493@amd>
References: <1288342803-14957-1-git-send-email-david@fromorbit.com>
 <20101029092930.GR19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101029092930.GR19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 29, 2010 at 10:29:30AM +0100, Al Viro wrote:
> On Fri, Oct 29, 2010 at 07:59:55PM +1100, Dave Chinner wrote:
> > Hi Al,
> > 
> > Another update to the inode_lock splitting patch set. It's still
> > based on your merge-stem branch. I'm going to be out all weekend, so
> > any further changes will take a couple of days to turn around.
> > 
> > Version 4:
> > - whitespace cleanup
> > - moved setting state on new inodes till after the hash search fails
> >   in insert_inode_locked
> > - made hash insert operations atomic with state changes by holding
> >   inode->i_lock while doing hash inserts
> > - made inode hash removals atomic with state changes by taking the
> >   inode_lock (later inode_hash_lock) and inode->i_lock. Combined
> >   with the insert changes, this means the inode_unhashed check in
> >   ->drop_inode is safely protected by just holding the
> >   inode->i_lock.
> > - protect inode_unhashed() checks in insert_inode_locked with
> >   inode->i_lock
> 
> The last one is not needed at all; look at what's getting done there - we
> drop that ->i_lock immediately after the check, so it doesn't buy us anything.
> The stuff before that *is* a race fix; namely, the race with BS iget()
> triggered by nfsd.  This check is just verifying that it was a race and not
> a badly confused filesystem.  IOW, no need to lock anything and no _point_
> locking anything.  We are repeating the hash walk anyway; this is just making
> sure that we hadn't run into infinite retries.
> 
> Other than that I'm OK with that set; could you add "lift ->i_lock from
> the beginning of writeback_single_inode()" to the series and post your
> current RCU-for-i_hash patch for review?

Just getting back to this. The RCU for i_hash IMO is stupid and using
SLAB_DESTORY_BY_RCU is way overkill right now.

inode hash lookups aren't that much of a problem. They actually don't
need to be RCU ified at all, and if we end up requiring
SLAB_DESTORY_BY_RCU for inodes to combat regressions, I will possibly
just hold the hash lock over the entire thing to avoid all this
complexity.

BUT, I note that the whole work so far is being driven without getting
any numbers (wheras I had extensively benchmarked it and concluded that
we probably don't need complexity of SLAB_DESTROY_BY_RCU at least for
now).

The most important inode lookup is the dentry->inode lookup, and that
is the only thing that inode really _needs_ to be RCU for, and it gets
significantly ugly trying to do the store free path walk (remember, no
touching inode->i_lock) with SLAB_DESTROY_BY_RCU.

I went over this (with Linus actually), and even hacked up a proof of
concept to do DESTORY_BY_RCU, but we agreed to do the important and
fundamental work first, and then things like DESTROY_BY_RCU would be
optimisations on top of that.

So please NACK for that patch, I'll send you the inode RCU freeing patch
and send Linus some relatively mechanical d_op prototype changes
hopefully that can get merged in this window now that things have
settled down.


> Nick, can you live with the results of that set as an intermediate point
> for merge?  Note that RCU for other lists (sb, wb, lru) is bloody pointless -
> all heavy users are going to modify the lists in question anyway, so we'll
> need exclusion for them.

It's not pointless as such, but it's not a big priority. Once the inode
is RCU freed, if we can do lock free lookups, then there is no reason
not to (at least, with my locking order that made i_lock the big icache
lock, and made RCU lookups easy).

What we gain from that is simply that "normal" state of operations
(usually, insert, delete, etc) do not get bogged down on "unusual"
events (drop_caches, lru scanning, etc). And lock ordering gets
simplified too.

Really, with my lock order design and RCU lookups for the data
structures, you can _always_ reach the inode _before_ touching any
other locks -- this really nicely ties in with big-i_lock approach
to locking (which I'm still going to push for after RCU indoes and
the dcache work are done).

You said that my approach was over engineered, but on the contrary,
the way things are going seems to just have more special cases, more
complexity, and more required transformations. I think it is working
out exactly as I suspected :(

