Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab0CWSVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 14:21:47 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33863 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab0CWSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 14:21:46 -0400
Message-ID: <4BA90637.5000202@oracle.com>
Date: Tue, 23 Mar 2010 11:19:35 -0700
From: Sunil Mushran <sunil.mushran@oracle.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Josef Bacik <josef@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, viro@ZenIV.linux.org.uk, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
References: <20100323142200.GA2381@localhost.localdomain>
In-Reply-To: <20100323142200.GA2381@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BA906A4.019C:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for doing this. This helps ocfs2 too because we need to be able
to freeze the fs both from the user-context (node the ioctl was issued)
and the kernel-context (other nodes). In the older scheme, it was tricky
to handle nodes racing to freeze the fs. This will make it a lot easier.

Sunil

Josef Bacik wrote:
> Currently the way we do freezing is by passing sb>s_bdev to freeze_bdev and then
> letting it do all the work.  But freezing is more of an fs thing, and doesn't
> really have much to do with the bdev at all, all the work gets done with the
> super.  In btrfs we do not populate s_bdev, since we can have multiple bdev's
> for one fs and setting s_bdev makes removing devices from a pool kind of tricky.
> This means that freezing a btrfs filesystem fails, which causes us to corrupt
> with things like tux-on-ice which use the fsfreeze mechanism.  So instead of
> populating sb->s_bdev with a random bdev in our pool, I've broken the actual fs
> freezing stuff into freeze_super and thaw_super.  These just take the
> super_block that we're freezing and does the appropriate work.  It's basically
> just copy and pasted from freeze_bdev.  I've then converted freeze_bdev over to
> use the new super helpers.  I've tested this with ext4 and btrfs and verified
> everything continues to work the same as before.
>
> The only new gotcha is multiple calls to the fsfreeze ioctl will return EBUSY if
> the fs is already frozen.  I thought this was a better solution than adding a
> freeze counter to the super_block, but if everybody hates this idea I'm open to
> suggestions.  Thanks,
>
> Signed-off-by: Josef Bacik <josef@redhat.com>
> ---
>  fs/block_dev.c     |   66 ++++++++------------------------------
>  fs/ioctl.c         |   18 +++--------
>  fs/super.c         |   88 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h |    2 +
>  4 files changed, 109 insertions(+), 65 deletions(-)
>
> diff --git a/fs/block_dev.c b/fs/block_dev.c
> index 8bed055..71b6165 100644
> --- a/fs/block_dev.c
> +++ b/fs/block_dev.c
> @@ -245,35 +245,13 @@ struct super_block *freeze_bdev(struct block_device *bdev)
>  	sb = get_active_super(bdev);
>  	if (!sb)
>  		goto out;
> -	if (sb->s_flags & MS_RDONLY) {
> -		deactivate_locked_super(sb);
> -		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -		return sb;
> -	}
> -
> -	sb->s_frozen = SB_FREEZE_WRITE;
> -	smp_wmb();
> -
> -	sync_filesystem(sb);
>  
> -	sb->s_frozen = SB_FREEZE_TRANS;
> -	smp_wmb();
> -
> -	sync_blockdev(sb->s_bdev);
> -
> -	if (sb->s_op->freeze_fs) {
> -		error = sb->s_op->freeze_fs(sb);
> -		if (error) {
> -			printk(KERN_ERR
> -				"VFS:Filesystem freeze failed\n");
> -			sb->s_frozen = SB_UNFROZEN;
> -			deactivate_locked_super(sb);
> -			bdev->bd_fsfreeze_count--;
> -			mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -			return ERR_PTR(error);
> -		}
> +	error = freeze_super(sb, 1);
> +	if (error) {
> +		bdev->bd_fsfreeze_count--;
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return ERR_PTR(error);
>  	}
> -	up_write(&sb->s_umount);
>  
>   out:
>  	sync_blockdev(bdev);
> @@ -295,40 +273,24 @@ int thaw_bdev(struct block_device *bdev, struct super_block *sb)
>  
>  	mutex_lock(&bdev->bd_fsfreeze_mutex);
>  	if (!bdev->bd_fsfreeze_count)
> -		goto out_unlock;
> +		goto out;
>  
>  	error = 0;
>  	if (--bdev->bd_fsfreeze_count > 0)
> -		goto out_unlock;
> +		goto out;
>  
>  	if (!sb)
> -		goto out_unlock;
> +		goto out;
>  
>  	BUG_ON(sb->s_bdev != bdev);
> -	down_write(&sb->s_umount);
> -	if (sb->s_flags & MS_RDONLY)
> -		goto out_deactivate;
> -
> -	if (sb->s_op->unfreeze_fs) {
> -		error = sb->s_op->unfreeze_fs(sb);
> -		if (error) {
> -			printk(KERN_ERR
> -				"VFS:Filesystem thaw failed\n");
> -			sb->s_frozen = SB_FREEZE_TRANS;
> -			bdev->bd_fsfreeze_count++;
> -			mutex_unlock(&bdev->bd_fsfreeze_mutex);
> -			return error;
> -		}
> +	error = thaw_super(sb);
> +	if (error) {
> +		bdev->bd_fsfreeze_count++;
> +		mutex_unlock(&bdev->bd_fsfreeze_mutex);
> +		return error;
>  	}
>  
> -	sb->s_frozen = SB_UNFROZEN;
> -	smp_wmb();
> -	wake_up(&sb->s_wait_unfrozen);
> -
> -out_deactivate:
> -	if (sb)
> -		deactivate_locked_super(sb);
> -out_unlock:
> +out:
>  	mutex_unlock(&bdev->bd_fsfreeze_mutex);
>  	return 0;
>  }
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 6c75110..a065eff 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -503,6 +503,7 @@ static int ioctl_fioasync(unsigned int fd, struct file *filp,
>  static int ioctl_fsfreeze(struct file *filp)
>  {
>  	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;
> +	int ret;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -511,15 +512,10 @@ static int ioctl_fsfreeze(struct file *filp)
>  	if (sb->s_op->freeze_fs == NULL)
>  		return -EOPNOTSUPP;
>  
> -	/* If a blockdevice-backed filesystem isn't specified, return. */
> -	if (sb->s_bdev == NULL)
> -		return -EINVAL;
> -
>  	/* Freeze */
> -	sb = freeze_bdev(sb->s_bdev);
> -	if (IS_ERR(sb))
> -		return PTR_ERR(sb);
> -	return 0;
> +	ret = freeze_super(sb, 0);
> +
> +	return ret;
>  }
>  
>  static int ioctl_fsthaw(struct file *filp)
> @@ -529,12 +525,8 @@ static int ioctl_fsthaw(struct file *filp)
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> -	/* If a blockdevice-backed filesystem isn't specified, return EINVAL. */
> -	if (sb->s_bdev == NULL)
> -		return -EINVAL;
> -
>  	/* Thaw */
> -	return thaw_bdev(sb->s_bdev, sb);
> +	return thaw_super(sb);
>  }
>  
>  /*
> diff --git a/fs/super.c b/fs/super.c
> index 19eb70b..305d475 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -971,6 +971,94 @@ out:
>  
>  EXPORT_SYMBOL_GPL(vfs_kern_mount);
>  
> +/**
> + * freeze_super -- lock the filesystem and force it into a consistent state
> + * @super: the super to lock
> + *
> + * Syncs the super to make sure the filesystem is consistent and calls the fs's
> + * freeze_fs.  We hold the s_umount semaphore in order to make sure the fs is
> + * not unmounted until after we thaw the fs.  This cannot be called multiple
> + * times like freeze_bdev, if we're already frozen we'll return -EBUSY.
> + */
> +int freeze_super(struct super_block *sb, int locked)
> +{
> +	int ret;
> +
> +	if (!locked) {
> +		spin_lock(&sb_lock);
> +		ret = grab_super(sb);
> +		if (!ret)
> +			return 0;
> +	}
> +
> +	if (sb->s_flags & MS_RDONLY) {
> +		deactivate_locked_super(sb);
> +		return 0;
> +	}
> +
> +	if (sb->s_frozen) {
> +		deactivate_locked_super(sb);
> +		return -EBUSY;
> +	}
> +
> +	sb->s_frozen = SB_FREEZE_WRITE;
> +	smp_wmb();
> +
> +	sync_filesystem(sb);
> +
> +	sb->s_frozen = SB_FREEZE_TRANS;
> +	smp_wmb();
> +
> +	sync_blockdev(sb->s_bdev);
> +	if (sb->s_op->freeze_fs) {
> +		ret = sb->s_op->freeze_fs(sb);
> +		if (ret) {
> +			printk(KERN_ERR
> +				"VFS:Filesystem freeze failed\n");
> +			sb->s_frozen = SB_UNFROZEN;
> +			deactivate_locked_super(sb);
> +			return ret;
> +		}
> +	}
> +	up_write(&sb->s_umount);
> +	return 0;
> +}
> +EXPORT_SYMBOL(freeze_super);
> +
> +/**
> + * thaw_super -- unlock filesystem
> + * @sb: the super to thaw
> + *
> + * Unlocks the filesystem and marks it writeable again after freeze_super().
> + */
> +int thaw_super(struct super_block *sb)
> +{
> +	int error;
> +
> +	down_write(&sb->s_umount);
> +	if (sb->s_flags & MS_RDONLY)
> +		goto out;
> +
> +	if (sb->s_op->unfreeze_fs) {
> +		error = sb->s_op->unfreeze_fs(sb);
> +		if (error) {
> +			printk(KERN_ERR
> +				"VFS:Filesystem thaw failed\n");
> +			sb->s_frozen = SB_FREEZE_TRANS;
> +			return error;
> +		}
> +	}
> +
> +	sb->s_frozen = SB_UNFROZEN;
> +	smp_wmb();
> +	wake_up(&sb->s_wait_unfrozen);
> +
> +out:
> +	deactivate_locked_super(sb);
> +	return 0;
> +}
> +EXPORT_SYMBOL(thaw_super);
> +
>  static struct vfsmount *fs_set_subtype(struct vfsmount *mnt, const char *fstype)
>  {
>  	int err;
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 2620a8c..a5778ae 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1802,6 +1802,8 @@ extern int may_umount(struct vfsmount *);
>  extern long do_mount(char *, char *, char *, unsigned long, void *);
>  extern struct vfsmount *collect_mounts(struct path *);
>  extern void drop_collected_mounts(struct vfsmount *);
> +extern int freeze_super(struct super_block *super, int locked);
> +extern int thaw_super(struct super_block *super);
>  
>  extern int vfs_statfs(struct dentry *, struct kstatfs *);
>  

