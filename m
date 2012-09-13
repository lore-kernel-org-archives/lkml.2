Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923Ab2IMMkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:40:07 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:51541 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755004Ab2IMMkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:40:05 -0400
Date: Thu, 13 Sep 2012 13:38:50 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Simon Baatz <gmbnomis@gmail.com>
Cc: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 09/31] arm64: Cache maintenance routines
Message-ID: <20120913123850.GB25131@arm.com>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
 <20120907193542.GA22806@schnuecks.de>
 <20120912092954.GA21823@arm.com>
 <20120912215553.GA17393@schnuecks.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912215553.GA17393@schnuecks.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 12, 2012 at 10:55:54PM +0100, Simon Baatz wrote:
> On Wed, Sep 12, 2012 at 10:29:54AM +0100, Catalin Marinas wrote:
> > > > +void __flush_dcache_page(struct address_space *mapping, struct page *page)
> > > > +{
> > > > +     __flush_dcache_area(page_address(page), PAGE_SIZE);
> > > > +}
> > > > +
> > > > +void __sync_icache_dcache(pte_t pte)
> > > > +{
> > > > +     unsigned long pfn;
> > > > +     struct page *page;
> > > > +
> > > > +     pfn = pte_pfn(pte);
> > > > +     if (!pfn_valid(pfn))
> > > > +             return;
> > > > +
> > > > +     page = pfn_to_page(pfn);
> > > > +     if (!test_and_set_bit(PG_dcache_clean, &page->flags))
> > > > +             __flush_dcache_page(NULL, page);
> > > > +     __flush_icache_all();
> > > > +}
> > > > +
> > > > +/*
> > > > + * Ensure cache coherency between kernel mapping and userspace mapping of this
> > > > + * page.
> > > > + */
> > > > +void flush_dcache_page(struct page *page)
> > > > +{
> > > > +     struct address_space *mapping;
> > > > +
> > > > +     /*
> > > > +      * The zero page is never written to, so never has any dirty cache
> > > > +      * lines, and therefore never needs to be flushed.
> > > > +      */
> > > > +     if (page == ZERO_PAGE(0))
> > > > +             return;
> > > > +
> > > > +     mapping = page_mapping(page);
> > > > +
> > > > +     if (mapping && !mapping_mapped(mapping))
> > > > +             clear_bit(PG_dcache_clean, &page->flags);
> > > > +     else {
> > > > +             __flush_dcache_page(mapping, page);
> > > > +             if (mapping)
> > > > +                     __flush_icache_all();
> > > 
> > > 
> > > Is this necessary to ensure I/D coherency? Then, I would have
> > > expected
> > > 
> > >                 if (mapping) {
> > >                         __flush_dcache_page(mapping, page);
> > >                         __flush_icache_all();
> > >                 }
> > > 
> > > similar to __sync_icache_dcache() above.
> > 
> > We don't want to do additional flushing if !mapping_mapped() as the page
> > isn't mapped in user space. In this case we defer the flushing until
> > __sync_icache_dcache().
> > 
> > The other case is for anonymous pages where mapping == NULL. Here we
> > don't defer the D-cache flush and do it directly. The I-cache, if
> > needed, is handled later in __sync_icache_dcache(). This was based on
> > the idea that this case is mainly for the args/env page which is mapped
> > shortly after anyway, so not worth deferring. On AArch64, I don't think
> > it makes any difference. Maybe a slight improvement (at least in
> > clarity) in flush_dcache_page():
> > 
> > 	if (mapping && mapping_mapped(mapping)) {
> > 		__flush_dcache_page(page);
> > 		__flush_icache_all();
> > 		set_bit(PG_dcache_clean, &page->flags);
> > 	} else {
> > 		clear_bit(PG_dcache_clean, &page->flags);
> > 	}
> > 
> > In this case the anonymous page flushing is deferred to
> > __sync_icache_dcache().
> 
> Yes, I think this is much clearer. It makes clear that the D-cache
> flush is done to avoid I/D incoherencies.  Previously, the obvious
> question was "Why do we flush only the D-cache in some situations
> given that it essentially behaves like a PIPT cache?" (the motivation
> for this became only clear to me after your explanation.)
> 
> However, the reason why this was an obvious question for me is
> interesting: I think the main use case you had in mind does not
> happen since about five years (since commit b6a2fe, "mm: variable
> length argument support").  And I had a completely different main use
> case in mind.
> 
> I reckon that the use case you refer to is the use in fs/exec.c? 
> Copying arg/env was changed in the commit mentioned above.  This also
> changed the use of flush_dcache_page() (which is not supposed to
> handle anon pages) into flush_kernel_dcache_page() (which is supposed
> to handle kernel modified user pages, i.e.  also anon pages).

That's what I was thinking about, thanks for the pointer. I still get a
flush_dcache_page() call (on the source page) from copy_strings() via
get_user_page() but with my changes above it doesn't trigger any cache
flushing (which is correct).

> In case of direct I/O (and probably also in other cases like SG_IO)
> the block layer will see pages from get_user_pages() directly, i.e.
> also anonymous pages. Many drivers (especially emulated storage
> drivers like dm-crypt) use flush_dcache_page() after modifying a
> page. Although flush_dcache_page() is not even supposed to handle
> anonymous pages, it flushes the kernel mapping of the page because of
> this code line and everything is well on aliasing D-caches.

According to the cachetlb.txt document (though not sure architecture
ports follow it entirely), flush_dcache_page() deliberately shouldn't
follow anonymous pages. But it seems that we do it on ARM (maybe as an
alternative to flush_kernel_dcache_page()).

> Back to arm64 (and possibly to arm with non-aliasing D-caches?), this
> also means that the saved D-cache flush in the anonymous page case is
> not only a slight improvement on clarity, but may avoid a
> considerable number of D-cache flushes in some I/O situations.  (If
> it is still correct that there are no problems with the I-cache for
> this use case.)

The I-cache would be needed if the kernel modifies an executable user
page. But I don't see a case for this yet. So with non-aliasing D-cache
the flush_kernel_dcache_page() can be a nop.

> If now we could additionally avoid to flush the entire I-cache for
> every page in direct I/O operations with user mapped page cache
> pages (e.g. direct I/O read into an mmap region)...

If the page is already mapped, we don't have a later hook to be able to
flush the caches, so we do it here. We can avoid the I-cache operation
only if we are sure that the user would not execute code from such page.
IOW the direct I/O wouldn't write any instructions.

The powerpc implementation of flush_dcache_page() doesn't even check for
the existence of a mapping, it always marks the page as dirty. We can do
the same on arm64 (only leave the clear_bit part of the condition) as
long as we know that the kernel wouldn't write new code into a page that
is already mapped.

> > > What is the reason why the D-cache flush is done in different
> > > cases than the following I-cache flush?
> > 
> > For __sync_icache_dcache(), we need to handle the situation where the
> > page mapped into user space has been cleaned (D-cache) but there may be
> > stale data in the I-cache. I think this can only happen with an
> > ASID-tagged VIVT I-cache configuration (which is allowed on AArch64) if
> > an existing page has been unmapped and the same virtual address remapped
> > (withing the same mm context) to a different page that had been cleaned
> > previously. We could optimise the __sync_icache_dcache() as below:
> > 
> > 	if (!test_and_set_bit(PG_dcache_clean, &page->flags)) {
> > 		__flush_dcache_page(page);
> > 		__flush_icache_all();
> > 	} else if (icache_is_aivivt()) {
> > 		__flush_icache_all();
> > 	}
> 
> Sorry, this is out of my depth. I think I don't really understand the
> cases leading to I/D incoherency.

That's with a VIVT I-cache where a process mapped some file at a virtual
address, unmapped it and remapped a different file at the same virtual
address. For the latter file, the page may have already been cleaned by
a different process but our process has stale I-cache entries from the
previous mapping. With physically tagged I-cache, this wouldn't be
necessary.

-- 
Catalin
