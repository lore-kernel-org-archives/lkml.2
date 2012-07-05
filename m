Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933207Ab2GEWm7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 18:42:59 -0400
Received: from fieldses.org ([174.143.236.118]:38127 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932368Ab2GEWm6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 18:42:58 -0400
Date: Thu, 5 Jul 2012 18:42:51 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Filipe Brandenburger <filbranden@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] locks: prevent side-effects of
 locks_release_private before file_lock is initialized
Message-ID: <20120705224251.GH3051@fieldses.org>
References: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
 <1340761848-1352-1-git-send-email-filbranden@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340761848-1352-1-git-send-email-filbranden@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 09:50:48PM -0400, Filipe Brandenburger wrote:
> When calling fcntl(F_SETLEASE) for a second time on the same file descriptor,
> do_fcntl_add_lease will allocate and initialize a new file_lock to pass to
> __vfs_setlease. If that function decides to reuse the existing file_lock, it
> will free the newly allocated one to prevent leaking memory.
> 
> However, the newly allocate file_lock was initialized with a valid file
> descriptor pointer and fl_lmops that contains a lm_release_private function,
> so calling locks_free_lock will trigger a call to lease_release_private_callback
> which will clear the fcntl(F_SETOWN) and fcntl(F_SETSIG) settings for the file
> descriptor even though the lease is not really being cleared at that point (as
> only the temporary file_lock is being freed.)
> 
> This patch will fix this bug by calling kmem_cache_free directly instead of
> locks_free_lock if the file_lock will not be used. This will end up avoiding
> the call to lease_release_private_callback.
> 
> This bug was tracked in kernel.org Bugzilla database:
> https://bugzilla.kernel.org/show_bug.cgi?id=43336
> 
> Signed-off-by: Filipe Brandenburger <filbranden@gmail.com>
> ---
>  fs/locks.c |   22 +++++++++++++++++-----
>  1 files changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 814c51d..2a751d8 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -473,7 +473,10 @@ static struct file_lock *lease_alloc(struct file *filp, int type)
>  
>  	error = lease_init(filp, type, fl);
>  	if (error) {
> -		locks_free_lock(fl);
> +		/* Free the lock by hand instead of calling locks_free_lock
> +		 * to prevent the call back to lease_release_private_callback
> +		 */
> +		kmem_cache_free(filelock_cache, fl);
>  		return ERR_PTR(error);
>  	}
>  	return fl;
> @@ -1538,19 +1541,28 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
>  
>  	new = fasync_alloc();
>  	if (!new) {
> -		locks_free_lock(fl);
> +		/* Free the lock by hand instead of calling locks_free_lock
> +		 * to prevent the call back to lease_release_private_callback
> +		 */
> +		kmem_cache_free(filelock_cache, fl);
>  		return -ENOMEM;
>  	}
>  	ret = fl;
>  	lock_flocks();
>  	error = __vfs_setlease(filp, arg, &ret);
> +	if (error || ret != fl)
> +		/*
> +		 * Free the lock by hand instead of calling locks_free_lock
> +		 * to prevent the call back to lease_release_private_callback
> +		 * which will unset F_SETOWN and F_SETSIG for the file
> +		 * descriptor but that is not wanted as the lease was not
> +		 * really in use.
> +		 */
> +		kmem_cache_free(filelock_cache, fl);

Ugh, and now we end up with essentially the same comment in 3 different
places.  So maybe marking the lock somehow *was* the better idea.

--b.

>  	if (error) {
>  		unlock_flocks();
> -		locks_free_lock(fl);
>  		goto out_free_fasync;
>  	}
> -	if (ret != fl)
> -		locks_free_lock(fl);
>  
>  	/*
>  	 * fasync_insert_entry() returns the old entry if any.
> -- 
> 1.7.7.6
> 
