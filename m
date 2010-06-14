Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab0FNOHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 10:07:34 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187Ab0FNOHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:07:33 -0400
Date: Mon, 14 Jun 2010 10:07:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH] Only honor the FIGETBSZ ioctl for regular files,
 directories, and symlinks
Message-ID: <20100614140730.GA30779@infradead.org>
References: <20100614134252.GA22163@thunk.org>
 <1276524310-25812-1-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276524310-25812-1-git-send-email-tytso@mit.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 14, 2010 at 10:05:10AM -0400, Theodore Ts'o wrote:
> FIGETBSZ has an ioctl number of _IO(0x00,2) == 2, which can conflict
> with device driver ioctls.  Let's avoid the potential for problems by
> only honoring the ioctl number for files where this ioctl is likely
> going to be useful: regular files, directories, and symlinks.
> 
> Thanks to Johannes Stezenbach for pointing this consequence of commit
> 19ba0559.

ioctl operate on a file descriptor, so you never call them on
symbolic links.

> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 2d140a7..5c61d69 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -597,7 +597,10 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
>  	{
>  		struct inode *inode = filp->f_path.dentry->d_inode;
>  		int __user *p = (int __user *)arg;
> -		return put_user(inode->i_sb->s_blocksize, p);
> +
> +		if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode) ||
> +		    S_ISLNK(inode->i_mode))
> +			return put_user(inode->i_sb->s_blocksize, p);
>  	}
>  
>  	default:

A comment explaining why we fall through here for special files is
almost required.  Without that the chance of breaking it during the
next random cleanup are far too high.

