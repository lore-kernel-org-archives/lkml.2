Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755236Ab2FSXZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 19:25:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37395 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab2FSXZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 19:25:48 -0400
Date: Tue, 19 Jun 2012 16:25:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, aarcange@redhat.com, peterz@infradead.org,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 1/7] mm: track free size between VMAs in VMA rbtree
Message-Id: <20120619162547.d35e759e.akpm@linux-foundation.org>
In-Reply-To: <1340057126-31143-2-git-send-email-riel@redhat.com>
References: <1340057126-31143-1-git-send-email-riel@redhat.com>
	<1340057126-31143-2-git-send-email-riel@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012 18:05:20 -0400
Rik van Riel <riel@redhat.com> wrote:

> From: Rik van Riel <riel@surriel.com>
> 
> Track the size of free areas between VMAs in the VMA rbtree.
> 
> This will allow get_unmapped_area_* to find a free area of the
> right size in O(log(N)) time, instead of potentially having to
> do a linear walk across all the VMAs.
> 
> ...
>
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -213,6 +213,13 @@ struct vm_area_struct {
>  	struct rb_node vm_rb;
>  
>  	/*
> +	 * Largest free memory gap "behind" this VMA (in the direction mmap
> +	 * grows from), or of VMAs down the rb tree below us. This helps
> +	 * get_unmapped_area find a free area of the right size.
> +	 */
> +	unsigned long free_gap;

Please mention the units?  Seems to be "bytes", not "pages".

> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -205,6 +205,51 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
>  	flush_dcache_mmap_unlock(mapping);
>  }
>  
> +static unsigned long max_free_space(struct rb_node *node)
> +{
> +	struct vm_area_struct *vma, *prev, *left = NULL, *right = NULL;
> +	unsigned long largest = 0;
> +
> +	if (node->rb_left)
> +		left = rb_to_vma(node->rb_left);
> +	if (node->rb_right)
> +		right = rb_to_vma(node->rb_right);
> +
> +	/*
> +	 * Calculate the free gap size between us and the
> +	 * VMA to our left.
> +	 */

Comment will fit in a single line.

> +	vma = rb_to_vma(node);
> +	prev = vma->vm_prev;
> +
> +	if (prev)
> +		largest = vma->vm_start - prev->vm_end;
> +	else
> +		largest = vma->vm_start;
> +
> +	/* We propagate the largest of our own, or our children's free gaps. */
> +	if (left)
> +		largest = max(largest, left->free_gap);
> +	if (right)
> +		largest = max(largest, right->free_gap);
> +
> +	return largest;
> +}

This would be easier to review if it had a nice comment explaining its
role ;)

> +static void vma_rb_augment_cb(struct rb_node *node, void *__unused)
> +{
> +	struct vm_area_struct *vma;
> +
> +	vma = rb_to_vma(node);
> +
> +	vma->free_gap = max_free_space(node);
> +}

Save some trees!

	struct vm_area_struct *vma = rb_to_vma(node);
	vma->free_gap = max_free_space(node);

or even

	rb_to_vma(node)->free_gap = max_free_space(node);


Major stuff, huh?
