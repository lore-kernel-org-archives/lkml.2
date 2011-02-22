Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307Ab1BVU62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:58:28 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14014 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab1BVU60 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:58:26 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        linux-i2c@vger.kernel.org
Subject: [RFC PATCH 07/10] i2c: Convert i2c-octeon.c to use device tree.
Date: Tue, 22 Feb 2011 12:57:51 -0800
Message-Id: <1298408274-20856-8-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 22 Feb 2011 20:58:25.0910 (UTC) FILETIME=[3FB74960:01CBD2D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>
Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
Cc: linux-i2c@vger.kernel.org
---
 arch/mips/cavium-octeon/octeon-platform.c |   84 ---------------------------
 arch/mips/include/asm/octeon/octeon.h     |    5 --
 drivers/i2c/busses/i2c-octeon.c           |   88 +++++++++++++---------------
 3 files changed, 41 insertions(+), 136 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index 428de0d..f148324 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -166,90 +166,6 @@ out:
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
index 56dbe54..99a20c6 100644
--- a/drivers/i2c/busses/i2c-octeon.c
+++ b/drivers/i2c/busses/i2c-octeon.c
@@ -11,17 +11,21 @@
  * warranty of any kind, whether express or implied.
  */
 
+#include <linux/platform_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
+#include <linux/of_irq.h>
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
 
@@ -67,9 +71,7 @@ struct octeon_i2c {
 	int irq;
 	int twsi_freq;
 	int sys_freq;
-	resource_size_t twsi_phys;
 	void __iomem *twsi_base;
-	resource_size_t regsize;
 	struct device *dev;
 };
 
@@ -511,17 +513,18 @@ static int __devinit octeon_i2c_initlowlevel(struct octeon_i2c *i2c)
 	return -EIO;
 }
 
-static int __devinit octeon_i2c_probe(struct platform_device *pdev)
+static int __devinit octeon_i2c_probe(struct platform_device *pdev,
+				      const struct of_device_id *match)
 {
 	int irq, result = 0;
 	struct octeon_i2c *i2c;
-	struct octeon_i2c_data *i2c_data;
-	struct resource *res_mem;
+	const __be32 *data;
+	int len;
 
 	/* All adaptors have an irq.  */
-	irq = platform_get_irq(pdev, 0);
-	if (irq < 0)
-		return irq;
+	irq = irq_of_parse_and_map(pdev->dev.of_node, 0);
+	if (!irq)
+		return -ENXIO;
 
 	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
 	if (!i2c) {
@@ -530,32 +533,16 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
 		goto out;
 	}
 	i2c->dev = &pdev->dev;
-	i2c_data = pdev->dev.platform_data;
-
-	res_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-
-	if (res_mem == NULL) {
-		dev_err(i2c->dev, "found no memory resource\n");
-		result = -ENXIO;
-		goto fail_region;
-	}
 
-	if (i2c_data == NULL) {
-		dev_err(i2c->dev, "no I2C frequency data\n");
-		result = -ENXIO;
-		goto fail_region;
-	}
+	data = of_get_property(pdev->dev.of_node, "clock-rate", &len);
+	if (data && len == sizeof(*data))
+		i2c->twsi_freq = be32_to_cpup(data);
+	else
+		i2c->twsi_freq = 100000;
 
-	i2c->twsi_phys = res_mem->start;
-	i2c->regsize = resource_size(res_mem);
-	i2c->twsi_freq = i2c_data->i2c_freq;
-	i2c->sys_freq = i2c_data->sys_freq;
+	i2c->sys_freq = octeon_get_io_clock_rate();
 
-	if (!request_mem_region(i2c->twsi_phys, i2c->regsize, res_mem->name)) {
-		dev_err(i2c->dev, "request_mem_region failed\n");
-		goto fail_region;
-	}
-	i2c->twsi_base = ioremap(i2c->twsi_phys, i2c->regsize);
+	i2c->twsi_base = of_iomap(pdev->dev.of_node, 0);
 
 	init_waitqueue_head(&i2c->queue);
 
@@ -581,27 +568,27 @@ static int __devinit octeon_i2c_probe(struct platform_device *pdev)
 
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
-fail_region:
+
 	kfree(i2c);
 out:
 	return result;
@@ -615,17 +602,25 @@ static int __devexit octeon_i2c_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	free_irq(i2c->irq, i2c);
 	iounmap(i2c->twsi_base);
-	release_mem_region(i2c->twsi_phys, i2c->regsize);
 	kfree(i2c);
 	return 0;
 };
 
-static struct platform_driver octeon_i2c_driver = {
+static struct of_device_id octeon_i2c_match[] = {
+	{
+		.compatible = "octeon,twsi",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, octeon_i2c_match);
+
+static struct of_platform_driver octeon_i2c_driver = {
 	.probe		= octeon_i2c_probe,
 	.remove		= __devexit_p(octeon_i2c_remove),
 	.driver		= {
 		.owner	= THIS_MODULE,
 		.name	= DRV_NAME,
+		.of_match_table = octeon_i2c_match,
 	},
 };
 
@@ -633,20 +628,19 @@ static int __init octeon_i2c_init(void)
 {
 	int rv;
 
-	rv = platform_driver_register(&octeon_i2c_driver);
+	rv = of_register_platform_driver(&octeon_i2c_driver);
 	return rv;
 }
 
 static void __exit octeon_i2c_exit(void)
 {
-	platform_driver_unregister(&octeon_i2c_driver);
+	of_unregister_platform_driver(&octeon_i2c_driver);
 }
 
 MODULE_AUTHOR("Michael Lawnick <michael.lawnick.ext@nsn.com>");
 MODULE_DESCRIPTION("I2C-Bus adapter for Cavium OCTEON processors");
 MODULE_LICENSE("GPL");
 MODULE_VERSION(DRV_VERSION);
-MODULE_ALIAS("platform:" DRV_NAME);
 
 module_init(octeon_i2c_init);
 module_exit(octeon_i2c_exit);
-- 
1.7.2.3

