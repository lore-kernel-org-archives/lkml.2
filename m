Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab1DVAgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 20:36:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:34868 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1DVAgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 20:36:18 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Subject: Re: [patch] mm: always set nodes with regular memory in N_NORMAL_MEMORY
Cc: kosaki.motohiro@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mel@csn.ul.ie>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.2.00.1104211440240.20201@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1104211411540.20201@chino.kir.corp.google.com> <alpine.DEB.2.00.1104211440240.20201@chino.kir.corp.google.com>
Message-Id: <20110422093619.FA5A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Fri, 22 Apr 2011 09:36:15 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> N_NORMAL_MEMORY is intended to include all nodes that have present memory 
> in regular zones, that is, zones below ZONE_HIGHMEM.  This should be done 
> regardless of whether CONFIG_HIGHMEM is set or not.
> 
> This fixes ia64 so that the nodes get set appropriately in the nodemask 
> for DISCONTIGMEM and mips if it does not enable CONFIG_HIGHMEM even for 
> 32-bit kernels.
> 
> If N_NORMAL_MEMORY is not accurate, slub may encounter errors since it 
> relies on this nodemask to setup kmem_cache_node data structures for each 
> cache.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/page_alloc.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4727,7 +4727,6 @@ out:
>  /* Any regular memory on that node ? */
>  static void check_for_regular_memory(pg_data_t *pgdat)
>  {
> -#ifdef CONFIG_HIGHMEM
>  	enum zone_type zone_type;
>  
>  	for (zone_type = 0; zone_type <= ZONE_NORMAL; zone_type++) {
> @@ -4735,7 +4734,6 @@ static void check_for_regular_memory(pg_data_t *pgdat)
>  		if (zone->present_pages)
>  			node_set_state(zone_to_nid(zone), N_NORMAL_MEMORY);
>  	}
> -#endif

enum node_states {
        N_POSSIBLE,             /* The node could become online at some point */
        N_ONLINE,               /* The node is online */
        N_NORMAL_MEMORY,        /* The node has regular memory */
#ifdef CONFIG_HIGHMEM
        N_HIGH_MEMORY,          /* The node has regular or high memory */
#else
        N_HIGH_MEMORY = N_NORMAL_MEMORY,
#endif
        N_CPU,          /* The node has one or more cpus */
        NR_NODE_STATES
};

Then, only node_set_state(nid, N_HIGH_MEMORY) is enough initialization, IIUC.
Can you please explain when do we need this patch?


