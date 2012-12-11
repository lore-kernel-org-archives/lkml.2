Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab2LKHTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 02:19:54 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:36017 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab2LKHTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 02:19:52 -0500
Message-ID: <50C6DE95.3050603@vflare.org>
Date: Mon, 10 Dec 2012 23:19:49 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg KH <greg@kroah.com>, Jerome Marchand <jmarchan@redhat.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: feel Re: [PATCH v2 1/2] zsmalloc: add function to query object size
References: <1354258489-2703-1-git-send-email-ngupta@vflare.org> <20121130135124.GA22196@blaptop> <BA4DD5DA-0E4F-470E-98F5-DDA937636189@vflare.org> <20121203075226.GA4065@blaptop> <CAPkvG_fRC4xU4wXE=0O_Qtv=C0if4gW_2jSgNp06NpxQ+YQzCA@mail.gmail.com> <20121211035905.GA22698@blaptop>
In-Reply-To: <20121211035905.GA22698@blaptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 07:59 PM, Minchan Kim wrote:
> On Fri, Dec 07, 2012 at 04:45:53PM -0800, Nitin Gupta wrote:
>> On Sun, Dec 2, 2012 at 11:52 PM, Minchan Kim <minchan@kernel.org> wrote:
>>> On Sun, Dec 02, 2012 at 11:20:42PM -0800, Nitin Gupta wrote:
>>>>
>>>>
>>>> On Nov 30, 2012, at 5:54 AM, Minchan Kim <minchan.kernel.2@gmail.com> wrote:
>>>>
>>>>> On Thu, Nov 29, 2012 at 10:54:48PM -0800, Nitin Gupta wrote:
>>>>>> Changelog v2 vs v1:
>>>>>> - None
>>>>>>
>>>>>> Adds zs_get_object_size(handle) which provides the size of
>>>>>> the given object. This is useful since the user (zram etc.)
>>>>>> now do not have to maintain object sizes separately, saving
>>>>>> on some metadata size (4b per page).
>>>>>>
>>>>>> The object handle encodes <page, offset> pair which currently points
>>>>>> to the start of the object. Now, the handle implicitly stores the size
>>>>>> information by pointing to the object's end instead. Since zsmalloc is
>>>>>> a slab based allocator, the start of the object can be easily determined
>>>>>> and the difference between the end offset encoded in the handle and the
>>>>>> start gives us the object size.
>>>>>>
>>>>>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>>>> Acked-by: Minchan Kim <minchan@kernel.org>
>>>>>
>>>>> I already had a few comment in your previous versoin.
>>>>> I'm OK although you ignore them because I can make follow up patch about
>>>>> my nitpick but could you answer below my question?
>>>>>
>>>>>> ---
>>>>>> drivers/staging/zsmalloc/zsmalloc-main.c |  177 +++++++++++++++++++++---------
>>>>>> drivers/staging/zsmalloc/zsmalloc.h      |    1 +
>>>>>> 2 files changed, 127 insertions(+), 51 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/staging/zsmalloc/zsmalloc-main.c b/drivers/staging/zsmalloc/zsmalloc-main.c
>>>>>> index 09a9d35..65c9d3b 100644
>>>>>> --- a/drivers/staging/zsmalloc/zsmalloc-main.c
>>>>>> +++ b/drivers/staging/zsmalloc/zsmalloc-main.c
>>>>>> @@ -112,20 +112,20 @@
>>>>>> #define MAX_PHYSMEM_BITS 36
>>>>>> #else /* !CONFIG_HIGHMEM64G */
>>>>>> /*
>>>>>> - * If this definition of MAX_PHYSMEM_BITS is used, OBJ_INDEX_BITS will just
>>>>>> + * If this definition of MAX_PHYSMEM_BITS is used, OFFSET_BITS will just
>>>>>>  * be PAGE_SHIFT
>>>>>>  */
>>>>>> #define MAX_PHYSMEM_BITS BITS_PER_LONG
>>>>>> #endif
>>>>>> #endif
>>>>>> #define _PFN_BITS        (MAX_PHYSMEM_BITS - PAGE_SHIFT)
>>>>>> -#define OBJ_INDEX_BITS    (BITS_PER_LONG - _PFN_BITS)
>>>>>> -#define OBJ_INDEX_MASK    ((_AC(1, UL) << OBJ_INDEX_BITS) - 1)
>>>>>> +#define OFFSET_BITS    (BITS_PER_LONG - _PFN_BITS)
>>>>>> +#define OFFSET_MASK    ((_AC(1, UL) << OFFSET_BITS) - 1)
>>>>>>
>>>>>> #define MAX(a, b) ((a) >= (b) ? (a) : (b))
>>>>>> /* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
>>>>>> #define ZS_MIN_ALLOC_SIZE \
>>>>>> -    MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OBJ_INDEX_BITS))
>>>>>> +    MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> OFFSET_BITS))
>>>>>> #define ZS_MAX_ALLOC_SIZE    PAGE_SIZE
>>>>>>
>>>>>> /*
>>>>>> @@ -256,6 +256,11 @@ static int is_last_page(struct page *page)
>>>>>>    return PagePrivate2(page);
>>>>>> }
>>>>>>
>>>>>> +static unsigned long get_page_index(struct page *page)
>>>>>> +{
>>>>>> +    return is_first_page(page) ? 0 : page->index;
>>>>>> +}
>>>>>> +
>>>>>> static void get_zspage_mapping(struct page *page, unsigned int *class_idx,
>>>>>>                enum fullness_group *fullness)
>>>>>> {
>>>>>> @@ -433,39 +438,86 @@ static struct page *get_next_page(struct page *page)
>>>>>>    return next;
>>>>>> }
>>>>>>
>>>>>> -/* Encode <page, obj_idx> as a single handle value */
>>>>>> -static void *obj_location_to_handle(struct page *page, unsigned long obj_idx)
>>>>>> +static struct page *get_prev_page(struct page *page)
>>>>>> {
>>>>>> -    unsigned long handle;
>>>>>> +    struct page *prev, *first_page;
>>>>>>
>>>>>> -    if (!page) {
>>>>>> -        BUG_ON(obj_idx);
>>>>>> -        return NULL;
>>>>>> -    }
>>>>>> +    first_page = get_first_page(page);
>>>>>> +    if (page == first_page)
>>>>>> +        prev = NULL;
>>>>>> +    else if (page == (struct page *)first_page->private)
>>>>>> +        prev = first_page;
>>>>>> +    else
>>>>>> +        prev = list_entry(page->lru.prev, struct page, lru);
>>>>>>
>>>>>> -    handle = page_to_pfn(page) << OBJ_INDEX_BITS;
>>>>>> -    handle |= (obj_idx & OBJ_INDEX_MASK);
>>>>>> +    return prev;
>>>>>>
>>>>>> -    return (void *)handle;
>>>>>> }
>>>>>>
>>>>>> -/* Decode <page, obj_idx> pair from the given object handle */
>>>>>> -static void obj_handle_to_location(unsigned long handle, struct page **page,
>>>>>> -                unsigned long *obj_idx)
>>>>>> +static void *encode_ptr(struct page *page, unsigned long offset)
>>>>>> {
>>>>>> -    *page = pfn_to_page(handle >> OBJ_INDEX_BITS);
>>>>>> -    *obj_idx = handle & OBJ_INDEX_MASK;
>>>>>> +    unsigned long ptr;
>>>>>> +    ptr = page_to_pfn(page) << OFFSET_BITS;
>>>>>> +    ptr |= offset & OFFSET_MASK;
>>>>>> +    return (void *)ptr;
>>>>>> +}
>>>>>> +
>>>>>> +static void decode_ptr(unsigned long ptr, struct page **page,
>>>>>> +                    unsigned int *offset)
>>>>>> +{
>>>>>> +    *page = pfn_to_page(ptr >> OFFSET_BITS);
>>>>>> +    *offset = ptr & OFFSET_MASK;
>>>>>> +}
>>>>>> +
>>>>>> +static struct page *obj_handle_to_page(unsigned long handle)
>>>>>> +{
>>>>>> +    struct page *page;
>>>>>> +    unsigned int offset;
>>>>>> +
>>>>>> +    decode_ptr(handle, &page, &offset);
>>>>>> +    if (offset < get_page_index(page))
>>>>>> +        page = get_prev_page(page);
>>>>>> +
>>>>>> +    return page;
>>>>>> +}
>>>>>> +
>>>>>> +static unsigned int obj_handle_to_offset(unsigned long handle,
>>>>>> +                    unsigned int class_size)
>>>>>> +{
>>>>>> +    struct page *page;
>>>>>> +    unsigned int offset;
>>>>>> +
>>>>>> +    decode_ptr(handle, &page, &offset);
>>>>>> +    if (offset < get_page_index(page))
>>>>>> +        offset = PAGE_SIZE - class_size + get_page_index(page);
>>>>>> +    else
>>>>>> +        offset = roundup(offset, class_size) - class_size;
>>>>>> +
>>>>>> +    return offset;
>>>>>> }
>>>>>>
>>>>>> -static unsigned long obj_idx_to_offset(struct page *page,
>>>>>> -                unsigned long obj_idx, int class_size)
>>>>>> +/* Encode <page, offset, size> as a single handle value */
>>>>>> +static void *obj_location_to_handle(struct page *page, unsigned int offset,
>>>>>> +                unsigned int size, unsigned int class_size)
>>>>>> {
>>>>>> -    unsigned long off = 0;
>>>>>> +    struct page *endpage;
>>>>>> +    unsigned int endoffset;
>>>>>>
>>>>>> -    if (!is_first_page(page))
>>>>>> -        off = page->index;
>>>>>> +    if (!page) {
>>>>>> +        BUG_ON(offset);
>>>>>> +        return NULL;
>>>>>> +    }
>>>>>
>>>>> What do you expect to catch with above check?
>>>>>
>>>>>
>>>>
>>>> This would catch cases where, say, user passes handle to a zero page to this function. In general, just a sanity check since pfn 0 and any non-zero offset is invalid.
>>>
>>> You mean zero_page is always pfn 0?
>>> No, we can't assume it.
>>>
>>
>> Sorry, missed this point.    Though it's not correct to embed the
>> assumption that the zero-page handle will have pfn of 0, but in
>> general, PFN 0 is always invalid. However, for 0 size requests
> 
> Not true. PFN 0 is valid. Why do you think pfn 0 is invalid?
> 

I thought PFN 0 must be reserved or already used during bootup, so no
chance of it getting swapped out and reaching zram.


>> zsmalloc returns NULL, so user should be also to pass <PFN=0,offset=0>
>> pair to this function. However, <PFN=0, offset!=0> is invalid and this
> 
> I don't get it. If zs_malloc return 0, it means FAILED. 
> How can user pass it in obj_location_to_handle?
> 

zsmalloc also returns 0 as a result of zero sized request. In general,
malloc is supposed to treat zero-sized request as valid and is supposed
to return either 0 or a valid pointer in that case. So, in that user
should be able to pass on 0 to any zs_* API. Anyways, I don't consider
wither removing or keeping the assert as-is or just do BUG_ON(!page). so
any future cleanups could cleanup this BUG_ON if you feel like.

>> is what this assert checks.
> 
> Although you are worry that someone might use the function in future,
> Just enough with below.
> 
>         BUG_ON(!page);
> 
> The assertion isn't effecitve so we don't need that.
> 

Ok, then we can clean this up in a future patch.


Thanks,
Nitin

