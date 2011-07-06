Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257Ab1GFSV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 14:21:57 -0400
Received: from fieldses.org ([174.143.236.118]:50726 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754530Ab1GFSV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 14:21:56 -0400
Date: Wed, 6 Jul 2011 14:21:54 -0400
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org
Subject: Re: [PATCH] fs: fix lock initialization
Message-ID: <20110706182154.GB31214@fieldses.org>
References: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 12:33:55PM +0200, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> locks_alloc_lock() assumed that the allocated struct file_lock is
> already initialized to zero members.  This is only true for the first
> allocation of the structure, after reuse some of the members will have
> random values.
> 
> This will for example result in passing random fl_start values to
> userspace in fuse for FL_FLOCK locks, which is an information leak at
> best.
> 
> Fix by reinitializing those members which may be non-zero after freeing.

Could you also just get rid of init_once() while you're at it?

--b.

> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> CC: stable@kernel.org
> ---
>  fs/locks.c |   30 ++++++++++++++++++++----------
>  1 file changed, 20 insertions(+), 10 deletions(-)
> 
> Index: linux-2.6/fs/locks.c
> ===================================================================
> --- linux-2.6.orig/fs/locks.c	2011-07-04 17:06:01.000000000 +0200
> +++ linux-2.6/fs/locks.c	2011-07-04 17:06:04.000000000 +0200
> @@ -160,10 +160,28 @@ EXPORT_SYMBOL_GPL(unlock_flocks);
>  
>  static struct kmem_cache *filelock_cache __read_mostly;
>  
> +static void locks_init_lock_always(struct file_lock *fl)
> +{
> +	fl->fl_next = NULL;
> +	fl->fl_fasync = NULL;
> +	fl->fl_owner = NULL;
> +	fl->fl_pid = 0;
> +	fl->fl_nspid = NULL;
> +	fl->fl_file = NULL;
> +	fl->fl_flags = 0;
> +	fl->fl_type = 0;
> +	fl->fl_start = fl->fl_end = 0;
> +}
> +
>  /* Allocate an empty lock structure. */
>  struct file_lock *locks_alloc_lock(void)
>  {
> -	return kmem_cache_alloc(filelock_cache, GFP_KERNEL);
> +	struct file_lock *fl = kmem_cache_alloc(filelock_cache, GFP_KERNEL);
> +
> +	if (fl)
> +		locks_init_lock_always(fl);
> +
> +	return fl;
>  }
>  EXPORT_SYMBOL_GPL(locks_alloc_lock);
>  
> @@ -200,17 +218,9 @@ void locks_init_lock(struct file_lock *f
>  	INIT_LIST_HEAD(&fl->fl_link);
>  	INIT_LIST_HEAD(&fl->fl_block);
>  	init_waitqueue_head(&fl->fl_wait);
> -	fl->fl_next = NULL;
> -	fl->fl_fasync = NULL;
> -	fl->fl_owner = NULL;
> -	fl->fl_pid = 0;
> -	fl->fl_nspid = NULL;
> -	fl->fl_file = NULL;
> -	fl->fl_flags = 0;
> -	fl->fl_type = 0;
> -	fl->fl_start = fl->fl_end = 0;
>  	fl->fl_ops = NULL;
>  	fl->fl_lmops = NULL;
> +	locks_init_lock_always(fl);
>  }
>  
>  EXPORT_SYMBOL(locks_init_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
