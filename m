Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab2ICNeO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:34:14 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49441 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686Ab2ICNeM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:34:12 -0400
Date: Mon, 3 Sep 2012 15:34:09 +0200
From: Jan Kara <jack@suse.cz>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Luca Tettamanti <kronos.it@gmail.com>, reiserfs-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/21] reiserfs: drop vmtruncate
Message-ID: <20120903133409.GH21109@quack.suse.cz>
References: <5040C195.9050303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5040C195.9050303@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31-08-12 15:52:21, Marco Stornelli wrote:
> Removed vmtruncate.
  Looks good. You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

							Honza

> 
> Signed-off-by: Marco Stornelli <marco.stornelli@gmail.com>
> ---
>  fs/reiserfs/file.c     |    3 +--
>  fs/reiserfs/inode.c    |   15 +++++++++++----
>  fs/reiserfs/reiserfs.h |    1 +
>  3 files changed, 13 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
> index 8375c92..50302d6 100644
> --- a/fs/reiserfs/file.c
> +++ b/fs/reiserfs/file.c
> @@ -126,7 +126,7 @@ static int reiserfs_file_open(struct inode *inode, struct file *file)
>  	return err;
>  }
>  
> -static void reiserfs_vfs_truncate_file(struct inode *inode)
> +void reiserfs_vfs_truncate_file(struct inode *inode)
>  {
>  	mutex_lock(&(REISERFS_I(inode)->tailpack));
>  	reiserfs_truncate_file(inode, 1);
> @@ -312,7 +312,6 @@ const struct file_operations reiserfs_file_operations = {
>  };
>  
>  const struct inode_operations reiserfs_file_inode_operations = {
> -	.truncate = reiserfs_vfs_truncate_file,
>  	.setattr = reiserfs_setattr,
>  	.setxattr = reiserfs_setxattr,
>  	.getxattr = reiserfs_getxattr,
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index 855da58..03430b6 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -3078,8 +3078,10 @@ static ssize_t reiserfs_direct_IO(int rw, struct kiocb *iocb,
>  		loff_t isize = i_size_read(inode);
>  		loff_t end = offset + iov_length(iov, nr_segs);
>  
> -		if (end > isize)
> -			vmtruncate(inode, isize);
> +		if ((end > isize) && inode_newsize_ok(inode, isize) == 0) {
> +			truncate_setsize(inode, isize);
> +			reiserfs_vfs_truncate_file(inode);
> +		}
>  	}
>  
>  	return ret;
> @@ -3192,8 +3194,13 @@ int reiserfs_setattr(struct dentry *dentry, struct iattr *attr)
>  	 */
>  	reiserfs_write_unlock_once(inode->i_sb, depth);
>  	if ((attr->ia_valid & ATTR_SIZE) &&
> -	    attr->ia_size != i_size_read(inode))
> -		error = vmtruncate(inode, attr->ia_size);
> +	    attr->ia_size != i_size_read(inode)) {
> +		error = inode_newsize_ok(inode, attr->ia_size);
> +		if (!error) {
> +			truncate_setsize(inode, attr->ia_size);
> +			reiserfs_vfs_truncate_file(inode);
> +		}
> +	}
>  
>  	if (!error) {
>  		setattr_copy(inode, attr);
> diff --git a/fs/reiserfs/reiserfs.h b/fs/reiserfs/reiserfs.h
> index 33215f5..157e474 100644
> --- a/fs/reiserfs/reiserfs.h
> +++ b/fs/reiserfs/reiserfs.h
> @@ -2455,6 +2455,7 @@ struct reiserfs_transaction_handle *reiserfs_persistent_transaction(struct
>  								    *,
>  								    int count);
>  int reiserfs_end_persistent_transaction(struct reiserfs_transaction_handle *);
> +void reiserfs_vfs_truncate_file(struct inode *inode);
>  int reiserfs_commit_page(struct inode *inode, struct page *page,
>  			 unsigned from, unsigned to);
>  void reiserfs_flush_old_commits(struct super_block *);
> -- 
> 1.7.3.4
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
