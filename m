Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1BTEDj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:03:39 -0500
Received: from smtp-out.google.com ([74.125.121.67]:48893 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1BTEDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:03:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=octpcqMiuJFtwd2bN4FndCoM135RQkVBurBUCVZl9yTpus/kkHFIui2DR/HtxTb1pY
         nAKhYR0R7xUX0yxyfwgA==
Date: Sat, 19 Feb 2011 20:03:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 1/4] x86, numa: Do not scan two times for
 setup_node_bootmem()
In-Reply-To: <4D5EC177.7030101@kernel.org>
Message-ID: <alpine.DEB.2.00.1102191942420.32280@chino.kir.corp.google.com>
References: <4D5EC05A.60103@kernel.org> <4D5EC177.7030101@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Yinghai Lu wrote:

> 
> We don't need to scan two times for setup_node_bootmem()
> because We are using mapped memblock for node_data finding already.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/mm/numa_64.c |   31 +++++++++++++------------------
>  1 file changed, 13 insertions(+), 18 deletions(-)
> 
> Index: linux-2.6/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -480,7 +480,7 @@ static bool __init numa_meminfo_cover_me
>  
>  static int __init numa_register_memblks(struct numa_meminfo *mi)
>  {
> -	int i, j, nid;
> +	int i, nid;
>  
>  	/* Account for nodes with cpus and no memory */
>  	node_possible_map = numa_nodes_parsed;
> @@ -507,27 +507,22 @@ static int __init numa_register_memblks(
>  	init_memory_mapping_high();
>  
>  	/*
> -	 * Finally register nodes.  Do it twice in case setup_node_bootmem
> -	 * missed one due to missing bootmem.
> +	 * Do not do that twice, not needed!
> +	 *   We are using mapped memblock directly for node data

I don't think this comment is actually needed, it seems to be referring to 
why this patch is changing it and has no real relevance once it's merged.

Other than that:

Acked-by: David Rientjes <rientjes@google.com>

>  	 */
> -	for (i = 0; i < 2; i++) {
> -		for_each_node_mask(nid, node_possible_map) {
> -			u64 start = (u64)max_pfn << PAGE_SHIFT;
> -			u64 end = 0;
> +	for_each_node_mask(nid, node_possible_map) {
> +		u64 start = (u64)max_pfn << PAGE_SHIFT;
> +		u64 end = 0;
>  
> -			if (node_online(nid))
> +		for (i = 0; i < mi->nr_blks; i++) {
> +			if (nid != mi->blk[i].nid)
>  				continue;
> -
> -			for (j = 0; j < mi->nr_blks; j++) {
> -				if (nid != mi->blk[j].nid)
> -					continue;
> -				start = min(mi->blk[j].start, start);
> -				end = max(mi->blk[j].end, end);
> -			}
> -
> -			if (start < end)
> -				setup_node_bootmem(nid, start, end);
> +			start = min(mi->blk[i].start, start);
> +			end = max(mi->blk[i].end, end);
>  		}
> +
> +		if (start < end)
> +			setup_node_bootmem(nid, start, end);
>  	}
>  
>  	return 0;
> 
