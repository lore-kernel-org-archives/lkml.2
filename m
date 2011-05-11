Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab1EKUiz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 16:38:55 -0400
Received: from smtp-out.google.com ([216.239.44.51]:42613 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab1EKUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 16:38:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=MgoylGotzPsmmPVh6wYFArr2YVQuylUlcLEEbCMwDYC7Se6OvikTAzThhst3zHfTZc
         YC7e7Zrr2IQnAg+xtV5Q==
Date: Wed, 11 May 2011 13:38:47 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Colin King <colin.king@canonical.com>,
        Raghavendra D Prabhu <raghu.prabhu13@gmail.com>,
        Jan Kara <jack@suse.cz>, Chris Mason <chris.mason@oracle.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-ext4 <linux-ext4@vger.kernel.org>
Subject: Re: [PATCH 3/3] mm: slub: Default slub_max_order to 0
In-Reply-To: <1305127773-10570-4-git-send-email-mgorman@suse.de>
Message-ID: <alpine.DEB.2.00.1105111314310.9346@chino.kir.corp.google.com>
References: <1305127773-10570-1-git-send-email-mgorman@suse.de> <1305127773-10570-4-git-send-email-mgorman@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011, Mel Gorman wrote:

> To avoid locking and per-cpu overhead, SLUB optimisically uses
> high-order allocations up to order-3 by default and falls back to
> lower allocations if they fail. While care is taken that the caller
> and kswapd take no unusual steps in response to this, there are
> further consequences like shrinkers who have to free more objects to
> release any memory. There is anecdotal evidence that significant time
> is being spent looping in shrinkers with insufficient progress being
> made (https://lkml.org/lkml/2011/4/28/361) and keeping kswapd awake.
> 
> SLUB is now the default allocator and some bug reports have been
> pinned down to SLUB using high orders during operations like
> copying large amounts of data. SLUBs use of high-orders benefits
> applications that are sized to memory appropriately but this does not
> necessarily apply to large file servers or desktops.  This patch
> causes SLUB to use order-0 pages like SLAB does by default.
> There is further evidence that this keeps kswapd's usage lower
> (https://lkml.org/lkml/2011/5/10/383).
> 

This is going to severely impact slub's performance for applications on 
machines with plenty of memory available where fragmentation isn't a 
concern when allocating from caches with large object sizes (even 
changing the min order of kamlloc-256 from 1 to 0!) by default for users 
who don't use slub_max_order=3 on the command line.  SLUB relies heavily 
on allocating from the cpu slab and freeing to the cpu slab to avoid the 
slowpaths, so higher order slabs are important for its performance.

I can get numbers for a simple netperf TCP_RR benchmark with this change 
applied to show the degradation on a server with >32GB of RAM with this 
patch applied.

It would be ideal if this default could be adjusted based on the amount of 
memory available in the smallest node to determine whether we're concerned 
about making higher order allocations.  (Using the smallest node as a 
metric so that mempolicies and cpusets don't get unfairly biased against.)  
With the previous changes in this patchset, specifically avoiding waking 
kswapd and doing compaction for the higher order allocs before falling 
back to the min order, it shouldn't be devastating to try an order-3 alloc 
that will fail quickly.

> Signed-off-by: Mel Gorman <mgorman@suse.de>
> ---
>  Documentation/vm/slub.txt |    2 +-
>  mm/slub.c                 |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/vm/slub.txt b/Documentation/vm/slub.txt
> index 07375e7..778e9fa 100644
> --- a/Documentation/vm/slub.txt
> +++ b/Documentation/vm/slub.txt
> @@ -117,7 +117,7 @@ can be influenced by kernel parameters:
>  
>  slub_min_objects=x		(default 4)
>  slub_min_order=x		(default 0)
> -slub_max_order=x		(default 1)
> +slub_max_order=x		(default 0)

Hmm, that was wrong to begin with, it should have been 3.

>  
>  slub_min_objects allows to specify how many objects must at least fit
>  into one slab in order for the allocation order to be acceptable.
> diff --git a/mm/slub.c b/mm/slub.c
> index 1071723..23a4789 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2198,7 +2198,7 @@ EXPORT_SYMBOL(kmem_cache_free);
>   * take the list_lock.
>   */
>  static int slub_min_order;
> -static int slub_max_order = PAGE_ALLOC_COSTLY_ORDER;
> +static int slub_max_order;
>  static int slub_min_objects;
>  
>  /*
