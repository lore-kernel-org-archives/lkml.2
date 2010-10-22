Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0JVDOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 23:14:36 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:53850 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752018Ab0JVDOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 23:14:35 -0400
Date: Fri, 22 Oct 2010 14:14:31 +1100
From: Dave Chinner <david@fromorbit.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101022031431.GK12506@dastard>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022015622.GE19804@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 02:56:22AM +0100, Al Viro wrote:
> On Thu, Oct 21, 2010 at 11:49:41AM +1100, Dave Chinner wrote:
> > From: Dave Chinner <dchinner@redhat.com>
> > 
> > We currently protect the per-inode state flags with the inode_lock.
> > Using a global lock to protect per-object state is overkill when we
> > coul duse a per-inode lock to protect the state.  Use the
> > inode->i_lock for this, and wrap all the state changes and checks
> > with the inode->i_lock.
> 
> > @@ -1424,22 +1449,30 @@ static void iput_final(struct inode *inode)
> >  	if (!drop) {
> >  		if (sb->s_flags & MS_ACTIVE) {
> >  			inode->i_state |= I_REFERENCED;
> > -			if (!(inode->i_state & (I_DIRTY|I_SYNC)))
> > +			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
> > +			    list_empty(&inode->i_lru)) {
> > +				spin_unlock(&inode->i_lock);
> >  				inode_lru_list_add(inode);
> > +				return;
> 
> Sorry, that's broken.  Leaving aside leaking inode_lock here (you remove
> taking it later anyway), this is racy.
> 
> Look: inode is hashed.  It's alive and well.  It just has no references outside
> of the lists.  Right?  Now, what's to stop another CPU from
> 	a) looking it up in icache
> 	b) doing unlink()
> 	c) dropping the last reference
> 	d) freeing the sucker
> ... just as you are about to call inode_lru_list_add() here?

Nothing - I hadn't considered that as a potential inode freeing
race window, so my assumption that it was OK to do this is wrong. It
definitely needs fixing.

> For paths in iput() where we do set I_FREEING/I_WILL_FREE it's perfectly
> fine to drop all locks once that's done.  Inode is ours, nobody will pick
> it and we are free to do as we wish.

Yes, I knew that bit - I went wrong making the same assumptions
through the unused path.

> For the path that leaves the inode alive and hashed - sorry, can't do.
> AFAICS, unlike hash, wb and sb locks, lru lock should nest *inside*
> ->i_lock.  And yes, it means trylock in prune_icache(), with "put it in
> the end of the list for one more spin" if we fail.  In that case it's
> really cleaner that way.

I left it outside i_lock to be consistent with all the new
locks being introduced. fs/fs-writeback.c::sync_inode() has a
similar inode life-time wart when adding clean inodes to the lru
which I was never really happy about. I suspect it has similar
problems.

I had a bit of a think about playing refcounting games to avoid
doing the LRU add without holding the i_lock (to avoid the above
freeing problem), but that ends up with more complex and messy iput/
iput_final interactions.  Likewise, adding trylocks into the lru
list add sites is doesn't solve the inode-goes-away-after-i_lock-
is-dropped problems.  A couple of other ideas I had also drowned in
complexity at birth.

AFAICT, moving the inode_lru_lock inside i_lock doesn't affect the
locking order of anything else, and I agree that putting a single
trylock in the prune_icache loop is definitely cleaner than anything
else I've been able to think of that retains the current locking
order. It will also remove the wart in sync_inode().

So, I'll swallow my rhetoric and agree with you that inode_lru_lock
inside the i_lock is the natural and easiest way to nest these
locks. I'll rework the series to do this. 

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
