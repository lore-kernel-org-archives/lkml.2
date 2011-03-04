Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab1CDTnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:43:02 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11839 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932510Ab1CDTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:42:58 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: [RFC PATCH v2 09/12] i2c: Convert i2c-octeon.c to use device tree.
Date: Fri,  4 Mar 2011 11:42:21 -0800
Message-Id: <1299267744-17278-10-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
References: <1299267744-17278-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 04 Mar 2011 19:42:58.0451 (UTC) FILETIME=[5D455E30:01CBDAA4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
---
 arch/mips/cavium-octeon/octeon-platform.c |   84 -----------------------------
 arch/mips/include/asm/octeon/octeon.h     |    5 --
 drivers/i2c/busses/i2c-octeon.c           |   69 ++++++++++++++----------
 3 files changed, 41 insertions(+), 117 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 87512c5..0533351 100644
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
index 56dbe54..cb34725 100644
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
@@ -515,22 +514,22 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
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
 
@@ -539,19 +538,22 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
 		result = -ENXIO;
 		goto fail_region;
 	}
+	i2c->twsi_phys = res_mem->start;
+	i2c->regsize = resource_size(res_mem);
 
-	if (i2c_data == NULL) {
-		dev_err(i2c->dev, "no I2C frequency data\n");
+	data = of_get_property(pdev->dev.of_node, "clock-rate", &len);
+	if (data && len == sizeof(*data)) {
+		i2c->twsi_freq = be32_to_cpup(data);
+	} else {
+		dev_err(i2c->dev, "no I2C 'clock-rate' property\n");
 		result = -ENXIO;
 		goto fail_region;
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
 		goto fail_region;
 	}
@@ -581,28 +583,31 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
 
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
 	free_irq(i2c->irq, i2c);
 fail_irq:
 	iounmap(i2c->twsi_base);
-	release_mem_region(i2c->twsi_phys, i2c->regsize);
+
+	devm_release_mem_region(&pdev->dev, i2c->twsi_phys, i2c->regsize);
 fail_region:
-	kfree(i2c);
+
+	devm_kfree(&pdev->dev, i2c);
 out:
 	return result;
 };
@@ -615,17 +620,26 @@ static int __devexit octeon_i2c_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	free_irq(i2c->irq, i2c);
 	iounmap(i2c->twsi_base);
-	release_mem_region(i2c->twsi_phys, i2c->regsize);
-	kfree(i2c);
+	devm_release_mem_region(&pdev->dev, i2c->twsi_phys, i2c->regsize);
+	devm_kfree(&pdev->dev, i2c);
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
 
@@ -646,7 +660,6 @@ MODULE_AUTHOR("Michael Lawnick <michael.lawnick.ext@nsn.com>");
 MODULE_DESCRIPTION("I2C-Bus adapter for Cavium OCTEON processors");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-MODULE_ALIAS("platform:" DRV_NAME);
 
 module_init(octeon_i2c_init);
 module_exit(octeon_i2c_exit);
-- 
1.7.2.3

