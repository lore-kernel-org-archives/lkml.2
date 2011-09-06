Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773Ab1IFISP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 04:18:15 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:38811 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753286Ab1IFISH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 04:18:07 -0400
From: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
To: Grant Likely <grant.likely@secretlab.ca>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, toshiharu-linux@dsn.okisemi.com,
        Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
Subject: [PATCH 2/5 v2] spi-topcliff-pch: Fix SSN Control issue
Date: Tue,  6 Sep 2011 17:16:35 +0900
Message-Id: <1315296998-7296-2-git-send-email-tomoya-linux@dsn.okisemi.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1315296998-7296-1-git-send-email-tomoya-linux@dsn.okisemi.com>
References: <1315296998-7296-1-git-send-email-tomoya-linux@dsn.okisemi.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During processing 1 command/data series,
SSN should keep LOW.
However, currently, SSN becomes HIGH.
This patch fixes the issue.

Signed-off-by: Tomoya MORINAGA <tomoya-linux@dsn.okisemi.com>
---
v2: v1 patch series are included invalid patch file
---
 drivers/spi/spi-topcliff-pch.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/spi/spi-topcliff-pch.c b/drivers/spi/spi-topcliff-pch.c
index 7a98caa..c36d516 100644
--- a/drivers/spi/spi-topcliff-pch.c
+++ b/drivers/spi/spi-topcliff-pch.c
@@ -58,6 +58,7 @@
 #define PCH_SLEEP_TIME		10
 
 #define SSN_LOW			0x02U
+#define SSN_HIGH		0x03U
 #define SSN_NO_CONTROL		0x00U
 #define PCH_MAX_CS		0xFF
 #define PCI_DEVICE_ID_GE_SPI	0x8816
@@ -756,10 +757,6 @@ static void pch_spi_set_ir(struct pch_spi_data *data)
 
 	wait_event_interruptible(data->wait, data->transfer_complete);
 
-	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);
-	dev_dbg(&data->master->dev,
-		"%s:no more control over SSN-writing 0 to SSNXCR.", __func__);
-
 	/* clear all interrupts */
 	pch_spi_writereg(data->master, PCH_SPSR,
 			 pch_spi_readreg(data->master, PCH_SPSR));
@@ -848,9 +845,6 @@ static void pch_spi_start_transfer(struct pch_spi_data *data)
 	kfree(dma->sg_rx_p);
 
 	spin_lock_irqsave(&data->lock, flags);
-	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);
-	dev_dbg(&data->master->dev,
-		"%s:no more control over SSN-writing 0 to SSNXCR.", __func__);
 
 	/* clear fifo threshold, disable interrupts, disable SPI transfer */
 	pch_spi_setclr_reg(data->master, PCH_SPCR, 0,
@@ -1167,6 +1161,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 	if (data->use_dma)
 		pch_spi_request_dma(data,
 				    data->current_msg->spi->bits_per_word);
+	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_NO_CONTROL);
 	do {
 		/* If we are already processing a message get the next
 		transfer structure from the message otherwise retrieve
@@ -1227,6 +1222,7 @@ static void pch_spi_process_messages(struct work_struct *pwork)
 
 	} while (data->cur_trans != NULL);
 
+	pch_spi_writereg(data->master, PCH_SSNXCR, SSN_HIGH);
 	if (data->use_dma)
 		pch_spi_release_dma(data);
 }
-- 
1.7.4.4

