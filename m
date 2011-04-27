Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758627Ab1D0PJp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 11:09:45 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:42549 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754972Ab1D0PJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 11:09:43 -0400
Date: Wed, 27 Apr 2011 16:09:40 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Delete non-atomic mm counter implementation
Message-ID: <20110427160940.0493f24f@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1303914965-868-1-git-send-email-matt@console-pimps.org>
References: <1303914965-868-1-git-send-email-matt@console-pimps.org>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Oops! Replying with the correct linux-mm address]

On Wed, 27 Apr 2011 15:36:05 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> The problem with having two different types of counters is that
> developers adding new code need to keep in mind whether it's safe to
> use both the atomic and non-atomic implementations. For example, when
> adding new callers of the *_mm_counter() functions a developer needs
> to ensure that those paths are always executed with page_table_lock
> held, in case we're using the non-atomic implementation of mm
> counters.
> 
> Hugh Dickins introduced the atomic mm counters in commit f412ac08c986
> ("[PATCH] mm: fix rss and mmlist locking"). When asked why he left the
> non-atomic counters around he said,
> 
>   | The only reason was to avoid adding costly atomic operations into a
>   | configuration that had no need for them there: the page_table_lock
>   | sufficed.
>   |
>   | Certainly it would be simpler just to delete the non-atomic variant.
>   |
>   | And I think it's fair to say that any configuration on which we're
>   | measuring performance to that degree (rather than "does it boot fast?"
>   | type measurements), would already be going the split ptlocks route.
> 
> Removing the non-atomic counters eases the maintenance burden because
> developers no longer have to mindful of the two implementations when
> using *_mm_counter().
> 
> Note that all architectures provide a means of atomically updating
> atomic_long_t variables, even if they have to revert to the generic
> spinlock implementation because they don't support 64-bit atomic
> instructions (see lib/atomic64.c).
> 
> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>
> ---
> 
> Dave, you might want to take this into your pagetable counters series
> so that you only need to worry about atomic mm counters.
> 
>  include/linux/mm.h       |   44 +++++++-------------------------------------
>  include/linux/mm_types.h |    9 +++------
>  2 files changed, 10 insertions(+), 43 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd87a78..ee64af2 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1034,65 +1034,35 @@ int __get_user_pages_fast(unsigned long start, int nr_pages, int write,
>  /*
>   * per-process(per-mm_struct) statistics.
>   */
> -#if defined(SPLIT_RSS_COUNTING)
> -/*
> - * The mm counters are not protected by its page_table_lock,
> - * so must be incremented atomically.
> - */
>  static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
>  {
>  	atomic_long_set(&mm->rss_stat.count[member], value);
>  }
>  
> +#if defined(SPLIT_RSS_COUNTING)
>  unsigned long get_mm_counter(struct mm_struct *mm, int member);
> -
> -static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
> -{
> -	atomic_long_add(value, &mm->rss_stat.count[member]);
> -}
> -
> -static inline void inc_mm_counter(struct mm_struct *mm, int member)
> -{
> -	atomic_long_inc(&mm->rss_stat.count[member]);
> -}
> -
> -static inline void dec_mm_counter(struct mm_struct *mm, int member)
> -{
> -	atomic_long_dec(&mm->rss_stat.count[member]);
> -}
> -
> -#else  /* !USE_SPLIT_PTLOCKS */
> -/*
> - * The mm counters are protected by its page_table_lock,
> - * so can be incremented directly.
> - */
> -static inline void set_mm_counter(struct mm_struct *mm, int member, long value)
> -{
> -	mm->rss_stat.count[member] = value;
> -}
> -
> +#else
>  static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
>  {
> -	return mm->rss_stat.count[member];
> +	return atomic_long_read(&mm->rss_stat.count[member]);
>  }
> +#endif
>  
>  static inline void add_mm_counter(struct mm_struct *mm, int member, long value)
>  {
> -	mm->rss_stat.count[member] += value;
> +	atomic_long_add(value, &mm->rss_stat.count[member]);
>  }
>  
>  static inline void inc_mm_counter(struct mm_struct *mm, int member)
>  {
> -	mm->rss_stat.count[member]++;
> +	atomic_long_inc(&mm->rss_stat.count[member]);
>  }
>  
>  static inline void dec_mm_counter(struct mm_struct *mm, int member)
>  {
> -	mm->rss_stat.count[member]--;
> +	atomic_long_dec(&mm->rss_stat.count[member]);
>  }
>  
> -#endif /* !USE_SPLIT_PTLOCKS */
> -
>  static inline unsigned long get_mm_rss(struct mm_struct *mm)
>  {
>  	return get_mm_counter(mm, MM_FILEPAGES) +
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index ca01ab2..b8ca318 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -205,19 +205,16 @@ enum {
>  
>  #if USE_SPLIT_PTLOCKS && defined(CONFIG_MMU)
>  #define SPLIT_RSS_COUNTING
> -struct mm_rss_stat {
> -	atomic_long_t count[NR_MM_COUNTERS];
> -};
>  /* per-thread cached information, */
>  struct task_rss_stat {
>  	int events;	/* for synchronization threshold */
>  	int count[NR_MM_COUNTERS];
>  };
> -#else  /* !USE_SPLIT_PTLOCKS */
> +#endif /* USE_SPLIT_PTLOCKS */
> +
>  struct mm_rss_stat {
> -	unsigned long count[NR_MM_COUNTERS];
> +	atomic_long_t count[NR_MM_COUNTERS];
>  };
> -#endif /* !USE_SPLIT_PTLOCKS */
>  
>  struct mm_struct {
>  	struct vm_area_struct * mmap;		/* list of VMAs */



-- 
Matt Fleming, Intel Open Source Technology Center
