Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab1BWEjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:39:22 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:55429 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110Ab1BWEjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:39:20 -0500
Subject: [RFC PATCH 03/15] dt/powerpc: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:33:50 -0700
Message-ID: <20110223043350.20795.78915.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of old users of of_platform_driver in arch/powerpc.  Most
of_platform_driver users can be converted to use the platform_bus
directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/of_platform.c             |    7 +++---
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c    |   14 ++++++-------
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |   10 +++------
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c |   11 ++++------
 arch/powerpc/platforms/82xx/ep8248e.c         |    7 +++---
 arch/powerpc/platforms/83xx/suspend.c         |   14 ++++++++-----
 arch/powerpc/platforms/cell/axon_msi.c        |   11 ++++------
 arch/powerpc/platforms/pasemi/gpio_mdio.c     |    9 ++++----
 arch/powerpc/sysdev/axonram.c                 |   11 +++++-----
 arch/powerpc/sysdev/bestcomm/bestcomm.c       |    9 ++++----
 arch/powerpc/sysdev/fsl_85xx_l2ctlr.c         |    9 ++++----
 arch/powerpc/sysdev/fsl_msi.c                 |   13 +++++++-----
 arch/powerpc/sysdev/fsl_pmc.c                 |    7 +++---
 arch/powerpc/sysdev/fsl_rio.c                 |    7 +++---
 arch/powerpc/sysdev/pmi.c                     |    9 ++++----
 arch/powerpc/sysdev/qe_lib/qe.c               |    7 +++---
 drivers/char/hw_random/pasemi-rng.c           |    9 ++++----
 drivers/crypto/amcc/crypto4xx_core.c          |    9 ++++----
 drivers/dma/fsldma.c                          |   14 +++----------
 drivers/dma/mpc512x_dma.c                     |    9 ++++----
 drivers/dma/ppc4xx/adma.c                     |   11 +++++-----
 drivers/edac/mpc85xx_edac.c                   |   27 +++++++++++--------------
 drivers/edac/ppc4xx_edac.c                    |   23 ++++++---------------
 drivers/macintosh/smu.c                       |    7 +++---
 drivers/macintosh/therm_pm72.c                |    8 ++++---
 drivers/macintosh/therm_windtunnel.c          |    9 ++++----
 26 files changed, 120 insertions(+), 161 deletions(-)

diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index 9bd951c..2458218 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -36,8 +36,7 @@
  * lacking some bits needed here.
  */
 
