Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755545Ab2K3M6j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 07:58:39 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:36735 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2K3M6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 07:58:38 -0500
From: Vitaly Andrianov <vitalya@ti.com>
To: <mina86@mina86.com>, <m.szyprowski@samsung.com>,
        <kyungmin.park@samsung.com>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-keystone@list.ti.com>
CC: Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH] drivers: cma: fix addressing on PAE machines
Date: Fri, 30 Nov 2012 07:58:03 -0500
Message-ID: <1354280283-28365-1-git-send-email-vitalya@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a couple of bugs that otherwise impair CMA functionality on
PAE machines:

  - alignment must be a 64-bit type when running on systems with 64-bit
    physical addresses.  If this is not the case, the limit calculation thunks
    allocations down to an address range < 4G.

  - The allocated range check is removed. On 32bit ARM kernel with LPAE
    enabled the base may be allocated outside the fist 4GB of physical
    memory (keystone SoC for example).

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 drivers/base/dma-contiguous.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 9a14694..7936b2e 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -234,7 +234,7 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
 				  phys_addr_t base, phys_addr_t limit)
 {
 	struct cma_reserved *r = &cma_reserved[cma_reserved_count];
-	unsigned long alignment;
+	phys_addr_t alignment;
 
 	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
 		 (unsigned long)size, (unsigned long)base,
@@ -271,10 +271,6 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
 		if (!addr) {
 			base = -ENOMEM;
 			goto err;
-		} else if (addr + size > ~(unsigned long)0) {
-			memblock_free(addr, size);
-			base = -EINVAL;
-			goto err;
 		} else {
 			base = addr;
 		}
-- 
1.7.9.5

