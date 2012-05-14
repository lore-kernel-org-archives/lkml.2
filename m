Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab2ENIfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 04:35:44 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:60572 "HELO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751499Ab2ENIfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 04:35:42 -0400
From: yongd <yongd@marvell.com>
To: cjb@laptop.org, linux-mmc@vger.kernel.org
Cc: prakity@marvell.com, ohad@wizery.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, linux-kernel@vger.kernel.org,
        yongd <yongd@marvell.com>
Subject: [PATCH] mmc:sdio:guarantee setting card data bus width as 4-bit
Date: Mon, 14 May 2012 16:35:10 +0800
Message-Id: <1336984510-9723-1-git-send-email-yongd@marvell.com>
X-Mailer: git-send-email 1.7.9.5
X-OriginalArrivalTime: 14 May 2012 08:35:11.0080 (UTC) FILETIME=[79C67E80:01CD31AC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  SDIO_CCCR_IF[1:0] in SDIO card is used for card data bus width
setting as below,
     00b: 1-bit bus
     01b: Reserved
     10b: 4-bit bus
     11b: 8-bit bus(only for embedded SDIO)
  And sdio_enable_wide is for setting data bus width as 4-bit. But
currently, it 1stly read the register, 2ndly OR' 1b with SDIO_CCCR_IF[1],
and then write it back.
  As we can see, such way is based on such assumption that the
SDIO_CCCR_IF[0] is always 0. Apparently, this is not right.

Signed-off-by: yongd <yongd@marvell.com>
---
 drivers/mmc/core/sdio.c  |    6 ++++++
 include/linux/mmc/sdio.h |    2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/mmc/core/sdio.c b/drivers/mmc/core/sdio.c
index 13d0e95..6b6f902 100644
--- a/drivers/mmc/core/sdio.c
+++ b/drivers/mmc/core/sdio.c
@@ -218,6 +218,12 @@ static int sdio_enable_wide(struct mmc_card *card)
 	if (ret)
 		return ret;
 
+	if ((ctrl & SDIO_BUS_WIDTH_MASK)
+				== SDIO_BUS_WIDTH_RESERVED)
+		printk(KERN_WARNING"SDIO_CCCR_IF is invalid: %d\n", ctrl);
+
+	/* set as 4-bit bus width */
+	ctrl &= ~SDIO_BUS_WIDTH_MASK;
 	ctrl |= SDIO_BUS_WIDTH_4BIT;
 
 	ret = mmc_io_rw_direct(card, 1, 0, SDIO_CCCR_IF, ctrl, NULL);
diff --git a/include/linux/mmc/sdio.h b/include/linux/mmc/sdio.h
index c9fe66c..17446d3 100644
--- a/include/linux/mmc/sdio.h
+++ b/include/linux/mmc/sdio.h
@@ -98,7 +98,9 @@
 
 #define SDIO_CCCR_IF		0x07	/* bus interface controls */
 
+#define  SDIO_BUS_WIDTH_MASK	0x03	/* data bus width setting */
 #define  SDIO_BUS_WIDTH_1BIT	0x00
+#define  SDIO_BUS_WIDTH_RESERVED 0x01
 #define  SDIO_BUS_WIDTH_4BIT	0x02
 #define  SDIO_BUS_ECSI		0x20	/* Enable continuous SPI interrupt */
 #define  SDIO_BUS_SCSI		0x40	/* Support continuous SPI interrupt */
-- 
1.7.9.5

