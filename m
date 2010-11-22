Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782Ab0KVRf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 12:35:29 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:46885 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752795Ab0KVRf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 12:35:28 -0500
X-Auth-Info: M3G7QgcNloB3tyqdgKzzcwVS/LdCYPGNDogZni5Z5CU=
From: Anatolij Gustschin <agust@denx.de>
To: linux-kernel@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] dmaengine: imx-sdma: fix bug in buffer descriptor initialization
Date: Mon, 22 Nov 2010 18:35:18 +0100
Message-Id: <1290447318-29333-1-git-send-email-agust@denx.de>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently while submitting scatterlists with more than one SG
entry the DMA buffer address from the first SG entry is inserted
into all initialized DMA buffer descriptors. This is due to the
typo in the for_each_sg() loop where the scatterlist pointer is
used for obtaining the DMA buffer address and _not_ the SG list
iterator.

As a result all received data will be written only into the first
DMA buffer while reading. While writing the data from the first
DMA buffer is send to the device multiple times. This caused
the filesystem destruction on the MMC card when using DMA in
mxcmmc driver.

Signed-off-by: Anatolij Gustschin <agust@denx.de>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/dma/imx-sdma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 0834323..13d6447 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -951,7 +951,7 @@ static struct dma_async_tx_descriptor *sdma_prep_slave_sg(
 		struct sdma_buffer_descriptor *bd = &sdmac->bd[i];
 		int param;
 
-		bd->buffer_addr = sgl->dma_address;
+		bd->buffer_addr = sg->dma_address;
 
 		count = sg->length;
 
-- 
1.7.1

