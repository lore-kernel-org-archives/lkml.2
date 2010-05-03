Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab0ECSy2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 14:54:28 -0400
Received: from cantor.suse.de ([195.135.220.2]:36304 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754800Ab0ECSyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 14:54:23 -0400
Date: Mon, 3 May 2010 20:54:21 +0200
From: Jan Kara <jack@suse.cz>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: David Woodhouse <dwmw2@infradead.org>, Jan Kara <jack@suse.cz>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd: Do not corrupt backing device of device node inode
Message-ID: <20100503185421.GF3470@quack.suse.cz>
References: <1271934535.11751.1550.camel@macbook.infradead.org>
 <1272905767-4317-1-git-send-email-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1272905767-4317-1-git-send-email-kirill@shutemov.name>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 03-05-10 19:56:07, Kirill A. Shutemov wrote:
> We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
> backing device of device node inode, since file->f_mapping is equal to
> inode->i_mapping (see __dentry_open() in fs/open.c).
> 
> Let's introduce separate inode for MTD device with appropriate backing
> device.
  Now the patch looks much cleaner. Thanks! Having a separate fstype for a
single inode seems like a bit of an overkill but I agree there doesn't seem
to be a suitable filesystem where an inode could live, so it's probably OK.
Two minor comments are below.

> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>
> ---
>  drivers/mtd/mtdchar.c   |   70 +++++++++++++++++++++++++++++++++++++++++-----
>  drivers/mtd/mtdcore.c   |    3 ++
>  include/linux/mtd/mtd.h |    3 ++
>  3 files changed, 68 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/mtd/mtdchar.c b/drivers/mtd/mtdchar.c
> index 5b081cb..24ea34f 100644
> --- a/drivers/mtd/mtdchar.c
> +++ b/drivers/mtd/mtdchar.c
> @@ -88,8 +91,21 @@ static int mtd_open(struct inode *inode, struct file *file)
>  		goto out;
>  	}
>  
> -	if (mtd->backing_dev_info)
> -		file->f_mapping->backing_dev_info = mtd->backing_dev_info;
> +	if (!mtd->inode) {
> +		mtd->inode = new_inode(mtd_inode_mnt->mnt_sb);
  This can fail so you should check whether mtd->inode is != NULL.

...
>  static int __init init_mtdchar(void)
>  {
> -	int status;
> +	int ret;
>  
> -	status = register_chrdev(MTD_CHAR_MAJOR, "mtd", &mtd_fops);
> -	if (status < 0) {
> -		printk(KERN_NOTICE "Can't allocate major number %d for Memory Technology Devices.\n",
> -		       MTD_CHAR_MAJOR);
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
> +
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
> +err_unregister_chdev:
> +	unregister_chrdev(MTD_CHAR_MAJOR, "mtd");
> +err_unregister_filesystem:
> +	unregister_filesystem(&mtd_inodefs_type);
> +	return ret;
  I think you should swap unregister_chrdev and unregister_filesystem
blocks...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
