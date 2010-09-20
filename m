Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756104Ab0ITK7E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 06:59:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:38584 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570Ab0ITK7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 06:59:03 -0400
Date: Mon, 20 Sep 2010 12:58:11 +0200
From: Jan Kara <jack@suse.cz>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] BKL: Remove BKL from isofs
Message-ID: <20100920105811.GC3390@quack.suse.cz>
References: <201009161632.59210.arnd@arndb.de>
 <20100917140219.GA9454@infradead.org>
 <201009171656.56615.arnd@arndb.de>
 <201009172100.06598.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009172100.06598.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-09-10 21:00:06, Arnd Bergmann wrote:
> As in other file systems, we can replace the big kernel lock
> with a private mutex in isofs. This means we can now access
> multiple file systems concurrently, but it also means that
> we serialize readdir and lookup across sleeping operations
> which previously released the big kernel lock. This should
> not matter though, as these operations are in practice
> serialized through the hardware access.
> 
> The isofs_get_blocks functions now does not take any lock
> any more, it used to recursively get the BKL. After looking
> at the code for hours, I convinced myself that it was never
> needed here anyway, because it only reads constant fields
> of the inode and writes to a buffer head array that is
> at this time only visible to the caller.
> 
> The get_sb and fill_super operations do not need the locking
> at all because they operate on a file system that is either
> about to be created or to be destroyed but in either case
> is not visible to other threads.
  Hmm, looking through the code, I actually don't see a reason
