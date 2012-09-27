Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756946Ab2I0Kl3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 06:41:29 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:33408 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429Ab2I0Kg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 06:36:57 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AkECAEQrZFBbdWObgWdsb2JhbABFvg8jAQEWJieCIAEBBSdSECAxVwYTiAm3b5E1A5VpkxQ
X-IronPort-AV: E=Sophos;i="4.80,496,1344204000"; 
   d="scan'208";a="956447819"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 10/17] staging: ipack: swich to regular ioremap and friends.
Date: Thu, 27 Sep 2012 12:37:34 +0200
Message-Id: <1348742261-28145-10-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
References: <1348742261-28145-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

Use the regular ioremap functions and their managed counterparts instead
of the ones provided through IPack callbacks.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   70 +++++++++++++++----------------
 drivers/staging/ipack/ipack.c           |    8 ++--
 2 files changed, 37 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 35b98e8..3c8eb64 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -53,6 +53,8 @@ struct ipoctal {
 	struct ipoctal_channel		channel[NR_CHANNELS];
 	unsigned char			write;
 	struct tty_driver		*tty_drv;
+	u8 __iomem			*mem_space;
+	u8 __iomem			*int_space;
 };
 
 static int ipoctal_port_activate(struct tty_port *port, struct tty_struct *tty)
@@ -252,8 +254,8 @@ static irqreturn_t ipoctal_irq_handler(void *arg)
 		ipoctal_irq_channel(&ipoctal->channel[i]);
 
 	/* Clear the IPack device interrupt */
-	readw(ipoctal->dev->int_space.address + ACK_INT_REQ0);
-	readw(ipoctal->dev->int_space.address + ACK_INT_REQ1);
+	readw(ipoctal->int_space + ACK_INT_REQ0);
+	readw(ipoctal->int_space + ACK_INT_REQ1);
 
 	return IRQ_HANDLED;
 }
@@ -266,48 +268,55 @@ static const struct tty_port_operations ipoctal_tty_port_ops = {
 static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 			     unsigned int slot)
 {
-	int res = 0;
+	int res;
 	int i;
 	struct tty_driver *tty;
 	char name[20];
 	struct ipoctal_channel *channel;
+	struct ipack_region *region;
+	void __iomem *addr;
 	union scc2698_channel __iomem *chan_regs;
 	union scc2698_block __iomem *block_regs;
 
 	ipoctal->board_id = ipoctal->dev->id_device;
 
-	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
-						IPACK_IO_SPACE);
-	if (res) {
+	region = &ipoctal->dev->region[IPACK_IO_SPACE];
+	addr = devm_ioremap_nocache(&ipoctal->dev->dev,
+				    region->start, region->size);
+	if (!addr) {
 		dev_err(&ipoctal->dev->dev,
 			"Unable to map slot [%d:%d] IO space!\n",
 			bus_nr, slot);
-		return res;
+		return -EADDRNOTAVAIL;
 	}
+	/* Save the virtual address to access the registers easily */
+	chan_regs =
+		(union scc2698_channel __iomem *) addr;
+	block_regs =
+		(union scc2698_block __iomem *) addr;
 
-	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev, 0,
-						IPACK_INT_SPACE);
-	if (res) {
+	region = &ipoctal->dev->region[IPACK_INT_SPACE];
+	ipoctal->int_space =
+		devm_ioremap_nocache(&ipoctal->dev->dev,
+				     region->start, region->size);
+	if (!ipoctal->int_space) {
 		dev_err(&ipoctal->dev->dev,
 			"Unable to map slot [%d:%d] INT space!\n",
 			bus_nr, slot);
-		goto out_unregister_io_space;
+		return -EADDRNOTAVAIL;
 	}
 
-	res = ipoctal->dev->bus->ops->map_space(ipoctal->dev,
-					   0x8000, IPACK_MEM_SPACE);
-	if (res) {
+	region = &ipoctal->dev->region[IPACK_MEM_SPACE];
+	ipoctal->mem_space =
+		devm_ioremap_nocache(&ipoctal->dev->dev,
+				     region->start, 0x8000);
+	if (!addr) {
 		dev_err(&ipoctal->dev->dev,
 			"Unable to map slot [%d:%d] MEM space!\n",
 			bus_nr, slot);
-		goto out_unregister_int_space;
+		return -EADDRNOTAVAIL;
 	}
 
-	/* Save the virtual address to access the registers easily */
-	chan_regs =
-		(union scc2698_channel __iomem *) ipoctal->dev->io_space.address;
-	block_regs =
-		(union scc2698_block __iomem *) ipoctal->dev->io_space.address;
 
 	/* Disable RX and TX before touching anything */
 	for (i = 0; i < NR_CHANNELS ; i++) {
@@ -350,17 +359,15 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
 				       ipoctal_irq_handler, ipoctal);
 	/* Dummy write */
-	iowrite8(1, ipoctal->dev->mem_space.address + 1);
+	iowrite8(1, ipoctal->mem_space + 1);
 
 	/* Register the TTY device */
 
 	/* Each IP-OCTAL channel is a TTY port */
 	tty = alloc_tty_driver(NR_CHANNELS);
 
-	if (!tty) {
-		res = -ENOMEM;
-		goto out_unregister_slot_unmap;
-	}
+	if (!tty)
+		return -ENOMEM;
 
 	/* Fill struct tty_driver with ipoctal data */
 	tty->owner = THIS_MODULE;
@@ -383,7 +390,7 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	if (res) {
 		dev_err(&ipoctal->dev->dev, "Can't register tty driver.\n");
 		put_tty_driver(tty);
-		goto out_unregister_slot_unmap;
+		return res;
 	}
 
 	/* Save struct tty_driver for use it when uninstalling the device */
@@ -419,14 +426,6 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	}
 
 	return 0;
-
-out_unregister_slot_unmap:
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
-out_unregister_int_space:
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_INT_SPACE);
-out_unregister_io_space:
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
-	return res;
 }
 
 static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
@@ -704,9 +703,6 @@ static void __ipoctal_remove(struct ipoctal *ipoctal)
 
 	tty_unregister_driver(ipoctal->tty_drv);
 	put_tty_driver(ipoctal->tty_drv);
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_MEM_SPACE);
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_INT_SPACE);
-	ipoctal->dev->bus->ops->unmap_space(ipoctal->dev, IPACK_IO_SPACE);
 	kfree(ipoctal);
 }
 
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index d2ed9f5..5bd462b 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -351,12 +351,12 @@ static int ipack_device_read_id(struct ipack_device *dev)
 	int i;
 	int ret = 0;
 
-	ret = dev->bus->ops->map_space(dev, 0, IPACK_ID_SPACE);
-	if (ret) {
+	idmem = ioremap(dev->region[IPACK_ID_SPACE].start,
+			dev->region[IPACK_ID_SPACE].size);
+	if (!idmem) {
 		dev_err(&dev->dev, "error mapping memory\n");
 		return ret;
 	}
-	idmem = dev->id_space.address;
 
 	/* Determine ID PROM Data Format.  If we find the ids "IPAC" or "IPAH"
 	 * we are dealing with a IndustryPack  format 1 device.  If we detect
@@ -421,7 +421,7 @@ static int ipack_device_read_id(struct ipack_device *dev)
 	}
 
 out:
-	dev->bus->ops->unmap_space(dev, IPACK_ID_SPACE);
+	iounmap(idmem);
 
 	return ret;
 }
-- 
1.7.10.4

