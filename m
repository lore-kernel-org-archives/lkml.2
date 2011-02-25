Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932316Ab1BYJFV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 04:05:21 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51942 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754271Ab1BYJFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 04:05:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VP4hTn+r1x+lQwqMIRLSEdePSHZ64GO4FDJSRQtjfktraf4lU7jeIPuRXXjEp/B8jx
         HZQbBVeJcoubBTafM8Z/Evek2cAeBou5e1Tm6w0zLuR4qBjgziJht+ElfYLSjSxAufx1
         S4mJ0Fxm38y6DGxznG3adCftUqTsXRiliQrVM=
Date: Fri, 25 Feb 2011 10:05:12 +0100
From: Tejun Heo <tj@kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, Yinghai Lu <yinghai@kernel.org>,
        tglx@linutronix.de, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] x86, mm: Fix size of numa_distance array
Message-ID: <20110225090512.GC24828@htj.dyndns.org>
References: <20110224145128.GM7840@htj.dyndns.org>
 <4D66AC9C.6080500@kernel.org>
 <20110224192305.GB15498@elte.hu>
 <4D66B176.9030300@kernel.org>
 <20110224193211.GC15498@elte.hu>
 <AANLkTimvJ=BLDjoRDXg_TRSepd9GoDx-w_FonSCZtybi@mail.gmail.com>
 <alpine.DEB.2.00.1102241330270.28798@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1102241530310.9247@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1102241530310.9247@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Feb 24, 2011 at 03:31:24PM -0800, David Rientjes wrote:
> > -	size = ++cnt * sizeof(numa_distance[0]);
> > +	size = cnt * cnt * sizeof(numa_distance[0]);
> >  
> >  	phys = memblock_find_in_range(0, (u64)max_pfn_mapped << PAGE_SHIFT,
> >  				      size, PAGE_SIZE);
> > 
> 
> This also looks like it needs the following to not erroneously consider a 
> node id to be out of bounds.  Why were we oversizing cnt in the old code 
> above by 1?

Umm... because @cnt should be length not the last index?

> diff --git a/arch/x86/mm/numa_64.c b/arch/x86/mm/numa_64.c
> --- a/arch/x86/mm/numa_64.c
> +++ b/arch/x86/mm/numa_64.c
> @@ -454,7 +454,7 @@ void __init numa_set_distance(int from, int to, int distance)
>  	if (!numa_distance && numa_alloc_distance() < 0)
>  		return;
>  
> -	if (from >= numa_distance_cnt || to >= numa_distance_cnt) {
> +	if (from > numa_distance_cnt || to > numa_distance_cnt) {
>  		printk_once(KERN_DEBUG "NUMA: Debug: distance out of bound, from=%d to=%d distance=%d\n",
>  			    from, to, distance);
>  		return;
> @@ -472,7 +472,7 @@ void __init numa_set_distance(int from, int to, int distance)
>  
>  int __node_distance(int from, int to)
>  {
> -	if (from >= numa_distance_cnt || to >= numa_distance_cnt)
> +	if (from > numa_distance_cnt || to > numa_distance_cnt)

Again, numa_distance_cnt is the number of elements in one dimension of
the table not the index, while @from and @to are 0 based index.

Thanks.

-- 
tejun