why we should need any per-sb lock at all. The filesystem is always
read-only and we don't seem to have any global data structures that
change. But that needs some testing I guess - I'll try to do that.

								Honza
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
> 
>  fs/isofs/dir.c   |    6 +++---
>  fs/isofs/inode.c |   17 ++---------------
>  fs/isofs/isofs.h |    1 +
>  fs/isofs/namei.c |    8 ++++----
>  fs/isofs/rock.c  |   10 +++++-----
>  5 files changed, 15 insertions(+), 27 deletions(-)
> 
> diff --git a/fs/isofs/dir.c b/fs/isofs/dir.c
> index e0aca9a..0542b6e 100644
> --- a/fs/isofs/dir.c
> +++ b/fs/isofs/dir.c
> @@ -10,7 +10,6 @@
>   *
>   *  isofs directory handling functions
>   */
> -#include <linux/smp_lock.h>
>  #include <linux/gfp.h>
>  #include "isofs.h"
>  
> @@ -255,18 +254,19 @@ static int isofs_readdir(struct file *filp,
>  	char *tmpname;
>  	struct iso_directory_record *tmpde;
>  	struct inode *inode = filp->f_path.dentry->d_inode;
> +	struct isofs_sb_info *sbi = ISOFS_SB(inode->i_sb);
>  
>  	tmpname = (char *)__get_free_page(GFP_KERNEL);
>  	if (tmpname == NULL)
>  		return -ENOMEM;
>  
> -	lock_kernel();
> +	mutex_lock(&sbi->s_mutex);
>  	tmpde = (struct iso_directory_record *) (tmpname+1024);
>  
>  	result = do_isofs_readdir(inode, filp, dirent, filldir, tmpname, tmpde);
>  
>  	free_page((unsigned long) tmpname);
> -	unlock_kernel();
> +	mutex_unlock(&sbi->s_mutex);
>  	return result;
>  }
>  
> diff --git a/fs/isofs/inode.c b/fs/isofs/inode.c
> index 05baf77..09ff41a 100644
> --- a/fs/isofs/inode.c
> +++ b/fs/isofs/inode.c
> @@ -17,7 +17,6 @@
>  #include <linux/slab.h>
>  #include <linux/nls.h>
>  #include <linux/ctype.h>
> -#include <linux/smp_lock.h>
>  #include <linux/statfs.h>
>  #include <linux/cdrom.h>
>  #include <linux/parser.h>
> @@ -44,11 +43,7 @@ static void isofs_put_super(struct super_block *sb)
>  	struct isofs_sb_info *sbi = ISOFS_SB(sb);
>  
>  #ifdef CONFIG_JOLIET
> -	lock_kernel();
> -
>  	unload_nls(sbi->s_nls_iocharset);
> -
> -	unlock_kernel();
>  #endif
>  
>  	kfree(sbi);
> @@ -571,15 +566,11 @@ static int isofs_fill_super(struct super_block *s, void *data, int silent)
>  	int table, error = -EINVAL;
>  	unsigned int vol_desc_start;
>  
> -	lock_kernel();
> -
>  	save_mount_options(s, data);
>  
>  	sbi = kzalloc(sizeof(*sbi), GFP_KERNEL);
> -	if (!sbi) {
> -		unlock_kernel();
> +	if (!sbi)
>  		return -ENOMEM;
> -	}
>  	s->s_fs_info = sbi;
>  
>  	if (!parse_options((char *)data, &opt))
> @@ -827,6 +818,7 @@ root_found:
>  	sbi->s_utf8 = opt.utf8;
>  	sbi->s_nocompress = opt.nocompress;
>  	sbi->s_overriderockperm = opt.overriderockperm;
> +	mutex_init(&sbi->s_mutex);
>  	/*
>  	 * It would be incredibly stupid to allow people to mark every file
>  	 * on the disk as suid, so we merely allow them to set the default
> @@ -904,7 +896,6 @@ root_found:
>  
>  	kfree(opt.iocharset);
>  
> -	unlock_kernel();
>  	return 0;
>  
>  	/*
> @@ -944,7 +935,6 @@ out_freesbi:
>  	kfree(opt.iocharset);
>  	kfree(sbi);
>  	s->s_fs_info = NULL;
> -	unlock_kernel();
>  	return error;
>  }
>  
> @@ -983,8 +973,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
>  	int section, rv, error;
>  	struct iso_inode_info *ei = ISOFS_I(inode);
>  
> -	lock_kernel();
> -
>  	error = -EIO;
>  	rv = 0;
>  	if (iblock < 0 || iblock != iblock_s) {
> @@ -1060,7 +1048,6 @@ int isofs_get_blocks(struct inode *inode, sector_t iblock_s,
>  
>  	error = 0;
>  abort:
> -	unlock_kernel();
>  	return rv != 0 ? rv : error;
>  }
>  
> diff --git a/fs/isofs/isofs.h b/fs/isofs/isofs.h
> index 7d33de8..2882dc0 100644
> --- a/fs/isofs/isofs.h
> +++ b/fs/isofs/isofs.h
> @@ -55,6 +55,7 @@ struct isofs_sb_info {
>  	gid_t s_gid;
>  	uid_t s_uid;
>  	struct nls_table *s_nls_iocharset; /* Native language support table */
> +	struct mutex s_mutex; /* replaces BKL, please remove if possible */
>  };
>  
>  #define ISOFS_INVALID_MODE ((mode_t) -1)
> diff --git a/fs/isofs/namei.c b/fs/isofs/namei.c
> index ab438be..0d23abf 100644
> --- a/fs/isofs/namei.c
> +++ b/fs/isofs/namei.c
> @@ -6,7 +6,6 @@
>   *  (C) 1991  Linus Torvalds - minix filesystem
>   */
>  
> -#include <linux/smp_lock.h>
>  #include <linux/gfp.h>
>  #include "isofs.h"
>  
> @@ -168,6 +167,7 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
>  	int found;
>  	unsigned long uninitialized_var(block);
>  	unsigned long uninitialized_var(offset);
> +	struct isofs_sb_info *sbi = ISOFS_SB(dir->i_sb);
>  	struct inode *inode;
>  	struct page *page;
>  
> @@ -177,7 +177,7 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
>  	if (!page)
>  		return ERR_PTR(-ENOMEM);
>  
> -	lock_kernel();
> +	mutex_lock(&sbi->s_mutex);
>  	found = isofs_find_entry(dir, dentry,
>  				&block, &offset,
>  				page_address(page),
> @@ -188,10 +188,10 @@ struct dentry *isofs_lookup(struct inode *dir, struct dentry *dentry, struct nam
>  	if (found) {
>  		inode = isofs_iget(dir->i_sb, block, offset);
>  		if (IS_ERR(inode)) {
> -			unlock_kernel();
> +			mutex_unlock(&sbi->s_mutex);
>  			return ERR_CAST(inode);
>  		}
>  	}
> -	unlock_kernel();
> +	mutex_unlock(&sbi->s_mutex);
>  	return d_splice_alias(inode, dentry);
>  }
> diff --git a/fs/isofs/rock.c b/fs/isofs/rock.c
> index 96a685c..f9cd04d 100644
> --- a/fs/isofs/rock.c
> +++ b/fs/isofs/rock.c
> @@ -8,7 +8,6 @@
>  
>  #include <linux/slab.h>
>  #include <linux/pagemap.h>
> -#include <linux/smp_lock.h>
>  
>  #include "isofs.h"
>  #include "rock.h"
> @@ -661,6 +660,7 @@ static int rock_ridge_symlink_readpage(struct file *file, struct page *page)
>  {
>  	struct inode *inode = page->mapping->host;
>  	struct iso_inode_info *ei = ISOFS_I(inode);
> +	struct isofs_sb_info *sbi = ISOFS_SB(inode->i_sb);
>  	char *link = kmap(page);
>  	unsigned long bufsize = ISOFS_BUFFER_SIZE(inode);
>  	struct buffer_head *bh;
> @@ -673,12 +673,12 @@ static int rock_ridge_symlink_readpage(struct file *file, struct page *page)
>  	struct rock_state rs;
>  	int ret;
>  
> -	if (!ISOFS_SB(inode->i_sb)->s_rock)
> +	if (!sbi->s_rock)
>  		goto error;
>  
>  	init_rock_state(&rs, inode);
>  	block = ei->i_iget5_block;
> -	lock_kernel();
> +	mutex_lock(&sbi->s_mutex);
>  	bh = sb_bread(inode->i_sb, block);
>  	if (!bh)
>  		goto out_noread;
> @@ -748,7 +748,7 @@ repeat:
>  		goto fail;
>  	brelse(bh);
>  	*rpnt = '\0';
> -	unlock_kernel();
> +	mutex_unlock(&sbi->s_mutex);
>  	SetPageUptodate(page);
>  	kunmap(page);
>  	unlock_page(page);
> @@ -765,7 +765,7 @@ out_bad_span:
>  	printk("symlink spans iso9660 blocks\n");
>  fail:
>  	brelse(bh);
> -	unlock_kernel();
> +	mutex_unlock(&sbi->s_mutex);
>  error:
>  	SetPageError(page);
>  	kunmap(page);
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
