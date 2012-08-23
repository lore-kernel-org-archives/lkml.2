Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933099Ab2HWGK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 02:10:56 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8129 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754623Ab2HWGKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 02:10:52 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 22 Aug 2012 23:10:49 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: <m.szyprowski@samsung.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <linux-arm-kernel@lists.infradead.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <arnd@arndb.de>, <linux@arm.linux.org.uk>, <chunsang.jeong@linaro.org>,
        <vdumpa@nvidia.com>, <konrad.wilk@oracle.com>, <subashrp@gmail.com>,
        <minchan@kernel.org>, <pullip.cho@samsung.com>
Subject: [v2 1/4] ARM: dma-mapping: Refactor out to introduce __in_atomic_pool
Date: Thu, 23 Aug 2012 09:10:26 +0300
Message-ID: <1345702229-9539-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345702229-9539-1-git-send-email-hdoyu@nvidia.com>
References: <1345702229-9539-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the given range("start", "size") is included in "atomic_pool" or not.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |   25 +++++++++++++++++++------
 1 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 601da7a..aca2fd0 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -492,19 +492,32 @@ static void *__alloc_from_pool(size_t size, struct page **ret_page)
 	return ptr;
 }
 
+static bool __in_atomic_pool(void *start, size_t size)
+{
+	struct dma_pool *pool = &atomic_pool;
+	void *end = start + size;
+	void *pool_start = pool->vaddr;
+	void *pool_end = pool->vaddr + pool->size;
+
+	if (start < pool_start || start > pool_end)
+		return false;
+
+	if (end > pool_end) {
+		WARN(1, "freeing wrong coherent size from pool\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int __free_from_pool(void *start, size_t size)
 {
 	struct dma_pool *pool = &atomic_pool;
 	unsigned long pageno, count;
 	unsigned long flags;
 
-	if (start < pool->vaddr || start > pool->vaddr + pool->size)
-		return 0;
-
-	if (start + size > pool->vaddr + pool->size) {
-		WARN(1, "freeing wrong coherent size from pool\n");
+	if (!__in_atomic_pool(start, size))
 		return 0;
-	}
 
 	pageno = (start - pool->vaddr) >> PAGE_SHIFT;
 	count = size >> PAGE_SHIFT;
-- 
1.7.5.4

