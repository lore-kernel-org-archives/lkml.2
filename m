Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab1LWMUr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 07:20:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58213 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754020Ab1LWMUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 07:20:45 -0500
MIME-Version: 1.0
In-Reply-To: <015301ccc15f$053e61d0$0fbb2570$%szyprowski@samsung.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
	<1323871214-25435-5-git-send-email-ming.lei@canonical.com>
	<010501ccc08c$1c7b7870$55726950$%szyprowski@samsung.com>
	<CACVXFVOqMmakPW-aAdp005RDLuV5oc6-JfjQHr-2bFRzZi2zDQ@mail.gmail.com>
	<015201ccc156$033f73a0$09be5ae0$%szyprowski@samsung.com>
	<CACVXFVNdczv=tu7VG24766myCnGDRWAjkthbdfMwTGzTwFCoBA@mail.gmail.com>
	<015301ccc15f$053e61d0$0fbb2570$%szyprowski@samsung.com>
Date: Fri, 23 Dec 2011 20:20:43 +0800
Message-ID: <CACVXFVMrRTS7TUtj7bqCWeF4zx11yT6mOq4syOkZv=Ejoo0LMw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/8] media: videobuf2: introduce VIDEOBUF2_PAGE memops
From: Ming Lei <ming.lei@canonical.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Sylwester Nawrocki <snjw23@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Pawel Osciak <p.osciak@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Dec 23, 2011 at 6:38 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Friday, December 23, 2011 10:51 AM Ming Lei wrote:
>
>> On Fri, Dec 23, 2011 at 5:34 PM, Marek Szyprowski
>> <m.szyprowski@samsung.com> wrote:
>>
>> >> For example, on ARM, there is very limited kernel virtual address space reserved
>> >> for DMA coherent buffer mapping, the default size is about 2M if I
>> >> don't remember mistakenly.
>> >
>> > It can be easily increased for particular boards, there is no problem with this.
>>
>> It is not easily to increase it because there is very limited space reserved for
>> this purpose, see Documentation/arm/memory.txt. Also looks like it is
>> not configurable.
>
> It is really not a big issue to increase it by a few MBytes.

IMO, the extra few MBytes are not helpful for the issue at all, considered the
kernel virtual memory address fragmentation problem, you know there is only
several MBytes DMA coherent virtual address space on ARM.

>
>> >> > I understand that there might be some speed issues with coherent (uncached)
>> >> > userspace mappings, but I would solve it in completely different way. The interface
>> >>
>> >> Also there is poor performance inside kernel space, see [1]
>> >
>> > Your driver doesn't access video data inside kernel space, so this is also not an issue.
>>
>> Why not introduce it so that other drivers(include face detection) can
>> benefit with it? :-)
>
> We can get back into this once a driver which really benefits from comes.

In fact, streaming DMA is more widespread used than coherent DMA in
kernel, so why can't videobuf2 support streaming dma? :-)

You know under some situation, coherent DMA buffer is very slower than
other buffer to be accessed by CPU.

>
>> >> >
>> >> > Your current implementation also abuses the design and api of videobuf2 memory
>> >> > allocators. If the allocator needs to return a custom structure to the driver
>> >>
>> >> I think returning vaddr is enough.
>> >>
>> >> > you should use cookie method. vaddr is intended to provide only a pointer to
>> >> > kernel virtual mapping, but you pass a struct page * there.
>> >>
>> >> No, __get_free_pages returns virtual address instead of 'struct page *'.
>> >
>> > Then you MUST use cookie for it. vaddr method should return kernel virtual address
>> > to the buffer video data. Some parts of videobuf2 relies on this - it is used by file
>> > io emulator (read(), write() calls) and mmap equivalent for non-mmu systems.
>> >
>> > Manual casting in the driver is also a bad idea, that's why there are helper functions
>>
>> I don't see any casts are needed. The dma address can be got from vaddr with
>> dma_map_* easily in drivers, see the usage on patch 8/8(media: video: introduce
>> omap4 face detection module driver).
>
> Sorry, but I won't accept such driver/allocator which abuses the defined API. I've already
> pointed what vaddr method is used for.

Sorry, could you describe the abuse problem in a bit detail?

>
>> > defined for both dma_contig and dma_sg allocators: vb2_dma_contig_plane_dma_addr() and
>> > vb2_dma_sg_plane_desc().
>>
>> These two helpers are not needed and won't be provided by VIDEOBUF2_PAGE memops.
>
> I gave the example. Your allocator should have something similar.

I don't think the two helper are required for the VIDEOBUF2_PAGE memops, why
can't driver handle DMA mapping directly?


thanks,
--
Ming Lei
