Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1F2Sld (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:41:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:44654 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752272Ab1F2Slb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:41:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,444,1304319600"; 
   d="scan'208";a="19802114"
Message-ID: <4E0B71D5.9010204@linux.intel.com>
Date: Wed, 29 Jun 2011 11:41:25 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Shawn Bohrer <sbohrer@rgmadvisors.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, peterz@infradead.org,
        eric.dumazet@gmail.com, david@rgmadvisors.com,
        linux-kernel@vger.kernel.org, zvonler@rgmadvisors.com,
        hughd@google.com, tglx@linutronix.de, mingo@elte.hu
Subject: Re: [PATCH v4] futex: Fix regression with read only mappings
References: <4E0A6A0F.9020004@linux.intel.com> <1309360644-24079-1-git-send-email-sbohrer@rgmadvisors.com>
In-Reply-To: <1309360644-24079-1-git-send-email-sbohrer@rgmadvisors.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/29/2011 08:17 AM, Shawn Bohrer wrote:
> commit 7485d0d3758e8e6491a5c9468114e74dc050785d (futexes: Remove rw
> parameter from get_futex_key()) in 2.6.33 introduced a user-mode
> regression in that it additionally prevented futex operations on a
> region within a read only memory mapped file.  For example this breaks
> workloads that have one or more reader processes doing a FUTEX_WAIT on a
> futex within a read only shared mapping, and a writer processes that has
> a writable mapping issuing the FUTEX_WAKE.
> 
> This fixes the regression for futex operations that should be valid on
> RO mappings by trying a RO get_user_pages_fast() when the RW
> get_user_pages_fast() fails so as not to slow down the common path of
> writable anonymous maps and bailing when we used the RO path on
> anonymous memory.
> 
> While fixing the regression this patch opens up a possible bad
> scenarios as identified by KOSAKI Motohiro:
> 
> This patch also allows FUTEX_WAIT on RO private mappings which have
> the following corner case.
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
> This Patch is based on Peter Zijlstra's initial patch with modifications to
> only allow RO mappings for futex operations that need VERIFY_READ access.
> 
> Reported-by: David Oliver <david@rgmadvisors.com>
> Signed-off-by: Shawn Bohrer <sbohrer@rgmadvisors.com>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
> 
> Included Darren Hart's fix to infinite loop in kernel on zero page.


Thanks for sticking with it Shawn!

Signed-off-by: Darren Hart <dvhart@linux.intel.com>


>  kernel/futex.c |   57 ++++++++++++++++++++++++++++++++++++++++++-------------
>  1 files changed, 43 insertions(+), 14 deletions(-)
> 
> diff --git a/kernel/futex.c b/kernel/futex.c
> index fe28dc2..d919cc0 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -75,6 +75,7 @@ int __read_mostly futex_cmpxchg_enabled;
>  #define FLAGS_SHARED		0x01
>  #define FLAGS_CLOCKRT		0x02
>  #define FLAGS_HAS_TIMEOUT	0x04
> +#define FLAGS_RO		0x08
>  
>  /*
>   * Priority Inheritance state:
> @@ -216,7 +217,7 @@ static void drop_futex_key_refs(union futex_key *key)
>  /**
>   * get_futex_key() - Get parameters which are the keys for a futex
>   * @uaddr:	virtual address of the futex
> - * @fshared:	0 for a PROCESS_PRIVATE futex, 1 for PROCESS_SHARED
> + * @flags:	futex flags: FLAGS_SHARED and FLAGS_RO are valid.
>   * @key:	address where result is stored.
>   *
>   * Returns a negative error code or 0
> @@ -229,12 +230,12 @@ static void drop_futex_key_refs(union futex_key *key)
>   * lock_page() might sleep, the caller should not hold a spinlock.
>   */
>  static int
> -get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
> +get_futex_key(u32 __user *uaddr, unsigned int flags, union futex_key *key)
>  {
>  	unsigned long address = (unsigned long)uaddr;
>  	struct mm_struct *mm = current->mm;
>  	struct page *page, *page_head;
> -	int err;
> +	int err, ro = 0;
>  
>  	/*
>  	 * The futex address must be "naturally" aligned.
> @@ -251,7 +252,7 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  	 * Note : We do have to check 'uaddr' is a valid user address,
>  	 *        but access_ok() should be faster than find_vma()
>  	 */
> -	if (!fshared) {
> +	if (!(flags & FLAGS_SHARED)) {
>  		if (unlikely(!access_ok(VERIFY_WRITE, uaddr, sizeof(u32))))
>  			return -EFAULT;
>  		key->private.mm = mm;
> @@ -262,8 +263,18 @@ get_futex_key(u32 __user *uaddr, int fshared, union futex_key *key)
>  
>  again:
>  	err = get_user_pages_fast(address, 1, 1, &page);
> +        /*
> +         * If write access is not required (eg. FUTEX_WAIT), try
> +         * and get read-only access.
> +         */
> +	if (err == -EFAULT && flags & FLAGS_RO) {
> +		err = get_user_pages_fast(address, 1, 0, &page);
> +		ro = 1;
> +	}
>  	if (err < 0)
>  		return err;
> +	else
> +		err = 0;
>  
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>  	page_head = page;
> @@ -305,6 +316,13 @@ again:
>  	if (!page_head->mapping) {
>  		unlock_page(page_head);
>  		put_page(page_head);
> +		/*
> +		* ZERO_PAGE pages don't have a mapping. Avoid a busy loop
> +		* trying to find one. RW mapping would have COW'd (and thus
> +		* have a mapping) so this page is RO and won't ever change.
> +		*/
> +		if ((page_head == ZERO_PAGE(address)))
> +			return -EFAULT;
>  		goto again;
>  	}
>  
> @@ -316,6 +334,15 @@ again:
>  	 * the object not the particular process.
>  	 */
>  	if (PageAnon(page_head)) {
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
> @@ -327,9 +354,10 @@ again:
>  
>  	get_futex_key_refs(key);
>  
> +out:
>  	unlock_page(page_head);
>  	put_page(page_head);
> -	return 0;
> +	return err;
>  }
>  
>  static inline void put_futex_key(union futex_key *key)
> @@ -940,7 +968,7 @@ futex_wake(u32 __user *uaddr, unsigned int flags, int nr_wake, u32 bitset)
>  	if (!bitset)
>  		return -EINVAL;
>  
> -	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
> +	ret = get_futex_key(uaddr, flags | FLAGS_RO, &key);

>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -986,10 +1014,10 @@ futex_wake_op(u32 __user *uaddr1, unsigned int flags, u32 __user *uaddr2,
>  	int ret, op_ret;
>  
>  retry:
> -	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
> +	ret = get_futex_key(uaddr1, flags | FLAGS_RO, &key1);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
> +	ret = get_futex_key(uaddr2, flags, &key2);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
>  
> @@ -1243,10 +1271,11 @@ retry:
>  		pi_state = NULL;
>  	}
>  
> -	ret = get_futex_key(uaddr1, flags & FLAGS_SHARED, &key1);
> +	ret = get_futex_key(uaddr1, flags | FLAGS_RO, &key1);
>  	if (unlikely(ret != 0))
>  		goto out;
> -	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
> +	ret = get_futex_key(uaddr2, requeue_pi ? flags : flags | FLAGS_RO,
> +	                    &key2);
>  	if (unlikely(ret != 0))
>  		goto out_put_key1;
>  
> @@ -1790,7 +1819,7 @@ static int futex_wait_setup(u32 __user *uaddr, u32 val, unsigned int flags,
>  	 * while the syscall executes.
>  	 */
>  retry:
> -	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q->key);
> +	ret = get_futex_key(uaddr, flags | FLAGS_RO, &q->key);
>  	if (unlikely(ret != 0))
>  		return ret;
>  
> @@ -1941,7 +1970,7 @@ static int futex_lock_pi(u32 __user *uaddr, unsigned int flags, int detect,
>  	}
>  
>  retry:
> -	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &q.key);
> +	ret = get_futex_key(uaddr, flags, &q.key);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -2060,7 +2089,7 @@ retry:
>  	if ((uval & FUTEX_TID_MASK) != vpid)
>  		return -EPERM;
>  
> -	ret = get_futex_key(uaddr, flags & FLAGS_SHARED, &key);
> +	ret = get_futex_key(uaddr, flags, &key);
>  	if (unlikely(ret != 0))
>  		goto out;
>  
> @@ -2249,7 +2278,7 @@ static int futex_wait_requeue_pi(u32 __user *uaddr, unsigned int flags,
>  	debug_rt_mutex_init_waiter(&rt_waiter);
>  	rt_waiter.task = NULL;
>  
> -	ret = get_futex_key(uaddr2, flags & FLAGS_SHARED, &key2);
> +	ret = get_futex_key(uaddr2, flags, &key2);
>  	if (unlikely(ret != 0))
>  		goto out;
>  

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
