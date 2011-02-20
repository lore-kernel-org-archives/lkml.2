Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1BTEEB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Feb 2011 23:04:01 -0500
Received: from smtp-out.google.com ([216.239.44.51]:31056 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753532Ab1BTEDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Feb 2011 23:03:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=nEwopkHtV7TOZQWky1Wm1G2zRDWDPdNDzcOv05yvz/pFTow4cEeNuEOyv6h9V8tvlQ
         0iI82HUwJgH4t96R14gw==
Date: Sat, 19 Feb 2011 20:03:41 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: [PATCH 2/4] x86, numa: Do not adjust start/end for
 early_node_mem()
In-Reply-To: <4D5EC184.6000505@kernel.org>
Message-ID: <alpine.DEB.2.00.1102191944530.32280@chino.kir.corp.google.com>
References: <4D5EC05A.60103@kernel.org> <4D5EC184.6000505@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Feb 2011, Yinghai Lu wrote:

> Index: linux-2.6/arch/x86/mm/numa_64.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/mm/numa_64.c
> +++ linux-2.6/arch/x86/mm/numa_64.c
> @@ -164,14 +164,9 @@ static void * __init early_node_mem(int
>  	unsigned long mem;
>  
>  	/*
> -	 * put it on high as possible
> -	 * something will go with NODE_DATA
> +	 * memblock find will follow top-down, so don't need to adjust
> +	 *   start anymore
>  	 */
> -	if (start < (MAX_DMA_PFN<<PAGE_SHIFT))
> -		start = MAX_DMA_PFN<<PAGE_SHIFT;
> -	if (start < (MAX_DMA32_PFN<<PAGE_SHIFT) &&
> -	    end > (MAX_DMA32_PFN<<PAGE_SHIFT))
> -		start = MAX_DMA32_PFN<<PAGE_SHIFT;
>  	mem = memblock_x86_find_in_range_node(nodeid, start, end, size, align);
>  	if (mem != MEMBLOCK_ERROR)
>  		return __va(mem);
> 

The old code guarantees that the range is from a single zone, and even 
though memblock may be top -> down, it seems like there would be 
configurations where this would still be an issue (perhaps simulating it 
with numa=fake for testing?) if it crosses the boundary.
