Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760065Ab0GVWa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 18:30:27 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:38066 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759973Ab0GVWaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 18:30:18 -0400
Subject: [PATCH 2/4] powerpc: remove references to of_device and to_of_device
To: sfr@canb.auug.org.au, monstr@monstr.eu, microblaze-uclinux@itee.uq.edu.au,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, benh@kernel.crashing.org,
        sparclinux@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Jul 2010 16:30:11 -0600
Message-ID: <20100722223011.21557.77496.stgit@angua>
In-Reply-To: <20100722222600.21557.34167.stgit@angua>
References: <20100722222600.21557.34167.stgit@angua>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_device is just a #define alias to platform_device.  This patch
replaces all references to it with platform_device.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/kernel/ibmebus.c                 |    8 ++++----
 arch/powerpc/kernel/of_platform.c             |    8 ++++----
 arch/powerpc/platforms/512x/clock.c           |    2 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c    |    6 +++---
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c     |    4 ++--
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c |    6 +++---
 arch/powerpc/platforms/82xx/ep8248e.c         |    4 ++--
 arch/powerpc/platforms/83xx/suspend.c         |    6 +++---
 arch/powerpc/platforms/cell/axon_msi.c        |    4 ++--
 arch/powerpc/platforms/pasemi/gpio_mdio.c     |    4 ++--
 arch/powerpc/sysdev/axonram.c                 |   12 ++++++------
 arch/powerpc/sysdev/bestcomm/bestcomm.c       |    7 +++----
 arch/powerpc/sysdev/fsl_msi.c                 |    4 ++--
 arch/powerpc/sysdev/fsl_pmc.c                 |    3 ++-
 arch/powerpc/sysdev/fsl_rio.c                 |    4 ++--
 arch/powerpc/sysdev/pmi.c                     |    6 +++---
 arch/powerpc/sysdev/qe_lib/qe.c               |    5 +++--
 17 files changed, 47 insertions(+), 46 deletions(-)

