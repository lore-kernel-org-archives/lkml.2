Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756494Ab1COKNN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:13:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37142 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab1COKNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:13:09 -0400
Date: Tue, 15 Mar 2011 09:53:41 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: daeinki <inki.dae@samsung.com>
Cc: Tomasz Stanislawski <t.stanislaws@samsung.com>, k.debski@samsung.com,
        linux-samsung-soc@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        =?utf-8?B?6rCV66+86rec?= <mk7.kang@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        InKi Dae <daeinki@gmail.com>, KyongHo Cho <pullip.cho@samsung.com>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Subject: Re: [PATCH 3/7] ARM: Samsung: update/rewrite Samsung SYSMMU (IOMMU)
	driver
Message-ID: <20110315095341.GD3921@n2100.arm.linux.org.uk>
References: <1299229274-9753-4-git-send-email-m.szyprowski@samsung.com> <201103111615.01829.arnd@arndb.de> <000201cbe002$768d9de0$63a8d9a0$%szyprowski@samsung.com> <201103111700.17373.arnd@arndb.de> <AANLkTimagS1vBXEYjXQDx=OGhTRm=n0yO4n+kHTAqBOz@mail.gmail.com> <20110314124652.GF26085@n2100.arm.linux.org.uk> <AANLkTinzBvkcB111UZd2rJ9raaXkh2TqmTw5Y+4WFd48@mail.gmail.com> <20110315083515.GA3921@n2100.arm.linux.org.uk> <4D7F32B2.6020905@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4D7F32B2.6020905@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 15, 2011 at 06:34:42PM +0900, daeinki wrote:
> Russell King - ARM Linux 쓴 글:
>> On Tue, Mar 15, 2011 at 10:45:50AM +0900, InKi Dae wrote:
>>> 2011/3/14 Russell King - ARM Linux <linux@arm.linux.org.uk>:
>>>> On Mon, Mar 14, 2011 at 09:37:51PM +0900, KyongHo Cho wrote:
>>>>> I have also noticed that dma_map_single/page/sg() can map physical
>>>>> memory into an arbitrary device address region.
>>>>> But it is not enough solution for various kinds of IOMMUs.
>>>>> As Kukjin Kim addressed, we need to support larger page size than 4KB
>>>>> because we can reduce TLB miss when we have larger page size.
>>>>>
>>>>> Our IOMMU(system mmu) supports all page size of ARM architecture
>>>>> including 16MB, 1MB, 64KB and 4KB.
>>>>> Since the largest size supported by buddy system of 32-bit architecture is 4MB,
>>>>> our system support all page sizes except 16MB.
>>>>> We proved that larger page size is helpful for DMA performance
>>>>> significantly (more than 10%, approximately).
>>>>> Big page size is not a problem for peripheral devices
>>>>> because their address space is not suffer from external fragmentation.
>>>> 1. dma_map_single() et.al. is used for mapping *system* *RAM* for devices
>>>>   using whatever is necessary.  It must not be used for trying to setup
>>>>   arbitary other mappings.
>>>>
>>>> 2. It doesn't matter where the memory for dma_map_single() et.al. comes
>>>>   from provided the virtual address is a valid system RAM address or
>>>>   the struct page * is a valid struct page in the memory map (iow, you
>>>>   can't create this yourself.)
>>> You mean that we cannot have arbitrary virtual address mapping for
>>> iommu based device?
>>
>> No.  I mean exactly what I said - I'm talking about the DMA API in the
>> above two points.  The implication is that you can not create arbitary
>> mappings of non-system RAM with the DMA API.
>>
> sorry but I couldn't understand exactly what you said. could you give me  
> your answer one more time?
> does non-system RAM mean reserved memory regions? if not, is it  
> arbitrary virtual address space that isn't kernel or user virtual  
> address space and is the space for iommu based deivce?

For dma_map_single(dev, addr, size, dir), basically:

	for (a = addr; a < addr + size; a += PAGE_SIZE)
		BUG_ON(!virt_addr_valid(a));

For dma_map_page(dev, page, offset, size, dir), 'page' must be something
obtained from one of the page-based kernel allocators (so either refering
to a page in the *existing* lowmem or highmem memory) _and_ you must not
use offset/size to then point at something outside that.

So, if you take something out of the kernel's knowledge of what is memory,
you can't then use the DMA API with it.
