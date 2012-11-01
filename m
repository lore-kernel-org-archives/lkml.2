Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761310Ab2KALLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 07:11:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34908 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757856Ab2KALLD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 07:11:03 -0400
Date: Thu, 1 Nov 2012 11:10:58 +0000
From: Mel Gorman <mgorman@suse.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Rik van Riel <riel@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 12/31] mm/mpol: Add MPOL_MF_NOOP
Message-ID: <20121101111058.GS3888@suse.de>
References: <20121025121617.617683848@chello.nl>
 <20121025124833.400431442@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121025124833.400431442@chello.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, 2012 at 02:16:29PM +0200, Peter Zijlstra wrote:
> From: Lee Schermerhorn <lee.schermerhorn@hp.com>
> 
> This patch augments the MPOL_MF_LAZY feature by adding a "NOOP" policy

The MPOL_MF_LAZY feature doesn't exist yet so it's hard to augment at this
point :)

> to mbind().  When the NOOP policy is used with the 'MOVE and 'LAZY
> flags, mbind() will map the pages PROT_NONE so that they will be
> migrated on the next touch.
> 

This implies that a user-space application has a two-stage process.  Stage 1,
it marks a range NOOP and the stage 2 marks the range lazy.  That feels like
it might violate Rusty's API design rule of "The obvious use is wrong."
What is the motivation for exposing NOOP to userspace? Instead why does
mbind(addr, len, MPOL_MF_LAZY, nodemask, maxnode, flags) not imply that
the range gets marked PROT_NONE (or PROT_NUMA or some other variant that
is not arch-specific)?

It also seems that MPOL_MF_LAZY must imply MPOL_MF_MOVE or it's a bit
pointless without the application having to specify the exact flag
combination

> This allows an application to prepare for a new phase of operation
> where different regions of shared storage will be assigned to
> worker threads, w/o changing policy.  Note that we could just use
> "default" policy in this case.  However, this also allows an
> application to request that pages be migrated, only if necessary,
> to follow any arbitrary policy that might currently apply to a
> range of pages, without knowing the policy, or without specifying
> multiple mbind()s for ranges with different policies.
> 

I very much like the idea because potentially a motivated developer could use
this mechanism to avoid any ping-pong problems with an automatic migration
scheme. It could even be argued that any application using MPOL_MF_LAZY
get unsubscribed from any automatic mechanism to avoid interference.

> [ Bug in early version of mpol_parse_str() reported by Fengguang Wu. ]
> 
> Bug-Reported-by: Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Lee Schermerhorn <lee.schermerhorn@hp.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Ingo Molnar <mingo@kernel.org>
> ---
>  include/uapi/linux/mempolicy.h |    1 +
>  mm/mempolicy.c                 |   11 ++++++-----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> Index: tip/include/uapi/linux/mempolicy.h
> ===================================================================
> --- tip.orig/include/uapi/linux/mempolicy.h
> +++ tip/include/uapi/linux/mempolicy.h
> @@ -21,6 +21,7 @@ enum {
>  	MPOL_BIND,
>  	MPOL_INTERLEAVE,
>  	MPOL_LOCAL,
> +	MPOL_NOOP,		/* retain existing policy for range */
>  	MPOL_MAX,	/* always last member of enum */
>  };
>  
> Index: tip/mm/mempolicy.c
> ===================================================================
> --- tip.orig/mm/mempolicy.c
> +++ tip/mm/mempolicy.c
> @@ -251,10 +251,10 @@ static struct mempolicy *mpol_new(unsign
>  	pr_debug("setting mode %d flags %d nodes[0] %lx\n",
>  		 mode, flags, nodes ? nodes_addr(*nodes)[0] : -1);
>  
> -	if (mode == MPOL_DEFAULT) {
> +	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP) {
>  		if (nodes && !nodes_empty(*nodes))
>  			return ERR_PTR(-EINVAL);
> -		return NULL;	/* simply delete any existing policy */
> +		return NULL;
>  	}
>  	VM_BUG_ON(!nodes);
>  
> @@ -1146,7 +1146,7 @@ static long do_mbind(unsigned long start
>  	if (start & ~PAGE_MASK)
>  		return -EINVAL;
>  
> -	if (mode == MPOL_DEFAULT)
> +	if (mode == MPOL_DEFAULT || mode == MPOL_NOOP)
>  		flags &= ~MPOL_MF_STRICT;
>  
>  	len = (len + PAGE_SIZE - 1) & PAGE_MASK;
> @@ -2381,7 +2381,8 @@ static const char * const policy_modes[]
>  	[MPOL_PREFERRED]  = "prefer",
>  	[MPOL_BIND]       = "bind",
>  	[MPOL_INTERLEAVE] = "interleave",
> -	[MPOL_LOCAL]      = "local"
> +	[MPOL_LOCAL]      = "local",
> +	[MPOL_NOOP]	  = "noop",	/* should not actually be used */

If it should not be used, why it is exposed to userspace?

>  };
>  
>  
> @@ -2432,7 +2433,7 @@ int mpol_parse_str(char *str, struct mem
>  			break;
>  		}
>  	}
> -	if (mode >= MPOL_MAX)
> +	if (mode >= MPOL_MAX || mode == MPOL_NOOP)
>  		goto out;
>  
>  	switch (mode) {
> 
> 

-- 
Mel Gorman
SUSE Labs
