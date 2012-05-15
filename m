Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab2EOEjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 00:39:14 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59847 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab2EOEjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 00:39:12 -0400
Date: Mon, 14 May 2012 21:38:54 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Paul Gortmaker <paul.gortmaker@windriver.com>
cc: Peter Zijlstra <peterz@infradead.org>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [34-longterm 167/179] futex: Fix regression with read only
 mappings
In-Reply-To: <1337048075-6132-168-git-send-email-paul.gortmaker@windriver.com>
Message-ID: <alpine.LSU.2.00.1205142126180.2196@eggly.anvils>
References: <1337048075-6132-1-git-send-email-paul.gortmaker@windriver.com> <1337048075-6132-168-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2012, Paul Gortmaker wrote:
> From: Shawn Bohrer <sbohrer@rgmadvisors.com>
> 
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
> 
> commit 9ea71503a8ed9184d2d0b8ccc4d269d05f7940ae upstream.
> 
> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
> parameter from get_futex_key()) in 2.6.33 fixed two problems:  First, It
> prevented a loop when encountering a ZERO_PAGE. Second, it fixed RW
> MAP_PRIVATE futex operations by forcing the COW to occur by
> unconditionally performing a write access get_user_pages_fast() to get
> the page.  The commit also introduced a user-mode regression in that it
> broke futex operations on read-only memory maps.  For example, this
> breaks workloads that have one or more reader processes doing a
> FUTEX_WAIT on a futex within a read only shared file mapping, and a
> writer processes that has a writable mapping issuing the FUTEX_WAKE.
> 
> This fixes the regression for valid futex operations on RO mappings by
> trying a RO get_user_pages_fast() when the RW get_user_pages_fast()
> fails. This change makes it necessary to also check for invalid use
> cases, such as anonymous RO mappings (which can never change) and the
> ZERO_PAGE which the commit referenced above was written to address.
> 
> This patch does restore the original behavior with RO MAP_PRIVATE
> mappings, which have inherent user-mode usage problems and don't really
> make sense.  With this patch performing a FUTEX_WAIT within a RO
> MAP_PRIVATE mapping will be successfully woken provided another process
> updates the region of the underlying mapped file.  However, the mmap()
> man page states that for a MAP_PRIVATE mapping:
> 
>   It is unspecified whether changes made to the file after
>   the mmap() call are visible in the mapped region.
> 
> So user-mode users attempting to use futex operations on RO MAP_PRIVATE
> mappings are depending on unspecified behavior.  Additionally a
> RO MAP_PRIVATE mapping could fail to wake up in the following case.
> 
>   Thread-A: call futex(FUTEX_WAIT, memory-region-A).
>             get_futex_key() return inode based key.
>             sleep on the key
>   Thread-B: call mprotect(PROT_READ|PROT_WRITE, memory-region-A)
>   Thread-B: write memory-region-A.
>             COW happen. This process's memory-region-A become related
>             to new COWed private (ie PageAnon=1) page.
>   Thread-B: call futex(FUETX_WAKE, memory-region-A).
>             get_futex_key() return mm based key.
>             IOW, we fail to wake up Thread-A.
> 
> Once again doing something like this is just silly and users who do
> something like this get what they deserve.
> 
> While RO MAP_PRIVATE mappings are nonsensical, checking for a private
> mapping requires walking the vmas and was deemed too costly to avoid a
> userspace hang.
> 
> This Patch is based on Peter Zijlstra's initial patch with modifications to
> only allow RO mappings for futex operations that need VERIFY_READ access.
> 
> Reported-by: David Oliver <david@rgmadvisors.com>
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Cc: peterz@infradead.org
> Cc: eric.dumazet@gmail.com
> Cc: zvonler@rgmadvisors.com
> Cc: hughd@google.com
> Link: http://lkml.kernel.org/r/1309450892-30676-1-git-send-email-sbohrer@rgmadvisors.com
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> [PG: in 34, the variable is "page"; in original 9ea71503a it is page_head]
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
>  kernel/futex.c |   54 ++++++++++++++++++++++++++++++++++++++++++------------
>  1 file changed, 42 insertions(+), 12 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index e328f57..98a354d 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -203,6 +203,8 @@ static void drop_futex_key_refs(union futex_key *key)
>   * @uaddr:	virtual address of the futex
>   * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
>   * @key:	address where result is stored.
> + * @rw:		mapping needs to be read/write (values: VERIFY_READ,
> + *              VERIFY_WRITE)
>   *
>   * Returns a negative error code or 0
>   * The key words are stored in *key on success.
> @@ -214,12 +216,12 @@ static void drop_futex_key_refs(union futex_key *key)
>   * lock_page() might sleep, the caller should not hold a spinlock.
>   */
>  static int
> -get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
> +get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key, int rw)
>  {
>  	unsigned long address = (unsigned long)uaddr;
>  	struct mm_struct *mm = current->mm;
>  	struct page *page;
> -	int err;
> +	int err, ro = 0;
>  
>  	/*
>  	 * The futex address must be "naturally" aligned.
> @@ -247,14 +249,31 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  
>  again:
>  	err = get_user_pages_fast(address, 1, 1, &page);
> +	/*
> +	 * If write access is not required (eg. FUTEX_WAIT), try
> +	 * and get read-only access.
> +	 */
> +	if (err == -EFAULT && rw == VERIFY_READ) {
> +		err = get_user_pages_fast(address, 1, 0, &page);
> +		ro = 1;
> +	}
>  	if (err < 0)
>  		return err;
> +	else
> +		err = 0;
>  
>  	page = compound_head(page);
>  	lock_page(page);
>  	if (!page->mapping) {
>  		unlock_page(page);
>  		put_page(page);
> +		/*
> +		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
> +		* trying to find one. RW mapping would have COW'd (and thus
> +		* have a mapping) so this page is RO and won't ever change.
> +		*/
> +		if ((page == ZERO_PAGE(address)))
> +			return -EFAULT;
>  		goto again;
>  	}
>  
> @@ -266,6 +285,15 @@ again:
>  	 * the object not the particular process.
>  	 */
>  	if (PageAnon(page)) {
> +		/*
> +		 * A RO anonymous page will never change and thus doesn't make
> +		 * sense for futex operations.
> +		 */
> +		if (ro) {
> +			err = -EFAULT;
> +			goto out;
> +		}
> +
>  		key->both.offset |= FUT_OFF_MMSHARED; /* ref taken on mm */
>  		key->private.mm = mm;
>  		key->private.address = address;
> @@ -277,9 +305,10 @@ again:
>  
>  	get_futex_key_refs(key);
>  
> +out:
>  	unlock_page(page);
>  	put_page(page);
> -	return 0;
> +	return err;
>  }
>  
>  static inline
> @@ -880,7 +909,7 @@ static int futex_wake(u32 __user *uaddr, int fshared, int nr_wake, u32 bitset)
>  	if (!bitset)
>  		return -EINVAL;
>  
> -	ret = get_futex_key(uaddr, fshared, &key);
> +	ret = get_futex_key(uaddr, fshared, &key, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -926,10 +955,10 @@ futex_wake_op(u32 __user *uaddr1, int fshared, u32 __user *uaddr2,
>  	int ret, op_ret;
>  
>  retry:
> -	ret = get_futex_key(uaddr1, fshared, &key1);
> +	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, fshared, &key2);
> +	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
>  
> @@ -1188,10 +1217,11 @@ retry:
>  		pi_state = NULL;
>  	}
>  
> -	ret = get_futex_key(uaddr1, fshared, &key1);
> +	ret = get_futex_key(uaddr1, fshared, &key1, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, fshared, &key2);
> +	ret = get_futex_key(uaddr2, fshared, &key2,
> +			    requeue_pi ? VERIFY_WRITE : VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
>  
> @@ -1746,7 +1776,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, int fshared,
>  	 */
>  retry:
>  	q->key = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr, fshared, &q->key);
> +	ret = get_futex_key(uaddr, fshared, &q->key, VERIFY_READ);
>  	if (unlikely(ret != 0))
>  		return ret;
>  
> @@ -1912,7 +1942,7 @@ static int futex_lock_pi(u32 __user *uaddr, int fshared,
>  	q.requeue_pi_key = NULL;
>  retry:
>  	q.key = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr, fshared, &q.key);
> +	ret = get_futex_key(uaddr, fshared, &q.key, VERIFY_WRITE);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -2031,7 +2061,7 @@ retry:
>  	if ((uval & FUTEX_TID_MASK) != task_pid_vnr(current))
>  		return -EPERM;
>  
> -	ret = get_futex_key(uaddr, fshared, &key);
> +	ret = get_futex_key(uaddr, fshared, &key, VERIFY_WRITE);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -2223,7 +2253,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, int fshared,
>  	rt_waiter.task = NULL;
>  
>  	key2 = FUTEX_KEY_INIT;
> -	ret = get_futex_key(uaddr2, fshared, &key2);
> +	ret = get_futex_key(uaddr2, fshared, &key2, VERIFY_WRITE);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> -- 
> 1.7.9.6

Including this commit worries me a little, because it introduces
the ZERO_PAGE case which we later had to change.  Though I did end up
supplying the patch below, it was very much in consultation with Peter
and Linus: I'm no expert on futices, and haven't followed the history
of intervening patches between what you're including above and this one
below (and I don't see an rw arg to get_futex_key() in latest source).

I don't know: I'm not NAKking it, I'm just waving a reddish flag,
and hoping that Peter will remember more, and have something more
constructive to say, than I can think of at this moment.

Hugh

commit e6780f7243eddb133cc20ec37fa69317c218b709
Author: Hugh Dickins <hughd@google.com>
Date:   Sat Dec 31 11:44:01 2011 -0800

    futex: Fix uninterruptible loop due to gate_area
    
    It was found (by Sasha) that if you use a futex located in the gate
    area we get stuck in an uninterruptible infinite loop, much like the
    ZERO_PAGE issue.
    
    While looking at this problem, PeterZ realized you'll get into similar
    trouble when hitting any install_special_pages() mapping.  And are there
    still drivers setting up their own special mmaps without page->mapping,
    and without special VM or pte flags to make get_user_pages fail?
    
    In most cases, if page->mapping is NULL, we do not need to retry at all:
    Linus points out that even /proc/sys/vm/drop_caches poses no problem,
    because it ends up using remove_mapping(), which takes care not to
    interfere when the page reference count is raised.
    
    But there is still one case which does need a retry: if memory pressure
    called shmem_writepage in between get_user_pages_fast dropping page
    table lock and our acquiring page lock, then the page gets switched from
    filecache to swapcache (and ->mapping set to NULL) whatever the refcount.
    Fault it back in to get the page->mapping needed for key->shared.inode.
    
    Reported-by: Sasha Levin <levinsasha928@gmail.com>
    Signed-off-by: Hugh Dickins <hughd@google.com>
    Cc: stable@vger.kernel.org
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/kernel/futex.c b/kernel/futex.c
index ea87f4d..1614be2 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -314,17 +314,29 @@ again:
 #endif
 
 	lock_page(page_head);
+
+	/*
+	 * If page_head->mapping is NULL, then it cannot be a PageAnon
+	 * page; but it might be the ZERO_PAGE or in the gate area or
+	 * in a special mapping (all cases which we are happy to fail);
+	 * or it may have been a good file page when get_user_pages_fast
+	 * found it, but truncated or holepunched or subjected to
+	 * invalidate_complete_page2 before we got the page lock (also
+	 * cases which we are happy to fail).  And we hold a reference,
+	 * so refcount care in invalidate_complete_page's remove_mapping
+	 * prevents drop_caches from setting mapping to NULL beneath us.
+	 *
+	 * The case we do have to guard against is when memory pressure made
+	 * shmem_writepage move it from filecache to swapcache beneath us:
+	 * an unlikely race, but we do need to retry for page_head->mapping.
+	 */
 	if (!page_head->mapping) {
+		int shmem_swizzled = PageSwapCache(page_head);
 		unlock_page(page_head);
 		put_page(page_head);
-		/*
-		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
-		* trying to find one. RW mapping would have COW'd (and thus
-		* have a mapping) so this page is RO and won't ever change.
-		*/
-		if ((page_head == ZERO_PAGE(address)))
-			return -EFAULT;
-		goto again;
+		if (shmem_swizzled)
+			goto again;
+		return -EFAULT;
 	}
 
 	/*
