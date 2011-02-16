Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751Ab1BPVLN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 16:11:13 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37277 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030Ab1BPVLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 16:11:10 -0500
Date: Wed, 16 Feb 2011 15:11:06 -0600
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Thieu Le <thieule@chromium.org>
Cc: kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs: modify write path to encrypt page in writepage
Message-ID: <20110216211102.GB16672@boyd.l.tihix.com>
References: <1297207213-31279-1-git-send-email-thieule@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297207213-31279-1-git-send-email-thieule@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Feb 08, 2011 at 03:20:12PM -0800, Thieu Le <thieule@chromium.org> wrote:
> Change the write path to encrypt the data only when the page is written to
> disk in ecryptfs_writepage. Previously, ecryptfs encrypts the page in
> ecryptfs_write_end which means that if there are multiple write requests to
> the same page, ecryptfs ends up re-encrypting that page over and over again.
> This patch minimizes the number of encryptions needed.

Hi Thieu - Thanks for tackling this issue. This should really speed up
eCryptfs write performance.

You and I have discussed all of this in IRC already, but I
wanted to respond here for completeness and to allow for feedback from
others.

Upon testing this patch, I see some lockdep warnings from where we're
grabbing a mutex and dynamically allocating memory. This causes direct
reclaim to try to shrink the eCryptfs page cache and then we might try
to grab the same lock or allocate more memory in our writepage() path.

All of the eCryptfs issues are probably fixable, but since we use
vfs_write() on the lower file in our writepage() path, I think it is
possible that the lower filesystem could allocate more memory in its
write/aio_write path.

I think we'll have to borrow the idea from other filesystems, such as
xfs_vm_writepage(), where we simply redirty the page if writepage() is
called from direct reclaim. We'd be doing this for a different reason
than xfs, but kernel stack size is also an issue with stacked
filesystems.

Finally, there seems to be a deadlock issue with this patch.

When eCryptfs is mounted at /upper, ext4 is the lower fs, and I run
this:

$ dd if=/dev/zero of=/upper/foo.dd bs=4096 count=131072

It results in this hung task trace:

INFO: task flush-ecryptfs-:1004 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
flush-ecryptfs- D 0000000000000000     0  1004      2 0x00000080
 ffff8800000916a0 0000000000000046 ffff880000091640 ffffffff00000000
 00000000001d1880 00000000001d1880 ffff88000b8da2e0 ffff880000091fd8
 00000000001d1880 00000000001d1880 00000000001d1880 00000000001d1880
Call Trace:
 [<ffffffff810b3450>] ? generic_file_aio_write+0x47/0xac
 [<ffffffff812e03bf>] __mutex_lock_common+0x2c3/0x447
 [<ffffffff810b3450>] ? generic_file_aio_write+0x47/0xac
 [<ffffffff812e05f8>] mutex_lock_nested+0x39/0x3e
 [<ffffffff810b3450>] generic_file_aio_write+0x47/0xac
 [<ffffffffa009bd4e>] ext4_file_write+0x1f8/0x252 [ext4]
 [<ffffffff8103190f>] ? get_parent_ip+0x11/0x41
 [<ffffffff81154a80>] ? file_has_perm+0x95/0xa3
 [<ffffffff810e3f76>] do_sync_write+0xcb/0x108
 [<ffffffff81154c39>] ? selinux_file_permission+0xa6/0xb9
 [<ffffffff81150032>] ? security_file_permission+0x2e/0x33
 [<ffffffff810e461d>] vfs_write+0xaf/0x102
 [<ffffffffa024774a>] ecryptfs_write_lower+0x55/0x7d [ecryptfs]
 [<ffffffffa02488fa>] ecryptfs_encrypt_page+0xf5/0x15b [ecryptfs]
 [<ffffffffa0246d51>] ecryptfs_writepage+0x14/0x56 [ecryptfs]
 [<ffffffff810b8a12>] __writepage+0x1a/0x39
 [<ffffffff810b921f>] write_cache_pages+0x250/0x37a
 [<ffffffff810b89f8>] ? __writepage+0x0/0x39
 [<ffffffff810b9370>] generic_writepages+0x27/0x29
 [<ffffffff810b9f56>] do_writepages+0x2b/0x2d
 [<ffffffff81103dce>] writeback_single_inode+0xad/0x1de
 [<ffffffff8110414d>] writeback_sb_inodes+0xa7/0x136
 [<ffffffff81104bfd>] ? writeback_inodes_wb+0x118/0x190
 [<ffffffff81104c63>] writeback_inodes_wb+0x17e/0x190
 [<ffffffff81104ed8>] wb_writeback+0x263/0x39b
 [<ffffffff8110519e>] wb_do_writeback+0x18e/0x1a9
 [<ffffffff8110524f>] bdi_writeback_thread+0x96/0x233
 [<ffffffff811051b9>] ? bdi_writeback_thread+0x0/0x233
 [<ffffffff81054bd4>] kthread+0x8e/0x96
 [<ffffffff81003a84>] kernel_thread_helper+0x4/0x10
 [<ffffffff812e2558>] ? restore_args+0x0/0x30
 [<ffffffff81054b46>] ? kthread+0x0/0x96
 [<ffffffff81003a80>] ? kernel_thread_helper+0x0/0x10
2 locks held by flush-ecryptfs-/1004:
 #0:  (&type->s_umount_key#34){.+.+.+}, at: [<ffffffff81104bfd>] writeback_inodes_wb+0x118/0x190
 #1:  (&sb->s_type->i_mutex_key#11){+.+.+.}, at: [<ffffffff810b3450>] generic_file_aio_write+0x47/0xac

Thanks again for working on this.

Tyler

> 
> Signed-off-by: Thieu Le <thieule@chromium.org>
> ---
>  fs/ecryptfs/ecryptfs_kernel.h |    1 -
>  fs/ecryptfs/file.c            |    9 ++++++++-
>  fs/ecryptfs/main.c            |    2 --
>  fs/ecryptfs/mmap.c            |   20 ++++++++------------
>  fs/ecryptfs/read_write.c      |   12 ++----------
>  fs/ecryptfs/super.c           |    1 -
>  6 files changed, 18 insertions(+), 27 deletions(-)
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
> index cc64fca..c5676e6 100644
> --- a/fs/ecryptfs/mmap.c
> +++ b/fs/ecryptfs/mmap.c
> @@ -512,24 +512,20 @@ static int ecryptfs_write_end(struct file *file,
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
>  	if (pos + copied > i_size_read(ecryptfs_inode)) {
>  		i_size_write(ecryptfs_inode, pos + copied);
>  		ecryptfs_printk(KERN_DEBUG, "Expanded file size to "
>  			"[0x%.16llx]\n",
>  			(unsigned long long)i_size_read(ecryptfs_inode));
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
>  	unlock_page(page);
>  	page_cache_release(page);
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
> index 3042fe1..15c969e 100644
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
> -- 
> 1.7.3.1
> 
