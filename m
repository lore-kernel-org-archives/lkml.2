Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab2HVJEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:04:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42932 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195Ab2HVJDz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:03:55 -0400
Date: Wed, 22 Aug 2012 09:58:01 +0100
From: Mel Gorman <mgorman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-ID: <20120822085801.GA15058@suse.de>
References: <20120822155941.ae0b4c163fc15346a9863e5e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20120822155941.ae0b4c163fc15346a9863e5e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 03:59:41PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> mm/page_alloc.c between commit c67fe3752abe ("mm: compaction: Abort async
> compaction if locks are contended or taking too long") from Linus' tree
> and commit "mm: remove __GFP_NO_KSWAPD" from the akpm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Hi Stephen,

I think this will be a temporary problem. In the patch series that contained
"mm: compaction: Abort async compaction if locks are contended or taking
too long" there is a replacement patch for "mm: remove __GFP_NO_KSWAPD"
that handles the conflict. According to the mm-commits mailing list the
replacement patch has been picked up by Andrew but I see the old
versions in linux-next/akpm. It should get resolved the next time
Andrews tree gets pushed out.

> diff --cc mm/page_alloc.c
> index 5b3cc33,cefac39..0000000
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@@ -2436,11 -2429,10 +2435,10 @@@ rebalance
>   	/*
>   	 * If compaction is deferred for high-order allocations, it is because
>   	 * sync compaction recently failed. In this is the case and the caller
>  -	 * has requested the system not be heavily disrupted, fail the
>  -	 * allocation now instead of entering direct reclaim
>  +	 * requested a movable allocation that does not heavily disrupt the
>  +	 * system then fail the allocation instead of entering direct reclaim.
>   	 */
> - 	if ((deferred_compaction || contended_compaction) &&
> - 						(gfp_mask & __GFP_NO_KSWAPD))
>  -	if (deferred_compaction)
> ++	if (deferred_compaction || contended_compaction)
>   		goto nopage;
>   
>   	/* Try direct reclaim and then allocating */

It is not obvious at all but the correct resolution is actually the
following. Andrew should already have the right version.

@@ -2437,7 +2436,7 @@ rebalance:
 	 * system then fail the allocation instead of entering direct reclaim.
 	 */
 	if ((deferred_compaction || contended_compaction) &&
-						(gfp_mask & __GFP_NO_KSWAPD))
+	    (gfp_mask & (__GFP_MOVABLE|__GFP_REPEAT)) == __GFP_MOVABLE)
 		goto nopage;
 
 	/* Try direct reclaim and then allocating */

-- 
Mel Gorman
SUSE Labs
