Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1JXTjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 15:39:35 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:51325 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751994Ab1JXTje convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 15:39:34 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        "Mel Gorman" <mel@csn.ul.ie>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] drivers: add Contiguous Memory Allocator
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
 <1317909290-29832-7-git-send-email-m.szyprowski@samsung.com>
 <20111018134321.GE6660@csn.ul.ie>
Date: Mon, 24 Oct 2011 12:39:29 -0700
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v3vfj30d3l0zgt@mpn-glaptop>
In-Reply-To: <20111018134321.GE6660@csn.ul.ie>
User-Agent: Opera Mail/11.52 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Oct 06, 2011 at 03:54:46PM +0200, Marek Szyprowski wrote:
>> +static unsigned long __init __cma_early_get_total_pages(void)
>> +{
>> +	struct memblock_region *reg;
>> +	unsigned long total_pages = 0;
>> +
>> +	/*
>> +	 * We cannot use memblock_phys_mem_size() here, because
>> +	 * memblock_analyze() has not been called yet.
>> +	 */
>> +	for_each_memblock(memory, reg)
>> +		total_pages += memblock_region_memory_end_pfn(reg) -
>> +			       memblock_region_memory_base_pfn(reg);
>> +	return total_pages;
>> +}
>> +

On Tue, 18 Oct 2011 06:43:21 -0700, Mel Gorman <mel@csn.ul.ie> wrote:
> Is this being called too early yet? What prevents you seeing up the CMA
> regions after the page allocator is brought up for example? I understand
> that there is a need for the memory to be coherent so maybe that is the
> obstacle.

Another reason is that we want to be sure that we can get given range of pages.
After page allocator is set-up, someone could allocate a non-movable page from
the range that interests us and that wouldn't be nice for us.

>> +struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>> +				       unsigned int align)
>> +{
>> +	struct cma *cma = get_dev_cma_area(dev);
>> +	unsigned long pfn, pageno;
>> +	int ret;
>> +
>> +	if (!cma)
>> +		return NULL;
>> +
>> +	if (align > CONFIG_CMA_ALIGNMENT)
>> +		align = CONFIG_CMA_ALIGNMENT;
>> +
>> +	pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
>> +		 count, align);
>> +
>> +	if (!count)
>> +		return NULL;
>> +
>> +	mutex_lock(&cma_mutex);
>> +
>> +	pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count, 0, count,
>> +					    (1 << align) - 1);
>> +	if (pageno >= cma->count) {
>> +		ret = -ENOMEM;
>> +		goto error;
>> +	}
>> +	bitmap_set(cma->bitmap, pageno, count);
>> +
>> +	pfn = cma->base_pfn + pageno;
>> +	ret = alloc_contig_range(pfn, pfn + count, 0, MIGRATE_CMA);
>> +	if (ret)
>> +		goto free;
>> +

> If alloc_contig_range returns failure, the bitmap is still set. It will
> never be freed so now the area cannot be used for CMA allocations any
> more.

bitmap is cleared at the “free:” label.

>> +	mutex_unlock(&cma_mutex);
>> +
>> +	pr_debug("%s(): returned %p\n", __func__, pfn_to_page(pfn));
>> +	return pfn_to_page(pfn);
>> +free:
>> +	bitmap_clear(cma->bitmap, pageno, count);
>> +error:
>> +	mutex_unlock(&cma_mutex);
>> +	return NULL;
>> +}


>> +int dma_release_from_contiguous(struct device *dev, struct page *pages,
>> +				int count)
>> +{
>> +	struct cma *cma = get_dev_cma_area(dev);
>> +	unsigned long pfn;
>> +
>> +	if (!cma || !pages)
>> +		return 0;
>> +
>> +	pr_debug("%s(page %p)\n", __func__, (void *)pages);
>> +
>> +	pfn = page_to_pfn(pages);
>> +
>> +	if (pfn < cma->base_pfn || pfn >= cma->base_pfn + cma->count)
>> +		return 0;
>> +
>> +	mutex_lock(&cma_mutex);
>> +
>> +	bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
>> +	free_contig_pages(pfn, count);
>> +
>> +	mutex_unlock(&cma_mutex);
>
> It feels like the mutex could be a lot lighter here. If the bitmap is
> protected by a spinlock, it would only need to be held while the bitmap
> was being cleared. free the contig pages outside the spinlock and clear
> the bitmap afterwards.
>
> It's not particularly important as the scalability of CMA is not
> something to be concerned with at this point.

Mutex is used also to protect the core operations, ie. isolating pages
and such.  This is because two CMA calls may want to work on the same
pageblock and we have to prevent that from happening.

We could add the spinlock for protecting the bitmap but we will still
need mutex for other uses.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
