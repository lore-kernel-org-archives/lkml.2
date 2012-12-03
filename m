Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab2LCHw3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 02:52:29 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52000 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750760Ab2LCHw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 02:52:28 -0500
X-AuditID: 9c93016f-b7b86ae000003a75-01-50bc5a3a4520
Date: Mon, 3 Dec 2012 16:52:26 +0900
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] zsmalloc: add function to query object size
Message-ID: <20121203075226.GA4065@blaptop>
References: <1354258489-2703-1-git-send-email-ngupta@vflare.org>
 <20121130135124.GA22196@blaptop>
 <BA4DD5DA-0E4F-470E-98F5-DDA937636189@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BA4DD5DA-0E4F-470E-98F5-DDA937636189@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 02, 2012 at 11:20:42PM -0800, Nitin Gupta wrote:
> 
> 
> On Nov 30, 2012, at 5:54 AM, Minchan Kim <minchan.kernel.2@gmail.com> wrote:
> 
> > On Thu, Nov 29, 2012 at 10:54:48PM -0800, Nitin Gupta wrote:
> >> Changelog v2 vs v1:
> >> - None
> >> 
> >> Adds zs_get_object_size(handle) which provides the size of
> >> the given object. This is useful since the user (zram etc.)
> >> now do not have to maintain object sizes separately, saving
> >> on some metadata size (4b per page).
> >> 
> >> The object handle encodes <page, offset> pair which currently points
> >> to the start of the object. Now, the handle implicitly stores the size
> >> information by pointing to the object's end instead. Since zsmalloc is
> >> a slab based allocator, the start of the object can be easily determined
> >> and the difference between the end offset encoded in the handle and the
> >> start gives us the object size.
> >> 
> >> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> > Acked-by: Minchan Kim <minchan@kernel.org>
> > 
> > I already had a few comment in your previous versoin.
> > I'm OK although you ignore them because I can make follow up patch about
> > my nitpick but could you answer below my question?
> > 
> >> ---
> >> drivers/staging/zsmalloc/zsmalloc-main.c |  177 +++++++++++++++++++++---------
> >> drivers/staging/zsmalloc/zsmalloc.h      |    1 +
> >> 2 files changed, 127 insertions(+), 51 deletions(-)
> >> 
> >> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> index 09a9d35..65c9d3b 100644
> >> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
> >> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
> >> @@ -112,20 +112,20 @@
> >> #define MAX_PHYSMEM_BITS 36
> >> #else /* !CONFIG_HIGHMEM64G */
> >> /*
> >> - * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
> >> + * If this definition of MAX_PHYSMEM_BITS is used, OFFSET_BITS will just
> >>  * be PAGE_SHIFT
> >>  */
> >> #define MAX_PHYSMEM_BITS BITS_PER_LONG
> >> #endif
> >> #endif
> >> #define _PFN_BITS        (MAX_PHYSMEM_BITS - PAGE_SHIFT)
> >> -#define OBJ_INDEX_BITS    (BITS_PER_LONG - _PFN_BITS)
> >> -#define OBJ_INDEX_MASK    ((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
> >> +#define OFFSET_BITS    (BITS_PER_LONG - _PFN_BITS)
> >> +#define OFFSET_MASK    ((_AC(1, UL) << OFFSET_BITS) - 1)
> >> 
> >> #define MAX(a, b) ((a) >= (b) ? (a) : (b))
> >> /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
> >> #define ZS_MIN_ALLOC_SIZE \
> >> -    MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
> >> +    MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OFFSET_BITS))
> >> #define ZS_MAX_ALLOC_SIZE    PAGE_SIZE
> >> 
> >> /*
> >> @@ -256,6 +256,11 @@ static int is_last_page(struct page *page)
> >>    return PagePrivate2(page);
> >> }
> >> 
> >> +static unsigned long get_page_index(struct page *page)
> >> +{
> >> +    return is_first_page(page) ? 0 : page->index;
> >> +}
> >> +
> >> static void get_zspage_mapping(struct page *page, unsigned int *class_idx,
> >>                enum fullness_group *fullness)
> >> {
> >> @@ -433,39 +438,86 @@ static struct page *get_next_page(struct page *page)
> >>    return next;
> >> }
> >> 
> >> -/* Encode <page, obj_idx> as a single handle value */
> >> -static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
> >> +static struct page *get_prev_page(struct page *page)
> >> {
> >> -    unsigned long handle;
> >> +    struct page *prev, *first_page;
> >> 
> >> -    if (!page) {
> >> -        BUG_ON(obj_idx);
> >> -        return NULL;
> >> -    }
> >> +    first_page = get_first_page(page);
> >> +    if (page == first_page)
> >> +        prev = NULL;
> >> +    else if (page == (struct page *)first_page->private)
> >> +        prev = first_page;
> >> +    else
> >> +        prev = list_entry(page->lru.prev, struct page, lru);
> >> 
> >> -    handle = page_to_pfn(page) << OBJ_INDEX_BITS;
> >> -    handle |= (obj_idx & OBJ_INDEX_MASK);
> >> +    return prev;
> >> 
> >> -    return (void *)handle;
> >> }
> >> 
> >> -/* Decode <page, obj_idx> pair from the given object handle */
> >> -static void obj_handle_to_location(unsigned long handle, struct page **page,
> >> -                unsigned long *obj_idx)
> >> +static void *encode_ptr(struct page *page, unsigned long offset)
> >> {
> >> -    *page = pfn_to_page(handle >> OBJ_INDEX_BITS);
> >> -    *obj_idx = handle & OBJ_INDEX_MASK;
> >> +    unsigned long ptr;
> >> +    ptr = page_to_pfn(page) << OFFSET_BITS;
> >> +    ptr |= offset & OFFSET_MASK;
> >> +    return (void *)ptr;
> >> +}
> >> +
> >> +static void decode_ptr(unsigned long ptr, struct page **page,
> >> +                    unsigned int *offset)
> >> +{
> >> +    *page = pfn_to_page(ptr >> OFFSET_BITS);
> >> +    *offset = ptr & OFFSET_MASK;
> >> +}
> >> +
> >> +static struct page *obj_handle_to_page(unsigned long handle)
> >> +{
> >> +    struct page *page;
> >> +    unsigned int offset;
> >> +
> >> +    decode_ptr(handle, &page, &offset);
> >> +    if (offset < get_page_index(page))
> >> +        page = get_prev_page(page);
> >> +
> >> +    return page;
> >> +}
> >> +
> >> +static unsigned int obj_handle_to_offset(unsigned long handle,
> >> +                    unsigned int class_size)
> >> +{
> >> +    struct page *page;
> >> +    unsigned int offset;
> >> +
> >> +    decode_ptr(handle, &page, &offset);
> >> +    if (offset < get_page_index(page))
> >> +        offset = PAGE_SIZE - class_size + get_page_index(page);
> >> +    else
> >> +        offset = roundup(offset, class_size) - class_size;
> >> +
> >> +    return offset;
> >> }
> >> 
> >> -static unsigned long obj_idx_to_offset(struct page *page,
> >> -                unsigned long obj_idx, int class_size)
> >> +/* Encode <page, offset, size> as a single handle value */
> >> +static void *obj_location_to_handle(struct page *page, unsigned int offset,
> >> +                unsigned int size, unsigned int class_size)
> >> {
> >> -    unsigned long off = 0;
> >> +    struct page *endpage;
> >> +    unsigned int endoffset;
> >> 
> >> -    if (!is_first_page(page))
> >> -        off = page->index;
> >> +    if (!page) {
> >> +        BUG_ON(offset);
> >> +        return NULL;
> >> +    }
> > 
> > What do you expect to catch with above check?
> > 
> > 
> 
> This would catch cases where, say, user passes handle to a zero page to this function. In general, just a sanity check since pfn 0 and any non-zero offset is invalid.

You mean zero_page is always pfn 0?
No, we can't assume it.

> 
> Thanks,
> Nitin

-- 
Kind regards,
Minchan Kim
