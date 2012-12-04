Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223Ab2LDH6v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 02:58:51 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:13850 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab2LDH6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 02:58:45 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v2 PATCH 04/14] spi/atmel_spi: call unmapping on transfers buffers
Date: Tue,  4 Dec 2012 15:53:50 +0800
Message-Id: <1354607640-13229-5-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
References: <1354607640-13229-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 04 Dec 2012 07:58:27.0671 (UTC) FILETIME=[24B5F670:01CDD1F5]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 2e040be..fc1222a 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -1010,6 +1010,7 @@ static int __devexit atmel_spi_remove(struct platform_device *pdev)
 	struct spi_master	*master = platform_get_drvdata(pdev);
 	struct atmel_spi	*as = spi_master_get_devdata(master);
 	struct spi_message	*msg;
+	struct spi_transfer	*xfer;
 
 	/* reset the hardware and block queue progress */
 	spin_lock_irq(&as->lock);
@@ -1021,9 +1022,10 @@ static int __devexit atmel_spi_remove(struct platform_device *pdev)
 
 	/* Terminate remaining queued transfers */
 	list_for_each_entry(msg, &as->queue, queue) {
-		/* REVISIT unmapping the dma is a NOP on ARM and AVR32
-		 * but we shouldn't depend on that...
-		 */
+		list_for_each_entry(xfer, &msg->transfers, transfer_list) {
+			if (!msg->is_dma_mapped)
+				atmel_spi_dma_unmap_xfer(master, xfer);
+		}
 		msg->status = -ESHUTDOWN;
 		msg->complete(msg->context);
 	}
-- 
1.7.9.5

