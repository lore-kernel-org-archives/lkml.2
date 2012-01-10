Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab2AJKUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 05:20:43 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34429 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755147Ab2AJKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 05:20:41 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; charset=us-ascii
Date: Tue, 10 Jan 2012 11:20:32 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: RE: [RFC PATCH v2 4/8] media: videobuf2: introduce VIDEOBUF2_PAGE
 memops
In-reply-to: <CACVXFVMrRTS7TUtj7bqCWeF4zx11yT6mOq4syOkZv=Ejoo0LMw@mail.gmail.com>
To: "'Ming Lei'" <ming.lei@canonical.com>
Cc: "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Tony Lindgren'" <tony@atomide.com>,
        "'Sylwester Nawrocki'" <snjw23@gmail.com>,
        "'Alan Cox'" <alan@lxorguk.ukuu.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, "'Pawel Osciak'" <p.osciak@gmail.com>
Message-id: <013701cccf81$7c0cdb90$742692b0$%szyprowski@samsung.com>
Organization: SPRC
X-Mailer: Microsoft Office Outlook 12.0
Content-language: pl
Thread-index: AczBbU1WCwpemINpSH2+iSuJPK/RkAOEW+ew
References: <1323871214-25435-1-git-send-email-ming.lei@canonical.com>
 <1323871214-25435-5-git-send-email-ming.lei@canonical.com>
 <010501ccc08c$1c7b7870$55726950$%szyprowski@samsung.com>
 <CACVXFVOqMmakPW-aAdp005RDLuV5oc6-JfjQHr-2bFRzZi2zDQ@mail.gmail.com>
 <015201ccc156$033f73a0$09be5ae0$%szyprowski@samsung.com>
 <CACVXFVNdczv=tu7VG24766myCnGDRWAjkthbdfMwTGzTwFCoBA@mail.gmail.com>
 <015301ccc15f$053e61d0$0fbb2570$%szyprowski@samsung.com>
 <CACVXFVMrRTS7TUtj7bqCWeF4zx11yT6mOq4syOkZv=Ejoo0LMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Friday, December 23, 2011 1:21 PM Ming Lei wrote:

> >> >> > Your current implementation also abuses the design and api of videobuf2 memory
> >> >> > allocators. If the allocator needs to return a custom structure to the driver
> >> >>
> >> >> I think returning vaddr is enough.
> >> >>
> >> >> > you should use cookie method. vaddr is intended to provide only a pointer to
> >> >> > kernel virtual mapping, but you pass a struct page * there.
> >> >>
> >> >> No, __get_free_pages returns virtual address instead of 'struct page *'.
> >> >
> >> > Then you MUST use cookie for it. vaddr method should return kernel virtual address
> >> > to the buffer video data. Some parts of videobuf2 relies on this - it is used by file
> >> > io emulator (read(), write() calls) and mmap equivalent for non-mmu systems.
> >> >
> >> > Manual casting in the driver is also a bad idea, that's why there are helper functions
> >>
> >> I don't see any casts are needed. The dma address can be got from vaddr with
> >> dma_map_* easily in drivers, see the usage on patch 8/8(media: video: introduce
> >> omap4 face detection module driver).
> >
> > Sorry, but I won't accept such driver/allocator which abuses the defined API. I've already
> > pointed what vaddr method is used for.
> 
> Sorry, could you describe the abuse problem in a bit detail?

Videobuf2 requires memory module handlers to provide vaddr method to provide a pointer in 
kernel virtual address space to video data (buffer content). It is used for example by 
read()/write() io method emulator. Memory allocator/handler should not be specific to any
particular use case in the device driver. That's the design. Simple.

I your case you want to give pointer to struct page from the memory allocator to the 
driver. The cookie method has been introduced exactly for this purpose. Memory allocator
also provides a simple inline function to convert generic 'void *' return type from cookie
method to allocator specific structure/pointer. vb2_dma_contig_plane_dma_addr() and 
vb2_dma_sg_plane_desc() were examples how does passing allocator specific type though the
cookie method works.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



