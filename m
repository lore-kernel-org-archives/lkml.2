Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674Ab1GIUkd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 16:40:33 -0400
Received: from fieldses.org ([174.143.236.118]:40789 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518Ab1GIUka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 16:40:30 -0400
Date: Sat, 9 Jul 2011 16:40:25 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@kernel.org
Subject: Re: [PATCH] fs: fix lock initialization
Message-ID: <20110709204025.GA19365@fieldses.org>
References: <87iprf3dgs.fsf@tucsk.pomaz.szeredi.hu>
 <20110706182154.GB31214@fieldses.org>
 <87k4bu2y0k.fsf@tucsk.pomaz.szeredi.hu>
 <87fwmi2vvi.fsf@tucsk.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fwmi2vvi.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 07, 2011 at 01:06:09PM +0200, Miklos Szeredi wrote:
> Miklos Szeredi <miklos@szeredi.hu> writes:
> 
> > "J. Bruce Fields" <bfields@fieldses.org> writes:
> >
> >> On Wed, Jul 06, 2011 at 12:33:55PM +0200, Miklos Szeredi wrote:
> >>> From: Miklos Szeredi <mszeredi@suse.cz>
> >>> 
> >>> locks_alloc_lock() assumed that the allocated struct file_lock is
> >>> already initialized to zero members.  This is only true for the first
> >>> allocation of the structure, after reuse some of the members will have
> >>> random values.
> >>> 
> >>> This will for example result in passing random fl_start values to
> >>> userspace in fuse for FL_FLOCK locks, which is an information leak at
> >>> best.
> >>> 
> >>> Fix by reinitializing those members which may be non-zero after freeing.
> >>
> >> Could you also just get rid of init_once() while you're at it?
> >
> > Sure.  Updated patch below.
> 
> Oh, the original was already applied.  Here's the incremental, if you
> still want it.

Sure, I'll queue it up with nfsd stuff if noone else takes it.

Is there any reason file locks should use a slab cache at all, actually?

The three different lock types (posix, flock, lease) don't each use all
the fields of "struct file_lock", and it might be clearer to reduce
struct file_lock to the minimal common fields and define posix locks,
flocks, and leases as separate structures embedding a file_lock.  (Well,
and then I suppose they could each get their own slab cache if someone
really though it mattered.)

--b.

> 
> Thanks,
> Miklos
> ----
> 
> 
> Subject: fs: locks: remove init_once
> 
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Remove SLAB initialization entirely, as suggested by Bruce and Linus.
> Allocate with __GFP_ZERO instead and only initialize list heads.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/locks.c |   41 ++++++++++-------------------------------
>  1 file changed, 10 insertions(+), 31 deletions(-)
> 
> Index: linux-2.6/fs/locks.c
> ===================================================================
> --- linux-2.6.orig/fs/locks.c	2011-07-07 13:03:49.000000000 +0200
> +++ linux-2.6/fs/locks.c	2011-07-07 13:03:58.000000000 +0200
> @@ -160,26 +160,20 @@ EXPORT_SYMBOL_GPL(unlock_flocks);
>  
>  static struct kmem_cache *filelock_cache __read_mostly;
>  
> -static void locks_init_lock_always(struct file_lock *fl)
> +static void locks_init_lock_heads(struct file_lock *fl)
>  {
> -	fl->fl_next = NULL;
> -	fl->fl_fasync = NULL;
> -	fl->fl_owner = NULL;
> -	fl->fl_pid = 0;
> -	fl->fl_nspid = NULL;
> -	fl->fl_file = NULL;
> -	fl->fl_flags = 0;
> -	fl->fl_type = 0;
> -	fl->fl_start = fl->fl_end = 0;
> +	INIT_LIST_HEAD(&fl->fl_link);
> +	INIT_LIST_HEAD(&fl->fl_block);
> +	init_waitqueue_head(&fl->fl_wait);
>  }
>  
>  /* Allocate an empty lock structure. */
>  struct file_lock *locks_alloc_lock(void)
>  {
> -	struct file_lock *fl = kmem_cache_alloc(filelock_cache, GFP_KERNEL);
> +	struct file_lock *fl = kmem_cache_zalloc(filelock_cache, GFP_KERNEL);
>  
>  	if (fl)
> -		locks_init_lock_always(fl);
> +		locks_init_lock_heads(fl);
>  
>  	return fl;
>  }
> @@ -215,27 +209,12 @@ EXPORT_SYMBOL(locks_free_lock);
>  
>  void locks_init_lock(struct file_lock *fl)
>  {
> -	INIT_LIST_HEAD(&fl->fl_link);
> -	INIT_LIST_HEAD(&fl->fl_block);
> -	init_waitqueue_head(&fl->fl_wait);
> -	fl->fl_ops = NULL;
> -	fl->fl_lmops = NULL;
> -	locks_init_lock_always(fl);
> +	memset(fl, 0, sizeof(struct file_lock));
> +	locks_init_lock_heads(fl);
>  }
>  
>  EXPORT_SYMBOL(locks_init_lock);
>  
> -/*
> - * Initialises the fields of the file lock which are invariant for
> - * free file_locks.
> - */
> -static void init_once(void *foo)
> -{
> -	struct file_lock *lock = (struct file_lock *) foo;
> -
> -	locks_init_lock(lock);
> -}
> -
>  static void locks_copy_private(struct file_lock *new, struct file_lock *fl)
>  {
>  	if (fl->fl_ops) {
> @@ -2333,8 +2312,8 @@ EXPORT_SYMBOL(lock_may_write);
>  static int __init filelock_init(void)
>  {
>  	filelock_cache = kmem_cache_create("file_lock_cache",
> -			sizeof(struct file_lock), 0, SLAB_PANIC,
> -			init_once);
> +			sizeof(struct file_lock), 0, SLAB_PANIC, NULL);
> +
>  	return 0;
>  }
>  
