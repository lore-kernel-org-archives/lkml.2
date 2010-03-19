Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab0CSS7m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 14:59:42 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:33252 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751315Ab0CSS7k (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Fri, 19 Mar 2010 14:59:40 -0400
Date: Fri, 19 Mar 2010 14:28:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Infinite loop on boot in free_early_partial due to start==end
	on tip/master
Message-ID: <20100319182807.GA14985@phenom.dumpdata.com>
References: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267801390.11737.38014.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BA3C963.0107:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: x86: do not free zero sized per cpu areas
> 
> This avoids an infinite loop in free_early_partial().

The patch fixed PV guests booting on Xen. I've added my
Tested-by .. Please merge it in the release.

Thanks!
> 
> Add a warning to free_early_partial to catch future problems.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>

Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
> index ef6370b..89a3205 100644
> --- a/arch/x86/kernel/setup_percpu.c
> +++ b/arch/x86/kernel/setup_percpu.c
> @@ -140,7 +140,8 @@ static void __init pcpu_fc_free(void *ptr, size_t size)
>  #ifdef CONFIG_NO_BOOTMEM
>  	u64 start = __pa(ptr);
>  	u64 end = start + size;
> -	free_early_partial(start, end);
> +	if (start < end)
> +		free_early_partial(start, end);
>  #else
>  	free_bootmem(__pa(ptr), size);
>  #endif
> diff --git a/kernel/early_res.c b/kernel/early_res.c
> index 3cb2c66..fbde443 100644
> --- a/kernel/early_res.c
> +++ b/kernel/early_res.c
> @@ -333,6 +333,8 @@ void __init free_early_partial(u64 start, u64 end)
>  	struct early_res *r;
>  	int i;
>  
> +	WARN_ON(start>=end);
> +
>  try_next:
>  	i = find_overlapped_early(start, end);
>  	if (i >= max_early_res)
