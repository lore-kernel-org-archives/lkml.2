Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761995Ab2FVKDP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:03:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:35600 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761960Ab2FVKDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:03:14 -0400
Message-ID: <1340359379.18025.60.camel@twins>
Subject: Re: [PATCH -mm v2 01/11] mm: track free size between VMAs in VMA
 rbtree
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        minchan@gmail.com, kosaki.motohiro@gmail.com, andi@firstfloor.org,
        hannes@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>
Date: Fri, 22 Jun 2012 12:02:59 +0200
In-Reply-To: <1340315835-28571-2-git-send-email-riel@surriel.com>
References: <1340315835-28571-1-git-send-email-riel@surriel.com>
	 <1340315835-28571-2-git-send-email-riel@surriel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-06-21 at 17:57 -0400, Rik van Riel wrote:
> +static unsigned long largest_free_gap(struct rb_node *node)
> +{
> +       struct vm_area_struct *vma, *prev, *left = NULL, *right = NULL;
> +       unsigned long largest = 0;
> +
> +       if (node->rb_left)
> +               left = rb_to_vma(node->rb_left);
> +       if (node->rb_right)
> +               right = rb_to_vma(node->rb_right);
> +
> +       /* Calculate the free gap size between us and the VMA to our left. */
> +       vma = rb_to_vma(node);
> +       prev = vma->vm_prev;
> +
> +       if (prev)
> +               largest = vma->vm_start - prev->vm_end;
> +       else
> +               largest = vma->vm_start;
> +
> +       /* We propagate the largest of our own, or our children's free gaps. */
> +       if (left)
> +               largest = max(largest, left->free_gap);
> +       if (right)
> +               largest = max(largest, right->free_gap);
> +
> +       return largest;
> +} 

If you introduce helpers like:

static inline struct vm_area_struct *vma_of(struct rb_node *node)
{
        return container_of(node, struct vm_area_struct, vm_rb);
}

static inline unsigned long max_gap_of(struct rb_node *node)
{
        return vma_of(node)->free_gap;
}

static unsigned long gap_of(struct rb_node *node)
{
        struct vm_area_struct *vma = vma_of(node);

        if (!vma->vm_prev)
                return vma->vm_start;

        return vma->vm_start - vma->vm_prev->vm_end;
}

You can write your largest free gap as:

unsigned long largest_gap(struct rb_node *node)
{
	unsigned long gap = gap_of(node);

	if (node->rb_left)
		gap = max(gap, max_gap_of(node->rb_left));
	if (node->rb_right)
		gap = max(gap, max_gap_of(node->rb_right));

	return gap;
}

And as shown, you can re-used those {max_,}gap_of() function in the
lookup function in the next patch.
