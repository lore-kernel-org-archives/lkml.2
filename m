Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758824Ab2IGXG5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 19:06:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57026 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab2IGXG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 19:06:56 -0400
Message-ID: <504A7E11.2010700@jp.fujitsu.com>
Date: Fri, 07 Sep 2012 19:06:57 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: mgorman@suse.de
CC: cl@linux.com, akpm@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com,
        davej@redhat.com, ben@decadent.org.uk, ak@linux.intel.com,
        hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/5] mempolicy: fix a memory corruption by refcount imbalance
 in alloc_pages_vma()
References: <1345480594-27032-1-git-send-email-mgorman@suse.de> <1345480594-27032-6-git-send-email-mgorman@suse.de> <000001394596bd69-2c16d7fb-71b5-4009-95cc-7068103b2bfd-000000@email.amazonses.com> <20120821072611.GC1657@suse.de>
In-Reply-To: <20120821072611.GC1657@suse.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> mempolicy: fix a memory corruption by refcount imbalance in alloc_pages_vma()
> 
> [cc9a6c87: cpuset: mm: reduce large amounts of memory barrier related damage
> v3] introduced a potential memory corruption. shmem_alloc_page() uses a
> pseudo vma and it has one significant unique combination, vma->vm_ops=NULL
> and vma->policy->flags & MPOL_F_SHARED.
> 
> get_vma_policy() does NOT increase a policy ref when vma->vm_ops=NULL and
> mpol_cond_put() DOES decrease a policy ref when a policy has MPOL_F_SHARED.
> Therefore, when a cpuset update race occurs, alloc_pages_vma() falls in 'goto
> retry_cpuset' path, decrements the reference count and frees the policy
> prematurely.
> 
> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  mm/mempolicy.c |   12 +++++++++++-
>  1 files changed, 11 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 45f9825..9842ef5 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1552,8 +1552,18 @@ struct mempolicy *get_vma_policy(struct task_struct *task,
>  									addr);
>  			if (vpol)
>  				pol = vpol;
> -		} else if (vma->vm_policy)
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

Ok, looks sene change. thank you.


Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

>  	}
>  	if (!pol)
>  		pol = &default_policy;
> 

