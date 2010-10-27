Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0J0WYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 18:24:51 -0400
Received: from bld-mail13.adl6.internode.on.net ([150.101.137.98]:38991 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754016Ab0J0WYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 18:24:48 -0400
Date: Thu, 28 Oct 2010 09:24:44 +1100
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] fs: Lock the inode LRU list separately
Message-ID: <20101027222444.GC2715@dastard>
References: <1288153384-8878-1-git-send-email-david@fromorbit.com>
 <1288153384-8878-4-git-send-email-david@fromorbit.com>
 <20101027090530.GB16443@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027090530.GB16443@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 27, 2010 at 05:05:30AM -0400, Christoph Hellwig wrote:
> > @@ -537,15 +545,10 @@ void evict_inodes(struct super_block *sb)
> >  		}
> >  
> >  		inode->i_state |= I_FREEING;
> > -		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
> > -			percpu_counter_dec(&nr_inodes_unused);
> > +		inode_lru_list_del(inode);
> >  		spin_unlock(&inode->i_lock);
> >  
> > -		/*
> > -		 * Move the inode off the IO lists and LRU once I_FREEING is
> > -		 * set so that it won't get moved back on there if it is dirty.
> > -		 */
> > -		list_move(&inode->i_lru, &dispose);
> > +		list_add(&inode->i_lru, &dispose);
> >  	}
> >  	spin_unlock(&inode_lock);
> >  
> > @@ -582,15 +585,10 @@ int invalidate_inodes(struct super_block *sb)
> >  		}
> >  
> >  		inode->i_state |= I_FREEING;
> > -		if (!(inode->i_state & (I_DIRTY | I_SYNC)))
> > -			percpu_counter_dec(&nr_inodes_unused);
> > +		inode_lru_list_del(inode);
> >  		spin_unlock(&inode->i_lock);
> 
> with this scheme we now decrement nr_inodes_unused twice - once in
> invalidate_inodes/evict_inodes and once in dispose_one_inode. 

That doesn't happen because the counter is only modified when
the inode is moved on/off the list and there are checks to avoid
removing an inode that is not on the list. Also, the inode is not
removed from the LRU in dispose_one_inode - it is always done when
the inode is marked I_FREEING while the i_lock is held before
calling dispose_one_inode().

Basically I wanted to remove the strange "inode is not on the LRU if
it is dirty or under writeback" accounting checks and make the
accounting symmetric with adding/removing the inodes from the LRU.
These are protected by list_empty() checks, so should always end up
with the correct accounting.

hence the only special case now is prune_icache() which already
holds the inode_lru_lock() so can't call the helper. Besides, we
don't need any checks there because we know the inode is on the LRU
already....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
