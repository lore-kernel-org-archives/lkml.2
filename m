Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab1CKALT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:11:19 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:44536 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab1CKALS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:11:18 -0500
Date: Thu, 10 Mar 2011 18:11:15 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Thieu Le <thieule@chromium.org>
Cc: kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: modify write path to encrypt page in writepage
Message-ID: <20110311001115.GD14558@boyd.l.tihix.com>
References: <20110307234321.GA27908@boyd.l.tihix.com>
 <1299630363-20897-1-git-send-email-thieule@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299630363-20897-1-git-send-email-thieule@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Mar 08, 2011 at 04:26:03PM -0800, Thieu Le <thieule@chromium.org> wrote:
> I've addressed the data corruption issue. I forgot to update ecryptfs_sops.drop_inode to point to NULL to indicate that ecryptfs now caches data and the cache data should be flushed to disk when the last reference to the inode is released.
> 
> Commit message and updated patch below.

Thanks, Thieu. I've been testing this the last couple days and
everything is working well. I made one small change (noted inline) and
then pushed the patch to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

> 
> ------------------------------------------------------------------------------
> 
> Change the write path to encrypt the data only when the page is written to
> disk in ecryptfs_writepage. Previously, ecryptfs encrypts the page in
> ecryptfs_write_end which means that if there are multiple write requests to
> the same page, ecryptfs ends up re-encrypting that page over and over again.
> This patch minimizes the number of encryptions needed.
> 
> Signed-off-by: Thieu Le <thieule@chromium.org>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |    1 -
>  fs/ecryptfs/file.c            |    9 ++++++++-
>  fs/ecryptfs/main.c            |    2 --
>  fs/ecryptfs/mmap.c            |   41 +++++++++++++++++++++++++++--------------
>  fs/ecryptfs/read_write.c      |   12 ++----------
>  fs/ecryptfs/super.c           |    3 +--
>  6 files changed, 38 insertions(+), 30 deletions(-)
> 
> diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
> index dbc84ed..13517ac 100644
> --- a/fs/ecryptfs/ecryptfs_kernel.h
> +++ b/fs/ecryptfs/ecryptfs_kernel.h
> @@ -297,7 +297,6 @@ struct ecryptfs_inode_info {
>  	struct inode vfs_inode;
>  	struct inode *wii_inode;
>  	struct file *lower_file;
> -	struct mutex lower_file_mutex;
>  	struct ecryptfs_crypt_stat crypt_stat;
>  };
> 
> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> index 81e10e6..9f7ce63 100644
> --- a/fs/ecryptfs/file.c
> +++ b/fs/ecryptfs/file.c
> @@ -273,7 +273,14 @@ static int ecryptfs_release(struct inode *inode, struct file *file)
>  static int
>  ecryptfs_fsync(struct file *file, int datasync)
>  {
> -	return vfs_fsync(ecryptfs_file_to_lower(file), datasync);
> +	int rc = 0;
> +
> +	rc = generic_file_fsync(file, datasync);
> +	if (rc)
> +		goto out;
> +	rc = vfs_fsync(ecryptfs_file_to_lower(file), datasync);
> +out:
> +	return rc;
>  }
> 
>  static int ecryptfs_fasync(int fd, struct file *file, int flag)
> diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> index 758323a..63e412c 100644
> --- a/fs/ecryptfs/main.c
> +++ b/fs/ecryptfs/main.c
> @@ -122,7 +122,6 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
>  		ecryptfs_inode_to_private(ecryptfs_dentry->d_inode);
>  	int rc = 0;
> 
> -	mutex_lock(&inode_info->lower_file_mutex);
>  	if (!inode_info->lower_file) {
>  		struct dentry *lower_dentry;
>  		struct vfsmount *lower_mnt =
> @@ -138,7 +137,6 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
>  			inode_info->lower_file = NULL;
>  		}
>  	}
> -	mutex_unlock(&inode_info->lower_file_mutex);
>  	return rc;
>  }
> 
> diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
> index cc64fca..d36829f 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -62,6 +62,18 @@ static int ecryptfs_writepage(struct page *page, struct writeback_control *wbc)
>  {
>  	int rc;
> 
> +	/*
> +	 * Refuse to write the page out if we are called from reclaim context
> +	 * since our writepage() path may potentially allocate memory when
> +	 * calling into the lower fs vfs_write() which may in turn invoke
> +	 * us again.
> +	 */
> +	if (current->flags & PF_MEMALLOC) {
> +		redirty_page_for_writepage(wbc, page);
> +		rc = 0;
> +		goto out;
> +	}
> +
>  	rc = ecryptfs_encrypt_page(page);
>  	if (rc) {
>  		ecryptfs_printk(KERN_WARNING, "Error encrypting "
> @@ -70,8 +82,8 @@ static int ecryptfs_writepage(struct page *page, struct writeback_control *wbc)
>  		goto out;
>  	}
>  	SetPageUptodate(page);
> -	unlock_page(page);
>  out:
> +	unlock_page(page);
>  	return rc;
>  }
> 
> @@ -486,6 +498,7 @@ static int ecryptfs_write_end(struct file *file,
>  	struct ecryptfs_crypt_stat *crypt_stat =
>  		&ecryptfs_inode_to_private(ecryptfs_inode)->crypt_stat;
>  	int rc;
> +	int need_unlock_page = 1;
> 
>  	if (crypt_stat->flags & ECRYPTFS_NEW_FILE) {
>  		ecryptfs_printk(KERN_DEBUG, "ECRYPTFS_NEW_FILE flag set in "
> @@ -512,26 +525,26 @@ static int ecryptfs_write_end(struct file *file,
>  			"zeros in page with index = [0x%.16lx]\n", index);
>  		goto out;
>  	}
> -	rc = ecryptfs_encrypt_page(page);
> -	if (rc) {
> -		ecryptfs_printk(KERN_WARNING, "Error encrypting page (upper "
> -				"index [0x%.16lx])\n", index);
> -		goto out;
> -	}
> +	set_page_dirty(page);
> +	unlock_page(page);
> +	need_unlock_page = 0;
>  	if (pos + copied > i_size_read(ecryptfs_inode)) {
>  		i_size_write(ecryptfs_inode, pos + copied);
>  		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
>  			"[0x%.16llx]\n",
>  			(unsigned long long)i_size_read(ecryptfs_inode));
> +		balance_dirty_pages_ratelimited(mapping);
> +		rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
> +		if (rc) {
> +			printk(KERN_ERR "Error writing inode size to metadata; "
> +			       "rc = [%d]\n", rc);
> +			goto out;
> +		}
>  	}
> -	rc = ecryptfs_write_inode_size_to_metadata(ecryptfs_inode);
> -	if (rc)
> -		printk(KERN_ERR "Error writing inode size to metadata; "
> -		       "rc = [%d]\n", rc);
> -	else
> -		rc = copied;
> +	rc = copied;
>  out:
> -	unlock_page(page);
> +	if (need_unlock_page)
> +		unlock_page(page);
>  	page_cache_release(page);
>  	return rc;
>  }
> diff --git a/fs/ecryptfs/read_write.c b/fs/ecryptfs/read_write.c
> index db184ef..85d4309 100644
> --- a/fs/ecryptfs/read_write.c
> +++ b/fs/ecryptfs/read_write.c
> @@ -44,15 +44,11 @@ int ecryptfs_write_lower(struct inode *ecryptfs_inode, char *data,
>  	ssize_t rc;
> 
>  	inode_info = ecryptfs_inode_to_private(ecryptfs_inode);
> -	mutex_lock(&inode_info->lower_file_mutex);
>  	BUG_ON(!inode_info->lower_file);
> -	inode_info->lower_file->f_pos = offset;
>  	fs_save = get_fs();
>  	set_fs(get_ds());
> -	rc = vfs_write(inode_info->lower_file, data, size,
> -		       &inode_info->lower_file->f_pos);
> +	rc = vfs_write(inode_info->lower_file, data, size, &offset);
>  	set_fs(fs_save);
> -	mutex_unlock(&inode_info->lower_file_mutex);
>  	mark_inode_dirty_sync(ecryptfs_inode);
>  	return rc;
>  }
> @@ -234,15 +230,11 @@ int ecryptfs_read_lower(char *data, loff_t offset, size_t size,
>  	mm_segment_t fs_save;
>  	ssize_t rc;
> 
> -	mutex_lock(&inode_info->lower_file_mutex);
>  	BUG_ON(!inode_info->lower_file);
> -	inode_info->lower_file->f_pos = offset;
>  	fs_save = get_fs();
>  	set_fs(get_ds());
> -	rc = vfs_read(inode_info->lower_file, data, size,
> -		      &inode_info->lower_file->f_pos);
> +	rc = vfs_read(inode_info->lower_file, data, size, &offset);
>  	set_fs(fs_save);
> -	mutex_unlock(&inode_info->lower_file_mutex);
>  	return rc;
>  }
> 
> diff --git a/fs/ecryptfs/super.c b/fs/ecryptfs/super.c
> index 3042fe1..e15ff06 100644
> --- a/fs/ecryptfs/super.c
> +++ b/fs/ecryptfs/super.c
> @@ -55,7 +55,6 @@ static struct inode *ecryptfs_alloc_inode(struct super_block *sb)
>  	if (unlikely(!inode_info))
>  		goto out;
>  	ecryptfs_init_crypt_stat(&inode_info->crypt_stat);
> -	mutex_init(&inode_info->lower_file_mutex);
>  	inode_info->lower_file = NULL;
>  	inode = &inode_info->vfs_inode;
>  out:
> @@ -198,7 +197,7 @@ static int ecryptfs_show_options(struct seq_file *m, struct vfsmount *mnt)
>  const struct super_operations ecryptfs_sops = {
>  	.alloc_inode = ecryptfs_alloc_inode,
>  	.destroy_inode = ecryptfs_destroy_inode,
> -	.drop_inode = generic_delete_inode,
> +	.drop_inode = NULL,

For the sake of having one less NULL function pointer in the kernel, I
changed this from NULL to generic_drop_inode. :)

Tyler

>  	.statfs = ecryptfs_statfs,
>  	.remount_fs = NULL,
>  	.evict_inode = ecryptfs_evict_inode,
> -- 
> 1.7.3.1
> 
