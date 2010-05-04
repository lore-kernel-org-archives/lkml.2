Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933Ab0EDLTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 07:19:52 -0400
Received: from cantor.suse.de ([195.135.220.2]:33978 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751467Ab0EDLTu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 07:19:50 -0400
Date: Tue, 4 May 2010 13:19:48 +0200
From: Jan Kara <jack@suse.cz>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Woodhouse <dwmw2@infradead.org>, Jan Kara <jack@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mtd: Do not corrupt backing device of device node
 inode
Message-ID: <20100504111947.GB3398@quack.suse.cz>
References: <1272922368-18517-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272922368-18517-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-05-10 00:32:48, Kirill A. Shutemov wrote:
> We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> backing device of device node inode, since file->f_mapping is equal to
> inode->i_mapping (see __dentry_open() in fs/open.c).
> 
> Let's introduce separate inode for MTD device with appropriate backing
> device.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
  The patch now looks correct to me. Acked-by: Jan Kara <jack@suse.cz>

									Honza
> 
> ---
> Changelog v1 -> v2:
>  - Fix error handling based on comments by Jan Kara.
> 
> ---
>  drivers/mtd/mtdchar.c   |   77 ++++++++++++++++++++++++++++++++++++++++++-----
>  drivers/mtd/mtdcore.c   |    3 ++
>  include/linux/mtd/mtd.h |    3 ++
>  3 files changed, 75 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 5b081cb..11d7c4a 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -15,12 +15,15 @@
>  #include <linux/smp_lock.h>
>  #include <linux/backing-dev.h>
>  #include <linux/compat.h>
> +#include <linux/mount.h>
>  
>  #include <linux/mtd/mtd.h>
>  #include <linux/mtd/compatmac.h>
>  
>  #include <asm/uaccess.h>
>  
> +#define MTD_INODE_FS_MAGIC 0x11307854
> +static struct vfsmount *mtd_inode_mnt __read_mostly;
>  
>  /*
>   * Data structure to hold the pointer to the mtd device as well
> @@ -88,11 +91,30 @@ static int mtd_open(struct inode *inode, struct file *file)
>  		goto out;
>  	}
>  
> -	if (mtd->backing_dev_info)
> -		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
> +	if (!mtd->inode) {
> +		mtd->inode = new_inode(mtd_inode_mnt->mnt_sb);
> +		if (!mtd->inode) {
> +			put_mtd_device(mtd);
> +			ret = -ENOMEM;
> +			goto out;
> +		}
> +		mtd->inode->i_mode = S_IFCHR;
> +		mtd->inode->i_rdev = inode->i_rdev;
> +		if (mtd->backing_dev_info) {
> +			mtd->inode->i_data.backing_dev_info =
> +				mtd->backing_dev_info;
> +		}
> +	}
> +
> +	spin_lock(&inode_lock);
> +	__iget(mtd->inode);
> +	spin_unlock(&inode_lock);
> +
> +	file->f_mapping = mtd->inode->i_mapping;
>  
>  	/* You can't open it RW if it's not a writeable device */
>  	if ((file->f_mode & FMODE_WRITE) && !(mtd->flags & MTD_WRITEABLE)) {
> +		iput(mtd->inode);
>  		put_mtd_device(mtd);
>  		ret = -EACCES;
>  		goto out;
> @@ -100,6 +122,7 @@ static int mtd_open(struct inode *inode, struct file *file)
>  
>  	mfi = kzalloc(sizeof(*mfi), GFP_KERNEL);
>  	if (!mfi) {
> +		iput(mtd->inode);
>  		put_mtd_device(mtd);
>  		ret = -ENOMEM;
>  		goto out;
> @@ -125,6 +148,8 @@ static int mtd_close(struct inode *inode, struct file *file)
>  	if ((file->f_mode & FMODE_WRITE) && mtd->sync)
>  		mtd->sync(mtd);
>  
> +	iput(mtd->inode);
> +
>  	put_mtd_device(mtd);
>  	file->private_data = NULL;
>  	kfree(mfi);
> @@ -954,21 +979,57 @@ static const struct file_operations mtd_fops = {
>  #endif
>  };
>  
> +static int mtd_inodefs_get_sb(struct file_system_type *fs_type, int flags,
> +                               const char *dev_name, void *data,
> +                               struct vfsmount *mnt)
> +{
> +        return get_sb_pseudo(fs_type, "mtd_inode:", NULL, MTD_INODE_FS_MAGIC,
> +                             mnt);
> +}
> +
> +static struct file_system_type mtd_inodefs_type = {
> +       .name = "mtd_inodefs",
> +       .get_sb = mtd_inodefs_get_sb,
> +       .kill_sb = kill_anon_super,
> +};
> +
>  static int __init init_mtdchar(void)
>  {
> -	int status;
> +	int ret;
> +
> +	ret = register_chrdev(MTD_CHAR_MAJOR, "mtd", &mtd_fops);
> +	if (ret < 0) {
> +		pr_notice("Can't allocate major number %d for "
> +				"Memory Technology Devices.\n", MTD_CHAR_MAJOR);
> +		return ret;
> +	}
> +
> +	ret = register_filesystem(&mtd_inodefs_type);
> +	if (ret) {
> +		pr_notice("Can't register mtd_inodefs filesystem: %d\n", ret);
> +		goto err_unregister_chdev;
> +	}
>  
> -	status = register_chrdev(MTD_CHAR_MAJOR, "mtd", &mtd_fops);
> -	if (status < 0) {
> -		printk(KERN_NOTICE "Can't allocate major number %d for Memory Technology Devices.\n",
> -		       MTD_CHAR_MAJOR);
> +	mtd_inode_mnt = kern_mount(&mtd_inodefs_type);
> +	if (IS_ERR(mtd_inode_mnt)) {
> +		ret = PTR_ERR(mtd_inode_mnt);
> +		pr_notice("Error mounting mtd_inodefs filesystem: %d\n", ret);
> +		goto err_unregister_filesystem;
>  	}
>  
> -	return status;
> +	return ret;
> +
> +err_unregister_filesystem:
> +	unregister_filesystem(&mtd_inodefs_type);
> +err_unregister_chdev:
> +	unregister_chrdev(MTD_CHAR_MAJOR, "mtd");
> +	return ret;
>  }
>  
>  static void __exit cleanup_mtdchar(void)
>  {
> +	mntput(mtd_inode_mnt);
> +	unregister_filesystem(&mtd_inodefs_type);
>  	unregister_chrdev(MTD_CHAR_MAJOR, "mtd");
>  }
>  
> diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
> index b177e75..980919e 100644
> --- a/drivers/mtd/mtdcore.c
> +++ b/drivers/mtd/mtdcore.c
> @@ -383,6 +383,9 @@ int del_mtd_device (struct mtd_info *mtd)
>  	} else {
>  		struct mtd_notifier *not;
>  
> +		if (mtd->inode)
> +			iput(mtd->inode);
> +
>  		device_unregister(&mtd->dev);
>  
>  		/* No need to get a refcount on the module containing
> diff --git a/include/linux/mtd/mtd.h b/include/linux/mtd/mtd.h
> index 0f32a9b..0589632 100644
> --- a/include/linux/mtd/mtd.h
> +++ b/include/linux/mtd/mtd.h
> @@ -12,6 +12,7 @@
>  #include <linux/uio.h>
>  #include <linux/notifier.h>
>  #include <linux/device.h>
> +#include <linux/fs.h>
>  
>  #include <linux/mtd/compatmac.h>
>  #include <mtd/mtd-abi.h>
> @@ -177,6 +178,8 @@ struct mtd_info {
>  	 */
>  	struct backing_dev_info *backing_dev_info;
>  
> +	/* inode for mtd device */
> +	struct inode *inode;
>  
>  	int (*read) (struct mtd_info *mtd, loff_t from, size_t len, size_t *retlen, u_char *buf);
>  	int (*write) (struct mtd_info *mtd, loff_t to, size_t len, size_t *retlen, const u_char *buf);
> -- 
> 1.7.0.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
