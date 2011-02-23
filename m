Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1BWEes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028Ab1BWEep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:45 -0500
Subject: [RFC PATCH 13/15] dt/serial: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:42 -0700
Message-ID: <20110223043442.20795.4037.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of users of of_platform_driver in drivers/serial.  The
of_platform_{,un}register_driver functions are going away, so the
users need to be converted to using the platform_bus_type directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/tty/serial/apbuart.c                |   11 +++++------
 drivers/tty/serial/cpm_uart/cpm_uart_core.c |    9 ++++-----
 drivers/tty/serial/mpc52xx_uart.c           |   13 +++++--------
 drivers/tty/serial/of_serial.c              |   14 ++++++++------
 drivers/tty/serial/sunhv.c                  |    8 ++++----
 drivers/tty/serial/sunsab.c                 |    8 ++++----
 drivers/tty/serial/sunsu.c                  |    6 +++---
 drivers/tty/serial/sunzilog.c               |   10 +++++-----
 drivers/tty/serial/ucc_uart.c               |    9 ++++-----
 9 files changed, 42 insertions(+), 46 deletions(-)

diff --git a/drivers/tty/serial/apbuart.c b/drivers/tty/serial/apbuart.c
index 095a5d5..1ab999b 100644
--- a/drivers/tty/serial/apbuart.c
+++ b/drivers/tty/serial/apbuart.c
@@ -553,8 +553,7 @@ static struct uart_driver grlib_apbuart_driver = {
 /* OF Platform Driver                                                       */
 /* ======================================================================== */
 
-static int __devinit apbuart_probe(struct platform_device *op,
-				   const struct of_device_id *match)
+static int __devinit apbuart_probe(struct platform_device *op)
 {
 	int i = -1;
 	struct uart_port *port = NULL;
@@ -587,7 +586,7 @@ static struct of_device_id __initdata apbuart_match[] = {
 	{},
 };
 
-static struct of_platform_driver grlib_apbuart_of_driver = {
+static struct platform_driver grlib_apbuart_of_driver = {
 	.probe = apbuart_probe,
 	.driver = {
 		.owner = THIS_MODULE,
@@ -676,10 +675,10 @@ static int __init grlib_apbuart_init(void)
 		return ret;
 	}
 
-	ret = of_register_platform_driver(&grlib_apbuart_of_driver);
+	ret = platform_driver_register(&grlib_apbuart_of_driver);
 	if (ret) {
 		printk(KERN_ERR
-		       "%s: of_register_platform_driver failed (%i)\n",
+		       "%s: platform_driver_register failed (%i)\n",
 		       __FILE__, ret);
 		uart_unregister_driver(&grlib_apbuart_driver);
 		return ret;
@@ -697,7 +696,7 @@ static void __exit grlib_apbuart_exit(void)
 				     &grlib_apbuart_ports[i]);
 
 	uart_unregister_driver(&grlib_apbuart_driver);
-	of_unregister_platform_driver(&grlib_apbuart_of_driver);
+	platform_driver_unregister(&grlib_apbuart_of_driver);
 }
 
 module_init(grlib_apbuart_init);
diff --git a/drivers/tty/serial/cpm_uart/cpm_uart_core.c b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
index 8692ff9..a9a6a5f 100644
--- a/drivers/tty/serial/cpm_uart/cpm_uart_core.c
+++ b/drivers/tty/serial/cpm_uart/cpm_uart_core.c
@@ -1359,8 +1359,7 @@ static struct uart_driver cpm_reg = {
 
 static int probe_index;
 
-static int __devinit cpm_uart_probe(struct platform_device *ofdev,
-                                    const struct of_device_id *match)
+static int __devinit cpm_uart_probe(struct platform_device *ofdev)
 {
 	int index = probe_index++;
 	struct uart_cpm_port *pinfo = &cpm_uart_ports[index];
@@ -1405,7 +1404,7 @@ static struct of_device_id cpm_uart_match[] = {
 	{}
 };
 
-static struct of_platform_driver cpm_uart_driver = {
+static struct platform_driver cpm_uart_driver = {
 	.driver = {
 		.name = "cpm_uart",
 		.owner = THIS_MODULE,
@@ -1421,7 +1420,7 @@ static int __init cpm_uart_init(void)
 	if (ret)
 		return ret;
 
-	ret = of_register_platform_driver(&cpm_uart_driver);
+	ret = platform_driver_register(&cpm_uart_driver);
 	if (ret)
 		uart_unregister_driver(&cpm_reg);
 
@@ -1430,7 +1429,7 @@ static int __init cpm_uart_init(void)
 
 static void __exit cpm_uart_exit(void)
 {
-	of_unregister_platform_driver(&cpm_uart_driver);
+	platform_driver_unregister(&cpm_uart_driver);
 	uart_unregister_driver(&cpm_reg);
 }
 
diff --git a/drivers/tty/serial/mpc52xx_uart.c b/drivers/tty/serial/mpc52xx_uart.c
index 126ec7f..a0bcd8a 100644
--- a/drivers/tty/serial/mpc52xx_uart.c
+++ b/drivers/tty/serial/mpc52xx_uart.c
@@ -1302,8 +1302,7 @@ static struct of_device_id mpc52xx_uart_of_match[] = {
 	{},
 };
 
-static int __devinit
-mpc52xx_uart_of_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit mpc52xx_uart_of_probe(struct platform_device *op)
 {
 	int idx = -1;
 	unsigned int uartclk;
@@ -1311,8 +1310,6 @@ mpc52xx_uart_of_probe(struct platform_device *op, const struct of_device_id *mat
 	struct resource res;
 	int ret;
 
-	dev_dbg(&op->dev, "mpc52xx_uart_probe(op=%p, match=%p)\n", op, match);
-
 	/* Check validity & presence */
 	for (idx = 0; idx < MPC52xx_PSC_MAXNUM; idx++)
 		if (mpc52xx_uart_nodes[idx] == op->dev.of_node)
@@ -1453,7 +1450,7 @@ mpc52xx_uart_of_enumerate(void)
 
 MODULE_DEVICE_TABLE(of, mpc52xx_uart_of_match);
 
-static struct of_platform_driver mpc52xx_uart_of_driver = {
+static struct platform_driver mpc52xx_uart_of_driver = {
 	.probe		= mpc52xx_uart_of_probe,
 	.remove		= mpc52xx_uart_of_remove,
 #ifdef CONFIG_PM
@@ -1497,9 +1494,9 @@ mpc52xx_uart_init(void)
 			return ret;
 	}
 
-	ret = of_register_platform_driver(&mpc52xx_uart_of_driver);
+	ret = platform_driver_register(&mpc52xx_uart_of_driver);
 	if (ret) {
-		printk(KERN_ERR "%s: of_register_platform_driver failed (%i)\n",
+		printk(KERN_ERR "%s: platform_driver_register failed (%i)\n",
 		       __FILE__, ret);
 		uart_unregister_driver(&mpc52xx_uart_driver);
 		return ret;
@@ -1514,7 +1511,7 @@ mpc52xx_uart_exit(void)
 	if (psc_ops->fifoc_uninit)
 		psc_ops->fifoc_uninit();
 
-	of_unregister_platform_driver(&mpc52xx_uart_of_driver);
+	platform_driver_unregister(&mpc52xx_uart_of_driver);
 	uart_unregister_driver(&mpc52xx_uart_driver);
 }
 
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 5c7abe4..1a43197 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -80,14 +80,16 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 /*
  * Try to register a serial port
  */
-static int __devinit of_platform_serial_probe(struct platform_device *ofdev,
-						const struct of_device_id *id)
+static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 {
 	struct of_serial_info *info;
 	struct uart_port port;
 	int port_type;
 	int ret;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+
 	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
 		return -EBUSY;
 
@@ -95,7 +97,7 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev,
 	if (info == NULL)
 		return -ENOMEM;
 
-	port_type = (unsigned long)id->data;
+	port_type = (unsigned long)ofdev->dev.of_match->data;
 	ret = of_platform_serial_setup(ofdev, port_type, &port);
 	if (ret)
 		goto out;
@@ -174,7 +176,7 @@ static struct of_device_id __devinitdata of_platform_serial_table[] = {
 	{ /* end of list */ },
 };
 
-static struct of_platform_driver of_platform_serial_driver = {
+static struct platform_driver of_platform_serial_driver = {
 	.driver = {
 		.name = "of_serial",
 		.owner = THIS_MODULE,
@@ -186,13 +188,13 @@ static struct of_platform_driver of_platform_serial_driver = {
 
 static int __init of_platform_serial_init(void)
 {
-	return of_register_platform_driver(&of_platform_serial_driver);
+	return platform_driver_register(&of_platform_serial_driver);
 }
 module_init(of_platform_serial_init);
 
 static void __exit of_platform_serial_exit(void)
 {
-	return of_unregister_platform_driver(&of_platform_serial_driver);
+	return platform_driver_unregister(&of_platform_serial_driver);
 };
 module_exit(of_platform_serial_exit);
 
diff --git a/drivers/tty/serial/sunhv.c b/drivers/tty/serial/sunhv.c
index c901486..c0b7246 100644
--- a/drivers/tty/serial/sunhv.c
+++ b/drivers/tty/serial/sunhv.c
@@ -519,7 +519,7 @@ static struct console sunhv_console = {
 	.data	=	&sunhv_reg,
 };
 
-static int __devinit hv_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit hv_probe(struct platform_device *op)
 {
 	struct uart_port *port;
 	unsigned long minor;
@@ -629,7 +629,7 @@ static const struct of_device_id hv_match[] = {
 };
 MODULE_DEVICE_TABLE(of, hv_match);
 
-static struct of_platform_driver hv_driver = {
+static struct platform_driver hv_driver = {
 	.driver = {
 		.name = "hv",
 		.owner = THIS_MODULE,
@@ -644,12 +644,12 @@ static int __init sunhv_init(void)
 	if (tlb_type != hypervisor)
 		return -ENODEV;
 
-	return of_register_platform_driver(&hv_driver);
+	return platform_driver_register(&hv_driver);
 }
 
 static void __exit sunhv_exit(void)
 {
-	of_unregister_platform_driver(&hv_driver);
+	platform_driver_unregister(&hv_driver);
 }
 
 module_init(sunhv_init);
diff --git a/drivers/tty/serial/sunsab.c b/drivers/tty/serial/sunsab.c
index 5b246b1..b5fa2a5 100644
--- a/drivers/tty/serial/sunsab.c
+++ b/drivers/tty/serial/sunsab.c
@@ -1006,7 +1006,7 @@ static int __devinit sunsab_init_one(struct uart_sunsab_port *up,
 	return 0;
 }
 
-static int __devinit sab_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit sab_probe(struct platform_device *op)
 {
 	static int inst;
 	struct uart_sunsab_port *up;
@@ -1092,7 +1092,7 @@ static const struct of_device_id sab_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sab_match);
 
-static struct of_platform_driver sab_driver = {
+static struct platform_driver sab_driver = {
 	.driver = {
 		.name = "sab",
 		.owner = THIS_MODULE,
@@ -1130,12 +1130,12 @@ static int __init sunsab_init(void)
 		}
 	}
 
-	return of_register_platform_driver(&sab_driver);
+	return platform_driver_register(&sab_driver);
 }
 
 static void __exit sunsab_exit(void)
 {
-	of_unregister_platform_driver(&sab_driver);
+	platform_driver_unregister(&sab_driver);
 	if (sunsab_reg.nr) {
 		sunserial_unregister_minors(&sunsab_reg, sunsab_reg.nr);
 	}
diff --git a/drivers/tty/serial/sunsu.c b/drivers/tty/serial/sunsu.c
index 551ebfe..92aa545 100644
--- a/drivers/tty/serial/sunsu.c
+++ b/drivers/tty/serial/sunsu.c
@@ -1406,7 +1406,7 @@ static enum su_type __devinit su_get_type(struct device_node *dp)
 	return SU_PORT_PORT;
 }
 
-static int __devinit su_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit su_probe(struct platform_device *op)
 {
 	static int inst;
 	struct device_node *dp = op->dev.of_node;
@@ -1543,7 +1543,7 @@ static const struct of_device_id su_match[] = {
 };
 MODULE_DEVICE_TABLE(of, su_match);
 
-static struct of_platform_driver su_driver = {
+static struct platform_driver su_driver = {
 	.driver = {
 		.name = "su",
 		.owner = THIS_MODULE,
@@ -1586,7 +1586,7 @@ static int __init sunsu_init(void)
 			return err;
 	}
 
-	err = of_register_platform_driver(&su_driver);
+	err = platform_driver_register(&su_driver);
 	if (err && num_uart)
 		sunserial_unregister_minors(&sunsu_reg, num_uart);
 
diff --git a/drivers/tty/serial/sunzilog.c b/drivers/tty/serial/sunzilog.c
index c1967ac..99ff9ab 100644
--- a/drivers/tty/serial/sunzilog.c
+++ b/drivers/tty/serial/sunzilog.c
@@ -1399,7 +1399,7 @@ static void __devinit sunzilog_init_hw(struct uart_sunzilog_port *up)
 
 static int zilog_irq = -1;
 
-static int __devinit zs_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit zs_probe(struct platform_device *op)
 {
 	static int kbm_inst, uart_inst;
 	int inst;
@@ -1540,7 +1540,7 @@ static const struct of_device_id zs_match[] = {
 };
 MODULE_DEVICE_TABLE(of, zs_match);
 
-static struct of_platform_driver zs_driver = {
+static struct platform_driver zs_driver = {
 	.driver = {
 		.name = "zs",
 		.owner = THIS_MODULE,
@@ -1576,7 +1576,7 @@ static int __init sunzilog_init(void)
 			goto out_free_tables;
 	}
 
-	err = of_register_platform_driver(&zs_driver);
+	err = platform_driver_register(&zs_driver);
 	if (err)
 		goto out_unregister_uart;
 
@@ -1604,7 +1604,7 @@ out:
 	return err;
 
 out_unregister_driver:
-	of_unregister_platform_driver(&zs_driver);
+	platform_driver_unregister(&zs_driver);
 
 out_unregister_uart:
 	if (num_sunzilog) {
@@ -1619,7 +1619,7 @@ out_free_tables:
 
 static void __exit sunzilog_exit(void)
 {
-	of_unregister_platform_driver(&zs_driver);
+	platform_driver_unregister(&zs_driver);
 
 	if (zilog_irq != -1) {
 		struct uart_sunzilog_port *up = sunzilog_irq_chain;
diff --git a/drivers/tty/serial/ucc_uart.c b/drivers/tty/serial/ucc_uart.c
index 3f4848e..ff51dae 100644
--- a/drivers/tty/serial/ucc_uart.c
+++ b/drivers/tty/serial/ucc_uart.c
@@ -1194,8 +1194,7 @@ static void uart_firmware_cont(const struct firmware *fw, void *context)
 	release_firmware(fw);
 }
 
-static int ucc_uart_probe(struct platform_device *ofdev,
-	const struct of_device_id *match)
+static int ucc_uart_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	const unsigned int *iprop;      /* Integer OF properties */
@@ -1485,7 +1484,7 @@ static struct of_device_id ucc_uart_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ucc_uart_match);
 
-static struct of_platform_driver ucc_uart_of_driver = {
+static struct platform_driver ucc_uart_of_driver = {
 	.driver = {
 		.name = "ucc_uart",
 		.owner = THIS_MODULE,
@@ -1510,7 +1509,7 @@ static int __init ucc_uart_init(void)
 		return ret;
 	}
 
-	ret = of_register_platform_driver(&ucc_uart_of_driver);
+	ret = platform_driver_register(&ucc_uart_of_driver);
 	if (ret)
 		printk(KERN_ERR
 		       "ucc-uart: could not register platform driver\n");
@@ -1523,7 +1522,7 @@ static void __exit ucc_uart_exit(void)
 	printk(KERN_INFO
 	       "Freescale QUICC Engine UART device driver unloading\n");
 
-	of_unregister_platform_driver(&ucc_uart_of_driver);
+	platform_driver_unregister(&ucc_uart_of_driver);
 	uart_unregister_driver(&ucc_uart_driver);
 }
 

