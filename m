Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758947Ab1CCWEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 17:04:30 -0500
Received: from smtp-out.google.com ([74.125.121.67]:55544 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754793Ab1CCWE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 17:04:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=mft/PiFW9mxO7R3YABIQMwQegxOh+X+EDfm6PRmdSykVJdGXWaYxe8XeRu8nNdlNKB
         EjVuIWDmWTxdmiDAAVnQ==
Date: Thu, 3 Mar 2011 14:04:23 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mm: clean up setup_node_bootmem
In-Reply-To: <4D7009BA.5030600@kernel.org>
Message-ID: <alpine.DEB.2.00.1103031401071.4141@chino.kir.corp.google.com>
References: <4D6EECA1.70603@kernel.org> <alpine.DEB.2.00.1103031243020.9993@chino.kir.corp.google.com> <4D7009BA.5030600@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Mar 2011, Yinghai Lu wrote:

> >> Index: linux-2.6/arch/x86/mm/numa_64.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> >> +++ linux-2.6/arch/x86/mm/numa_64.c
> >> @@ -237,21 +237,18 @@ int __init numa_add_memblk(int nid, u64
> >>  }
> >>  
> >>  /* Initialize bootmem allocator for a node */
> >> -void __init
> >> +static void __init
> >>  setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
> >>  {
> >>  	unsigned long start_pfn, last_pfn, nodedata_phys;
> >>  	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
> >>  	int nid;
> >>  
> >> -	if (!end)
> >> -		return;
> >> -
> >>  	/*
> >>  	 * Don't confuse VM with a node that doesn't have the
> >>  	 * minimum amount of memory:
> >>  	 */
> >> -	if (end && (end - start) < NODE_MIN_SIZE)
> >> +	if (end < (start +  NODE_MIN_SIZE))
> >>  		return;
> >>  
> >>  	start = roundup(start, ZONE_ALIGN);
> >> @@ -557,8 +554,7 @@ static int __init numa_register_memblks(
> >>  			end = max(mi->blk[i].end, end);
> >>  		}
> >>  
> >> -		if (start < end)
> >> -			setup_node_bootmem(nid, start, end);
> >> +		setup_node_bootmem(nid, start, end);
> >>  	}
> >>  
> >>  	return 0;
> >>
> > 
> > Good catch on finding only the one caller of setup_node_bootmem().
> > 
> > I'd actually rather see the validity checking being done in 
> > numa_register_memblks(), though, because it's a bug for a node to be set 
> > in node_possible_map without having a valid 
> > [mi->blk[i].start, mi->blk[i].end) range.
> > 
> > So could this be
> > 
> > 	BUG_ON(end < start);
> 
> no, it could cause crash here
> 
>         /* Finally register nodes. */
>         for_each_node_mask(nid, node_possible_map) {
>                 u64 start = (u64)max_pfn << PAGE_SHIFT;
>                 u64 end = 0;
> 
>                 for (i = 0; i < mi->nr_blks; i++) {
>                         if (nid != mi->blk[i].nid)
>                                 continue;
>                         start = min(mi->blk[i].start, start);
>                         end = max(mi->blk[i].end, end);
>                 }
> 
> could have some node without memory. and it could be set in node_possible_map, and it will have end = 0, and start max_pfn<<page_shift.
> 

Ok, I didn't realize this was being used for memoryless nodes.

> > 	/*
> > 	 * Don't confuse the VM with a node that doesn't have the minimum
> > 	 * amount of memory.
> > 	 */
> > 	if (end < start + NODE_MIN_SIZE) {
> > 		node_clear(nid, node_possible_map);
> 
> why touch that possible_map ?
> online_map is for that purpose that state node have ram.
> 

Hmm, that's the purpose of N_NORMAL_MEMORY, not node_online_map.  I 
understand why we don't want to register bootmem for a node that has such 
little memory that we disregard it, but shouldn't we then consider it to 
no longer be possible?
