Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab2IMJpx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 05:45:53 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:38978 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756834Ab2IMJpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 05:45:24 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkCAL6qUVBbdWObgWdsb2JhbABFu3AiAQEWJieCIAEBBSdSECAxVwYTiBG8GpFHA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="scan'208";a="1043297972"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 2/5] Staging: ipack: move the responsibility to clear interrupts to the IPack devices.
Date: Thu, 13 Sep 2012 11:46:25 +0200
Message-Id: <1347529588-21212-2-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
References: <1347529588-21212-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Now the IPack device acknowledges its own IRQ.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    4 ----
 drivers/staging/ipack/devices/ipoctal.c |   19 +++++++++++++++++--
 drivers/staging/ipack/devices/scc2698.h |    3 +++
 3 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 3462783..43f2f38 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -126,10 +126,6 @@ static irqreturn_t tpci200_slot_irq(struct slot_irq *slot_irq)
 		return -ENODEV;
 	ret = slot_irq->handler(slot_irq->arg);
 
-	/* Clear the IPack device interrupt */
-	readw(slot_irq->holder->io_space.address + 0xC0);
-	readw(slot_irq->holder->io_space.address + 0xC2);
-
 	return ret;
 }
 
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 0292364..30d8d42 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -252,6 +252,10 @@ static irqreturn_t ipoctal_irq_handler(void *arg)
 	for (i = 0; i < NR_CHANNELS; i++)
 		ipoctal_irq_channel(&ipoctal->channel[i]);
 
+	/* Clear the IPack device interrupt */
+	readw(ipoctal->dev->int_space.address + ACK_INT_REQ0);
+	readw(ipoctal->dev->int_space.address + ACK_INT_REQ1);
+
 	return IRQ_HANDLED;
 }
 
@@ -264,7 +268,6 @@ static int ipoctal_check_model(struct ipack_device *dev, unsigned char *id)
 	manufacturerID = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MANUFACTURER_ID);
 	if (manufacturerID != IPACK1_VENDOR_ID_SBS)
 		return -ENODEV;
-
 	board_id = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MODEL);
 	switch (board_id) {
 	case IPACK1_DEVICE_ID_SBS_OCTAL_232:
@@ -322,13 +325,22 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		goto out_unregister_id_space;
 	}
 
+	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
+						IPACK_INT_SPACE);
+	if (res) {
+		dev_err(&ipoctal->dev->dev,
+			"Unable to map slot [%d:%d] INT space!\n",
+			bus_nr, slot);
+		goto out_unregister_io_space;
+	}
+
 	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev,
 					   0x8000, IPACK_MEM_SPACE);
 	if (res) {
 		dev_err(&ipoctal->dev->dev,
 			"Unable to map slot [%d:%d] MEM space!\n",
 			bus_nr, slot);
-		goto out_unregister_io_space;
+		goto out_unregister_int_space;
 	}
 
 	/* Save the virtual address to access the registers easily */
@@ -450,6 +462,8 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 
 out_unregister_slot_unmap:
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
+out_unregister_int_space:
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_INT_SPACE);
 out_unregister_io_space:
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
 out_unregister_id_space:
@@ -735,6 +749,7 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 	tty_unregister_driver(ipoctal->tty_drv);
 	put_tty_driver(ipoctal->tty_drv);
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
+	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_INT_SPACE);
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
 	kfree(ipoctal);
diff --git a/drivers/staging/ipack/devices/scc2698.h b/drivers/staging/ipack/devices/scc2698.h
index 223838a..96e8d8c 100644
--- a/drivers/staging/ipack/devices/scc2698.h
+++ b/drivers/staging/ipack/devices/scc2698.h
@@ -221,4 +221,7 @@ union scc2698_block {
 #define ISR_DELTA_BREAK_B           (0x1 << 6)
 #define ISR_INPUT_PORT_CHANGE       (0x1 << 7)
 
+#define ACK_INT_REQ0			0
+#define ACK_INT_REQ1			2
+
 #endif /* SCC2698_H_ */
-- 
1.7.10.4

