Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751471Ab2KPFrD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:47:03 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:32927 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2KPFq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:46:59 -0500
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH 1/4] drivers: uio_dmem_genirq: Don't mix address spaces for dynamic region vaddr
Date: Fri, 16 Nov 2012 14:46:09 +0900
Message-Id: <1353044772-18803-2-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353044772-18803-1-git-send-email-dhobsong@igel.co.jp>
References: <1353044772-18803-1-git-send-email-dhobsong@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Assigning the virtual address returned from dma_alloc_coherent to the the
internal_addr element of uioinfo produces the following sparse errors since
internal_addr is a void __iomem * and dma_alloc_coherent returns void *.

+ drivers/uio/uio_dmem_genirq.c:65:39: sparse: incorrect type in assignment (different address spaces)
drivers/uio/uio_dmem_genirq.c:65:39:    expected void [noderef] <asn:2>*internal_addr
drivers/uio/uio_dmem_genirq.c:65:39:    got void *[assigned] addr
+ drivers/uio/uio_dmem_genirq.c:93:17: sparse: incorrect type in argument 3 (different address spaces)
drivers/uio/uio_dmem_genirq.c:93:17:    expected void *vaddr
drivers/uio/uio_dmem_genirq.c:93:17:    got void [noderef] <asn:2>*internal_addr

Store the void * in the driver's private data instead.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 drivers/uio/uio_dmem_genirq.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 4d4dd00..d8bbe07 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -37,6 +37,7 @@ struct uio_dmem_genirq_platdata {
 	struct platform_device *pdev;
 	unsigned int dmem_region_start;
 	unsigned int num_dmem_regions;
+	void *dmem_region_vaddr[MAX_UIO_MAPS];
 	struct mutex alloc_lock;
 	unsigned int refcnt;
 };
@@ -46,6 +47,7 @@ static int uio_dmem_genirq_open(struct uio_info *info, struct inode *inode)
 	struct uio_dmem_genirq_platdata *priv = info->priv;
 	struct uio_mem *uiomem;
 	int ret = 0;
+	int dmem_region = priv->dmem_region_start;
 
 	uiomem = &priv->uioinfo->mem[priv->dmem_region_start];
 
@@ -61,8 +63,7 @@ static int uio_dmem_genirq_open(struct uio_info *info, struct inode *inode)
 			ret = -ENOMEM;
 			break;
 		}
-
-		uiomem->internal_addr = addr;
+		priv->dmem_region_vaddr[dmem_region++] = addr;
 		++uiomem;
 	}
 	priv->refcnt++;
@@ -77,6 +78,7 @@ static int uio_dmem_genirq_release(struct uio_info *info, struct inode *inode)
 {
 	struct uio_dmem_genirq_platdata *priv = info->priv;
 	struct uio_mem *uiomem;
+	int dmem_region = priv->dmem_region_start;
 
 	/* Tell the Runtime PM code that the device has become idle */
 	pm_runtime_put_sync(&priv->pdev->dev);
@@ -91,7 +93,8 @@ static int uio_dmem_genirq_release(struct uio_info *info, struct inode *inode)
 			break;
 
 		dma_free_coherent(&priv->pdev->dev, uiomem->size,
-				uiomem->internal_addr, uiomem->addr);
+				priv->dmem_region_vaddr[dmem_region++],
+				uiomem->addr);
 		uiomem->addr = DMA_ERROR_CODE;
 		++uiomem;
 	}
-- 
1.7.5.4

