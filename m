Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2H1FPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 01:15:31 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10595 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab2H1FPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 01:15:30 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 Aug 2012 22:15:29 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <m.szyprowski@samsung.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <arnd@arndb.de>, <linux@arm.linux.org.uk>, <chunsang.jeong@linaro.org>,
        <vdumpa@nvidia.com>, <subashrp@gmail.com>, <minchan@kernel.org>,
        <pullip.cho@samsung.com>, <konrad.wilk@oracle.com>,
        <linux-tegra@vger.kernel.org>
Subject: [v4 3/4] ARM: dma-mapping: Introduce __atomic_get_pages() for __iommu_get_pages()
Date: Tue, 28 Aug 2012 08:13:03 +0300
Message-ID: <1346130784-23571-4-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1346130784-23571-1-git-send-email-hdoyu@nvidia.com>
References: <1346130784-23571-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support atomic allocation in __iommu_get_pages().

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index a62f552..4ef2d7b 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -503,6 +503,15 @@ static void *__alloc_from_pool(size_t size, struct page **ret_page)
 	return ptr;
 }
 
+static struct page **__atomic_get_pages(void *addr)
+{
+	struct dma_pool *pool = &atomic_pool;
+	struct page **pages = pool->pages;
+	int offs = (addr - pool->vaddr) >> PAGE_SHIFT;
+
+	return pages + offs;
+}
+
 static bool __in_atomic_pool(void *start, size_t size)
 {
 	struct dma_pool *pool = &atomic_pool;
@@ -1288,6 +1297,9 @@ static struct page **__iommu_get_pages(void *cpu_addr, struct dma_attrs *attrs)
 {
 	struct vm_struct *area;
 
+	if (__in_atomic_pool(cpu_addr, PAGE_SIZE))
+		return __atomic_get_pages(cpu_addr);
+
 	if (dma_get_attr(DMA_ATTR_NO_KERNEL_MAPPING, attrs))
 		return cpu_addr;
 
-- 
1.7.5.4

