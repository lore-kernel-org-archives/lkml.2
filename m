Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab1CBWYc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 17:24:32 -0500
Received: from ovro.ovro.caltech.edu ([192.100.16.2]:54652 "EHLO
	ovro.ovro.caltech.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757936Ab1CBWXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 17:23:35 -0500
From: "Ira W. Snyder" <iws@ovro.caltech.edu>
To: linuxppc-dev@lists.ozlabs.org
Cc: linux-kernel@vger.kernel.org, leoli@freescale.com,
        dan.j.williams@intel.com, "Ira W. Snyder" <iws@ovro.caltech.edu>
Subject: [PATCH v2 9/9] fsldma: make halt behave nicely on all supported controllers
Date: Wed,  2 Mar 2011 14:23:21 -0800
Message-Id: <1299104601-15447-10-git-send-email-iws@ovro.caltech.edu>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
References: <1299104601-15447-1-git-send-email-iws@ovro.caltech.edu>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (ovro.ovro.caltech.edu); Wed, 02 Mar 2011 14:23:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original dma_halt() function set the CA (channel abort) bit on both
the 83xx and 85xx controllers. This is incorrect on the 83xx, where this
bit means TEM (transfer error mask) instead. The 83xx doesn't support
channel abort, so we only do this operation on 85xx.

Signed-off-by: Ira W. Snyder <iws@ovro.caltech.edu>
---
 drivers/dma/fsldma.c |   19 ++++++++++++++++---
 1 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 40babc1..eb7bc24 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -216,13 +216,26 @@ static void dma_halt(struct fsldma_chan *chan)
 	u32 mode;
 	int i;
 
+	/* read the mode register */
 	mode = DMA_IN(chan, &chan->regs->mr, 32);
-	mode |= FSL_DMA_MR_CA;
-	DMA_OUT(chan, &chan->regs->mr, mode, 32);
 
-	mode &= ~(FSL_DMA_MR_CS | FSL_DMA_MR_EMS_EN | FSL_DMA_MR_CA);
+	/*
+	 * The 85xx controller supports channel abort, which will stop
+	 * the current transfer. On 83xx, this bit is the transfer error
+	 * mask bit, which should not be changed.
+	 */
+	if ((chan->feature & FSL_DMA_IP_MASK) == FSL_DMA_IP_85XX) {
+		mode |= FSL_DMA_MR_CA;
+		DMA_OUT(chan, &chan->regs->mr, mode, 32);
+
+		mode &= ~FSL_DMA_MR_CA;
+	}
+
+	/* stop the DMA controller */
+	mode &= ~(FSL_DMA_MR_CS | FSL_DMA_MR_EMS_EN);
 	DMA_OUT(chan, &chan->regs->mr, mode, 32);
 
+	/* wait for the DMA controller to become idle */
 	for (i = 0; i < 100; i++) {
 		if (dma_is_idle(chan))
 			return;
-- 
1.7.3.4

