Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab1JKE0J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 00:26:09 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43498 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JKE0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 00:26:07 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=REFwgzLsF+YKVjG3Yqdt38yPBggl929sbqqzo47vZRYpN3gtAWHZoYz0t9xSIIUfN
	dX/qVT0Ogox2gb2wounXw==
Date: Mon, 10 Oct 2011 21:26:00 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>
cc: Greg KH <greg@kroah.com>, linux-mm <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, nfont@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: memory hotplug: Check if pages are correctly reserved
 on a per-section basis
In-Reply-To: <20111010164152.5485fbaf.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1110102125040.12035@chino.kir.corp.google.com>
References: <20111010071119.GE6418@suse.de> <20111010150038.ac161977.akpm@linux-foundation.org> <20111010232403.GA30513@kroah.com> <20111010162813.7a470ae4.akpm@linux-foundation.org> <20111010233531.GA7234@kroah.com>
 <20111010164152.5485fbaf.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Andrew Morton wrote:

> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index 2840ed4..ffb69cd 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -224,13 +224,48 @@ int memory_isolate_notify(unsigned long val, void *v)
>  }
>  
>  /*
> + * The probe routines leave the pages reserved, just as the bootmem code does.
> + * Make sure they're still that way.
> + */
> +static bool pages_correctly_reserved(unsigned long start_pfn,
> +					unsigned long nr_pages)
> +{
> +	int i, j;
> +	struct page *page;
> +	unsigned long pfn = start_pfn;
> +
> +	/*
> +	 * memmap between sections is not contiguous except with
> +	 * SPARSEMEM_VMEMMAP. We lookup the page once per section
> +	 * and assume memmap is contiguous within each section
> +	 */
> +	for (i = 0; i < sections_per_block; i++, pfn += PAGES_PER_SECTION) {
> +		if (WARN_ON_ONCE(!pfn_valid(pfn)))
> +			return false;
> +		page = pfn_to_page(pfn);
> +
> +		for (j = 0; j < PAGES_PER_SECTION; j++) {
> +			if (PageReserved(page + i))

page + j

> +				continue;
> +
> +			printk(KERN_WARNING "section number %ld page number %d "
> +				"not reserved, was it already online?\n",
> +				pfn_to_section_nr(pfn), j);
> +
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
> +/*
>   * MEMORY_HOTPLUG depends on SPARSEMEM in mm/Kconfig, so it is
>   * OK to have direct references to sparsemem variables in here.
>   */
>  static int
>  memory_block_action(unsigned long phys_index, unsigned long action)
>  {
> -	int i;
>  	unsigned long start_pfn, start_paddr;
>  	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
>  	struct page *first_page;
> @@ -238,26 +273,13 @@ memory_block_action(unsigned long phys_index, unsigned long action)
>  
>  	first_page = pfn_to_page(phys_index << PFN_SECTION_SHIFT);
>  
> -	/*
> -	 * The probe routines leave the pages reserved, just
> -	 * as the bootmem code does.  Make sure they're still
> -	 * that way.
> -	 */
> -	if (action == MEM_ONLINE) {
> -		for (i = 0; i < nr_pages; i++) {
> -			if (PageReserved(first_page+i))
> -				continue;
> -
> -			printk(KERN_WARNING "section number %ld page number %d "
> -				"not reserved, was it already online?\n",
> -				phys_index, i);
> -			return -EBUSY;
> -		}
> -	}
> -
>  	switch (action) {
>  		case MEM_ONLINE:
>  			start_pfn = page_to_pfn(first_page);
> +
> +			if (!pages_correctly_reserved(start_pfn, nr_pages))
> +				return -EBUSY;
> +
>  			ret = online_pages(start_pfn, nr_pages);
>  			break;
>  		case MEM_OFFLINE:
