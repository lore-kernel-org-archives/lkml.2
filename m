Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab2FRUBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:01:42 -0400
Received: from fieldses.org ([174.143.236.118]:35451 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2FRUBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:01:41 -0400
Date: Mon, 18 Jun 2012 16:01:31 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Filipe Brandenburger <filbranden@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] locks: prevent side-effects of
 locks_release_private before file_lock is initialized
Message-ID: <20120618200131.GA12351@fieldses.org>
References: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
 <1339815965-1171-2-git-send-email-filbranden@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339815965-1171-2-git-send-email-filbranden@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 11:06:05PM -0400, Filipe Brandenburger wrote:
> When calling fcntl(F_SETLEASE) for a second time on the same fd, do_fcntl_add_lease
> will allocate and initialize a new file_lock, then if __vfs_setlease decides to
> reuse the existing file_lock it will free the newly allocated one to prevent leaking
> memory.
> 
> However, the new file_lock was initialized to the point where it has a valid file
> descriptor pointer and lmops, so calling locks_free_lock will trigger a call to
> lease_release_private_callback which will have the side effect of clearing the
> fcntl(F_SETOWN) and fcntl(F_SETSIG) settings for the file descriptor even though
> that was not supposed to happen at that point.
> 
> This patch will fix this by calling kmem_cache_free(filelock_cache, fl) instead of
> locks_free_lock(fl) if the file_lock is not completely initialized and actually
> associated to the file descriptor, avoiding the call to lease_release_private_callback
> with the undesired side effects.

Thanks for catching this!

The result doesn't feel entirely obvious to me.  We could consolidate
the two kmem_cache_free calls and add a comment saying why we're not
calling locks_free_lock().

But clearest might be to separate allocation and initialization and
delay the latter till we know we're going to need it?

--b.

> 
> Signed-off-by: Filipe Brandenburger <filbranden@gmail.com>
> ---
>  fs/locks.c |    8 ++++----
>  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/locks.c b/fs/locks.c
> index 814c51d..ce57c59 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -473,7 +473,7 @@ static struct file_lock *lease_alloc(struct file *filp, int type)
>  
>  	error = lease_init(filp, type, fl);
>  	if (error) {
> -		locks_free_lock(fl);
> +		kmem_cache_free(filelock_cache, fl);
>  		return ERR_PTR(error);
>  	}
>  	return fl;
> @@ -1538,7 +1538,7 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
>  
>  	new = fasync_alloc();
>  	if (!new) {
> -		locks_free_lock(fl);
> +		kmem_cache_free(filelock_cache, fl);
>  		return -ENOMEM;
>  	}
>  	ret = fl;
> @@ -1546,11 +1546,11 @@ static int do_fcntl_add_lease(unsigned int fd, struct file *filp, long arg)
>  	error = __vfs_setlease(filp, arg, &ret);
>  	if (error) {
>  		unlock_flocks();
> -		locks_free_lock(fl);
> +		kmem_cache_free(filelock_cache, fl);
>  		goto out_free_fasync;
>  	}
>  	if (ret != fl)
> -		locks_free_lock(fl);
> +		kmem_cache_free(filelock_cache, fl);
>  
>  	/*
>  	 * fasync_insert_entry() returns the old entry if any.
> -- 
> 1.7.7.6
> 
