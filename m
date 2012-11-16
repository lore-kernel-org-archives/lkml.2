Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570Ab2KPFrN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 00:47:13 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40445 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab2KPFrJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 00:47:09 -0500
From: Damian Hobson-Garcia <dhobsong@igel.co.jp>
To: hjk@hansjkoch.de, gregkh@linuxfoundation.org, magnus.damm@gmail.com,
        horms@verge.net.au
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Damian Hobson-Garcia <dhobsong@igel.co.jp>
Subject: [PATCH 3/4] drivers: uio_dmem_genirq: Allow partial success when opening device
Date: Fri, 16 Nov 2012 14:46:11 +0900
Message-Id: <1353044772-18803-4-git-send-email-dhobsong@igel.co.jp>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1353044772-18803-1-git-send-email-dhobsong@igel.co.jp>
References: <1353044772-18803-1-git-send-email-dhobsong@igel.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The uio device should not fail on open just because one memory allocation
fails. The device might export several regions, the failure of some of
which may or may not be a problem for the user space driver.  Failing
regions will remain unmapped, and successful regions will be mapped and
exported to user space.  Also deals with the case where failing to map
a region after successfully allocating others would not unmap the
successfully allocated regions before dying.

Signed-off-by: Damian Hobson-Garcia <dhobsong@igel.co.jp>
---
 drivers/uio/uio_dmem_genirq.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/uio/uio_dmem_genirq.c b/drivers/uio/uio_dmem_genirq.c
index 7be8d04..bbdf925 100644
--- a/drivers/uio/uio_dmem_genirq.c
+++ b/drivers/uio/uio_dmem_genirq.c
@@ -62,8 +62,6 @@ static int uio_dmem_genirq_open(struct uio_info *info, struct inode *inode)
 				(dma_addr_t *)&uiomem->addr, GFP_KERNEL);
 		if (!addr) {
 			uiomem->addr = DMEM_MAP_ERROR;
-			ret = -ENOMEM;
-			break;
 		}
 		priv->dmem_region_vaddr[dmem_region++] = addr;
 		++uiomem;
@@ -93,11 +91,13 @@ static int uio_dmem_genirq_release(struct uio_info *info, struct inode *inode)
 	while (!priv->refcnt && uiomem < &priv->uioinfo->mem[MAX_UIO_MAPS]) {
 		if (!uiomem->size)
 			break;
-
-		dma_free_coherent(&priv->pdev->dev, uiomem->size,
-				priv->dmem_region_vaddr[dmem_region++],
-				uiomem->addr);
+		if (priv->dmem_region_vaddr[dmem_region]) {
+			dma_free_coherent(&priv->pdev->dev, uiomem->size,
+					priv->dmem_region_vaddr[dmem_region],
+					uiomem->addr);
+		}
 		uiomem->addr = DMEM_MAP_ERROR;
+		++dmem_region;
 		++uiomem;
 	}
 
-- 
1.7.5.4

