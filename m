Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0ETXqq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 May 2010 19:46:46 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:49730 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755025Ab0ETXqp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 May 2010 19:46:45 -0400
Date: Thu, 20 May 2010 18:39:42 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Dustin Kirkland <kirkland@canonical.com>,
       Ecryptfs <ecryptfs-devel@lists.launchpad.net>,
       Thomas Gleixner <tglx@linutronix.de>, John Kacur <jkacur@redhat.com>,
       Arnd Bergmann <arnd@arndb.de>, Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/8] ecryptfs: Pushdown the bkl from ioctl
Message-ID: <20100520233942.GA1086@ecryptfs>
References: <1274289855-10001-1-git-send-regression-fweisbec@gmail.com>
 <1274289855-10001-2-git-send-regression-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1274289855-10001-2-git-send-regression-fweisbec@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed May 19, 2010 at 07:24:08PM +0200, Frederic Weisbecker (fweisbec@gmail.com) was quoted:
> Pushdown the bkl to ecryptfs_ioctl.

I've been sitting on a bug fix for a while that cleans up the eCryptfs
ioctl code. eCryptfs doesn't need the BKL itself and can leave that
decision up to the lower file sytem. The patch I have written should
cover what you're trying to do here, too. I'll respond with the patch
and if you think it looks good, I'll carry it in my tree and ask Linus
to pull soon.

I reuse vfs_ioctl(), which must be exported, so I should get Al's ack.

> 
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
> Cc: Dustin Kirkland <kirkland@canonical.com>
> Cc: Ecryptfs <ecryptfs-devel@lists.launchpad.net>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: John Kacur <jkacur@redhat.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  fs/ecryptfs/file.c |   23 ++++++++++++++++++-----
>  1 files changed, 18 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/ecryptfs/file.c b/fs/ecryptfs/file.c
> index e7440a6..9352613 100644
> --- a/fs/ecryptfs/file.c
> +++ b/fs/ecryptfs/file.c
> @@ -294,12 +294,12 @@ static int ecryptfs_fasync(int fd, struct file *file, int flag)
>  	return rc;
>  }
> 
> -static int ecryptfs_ioctl(struct inode *inode, struct file *file,
> +static long ecryptfs_ioctl(struct file *file,
>  			  unsigned int cmd, unsigned long arg);
> 
>  const struct file_operations ecryptfs_dir_fops = {
>  	.readdir = ecryptfs_readdir,
> -	.ioctl = ecryptfs_ioctl,
> +	.unlocked_ioctl = ecryptfs_ioctl,
>  	.open = ecryptfs_open,
>  	.flush = ecryptfs_flush,
>  	.release = ecryptfs_release,
> @@ -315,7 +315,7 @@ const struct file_operations ecryptfs_main_fops = {
>  	.write = do_sync_write,
>  	.aio_write = generic_file_aio_write,
>  	.readdir = ecryptfs_readdir,
> -	.ioctl = ecryptfs_ioctl,
> +	.unlocked_ioctl = ecryptfs_ioctl,
>  	.mmap = generic_file_mmap,
>  	.open = ecryptfs_open,
>  	.flush = ecryptfs_flush,
> @@ -326,8 +326,8 @@ const struct file_operations ecryptfs_main_fops = {
>  };
> 
>  static int
> -ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> -	       unsigned long arg)
> +ecryptfs_ioctl_unlocked(struct inode *inode, struct file *file,
> +			unsigned int cmd, unsigned long arg)
>  {
>  	int rc = 0;
>  	struct file *lower_file = NULL;
> @@ -341,3 +341,16 @@ ecryptfs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
>  		rc = -ENOTTY;
>  	return rc;
>  }
> +
> +static long ecryptfs_ioctl(struct file *file, unsigned int cmd,
> +			   unsigned long arg)
> +{
> +	long ret;
> +	struct inode *inode = file->f_dentry->d_inode;
> +
> +	lock_kernel();
> +	ret = ecryptfs_ioctl_unlocked(inode, file, cmd, arg);
> +	unlock_kernel();
> +
> +	return ret;
> +}
> -- 
> 1.6.2.3
> 
