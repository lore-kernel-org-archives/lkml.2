Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069Ab2IMKba (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 06:31:30 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:13502 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349Ab2IMKbM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 06:31:12 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApkCAMO0UVBbdWObgWdsb2JhbABFu3AiAQEWJieCIAEBBSdAEhAgMVcGE4gRvB2RRwOVX4kziVQ
X-IronPort-AV: E=Sophos;i="4.80,416,1344204000"; 
   d="scan'208";a="951021178"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH v2 3/5] staging: ipack: remove irq field in struct ipack_device.
Date: Thu, 13 Sep 2012 12:32:21 +0200
Message-Id: <1347532343-22948-3-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347532343-22948-1-git-send-email-siglesias@igalia.com>
References: <1347532343-22948-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

The field irq currently is identical to the slot number.  It does not seem to
have any real use.  The number is written to hardware in ipoctal but it seems
the value that is written does not matter.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/bridges/tpci200.c |    9 ++-------
 drivers/staging/ipack/devices/ipoctal.c |    9 +++++----
 drivers/staging/ipack/ipack.c           |    3 +--
 drivers/staging/ipack/ipack.h           |    8 ++------
 4 files changed, 10 insertions(+), 19 deletions(-)

diff --git a/drivers/staging/ipack/bridges/tpci200.c b/drivers/staging/ipack/bridges/tpci200.c
index 43f2f38..bb8aa70 100644
--- a/drivers/staging/ipack/bridges/tpci200.c
+++ b/drivers/staging/ipack/bridges/tpci200.c
@@ -190,7 +190,7 @@ static int tpci200_free_irq(struct ipack_device *dev)
 	return 0;
 }
 
-static int tpci200_request_irq(struct ipack_device *dev, int vector,
+static int tpci200_request_irq(struct ipack_device *dev,
 			       irqreturn_t (*handler)(void *), void *arg)
 {
 	int res = 0;
@@ -227,7 +227,6 @@ static int tpci200_request_irq(struct ipack_device *dev, int vector,
 	 * Read the User Manual of your IndustryPack device to know
 	 * where to write the vector in memory.
 	 */
-	slot_irq->vector = vector;
 	slot_irq->handler = handler;
 	slot_irq->arg = arg;
 	slot_irq->holder = dev;
@@ -715,12 +714,8 @@ static int tpci200_pci_probe(struct pci_dev *pdev,
 	tpci200->number = tpci200->info->ipack_bus->bus_nr;
 	dev_set_drvdata(&pdev->dev, tpci200);
 
-	/*
-	 * Give the same IRQ number as the slot number.
-	 * The TPCI200 has assigned his own two IRQ by PCI bus driver
-	 */
 	for (i = 0; i < TPCI200_NB_SLOT; i++)
-		ipack_device_register(tpci200->info->ipack_bus, i, i);
+		ipack_device_register(tpci200->info->ipack_bus, i);
 	return 0;
 
 out_err_bus_register:
diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index 30d8d42..9fc2f7f 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -288,7 +288,7 @@ static const struct tty_port_operations ipoctal_tty_port_ops = {
 };
 
 static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
-			     unsigned int slot, unsigned int vector)
+			     unsigned int slot)
 {
 	int res = 0;
 	int i;
@@ -387,9 +387,10 @@ static int ipoctal_inst_slot(struct ipoctal *ipoctal, unsigned int bus_nr,
 	 * Depending of the carrier these addresses are accesible or not.
 	 * More info in the datasheet.
 	 */
-	ipoctal->dev->bus->ops->request_irq(ipoctal->dev, vector,
+	ipoctal->dev->bus->ops->request_irq(ipoctal->dev,
 				       ipoctal_irq_handler, ipoctal);
-	iowrite8(vector, ipoctal->dev->mem_space.address + 1);
+	/* Dummy write */
+	iowrite8(1, ipoctal->dev->mem_space.address + 1);
 
 	/* Register the TTY device */
 
@@ -722,7 +723,7 @@ static int ipoctal_probe(struct ipack_device *dev)
 		return -ENOMEM;
 
 	ipoctal->dev = dev;
-	res = ipoctal_inst_slot(ipoctal, dev->bus_nr, dev->slot, dev->irq);
+	res = ipoctal_inst_slot(ipoctal, dev->bus_nr, dev->slot);
 	if (res)
 		goto out_uninst;
 
diff --git a/drivers/staging/ipack/ipack.c b/drivers/staging/ipack/ipack.c
index c83f015..d1e0651 100644
--- a/drivers/staging/ipack/ipack.c
+++ b/drivers/staging/ipack/ipack.c
@@ -427,7 +427,7 @@ out:
 }
 
 struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
-					   int slot, int irqv)
+					   int slot)
 {
 	int ret;
 	struct ipack_device *dev;
@@ -441,7 +441,6 @@ struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
 	dev->dev.parent = bus->parent;
 	dev->slot = slot;
 	dev->bus_nr = bus->bus_nr;
-	dev->irq = irqv;
 	dev->bus = bus;
 	dev_set_name(&dev->dev,
 		     "ipack-dev.%u.%u", dev->bus_nr, dev->slot);
diff --git a/drivers/staging/ipack/ipack.h b/drivers/staging/ipack/ipack.h
index f8405df..d8e3bb6 100644
--- a/drivers/staging/ipack/ipack.h
+++ b/drivers/staging/ipack/ipack.h
@@ -54,7 +54,6 @@ struct ipack_addr_space {
  *
  *	@bus_nr: IP bus number where the device is plugged
  *	@slot: Slot where the device is plugged in the carrier board
- *	@irq: IRQ vector
  *	@bus: ipack_bus_device where the device is plugged to.
  *	@id_space: Virtual address to ID space.
  *	@io_space: Virtual address to IO space.
@@ -68,7 +67,6 @@ struct ipack_addr_space {
 struct ipack_device {
 	unsigned int bus_nr;
 	unsigned int slot;
-	unsigned int irq;
 	struct ipack_bus_device *bus;
 	struct ipack_addr_space id_space;
 	struct ipack_addr_space io_space;
@@ -129,7 +127,7 @@ struct ipack_driver {
 struct ipack_bus_ops {
 	int (*map_space) (struct ipack_device *dev, unsigned int memory_size, int space);
 	int (*unmap_space) (struct ipack_device *dev, int space);
-	int (*request_irq) (struct ipack_device *dev, int vector,
+	int (*request_irq) (struct ipack_device *dev,
 			    irqreturn_t (*handler)(void *), void *arg);
 	int (*free_irq) (struct ipack_device *dev);
 	int (*get_clockrate) (struct ipack_device *dev);
@@ -187,13 +185,11 @@ void ipack_driver_unregister(struct ipack_driver *edrv);
  *
  * @bus: ipack bus device it is plugged to.
  * @slot: slot position in the bus device.
- * @irqv: IRQ vector for the mezzanine.
  *
  * Register a new ipack device (mezzanine device). The call is done by
  * the carrier device driver.
  */
-struct ipack_device *ipack_device_register(struct ipack_bus_device *bus,
-					   int slot, int irqv);
+struct ipack_device *ipack_device_register(struct ipack_bus_device *bus, int slot);
 void ipack_device_unregister(struct ipack_device *dev);
 
 /**
-- 
1.7.10.4

