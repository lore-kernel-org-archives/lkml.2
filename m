Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215Ab0H0ANg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Aug 2010 20:13:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40269 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752200Ab0H0ANe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Aug 2010 20:13:34 -0400
Date: Thu, 26 Aug 2010 17:01:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sage Weil <sage@newdream.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] vfs: introduce FS_IOC_SYNCFS to sync a single super
Message-Id: <20100826170142.e029cff5.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
References: <Pine.LNX.4.64.1008090711040.17515@cobra.newdream.net>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Aug 2010 07:33:57 -0700 (PDT)
Sage Weil <sage@newdream.net> wrote:

> Currently the only way to sync a single super_block (and not all of them 
> via sync(2)) is via the BLKFLSBUF ioctl on the block device.  That also 
> invalidates the bdev mapping, which isn't usually desireable

Actually you can do

	mount -o remount /dev/whatever

and it will sync the fs and retain caches.

> and it 
> doesn't work for non-block file systems.

And I guess remount will do that also.

>  The ability to sync a single 
> mount can be useful for both applications and administrators (e.g., when 
> other mounts on the system are hung).
> 
> Introduce a simple ioctl to sync the super associated with an open file.
> Pass any error returned by sync_filesystem() back to the user.
> 

The changelog forgot to tell us why this is a useful thing to add. 
What is the use-case?

> ---
>  fs/ioctl.c         |    9 +++++++++
>  include/linux/fs.h |    1 +
>  2 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/ioctl.c b/fs/ioctl.c
> index 2d140a7..2aabb19 100644
> --- a/fs/ioctl.c
> +++ b/fs/ioctl.c
> @@ -593,6 +593,15 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
>  	case FS_IOC_FIEMAP:
>  		return ioctl_fiemap(filp, arg);
>  
> +	case FS_IOC_SYNCFS:
> +	{
> +		struct super_block *sb = filp->f_dentry->d_sb;
> +		down_read(&sb->s_umount);
> +		error = sync_filesystem(sb);
> +		up_read(&sb->s_umount);
> +		break;
> +	}
> +

`mount -o remount' is surely a Linux-specific side-effect and there's
really no guarantee that Linux will always retain that side-effect. 
OTOH FS_IOC_SYNCFS is linux-specific.

If we're going to add something like this then it will need to be
documented in manpages.  Supposedly, a cc to linux-api@vger.kernel.org
will help make all that happen, but I'm not sure who if anyone is
answering the phone over there?

