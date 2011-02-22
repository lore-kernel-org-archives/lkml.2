Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1BVRth (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 12:49:37 -0500
Received: from mail-bw0-f51.google.com ([209.85.214.51]:51744 "EHLO
	mail-bw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1BVRtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 12:49:36 -0500
From: Michal Simek <monstr@monstr.eu>
To: linux-i2c@vger.kernel.org
Cc: grant.likely@secretlab.ca, devicetree-discuss@lists.ozlabs.org,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        John.Linn@xilinx.com, Michal Simek <monstr@monstr.eu>
Subject: [PATCH v3 1/2] i2c: xiic: Add OF support for Xilinx i2c bus interface
Date: Tue, 22 Feb 2011 18:49:30 +0100
Message-Id: <1298396971-611-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add OF support to Xilinx i2c bus interface.
It is used on Microblaze systems.

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/i2c/busses/i2c-xiic.c |   37 +++++++++++++++++++++++++++++--------
 1 files changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index a9c419e..0b7647b 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -41,6 +41,11 @@
 #include <linux/io.h>
 #include <linux/slab.h>
 
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/of_i2c.h>
+#include <linux/of_address.h>
+
 #define DRIVER_NAME "xiic-i2c"
 
 enum xilinx_i2c_state {
@@ -426,7 +431,7 @@ static void xiic_process(struct xiic_i2c *i2c)
 			xiic_wakeup(i2c, STATE_ERROR);
 
 	} else if (pend & (XIIC_INTR_TX_EMPTY_MASK | XIIC_INTR_TX_HALF_MASK)) {
-		/* Transmit register/FIFO is empty or ½ empty */
+		/* Transmit register/FIFO is empty or 1/2 empty */
 
 		clr = pend &
 			(XIIC_INTR_TX_EMPTY_MASK | XIIC_INTR_TX_HALF_MASK);
@@ -704,10 +709,6 @@ static int __devinit xiic_i2c_probe(struct platform_device *pdev)
 	if (irq < 0)
 		goto resource_missing;
 
-	pdata = (struct xiic_i2c_platform_data *) pdev->dev.platform_data;
-	if (!pdata)
-		return -EINVAL;
-
 	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
 	if (!i2c)
 		return -ENOMEM;
@@ -730,6 +731,7 @@ static int __devinit xiic_i2c_probe(struct platform_device *pdev)
 	i2c->adap = xiic_adapter;
 	i2c_set_adapdata(&i2c->adap, i2c);
 	i2c->adap.dev.parent = &pdev->dev;
+	i2c->adap.dev.of_node = of_node_get(pdev->dev.of_node);
 
 	xiic_reinit(i2c);
 
@@ -748,9 +750,16 @@ static int __devinit xiic_i2c_probe(struct platform_device *pdev)
 		goto add_adapter_failed;
 	}
 
-	/* add in known devices to the bus */
-	for (i = 0; i < pdata->num_devices; i++)
-		i2c_new_device(&i2c->adap, pdata->devices + i);
+	dev_info(&pdev->dev, "mapped to 0x%08X, irq=%d\n",
+					(unsigned int)i2c->base, irq);
+
+	pdata = (struct xiic_i2c_platform_data *) pdev->dev.platform_data;
+	if (pdata) {
+		/* add in known devices to the bus */
+		for (i = 0; i < pdata->num_devices; i++)
+			i2c_new_device(&i2c->adap, pdata->devices + i);
+	}
+	of_i2c_register_devices(&i2c->adap);
 
 	return 0;
 
@@ -799,12 +808,24 @@ static int __devexit xiic_i2c_remove(struct platform_device* pdev)
 /* work with hotplug and coldplug */
 MODULE_ALIAS("platform:"DRIVER_NAME);
 
+#ifdef CONFIG_OF
+/* Match table for of_platform binding */
+static struct of_device_id __devinitdata xilinx_iic_of_match[] = {
+	{ .compatible = "xlnx,xps-iic-2.00.a", },
+	{},
+};
+MODULE_DEVICE_TABLE(of, xilinx_iic_of_match);
+#else
+# define xilinx_iic_of_match NULL
+#endif
+
 static struct platform_driver xiic_i2c_driver = {
 	.probe   = xiic_i2c_probe,
 	.remove  = __devexit_p(xiic_i2c_remove),
 	.driver  = {
 		.owner = THIS_MODULE,
 		.name = DRIVER_NAME,
+		.of_match_table = xilinx_iic_of_match,
 	},
 };
 
-- 
1.5.5.6

