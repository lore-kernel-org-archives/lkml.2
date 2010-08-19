Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab0HSIw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 04:52:29 -0400
Received: from sh.osrg.net ([192.16.179.4]:39401 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab0HSIwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 04:52:23 -0400
Date: Thu, 19 Aug 2010 17:51:48 +0900
To: khc@pm.waw.pl
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk
Subject: [PATCH] arm: fix pci_set_consistent_dma_mask for dmabounce devices
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100819174426O.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Thu, 19 Aug 2010 17:51:51 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes the regression of the
6fee48cd330c68332f9712bc968d934a1a84a32a commit.

After the above commit, pci_set_consistent_dma_mask doesn't work for
dmabounce devices. It converts ARM to use the generic implementation
of pci_set_consistent_dma_mask.

The root cause that ARM's CONFIG_DMABOUNCE uses dev->coherent_dma_mask
for the dma mask of a device _AND_ a bus. dev->coherent_dma_mask is
supposed to represent the dma mask of a device.

The proper solution is that device and bus has the own dma mask
respectively (POWERPC does the similar). But the fix must go to stable
trees so this simple (and hacky a bit) patch works better for now.

For further information: http://lkml.org/lkml/2010/8/10/272

Reported-by: Krzysztof Halasa <khc@pm.waw.pl>
Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Tested-by: Krzysztof Halasa <khc@pm.waw.pl>
Cc: stable@kernel.org
---
 arch/arm/mm/dma-mapping.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index c704eed..2a3fc2e 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -77,6 +77,11 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 	if (mask < 0xffffffffULL)
 		gfp |= GFP_DMA;
 
+#ifdef CONFIG_DMABOUNCE
+	if (dev->archdata.dmabounce)
+		gfp |= GFP_DMA;
+#endif
+
 	page = alloc_pages(gfp, order);
 	if (!page)
 		return NULL;
-- 
1.6.5

