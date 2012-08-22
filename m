Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757229Ab2HVKVX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:21:23 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8128 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221Ab2HVKVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:21:10 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 22 Aug 2012 03:20:51 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>
Subject: [RFC 3/4] ARM: dma-mapping: Return cpu addr when dma_alloc(GFP_ATOMIC)
Date: Wed, 22 Aug 2012 13:20:29 +0300
Message-ID: <1345630830-9586-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make dma_alloc{_attrs}() returns cpu address when
DMA_ATTR_NO_KERNEL_MAPPING && GFP_ATOMIC.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 9260107..a0cd476 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -1198,8 +1198,11 @@ static void *arm_iommu_alloc_attrs(struct device *dev, size_t size,
 	if (*handle == DMA_ERROR_CODE)
 		goto err_buffer;
 
-	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
+	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs)) {
+		if (gfp & GFP_ATOMIC)
+			return page_address(pages[0]);
 		return pages;
+	}
 
 	addr = __iommu_alloc_remap(pages, size, gfp, prot,
 				   __builtin_return_address(0));
-- 
1.7.5.4

