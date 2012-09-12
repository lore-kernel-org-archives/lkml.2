Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2ILJbP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 05:31:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:60908 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754476Ab2ILJbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 05:31:12 -0400
Date: Wed, 12 Sep 2012 10:29:54 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 09/31] arm64: Cache maintenance routines
Message-ID: <20120912092954.GA21823@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
 <20120907193542.GA22806@schnuecks.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907193542.GA22806@schnuecks.de>
Thread-Topic: [PATCH v3 09/31] arm64: Cache maintenance routines
Accept-Language: en-GB, en-US
Content-Language: en-US
acceptlanguage: en-GB, en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Fri, Sep 07, 2012 at 08:35:42PM +0100, Simon Baatz wrote:
> On Fri, Sep 07, 2012 at 05:26:44PM +0100, Catalin Marinas wrote:
> > +#define ARCH_HAS_FLUSH_ANON_PAGE
> > +static inline void flush_anon_page(struct vm_area_struct *vma,
> > +                      struct page *page, unsigned long vmaddr)
> > +{
> > +     extern void __flush_anon_page(struct vm_area_struct *vma,
> > +                             struct page *, unsigned long);
> > +     if (PageAnon(page))
> > +             __flush_anon_page(vma, page, vmaddr);
> 
> 
> __flush_anon_page() does nothing. Shouldn't this be removed as well?

Yes, good point.

> > +void __flush_dcache_page(struct address_space *mapping, struct page *page)
> > +{
> > +     __flush_dcache_area(page_address(page), PAGE_SIZE);
> > +}
> > +
> > +void __sync_icache_dcache(pte_t pte)
> > +{
> > +     unsigned long pfn;
> > +     struct page *page;
> > +
> > +     pfn = pte_pfn(pte);
> > +     if (!pfn_valid(pfn))
> > +             return;
> > +
> > +     page = pfn_to_page(pfn);
> > +     if (!test_and_set_bit(PG_dcache_clean, &page->flags))
> > +             __flush_dcache_page(NULL, page);
> > +     __flush_icache_all();
> > +}
> > +
> > +/*
> > + * Ensure cache coherency between kernel mapping and userspace mapping of this
> > + * page.
> > + */
> > +void flush_dcache_page(struct page *page)
> > +{
> > +     struct address_space *mapping;
> > +
> > +     /*
> > +      * The zero page is never written to, so never has any dirty cache
> > +      * lines, and therefore never needs to be flushed.
> > +      */
> > +     if (page == ZERO_PAGE(0))
> > +             return;
> > +
> > +     mapping = page_mapping(page);
> > +
> > +     if (mapping && !mapping_mapped(mapping))
> > +             clear_bit(PG_dcache_clean, &page->flags);
> > +     else {
> > +             __flush_dcache_page(mapping, page);
> > +             if (mapping)
> > +                     __flush_icache_all();
> 
> 
> Is this necessary to ensure I/D coherency? Then, I would have
> expected
> 
>                 if (mapping) {
>                         __flush_dcache_page(mapping, page);
>                         __flush_icache_all();
>                 }
> 
> similar to __sync_icache_dcache() above.

We don't want to do additional flushing if !mapping_mapped() as the page
isn't mapped in user space. In this case we defer the flushing until
__sync_icache_dcache().

The other case is for anonymous pages where mapping == NULL. Here we
don't defer the D-cache flush and do it directly. The I-cache, if
needed, is handled later in __sync_icache_dcache(). This was based on
the idea that this case is mainly for the args/env page which is mapped
shortly after anyway, so not worth deferring. On AArch64, I don't think
it makes any difference. Maybe a slight improvement (at least in
clarity) in flush_dcache_page():

	if (mapping && mapping_mapped(mapping)) {
		__flush_dcache_page(page);
		__flush_icache_all();
		set_bit(PG_dcache_clean, &page->flags);
	} else {
		clear_bit(PG_dcache_clean, &page->flags);
	}

In this case the anonymous page flushing is deferred to
__sync_icache_dcache().

> What is the reason why the D-cache flush is done in different
> cases than the following I-cache flush?

For __sync_icache_dcache(), we need to handle the situation where the
page mapped into user space has been cleaned (D-cache) but there may be
stale data in the I-cache. I think this can only happen with an
ASID-tagged VIVT I-cache configuration (which is allowed on AArch64) if
an existing page has been unmapped and the same virtual address remapped
(withing the same mm context) to a different page that had been cleaned
previously. We could optimise the __sync_icache_dcache() as below:

	if (!test_and_set_bit(PG_dcache_clean, &page->flags)) {
		__flush_dcache_page(page);
		__flush_icache_all();
	} else if (icache_is_aivivt()) {
		__flush_icache_all();
	}

> > +             set_bit(PG_dcache_clean, &page->flags);
> > +     }
> > +}
> > +EXPORT_SYMBOL(flush_dcache_page);
> > +
> > +void __flush_anon_page(struct vm_area_struct *vma, struct page *page, unsigned long vmaddr)
> > +{
> > +}
> 
> Note that the __flush_dcache_page(mapping, page) in
> flush_dcache_page() above is called when page is an anonymous page
> (since mapping == NULL in this case).  If the call to
> __flush_dcache_page() is right above, it should be needed
> here as well?

flush_anon_page() is called when the kernel needs to access an anonymous
page. Given that the D-cache behaves like a PIPT, there is no need for
additional flushing here. The flush_dcache_page() call was based on the
assumption that such page needs flushing anyway and it's not worth
deferring. But the code may be easier to understand as I suggested above
(and slightly more optimal for the VIPT I-cache case).

It looks like any other architecture does something different here.

-- 
Catalin
