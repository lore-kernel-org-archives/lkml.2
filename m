Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1BYJDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:03:14 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53149 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754387Ab1BYJDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:03:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nDqaMS+b5ERX1mFipnhJ477TEzzG0QKaXnxDNuwWOkgBeIQ3yAbuDxrdsaefVtP3M/
         cPE3gtwC8n9aG0wm6aJR3HhS4h5xuGe5D9aMv6FmRuOqQcs7ZJLKOwCA/jMdlScXSP2F
         ALfh0vgnbVgF+1e2RJnGXFHNpWgry3dsuiwgQ=
Date: Fri, 25 Feb 2011 10:03:01 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Fix size of numa_distance array
Message-ID: <20110225090301.GB24828@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <20110224193211.GC15498@elte.hu>
 <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
 <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 24, 2011 at 02:46:38PM -0800, David Rientjes wrote:
> That's this:
> 
> 430		numa_distance_cnt = cnt;
> 431	
> 432		/* fill with the default distances */
> 433		for (i = 0; i < cnt; i++)
> 434			for (j = 0; j < cnt; j++)
> 435	===>			numa_distance[i * cnt + j] = i == j ?
> 436					LOCAL_DISTANCE : REMOTE_DISTANCE;
> 437		printk(KERN_DEBUG "NUMA: Initialized distance table, cnt=%d\n", cnt);
> 438	
> 439		return 0;
> 
> We're overflowing the array and it's easy to see why:
> 
>         for_each_node_mask(i, nodes_parsed)
>                 cnt = i;
>         size = ++cnt * sizeof(numa_distance[0]);
> 
> cnt is the highest node id parsed, so numa_distance[] must be cnt * cnt.  
> The following patch fixes the issue on top of x86/mm.

Oops, that was stupid.

> I'm running on a 64GB machine with CONFIG_NODES_SHIFT == 10, so 
> numa=fake=128M would result in 512 nodes.  That's going to require 2MB for 
> numa_distance (and that's not __initdata).  Before these changes, we 
> calculated numa_distance() using pxms without this additional mapping, is 
> there any way to reduce this?  (Admittedly real NUMA machines with 512 
> nodes wouldn't mind sacrificing 2MB, but we didn't need this before.)

We can leave the physical distance table unmodified and map through
emu_nid_to_phys[] while dereferencing.  It just seemed simpler this
way.  Does it actually matter?  Anyways, I'll give it a shot.  Do you
guys actually use 512 nodes?

> x86, mm: Fix size of numa_distance array
> 
> numa_distance should be sized like the SLIT, an NxN matrix where N is the
> highest node id.  This patch fixes the calulcation to avoid overflowing
> the array on the subsequent iteration.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  arch/x86/mm/numa_64.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> index cccc01d..abf0131 100644
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -414,7 +414,7 @@ static int __init numa_alloc_distance(void)
>  
>  	for_each_node_mask(i, nodes_parsed)
>  		cnt = i;
> -	size = ++cnt * sizeof(numa_distance[0]);
> +	size = cnt * cnt * sizeof(numa_distance[0]);

It should be cnt++; cnt * cnt; as Yinghai wrote.

>  	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
>  				      size, PAGE_SIZE);

Thanks.

-- 
tejun
