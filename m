Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2HTTvN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 15:51:13 -0400
Received: from a194-183.smtp-out.amazonses.com ([199.255.194.183]:23100 "EHLO
	a194-183.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751817Ab2HTTvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 15:51:12 -0400
Date: Mon, 20 Aug 2012 19:51:10 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Jones <davej@redhat.com>, Ben Hutchings <ben@decadent.org.uk>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 5/5] mempolicy: fix a memory corruption by refcount
 imbalance in alloc_pages_vma()
In-Reply-To: <1345480594-27032-6-git-send-email-mgorman@suse.de>
Message-ID: <000001394596bd69-2c16d7fb-71b5-4009-95cc-7068103b2bfd-000000@email.amazonses.com>
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-6-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.194.183
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Aug 2012, Mel Gorman wrote:

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 45f9825..82e872f 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1545,15 +1545,28 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
>  		struct vm_area_struct *vma, unsigned long addr)
>  {
>  	struct mempolicy *pol = task->mempolicy;
> +	int got_ref;

New variable. Need to set it to zero?

>
>  	if (vma) {
>  		if (vma->vm_ops && vma->vm_ops->get_policy) {
>  			struct mempolicy *vpol = vma->vm_ops->get_policy(vma,
>  									addr);
> -			if (vpol)
> +			if (vpol) {
>  				pol = vpol;
> -		} else if (vma->vm_policy)
> +				got_ref = 1;

Set the new variable. But it was not initialzed before. So now its 1 or
undefined?

> +			}
> +		} else if (vma->vm_policy) {
>  			pol = vma->vm_policy;
> +
> +			/*
> +			 * shmem_alloc_page() passes MPOL_F_SHARED policy with
> +			 * a pseudo vma whose vma->vm_ops=NULL. Take a reference
> +			 * count on these policies which will be dropped by
> +			 * mpol_cond_put() later
> +			 */
> +			if (mpol_needs_cond_ref(pol))
> +				mpol_get(pol);
> +		}
>  	}
>  	if (!pol)
>  		pol = &default_policy;
>

I do not see any use of got_ref. Can we get rid of the variable?


