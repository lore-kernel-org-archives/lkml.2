Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab2LTCTF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 21:19:05 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56958 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTCTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 21:19:00 -0500
Subject: Re: [PATCH] mm: protect against concurrent vma expansion
From: Simon Jeons <simon.jeons@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20121204144820.GA13916@google.com>
References: <1354344987-28203-1-git-send-email-walken@google.com>
	 <20121203150110.39c204ff.akpm@linux-foundation.org>
	 <CANN689FfWVV4MyTUPKZQgQAWW9Dfdw9f0fqx98kc+USKj9g7TA@mail.gmail.com>
	 <20121203164322.b967d461.akpm@linux-foundation.org>
	 <20121204144820.GA13916@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Dec 2012 20:56:34 -0500
Message-ID: <1355968594.1415.4.camel@kernel-VirtualBox>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-12-04 at 06:48 -0800, Michel Lespinasse wrote:
> expand_stack() runs with a shared mmap_sem lock. Because of this, there
> could be multiple concurrent stack expansions in the same mm, which may
> cause problems in the vma gap update code.
> 
> I propose to solve this by taking the mm->page_table_lock around such vma
> expansions, in order to avoid the concurrency issue. We only have to worry
> about concurrent expand_stack() calls here, since we hold a shared mmap_sem
> lock and all vma modificaitons other than expand_stack() are done under
> an exclusive mmap_sem lock.

Hi Michel and Andrew,

One question.

I found that mainly callsite of expand_stack() is #PF, but it holds
mmap_sem each time before call expand_stack(), how can hold a *shared*
mmap_sem happen?

> 
> I previously tried to achieve the same effect by making sure all
> growable vmas in a given mm would share the same anon_vma, which we
> already lock here. However this turned out to be difficult - all of the
> schemes I tried for refcounting the growable anon_vma and clearing
> turned out ugly. So, I'm now proposing only the minimal fix.
> 
> The overhead of taking the page table lock during stack expansion is
> expected to be small: glibc doesn't use expandable stacks for the
> threads it creates, so having multiple growable stacks is actually
> uncommon and we don't expect the page table lock to get bounced
> between threads.
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>
> 
> ---
>  mm/mmap.c |   28 ++++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 9ed3a06242a0..2b7d9e78a569 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2069,6 +2069,18 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>  		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
>  			error = acct_stack_growth(vma, size, grow);
>  			if (!error) {
> +				/*
> +				 * vma_gap_update() doesn't support concurrent
> +				 * updates, but we only hold a shared mmap_sem
> +				 * lock here, so we need to protect against
> +				 * concurrent vma expansions.
> +				 * vma_lock_anon_vma() doesn't help here, as
> +				 * we don't guarantee that all growable vmas
> +				 * in a mm share the same root anon vma.
> +				 * So, we reuse mm->page_table_lock to guard
> +				 * against concurrent vma expansions.
> +				 */
> +				spin_lock(&vma->vm_mm->page_table_lock);
>  				anon_vma_interval_tree_pre_update_vma(vma);
>  				vma->vm_end = address;
>  				anon_vma_interval_tree_post_update_vma(vma);
> @@ -2076,6 +2088,8 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
>  					vma_gap_update(vma->vm_next);
>  				else
>  					vma->vm_mm->highest_vm_end = address;
> +				spin_unlock(&vma->vm_mm->page_table_lock);
> +
>  				perf_event_mmap(vma);
>  			}
>  		}
> @@ -2126,11 +2140,25 @@ int expand_downwards(struct vm_area_struct *vma,
>  		if (grow <= vma->vm_pgoff) {
>  			error = acct_stack_growth(vma, size, grow);
>  			if (!error) {
> +				/*
> +				 * vma_gap_update() doesn't support concurrent
> +				 * updates, but we only hold a shared mmap_sem
> +				 * lock here, so we need to protect against
> +				 * concurrent vma expansions.
> +				 * vma_lock_anon_vma() doesn't help here, as
> +				 * we don't guarantee that all growable vmas
> +				 * in a mm share the same root anon vma.
> +				 * So, we reuse mm->page_table_lock to guard
> +				 * against concurrent vma expansions.
> +				 */
> +				spin_lock(&vma->vm_mm->page_table_lock);
>  				anon_vma_interval_tree_pre_update_vma(vma);
>  				vma->vm_start = address;
>  				vma->vm_pgoff -= grow;
>  				anon_vma_interval_tree_post_update_vma(vma);
>  				vma_gap_update(vma);
> +				spin_unlock(&vma->vm_mm->page_table_lock);
> +
>  				perf_event_mmap(vma);
>  			}
>  		}


