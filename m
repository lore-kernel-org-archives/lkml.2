Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab1KKCYA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 21:24:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44976 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab1KKCWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 21:22:19 -0500
From: ddaney.cavm@gmail.com
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: [PATCH 5/8] i2c: Convert i2c-octeon.c to use device tree.
Date: Thu, 10 Nov 2011 18:22:01 -0800
Message-Id: <1320978124-13042-6-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1320978124-13042-1-git-send-email-ddaney.cavm@gmail.com>
References: <1320978124-13042-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
Signed-off-by: David Daney <david.daney@cavium.com>
---
 arch/mips/cavium-octeon/octeon-platform.c |   84 -------------------------
 arch/mips/include/asm/octeon/octeon.h     |    5 --
 drivers/i2c/busses/i2c-octeon.c           |   94 ++++++++++++++++-------------
 3 files changed, 52 insertions(+), 131 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 2754bc2..f62a40f 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -168,90 +168,6 @@ out:
 }
 device_initcall(octeon_rng_device_init);
 
-static struct i2c_board_info __initdata octeon_i2c_devices[] = {
-	{
-		I2C_BOARD_INFO("ds1337", 0x68),
-	},
-};
-
-static int __init octeon_i2c_devices_init(void)
-{
-	return i2c_register_board_info(0, octeon_i2c_devices,
-				       ARRAY_SIZE(octeon_i2c_devices));
-}
-arch_initcall(octeon_i2c_devices_init);
-
-#define OCTEON_I2C_IO_BASE 0x1180000001000ull
-#define OCTEON_I2C_IO_UNIT_OFFSET 0x200
-
-static struct octeon_i2c_data octeon_i2c_data[2];
-
-static int __init octeon_i2c_device_init(void)
-{
-	struct platform_device *pd;
-	int ret = 0;
-	int port, num_ports;
-
-	struct resource i2c_resources[] = {
-		{
-			.flags	= IORESOURCE_MEM,
-		}, {
-			.flags	= IORESOURCE_IRQ,
-		}
-	};
-
-	if (OCTEON_IS_MODEL(OCTEON_CN56XX) || OCTEON_IS_MODEL(OCTEON_CN52XX))
-		num_ports = 2;
-	else
-		num_ports = 1;
-
-	for (port = 0; port < num_ports; port++) {
-		octeon_i2c_data[port].sys_freq = octeon_get_io_clock_rate();
-		/*FIXME: should be examined. At the moment is set for 100Khz */
-		octeon_i2c_data[port].i2c_freq = 100000;
-
-		pd = platform_device_alloc("i2c-octeon", port);
-		if (!pd) {
-			ret = -ENOMEM;
-			goto out;
-		}
-
-		pd->dev.platform_data = octeon_i2c_data + port;
-
-		i2c_resources[0].start =
-			OCTEON_I2C_IO_BASE + (port * OCTEON_I2C_IO_UNIT_OFFSET);
-		i2c_resources[0].end = i2c_resources[0].start + 0x1f;
-		switch (port) {
-		case 0:
-			i2c_resources[1].start = OCTEON_IRQ_TWSI;
-			i2c_resources[1].end = OCTEON_IRQ_TWSI;
-			break;
-		case 1:
-			i2c_resources[1].start = OCTEON_IRQ_TWSI2;
-			i2c_resources[1].end = OCTEON_IRQ_TWSI2;
-			break;
-		default:
-			BUG();
-		}
-
-		ret = platform_device_add_resources(pd,
-						    i2c_resources,
-						    ARRAY_SIZE(i2c_resources));
-		if (ret)
-			goto fail;
-
-		ret = platform_device_add(pd);
-		if (ret)
-			goto fail;
-	}
-	return ret;
-fail:
-	platform_device_put(pd);
-out:
-	return ret;
-}
-device_initcall(octeon_i2c_device_init);
-
 /* Octeon SMI/MDIO interface.  */
 static int __init octeon_mdiobus_device_init(void)
 {
diff --git a/arch/mips/include/asm/octeon/octeon.h b/arch/mips/include/asm/octeon/octeon.h
index f72f768..1e2486e 100644
--- a/arch/mips/include/asm/octeon/octeon.h
+++ b/arch/mips/include/asm/octeon/octeon.h
@@ -215,11 +215,6 @@ struct octeon_cf_data {
 	int		dma_engine;	/* -1 for no DMA */
 };
 
-struct octeon_i2c_data {
-	unsigned int	sys_freq;
-	unsigned int	i2c_freq;
-};
-
 extern void octeon_write_lcd(const char *s);
 extern void octeon_check_cpu_bist(void);
 extern int octeon_get_boot_debug_flag(void);
diff --git a/drivers/i2c/busses/i2c-octeon.c b/drivers/i2c/busses/i2c-octeon.c
index 56dbe54..e211c0b 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -2,7 +2,7 @@
  * (C) Copyright 2009-2010
  * Nokia Siemens Networks, michael.lawnick.ext@nsn.com
  *
- * Portions Copyright (C) 2010 Cavium Networks, Inc.
+ * Portions Copyright (C) 2010, 2011 Cavium Networks, Inc.
  *
  * This is a driver for the i2c adapter in Cavium Networks' OCTEON processors.
  *
@@ -11,17 +11,18 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/platform_device.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_i2c.h>
+#include <linux/delay.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/init.h>
-
-#include <linux/io.h>
 #include <linux/i2c.h>
-#include <linux/interrupt.h>
-#include <linux/delay.h>
-#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/of.h>
 
 #include <asm/octeon/octeon.h>
 
@@ -121,10 +122,8 @@ static u8 octeon_i2c_read_sw(struct octeon_i2c *i2c, u64 eop_reg)
  */
 static void octeon_i2c_write_int(struct octeon_i2c *i2c, u64 data)
 {
-	u64 tmp;
-
 	__raw_writeq(data, i2c->twsi_base + TWSI_INT);
-	tmp = __raw_readq(i2c->twsi_base + TWSI_INT);
+	__raw_readq(i2c->twsi_base + TWSI_INT);
 }
 
 /**
@@ -515,94 +514,101 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
 {
 	int irq, result = 0;
 	struct octeon_i2c *i2c;
-	struct octeon_i2c_data *i2c_data;
 	struct resource *res_mem;
+	const __be32 *data;
+	int len;
 
 	/* All adaptors have an irq.  */
 	irq = platform_get_irq(pdev, 0);
 	if (irq < 0)
 		return irq;
 
-	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
+	i2c = devm_kzalloc(&pdev->dev, sizeof(*i2c), GFP_KERNEL);
 	if (!i2c) {
 		dev_err(&pdev->dev, "kzalloc failed\n");
 		result = -ENOMEM;
 		goto out;
 	}
 	i2c->dev = &pdev->dev;
-	i2c_data = pdev->dev.platform_data;
 
 	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 
 	if (res_mem == NULL) {
 		dev_err(i2c->dev, "found no memory resource\n");
 		result = -ENXIO;
-		goto fail_region;
+		goto out;
 	}
+	i2c->twsi_phys = res_mem->start;
+	i2c->regsize = resource_size(res_mem);
 
-	if (i2c_data == NULL) {
-		dev_err(i2c->dev, "no I2C frequency data\n");
+	/*
+	 * "clock-rate" is a legacy binding, the official binding is
+	 * "clock-frequency".  Try the official one first and then
+	 * fall back if it doesn't exist.
+	 */
+	data = of_get_property(pdev->dev.of_node, "clock-frequency", &len);
+	if (!data || len != sizeof(*data))
+		data = of_get_property(pdev->dev.of_node, "clock-rate", &len);
+	if (data && len == sizeof(*data)) {
+		i2c->twsi_freq = be32_to_cpup(data);
+	} else {
+		dev_err(i2c->dev,
+			"no I2C 'clock-rate' or 'clock-frequency' property\n");
 		result = -ENXIO;
-		goto fail_region;
+		goto out;
 	}
 
-	i2c->twsi_phys = res_mem->start;
-	i2c->regsize = resource_size(res_mem);
-	i2c->twsi_freq = i2c_data->i2c_freq;
-	i2c->sys_freq = i2c_data->sys_freq;
+	i2c->sys_freq = octeon_get_io_clock_rate();
 
-	if (!request_mem_region(i2c->twsi_phys, i2c->regsize, res_mem->name)) {
+	if (!devm_request_mem_region(&pdev->dev, i2c->twsi_phys, i2c->regsize,
+				      res_mem->name)) {
 		dev_err(i2c->dev, "request_mem_region failed\n");
-		goto fail_region;
+		goto out;
 	}
-	i2c->twsi_base = ioremap(i2c->twsi_phys, i2c->regsize);
+	i2c->twsi_base = devm_ioremap(&pdev->dev, i2c->twsi_phys, i2c->regsize);
 
 	init_waitqueue_head(&i2c->queue);
 
 	i2c->irq = irq;
 
-	result = request_irq(i2c->irq, octeon_i2c_isr, 0, DRV_NAME, i2c);
+	result = devm_request_irq(&pdev->dev, i2c->irq,
+				  octeon_i2c_isr, 0, DRV_NAME, i2c);
 	if (result < 0) {
 		dev_err(i2c->dev, "failed to attach interrupt\n");
-		goto fail_irq;
+		goto out;
 	}
 
 	result = octeon_i2c_initlowlevel(i2c);
 	if (result) {
 		dev_err(i2c->dev, "init low level failed\n");
-		goto  fail_add;
+		goto  out;
 	}
 
 	result = octeon_i2c_setclock(i2c);
 	if (result) {
 		dev_err(i2c->dev, "clock init failed\n");
-		goto  fail_add;
+		goto  out;
 	}
 
 	i2c->adap = octeon_i2c_ops;
 	i2c->adap.dev.parent = &pdev->dev;
-	i2c->adap.nr = pdev->id >= 0 ? pdev->id : 0;
+	i2c->adap.dev.of_node = pdev->dev.of_node;
 	i2c_set_adapdata(&i2c->adap, i2c);
 	platform_set_drvdata(pdev, i2c);
 
-	result = i2c_add_numbered_adapter(&i2c->adap);
+	result = i2c_add_adapter(&i2c->adap);
 	if (result < 0) {
 		dev_err(i2c->dev, "failed to add adapter\n");
 		goto fail_add;
 	}
-
 	dev_info(i2c->dev, "version %s\n", DRV_VERSION);
 
-	return result;
+	of_i2c_register_devices(&i2c->adap);
+
+	return 0;
 
 fail_add:
 	platform_set_drvdata(pdev, NULL);
-	free_irq(i2c->irq, i2c);
-fail_irq:
-	iounmap(i2c->twsi_base);
-	release_mem_region(i2c->twsi_phys, i2c->regsize);
-fail_region:
-	kfree(i2c);
 out:
 	return result;
 };
@@ -613,19 +619,24 @@ static int __devexit octeon_i2c_remove(struct platform_device *pdev)
 
 	i2c_del_adapter(&i2c->adap);
 	platform_set_drvdata(pdev, NULL);
-	free_irq(i2c->irq, i2c);
-	iounmap(i2c->twsi_base);
-	release_mem_region(i2c->twsi_phys, i2c->regsize);
-	kfree(i2c);
 	return 0;
 };
 
+static struct of_device_id octeon_i2c_match[] = {
+	{
+		.compatible = "cavium,octeon-3860-twsi",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, octeon_i2c_match);
+
 static struct platform_driver octeon_i2c_driver = {
 	.probe		= octeon_i2c_probe,
 	.remove		= __devexit_p(octeon_i2c_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= DRV_NAME,
+		.of_match_table = octeon_i2c_match,
 	},
 };
 
@@ -646,7 +657,6 @@ MODULE_AUTHOR("Michael Lawnick <michael.lawnick.ext@nsn.com>");
 MODULE_DESCRIPTION("I2C-Bus adapter for Cavium OCTEON processors");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-MODULE_ALIAS("platform:" DRV_NAME);
 
 module_init(octeon_i2c_init);
 module_exit(octeon_i2c_exit);
-- 
1.7.2.3

