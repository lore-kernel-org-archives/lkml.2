Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab1DORUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 13:20:33 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52309 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558Ab1DORUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 13:20:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:content-type:to:cc:subject:references:date:mime-version
         :content-transfer-encoding:from:message-id:in-reply-to:user-agent;
        b=dPIJu5amTw6sN8e7iqfObxsa6kzRLCdTH2QnjhpBRBlfZWQ97ZoF8hNOTw9iVhR1/A
         giBJ7LYJRSWPCJNoZDG2tC4pkRdiVBcpu0KfHT2/7H8rMItabA+M2Dfw7Ztw9+r1dIm9
         08Ngz6s/p76BnGOp3l4NY0jU8B0BPtCwp8lic=
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-mm@kvack.org, "Dave Hansen" <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, "Johannes Weiner" <hannes@cmpxchg.org>,
        "David Rientjes" <rientjes@google.com>, akpm@osdl.org
Subject: Re: [PATCH 2/2] print vmalloc() state after allocation failures
References: <20110415170437.17E1AF36@kernel> <20110415170438.D5C317D5@kernel>
Date: Fri, 15 Apr 2011 19:20:28 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.vtzo4ejf3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <20110415170438.D5C317D5@kernel>
User-Agent: Opera Mail/11.10 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Apr 2011 19:04:38 +0200, Dave Hansen wrote:
> diff -puN mm/vmalloc.c~vmalloc-warn mm/vmalloc.c
> --- linux-2.6.git/mm/vmalloc.c~vmalloc-warn	2011-04-15  
> 08:49:06.823306620 -0700
> +++ linux-2.6.git-dave/mm/vmalloc.c	2011-04-15 09:20:17.926460283 -0700
> @@ -1534,6 +1534,7 @@ static void *__vmalloc_node(unsigned lon
>  static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				 pgprot_t prot, int node, void *caller)
>  {
> +	int order = 0;

Could we make that const?

>  	struct page **pages;
>  	unsigned int nr_pages, array_size, i;
>  	gfp_t nested_gfp = (gfp_mask & GFP_RECLAIM_MASK) | __GFP_ZERO;
> @@ -1560,11 +1561,12 @@ static void *__vmalloc_area_node(struct
> 	for (i = 0; i < area->nr_pages; i++) {
>  		struct page *page;
> +		gfp_t tmp_mask = gfp_mask | __GFP_NOWARN;
> 		if (node < 0)
> -			page = alloc_page(gfp_mask);
> +			page = alloc_page(tmp_mask);
>  		else
> -			page = alloc_pages_node(node, gfp_mask, 0);
> +			page = alloc_pages_node(node, tmp_mask, order);

so it'll be more visible that we are passing 0 here.

> 		if (unlikely(!page)) {
>  			/* Successfully allocated i pages, free them in __vunmap() */
> @@ -1579,6 +1581,9 @@ static void *__vmalloc_area_node(struct
>  	return area->addr;
> fail:
> +	warn_alloc_failed(gfp_mask, order, "vmalloc: allocation failure, "
> +			  "allocated %ld of %ld bytes\n",
> +			  (area->nr_pages*PAGE_SIZE), area->size);
>  	vfree(area->addr);
>  	return NULL;
>  }
> _
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Fight unfair telecom internet charges in Canada: sign  
> http://stopthemeter.ca/
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>


-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
