Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab1CCUt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:49:56 -0500
Received: from smtp-out.google.com ([216.239.44.51]:45284 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758665Ab1CCUtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:49:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=EgGcFTmVt/VDJYqijJMRc+RkX0DSuT7+RD4haF7zZqbt4U97pkVcqgJDooZ8BzbyoK
         RB6zCzLitareAyJ8R+nQ==
Date: Thu, 3 Mar 2011 12:49:51 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, mm: clean up setup_node_bootmem
In-Reply-To: <4D6EECA1.70603@kernel.org>
Message-ID: <alpine.DEB.2.00.1103031243020.9993@chino.kir.corp.google.com>
References: <4D6EECA1.70603@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Mar 2011, Yinghai Lu wrote:

> 
> only one user now, so change it to static
> 
> Also move validity checking into the fuction.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 
> ---
>  arch/x86/include/asm/numa_64.h |    2 --
>  arch/x86/mm/numa_64.c          |   10 +++-------
>  2 files changed, 3 insertions(+), 9 deletions(-)
> 
> Index: linux-2.6/arch/x86/include/asm/numa_64.h
> ===================================================================
> --- linux-2.6.orig/arch/x86/include/asm/numa_64.h
> +++ linux-2.6/arch/x86/include/asm/numa_64.h
> @@ -13,8 +13,6 @@ struct bootnode {
>  extern int numa_off;
>  
>  extern unsigned long numa_free_all_bootmem(void);
> -extern void setup_node_bootmem(int nodeid, unsigned long start,
> -			       unsigned long end);
>  
>  #ifdef CONFIG_NUMA
>  /*
> Index: linux-2.6/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -237,21 +237,18 @@ int __init numa_add_memblk(int nid, u64
>  }
>  
>  /* Initialize bootmem allocator for a node */
> -void __init
> +static void __init
>  setup_node_bootmem(int nodeid, unsigned long start, unsigned long end)
>  {
>  	unsigned long start_pfn, last_pfn, nodedata_phys;
>  	const int pgdat_size = roundup(sizeof(pg_data_t), PAGE_SIZE);
>  	int nid;
>  
> -	if (!end)
> -		return;
> -
>  	/*
>  	 * Don't confuse VM with a node that doesn't have the
>  	 * minimum amount of memory:
>  	 */
> -	if (end && (end - start) < NODE_MIN_SIZE)
> +	if (end < (start +  NODE_MIN_SIZE))
>  		return;
>  
>  	start = roundup(start, ZONE_ALIGN);
> @@ -557,8 +554,7 @@ static int __init numa_register_memblks(
>  			end = max(mi->blk[i].end, end);
>  		}
>  
> -		if (start < end)
> -			setup_node_bootmem(nid, start, end);
> +		setup_node_bootmem(nid, start, end);
>  	}
>  
>  	return 0;
> 

Good catch on finding only the one caller of setup_node_bootmem().

I'd actually rather see the validity checking being done in 
numa_register_memblks(), though, because it's a bug for a node to be set 
in node_possible_map without having a valid 
[mi->blk[i].start, mi->blk[i].end) range.

So could this be

	BUG_ON(end < start);
	/*
	 * Don't confuse the VM with a node that doesn't have the minimum
	 * amount of memory.
	 */
	if (end < start + NODE_MIN_SIZE) {
		node_clear(nid, node_possible_map);
		continue;
	}
	setup_node_bootmem(nid, start, end);

instead?
