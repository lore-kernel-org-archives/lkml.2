Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647Ab0ITPT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 11:19:26 -0400
Received: from cantor.suse.de ([195.135.220.2]:48147 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab0ITPTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 11:19:25 -0400
Date: Mon, 20 Sep 2010 17:18:34 +0200
From: Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] BKL: Remove BKL from isofs
Message-ID: <20100920151834.GF3390@quack.suse.cz>
References: <201009161632.59210.arnd@arndb.de>
 <201009172100.06598.arnd@arndb.de>
 <20100920105811.GC3390@quack.suse.cz>
 <201009201313.11526.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <201009201313.11526.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon 20-09-10 13:13:11, Arnd Bergmann wrote:
> On Monday 20 September 2010, Jan Kara wrote:
> >   Hmm, looking through the code, I actually don't see a reason
> > why we should need any per-sb lock at all. The filesystem is always
> > read-only and we don't seem to have any global data structures that
> > change. But that needs some testing I guess - I'll try to do that.
> 
> Ok, great! The BKL was basically as wrong as the global mutex protecting
> the operations anyway, because it does not document what data is
> actually getting protected in any of all the drivers that I'm converting
> to a private mutex.
> 
> Given more time for code inspection and some testing, you can probably
> come up with a good explanation why the BKL is not needed in all those
> places, but since nobody ever bothered to do this for the last decade
> for all these drivers, my approach was to simply prove (in a rather lose
> sense) that I can't make it worse by converting to a mutex.
  Attached is an obvious patch with some reasoning. I've also run for about
half an hour 10 parallel tar processes continuously reading the isofs image
in a loop. In parallel was running an infinite loop with "echo 2
>/proc/sys/vm/drop_caches" so directory entries were constantly reread from
the filesystem. The whole thing was running inside KVM so the fs image was
actually cached in memory. The machine has 8 CPUs so I think reasonable
paralelism has happened and all seemed happy. So I think the patch should
be safe to put into some tree for testing in inclusion...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--bp/iNruPH9dso1Pn
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-isofs-Remove-BKL.patch"

>From 95263e60835707d394f4a4daa6b916737b569f01 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Mon, 20 Sep 2010 15:11:54 +0200
Subject: [PATCH] isofs: Remove BKL

BKL isn't needed for isofs at all so we can just remove it. Generally, since
isofs is always mounted read-only, filesystem structure cannot change under us.
So buffer_head contents stays constant after it's filled in. That leaves us
with possible changes of global data structures. Superblock changes only during
filesystem mount (even remount does not change it), inodes are only filled in
during reading from disk. So there are no changes of these structures to
bother about.

Arguments why BKL can be removed at each place:
isofs_readdir: Accesses sb, inode, filp, local variables => no BKL needed
isofs_put_super: VFS guards us against races with mount (for sb access).
  Otherwise BKL not needed.
isofs_get_blocks: Accesses sb, inode, local variables (filled in buffer heads
  are local) => no BLK needed
isofs_lookup: Protected by directory's i_mutex. Accesses sb, inode, dentry,
  local variables => no BKL needed
rock_ridge_symlink_readpage: Protected by page lock. Accesses sb, inode,
  local variables => no BKL needed.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/isofs/dir.c   |    2 --
 fs/isofs/inode.c |    7 -------
 fs/isofs/namei.c |    3 ---
 fs/isofs/rock.c  |    3 ---
 4 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
index e0aca9a..b29d48e 100644
--- a/fs/isofs/dir.c
+++ b/fs/isofs/dir.c
@@ -260,13 +260,11 @@ static int isofs_readdir(struct file *filp,
 	if (tmpname == NULL)
 		return -ENOMEM;
 
-	lock_kernel();
 	tmpde = (struct iso_directory_record *) (tmpname+1024);
 
 	result = do_isofs_readdir(inode, filp, dirent, filldir, tmpname, tmpde);
 
 	free_page((unsigned long) tmpname);
-	unlock_kernel();
 	return result;
 }
 
diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
index 5a44811..d8a68e7 100644
--- a/fs/isofs/inode.c
+++ b/fs/isofs/inode.c
@@ -44,11 +44,7 @@ static void isofs_put_super(struct super_block *sb)
 	struct isofs_sb_info *sbi = ISOFS_SB(sb);
 
 #ifdef CONFIG_JOLIET
-	lock_kernel();
-
 	unload_nls(sbi->s_nls_iocharset);
-
-	unlock_kernel();
 #endif
 
 	kfree(sbi);
@@ -977,8 +973,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 	int section, rv, error;
 	struct iso_inode_info *ei = ISOFS_I(inode);
 
-	lock_kernel();
-
 	error = -EIO;
 	rv = 0;
 	if (iblock < 0 || iblock != iblock_s) {
@@ -1054,7 +1048,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
 
 	error = 0;
 abort:
-	unlock_kernel();
 	return rv != 0 ? rv : error;
 }
 
diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
index ab438be..c9c7498 100644
--- a/fs/isofs/namei.c
+++ b/fs/isofs/namei.c
@@ -177,7 +177,6 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	if (!page)
 		return ERR_PTR(-ENOMEM);
 
-	lock_kernel();
 	found = isofs_find_entry(dir, dentry,
 				&block, &offset,
 				page_address(page),
@@ -188,10 +187,8 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
 	if (found) {
 		inode = isofs_iget(dir->i_sb, block, offset);
 		if (IS_ERR(inode)) {
-			unlock_kernel();
 			return ERR_CAST(inode);
 		}
 	}
-	unlock_kernel();
 	return d_splice_alias(inode, dentry);
 }
diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
index 96a685c..a679b55 100644
--- a/fs/isofs/rock.c
+++ b/fs/isofs/rock.c
@@ -678,7 +678,6 @@ static int rock_ridge_symlink_readpage(struct file *file, struct page *page)
 
 	init_rock_state(&rs, inode);
 	block = ei->i_iget5_block;
-	lock_kernel();
 	bh = sb_bread(inode->i_sb, block);
 	if (!bh)
 		goto out_noread;
@@ -748,7 +747,6 @@ repeat:
 		goto fail;
 	brelse(bh);
 	*rpnt = '\0';
-	unlock_kernel();
 	SetPageUptodate(page);
 	kunmap(page);
 	unlock_page(page);
@@ -765,7 +763,6 @@ out_bad_span:
 	printk("symlink spans iso9660 blocks\n");
 fail:
 	brelse(bh);
-	unlock_kernel();
 error:
 	SetPageError(page);
 	kunmap(page);
-- 
1.6.4.2


--bp/iNruPH9dso1Pn--
