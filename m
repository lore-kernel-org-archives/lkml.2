Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756637Ab1BXXbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 18:31:33 -0500
Received: from smtp-out.google.com ([216.239.44.51]:25964 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756600Ab1BXXbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 18:31:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=Hu0JTcNHXhVy9WdaRPeMixdXIln1wETo6jvL+fMX2c3YUnIzdw3Hb0wAd2mBRmEn2+
         hqNzv6GtLR4LYqAc4/gA==
Date: Thu, 24 Feb 2011 15:31:24 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>
cc: Yinghai Lu <yinghai@kernel.org>, tglx@linutronix.de,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Fix size of numa_distance array
In-Reply-To: <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1102241530310.9247@chino.kir.corp.google.com>
References: <20110224145128.GM7840@htj.dyndns.org> <4D66AC9C.6080500@kernel.org> <20110224192305.GB15498@elte.hu> <4D66B176.9030300@kernel.org> <20110224193211.GC15498@elte.hu> <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
 <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Feb 2011, David Rientjes wrote:

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
>  
>  	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
>  				      size, PAGE_SIZE);
> 

This also looks like it needs the following to not erroneously consider a 
node id to be out of bounds.  Why were we oversizing cnt in the old code 
above by 1?

diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -454,7 +454,7 @@ void __init numa_set_distance(int from, int to, int distance)
 	if (!numa_distance && numa_alloc_distance() < 0)
 		return;
 
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
+	if (from > numa_distance_cnt || to > numa_distance_cnt) {
 		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
 			    from, to, distance);
 		return;
@@ -472,7 +472,7 @@ void __init numa_set_distance(int from, int to, int distance)
 
 int __node_distance(int from, int to)
 {
-	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
+	if (from > numa_distance_cnt || to > numa_distance_cnt)
 		return from == to ? LOCAL_DISTANCE : REMOTE_DISTANCE;
 	return numa_distance[from * numa_distance_cnt + to];
 }
