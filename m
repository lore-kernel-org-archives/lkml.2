Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754209Ab0CWOsb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 10:48:31 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41844 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438Ab0CWOs3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 10:48:29 -0400
Date: Tue, 23 Mar 2010 14:48:28 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Josef Bacik <josef@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       chris.mason@oracle.com, hch@lst.de
Subject: Re: [PATCH] Introduce freeze_super and thaw_super for the fsfreeze
 ioctl
Message-ID: <20100323144828.GH30031@ZenIV.linux.org.uk>
References: <20100323142200.GA2381@localhost.localdomain>
 <20100323142843.GG30031@ZenIV.linux.org.uk>
 <20100323143456.GC2381@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100323143456.GC2381@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 10:34:56AM -0400, Josef Bacik wrote:
> +++ b/fs/block_dev.c
> @@ -245,35 +245,13 @@ struct super_block *freeze_bdev(struct block_device *bdev)
>  	sb = get_active_super(bdev);

sb is an active locked reference

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

>  static int ioctl_fsfreeze(struct file *filp)
>  {
>  	struct super_block *sb = filp->f_path.dentry->d_inode->i_sb;

sb is an active reference

> +	ret = freeze_super(sb, 0);
> +
> +	return ret;
>  }

> +int freeze_super(struct super_block *sb, int locked)
> +{
> +	int ret;
> +
> +	if (!locked) {
> +		spin_lock(&sb_lock);
> +		ret = grab_super(sb);

What in hell for?  We already hold an active reference here.  That's leaving
aside the obvious comments about argument-dependent locking state...