diff --git a/arch/powerpc/kernel/ibmebus.c b/arch/powerpc/kernel/ibmebus.c
index 21266ab..9b626cf 100644
--- a/arch/powerpc/kernel/ibmebus.c
+++ b/arch/powerpc/kernel/ibmebus.c
@@ -140,19 +140,19 @@ static struct dma_map_ops ibmebus_dma_ops = {
 
 static int ibmebus_match_path(struct device *dev, void *data)
 {
-	struct device_node *dn = to_of_device(dev)->dev.of_node;
+	struct device_node *dn = to_platform_device(dev)->dev.of_node;
 	return (dn->full_name &&
 		(strcasecmp((char *)data, dn->full_name) == 0));
 }
 
 static int ibmebus_match_node(struct device *dev, void *data)
 {
-	return to_of_device(dev)->dev.of_node == data;
+	return to_platform_device(dev)->dev.of_node == data;
 }
 
 static int ibmebus_create_device(struct device_node *dn)
 {
-	struct of_device *dev;
+	struct platform_device *dev;
 	int ret;
 
 	dev = of_device_alloc(dn, NULL, &ibmebus_bus_device);
@@ -298,7 +298,7 @@ static ssize_t ibmebus_store_remove(struct bus_type *bus,
 
 	if ((dev = bus_find_device(&ibmebus_bus_type, NULL, path,
 				   ibmebus_match_path))) {
-		of_device_unregister(to_of_device(dev));
+		of_device_unregister(to_platform_device(dev));
 
 		kfree(path);
 		return count;
diff --git a/arch/powerpc/kernel/of_platform.c b/arch/powerpc/kernel/of_platform.c
index b093d4b..84439d1 100644
--- a/arch/powerpc/kernel/of_platform.c
+++ b/arch/powerpc/kernel/of_platform.c
@@ -54,16 +54,16 @@ const struct of_device_id of_default_bus_ids[] = {
 
 static int of_dev_node_match(struct device *dev, void *data)
 {
-	return to_of_device(dev)->dev.of_node == data;
+	return to_platform_device(dev)->dev.of_node == data;
 }
 
-struct of_device *of_find_device_by_node(struct device_node *np)
+struct platform_device *of_find_device_by_node(struct device_node *np)
 {
 	struct device *dev;
 
 	dev = bus_find_device(&platform_bus_type, NULL, np, of_dev_node_match);
 	if (dev)
-		return to_of_device(dev);
+		return to_platform_device(dev);
 	return NULL;
 }
 EXPORT_SYMBOL(of_find_device_by_node);
@@ -76,7 +76,7 @@ EXPORT_SYMBOL(of_find_device_by_node);
  * lacking some bits needed here.
  */
 
-static int __devinit of_pci_phb_probe(struct of_device *dev,
+static int __devinit of_pci_phb_probe(struct platform_device *dev,
 				      const struct of_device_id *match)
 {
 	struct pci_controller *phb;
diff --git a/arch/powerpc/platforms/512x/clock.c b/arch/powerpc/platforms/512x/clock.c
index 4c42246..65e2d67 100644
--- a/arch/powerpc/platforms/512x/clock.c
+++ b/arch/powerpc/platforms/512x/clock.c
@@ -660,7 +660,7 @@ static void psc_clks_init(void)
 {
 	struct device_node *np;
 	const u32 *cell_index;
-	struct of_device *ofdev;
+	struct platform_device *ofdev;
 
 	for_each_compatible_node(np, NULL, "fsl,mpc5121-psc") {
 		cell_index = of_get_property(np, "cell-index", NULL);
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
index 0855e80..0dad9a9 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpio.c
@@ -147,7 +147,7 @@ mpc52xx_wkup_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static int __devinit mpc52xx_wkup_gpiochip_probe(struct of_device *ofdev,
+static int __devinit mpc52xx_wkup_gpiochip_probe(struct platform_device *ofdev,
 					const struct of_device_id *match)
 {
 	struct mpc52xx_gpiochip *chip;
@@ -179,7 +179,7 @@ static int __devinit mpc52xx_wkup_gpiochip_probe(struct of_device *ofdev,
 	return 0;
 }
 
-static int mpc52xx_gpiochip_remove(struct of_device *ofdev)
+static int mpc52xx_gpiochip_remove(struct platform_device *ofdev)
 {
 	return -EBUSY;
 }
@@ -310,7 +310,7 @@ mpc52xx_simple_gpio_dir_out(struct gpio_chip *gc, unsigned int gpio, int val)
 	return 0;
 }
 
-static int __devinit mpc52xx_simple_gpiochip_probe(struct of_device *ofdev,
+static int __devinit mpc52xx_simple_gpiochip_probe(struct platform_device *ofdev,
 					const struct of_device_id *match)
 {
 	struct mpc52xx_gpiochip *chip;
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
index 5d7d607..fea833e 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_gpt.c
@@ -720,7 +720,7 @@ static inline int mpc52xx_gpt_wdt_setup(struct mpc52xx_gpt_priv *gpt,
 /* ---------------------------------------------------------------------
  * of_platform bus binding code
  */
-static int __devinit mpc52xx_gpt_probe(struct of_device *ofdev,
+static int __devinit mpc52xx_gpt_probe(struct platform_device *ofdev,
 				       const struct of_device_id *match)
 {
 	struct mpc52xx_gpt_priv *gpt;
@@ -766,7 +766,7 @@ static int __devinit mpc52xx_gpt_probe(struct of_device *ofdev,
 	return 0;
 }
 
-static int mpc52xx_gpt_remove(struct of_device *ofdev)
+static int mpc52xx_gpt_remove(struct platform_device *ofdev)
 {
 	return -EBUSY;
 }
diff --git a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
index e86aec6..f4ac213 100644
--- a/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
+++ b/arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c
@@ -436,8 +436,8 @@ void mpc52xx_lpbfifo_abort(struct mpc52xx_lpbfifo_request *req)
 }
 EXPORT_SYMBOL(mpc52xx_lpbfifo_abort);
 
-static int __devinit
-mpc52xx_lpbfifo_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit mpc52xx_lpbfifo_probe(struct platform_device *op,
+					   const struct of_device_id *match)
 {
 	struct resource res;
 	int rc = -ENOMEM;
@@ -507,7 +507,7 @@ mpc52xx_lpbfifo_probe(struct of_device *op, const struct of_device_id *match)
 }
 
 
-static int __devexit mpc52xx_lpbfifo_remove(struct of_device *op)
+static int __devexit mpc52xx_lpbfifo_remove(struct platform_device *op)
 {
 	if (lpbfifo.dev != &op->dev)
 		return 0;
diff --git a/arch/powerpc/platforms/82xx/ep8248e.c b/arch/powerpc/platforms/82xx/ep8248e.c
index 9f2e52b..1565e04 100644
--- a/arch/powerpc/platforms/82xx/ep8248e.c
+++ b/arch/powerpc/platforms/82xx/ep8248e.c
@@ -111,7 +111,7 @@ static struct mdiobb_ctrl ep8248e_mdio_ctrl = {
 	.ops = &ep8248e_mdio_ops,
 };
 
-static int __devinit ep8248e_mdio_probe(struct of_device *ofdev,
+static int __devinit ep8248e_mdio_probe(struct platform_device *ofdev,
                                         const struct of_device_id *match)
 {
 	struct mii_bus *bus;
@@ -154,7 +154,7 @@ err_free_bus:
 	return ret;
 }
 
-static int ep8248e_mdio_remove(struct of_device *ofdev)
+static int ep8248e_mdio_remove(struct platform_device *ofdev)
 {
 	BUG();
 	return 0;
diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index ebe6c35..75ae77f 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -99,7 +99,7 @@ struct pmc_type {
 	int has_deep_sleep;
 };
 
-static struct of_device *pmc_dev;
+static struct platform_device *pmc_dev;
 static int has_deep_sleep, deep_sleeping;
 static int pmc_irq;
 static struct mpc83xx_pmc __iomem *pmc_regs;
@@ -318,7 +318,7 @@ static struct platform_suspend_ops mpc83xx_suspend_ops = {
 	.end = mpc83xx_suspend_end,
 };
 
-static int pmc_probe(struct of_device *ofdev,
+static int pmc_probe(struct platform_device *ofdev,
                      const struct of_device_id *match)
 {
 	struct device_node *np = ofdev->dev.of_node;
@@ -396,7 +396,7 @@ out:
 	return ret;
 }
 
-static int pmc_remove(struct of_device *ofdev)
+static int pmc_remove(struct platform_device *ofdev)
 {
 	return -EPERM;
 };
diff --git a/arch/powerpc/platforms/cell/axon_msi.c b/arch/powerpc/platforms/cell/axon_msi.c
index 6257e53..9708553 100644
--- a/arch/powerpc/platforms/cell/axon_msi.c
+++ b/arch/powerpc/platforms/cell/axon_msi.c
@@ -328,7 +328,7 @@ static struct irq_host_ops msic_host_ops = {
 	.map	= msic_host_map,
 };
 
-static int axon_msi_shutdown(struct of_device *device)
+static int axon_msi_shutdown(struct platform_device *device)
 {
 	struct axon_msic *msic = dev_get_drvdata(&device->dev);
 	u32 tmp;
@@ -342,7 +342,7 @@ static int axon_msi_shutdown(struct of_device *device)
 	return 0;
 }
 
-static int axon_msi_probe(struct of_device *device,
+static int axon_msi_probe(struct platform_device *device,
 			  const struct of_device_id *device_id)
 {
 	struct device_node *dn = device->dev.of_node;
diff --git a/arch/powerpc/platforms/pasemi/gpio_mdio.c b/arch/powerpc/platforms/pasemi/gpio_mdio.c
index 627ee08..a5d907b 100644
--- a/arch/powerpc/platforms/pasemi/gpio_mdio.c
+++ b/arch/powerpc/platforms/pasemi/gpio_mdio.c
@@ -216,7 +216,7 @@ static int gpio_mdio_reset(struct mii_bus *bus)
 }
 
 
-static int __devinit gpio_mdio_probe(struct of_device *ofdev,
+static int __devinit gpio_mdio_probe(struct platform_device *ofdev,
 				     const struct of_device_id *match)
 {
 	struct device *dev = &ofdev->dev;
@@ -275,7 +275,7 @@ out:
 }
 
 
-static int gpio_mdio_remove(struct of_device *dev)
+static int gpio_mdio_remove(struct platform_device *dev)
 {
 	struct mii_bus *bus = dev_get_drvdata(&dev->dev);
 
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 402d221..2659a60 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -60,7 +60,7 @@
 static int azfs_major, azfs_minor;
 
 struct axon_ram_bank {
-	struct of_device	*device;
+	struct platform_device	*device;
 	struct gendisk		*disk;
 	unsigned int		irq_id;
 	unsigned long		ph_addr;
@@ -72,7 +72,7 @@ struct axon_ram_bank {
 static ssize_t
 axon_ram_sysfs_ecc(struct device *dev, struct device_attribute *attr, char *buf)
 {
-	struct of_device *device = to_of_device(dev);
+	struct platform_device *device = to_platform_device(dev);
 	struct axon_ram_bank *bank = device->dev.platform_data;
 
 	BUG_ON(!bank);
@@ -90,7 +90,7 @@ static DEVICE_ATTR(ecc, S_IRUGO, axon_ram_sysfs_ecc, NULL);
 static irqreturn_t
 axon_ram_irq_handler(int irq, void *dev)
 {
-	struct of_device *device = dev;
+	struct platform_device *device = dev;
 	struct axon_ram_bank *bank = device->dev.platform_data;
 
 	BUG_ON(!bank);
@@ -174,8 +174,8 @@ static const struct block_device_operations axon_ram_devops = {
  * axon_ram_probe - probe() method for platform driver
  * @device, @device_id: see of_platform_driver method
  */
-static int
-axon_ram_probe(struct of_device *device, const struct of_device_id *device_id)
+static int axon_ram_probe(struct platform_device *device,
+			  const struct of_device_id *device_id)
 {
 	static int axon_ram_bank_id = -1;
 	struct axon_ram_bank *bank;
@@ -304,7 +304,7 @@ failed:
  * @device: see of_platform_driver method
  */
 static int
-axon_ram_remove(struct of_device *device)
+axon_ram_remove(struct platform_device *device)
 {
 	struct axon_ram_bank *bank = device->dev.platform_data;
 
diff --git a/arch/powerpc/sysdev/bestcomm/bestcomm.c b/arch/powerpc/sysdev/bestcomm/bestcomm.c
index a7c5c47..6502561 100644
--- a/arch/powerpc/sysdev/bestcomm/bestcomm.c
+++ b/arch/powerpc/sysdev/bestcomm/bestcomm.c
@@ -365,8 +365,8 @@ bcom_engine_cleanup(void)
 /* OF platform driver                                                       */
 /* ======================================================================== */
 
-static int __devinit
-mpc52xx_bcom_probe(struct of_device *op, const struct of_device_id *match)
+static int __devinit mpc52xx_bcom_probe(struct platform_device *op,
+					const struct of_device_id *match)
 {
 	struct device_node *ofn_sram;
 	struct resource res_bcom;
@@ -461,8 +461,7 @@ error_ofput:
 }
 
 
-static int
-mpc52xx_bcom_remove(struct of_device *op)
+static int mpc52xx_bcom_remove(struct platform_device *op)
 {
 	/* Clean up the engine */
 	bcom_engine_cleanup();
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index 962c2d8..87991d3 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -250,7 +250,7 @@ unlock:
 	raw_spin_unlock(&desc->lock);
 }
 
-static int fsl_of_msi_remove(struct of_device *ofdev)
+static int fsl_of_msi_remove(struct platform_device *ofdev)
 {
 	struct fsl_msi *msi = ofdev->dev.platform_data;
 	int virq, i;
@@ -274,7 +274,7 @@ static int fsl_of_msi_remove(struct of_device *ofdev)
 	return 0;
 }
 
-static int __devinit fsl_of_msi_probe(struct of_device *dev,
+static int __devinit fsl_of_msi_probe(struct platform_device *dev,
 				const struct of_device_id *match)
 {
 	struct fsl_msi *msi;
diff --git a/arch/powerpc/sysdev/fsl_pmc.c b/arch/powerpc/sysdev/fsl_pmc.c
index 9082eb9..44de855 100644
--- a/arch/powerpc/sysdev/fsl_pmc.c
+++ b/arch/powerpc/sysdev/fsl_pmc.c
@@ -58,7 +58,8 @@ static struct platform_suspend_ops pmc_suspend_ops = {
 	.enter = pmc_suspend_enter,
 };
 
-static int pmc_probe(struct of_device *ofdev, const struct of_device_id *id)
+static int pmc_probe(struct platform_device *ofdev,
+		     const struct of_device_id *id)
 {
 	pmc_regs = of_iomap(ofdev->dev.of_node, 0);
 	if (!pmc_regs)
diff --git a/arch/powerpc/sysdev/fsl_rio.c b/arch/powerpc/sysdev/fsl_rio.c
index 30e1626..8bd8653 100644
--- a/arch/powerpc/sysdev/fsl_rio.c
+++ b/arch/powerpc/sysdev/fsl_rio.c
@@ -1338,7 +1338,7 @@ static inline void fsl_rio_info(struct device *dev, u32 ccsr)
  * master port with system-specific info, and registers the
  * master port with the RapidIO subsystem.
  */
-int fsl_rio_setup(struct of_device *dev)
+int fsl_rio_setup(struct platform_device *dev)
 {
 	struct rio_ops *ops;
 	struct rio_mport *port;
@@ -1536,7 +1536,7 @@ err_ops:
 
 /* The probe function for RapidIO peer-to-peer network.
  */
-static int __devinit fsl_of_rio_rpn_probe(struct of_device *dev,
+static int __devinit fsl_of_rio_rpn_probe(struct platform_device *dev,
 				     const struct of_device_id *match)
 {
 	int rc;
diff --git a/arch/powerpc/sysdev/pmi.c b/arch/powerpc/sysdev/pmi.c
index d07137a..24a0bb9 100644
--- a/arch/powerpc/sysdev/pmi.c
+++ b/arch/powerpc/sysdev/pmi.c
@@ -43,7 +43,7 @@ struct pmi_data {
 	struct mutex		msg_mutex;
 	pmi_message_t		msg;
 	struct completion	*completion;
-	struct of_device	*dev;
+	struct platform_device	*dev;
 	int			irq;
 	u8 __iomem		*pmi_reg;
 	struct work_struct	work;
@@ -121,7 +121,7 @@ static void pmi_notify_handlers(struct work_struct *work)
 	spin_unlock(&data->handler_spinlock);
 }
 
-static int pmi_of_probe(struct of_device *dev,
+static int pmi_of_probe(struct platform_device *dev,
 			const struct of_device_id *match)
 {
 	struct device_node *np = dev->dev.of_node;
@@ -185,7 +185,7 @@ out:
 	return rc;
 }
 
-static int pmi_of_remove(struct of_device *dev)
+static int pmi_of_remove(struct platform_device *dev)
 {
 	struct pmi_handler *handler, *tmp;
 
diff --git a/arch/powerpc/sysdev/qe_lib/qe.c b/arch/powerpc/sysdev/qe_lib/qe.c
index 093e0ae..3da8014 100644
--- a/arch/powerpc/sysdev/qe_lib/qe.c
+++ b/arch/powerpc/sysdev/qe_lib/qe.c
@@ -651,14 +651,15 @@ unsigned int qe_get_num_of_snums(void)
 EXPORT_SYMBOL(qe_get_num_of_snums);
 
 #if defined(CONFIG_SUSPEND) && defined(CONFIG_PPC_85xx)
-static int qe_resume(struct of_device *ofdev)
+static int qe_resume(struct platform_device *ofdev)
 {
 	if (!qe_alive_during_sleep())
 		qe_reset();
 	return 0;
 }
 
-static int qe_probe(struct of_device *ofdev, const struct of_device_id *id)
+static int qe_probe(struct platform_device *ofdev,
+		    const struct of_device_id *id)
 {
 	return 0;
 }

