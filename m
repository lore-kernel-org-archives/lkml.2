Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752168Ab2A1S5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 13:57:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34312 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab2A1S5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 13:57:34 -0500
MIME-Version: 1.0
X-Originating-IP: [93.173.166.112]
In-Reply-To: <010501ccdd06$b9844f20$2c8ced60$%szyprowski@samsung.com>
References: <1327568457-27734-1-git-send-email-m.szyprowski@samsung.com>
 <1327568457-27734-13-git-send-email-m.szyprowski@samsung.com>
 <CADMYwHw1B4RNV_9BqAg_M70da=g69Z3kyo5Cr6izCMwJ9LAtvA@mail.gmail.com>
 <00de01ccdce1$e7c8a360$b759ea20$%szyprowski@samsung.com> <CAO8GWqnQg-W=TEc+CUc8hs=GrdCa9XCCWcedQx34cqURhNwNwA@mail.gmail.com>
 <010301ccdd03$1ad15ab0$50741010$%szyprowski@samsung.com> <CAK=WgbZWHBKNQwcoY9OiXXH-r1n3XxB=ZODZJN-3vZopU2yhJA@mail.gmail.com>
 <010501ccdd06$b9844f20$2c8ced60$%szyprowski@samsung.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 28 Jan 2012 20:57:14 +0200
Message-ID: <CAK=WgbY3L7u0AC1c=iNvoMXX+LSJoz1W-xb=S6gmhqcse5CKaA@mail.gmail.com>
Subject: Re: [Linaro-mm-sig] [PATCH 12/15] drivers: add Contiguous Memory Allocator
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: "Clark, Rob" <rob@ti.com>, Daniel Walker <dwalker@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Jonathan Corbet <corbet@lwn.net>, Mel Gorman <mel@csn.ul.ie>,
        Jesse Barker <jesse.barker@linaro.org>, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Fri, Jan 27, 2012 at 5:17 PM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> There have been some vmalloc layout changes merged to v3.3-rc1.

That was dead-on, thanks a lot!

I did then bump into a different allocation failure which happened
because dma_alloc_from_contiguous() computes 'mask' before capping the
'align' argument.

The early 'mask' computation was added in v18 (and therefore exists in
v19 too) and I was actually testing v17 previously, so I didn't notice
it before.

You may want to squash something like this:

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index f41e699..8455cb7 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -319,8 +319,7 @@ struct page *dma_alloc_from_contiguous(struct device *dev, i
                                       unsigned int align)
 {
        struct cma *cma = dev_get_cma_area(dev);
-       unsigned long pfn, pageno, start = 0;
-       unsigned long mask = (1 << align) - 1;
+       unsigned long mask, pfn, pageno, start = 0;
        int ret;

        if (!cma || !cma->count)
@@ -329,6 +328,8 @@ struct page *dma_alloc_from_contiguous(struct device *dev, i
        if (align > CONFIG_CMA_ALIGNMENT)
                align = CONFIG_CMA_ALIGNMENT;

+       mask = (1 << align) - 1;
+
        pr_debug("%s(cma %p, count %d, align %d)\n", __func__, (void *)cma,
                 count, align);

Thanks,
Ohad.
