Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755007Ab1AaHk3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 02:40:29 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:33757 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1AaHk2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 02:40:28 -0500
Date: Sun, 30 Jan 2011 23:40:24 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>, Wu Fengguang <fengguang.wu@intel.com>,
        Mel Gorman <mel@csn.ul.ie>, Rik van Riel <riel@redhat.com>
Subject: Re: [Patch] rcu: remove dead code in include/linux/pagemap.h
Message-ID: <20110131074024.GB2145@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1296455224-14065-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296455224-14065-1-git-send-email-amwang@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 31, 2011 at 02:27:04PM +0800, Amerigo Wang wrote:
> TREE_RCU depends on !PREEMPT && SMP, when !CONFIG_SMP is true, CONFIG_TREE_RCU
> will be false, thus "!defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)"
> is always false.

The relationship between these configuration parameters has indeed
changed.  But I am wondering if rather than removing these, the
conditions need to be updated as shown below.

							Thanx, Paul

> Remove these dead code.
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> ---
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 9c66e99..e2bbbe3 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -133,23 +133,6 @@ static inline int page_cache_get_speculative(struct page *page)
>  {
>  	VM_BUG_ON(in_interrupt());
> 
> -#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)

#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_PREEMPT_RCU)

/* Must have CONFIG_PREEMPT here, implied by CONFIG_TREE_PREEMPT_RCU. */

> -# ifdef CONFIG_PREEMPT
	VM_BUG_ON(!in_atomic());
> -# endif
	/*
	 * Preempt must be disabled here - we rely on rcu_read_lock doing
	 * this for us.
	 *
	 * Pagecache won't be truncated from interrupt context, so if we have
	 * found a page in the radix tree here, we have pinned its refcount by
	 * disabling preempt, and hence no need for the "speculative get" that
	 * SMP requires.
	 */
	VM_BUG_ON(page_count(page) == 0);
	atomic_inc(&page->_count);

#else
	if (unlikely(!get_page_unless_zero(page))) {
		/*
		 * Either the page has been freed, or will be freed.
> @@ -158,7 +141,6 @@ static inline int page_cache_get_speculative(struct page *page)
		 */
		return 0;
	}
#endif
>  	VM_BUG_ON(PageTail(page));
> 
>  	return 1;
> @@ -171,17 +153,9 @@ static inline int page_cache_add_speculative(struct page *page, int count)
>  {
>  	VM_BUG_ON(in_interrupt());
> 
> -#if !defined(CONFIG_SMP) && defined(CONFIG_TREE_RCU)
> -# ifdef CONFIG_PREEMPT
> -	VM_BUG_ON(!in_atomic());
> -# endif
> -	VM_BUG_ON(page_count(page) == 0);
> -	atomic_add(count, &page->_count);
> -
> -#else
>  	if (unlikely(!atomic_add_unless(&page->_count, count, 0)))
>  		return 0;
> -#endif
> +
>  	VM_BUG_ON(PageCompound(page) && page != compound_head(page));
> 
>  	return 1;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
