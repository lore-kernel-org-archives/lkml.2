Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757922Ab2CSGdQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:33:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39038 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab2CSGdN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:33:13 -0400
Date: Sun, 18 Mar 2012 23:33:07 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: John Linn <john.linn@xilinx.com>
Cc: Tobias Klauser <tklauser@distanz.ch>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Input: xilinx_ps2 - allocate serio port separately
Message-ID: <20120319063306.GA10099@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'struct serio' is a refcounted data structure with lifetime rules different
from 'struct xps2data'. It is quite likely that serio_unregister_port() will
try to free memory allocated by the port and that is why it should be
allocated separately.

Also switch to using platform_get/set_drvdata instead of dev_get/set_drvdata
because we are dealing with platform device.

Reported-by: Tobias Klauser <tklauser@distanz.ch>
Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

Not tested...

 drivers/input/serio/xilinx_ps2.c |   35 ++++++++++++++++++-----------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index d96d4c2..1e983be 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -73,7 +73,8 @@ struct xps2data {
 	spinlock_t lock;
 	void __iomem *base_address;	/* virt. address of control registers */
 	unsigned int flags;
-	struct serio serio;		/* serio */
+	struct serio *serio;		/* serio */
+	struct device *dev;
 };
 
 /************************************/
@@ -119,7 +120,7 @@ static irqreturn_t xps2_interrupt(int irq, void *dev_id)
 
 	/* Check which interrupt is active */
 	if (intr_sr & XPS2_IPIXR_RX_OVF)
-		dev_warn(drvdata->serio.dev.parent, "receive overrun error\n");
+		dev_warn(drvdata->dev, "receive overrun error\n");
 
 	if (intr_sr & XPS2_IPIXR_RX_ERR)
 		drvdata->flags |= SERIO_PARITY;
@@ -132,10 +133,10 @@ static irqreturn_t xps2_interrupt(int irq, void *dev_id)
 
 		/* Error, if a byte is not received */
 		if (status) {
-			dev_err(drvdata->serio.dev.parent,
+			dev_err(drvdata->dev,
 				"wrong rcvd byte count (%d)\n", status);
 		} else {
-			serio_interrupt(&drvdata->serio, c, drvdata->flags);
+			serio_interrupt(drvdata->serio, c, drvdata->flags);
 			drvdata->flags = 0;
 		}
 	}
@@ -193,7 +194,7 @@ static int sxps2_open(struct serio *pserio)
 	error = request_irq(drvdata->irq, &xps2_interrupt, 0,
 				DRIVER_NAME, drvdata);
 	if (error) {
-		dev_err(drvdata->serio.dev.parent,
+		dev_err(drvdata->dev,
 			"Couldn't allocate interrupt %d\n", drvdata->irq);
 		return error;
 	}
@@ -259,15 +260,16 @@ static int __devinit xps2_of_probe(struct platform_device *ofdev)
 	}
 
 	drvdata = kzalloc(sizeof(struct xps2data), GFP_KERNEL);
-	if (!drvdata) {
-		dev_err(dev, "Couldn't allocate device private record\n");
-		return -ENOMEM;
+	serio = kzalloc(sizeof(struct serio), GFP_KERNEL);
+	if (!drvdata || !serio) {
+		error = -ENOMEM;
+		goto failed1;
 	}
 
-	dev_set_drvdata(dev, drvdata);
-
 	spin_lock_init(&drvdata->lock);
 	drvdata->irq = r_irq.start;
+	drvdata->serio = serio;
+	drvdata->dev = dev;
 
 	phys_addr = r_mem.start;
 	remap_size = resource_size(&r_mem);
@@ -298,7 +300,6 @@ static int __devinit xps2_of_probe(struct platform_device *ofdev)
 		 (unsigned long long)phys_addr, drvdata->base_address,
 		 drvdata->irq);
 
-	serio = &drvdata->serio;
 	serio->id.type = SERIO_8042;
 	serio->write = sxps2_write;
 	serio->open = sxps2_open;
@@ -312,13 +313,14 @@ static int __devinit xps2_of_probe(struct platform_device *ofdev)
 
 	serio_register_port(serio);
 
+	platform_set_drvdata(ofdev, drvdata);
 	return 0;		/* success */
 
 failed2:
 	release_mem_region(phys_addr, remap_size);
 failed1:
+	kfree(serio);
 	kfree(drvdata);
-	dev_set_drvdata(dev, NULL);
 
 	return error;
 }
@@ -333,22 +335,21 @@ failed1:
  */
 static int __devexit xps2_of_remove(struct platform_device *of_dev)
 {
-	struct device *dev = &of_dev->dev;
-	struct xps2data *drvdata = dev_get_drvdata(dev);
+	struct xps2data *drvdata = platform_get_drvdata(of_dev);
 	struct resource r_mem; /* IO mem resources */
 
-	serio_unregister_port(&drvdata->serio);
+	serio_unregister_port(drvdata->serio);
 	iounmap(drvdata->base_address);
 
 	/* Get iospace of the device */
 	if (of_address_to_resource(of_dev->dev.of_node, 0, &r_mem))
-		dev_err(dev, "invalid address\n");
+		dev_err(drvdata->dev, "invalid address\n");
 	else
 		release_mem_region(r_mem.start, resource_size(&r_mem));
 
 	kfree(drvdata);
 
-	dev_set_drvdata(dev, NULL);
+	platform_set_drvdata(of_dev, NULL);
 
 	return 0;
 }
-- 
1.7.7.6


-- 
Dmitry
