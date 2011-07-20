Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751934Ab1GTWAQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:00:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52704 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab1GTWAO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:00:14 -0400
Date: Thu, 21 Jul 2011 00:00:12 +0200
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Curt Wohlgemuth <curtw@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, fengguang.wu@intel.com
Subject: Re: [PATCH] writeback: Don't wait for completion in
 writeback_inodes_sb_nr
Message-ID: <20110720220012.GA23529@quack.suse.cz>
References: <20110629191518.GA23196@quack.suse.cz>
 <BANLkTinndb4oHi6kNQrTsL86UrKDB=2rK6-gA8FM1Nj8CKYZ+w@mail.gmail.com>
 <20110711170042.GE5482@quack.suse.cz>
 <CAO81RMairX_L5qGOcKKpw7gWdcTd2Y+5NL=+BA9EwTCNLCNmLw@mail.gmail.com>
 <20110711194835.GI5482@quack.suse.cz>
 <20110711201157.GA21460@infradead.org>
 <20110712103453.GC31226@quack.suse.cz>
 <20110712104132.GA14189@infradead.org>
 <20110712223715.GC13656@quack.suse.cz>
 <20110719165149.GA11540@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719165149.GA11540@infradead.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 19-07-11 12:51:49, Christoph Hellwig wrote:
> On Wed, Jul 13, 2011 at 12:37:15AM +0200, Jan Kara wrote:
> > -static int __sync_filesystem(struct super_block *sb, int wait)
> > +static void __sync_filesystem(struct super_block *sb, int wait)
> >  {
> > -	/*
> > -	 * This should be safe, as we require bdi backing to actually
> > -	 * write out data in the first place
> > -	 */
> > -	if (sb->s_bdi == &noop_backing_dev_info)
> > -		return 0;
> > -
> >  	if (sb->s_qcop && sb->s_qcop->quota_sync)
> >  		sb->s_qcop->quota_sync(sb, -1, wait);
> >  
> > @@ -47,7 +40,6 @@ static int __sync_filesystem(struct super_block *sb, int wait)
> >  
> >  	if (sb->s_op->sync_fs)
> >  		sb->s_op->sync_fs(sb, wait);
> > -	return __sync_blockdev(sb->s_bdev, wait);
> 
> Removing this call breaks sys_syncfs and similar semantics on filesystem
> just pushing metadata into buffers in ->write_inode or ->sync_fs and
> then expecting the caller to write them out.  This list of filesystem
> includes ext2 and in general most filesystems without journaling or
> similar technics.
  Note that for sys_syncfs() the __sync_blockdev() has just moved from
__sync_filesystem() to sync_filesystem(). So nothing should change.

> I'm perfectly fine with pushing the sync_blockdev call into the
> filesystem for these, but we'll need a way to handle them.
  Yes, calling sync_blockdev() from sync_fs() might actually make sence
(e.g. ext3 and ext4 don't need it) but I didn't want to go that far in
this patch.

> > +	/*
> > +	 * This should be safe, as we require bdi backing to actually
> > +	 * write out data in the first place.
> > +	 */
> > +	if (sb->s_bdi == &noop_backing_dev_info)
> > +		return 0;
> 
> There's really no reason to do that check early.  There's nothing
> no reason to not have a filesystem that doesn't use the writeback
> code, but still has a ->sync_fs method.  IMHO this check should
> move into sync_inodes_sb/writeback_inodes_sb.
  OK, will change.

> > +static void sync_all_bdevs(int wait)
> > +{
> > +	struct inode *inode, *old_inode = NULL;
> > +
> > +	spin_lock(&inode_sb_list_lock);
> > +	list_for_each_entry(inode, &blockdev_superblock->s_inodes, i_sb_list) {
> > +		struct address_space *mapping = inode->i_mapping;
> > +
> > +		spin_lock(&inode->i_lock);
> > +		if (inode->i_state & (I_FREEING|I_WILL_FREE|I_NEW) ||
> > +		    mapping->nrpages == 0) {
> > +			spin_unlock(&inode->i_lock);
> > +			continue;
> > +		}
> > +		__iget(inode);
> > +		spin_unlock(&inode->i_lock);
> > +		spin_unlock(&inode_sb_list_lock);
> > +		/*
> > +		 * We hold a reference to 'inode' so it couldn't have been
> > +		 * removed from s_inodes list while we dropped the
> > +		 * inode_sb_list_lock.  We cannot iput the inode now as we can
> > +		 * be holding the last reference and we cannot iput it under
> > +		 * inode_sb_list_lock. So we keep the reference and iput it
> > +		 * later.
> > +		 */
> > +		iput(old_inode);
> > +		old_inode = inode;
> > +
> > +		__sync_blockdev(I_BDEV(inode), wait);
> > +
> > +		spin_lock(&inode_sb_list_lock);
> > +	}
> > +	spin_unlock(&inode_sb_list_lock);
> > +	iput(old_inode);
> 
> At which point we could fold this code into a blkdev_sync_fs method for
> now.  Long term we'll need to support multiple BDIs per SB anyway, at
> which point the code can go away again.
  Ah, I had to think a bit before I understood what you mean :). It's kind
of elegant but also slightly subtle (it's not immediately obvious how
blockdevs are synced during sync when you look at the code). Umm, and you
don't have any guarantee in which order superblocks are on the sb list so
you could sync block devices before some filesystems are finished. So I
don't think using blkdev_sync_fs() is a good idea after all.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
