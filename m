Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756442Ab1DHM2w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 08:28:52 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64612 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab1DHM2v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 08:28:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=D2KQSqgBZ/ptiUPl0WC6E4kIzY68spRR8BNacFjVrj3ZybBAjAOPEjId/W/lwvmTrH
         i+DzgVU8ekaPLfofluDFE8WHe9nn/QCXoDLt6SNRxbkSS/7Rb8L30xDVpxH8miawMh9g
         6y9gbbA45Q2/l5LRtD/3oU9BylBuuA04aazxM=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-mm@kvack.org, "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Timur Tabi" <timur@freescale.com>,
        "Andi Kleen" <andi@firstfloor.org>, "Mel Gorman" <mel@csn.ul.ie>,
        "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] make new alloc_pages_exact()
References: <20110407172104.1F8B7329@kernel> <20110407172105.831B9A0A@kernel>
Date: Fri, 08 Apr 2011 14:28:47 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtmcx9kd3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110407172105.831B9A0A@kernel>
User-Agent: Opera Mail/11.01 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Apr 2011 19:21:05 +0200, Dave Hansen <dave@linux.vnet.ibm.com>  
wrote:
> +struct page *__alloc_pages_exact(gfp_t gfp_mask, size_t size)
>  {
>  	unsigned int order = get_order(size);
> -	unsigned long addr;
> +	struct page *page;
> -	addr = __get_free_pages(gfp_mask, order);
> -	if (addr) {
> -		unsigned long alloc_end = addr + (PAGE_SIZE << order);
> -		unsigned long used = addr + PAGE_ALIGN(size);
> +	page = alloc_pages(gfp_mask, order);
> +	if (page) {
> +		struct page *alloc_end = page + (1 << order);
> +		struct page *used = page + PAGE_ALIGN(size)/PAGE_SIZE;
> -		split_page(virt_to_page((void *)addr), order);
> +		split_page(page, order);
>  		while (used < alloc_end) {
> -			free_page(used);
> -			used += PAGE_SIZE;
> +			__free_page(used);
> +			used++;
>  		}

Have you thought about moving this loop to a separate function, ie.
_free_page_range(start, end)?  I'm asking because this loop appears
in two places and my CMA would also benefit from such a function.

>  	}
> -	return (void *)addr;
> +	return page;
> +}

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
