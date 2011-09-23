Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036Ab1IWPt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 11:49:59 -0400
Received: from dubexchange.kentrox.com ([192.228.36.11]:40928 "EHLO
	dubexchange.corp.kentrox.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754896Ab1IWPt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 11:49:56 -0400
From: Jeff Harris <jeff_harris@kentrox.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Jeff Harris <jeff_harris@kentrox.com>
Subject: [PATCH] spi: Fix WARN when removing spi-fsl-spi module
Date: Fri, 23 Sep 2011 11:49:36 -0400
Message-Id: <1316792976-28498-1-git-send-email-jeff_harris@kentrox.com>
X-Mailer: git-send-email 1.7.0.5
X-OriginalArrivalTime: 23 Sep 2011 15:49:44.0914 (UTC) FILETIME=[6A545320:01CC7A08]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CPM mode is not used, the fsl_dummy_rx variable is never allocated.  When
the cleanup attempts to free it, the reference count is zero and a WARN is
generated.  The same CPM mode check used in the initialize is applied to the
free as well.

Tested on 2.6.33 with the previous spi_mpc8xxx driver.  The renamed
spi-fsl-spi driver looks to have the same problem.

Signed-off-by: Jeff Harris <jeff_harris@kentrox.com>
---
 drivers/spi/spi-fsl-spi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/spi/spi-fsl-spi.c b/drivers/spi/spi-fsl-spi.c
index d240755..24cacff 100644
--- a/drivers/spi/spi-fsl-spi.c
+++ b/drivers/spi/spi-fsl-spi.c
@@ -825,6 +825,9 @@ static void fsl_spi_cpm_free(struct mpc8xxx_spi *mspi)
 {
 	struct device *dev = mspi->dev;
 
+	if (!(mspi->flags & SPI_CPM_MODE))
+		return;
+
 	dma_unmap_single(dev, mspi->dma_dummy_rx, SPI_MRBLR, DMA_FROM_DEVICE);
 	dma_unmap_single(dev, mspi->dma_dummy_tx, PAGE_SIZE, DMA_TO_DEVICE);
 	cpm_muram_free(cpm_muram_offset(mspi->tx_bd));
-- 
1.7.0.5

