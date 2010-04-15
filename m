Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0DOOtQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 10:49:16 -0400
Received: from fogou.chygwyn.com ([195.171.2.24]:52091 "EHLO fogou.chygwyn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab0DOOtP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 10:49:15 -0400
Subject: Re: [PATCH 2/2] [RFC] Remove BKL from fs/locks.c
From: Steven Whitehouse <steve@chygwyn.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Matthew Wilcox <willy@linux.intel.com>, Christoph Hellwig <hch@lst.de>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <1271277384-7627-2-git-send-email-arnd@arndb.de>
References: <1271277384-7627-1-git-send-email-arnd@arndb.de>
	 <1271277384-7627-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain
Organization: ChyGwyn Limited (Registered in England and Wales, No.
 03887683) Registered Office: Digital Technium, Singleton Park, Swansea. SA2
 8PP
Date: Thu, 15 Apr 2010 15:48:51 +0100
Message-Id: <1271342931.7196.120.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.4 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some comments...

On Wed, 2010-04-14 at 22:36 +0200, Arnd Bergmann wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> I've taken a patch originally written by Matthew Wilcox and
> ported it to the current version. It seems that there were
> originally concerns that this breaks NFS, but since Trond
> has recently removed the BKL from NFS, my naive assumption
> would be that it's all good now, despite not having tried to
> understand what it does.
[snip]
>  fs/locks.c |  110 ++++++++++++++++++++++++++++++++++++------------------------
>  1 files changed, 66 insertions(+), 44 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index ab24d49..87f1c60 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -140,9 +140,23 @@ int lease_break_time = 45;
>  #define for_each_lock(inode, lockp) \
>  	for (lockp = &inode->i_flock; *lockp != NULL; lockp = &(*lockp)->fl_next)
>  
> +/*
> + * Protects the two list heads below, plus the inode->i_flock list
> + */
> +static DEFINE_SPINLOCK(file_lock_lock);
>  static LIST_HEAD(file_lock_list);
>  static LIST_HEAD(blocked_list);
>  
> +static inline void lock_flocks(void)
> +{
> +	spin_lock(&file_lock_lock);
> +}
> +
> +static inline void unlock_flocks(void)
> +{
> +	spin_unlock(&file_lock_lock);
> +}
> +
>  static struct kmem_cache *filelock_cache __read_mostly;
>  
Why not just put the spin lock calls inline?

[snip]
>  	for_each_lock(inode, before) {
>  		struct file_lock *fl = *before;
>  		if (IS_POSIX(fl))
> @@ -767,8 +779,11 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
>  	 * If a higher-priority process was blocked on the old file lock,
>  	 * give it the opportunity to lock the file.
>  	 */
> -	if (found)
> +	if (found) {
> +		unlock_flocks();
>  		cond_resched();
> +		lock_flocks();
> +	}
>  
Use cond_resched_lock() here perhaps?

[snip]

> @@ -1341,7 +1358,7 @@ int fcntl_getlease(struct file *filp)
>   *	The (input) flp->fl_lmops->fl_break function is required
>   *	by break_lease().
>   *
> - *	Called with kernel lock held.
> + *	Called with file_lock_lock held.
>   */
>  int generic_setlease(struct file *filp, long arg, struct file_lock **flp)
>  {
> @@ -1436,7 +1453,15 @@ out:
>  }
>  EXPORT_SYMBOL(generic_setlease);
>  
> - /**
> +static int __vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
> +{
> +	if (filp->f_op && filp->f_op->setlease)
> +		return filp->f_op->setlease(filp, arg, lease);
> +	else
> +		return generic_setlease(filp, arg, lease);
> +}
> +
> +/**
>   *	vfs_setlease        -       sets a lease on an open file
>   *	@filp: file pointer
>   *	@arg: type of lease to obtain
> @@ -1467,12 +1492,9 @@ int vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
>  {
>  	int error;
>  
> -	lock_kernel();
> -	if (filp->f_op && filp->f_op->setlease)
> -		error = filp->f_op->setlease(filp, arg, lease);
> -	else
> -		error = generic_setlease(filp, arg, lease);
> -	unlock_kernel();
> +	lock_flocks();
> +	error = __vfs_setlease(filp, arg, lease);
> +	unlock_flocks();
>  
This looks to me like generic_setlease() or whatever fs specific
->setlease() there might be will be called under a spin lock. That
doesn't look right to me.

Rather than adding locking here, why not push the BKL down into
generic_setlease() and ->setlease() first, and then eliminate it on a
case by case basis later on? That is the pattern that has been followed
elsewhere in the kernel.

I might have some further comment on this, but thats as far as I've got
at the moment,

Steve.


