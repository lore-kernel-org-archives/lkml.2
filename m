Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1LWJeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 04:34:15 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16606 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753775Ab1LWJeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 04:34:12 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Fri, 23 Dec 2011 10:34:04 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC PATCH v2 4/8] media: videobuf2: introduce VIDEOBUF2_PAGE
 memops
In-reply-to: <CACVXFVOqMmakPW-aAdp005RDLuV5oc6-JfjQHr-2bFRzZi2zDQ@mail.gmail.com>
To: "'Ming Lei'" <ming.lei@canonical.com>
Cc: "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Sylwester Nawrocki'" <snjw23@gmail.com>,
        "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, "'Pawel Osciak'" <p.osciak@gmail.com>
Message-id: <015201ccc156$033f73a0$09be5ae0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczBVGOjOwUdJl0YQnW1AGHYjPdOpgAAFCag
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
 <1323871214-25435-5-git-send-email-ming.lei@canonical.com>
 <010501ccc08c$1c7b7870$55726950$%szyprowski@samsung.com>
 <CACVXFVOqMmakPW-aAdp005RDLuV5oc6-JfjQHr-2bFRzZi2zDQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, December 23, 2011 10:22 AM Ming Lei wrote:

> On Thu, Dec 22, 2011 at 5:28 PM, Marek Szyprowski
> <m.szyprowski@samsung.com> wrote:
> >> DMA contig memory resource is very limited and precious, also
> >> accessing to it from CPU is very slow on some platform.
> >>
> >> For some cases(such as the comming face detection driver), DMA Streaming
> >> buffer is enough, so introduce VIDEOBUF2_PAGE to allocate continuous
> >> physical memory but letting video device driver to handle DMA buffer mapping
> >> and unmapping things.
> >>
> >> Signed-off-by: Ming Lei <ming.lei@canonical.com>
> >
> > Could you elaborate a bit why do you think that DMA contig memory resource
> > is so limited? If dma_alloc_coherent fails because of the memory fragmentation,
> > the alloc_pages() call with order > 0 will also fail.
> 
> For example, on ARM, there is very limited kernel virtual address space reserved
> for DMA coherent buffer mapping, the default size is about 2M if I
> don't remember mistakenly.

It can be easily increased for particular boards, there is no problem with this.

> > I understand that there might be some speed issues with coherent (uncached)
> > userspace mappings, but I would solve it in completely different way. The interface
> 
> Also there is poor performance inside kernel space, see [1]

Your driver doesn't access video data inside kernel space, so this is also not an issue.
 
> > for both coherent/uncached and non-coherent/cached contig allocator should be the
> > same, so exchanging them is easy and will not require changes in the driver.
> > I'm planning to introduce some design changes in memory allocator api and introduce
> > prepare and finish callbacks in allocator ops. I hope to post the rfc after
> > Christmas. For your face detection driver using standard dma-contig allocator
> > shouldn't be a big issue.
> >
> > Your current implementation also abuses the design and api of videobuf2 memory
> > allocators. If the allocator needs to return a custom structure to the driver
> 
> I think returning vaddr is enough.
> 
> > you should use cookie method. vaddr is intended to provide only a pointer to
> > kernel virtual mapping, but you pass a struct page * there.
> 
> No, __get_free_pages returns virtual address instead of 'struct page *'.

Then you MUST use cookie for it. vaddr method should return kernel virtual address 
to the buffer video data. Some parts of videobuf2 relies on this - it is used by file
io emulator (read(), write() calls) and mmap equivalent for non-mmu systems.

Manual casting in the driver is also a bad idea, that's why there are helper functions
defined for both dma_contig and dma_sg allocators: vb2_dma_contig_plane_dma_addr() and
vb2_dma_sg_plane_desc().

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


