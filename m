Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415Ab1GEPhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 11:37:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:63306 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755389Ab1GEPhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 11:37:35 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jonas Bonn <jonas@southpole.se>
Subject: Re: [PATCH v2 07/19] OpenRISC: DMA
Date: Tue, 5 Jul 2011 17:37:29 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <1309641352-18714-1-git-send-email-jonas@southpole.se> <1309641352-18714-8-git-send-email-jonas@southpole.se>
In-Reply-To: <1309641352-18714-8-git-send-email-jonas@southpole.se>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201107051737.30120.arnd@arndb.de>
X-Provags-ID: V02:K0:5BQte3lhS6VqEQoCIQLYMnnKf4C1lcoX9InVL67ID26
 REV3Vt7aOmBvw40Nzgz0iUdncyXE7SODx9p3c3fy1/z2zTavj9
 OBqoP2jlyQsVuscGtFhxhp7pEZH7fWqIzXfqewLlWEsDa+JIr3
 62+mbQABVACnJOo2HKBdwuJLx58wcybY0dbj45SchkXuGF4BDE
 kaMmbdEbOT5RK04L2SvBg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 02 July 2011, Jonas Bonn wrote:
> +void *or1k_dma_alloc_coherent(struct device *dev, size_t size,
> +                             dma_addr_t *dma_handle, gfp_t flag)
> +{
> +       int order;
> +       unsigned long page, va;
> +       pgprot_t prot;
> +       struct vm_struct *area;
> +
> +       /* Only allocate page size areas. */
> +       size = PAGE_ALIGN(size);
> +       order = get_order(size);
> +
> +       page = __get_free_pages(flag, order);
> +       if (!page)
> +               return NULL;
> +
> +       /* Allocate some common virtual space to map the new pages. */
> +       area = get_vm_area(size, VM_ALLOC);
> +       if (area == NULL) {
> +               free_pages(page, order);
> +               return NULL;
> +       }
> +       va = (unsigned long)area->addr;
> +
> +       /* This gives us the real physical address of the first page. */
> +       *dma_handle = __pa(page);
> +
> +       prot = PAGE_KERNEL_NOCACHE;
> +
> +       /* This isn't so much ioremap as just simply 'remap' */
> +       if (ioremap_page_range(va, va + size, *dma_handle, prot)) {
> +               vfree(area->addr);
> +               return NULL;
> +       }
> +
> +       return (void *)va;
> +}

This will result in having conflicting mappings, one with and another
without caching, which a lot of CPU architectures don't like. Are you
sure that you can handle this with or1k?

I think at the very least you will need to flush the cache for
the linear mapping, to avoid writing back dirty cache lines over
the DMA buffer.

You can save a little memory by using alloc_pages_exact instead of
get_free_pages, which always gives you a power-of-two size.

Also, isn't get_vm_area+ioremap_page_range the same as ioremap
on or1k?

In the case that ioremap_page_ranges fails, I think you have a
memory leak, or worse, because areas is not backed by the pages at that
moment.

	Arnd
