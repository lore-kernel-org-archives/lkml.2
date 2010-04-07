Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245Ab0DGAHF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 20:07:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932220Ab0DGAGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 20:06:25 -0400
Date: Tue, 6 Apr 2010 17:05:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       David Rientjes <rientjes@google.com>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 01/14] mm,migration: Take a reference to the anon_vma
 before migrating
Message-Id: <20100406170520.1e29648c.akpm@linux-foundation.org>
In-Reply-To: <1270224168-14775-2-git-send-email-mel@csn.ul.ie>
References: <1270224168-14775-1-git-send-email-mel@csn.ul.ie>
	<1270224168-14775-2-git-send-email-mel@csn.ul.ie>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  2 Apr 2010 17:02:35 +0100
Mel Gorman <mel@csn.ul.ie> wrote:

> rmap_walk_anon() does not use page_lock_anon_vma() for looking up and
> locking an anon_vma and it does not appear to have sufficient locking to
> ensure the anon_vma does not disappear from under it.
> 
> This patch copies an approach used by KSM to take a reference on the
> anon_vma while pages are being migrated. This should prevent rmap_walk()
> running into nasty surprises later because anon_vma has been freed.
> 

The code didn't exactly bend over backwards making itself easy for
others to understand...

> 
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index d25bd22..567d43f 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -29,6 +29,9 @@ struct anon_vma {
>  #ifdef CONFIG_KSM
>  	atomic_t ksm_refcount;
>  #endif
> +#ifdef CONFIG_MIGRATION
> +	atomic_t migrate_refcount;
> +#endif

Some documentation here describing the need for this thing and its
runtime semantics would be appropriate.

>  	/*
>  	 * NOTE: the LSB of the head.next is set by
>  	 * mm_take_all_locks() _after_ taking the above lock. So the
> @@ -81,6 +84,26 @@ static inline int ksm_refcount(struct anon_vma *anon_vma)
>  	return 0;
>  }
>  #endif /* CONFIG_KSM */
> +#ifdef CONFIG_MIGRATION
> +static inline void migrate_refcount_init(struct anon_vma *anon_vma)
> +{
> +	atomic_set(&anon_vma->migrate_refcount, 0);
> +}
> +
> +static inline int migrate_refcount(struct anon_vma *anon_vma)
> +{
> +	return atomic_read(&anon_vma->migrate_refcount);
> +}
> +#else
> +static inline void migrate_refcount_init(struct anon_vma *anon_vma)
> +{
> +}
> +
> +static inline int migrate_refcount(struct anon_vma *anon_vma)
> +{
> +	return 0;
> +}
> +#endif /* CONFIG_MIGRATE */
>  
>  static inline struct anon_vma *page_anon_vma(struct page *page)
>  {
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 6903abf..06e6316 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -542,6 +542,7 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  	int rcu_locked = 0;
>  	int charge = 0;
>  	struct mem_cgroup *mem = NULL;
> +	struct anon_vma *anon_vma = NULL;
>  
>  	if (!newpage)
>  		return -ENOMEM;
> @@ -598,6 +599,8 @@ static int unmap_and_move(new_page_t get_new_page, unsigned long private,
>  	if (PageAnon(page)) {
>  		rcu_read_lock();
>  		rcu_locked = 1;
> +		anon_vma = page_anon_vma(page);
> +		atomic_inc(&anon_vma->migrate_refcount);

So no helper function for this.  I guess a grep for `migrate_refcount'
will find it OK.

Can this count ever have a value > 1?   I guess so..

>  	}
>  
>  	/*
> @@ -637,6 +640,15 @@ skip_unmap:
>  	if (rc)
>  		remove_migration_ptes(page, page);
>  rcu_unlock:
> +
> +	/* Drop an anon_vma reference if we took one */
> +	if (anon_vma && atomic_dec_and_lock(&anon_vma->migrate_refcount, &anon_vma->lock)) {
> +		int empty = list_empty(&anon_vma->head);
> +		spin_unlock(&anon_vma->lock);
> +		if (empty)
> +			anon_vma_free(anon_vma);
> +	}
> +

So...  Why shouldn't this be testing ksm_refcount() too?

Can we consolidate ksm_refcount and migrate_refcount into, err, `refcount'?

>  	if (rcu_locked)
>  		rcu_read_unlock();
>  uncharge:
> diff --git a/mm/rmap.c b/mm/rmap.c
> index fcd593c..578d0fe 100644

