Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466Ab2EUOB4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:01:56 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:59110 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756169Ab2EUOBy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:01:54 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=UTF-8
Message-id: <4FBA4ACE.4080602@samsung.com>
Date: Mon, 21 May 2012 16:01:50 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430
 Thunderbird/12.0.1
To: Andrew Morton <akpm@linux-foundation.org>
Cc: no To-header on input 
	<"unlisted-recipients:;;"@mail.linuxfoundation.org>,
        paul.gortmaker@windriver.com,
        =?UTF-8?B?J+uwleqyveuvvCc=?= <kyungmin.park@samsung.com>,
        amwang@redhat.com, dri-devel@lists.freedesktop.org,
        "'???/Mobile S/W Platform Lab.(???)/E3(??)/????'" 
	<inki.dae@samsung.com>,
        prashanth.g@samsung.com, Marek Szyprowski <m.szyprowski@samsung.com>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <rob@ti.com>, Dave Airlie <airlied@redhat.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andy Whitcroft <apw@shadowen.org>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] scatterlist: add sg_alloc_table_from_pages function
References: <4FA8EC69.8010805@samsung.com>
 <20120517165614.d5e6e4b6.akpm@linux-foundation.org>
In-reply-to: <20120517165614.d5e6e4b6.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,
Thank you for your review,
Please refer to the comments below.

On 05/18/2012 01:56 AM, Andrew Morton wrote:
> On Tue, 08 May 2012 11:50:33 +0200
> Tomasz Stanislawski <t.stanislaws@samsung.com> wrote:
> 
>> This patch adds a new constructor for an sg table. The table is constructed
>> from an array of struct pages. All contiguous chunks of the pages are merged
>> into a single sg nodes. A user may provide an offset and a size of a buffer if
>> the buffer is not page-aligned.
>>
>> The function is dedicated for DMABUF exporters which often perform conversion
>> from an page array to a scatterlist. Moreover the scatterlist should be
>> squashed in order to save memory and to speed-up the process of DMA mapping
>> using dma_map_sg.
>>
>> The code is based on the patch 'v4l: vb2-dma-contig: add support for
>> scatterlist in userptr mode' and hints from Laurent Pinchart.
>>
>> ...
>>
>>  /**
>> + * sg_alloc_table_from_pages - Allocate and initialize an sg table from
>> + *			       an array of pages
>> + * @sgt:	The sg table header to use
>> + * @pages:	Pointer to an array of page pointers
>> + * @n_pages:	Number of pages in the pages array
>> + * @offset:     Offset from start of the first page to the start of a buffer
>> + * @size:       Number of valid bytes in the buffer (after offset)
>> + * @gfp_mask:	GFP allocation mask
>> + *
>> + *  Description:
>> + *    Allocate and initialize an sg table from a list of pages. Continuous
> 
> s/Continuous/Contiguous/
> 

Ok. Thanks for noticing it.

>> + *    ranges of the pages are squashed into a single scatterlist node. A user
>> + *    may provide an offset at a start and a size of valid data in a buffer
>> + *    specified by the page array. The returned sg table is released by
>> + *    sg_free_table.
>> + *
>> + * Returns:
>> + *   0 on success, negative error on failure
>> + **/
> 
> nit: Use */, not **/ here.
> 
ok
>> +int sg_alloc_table_from_pages(struct sg_table *sgt,
>> +	struct page **pages, unsigned int n_pages,
>> +	unsigned long offset, unsigned long size,
>> +	gfp_t gfp_mask)
> 
> I guess a 32-bit n_pages is OK.  A 16TB IO seems enough ;)
> 

Do you think that 'unsigned long' for offset is too big?

Ad n_pages. Assuming that Moore's law holds it will take
circa 25 years before the limit of 16 TB is reached :) for
high-end scatterlist operations.
Or I can change the type of n_pages to 'unsigned long' now at
no cost :).

>> +{
>> +	unsigned int chunks;
>> +	unsigned int i;
> 
> erk, please choose a different name for this.  When a C programmer sees
> "i", he very much assumes it has type "int".  Making it unsigned causes
> surprise.
> 
> And don't rename it to "u"!  Let's give it a nice meaningful name.  pageno?
> 

The problem is that 'i' is  a natural name for a loop counter.
This exactly how 'i' is used in this function.
The type 'int' was used in the initial version of the code.
It was changed to avoid 'unsigned vs signed' comparisons in
the loop condition.

AFAIK, in the kernel code developers try to avoid Hungarian notation.
A name of a variable should reflect its purpose, not its type.
I can change the name of 'i' to 'pageno' and 'j' to 'pageno2' (?)
but I think it will make the code less reliable.

>> +	unsigned int cur_page;
>> +	int ret;
>> +	struct scatterlist *s;
>> +
>> +	/* compute number of contiguous chunks */
>> +	chunks = 1;
>> +	for (i = 1; i < n_pages; ++i)
>> +		if (page_to_pfn(pages[i]) != page_to_pfn(pages[i - 1]) + 1)
> 
> This assumes that if two pages have contiguous pfn's then they are
> physically contiguous.  Is that true for all architectures and memory
> models, including sparsemem?  See sparse_encode_mem_map().
> 

This is a very good questions. I did some research and I had looked
for all pfn_to_phys implementations in the kernel code. I found
that all conversions are performed by bit shifting. Therefore
I expect that assumption that contiguous PFNs imply contiguous physical
addresses is true for all architectures supported by Linux kernel.


>> +			++chunks;
>> +
>> +	ret = sg_alloc_table(sgt, chunks, gfp_mask);
>> +	if (unlikely(ret))
>> +		return ret;
>> +
>> +	/* merging chunks and putting them into the scatterlist */
>> +	cur_page = 0;
>> +	for_each_sg(sgt->sgl, s, sgt->orig_nents, i) {
>> +		unsigned long chunk_size;
>> +		unsigned int j;
> 
> "j" is an "int", too.

Please refer to 'i'-arguments above.

> 
>> +
>> +		/* looking for the end of the current chunk */
> 
> s/looking/look/
> 

ok

>> +		for (j = cur_page + 1; j < n_pages; ++j)
>> +			if (page_to_pfn(pages[j]) !=
>> +			    page_to_pfn(pages[j - 1]) + 1)
>> +				break;
>> +
>> +		chunk_size = ((j - cur_page) << PAGE_SHIFT) - offset;
>> +		sg_set_page(s, pages[cur_page], min(size, chunk_size), offset);
>> +		size -= chunk_size;
>> +		offset = 0;
>> +		cur_page = j;
>> +	}
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(sg_alloc_table_from_pages);
> 
> 

Regards,
Tomasz Stanislawski
