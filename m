Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133Ab0ISTfy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Sep 2010 15:35:54 -0400
Received: from fieldses.org ([174.143.236.118]:44973 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab0ISTfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Sep 2010 15:35:53 -0400
Date: Sun, 19 Sep 2010 15:34:18 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>,
        Christoph Hellwig <hch@lst.de>,
        Trond Myklebust <trond.myklebust@fys.uio.no>,
        Andrew Morton <akpm@linux-foundation.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>,
        Sage Weil <sage@newdream.net>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/locks.c: prepare for BKL removal
Message-ID: <20100919193418.GF32071@fieldses.org>
References: <1284815371-5843-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284815371-5843-1-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 18, 2010 at 03:09:31PM +0200, Arnd Bergmann wrote:
> This prepares the removal of the big kernel lock from the
> file locking code. We still use the BKL as long as fs/lockd
> uses it and ceph might sleep, but we can flip the definition
> to a private spinlock as soon as that's done.
> All users outside of fs/lockd get converted to use
> lock_flocks() instead of lock_kernel() where appropriate.
> 
> Based on an earlier patch to use a spinlock from Matthew
> Wilcox, who has attempted this a few times before. An even
> earlier attempt to use a semaphore instead of the BKL
> apparently was made by Andrew Morton about ten years ago,
> but reverted for performance reasons.
> 
> Someone should do some serious performance testing when
> this becomes a spinlock, since this has caused problems
> before. Using a spinlock should be at least as good
> as the BKL in theory, but who knows...
> 
> If nobody has any objections to this preparation patch,
> I'd like to add it to my bkl/vfs tree and into -next.

Looks good to me.

>  EXPORT_SYMBOL(posix_test_lock);
> @@ -730,18 +746,16 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
>  	int error = 0;
>  	int found = 0;
>  
> -	lock_kernel();
> -	if (request->fl_flags & FL_ACCESS)
> -		goto find_conflict;
> -
> -	if (request->fl_type != F_UNLCK) {
> -		error = -ENOMEM;
> +	if (!(request->fl_flags & FL_ACCESS) && (request->fl_type != F_UNLCK)) {
>  		new_fl = locks_alloc_lock();
> -		if (new_fl == NULL)
> -			goto out;
> -		error = 0;
> +		if (!new_fl)
> +			return -ENOMEM;
>  	}
>  
> +	lock_flocks();
> +	if (request->fl_flags & FL_ACCESS)
> +		goto find_conflict;
> +

I might have left this to a separate patch, but OK.

--b.

>  	for_each_lock(inode, before) {
>  		struct file_lock *fl = *before;
>  		if (IS_POSIX(fl))
> @@ -767,8 +781,11 @@ static int flock_lock_file(struct file *filp, struct file_lock *request)
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
>  find_conflict:
>  	for_each_lock(inode, before) {
