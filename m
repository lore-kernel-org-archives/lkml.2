Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015Ab0DAKb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 06:31:58 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:38658 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753536Ab0DAKbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 06:31:52 -0400
Subject: Re: [COUNTERPATCH] mm: avoid overflowing preempt_count() in 
 mmu_take_all_locks()
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       aarcange@redhat.com, akpm@linux-foundation.org,
       Kent Overstreet <kent.overstreet@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, tglx <tglx@linutronix.de>
In-Reply-To: <1270114817-28896-1-git-send-email-avi@redhat.com>
References: <20100330133634.2f1bf3d6@cuia.bos.redhat.com>
	 <1270114817-28896-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 01 Apr 2010 12:31:46 +0200
Message-ID: <1270117906.1653.139.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm sure you dropped Ingo and Thomas by accident.

On Thu, 2010-04-01 at 12:40 +0300, Avi Kivity wrote:
> mmu_take_all_locks() takes a spinlock for each vma, which means we increase
> the preempt count by the number of vmas in an address space.  Since the user
> controls the number of vmas, they can cause preempt_count to overflow.
> 
> Fix by making mmu_take_all_locks() only disable preemption once by making
> the spinlocks preempt-neutral.

Right, so while this will get rid of the warning it doesn't make the
code any nicer, its still a massive !preempt latency spot.

> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  mm/mmap.c |   37 +++++++++++++++++++++++++++++++++++++
>  1 files changed, 37 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 75557c6..7305510 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2442,6 +2442,12 @@ static void vm_lock_anon_vma(struct mm_struct *mm, struct anon_vma *anon_vma)
>  		 */
>  		spin_lock_nest_lock(&anon_vma->lock, &mm->mmap_sem);
>  		/*
> +		 * To avoid O(nr_vmas) preempt_disable()s, we keep each
> +		 * vma preemp_count neutral and instead disable preempt
> +		 * once per mmu_take_all_lock().
> +		 */
> +		preempt_enable();
> +		/*
>  		 * We can safely modify head.next after taking the
>  		 * anon_vma->lock. If some other vma in this mm shares
>  		 * the same anon_vma we won't take it again.
> @@ -2471,6 +2477,12 @@ static void vm_lock_mapping(struct mm_struct *mm, struct address_space *mapping)
>  		if (test_and_set_bit(AS_MM_ALL_LOCKS, &mapping->flags))
>  			BUG();
>  		spin_lock_nest_lock(&mapping->i_mmap_lock, &mm->mmap_sem);
> +		/*
> +		 * To avoid O(nr_vmas) preempt_disable()s, we keep each
> +		 * vma preemp_count neutral and instead disable preempt
> +		 * once per mmu_take_all_lock().
> +		 */
> +		preempt_enable();
>  	}
>  }
>  
> @@ -2516,6 +2528,13 @@ int mm_take_all_locks(struct mm_struct *mm)
>  
>  	mutex_lock(&mm_all_locks_mutex);
>  
> +	/*
> +	 * To avoid O(nr_vmas) preempt_disable()s, we keep each
> +	 * vma preemp_count neutral and instead disable preempt
> +	 * once per mmu_take_all_lock().
> +	 */
> +	preempt_disable();
> +
>  	for (vma = mm->mmap; vma; vma = vma->vm_next) {
>  		if (signal_pending(current))
>  			goto out_unlock;
> @@ -2558,6 +2577,12 @@ static void vm_unlock_anon_vma(struct anon_vma *anon_vma)
>  		if (!__test_and_clear_bit(0, (unsigned long *)
>  					  &anon_vma->head.next))
>  			BUG();
> +		/*
> +		 * To avoid O(nr_vmas) preempt_disable()s, we keep each
> +		 * vma preemp_count neutral and instead disable preempt
> +		 * once per mmu_take_all_lock().
> +		 */
> +		preempt_disable();
>  		spin_unlock(&anon_vma->lock);
>  	}
>  }
> @@ -2569,6 +2594,12 @@ static void vm_unlock_mapping(struct address_space *mapping)
>  		 * AS_MM_ALL_LOCKS can't change to 0 from under us
>  		 * because we hold the mm_all_locks_mutex.
>  		 */
> +		/*
> +		 * To avoid O(nr_vmas) preempt_disable()s, we keep each
> +		 * vma preemp_count neutral and instead disable preempt
> +		 * once per mmu_take_all_lock().
> +		 */
> +		preempt_disable();
>  		spin_unlock(&mapping->i_mmap_lock);
>  		if (!test_and_clear_bit(AS_MM_ALL_LOCKS,
>  					&mapping->flags))
> @@ -2596,6 +2627,12 @@ void mm_drop_all_locks(struct mm_struct *mm)
>  			vm_unlock_mapping(vma->vm_file->f_mapping);
>  	}
>  
> +	/*
> +	 * To avoid O(nr_vmas) preempt_disable()s, we keep each
> +	 * vma preemp_count neutral and instead disable preempt
> +	 * once per mmu_take_all_lock().
> +	 */
> +	preempt_enable();
>  	mutex_unlock(&mm_all_locks_mutex);
>  }
>  



