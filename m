Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab0JPHzC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 03:55:02 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:3752 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753210Ab0JPHzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 03:55:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAFP1uEx5LcB2/2dsb2JhbAChMXK8eIVJBA
Date: Sat, 16 Oct 2010 18:54:57 +1100
From: Nick Piggin <npiggin@kernel.dk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] fs: Implement lazy LRU updates for inodes.
Message-ID: <20101016075457.GF19147@amd>
References: <1285762729-17928-1-git-send-email-david@fromorbit.com>
 <1285762729-17928-14-git-send-email-david@fromorbit.com>
 <20100930020517.GB1535@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100930020517.GB1535@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:05:17PM -0400, Christoph Hellwig wrote:
> > @@ -1058,8 +1051,6 @@ static void wait_sb_inodes(struct super_block *sb)
> >  	 */
> >  	WARN_ON(!rwsem_is_locked(&sb->s_umount));
> >  
> > -	spin_lock(&sb_inode_list_lock);
> > -
> >  	/*
> >  	 * Data integrity sync. Must wait for all pages under writeback,
> >  	 * because there may have been pages dirtied before our sync
> > @@ -1067,6 +1058,7 @@ static void wait_sb_inodes(struct super_block *sb)
> >  	 * In which case, the inode may not be on the dirty list, but
> >  	 * we still have to wait for that writeout.
> >  	 */
> > +	spin_lock(&sb_inode_list_lock);
> 
> I think this should be folded back into the patch introducing
> sb_inode_list_lock.
> 
> > @@ -1083,10 +1075,10 @@ static void wait_sb_inodes(struct super_block *sb)
> >  		spin_unlock(&sb_inode_list_lock);
> >  		/*
> >  		 * We hold a reference to 'inode' so it couldn't have been
> > -		 * removed from s_inodes list while we dropped the
> > -		 * sb_inode_list_lock.  We cannot iput the inode now as we can
> > -		 * be holding the last reference and we cannot iput it under
> > -		 * spinlock. So we keep the reference and iput it later.
> > +		 * removed from s_inodes list while we dropped the i_lock.  We
> > +		 * cannot iput the inode now as we can be holding the last
> > +		 * reference and we cannot iput it under spinlock. So we keep
> > +		 * the reference and iput it later.
> 
> This also looks like a hunk that got in by accident and should be merged
> into an earlier patch.

These two actually came from a patch to do rcu locking (which Dave has
changed a bit, but originally due to my fault), so I'll fix those, thanks.

 
> > @@ -431,11 +412,12 @@ static int invalidate_list(struct list_head *head, struct list_head *dispose)
> >  		invalidate_inode_buffers(inode);
> >  		if (!inode->i_count) {
> >  			spin_lock(&wb_inode_list_lock);
> > -			list_move(&inode->i_list, dispose);
> > +			list_del(&inode->i_list);
> >  			spin_unlock(&wb_inode_list_lock);
> >  			WARN_ON(inode->i_state & I_NEW);
> >  			inode->i_state |= I_FREEING;
> >  			spin_unlock(&inode->i_lock);
> > +			list_add(&inode->i_list, dispose);
> 
> Moving the list_add out of the lock looks fine, but I can't really
> see how it's related to the rest of the patch.

Just helps shows that dispose isn't being protected by
wb_inode_list_lock, I guess.

> 
> > +		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
> > +			list_del_init(&inode->i_list);
> > +			spin_unlock(&inode->i_lock);
> > +			atomic_dec(&inodes_stat.nr_unused);
> > +			continue;
> > +		}
> > +		if (inode->i_state) {
> 
> Slightly confusing but okay given the only i_state that will get us here
> is I_REFERENCED.  Do we really care about the additional cycle or two a
> dumb compiler might generate when writing
> 
> 	if (inode->i_state & I_REFERENCED)

Sure, why not.

> 
> ?
> 
> >  		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
> > +			list_move(&inode->i_list, &inode_unused);
> 
> Why are we now moving the inode to the front of the list? 

It was always being moved to the front of the list, but with lazy LRU,
iput_final doesn't move it for us, hence the list_move here.

Without this, it busy-spins and locks badly under heavy reclaim load
when buffers or pagecache can't be invalidated.

Seeing as it wasn't obvious to you, I'll add a comment here.

I was thinking we should probably have a shortcut to go back to the
tail of the LRU in case of invalidation success, but that's out of the
scope of this patch and I never got around to testing such a change
yet.

