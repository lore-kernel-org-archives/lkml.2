Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754148Ab1AXR5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 12:57:24 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40304 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640Ab1AXR5U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 12:57:20 -0500
Subject: Re: [RFC -v6 PATCH 2/8] sched: limit the scope of clear_buddies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rik van Riel <riel@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Avi Kiviti <avi@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>, Chris Wright <chrisw@sous-sol.org>,
        ttracy@redhat.com, dshaks@redhat.com,
        "Nakajima, Jun" <jun.nakajima@intel.com>, Paul Turner <pjt@google.com>
In-Reply-To: <20110120163312.587f2e1e@annuminas.surriel.com>
References: <20110120163127.2568f4fe@annuminas.surriel.com>
	 <20110120163312.587f2e1e@annuminas.surriel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 24 Jan 2011 18:57:41 +0100
Message-ID: <1295891861.28776.448.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-20 at 16:33 -0500, Rik van Riel wrote:
> The clear_buddies function does not seem to play well with the concept
> of hierarchical runqueues.  In the following tree, task groups are
> represented by 'G', tasks by 'T', next by 'n' and last by 'l'.
> 
>      (nl)
>     /    \
>    G(nl)  G
>    / \     \
>  T(l) T(n)  T
> 
> This situation can arise when a task is woken up T(n), and the previously
> running task T(l) is marked last.
> 
> When clear_buddies is called from either T(l) or T(n), the next and last
> buddies of the group G(nl) will be cleared.  This is not the desired
> result, since we would like to be able to find the other type of buddy
> in many cases.
> 
> This especially a worry when implementing yield_task_fair through the
> buddy system.
> 
> The fix is simple: only clear the buddy type that the task itself
> is indicated to be.  As an added bonus, we stop walking up the tree
> when the buddy has already been cleared or pointed elsewhere.
> 
> Signed-off-by: Rik van Riel <riel@redhat.coM>
> ---
>  kernel/sched_fair.c |   30 +++++++++++++++++++++++-------
>  1 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
> index f4ee445..0321473 100644
> --- a/kernel/sched_fair.c
> +++ b/kernel/sched_fair.c
> @@ -784,19 +784,35 @@ enqueue_entity(struct cfs_rq *cfs_rq, struct sched_entity *se, int flags)
>  		__enqueue_entity(cfs_rq, se);
>  }
>  
> -static void __clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
> +static void __clear_buddies_last(struct sched_entity *se)
>  {
> -	if (!se || cfs_rq->last == se)
> -		cfs_rq->last = NULL;
> +	for_each_sched_entity(se) {
> +		struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +		if (cfs_rq->last == se)
> +			cfs_rq->last = NULL;
> +		else
> +			break;
> +	}
> +}
>  
> -	if (!se || cfs_rq->next == se)
> -		cfs_rq->next = NULL;
> +static void __clear_buddies_next(struct sched_entity *se)
> +{
> +	for_each_sched_entity(se) {
> +		struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +		if (cfs_rq->next == se)
> +			cfs_rq->next = NULL;
> +		else
> +			break;
> +	}
>  }
>  
>  static void clear_buddies(struct cfs_rq *cfs_rq, struct sched_entity *se)
>  {
> -	for_each_sched_entity(se)
> -		__clear_buddies(cfs_rq_of(se), se);
> +	if (cfs_rq->last == se)
> +		__clear_buddies_last(se);
> +
> +	if (cfs_rq->next == se)
> +		__clear_buddies_next(se);
>  }
>  

Right, I think this sorta matches with something the Google guys talked
about, they wanted to change pick_next_task() no always start from the
top but only go up one level when the current level ran out.

It looks ok, just sad that we can now have two hierarchy traversals (and
3 with the next patch).


