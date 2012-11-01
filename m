Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762177Ab2KAUDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 16:03:11 -0400
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:20441 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754461Ab2KAUDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 16:03:07 -0400
Date: Thu, 1 Nov 2012 20:03:06 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Glauber Costa <glommer@parallels.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        kamezawa.hiroyu@jp.fujitsu.com, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v6 06/29] memcg: kmem controller infrastructure
In-Reply-To: <1351771665-11076-7-git-send-email-glommer@parallels.com>
Message-ID: <0000013abd91e573-0ea881ef-538b-40dd-8056-9532812eb165-000000@email.amazonses.com>
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-7-git-send-email-glommer@parallels.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Glauber Costa wrote:

> +#ifdef CONFIG_MEMCG_KMEM
> +static inline bool memcg_kmem_enabled(void)
> +{
> +	return true;
> +}
> +

Maybe it would be better to do this in the same way that NUMA_BUILD was
done in kernel.h?


> +static __always_inline bool
> +memcg_kmem_newpage_charge(gfp_t gfp, struct mem_cgroup **memcg, int order)
> +{
> +	if (!memcg_kmem_enabled())
> +		return true;
> +
> +	/*
> +	 * __GFP_NOFAIL allocations will move on even if charging is not
> +	 * possible. Therefore we don't even try, and have this allocation
> +	 * unaccounted. We could in theory charge it with
> +	 * res_counter_charge_nofail, but we hope those allocations are rare,
> +	 * and won't be worth the trouble.
> +	 */
> +	if (!(gfp & __GFP_KMEMCG) || (gfp & __GFP_NOFAIL))
> +		return true;


> +	if (in_interrupt() || (!current->mm) || (current->flags & PF_KTHREAD))
> +		return true;

This type of check is repeatedly occurring in various subsystems. Could we
get a function (maybe inline) to do this check?

