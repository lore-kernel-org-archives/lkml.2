Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1LIUYJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 15:24:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55885 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab1LIUYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 15:24:07 -0500
Date: Fri, 9 Dec 2011 12:24:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kosaki.motohiro@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH] mm: simplify find_vma_prev
Message-Id: <20111209122406.11f9e31a.akpm@linux-foundation.org>
In-Reply-To: <1323461345-12805-1-git-send-email-kosaki.motohiro@gmail.com>
References: <1323461345-12805-1-git-send-email-kosaki.motohiro@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  9 Dec 2011 15:09:04 -0500
kosaki.motohiro@gmail.com wrote:

> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> commit 297c5eee37 (mm: make the vma list be doubly linked) added
> vm_prev member into vm_area_struct. Therefore we can simplify
> find_vma_prev() by using it. Also, this change help to imporove
> page fault performance becuase it has strong locality of reference.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> ---
>  mm/mmap.c |   34 ++++++----------------------------
>  1 files changed, 6 insertions(+), 28 deletions(-)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index eae90af..955750c 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1605,37 +1605,15 @@ EXPORT_SYMBOL(find_vma);
>  
>  /* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
>  struct vm_area_struct *
> -find_vma_prev(struct mm_struct *mm, unsigned long addr,
> -			struct vm_area_struct **pprev)
> +find_vma_prev(struct mm_struct *mm, unsigned long addr, struct vm_area_struct **pprev)
>  {
> -	struct vm_area_struct *vma = NULL, *prev = NULL;
> -	struct rb_node *rb_node;
> -	if (!mm)
> -		goto out;
> -
> -	/* Guard against addr being lower than the first VMA */
> -	vma = mm->mmap;
> -
> -	/* Go through the RB tree quickly. */
> -	rb_node = mm->mm_rb.rb_node;
> -
> -	while (rb_node) {
> -		struct vm_area_struct *vma_tmp;
> -		vma_tmp = rb_entry(rb_node, struct vm_area_struct, vm_rb);
> +	struct vm_area_struct *vma;
>  
> -		if (addr < vma_tmp->vm_end) {
> -			rb_node = rb_node->rb_left;
> -		} else {
> -			prev = vma_tmp;
> -			if (!prev->vm_next || (addr < prev->vm_next->vm_end))
> -				break;
> -			rb_node = rb_node->rb_right;
> -		}
> -	}
> +	vma = find_vma(mm, addr);
> +	if (vma)
> +		*pprev = vma->vm_prev;
>  
> -out:
> -	*pprev = prev;
> -	return prev ? prev->vm_next : vma;
> +	return vma;
>  }

This changes the (undocumented, naturally) interface in disturbing ways.

Currently, *pprev will always be written to.  With this change, *pprev
will only be written to if find_vma_prev() returns non-NULL.

Looking through the code, this is mostly benign.  But it will cause the
CONFIG_STACK_GROWSUP version of find_extend_vma() to use an
uninitialised stack slot in ways which surely will crash the kernel.

So please have a think about that and fix it up.  And please add
documentation for find_vma_prev()'s interface so we don't break it next
time.

