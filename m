Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab2ILV4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 17:56:03 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:46382 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753837Ab2ILVz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 17:55:58 -0400
Date: Wed, 12 Sep 2012 23:55:54 +0200
From: Simon Baatz <gmbnomis@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Simon Baatz <gmbnomis@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 09/31] arm64: Cache maintenance routines
Message-ID: <20120912215553.GA17393@schnuecks.de>
References: <1347035226-18649-1-git-send-email-catalin.marinas@arm.com>
 <1347035226-18649-10-git-send-email-catalin.marinas@arm.com>
 <20120907193542.GA22806@schnuecks.de>
 <20120912092954.GA21823@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120912092954.GA21823@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

On Wed, Sep 12, 2012 at 10:29:54AM +0100, Catalin Marinas wrote:
> 
> > > +void __flush_dcache_page(struct address_space *mapping, struct page *page)
> > > +{
> > > +     __flush_dcache_area(page_address(page), PAGE_SIZE);
> > > +}
> > > +
> > > +void __sync_icache_dcache(pte_t pte)
> > > +{
> > > +     unsigned long pfn;
> > > +     struct page *page;
> > > +
> > > +     pfn = pte_pfn(pte);
> > > +     if (!pfn_valid(pfn))
> > > +             return;
> > > +
> > > +     page = pfn_to_page(pfn);
> > > +     if (!test_and_set_bit(PG_dcache_clean, &page->flags))
> > > +             __flush_dcache_page(NULL, page);
> > > +     __flush_icache_all();
> > > +}
> > > +
> > > +/*
> > > + * Ensure cache coherency between kernel mapping and userspace mapping of this
> > > + * page.
> > > + */
> > > +void flush_dcache_page(struct page *page)
> > > +{
> > > +     struct address_space *mapping;
> > > +
> > > +     /*
> > > +      * The zero page is never written to, so never has any dirty cache
> > > +      * lines, and therefore never needs to be flushed.
> > > +      */
> > > +     if (page == ZERO_PAGE(0))
> > > +             return;
> > > +
> > > +     mapping = page_mapping(page);
> > > +
> > > +     if (mapping && !mapping_mapped(mapping))
> > > +             clear_bit(PG_dcache_clean, &page->flags);
> > > +     else {
> > > +             __flush_dcache_page(mapping, page);
> > > +             if (mapping)
> > > +                     __flush_icache_all();
> > 
> > 
> > Is this necessary to ensure I/D coherency? Then, I would have
> > expected
> > 
> >                 if (mapping) {
> >                         __flush_dcache_page(mapping, page);
> >                         __flush_icache_all();
> >                 }
> > 
> > similar to __sync_icache_dcache() above.
> 
> We don't want to do additional flushing if !mapping_mapped() as the page
> isn't mapped in user space. In this case we defer the flushing until
> __sync_icache_dcache().
> 
> The other case is for anonymous pages where mapping == NULL. Here we
> don't defer the D-cache flush and do it directly. The I-cache, if
> needed, is handled later in __sync_icache_dcache(). This was based on
> the idea that this case is mainly for the args/env page which is mapped
> shortly after anyway, so not worth deferring. On AArch64, I don't think
> it makes any difference. Maybe a slight improvement (at least in
> clarity) in flush_dcache_page():
> 
> 	if (mapping && mapping_mapped(mapping)) {
> 		__flush_dcache_page(page);
> 		__flush_icache_all();
> 		set_bit(PG_dcache_clean, &page->flags);
> 	} else {
> 		clear_bit(PG_dcache_clean, &page->flags);
> 	}
> 
> In this case the anonymous page flushing is deferred to
> __sync_icache_dcache().

Yes, I think this is much clearer. It makes clear that the D-cache
flush is done to avoid I/D incoherencies.  Previously, the obvious
question was "Why do we flush only the D-cache in some situations
given that it essentially behaves like a PIPT cache?" (the motivation
for this became only clear to me after your explanation.)

However, the reason why this was an obvious question for me is
interesting: I think the main use case you had in mind does not
happen since about five years (since commit b6a2fe, "mm: variable
length argument support").  And I had a completely different main use
case in mind.

I reckon that the use case you refer to is the use in fs/exec.c? 
Copying arg/env was changed in the commit mentioned above.  This also
changed the use of flush_dcache_page() (which is not supposed to
handle anon pages) into flush_kernel_dcache_page() (which is supposed
to handle kernel modified user pages, i.e.  also anon pages).

Nevertheless, the __flush_dcache_page(mapping, page) in the
mapping==NULL case is absoluty necessary for aliasing D-caches on arm
for the use case I had in mind (which does not apply to arm64 and
thus my question).

In case of direct I/O (and probably also in other cases like SG_IO)
the block layer will see pages from get_user_pages() directly, i.e.
also anonymous pages. Many drivers (especially emulated storage
drivers like dm-crypt) use flush_dcache_page() after modifying a
page. Although flush_dcache_page() is not even supposed to handle
anonymous pages, it flushes the kernel mapping of the page because of
this code line and everything is well on aliasing D-caches.

Ironically, flush_kernel_dcache_page(), which is specifically
designed to handle this case, does not on arm.  Thus, those few parts
of the kernel which use flush_kernel_dcache_page() may fail horribly
(for example the scatterlist memory iterator API, see [1]).

Back to arm64 (and possibly to arm with non-aliasing D-caches?), this
also means that the saved D-cache flush in the anonymous page case is
not only a slight improvement on clarity, but may avoid a
considerable number of D-cache flushes in some I/O situations.  (If
it is still correct that there are no problems with the I-cache for
this use case.)

If now we could additionally avoid to flush the entire I-cache for
every page in direct I/O operations with user mapped page cache
pages (e.g. direct I/O read into an mmap region)...

 
> > What is the reason why the D-cache flush is done in different
> > cases than the following I-cache flush?
> 
> For __sync_icache_dcache(), we need to handle the situation where the
> page mapped into user space has been cleaned (D-cache) but there may be
> stale data in the I-cache. I think this can only happen with an
> ASID-tagged VIVT I-cache configuration (which is allowed on AArch64) if
> an existing page has been unmapped and the same virtual address remapped
> (withing the same mm context) to a different page that had been cleaned
> previously. We could optimise the __sync_icache_dcache() as below:
> 
> 	if (!test_and_set_bit(PG_dcache_clean, &page->flags)) {
> 		__flush_dcache_page(page);
> 		__flush_icache_all();
> 	} else if (icache_is_aivivt()) {
> 		__flush_icache_all();
> 	}

Sorry, this is out of my depth. I think I don't really understand the
cases leading to I/D incoherency.


- Simon

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2012-July/111393.html

PS: You did not mention the following comment from my mail. It was
easy to overlook. Just to make sure you did not miss it:

> diff --git a/arch/arm64/mm/cache.S b/arch/arm64/mm/cache.S
> new file mode 100644
> index 0000000..3df0aa7
> --- /dev/null
> +++ b/arch/arm64/mm/cache.S

...
> +/*
> + *	__flush_kern_dcache_page(kaddr)


Should be:  __flush_dcache_area(kaddr,size)

> + *
> + *	Ensure that the data held in the page kaddr is written back
> to the
> + *	page in question.

s/page/area

> + *
> + *	- kaddr   - kernel address
> + *	- size    - size in question
> + */
> +ENTRY(__flush_dcache_area)
> +	dcache_line_size x2, x3
> +	add	x1, x0, x1
> +
