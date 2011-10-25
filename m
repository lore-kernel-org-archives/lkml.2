Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823Ab1JYWKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 18:10:13 -0400
Received: from smtp-out.google.com ([74.125.121.67]:1281 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752140Ab1JYWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 18:10:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=FcjYWo3MQjumaCu1PZXza3G52gYO/ZD1K4xbEHHrsGp49R/2qeJc/IzqYpwUsi5wd
	txjujmXLeu00Qq/4kadEA==
Date: Tue, 25 Oct 2011 15:10:05 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Colin Cross <ccross@android.com>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm@kvack.org
Subject: Re: [PATCH] mm: avoid livelock on !__GFP_FS allocations
In-Reply-To: <1319524789-22818-1-git-send-email-ccross@android.com>
Message-ID: <alpine.DEB.2.00.1110251503490.26017@chino.kir.corp.google.com>
References: <1319524789-22818-1-git-send-email-ccross@android.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Oct 2011, Colin Cross wrote:

> Under the following conditions, __alloc_pages_slowpath can loop
> forever:
> gfp_mask & __GFP_WAIT is true
> gfp_mask & __GFP_FS is false
> reclaim and compaction make no progress
> order <= PAGE_ALLOC_COSTLY_ORDER
> 

The oom killer is only called for __GFP_FS because we want to ensure that 
we don't inadvertently kill something if we didn't have a chance to at 
least make a good effort at direct reclaim.  There's a very high liklihood 
that direct reclaim would succeed with __GFP_FS, so we loop endlessly 
waiting for either kswapd to reclaim in the background even though it 
might not be able to because of filesystem locks or another allocation 
happens in a context that allows reclaim to succeed or oom killing.

For low-order allocations (those at or below PAGE_ALLOC_COSTLY_ORDER) 
where fragmentation isn't a huge issue, __GFP_WAIT && !__GFP_FS && 
!did_some_progress makes sense.

> These conditions happen very often during suspend and resume,
> when pm_restrict_gfp_mask() effectively converts all GFP_KERNEL
> allocations into __GFP_WAIT.
> 

This is the problem.  All allocations now have no chance of ever having 
direct reclaim succeed nor the oom killer called.  It seems like you would 
want pm_restrict_gfp_mask() to also include __GFP_NORETRY and ensure it 
can never be called for __GFP_NOFAIL.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index fef8dc3..dcd99b3 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2193,6 +2193,10 @@ rebalance:
>  			}
>  
>  			goto restart;
> +		} else {
> +			/* If we aren't going to try the OOM killer, give up */
> +			if (!(gfp_mask & __GFP_NOFAIL))
> +				goto nopage;
>  		}
>  	}
>  

Nack on this, it is going to cause many very verbose allocation failures 
(if !__GFP_NOWARN) when not using suspend because we're not in a context 
where we can do sensible reclaim or compaction and presently kswapd can 
either reclaim or another allocation will allow low-order amounts of 
memory to be reclaimed or the oom killer to free some memory.  It would 
introduce a regression into page allocation.
