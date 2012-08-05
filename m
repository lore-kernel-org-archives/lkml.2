Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab2HEARc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 20:17:32 -0400
Received: from gate.crashing.org ([63.228.1.57]:37132 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161Ab2HEAR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 20:17:29 -0400
Message-ID: <1344125816.24037.84.camel@pasglop>
Subject: Is iommu_num_pages() broken ?
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Anton Blanchard <anton@au1.ibm.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        linux-kernel@vger.kernel.org
Date: Sun, 05 Aug 2012 10:16:56 +1000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

I stumbled upon this today:

static inline unsigned long iommu_num_pages(unsigned long addr,
					    unsigned long len,
					    unsigned long io_page_size)
{
	unsigned long size = (addr & (io_page_size - 1)) + len;

	return DIV_ROUND_UP(size, io_page_size);
}
 

That doesn't look right to me...

The powerpc iommu code at least uses that with an addr which may not be
page aligned (ie, result of sg_virt() which include the offset).

The above code will align the start before adding the len which is wrong
and will result in potentially missing a page or am I missing
something ?

Shouldn't it be something like

static inline unsigned long iommu_num_pages(unsigned long addr,
					    unsigned long len,
					    unsigned long io_page_size)
{
	unsigned long start = addr & (io_page_size - 1);
	unsigned long end = addr + len;

	return DIV_ROUND_UP(end - start, io_page_size);
}

?

Cheers,
Ben.


