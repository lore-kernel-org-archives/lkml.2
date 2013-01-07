Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489Ab3AGB4m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 20:56:42 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:28896 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753391Ab3AGB4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 20:56:32 -0500
From: Wenyou Yang <wenyou.yang@atmel.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, nicolas.ferre@atmel.com,
        plagnioj@jcrosoft.com, richard.genoud@gmail.com, JM.Lin@atmel.com,
        wenyou.yang@atmel.com, grant.likely@secretlab.ca,
        spi-devel-general@lists.sourceforge.net
Subject: [v3 PATCH 04/12] spi/atmel_spi: add flag to controller data for lock operations
Date: Mon,  7 Jan 2013 09:50:05 +0800
Message-Id: <1357523413-27209-5-git-send-email-wenyou.yang@atmel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
References: <1357523413-27209-1-git-send-email-wenyou.yang@atmel.com>
X-OriginalArrivalTime: 07 Jan 2013 01:56:16.0053 (UTC) FILETIME=[2DB3B650:01CDEC7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nicolas Ferre <nicolas.ferre@atmel.com>

Will allow to drop the lock during DMA operations.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: grant.likely@secretlab.ca
Cc: spi-devel-general@lists.sourceforge.net
---
 drivers/spi/spi-atmel.c |   31 +++++++++++++++++++------------
 1 file changed, 19 insertions(+), 12 deletions(-)

diff --git a/drivers/spi/spi-atmel.c b/drivers/spi/spi-atmel.c
index 687075e..8f6f0a0 100644
--- a/drivers/spi/spi-atmel.c
+++ b/drivers/spi/spi-atmel.c
@@ -188,6 +188,7 @@
  */
 struct atmel_spi {
 	spinlock_t		lock;
+	unsigned long		flags;
 
 	resource_size_t		phybase;
 	void __iomem		*regs;
@@ -324,6 +325,16 @@ static void cs_deactivate(struct atmel_spi *as, struct spi_device *spi)
 		gpio_set_value(asd->npcs_pin, !active);
 }
 
+static void atmel_spi_lock(struct atmel_spi *as)
+{
+		spin_lock_irqsave(&as->lock, as->flags);
+}
+
+static void atmel_spi_unlock(struct atmel_spi *as)
+{
+		spin_unlock_irqrestore(&as->lock, as->flags);
+}
+
 static inline int atmel_spi_xfer_is_last(struct spi_message *msg,
 					struct spi_transfer *xfer)
 {
@@ -560,9 +571,9 @@ atmel_spi_msg_done(struct spi_master *master, struct atmel_spi *as,
 		"xfer complete: %u bytes transferred\n",
 		msg->actual_length);
 
-	spin_unlock(&as->lock);
+	atmel_spi_unlock(as);
 	msg->complete(msg->context);
-	spin_lock(&as->lock);
+	atmel_spi_lock(as);
 
 	as->current_transfer = NULL;
 	as->next_transfer = NULL;
@@ -793,13 +804,11 @@ static int atmel_spi_setup(struct spi_device *spi)
 		spi->controller_state = asd;
 		gpio_direction_output(npcs_pin, !(spi->mode & SPI_CS_HIGH));
 	} else {
-		unsigned long		flags;
-
-		spin_lock_irqsave(&as->lock, flags);
+		atmel_spi_lock(as);
 		if (as->stay == spi)
 			as->stay = NULL;
 		cs_deactivate(as, spi);
-		spin_unlock_irqrestore(&as->lock, flags);
+		atmel_spi_unlock(as);
 	}
 
 	asd->csr = csr;
@@ -818,7 +827,6 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 {
 	struct atmel_spi	*as;
 	struct spi_transfer	*xfer;
-	unsigned long		flags;
 	struct device		*controller = spi->master->dev.parent;
 	u8			bits;
 	struct atmel_spi_device	*asd;
@@ -883,11 +891,11 @@ static int atmel_spi_transfer(struct spi_device *spi, struct spi_message *msg)
 	msg->status = -EINPROGRESS;
 	msg->actual_length = 0;
 
-	spin_lock_irqsave(&as->lock, flags);
+	atmel_spi_lock(as);
 	list_add_tail(&msg->queue, &as->queue);
 	if (!as->current_transfer)
 		atmel_spi_next_message(spi->master);
-	spin_unlock_irqrestore(&as->lock, flags);
+	atmel_spi_unlock(as);
 
 	return 0;
 }
@@ -897,17 +905,16 @@ static void atmel_spi_cleanup(struct spi_device *spi)
 	struct atmel_spi	*as = spi_master_get_devdata(spi->master);
 	struct atmel_spi_device	*asd = spi->controller_state;
 	unsigned		gpio = (unsigned) spi->controller_data;
-	unsigned long		flags;
 
 	if (!asd)
 		return;
 
-	spin_lock_irqsave(&as->lock, flags);
+	atmel_spi_lock(as);
 	if (as->stay == spi) {
 		as->stay = NULL;
 		cs_deactivate(as, spi);
 	}
-	spin_unlock_irqrestore(&as->lock, flags);
+	atmel_spi_unlock(as);
 
 	spi->controller_state = NULL;
 	gpio_free(gpio);
-- 
1.7.9.5

