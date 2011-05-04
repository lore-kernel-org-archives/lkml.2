Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab1EDTR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 15:17:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:15911 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754157Ab1EDTR2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 15:17:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=o4Kp/ETnKqZryZzZTm1x1w5dGOBhNhIKBddDpSOFH8sYWrYb2krF2ewwAq81jcxpSk
         IkvLXP1UR9gSYqsL9lDQ==
Date: Wed, 4 May 2011 12:17:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andi Kleen <ak@linux.intel.com>,
        Michal Hocko <mhocko@suse.cz>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Balbir Singh <balbir@in.ibm.com>, Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] Allocate memory cgroup structures in local nodes
In-Reply-To: <1304533058-18228-1-git-send-email-andi@firstfloor.org>
Message-ID: <alpine.DEB.2.00.1105041213310.22426@chino.kir.corp.google.com>
References: <1304533058-18228-1-git-send-email-andi@firstfloor.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Andi Kleen wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> [Andrew: since this is a regression and a very simple fix
> could you still consider it for .39? Thanks]
> 

Before that's considered, the order of the arguments to 
alloc_pages_exact_node() needs to be fixed.

> dde79e005a769 added a regression that the memory cgroup data structures
> all end up in node 0 because the first attempt at allocating them
> would not pass in a node hint. Since the initialization runs on CPU #0
> it would all end up node 0. This is a problem on large memory systems,
> where node 0 would lose a lot of memory.
> 
> Change the alloc_pages_exact to alloc_pages_exact_node. This will
> still fall back to other nodes if not enough memory is available.
> 

The vmalloc_node() calls ensure that the nid is actually set in 
N_HIGH_MEMORY and fails otherwise (we don't fallback to using vmalloc()), 
so it looks like the failures for alloc_pages_exact_node() and 
vmalloc_node() would be different?  Why do we want to fallback for one and 
not the other?

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
>  	if (addr)
>  		return addr;
>  
