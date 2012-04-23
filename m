Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2DWU5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 16:57:06 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:43835 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab2DWU5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 16:57:03 -0400
Date: Mon, 23 Apr 2012 22:58:01 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Abhinav Kochhar <kochhar.abhinav@gmail.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [Linaro-mm-sig] [PATCH 0/4] ARM: replace custom consistent dma
 region with vmalloc
Message-ID: <20120423205801.GO4935@phenom.ffwll.local>
Mail-Followup-To: Abhinav Kochhar <kochhar.abhinav@gmail.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Russell King - ARM Linux <linux@arm.linux.org.uk>,
	Arnd Bergmann <arnd@arndb.de>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	linux-kernel@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
	linux-arm-kernel@lists.infradead.org
References: <1334325950-7881-1-git-send-email-m.szyprowski@samsung.com>
 <CALYq+qSMPoVC5OF+oBbt_i7O+_fmogLCtpqTAqHbsv1TcKrPdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALYq+qSMPoVC5OF+oBbt_i7O+_fmogLCtpqTAqHbsv1TcKrPdA@mail.gmail.com>
X-Operating-System: Linux phenom 3.2.0-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 23, 2012 at 09:02:25PM +0900, Abhinav Kochhar wrote:
> Hi,
> 
> I see a bottle-neck with the current dma-mapping framework.
> Issue seems to be with the Virtual memory allocation for access in kernel
> address space.
> 
> 1. In "arch/arm/mm/dma-mapping.c" there is a initialization call to
> "consistent_init". It reserves size 32MB of Kernel Address space.
> 2. "consistent_init" allocates memory for kernel page directory and page
> tables.
> 
> 3. "__iommu_alloc_remap" function allocates virtual memory region in kernel
> address space reserved in step 1.
> 
> 4. "__iommu_alloc_remap" function then maps the allocated pages to the
> address space reserved in step 3.
> 
> Since the virtual memory area allocated for mapping these pages in kernel
> address space is only 32MB,
> 
> eventually the calls for allocation and mapping new pages into kernel
> address space are going to fail once 32 MB is exhausted.
> 
> e.g., For Exynos 5 platform Each framebuffer for 1280x800 resolution
> consumes around 4MB.
> 
> We have a scenario where X11 DRI driver would allocate Non-contig pages for
> all "Pixmaps" through arm_iommu_alloc_attrs" function which will follow the
> path given above in steps 1 - 4.
> 
> Now the problem is the size limitation of 32MB. We may want to allocate
> more than 8 such buffers when X11 DRI driver is integrated.
> Possible solutions:
> 
> 1. Why do we need to create a kernel virtual address space? Are we going to
> access these pages in kernel using this address?
> 
> If we are not going to access anything in kernel then why do we need to map
> these pages in kernel address space?. If we can avoid this then the problem
> can be solved.
> 
> OR
> 
> 2 Is it used for only book-keeping to retrieve "struct pages" later on for
> passing/mapping to different devices?
> 
> If yes, then we have to find another way.
> 
> For "dmabuf" framework one solution could be to add a new member variable
> "pages" in the exporting driver's local object and use that for
> passing/mapping to different devices.
> 
> Moreover, even if we increase to say 64 MB that would not be enough for our
> use, we never know how many graphic applications would be spawned by the
> user.
> Let me know your opinion on this.

This is more or less the reason I'm so massively opposed to adding vmap to
dma-buf - you _really_ burn through the vmap space ridiculously quickly on
32bit platforms with too much memory (i.e. everything with more than 1 G).

You need to map/unmap everything page-by-page with all the usual kmap apis
the kernel provides.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
