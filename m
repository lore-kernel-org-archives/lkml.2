Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277Ab1EEFZJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 01:25:09 -0400
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:44962 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab1EEFZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 01:25:07 -0400
Date: Thu, 5 May 2011 01:06:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes
Message-ID: <20110504193658.GB4713@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <1304533058-18228-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1304533058-18228-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen <andi@firstfloor.org> [2011-05-04 11:17:38]:

> From: Andi Kleen <ak@linux.intel.com>
> 
> [Andrew: since this is a regression and a very simple fix
> could you still consider it for .39? Thanks]
> 
> dde79e005a769 added a regression that the memory cgroup data structures
> all end up in node 0 because the first attempt at allocating them
> would not pass in a node hint. Since the initialization runs on CPU #0
> it would all end up node 0. This is a problem on large memory systems,
> where node 0 would lose a lot of memory.
> 
> Change the alloc_pages_exact to alloc_pages_exact_node. This will
> still fall back to other nodes if not enough memory is available.
> 
> [RED-PEN: right now it would fall back first before trying
> vmalloc_node. Probably not the best strategy ... But I left it like
> that for now.]
> 
> Reported-by: Doug Nelson
> CC: Michal Hocko <mhocko@suse.cz>
> Cc: Dave Hansen <dave@linux.vnet.ibm.com>
> Cc: Balbir Singh <balbir@in.ibm.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>  mm/page_cgroup.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 9905501..1f4e20f 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -134,7 +134,7 @@ static void *__init_refok alloc_page_cgroup(size_t size, int nid)
>  {
>  	void *addr = NULL;
> 
> -	addr = alloc_pages_exact(size, GFP_KERNEL | __GFP_NOWARN);
> +	addr = alloc_pages_exact_node(nid, size, GFP_KERNEL | __GFP_NOWARN);

Excellent catch! My eyes might be cheating me, I see
alloc_pages_exact_node doing what you expect it to do, I think the
size is interpreted as order.

>  	if (addr)
>  		return addr;
> 
> -- 
> 1.7.4.4
> 

-- 
	Three Cheers,
	Balbir