-static int __devinit of_pci_phb_probe(struct platform_device *dev,
-				      const struct of_device_id *match)
+static int __devinit of_pci_phb_probe(struct platform_device *dev)
 {
 	struct pci_controller *phb;
 
@@ -104,7 +103,7 @@ static struct of_device_id of_pci_phb_ids[] = {
 	{}
 };
 
-static struct of_platform_driver of_pci_phb_driver = {
+static struct platform_driver of_pci_phb_driver = {
 	.probe = of_pci_phb_probe,
 	.driver = {
 		.name = "of-pci",
@@ -115,7 +114,7 @@ static struct of_platform_driver of_pci_phb_driver = {
 
 static __init int of_pci_phb_init(void)
 {
-	return of_register_platform_driver(&of_pci_phb_driver);
+	return platform_driver_register(&of_pci_phb_driver);
 }
 
 device_initcall(of_pci_phb_init);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
index 0dad9a9..1757d1d 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
@@ -147,8 +147,7 @@ mpc52xx_wkup_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static int __devinit mpc52xx_wkup_gpiochip_probe(struct platform_device *ofdev,
-					const struct of_device_id *match)
+static int __devinit mpc52xx_wkup_gpiochip_probe(struct platform_device *ofdev)
 {
 	struct mpc52xx_gpiochip *chip;
 	struct mpc52xx_gpio_wkup __iomem *regs;
@@ -191,7 +190,7 @@ static const struct of_device_id mpc52xx_wkup_gpiochip_match[] = {
 	{}
 };
 
-static struct of_platform_driver mpc52xx_wkup_gpiochip_driver = {
+static struct platform_driver mpc52xx_wkup_gpiochip_driver = {
 	.driver = {
 		.name = "gpio_wkup",
 		.owner = THIS_MODULE,
@@ -310,8 +309,7 @@ mpc52xx_simple_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static int __devinit mpc52xx_simple_gpiochip_probe(struct platform_device *ofdev,
-					const struct of_device_id *match)
+static int __devinit mpc52xx_simple_gpiochip_probe(struct platform_device *ofdev)
 {
 	struct mpc52xx_gpiochip *chip;
 	struct gpio_chip *gc;
@@ -349,7 +347,7 @@ static const struct of_device_id mpc52xx_simple_gpiochip_match[] = {
 	{}
 };
 
-static struct of_platform_driver mpc52xx_simple_gpiochip_driver = {
+static struct platform_driver mpc52xx_simple_gpiochip_driver = {
 	.driver = {
 		.name = "gpio",
 		.owner = THIS_MODULE,
@@ -361,10 +359,10 @@ static struct of_platform_driver mpc52xx_simple_gpiochip_driver = {
 
 static int __init mpc52xx_gpio_init(void)
 {
-	if (of_register_platform_driver(&mpc52xx_wkup_gpiochip_driver))
+	if (platform_driver_register(&mpc52xx_wkup_gpiochip_driver))
 		printk(KERN_ERR "Unable to register wakeup GPIO driver\n");
 
-	if (of_register_platform_driver(&mpc52xx_simple_gpiochip_driver))
+	if (platform_driver_register(&mpc52xx_simple_gpiochip_driver))
 		printk(KERN_ERR "Unable to register simple GPIO driver\n");
 
 	return 0;
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index e0d703c..859abf1 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -721,8 +721,7 @@ static inline int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
 /* ---------------------------------------------------------------------
  * of_platform bus binding code
  */
-static int __devinit mpc52xx_gpt_probe(struct platform_device *ofdev,
-				       const struct of_device_id *match)
+static int __devinit mpc52xx_gpt_probe(struct platform_device *ofdev)
 {
 	struct mpc52xx_gpt_priv *gpt;
 
@@ -781,7 +780,7 @@ static const struct of_device_id mpc52xx_gpt_match[] = {
 	{}
 };
 
-static struct of_platform_driver mpc52xx_gpt_driver = {
+static struct platform_driver mpc52xx_gpt_driver = {
 	.driver = {
 		.name = "mpc52xx-gpt",
 		.owner = THIS_MODULE,
@@ -793,10 +792,7 @@ static struct of_platform_driver mpc52xx_gpt_driver = {
 
 static int __init mpc52xx_gpt_init(void)
 {
-	if (of_register_platform_driver(&mpc52xx_gpt_driver))
-		pr_err("error registering MPC52xx GPT driver\n");
-
-	return 0;
+	return platform_driver_register(&mpc52xx_gpt_driver);
 }
 
 /* Make sure GPIOs and IRQs get set up before anyone tries to use them */
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
index f4ac213..6385d88 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
@@ -436,8 +436,7 @@ void mpc52xx_lpbfifo_abort(struct mpc52xx_lpbfifo_request *req)
 }
 EXPORT_SYMBOL(mpc52xx_lpbfifo_abort);
 
-static int __devinit mpc52xx_lpbfifo_probe(struct platform_device *op,
-					   const struct of_device_id *match)
+static int __devinit mpc52xx_lpbfifo_probe(struct platform_device *op)
 {
 	struct resource res;
 	int rc = -ENOMEM;
@@ -536,7 +535,7 @@ static struct of_device_id mpc52xx_lpbfifo_match[] __devinitconst = {
 	{},
 };
 
-static struct of_platform_driver mpc52xx_lpbfifo_driver = {
+static struct platform_driver mpc52xx_lpbfifo_driver = {
 	.driver = {
 		.name = "mpc52xx-lpbfifo",
 		.owner = THIS_MODULE,
@@ -551,14 +550,12 @@ static struct of_platform_driver mpc52xx_lpbfifo_driver = {
  */
 static int __init mpc52xx_lpbfifo_init(void)
 {
-	pr_debug("Registering LocalPlus bus FIFO driver\n");
-	return of_register_platform_driver(&mpc52xx_lpbfifo_driver);
+	return platform_driver_register(&mpc52xx_lpbfifo_driver);
 }
 module_init(mpc52xx_lpbfifo_init);
 
 static void __exit mpc52xx_lpbfifo_exit(void)
 {
-	pr_debug("Unregistering LocalPlus bus FIFO driver\n");
-	of_unregister_platform_driver(&mpc52xx_lpbfifo_driver);
+	platform_driver_unregister(&mpc52xx_lpbfifo_driver);
 }
 module_exit(mpc52xx_lpbfifo_exit);
diff --git a/arch/powerpc/platforms/82xx/ep8248e.c b/arch/powerpc/platforms/82xx/ep8248e.c
index 1565e04..10ff526 100644
--- a/arch/powerpc/platforms/82xx/ep8248e.c
+++ b/arch/powerpc/platforms/82xx/ep8248e.c
@@ -111,8 +111,7 @@ static struct mdiobb_ctrl ep8248e_mdio_ctrl = {
 	.ops = &ep8248e_mdio_ops,
 };
 
-static int __devinit ep8248e_mdio_probe(struct platform_device *ofdev,
-                                        const struct of_device_id *match)
+static int __devinit ep8248e_mdio_probe(struct platform_device *ofdev)
 {
 	struct mii_bus *bus;
 	struct resource res;
@@ -167,7 +166,7 @@ static const struct of_device_id ep8248e_mdio_match[] = {
 	{},
 };
 
-static struct of_platform_driver ep8248e_mdio_driver = {
+static struct platform_driver ep8248e_mdio_driver = {
 	.driver = {
 		.name = "ep8248e-mdio-bitbang",
 		.owner = THIS_MODULE,
@@ -308,7 +307,7 @@ static  __initdata struct of_device_id of_bus_ids[] = {
 static int __init declare_of_platform_devices(void)
 {
 	of_platform_bus_probe(NULL, of_bus_ids, NULL);
-	of_register_platform_driver(&ep8248e_mdio_driver);
+	platform_driver_register(&ep8248e_mdio_driver);
 
 	return 0;
 }
diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index fd4f2f2..1882729 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -318,14 +318,18 @@ static const struct platform_suspend_ops mpc83xx_suspend_ops = {
 	.end = mpc83xx_suspend_end,
 };
 
-static int pmc_probe(struct platform_device *ofdev,
-                     const struct of_device_id *match)
+static int pmc_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct resource res;
-	struct pmc_type *type = match->data;
+	struct pmc_type *type;
 	int ret = 0;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+
+	type = ofdev->dev.of_match->data;
+
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
@@ -422,7 +426,7 @@ static struct of_device_id pmc_match[] = {
 	{}
 };
 
-static struct of_platform_driver pmc_driver = {
+static struct platform_driver pmc_driver = {
 	.driver = {
 		.name = "mpc83xx-pmc",
 		.owner = THIS_MODULE,
@@ -434,7 +438,7 @@ static struct of_platform_driver pmc_driver = {
 
 static int pmc_init(void)
 {
-	return of_register_platform_driver(&pmc_driver);
+	return platform_driver_register(&pmc_driver);
 }
 
 module_init(pmc_init);
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index e3e379c..c35099a 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -328,7 +328,7 @@ static struct irq_host_ops msic_host_ops = {
 	.map	= msic_host_map,
 };
 
-static int axon_msi_shutdown(struct platform_device *device)
+static void axon_msi_shutdown(struct platform_device *device)
 {
 	struct axon_msic *msic = dev_get_drvdata(&device->dev);
 	u32 tmp;
@@ -338,12 +338,9 @@ static int axon_msi_shutdown(struct platform_device *device)
 	tmp  = dcr_read(msic->dcr_host, MSIC_CTRL_REG);
 	tmp &= ~MSIC_CTRL_ENABLE & ~MSIC_CTRL_IRQ_ENABLE;
 	msic_dcr_write(msic, MSIC_CTRL_REG, tmp);
-
-	return 0;
 }
 
-static int axon_msi_probe(struct platform_device *device,
-			  const struct of_device_id *device_id)
+static int axon_msi_probe(struct platform_device *device)
 {
 	struct device_node *dn = device->dev.of_node;
 	struct axon_msic *msic;
@@ -446,7 +443,7 @@ static const struct of_device_id axon_msi_device_id[] = {
 	{}
 };
 
-static struct of_platform_driver axon_msi_driver = {
+static struct platform_driver axon_msi_driver = {
 	.probe		= axon_msi_probe,
 	.shutdown	= axon_msi_shutdown,
 	.driver = {
@@ -458,7 +455,7 @@ static struct of_platform_driver axon_msi_driver = {
 
 static int __init axon_msi_init(void)
 {
-	return of_register_platform_driver(&axon_msi_driver);
+	return platform_driver_register(&axon_msi_driver);
 }
 subsys_initcall(axon_msi_init);
 
diff --git a/arch/powerpc/platforms/pasemi/gpio_mdio.c b/arch/powerpc/platforms/pasemi/gpio_mdio.c
index a5d907b..9886296 100644
--- a/arch/powerpc/platforms/pasemi/gpio_mdio.c
+++ b/arch/powerpc/platforms/pasemi/gpio_mdio.c
@@ -216,8 +216,7 @@ static int gpio_mdio_reset(struct mii_bus *bus)
 }
 
 
-static int __devinit gpio_mdio_probe(struct platform_device *ofdev,
-				     const struct of_device_id *match)
+static int __devinit gpio_mdio_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
@@ -299,7 +298,7 @@ static struct of_device_id gpio_mdio_match[] =
 };
 MODULE_DEVICE_TABLE(of, gpio_mdio_match);
 
-static struct of_platform_driver gpio_mdio_driver =
+static struct platform_driver gpio_mdio_driver =
 {
 	.probe		= gpio_mdio_probe,
 	.remove		= gpio_mdio_remove,
@@ -326,13 +325,13 @@ int gpio_mdio_init(void)
 	if (!gpio_regs)
 		return -ENODEV;
 
-	return of_register_platform_driver(&gpio_mdio_driver);
+	return platform_driver_register(&gpio_mdio_driver);
 }
 module_init(gpio_mdio_init);
 
 void gpio_mdio_exit(void)
 {
-	of_unregister_platform_driver(&gpio_mdio_driver);
+	platform_driver_unregister(&gpio_mdio_driver);
 	if (gpio_regs)
 		iounmap(gpio_regs);
 }
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 2659a60..27402c7 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -172,10 +172,9 @@ static const struct block_device_operations axon_ram_devops = {
 
 /**
  * axon_ram_probe - probe() method for platform driver
- * @device, @device_id: see of_platform_driver method
+ * @device: see platform_driver method
  */
-static int axon_ram_probe(struct platform_device *device,
-			  const struct of_device_id *device_id)
+static int axon_ram_probe(struct platform_device *device)
 {
 	static int axon_ram_bank_id = -1;
 	struct axon_ram_bank *bank;
@@ -326,7 +325,7 @@ static struct of_device_id axon_ram_device_id[] = {
 	{}
 };
 
-static struct of_platform_driver axon_ram_driver = {
+static struct platform_driver axon_ram_driver = {
 	.probe		= axon_ram_probe,
 	.remove		= axon_ram_remove,
 	.driver = {
@@ -350,7 +349,7 @@ axon_ram_init(void)
 	}
 	azfs_minor = 0;
 
-	return of_register_platform_driver(&axon_ram_driver);
+	return platform_driver_register(&axon_ram_driver);
 }
 
 /**
@@ -359,7 +358,7 @@ axon_ram_init(void)
 static void __exit
 axon_ram_exit(void)
 {
-	of_unregister_platform_driver(&axon_ram_driver);
+	platform_driver_unregister(&axon_ram_driver);
 	unregister_blkdev(azfs_major, AXON_RAM_DEVICE_NAME);
 }
 
diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.c b/arch/powerpc/sysdev/bestcomm/bestcomm.c
index 6502561..b3fbb27 100644
--- a/arch/powerpc/sysdev/bestcomm/bestcomm.c
+++ b/arch/powerpc/sysdev/bestcomm/bestcomm.c
@@ -365,8 +365,7 @@ bcom_engine_cleanup(void)
 /* OF platform driver                                                       */
 /* ======================================================================== */
 
-static int __devinit mpc52xx_bcom_probe(struct platform_device *op,
-					const struct of_device_id *match)
+static int __devinit mpc52xx_bcom_probe(struct platform_device *op)
 {
 	struct device_node *ofn_sram;
 	struct resource res_bcom;
@@ -492,7 +491,7 @@ static struct of_device_id mpc52xx_bcom_of_match[] = {
 MODULE_DEVICE_TABLE(of, mpc52xx_bcom_of_match);
 
 
-static struct of_platform_driver mpc52xx_bcom_of_platform_driver = {
+static struct platform_driver mpc52xx_bcom_of_platform_driver = {
 	.probe		= mpc52xx_bcom_probe,
 	.remove		= mpc52xx_bcom_remove,
 	.driver = {
@@ -510,13 +509,13 @@ static struct of_platform_driver mpc52xx_bcom_of_platform_driver = {
 static int __init
 mpc52xx_bcom_init(void)
 {
-	return of_register_platform_driver(&mpc52xx_bcom_of_platform_driver);
+	return platform_driver_register(&mpc52xx_bcom_of_platform_driver);
 }
 
 static void __exit
 mpc52xx_bcom_exit(void)
 {
-	of_unregister_platform_driver(&mpc52xx_bcom_of_platform_driver);
+	platform_driver_unregister(&mpc52xx_bcom_of_platform_driver);
 }
 
 /* If we're not a module, we must make sure everything is setup before  */
diff --git a/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c b/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
index cc8d655..2b9f0c9 100644
--- a/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
+++ b/arch/powerpc/sysdev/fsl_85xx_l2ctlr.c
@@ -71,8 +71,7 @@ static int __init get_offset_from_cmdline(char *str)
 __setup("cache-sram-size=", get_size_from_cmdline);
 __setup("cache-sram-offset=", get_offset_from_cmdline);
 
-static int __devinit mpc85xx_l2ctlr_of_probe(struct platform_device *dev,
-					  const struct of_device_id *match)
+static int __devinit mpc85xx_l2ctlr_of_probe(struct platform_device *dev)
 {
 	long rval;
 	unsigned int rem;
@@ -204,7 +203,7 @@ static struct of_device_id mpc85xx_l2ctlr_of_match[] = {
 	{},
 };
 
-static struct of_platform_driver mpc85xx_l2ctlr_of_platform_driver = {
+static struct platform_driver mpc85xx_l2ctlr_of_platform_driver = {
 	.driver	= {
 		.name		= "fsl-l2ctlr",
 		.owner		= THIS_MODULE,
@@ -216,12 +215,12 @@ static struct of_platform_driver mpc85xx_l2ctlr_of_platform_driver = {
 
 static __init int mpc85xx_l2ctlr_of_init(void)
 {
-	return of_register_platform_driver(&mpc85xx_l2ctlr_of_platform_driver);
+	return platform_driver_register(&mpc85xx_l2ctlr_of_platform_driver);
 }
 
 static void __exit mpc85xx_l2ctlr_of_exit(void)
 {
-	of_unregister_platform_driver(&mpc85xx_l2ctlr_of_platform_driver);
+	platform_driver_unregister(&mpc85xx_l2ctlr_of_platform_driver);
 }
 
 subsys_initcall(mpc85xx_l2ctlr_of_init);
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 108d76f..ee6a8a5 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -273,8 +273,7 @@ static int fsl_of_msi_remove(struct platform_device *ofdev)
 	return 0;
 }
 
-static int __devinit fsl_of_msi_probe(struct platform_device *dev,
-				const struct of_device_id *match)
+static int __devinit fsl_of_msi_probe(struct platform_device *dev)
 {
 	struct fsl_msi *msi;
 	struct resource res;
@@ -282,11 +281,15 @@ static int __devinit fsl_of_msi_probe(struct platform_device *dev,
 	int rc;
 	int virt_msir;
 	const u32 *p;
-	struct fsl_msi_feature *features = match->data;
+	struct fsl_msi_feature *features;
 	struct fsl_msi_cascade_data *cascade_data = NULL;
 	int len;
 	u32 offset;
 
+	if (!dev->dev.of_match)
+		return -EINVAL;
+	features = dev->dev.of_match->data;
+
 	printk(KERN_DEBUG "Setting up Freescale MSI support\n");
 
 	msi = kzalloc(sizeof(struct fsl_msi), GFP_KERNEL);
@@ -411,7 +414,7 @@ static const struct of_device_id fsl_of_msi_ids[] = {
 	{}
 };
 
-static struct of_platform_driver fsl_of_msi_driver = {
+static struct platform_driver fsl_of_msi_driver = {
 	.driver = {
 		.name = "fsl-msi",
 		.owner = THIS_MODULE,
@@ -423,7 +426,7 @@ static struct of_platform_driver fsl_of_msi_driver = {
 
 static __init int fsl_of_msi_init(void)
 {
-	return of_register_platform_driver(&fsl_of_msi_driver);
+	return platform_driver_register(&fsl_of_msi_driver);
 }
 
 subsys_initcall(fsl_of_msi_init);
diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
index e9381bf..f122e89 100644
--- a/arch/powerpc/sysdev/fsl_pmc.c
+++ b/arch/powerpc/sysdev/fsl_pmc.c
@@ -58,8 +58,7 @@ static const struct platform_suspend_ops pmc_suspend_ops = {
 	.enter = pmc_suspend_enter,
 };
 
-static int pmc_probe(struct platform_device *ofdev,
-		     const struct of_device_id *id)
+static int pmc_probe(struct platform_device *ofdev)
 {
 	pmc_regs = of_iomap(ofdev->dev.of_node, 0);
 	if (!pmc_regs)
@@ -76,7 +75,7 @@ static const struct of_device_id pmc_ids[] = {
 	{ },
 };
 
-static struct of_platform_driver pmc_driver = {
+static struct platform_driver pmc_driver = {
 	.driver = {
 		.name = "fsl-pmc",
 		.owner = THIS_MODULE,
@@ -87,6 +86,6 @@ static struct of_platform_driver pmc_driver = {
 
 static int __init pmc_init(void)
 {
-	return of_register_platform_driver(&pmc_driver);
+	return platform_driver_register(&pmc_driver);
 }
 device_initcall(pmc_init);
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 8c6cab0..3eff2c3 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1570,8 +1570,7 @@ err_ops:
 
 /* The probe function for RapidIO peer-to-peer network.
  */
-static int __devinit fsl_of_rio_rpn_probe(struct platform_device *dev,
-				     const struct of_device_id *match)
+static int __devinit fsl_of_rio_rpn_probe(struct platform_device *dev)
 {
 	int rc;
 	printk(KERN_INFO "Setting up RapidIO peer-to-peer network %s\n",
@@ -1594,7 +1593,7 @@ static const struct of_device_id fsl_of_rio_rpn_ids[] = {
 	{},
 };
 
-static struct of_platform_driver fsl_of_rio_rpn_driver = {
+static struct platform_driver fsl_of_rio_rpn_driver = {
 	.driver = {
 		.name = "fsl-of-rio",
 		.owner = THIS_MODULE,
@@ -1605,7 +1604,7 @@ static struct of_platform_driver fsl_of_rio_rpn_driver = {
 
 static __init int fsl_of_rio_rpn_init(void)
 {
-	return of_register_platform_driver(&fsl_of_rio_rpn_driver);
+	return platform_driver_register(&fsl_of_rio_rpn_driver);
 }
 
 subsys_initcall(fsl_of_rio_rpn_init);
diff --git a/arch/powerpc/sysdev/pmi.c b/arch/powerpc/sysdev/pmi.c
index 4260f36..8ce4fc3 100644
--- a/arch/powerpc/sysdev/pmi.c
+++ b/arch/powerpc/sysdev/pmi.c
@@ -121,8 +121,7 @@ static void pmi_notify_handlers(struct work_struct *work)
 	spin_unlock(&data->handler_spinlock);
 }
 
-static int pmi_of_probe(struct platform_device *dev,
-			const struct of_device_id *match)
+static int pmi_of_probe(struct platform_device *dev)
 {
 	struct device_node *np = dev->dev.of_node;
 	int rc;
@@ -205,7 +204,7 @@ static int pmi_of_remove(struct platform_device *dev)
 	return 0;
 }
 
-static struct of_platform_driver pmi_of_platform_driver = {
+static struct platform_driver pmi_of_platform_driver = {
 	.probe		= pmi_of_probe,
 	.remove		= pmi_of_remove,
 	.driver = {
@@ -217,13 +216,13 @@ static struct of_platform_driver pmi_of_platform_driver = {
 
 static int __init pmi_module_init(void)
 {
-	return of_register_platform_driver(&pmi_of_platform_driver);
+	return platform_driver_register(&pmi_of_platform_driver);
 }
 module_init(pmi_module_init);
 
 static void __exit pmi_module_exit(void)
 {
-	of_unregister_platform_driver(&pmi_of_platform_driver);
+	platform_driver_unregister(&pmi_of_platform_driver);
 }
 module_exit(pmi_module_exit);
 
diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
index 90020de..904c6cb 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/arch/powerpc/sysdev/qe_lib/qe.c
@@ -659,8 +659,7 @@ static int qe_resume(struct platform_device *ofdev)
 	return 0;
 }
 
-static int qe_probe(struct platform_device *ofdev,
-		    const struct of_device_id *id)
+static int qe_probe(struct platform_device *ofdev)
 {
 	return 0;
 }
@@ -670,7 +669,7 @@ static const struct of_device_id qe_ids[] = {
 	{ },
 };
 
-static struct of_platform_driver qe_driver = {
+static struct platform_driver qe_driver = {
 	.driver = {
 		.name = "fsl-qe",
 		.owner = THIS_MODULE,
@@ -682,7 +681,7 @@ static struct of_platform_driver qe_driver = {
 
 static int __init qe_drv_init(void)
 {
-	return of_register_platform_driver(&qe_driver);
+	return platform_driver_register(&qe_driver);
 }
 device_initcall(qe_drv_init);
 #endif /* defined(CONFIG_SUSPEND) && defined(CONFIG_PPC_85xx) */
diff --git a/drivers/char/hw_random/pasemi-rng.c b/drivers/char/hw_random/pasemi-rng.c
index a31c830..1d50481 100644
--- a/drivers/char/hw_random/pasemi-rng.c
+++ b/drivers/char/hw_random/pasemi-rng.c
@@ -94,8 +94,7 @@ static struct hwrng pasemi_rng = {
 	.data_read	= pasemi_rng_data_read,
 };
 
-static int __devinit rng_probe(struct platform_device *ofdev,
-			       const struct of_device_id *match)
+static int __devinit rng_probe(struct platform_device *ofdev)
 {
 	void __iomem *rng_regs;
 	struct device_node *rng_np = ofdev->dev.of_node;
@@ -139,7 +138,7 @@ static struct of_device_id rng_match[] = {
 	{ },
 };
 
-static struct of_platform_driver rng_driver = {
+static struct platform_driver rng_driver = {
 	.driver = {
 		.name = "pasemi-rng",
 		.owner = THIS_MODULE,
@@ -151,13 +150,13 @@ static struct of_platform_driver rng_driver = {
 
 static int __init rng_init(void)
 {
-	return of_register_platform_driver(&rng_driver);
+	return platform_driver_register(&rng_driver);
 }
 module_init(rng_init);
 
 static void __exit rng_exit(void)
 {
-	of_unregister_platform_driver(&rng_driver);
+	platform_driver_unregister(&rng_driver);
 }
 module_exit(rng_exit);
 
diff --git a/drivers/crypto/amcc/crypto4xx_core.c b/drivers/crypto/amcc/crypto4xx_core.c
index 2b1baee..1891252 100644
--- a/drivers/crypto/amcc/crypto4xx_core.c
+++ b/drivers/crypto/amcc/crypto4xx_core.c
@@ -1150,8 +1150,7 @@ struct crypto4xx_alg_common crypto4xx_alg[] = {
 /**
  * Module Initialization Routine
  */
-static int __init crypto4xx_probe(struct platform_device *ofdev,
-				  const struct of_device_id *match)
+static int __init crypto4xx_probe(struct platform_device *ofdev)
 {
 	int rc;
 	struct resource res;
@@ -1280,7 +1279,7 @@ static const struct of_device_id crypto4xx_match[] = {
 	{ },
 };
 
-static struct of_platform_driver crypto4xx_driver = {
+static struct platform_driver crypto4xx_driver = {
 	.driver = {
 		.name = "crypto4xx",
 		.owner = THIS_MODULE,
@@ -1292,12 +1291,12 @@ static struct of_platform_driver crypto4xx_driver = {
 
 static int __init crypto4xx_init(void)
 {
-	return of_register_platform_driver(&crypto4xx_driver);
+	return platform_driver_register(&crypto4xx_driver);
 }
 
 static void __exit crypto4xx_exit(void)
 {
-	of_unregister_platform_driver(&crypto4xx_driver);
+	platform_driver_unregister(&crypto4xx_driver);
 }
 
 module_init(crypto4xx_init);
diff --git a/drivers/dma/fsldma.c b/drivers/dma/fsldma.c
index 4de947a..e3854a8 100644
--- a/drivers/dma/fsldma.c
+++ b/drivers/dma/fsldma.c
@@ -1281,8 +1281,7 @@ static void fsl_dma_chan_remove(struct fsldma_chan *chan)
 	kfree(chan);
 }
 
-static int __devinit fsldma_of_probe(struct platform_device *op,
-			const struct of_device_id *match)
+static int __devinit fsldma_of_probe(struct platform_device *op)
 {
 	struct fsldma_device *fdev;
 	struct device_node *child;
@@ -1414,20 +1413,13 @@ static struct of_platform_driver fsldma_of_driver = {
 
 static __init int fsldma_init(void)
 {
-	int ret;
-
 	pr_info("Freescale Elo / Elo Plus DMA driver\n");
-
-	ret = of_register_platform_driver(&fsldma_of_driver);
-	if (ret)
-		pr_err("fsldma: failed to register platform driver\n");
-
-	return ret;
+	return platform_driver_register(&fsldma_of_driver);
 }
 
 static void __exit fsldma_exit(void)
 {
-	of_unregister_platform_driver(&fsldma_of_driver);
+	platform_driver_unregister(&fsldma_of_driver);
 }
 
 subsys_initcall(fsldma_init);
diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 59c2701..4f95d31 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -649,8 +649,7 @@ mpc_dma_prep_memcpy(struct dma_chan *chan, dma_addr_t dst, dma_addr_t src,
 	return &mdesc->desc;
 }
 
-static int __devinit mpc_dma_probe(struct platform_device *op,
-					const struct of_device_id *match)
+static int __devinit mpc_dma_probe(struct platform_device *op)
 {
 	struct device_node *dn = op->dev.of_node;
 	struct device *dev = &op->dev;
@@ -827,7 +826,7 @@ static struct of_device_id mpc_dma_match[] = {
 	{},
 };
 
-static struct of_platform_driver mpc_dma_driver = {
+static struct platform_driver mpc_dma_driver = {
 	.probe		= mpc_dma_probe,
 	.remove		= __devexit_p(mpc_dma_remove),
 	.driver = {
@@ -839,13 +838,13 @@ static struct of_platform_driver mpc_dma_driver = {
 
 static int __init mpc_dma_init(void)
 {
-	return of_register_platform_driver(&mpc_dma_driver);
+	return platform_driver_register(&mpc_dma_driver);
 }
 module_init(mpc_dma_init);
 
 static void __exit mpc_dma_exit(void)
 {
-	of_unregister_platform_driver(&mpc_dma_driver);
+	platform_driver_unregister(&mpc_dma_driver);
 }
 module_exit(mpc_dma_exit);
 
diff --git a/drivers/dma/ppc4xx/adma.c b/drivers/dma/ppc4xx/adma.c
index cef5845..3b0247e 100644
--- a/drivers/dma/ppc4xx/adma.c
+++ b/drivers/dma/ppc4xx/adma.c
@@ -4393,8 +4393,7 @@ static void ppc440spe_adma_release_irqs(struct ppc440spe_adma_device *adev,
 /**
  * ppc440spe_adma_probe - probe the asynch device
  */
-static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev,
-					  const struct of_device_id *match)
+static int __devinit ppc440spe_adma_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct resource res;
@@ -4944,7 +4943,7 @@ static const struct of_device_id ppc440spe_adma_of_match[] __devinitconst = {
 };
 MODULE_DEVICE_TABLE(of, ppc440spe_adma_of_match);
 
-static struct of_platform_driver ppc440spe_adma_driver = {
+static struct platform_driver ppc440spe_adma_driver = {
 	.probe = ppc440spe_adma_probe,
 	.remove = __devexit_p(ppc440spe_adma_remove),
 	.driver = {
@@ -4962,7 +4961,7 @@ static __init int ppc440spe_adma_init(void)
 	if (ret)
 		return ret;
 
-	ret = of_register_platform_driver(&ppc440spe_adma_driver);
+	ret = platform_driver_register(&ppc440spe_adma_driver);
 	if (ret) {
 		pr_err("%s: failed to register platform driver\n",
 			__func__);
@@ -4996,7 +4995,7 @@ out_dev:
 	/* User will not be able to enable h/w RAID-6 */
 	pr_err("%s: failed to create RAID-6 driver interface\n",
 		__func__);
-	of_unregister_platform_driver(&ppc440spe_adma_driver);
+	platform_driver_unregister(&ppc440spe_adma_driver);
 out_reg:
 	dcr_unmap(ppc440spe_mq_dcr_host, ppc440spe_mq_dcr_len);
 	kfree(ppc440spe_dma_fifo_buf);
@@ -5011,7 +5010,7 @@ static void __exit ppc440spe_adma_exit(void)
 			   &driver_attr_enable);
 	driver_remove_file(&ppc440spe_adma_driver.driver,
 			   &driver_attr_devices);
-	of_unregister_platform_driver(&ppc440spe_adma_driver);
+	platform_driver_unregister(&ppc440spe_adma_driver);
 	dcr_unmap(ppc440spe_mq_dcr_host, ppc440spe_mq_dcr_len);
 	kfree(ppc440spe_dma_fifo_buf);
 }
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index b123bb3..ffb5ad0 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -200,8 +200,7 @@ static irqreturn_t mpc85xx_pci_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __devinit mpc85xx_pci_err_probe(struct platform_device *op,
-					   const struct of_device_id *match)
+static int __devinit mpc85xx_pci_err_probe(struct platform_device *op)
 {
 	struct edac_pci_ctl_info *pci;
 	struct mpc85xx_pci_pdata *pdata;
@@ -338,7 +337,7 @@ static struct of_device_id mpc85xx_pci_err_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mpc85xx_pci_err_of_match);
 
-static struct of_platform_driver mpc85xx_pci_err_driver = {
+static struct platform_driver mpc85xx_pci_err_driver = {
 	.probe = mpc85xx_pci_err_probe,
 	.remove = __devexit_p(mpc85xx_pci_err_remove),
 	.driver = {
@@ -503,8 +502,7 @@ static irqreturn_t mpc85xx_l2_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-static int __devinit mpc85xx_l2_err_probe(struct platform_device *op,
-					  const struct of_device_id *match)
+static int __devinit mpc85xx_l2_err_probe(struct platform_device *op)
 {
 	struct edac_device_ctl_info *edac_dev;
 	struct mpc85xx_l2_pdata *pdata;
@@ -656,7 +654,7 @@ static struct of_device_id mpc85xx_l2_err_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mpc85xx_l2_err_of_match);
 
-static struct of_platform_driver mpc85xx_l2_err_driver = {
+static struct platform_driver mpc85xx_l2_err_driver = {
 	.probe = mpc85xx_l2_err_probe,
 	.remove = mpc85xx_l2_err_remove,
 	.driver = {
@@ -956,8 +954,7 @@ static void __devinit mpc85xx_init_csrows(struct mem_ctl_info *mci)
 	}
 }
 
-static int __devinit mpc85xx_mc_err_probe(struct platform_device *op,
-					  const struct of_device_id *match)
+static int __devinit mpc85xx_mc_err_probe(struct platform_device *op)
 {
 	struct mem_ctl_info *mci;
 	struct mpc85xx_mc_pdata *pdata;
@@ -1136,7 +1133,7 @@ static struct of_device_id mpc85xx_mc_err_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mpc85xx_mc_err_of_match);
 
-static struct of_platform_driver mpc85xx_mc_err_driver = {
+static struct platform_driver mpc85xx_mc_err_driver = {
 	.probe = mpc85xx_mc_err_probe,
 	.remove = mpc85xx_mc_err_remove,
 	.driver = {
@@ -1171,16 +1168,16 @@ static int __init mpc85xx_mc_init(void)
 		break;
 	}
 
-	res = of_register_platform_driver(&mpc85xx_mc_err_driver);
+	res = platform_driver_register(&mpc85xx_mc_err_driver);
 	if (res)
 		printk(KERN_WARNING EDAC_MOD_STR "MC fails to register\n");
 
-	res = of_register_platform_driver(&mpc85xx_l2_err_driver);
+	res = platform_driver_register(&mpc85xx_l2_err_driver);
 	if (res)
 		printk(KERN_WARNING EDAC_MOD_STR "L2 fails to register\n");
 
 #ifdef CONFIG_PCI
-	res = of_register_platform_driver(&mpc85xx_pci_err_driver);
+	res = platform_driver_register(&mpc85xx_pci_err_driver);
 	if (res)
 		printk(KERN_WARNING EDAC_MOD_STR "PCI fails to register\n");
 #endif
@@ -1212,10 +1209,10 @@ static void __exit mpc85xx_mc_exit(void)
 	on_each_cpu(mpc85xx_mc_restore_hid1, NULL, 0);
 #endif
 #ifdef CONFIG_PCI
-	of_unregister_platform_driver(&mpc85xx_pci_err_driver);
+	platform_driver_unregister(&mpc85xx_pci_err_driver);
 #endif
-	of_unregister_platform_driver(&mpc85xx_l2_err_driver);
-	of_unregister_platform_driver(&mpc85xx_mc_err_driver);
+	platform_driver_unregister(&mpc85xx_l2_err_driver);
+	platform_driver_unregister(&mpc85xx_mc_err_driver);
 }
 
 module_exit(mpc85xx_mc_exit);
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index b9f0c20..c1f0045 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -184,8 +184,7 @@ struct ppc4xx_ecc_status {
 
 /* Function Prototypes */
 
-static int ppc4xx_edac_probe(struct platform_device *device,
-			     const struct of_device_id *device_id);
+static int ppc4xx_edac_probe(struct platform_device *device)
 static int ppc4xx_edac_remove(struct platform_device *device);
 
 /* Global Variables */
@@ -201,7 +200,7 @@ static struct of_device_id ppc4xx_edac_match[] = {
 	{ }
 };
 
-static struct of_platform_driver ppc4xx_edac_driver = {
+static struct platform_driver ppc4xx_edac_driver = {
 	.probe			= ppc4xx_edac_probe,
 	.remove			= ppc4xx_edac_remove,
 	.driver = {
@@ -997,9 +996,6 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
  *       initialized.
  * @op: A pointer to the OpenFirmware device tree node associated
  *      with the controller this EDAC instance is bound to.
- * @match: A pointer to the OpenFirmware device tree match
- *         information associated with the controller this EDAC instance
- *         is bound to.
  * @dcr_host: A pointer to the DCR data containing the DCR mapping
  *            for this controller instance.
  * @mcopt1: The 32-bit Memory Controller Option 1 register value
@@ -1015,7 +1011,6 @@ ppc4xx_edac_init_csrows(struct mem_ctl_info *mci, u32 mcopt1)
 static int __devinit
 ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
 		    struct platform_device *op,
-		    const struct of_device_id *match,
 		    const dcr_host_t *dcr_host,
 		    u32 mcopt1)
 {
@@ -1024,7 +1019,7 @@ ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
 	struct ppc4xx_edac_pdata *pdata = NULL;
 	const struct device_node *np = op->dev.of_node;
 
-	if (match == NULL)
+	if (op->dev.of_match == NULL)
 		return -EINVAL;
 
 	/* Initial driver pointers and private data */
@@ -1227,9 +1222,6 @@ ppc4xx_edac_map_dcrs(const struct device_node *np, dcr_host_t *dcr_host)
  * ppc4xx_edac_probe - check controller and bind driver
  * @op: A pointer to the OpenFirmware device tree node associated
  *      with the controller being probed for driver binding.
- * @match: A pointer to the OpenFirmware device tree match
- *         information associated with the controller being probed
- *         for driver binding.
  *
  * This routine probes a specific ibm,sdram-4xx-ddr2 controller
  * instance for binding with the driver.
@@ -1237,8 +1229,7 @@ ppc4xx_edac_map_dcrs(const struct device_node *np, dcr_host_t *dcr_host)
  * Returns 0 if the controller instance was successfully bound to the
  * driver; otherwise, < 0 on error.
  */
-static int __devinit
-ppc4xx_edac_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit ppc4xx_edac_probe(struct platform_device *op)
 {
 	int status = 0;
 	u32 mcopt1, memcheck;
@@ -1304,7 +1295,7 @@ ppc4xx_edac_probe(struct platform_device *op, const struct of_device_id *match)
 		goto done;
 	}
 
-	status = ppc4xx_edac_mc_init(mci, op, match, &dcr_host, mcopt1);
+	status = ppc4xx_edac_mc_init(mci, op, &dcr_host, mcopt1);
 
 	if (status) {
 		ppc4xx_edac_mc_printk(KERN_ERR, mci,
@@ -1421,7 +1412,7 @@ ppc4xx_edac_init(void)
 
 	ppc4xx_edac_opstate_init();
 
-	return of_register_platform_driver(&ppc4xx_edac_driver);
+	return platform_driver_register(&ppc4xx_edac_driver);
 }
 
 /**
@@ -1434,7 +1425,7 @@ ppc4xx_edac_init(void)
 static void __exit
 ppc4xx_edac_exit(void)
 {
-	of_unregister_platform_driver(&ppc4xx_edac_driver);
+	platform_driver_unregister(&ppc4xx_edac_driver);
 }
 
 module_init(ppc4xx_edac_init);
diff --git a/drivers/macintosh/smu.c b/drivers/macintosh/smu.c
index 290cb32..116a49c 100644
--- a/drivers/macintosh/smu.c
+++ b/drivers/macintosh/smu.c
@@ -645,8 +645,7 @@ static void smu_expose_childs(struct work_struct *unused)
 
 static DECLARE_WORK(smu_expose_childs_work, smu_expose_childs);
 
-static int smu_platform_probe(struct platform_device* dev,
-			      const struct of_device_id *match)
+static int smu_platform_probe(struct platform_device* dev)
 {
 	if (!smu)
 		return -ENODEV;
@@ -669,7 +668,7 @@ static const struct of_device_id smu_platform_match[] =
 	{},
 };
 
-static struct of_platform_driver smu_of_platform_driver =
+static struct platform_driver smu_of_platform_driver =
 {
 	.driver = {
 		.name = "smu",
@@ -689,7 +688,7 @@ static int __init smu_init_sysfs(void)
 	 * I'm a bit too far from figuring out how that works with those
 	 * new chipsets, but that will come back and bite us
 	 */
-	of_register_platform_driver(&smu_of_platform_driver);
+	platform_driver_register(&smu_of_platform_driver);
 	return 0;
 }
 
diff --git a/drivers/macintosh/therm_pm72.c b/drivers/macintosh/therm_pm72.c
index f3a29f2..bca2af2 100644
--- a/drivers/macintosh/therm_pm72.c
+++ b/drivers/macintosh/therm_pm72.c
@@ -2210,7 +2210,7 @@ static void fcu_lookup_fans(struct device_node *fcu_node)
 	}
 }
 
-static int fcu_of_probe(struct platform_device* dev, const struct of_device_id *match)
+static int fcu_of_probe(struct platform_device* dev)
 {
 	state = state_detached;
 	of_dev = dev;
@@ -2240,7 +2240,7 @@ static const struct of_device_id fcu_match[] =
 };
 MODULE_DEVICE_TABLE(of, fcu_match);
 
-static struct of_platform_driver fcu_of_platform_driver = 
+static struct platform_driver fcu_of_platform_driver = 
 {
 	.driver = {
 		.name = "temperature",
@@ -2263,12 +2263,12 @@ static int __init therm_pm72_init(void)
 	    !rackmac)
 	    	return -ENODEV;
 
-	return of_register_platform_driver(&fcu_of_platform_driver);
+	return platform_driver_register(&fcu_of_platform_driver);
 }
 
 static void __exit therm_pm72_exit(void)
 {
-	of_unregister_platform_driver(&fcu_of_platform_driver);
+	platform_driver_unregister(&fcu_of_platform_driver);
 }
 
 module_init(therm_pm72_init);
diff --git a/drivers/macintosh/therm_windtunnel.c b/drivers/macintosh/therm_windtunnel.c
index c89f396..d37819f 100644
--- a/drivers/macintosh/therm_windtunnel.c
+++ b/drivers/macintosh/therm_windtunnel.c
@@ -443,8 +443,7 @@ static struct i2c_driver g4fan_driver = {
 /*	initialization / cleanup					*/
 /************************************************************************/
 
-static int
-therm_of_probe( struct platform_device *dev, const struct of_device_id *match )
+static int therm_of_probe(struct platform_device *dev)
 {
 	return i2c_add_driver( &g4fan_driver );
 }
@@ -462,7 +461,7 @@ static const struct of_device_id therm_of_match[] = {{
     }, {}
 };
 
-static struct of_platform_driver therm_of_driver = {
+static struct platform_driver therm_of_driver = {
 	.driver = {
 		.name = "temperature",
 		.owner = THIS_MODULE,
@@ -509,14 +508,14 @@ g4fan_init( void )
 		return -ENODEV;
 	}
 
-	of_register_platform_driver( &therm_of_driver );
+	platform_driver_register( &therm_of_driver );
 	return 0;
 }
 
 static void __exit
 g4fan_exit( void )
 {
-	of_unregister_platform_driver( &therm_of_driver );
+	platform_driver_unregister( &therm_of_driver );
 
 	if( x.of_dev )
 		of_device_unregister( x.of_dev );

