Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755771Ab1EPUex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 16:34:53 -0400
Received: from smtp-out.google.com ([74.125.121.67]:18000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755590Ab1EPUew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 16:34:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=dKHo4//NiBxUOpVesQWV9aBIhlxbtOZGW+gk2ejSqz/+6heJKR61QrWUTLM/Ra6aWC
         PSAH2mG5dvm2uebdGx1w==
Date: Mon, 16 May 2011 13:34:46 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: linux-kernel@vger.kernel.org
cc: mm-commits@vger.kernel.org, dkiper@net-space.pl, dave@linux.vnet.ibm.com
Subject: Re: + mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
 added to -mm tree
In-Reply-To: <201105032335.p43NZsk4017523@imap1.linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1105161334120.4353@chino.kir.corp.google.com>
References: <201105032335.p43NZsk4017523@imap1.linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 May 2011, akpm@linux-foundation.org wrote:

> 
> The patch titled
>      mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
> has been added to the -mm tree.  Its filename is
>      mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
> 
> Before you just go and hit "reply", please:
>    a) Consider who else should be cc'ed
>    b) Prefer to cc a suitable mailing list as well
>    c) Ideally: find the original patch on the mailing list and do a
>       reply-to-all to that, adding suitable additional cc's
> 
> *** Remember to use Documentation/SubmitChecklist when testing your code ***
> 
> See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
> out what to do about this
> 
> The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
> 
> ------------------------------------------------------
> Subject: mm: enable set_page_section() only if CONFIG_SPARSEMEM and !CONFIG_SPARSEMEM_VMEMMAP
> From: Daniel Kiper <dkiper@net-space.pl>
> 
> set_page_section() is valid only in CONFIG_SPARSEMEM and
> !CONFIG_SPARSEMEM_VMEMMAP context.  Move it to proper place and amend
> accordingly functions which are using it.
> 

set_page_section() is always valid, but only meaningful for 
CONFIG_SPARSEMEM.

Needs s/valid/meaningful/.

After that:

Acked-by: David Rientjes <rientjes@google.com>

> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> Acked-by: Dave Hansen <dave@linux.vnet.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  include/linux/mm.h |   14 ++++++++------
>  1 file changed, 8 insertions(+), 6 deletions(-)
> 
> diff -puN include/linux/mm.h~mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap include/linux/mm.h
> --- a/include/linux/mm.h~mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap
> +++ a/include/linux/mm.h
> @@ -682,6 +682,12 @@ static inline struct zone *page_zone(str
>  }
>  
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +static inline void set_page_section(struct page *page, unsigned long section)
> +{
> +	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
> +	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
> +}
> +
>  static inline unsigned long page_to_section(struct page *page)
>  {
>  	return (page->flags >> SECTIONS_PGSHIFT) & SECTIONS_MASK;
> @@ -700,18 +706,14 @@ static inline void set_page_node(struct 
>  	page->flags |= (node & NODES_MASK) << NODES_PGSHIFT;
>  }
>  
> -static inline void set_page_section(struct page *page, unsigned long section)
> -{
> -	page->flags &= ~(SECTIONS_MASK << SECTIONS_PGSHIFT);
> -	page->flags |= (section & SECTIONS_MASK) << SECTIONS_PGSHIFT;
> -}
> -
>  static inline void set_page_links(struct page *page, enum zone_type zone,
>  	unsigned long node, unsigned long pfn)
>  {
>  	set_page_zone(page, zone);
>  	set_page_node(page, node);
> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
>  	set_page_section(page, pfn_to_section_nr(pfn));
> +#endif
>  }
>  
>  /*
> _
> 
> Patches currently in -mm which might be from dkiper@net-space.pl are
> 
> linux-next.patch
> mm-remove-dependency-on-config_flatmem-from-online_page.patch
> mm-enable-set_page_section-only-if-config_sparsemem-and-config_sparsemem_vmemmap.patch
> mm-pfn_to_section_nr-section_nr_to_pfn-is-valid-only-in-config_sparsemem-context.patch
> mm-do-not-define-pfn_section_shift-if-config_sparsemem.patch
> 
> --
> To unsubscribe from this list: send the line "unsubscribe mm-commits" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
