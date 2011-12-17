Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751129Ab1LQHgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Dec 2011 02:36:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:55582 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab1LQHgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Dec 2011 02:36:10 -0500
Date: Sat, 17 Dec 2011 07:36:04 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Subject: Re: [PATCH 3/4] vfs: count unlinked inodes
Message-ID: <20111217073604.GA31872@ZenIV.linux.org.uk>
References: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
 <1321873893-4544-4-git-send-email-miklos@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321873893-4544-4-git-send-email-miklos@szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 12:11:32PM +0100, Miklos Szeredi wrote:
> @@ -241,6 +242,11 @@ void __destroy_inode(struct inode *inode)
>  	BUG_ON(inode_has_buffers(inode));
>  	security_inode_free(inode);
>  	fsnotify_inode_delete(inode);
> +	if (!inode->i_nlink) {
> +		WARN_ON(atomic_long_read(&inode->i_sb->s_remove_count) == 0);
> +		atomic_long_dec(&inode->i_sb->s_remove_count);
> +	}

Umm...  That relies on ->destroy_inode() doing nothing stupid; granted,
all work on actual file removal should've been done in ->evice_inode()
leaving only (RCU'd) freeing of in-core, but there are odd ones that
do strange things in ->destroy_inode() and I'm not sure that it's not
a Yet Another Remount Race(tm).  OTOH, it's clearly not worse than what
we used to have; just something to keep in mind for future work.

Anyway, I'm mostly OK with that series; I still hate your per-superblock
list of vfsmounts, but at least on top of the vfsmount-guts series they
won't be a temptation for abuse - list goes through struct mount now,
so filesystems won't be able to do fun things like "iterate through all
places where I'm mounted" (and #include "../mounts.h" in any fs code
will be a shootable offense - at least that is easy to spot).

There is another thing I'm less than happy about - suppose you have a
corrupted fs and run into zero on-disk i_nlink.  Sure, the inode will
get immediately evicted and __destroy_inode() will happen; however, for
the duration of that window you end up with bumped ->s_remove_count.
Transient EROFS is annoying, but tolerable - we only hit it if attempt
to remount r/o fails in ->remount_fs().  But this is something different -
it's a transient -EBUSY on attempt to remount r/o happening when nothing
actually is trying to do any kind of write access at all.  As it is,
you have ->s_remove_count equal to the number of in-core inodes with
zero ->i_nlink that had not yet reached destroy_inode().  Hell knows...
Maybe we want two versions of set_nlink(); one doing what yours does,
another returning -EINVAL if asked to set i_nlink to 0.  And assorted
foo_read_inode() would use the latter.  Anyway, that's a separate work;
so's the analysis of what happens if directory entry points to on-disk
inode with zero i_nlink.

Applied, with rebase on top of vfsmount-guts.  Will push the whole pile
into #for-next as soon as I finish sorting out conflicts in btrfs patches
versus btrfs tree.
