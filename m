Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552Ab2I0KhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:37:04 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:21131 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756151Ab2I0Kg4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdSECAxVwYTiAm3b5E1A5VpiTyJWA
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447816"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 09/17] staging: ipack/devices/ipoctal: obtain model from dev->id_device.
Date: Thu, 27 Sep 2012 12:37:33 +0200
Message-Id: <1348742261-28145-9-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

By doing so we can remove ipoctal_check_model() and we also no longer need
to map the IPACK_ID_SPACE.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   46 ++-----------------------------
 1 file changed, 2 insertions(+), 44 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index d9dbb3f..35b98e8 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -258,29 +258,6 @@ static irqreturn_t ipoctal_irq_handler(void *arg)
 	return IRQ_HANDLED;
 }
 
-static int ipoctal_check_model(struct ipack_device *dev, unsigned char *id)
-{
-	unsigned char manufacturerID;
-	unsigned char board_id;
-
-
-	manufacturerID = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MANUFACTURER_ID);
-	if (manufacturerID != IPACK1_VENDOR_ID_SBS)
-		return -ENODEV;
-	board_id = ioread8(dev->id_space.address + IPACK_IDPROM_OFFSET_MODEL);
-	switch (board_id) {
-	case IPACK1_DEVICE_ID_SBS_OCTAL_232:
-	case IPACK1_DEVICE_ID_SBS_OCTAL_422:
-	case IPACK1_DEVICE_ID_SBS_OCTAL_485:
-		*id = board_id;
-		break;
-	default:
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
 static const struct tty_port_operations ipoctal_tty_port_ops = {
 	.dtr_rts = NULL,
 	.activate = ipoctal_port_activate,
@@ -293,27 +270,11 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	int i;
 	struct tty_driver *tty;
 	char name[20];
-	unsigned char board_id;
 	struct ipoctal_channel *channel;
 	union scc2698_channel __iomem *chan_regs;
 	union scc2698_block __iomem *block_regs;
 
-	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
-						IPACK_ID_SPACE);
-	if (res) {
-		dev_err(&ipoctal->dev->dev,
-			"Unable to map slot [%d:%d] ID space!\n",
-			bus_nr, slot);
-		return res;
-	}
-
-	res = ipoctal_check_model(ipoctal->dev, &board_id);
-	if (res) {
-		ipoctal->dev->bus->ops->unmap_space(ipoctal->dev,
-						    IPACK_ID_SPACE);
-		goto out_unregister_id_space;
-	}
-	ipoctal->board_id = board_id;
+	ipoctal->board_id = ipoctal->dev->id_device;
 
 	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
 						IPACK_IO_SPACE);
@@ -321,7 +282,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 		dev_err(&ipoctal->dev->dev,
 			"Unable to map slot [%d:%d] IO space!\n",
 			bus_nr, slot);
-		goto out_unregister_id_space;
+		return res;
 	}
 
 	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
@@ -465,8 +426,6 @@ out_unregister_int_space:
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_INT_SPACE);
 out_unregister_io_space:
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
-out_unregister_id_space:
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
 	return res;
 }
 
@@ -748,7 +707,6 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_INT_SPACE);
 	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_ID_SPACE);
 	kfree(ipoctal);
 }
 
-- 
1.7.10.4

