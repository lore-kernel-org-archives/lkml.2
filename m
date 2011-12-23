Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754281Ab1LWJWa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:22:30 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57836 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab1LWJW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:22:27 -0500
MIME-Version: 1.0
In-Reply-To: <010501ccc08c$1c7b7870$55726950$%szyprowski@samsung.com>
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
	<1323871214-25435-5-git-send-email-ming.lei@canonical.com>
	<010501ccc08c$1c7b7870$55726950$%szyprowski@samsung.com>
Date: Fri, 23 Dec 2011 17:22:23 +0800
Message-ID: <CACVXFVOqMmakPW-aAdp005RDLuV5oc6-JfjQHr-2bFRzZi2zDQ@mail.gmail.com>
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

On Thu, Dec 22, 2011 at 5:28 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> Hello,
>
> On Wednesday, December 14, 2011 3:00 PM Ming Lei wrote:
>
>> DMA contig memory resource is very limited and precious, also
>> accessing to it from CPU is very slow on some platform.
>>
>> For some cases(such as the comming face detection driver), DMA Streaming
>> buffer is enough, so introduce VIDEOBUF2_PAGE to allocate continuous
>> physical memory but letting video device driver to handle DMA buffer mapping
>> and unmapping things.
>>
>> Signed-off-by: Ming Lei <ming.lei@canonical.com>
>
> Could you elaborate a bit why do you think that DMA contig memory resource
> is so limited? If dma_alloc_coherent fails because of the memory fragmentation,
> the alloc_pages() call with order > 0 will also fail.

For example, on ARM, there is very limited kernel virtual address space reserved
for DMA coherent buffer mapping, the default size is about 2M if I
don't remember
mistakenly.

>
> I understand that there might be some speed issues with coherent (uncached)
> userspace mappings, but I would solve it in completely different way. The interface

Also there is poor performance inside kernel space, see [1]

> for both coherent/uncached and non-coherent/cached contig allocator should be the
> same, so exchanging them is easy and will not require changes in the driver.
> I'm planning to introduce some design changes in memory allocator api and introduce
> prepare and finish callbacks in allocator ops. I hope to post the rfc after
> Christmas. For your face detection driver using standard dma-contig allocator
> shouldn't be a big issue.
>
> Your current implementation also abuses the design and api of videobuf2 memory
> allocators. If the allocator needs to return a custom structure to the driver

I think returning vaddr is enough.

> you should use cookie method. vaddr is intended to provide only a pointer to
> kernel virtual mapping, but you pass a struct page * there.

No, __get_free_pages returns virtual address instead of 'struct page *'.


thanks,
--
Ming Lei

[1], http://marc.info/?t=131198148500001&r=1&w=2
