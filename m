Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933751Ab1ERTVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 15:21:25 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:41173 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933641Ab1ERTVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 15:21:08 -0400
Subject: [PATCH 2/2] drivercore: revert addition of of_match to struct device
To: devicetree-discuss@lists.ozlabs.org, gregkh@suse.de,
        linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
        sparclinux@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Josip Rodin <joy@entuzijast.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 18 May 2011 13:21:05 -0600
Message-ID: <20110518192105.28986.53198.stgit@ponder>
In-Reply-To: <20110518185751.28986.69446.stgit@ponder>
References: <20110518185751.28986.69446.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit b826291c, "drivercore/dt: add a match table pointer to struct
device" added an of_match pointer to struct device to cache the
of_match_table entry discovered at driver match time.  This was unsafe
because matching is not an atomic operation with probing a driver.  If
two or more drivers are attempted to be matched to a driver at the
same time, then the cached matching entry pointer could get
overwritten.

This patch reverts the of_match cache pointer and reworks all users to
call of_match_device() directly instead.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/powerpc/platforms/83xx/suspend.c      |    7 +++++--
 arch/powerpc/sysdev/fsl_msi.c              |    7 +++++--
 arch/sparc/kernel/pci_sabre.c              |    5 ++++-
 arch/sparc/kernel/pci_schizo.c             |    8 ++++++--
 drivers/atm/fore200e.c                     |    7 +++++--
 drivers/char/hw_random/n2-drv.c            |    7 +++++--
 drivers/char/ipmi/ipmi_si_intf.c           |    7 +++++--
 drivers/char/xilinx_hwicap/xilinx_hwicap.c |   14 +++++++++-----
 drivers/edac/ppc4xx_edac.c                 |    2 +-
 drivers/i2c/busses/i2c-mpc.c               |    9 ++++++---
 drivers/mmc/host/sdhci-of-core.c           |    7 +++++--
 drivers/mtd/maps/physmap_of.c              |    7 +++++--
 drivers/net/can/mscan/mpc5xxx_can.c        |    7 +++++--
 drivers/net/fs_enet/fs_enet-main.c         |    9 ++++++---
 drivers/net/fs_enet/mii-fec.c              |    7 +++++--
 drivers/net/sunhme.c                       |    7 +++++--
 drivers/scsi/qlogicpti.c                   |    7 +++++--
 drivers/tty/serial/of_serial.c             |    7 +++++--
 drivers/usb/gadget/fsl_qe_udc.c            |    7 +++++--
 drivers/watchdog/mpc8xxx_wdt.c             |    7 +++++--
 include/linux/device.h                     |    1 -
 include/linux/of_device.h                  |   12 ++++++------
 22 files changed, 108 insertions(+), 50 deletions(-)

diff --git a/arch/powerpc/platforms/83xx/suspend.c b/arch/powerpc/platforms/83xx/suspend.c
index 1882729..104faa8 100644
--- a/arch/powerpc/platforms/83xx/suspend.c
+++ b/arch/powerpc/platforms/83xx/suspend.c
@@ -318,17 +318,20 @@ static const struct platform_suspend_ops mpc83xx_suspend_ops = {
 	.end = mpc83xx_suspend_end,
 };
 
+static struct of_device_id pmc_match[];
 static int pmc_probe(struct platform_device *ofdev)
 {
+	const struct of_device_id *match;
 	struct device_node *np = ofdev->dev.of_node;
 	struct resource res;
 	struct pmc_type *type;
 	int ret = 0;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(pmc_match, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
 
-	type = ofdev->dev.of_match->data;
+	type = match->data;
 
 	if (!of_device_is_available(np))
 		return -ENODEV;
diff --git a/arch/powerpc/sysdev/fsl_msi.c b/arch/powerpc/sysdev/fsl_msi.c
index d5679dc..01cd2f0 100644
--- a/arch/powerpc/sysdev/fsl_msi.c
+++ b/arch/powerpc/sysdev/fsl_msi.c
@@ -304,8 +304,10 @@ static int __devinit fsl_msi_setup_hwirq(struct fsl_msi *msi,
 	return 0;
 }
 
+static const struct of_device_id fsl_of_msi_ids[];
 static int __devinit fsl_of_msi_probe(struct platform_device *dev)
 {
+	const struct of_device_id *match;
 	struct fsl_msi *msi;
 	struct resource res;
 	int err, i, j, irq_index, count;
@@ -316,9 +318,10 @@ static int __devinit fsl_of_msi_probe(struct platform_device *dev)
 	u32 offset;
 	static const u32 all_avail[] = { 0, NR_MSI_IRQS };
 
-	if (!dev->dev.of_match)
+	match = of_match_device(fsl_of_msi_ids, &dev->dev);
+	if (!match)
 		return -EINVAL;
-	features = dev->dev.of_match->data;
+	features = match->data;
 
 	printk(KERN_DEBUG "Setting up Freescale MSI support\n");
 
diff --git a/arch/sparc/kernel/pci_sabre.c b/arch/sparc/kernel/pci_sabre.c
index 948068a..d1840db 100644
--- a/arch/sparc/kernel/pci_sabre.c
+++ b/arch/sparc/kernel/pci_sabre.c
@@ -452,8 +452,10 @@ static void __devinit sabre_pbm_init(struct pci_pbm_info *pbm,
 	sabre_scan_bus(pbm, &op->dev);
 }
 
+static const struct of_device_id sabre_match[];
 static int __devinit sabre_probe(struct platform_device *op)
 {
+	const struct of_device_id *match;
 	const struct linux_prom64_registers *pr_regs;
 	struct device_node *dp = op->dev.of_node;
 	struct pci_pbm_info *pbm;
@@ -463,7 +465,8 @@ static int __devinit sabre_probe(struct platform_device *op)
 	const u32 *vdma;
 	u64 clear_irq;
 
-	hummingbird_p = op->dev.of_match && (op->dev.of_match->data != NULL);
+	match = of_match_device(sabre_match, &op->dev);
+	hummingbird_p = match && (match->data != NULL);
 	if (!hummingbird_p) {
 		struct device_node *cpu_dp;
 
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index fecfcb2..283fbc3 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -1458,11 +1458,15 @@ out_err:
 	return err;
 }
 
+static const struct of_device_id schizo_match[];
 static int __devinit schizo_probe(struct platform_device *op)
 {
-	if (!op->dev.of_match)
+	const struct of_device_id *match;
+
+	match = of_match_device(schizo_match, &op->dev);
+	if (!match)
 		return -EINVAL;
-	return __schizo_init(op, (unsigned long) op->dev.of_match->data);
+	return __schizo_init(op, (unsigned long)match->data);
 }
 
 /* The ordering of this table is very important.  Some Tomatillo
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index bdd2719..bc9e702 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -2643,16 +2643,19 @@ fore200e_init(struct fore200e* fore200e, struct device *parent)
 }
 
 #ifdef CONFIG_SBUS
+static const struct of_device_id fore200e_sba_match[];
 static int __devinit fore200e_sba_probe(struct platform_device *op)
 {
+	const struct of_device_id *match;
 	const struct fore200e_bus *bus;
 	struct fore200e *fore200e;
 	static int index = 0;
 	int err;
 
-	if (!op->dev.of_match)
+	match = of_match_device(fore200e_sba_match, &op->dev);
+	if (!match)
 		return -EINVAL;
-	bus = op->dev.of_match->data;
+	bus = match->data;
 
 	fore200e = kzalloc(sizeof(struct fore200e), GFP_KERNEL);
 	if (!fore200e)
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 43ac619..ac6739e 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -619,15 +619,18 @@ static void __devinit n2rng_driver_version(void)
 		pr_info("%s", version);
 }
 
+static const struct of_device_id n2rng_match[];
 static int __devinit n2rng_probe(struct platform_device *op)
 {
+	const struct of_device_id *match;
 	int victoria_falls;
 	int err = -ENOMEM;
 	struct n2rng *np;
 
-	if (!op->dev.of_match)
+	match = of_match_device(n2rng_match, &op->dev);
+	if (!match)
 		return -EINVAL;
-	victoria_falls = (op->dev.of_match->data != NULL);
+	victoria_falls = (match->data != NULL);
 
 	n2rng_driver_version();
 	np = kzalloc(sizeof(*np), GFP_KERNEL);
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index cc6c9b2..64c6b85 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2554,9 +2554,11 @@ static struct pci_driver ipmi_pci_driver = {
 };
 #endif /* CONFIG_PCI */
 
+static struct of_device_id ipmi_match[];
 static int __devinit ipmi_probe(struct platform_device *dev)
 {
 #ifdef CONFIG_OF
+	const struct of_device_id *match;
 	struct smi_info *info;
 	struct resource resource;
 	const __be32 *regsize, *regspacing, *regshift;
@@ -2566,7 +2568,8 @@ static int __devinit ipmi_probe(struct platform_device *dev)
 
 	dev_info(&dev->dev, "probing via device tree\n");
 
-	if (!dev->dev.of_match)
+	match = of_match_device(ipmi_match, &dev->dev);
+	if (!match)
 		return -EINVAL;
 
 	ret = of_address_to_resource(np, 0, &resource);
@@ -2601,7 +2604,7 @@ static int __devinit ipmi_probe(struct platform_device *dev)
 		return -ENOMEM;
 	}
 
-	info->si_type		= (enum si_type) dev->dev.of_match->data;
+	info->si_type		= (enum si_type) match->data;
 	info->addr_source	= SI_DEVICETREE;
 	info->irq_setup		= std_irq_setup;
 
diff --git a/drivers/char/xilinx_hwicap/xilinx_hwicap.c b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
index d6412c1..39ccdea 100644
--- a/drivers/char/xilinx_hwicap/xilinx_hwicap.c
+++ b/drivers/char/xilinx_hwicap/xilinx_hwicap.c
@@ -715,13 +715,13 @@ static int __devexit hwicap_remove(struct device *dev)
 }
 
 #ifdef CONFIG_OF
-static int __devinit hwicap_of_probe(struct platform_device *op)
+static int __devinit hwicap_of_probe(struct platform_device *op,
+				     const struct hwicap_driver_config *config)
 {
 	struct resource res;
 	const unsigned int *id;
 	const char *family;
 	int rc;
-	const struct hwicap_driver_config *config = op->dev.of_match->data;
 	const struct config_registers *regs;
 
 
@@ -751,20 +751,24 @@ static int __devinit hwicap_of_probe(struct platform_device *op)
 			regs);
 }
 #else
-static inline int hwicap_of_probe(struct platform_device *op)
+static inline int hwicap_of_probe(struct platform_device *op,
+				  const struct hwicap_driver_config *config)
 {
 	return -EINVAL;
 }
 #endif /* CONFIG_OF */
 
+static const struct of_device_id __devinitconst hwicap_of_match[];
 static int __devinit hwicap_drv_probe(struct platform_device *pdev)
 {
+	const struct of_device_id *match;
 	struct resource *res;
 	const struct config_registers *regs;
 	const char *family;
 
-	if (pdev->dev.of_match)
-		return hwicap_of_probe(pdev);
+	match = of_match_device(hwicap_of_match, &pdev->dev);
+	if (match)
+		return hwicap_of_probe(pdev, match->data);
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
diff --git a/drivers/edac/ppc4xx_edac.c b/drivers/edac/ppc4xx_edac.c
index c1f0045..af8e7b1 100644
--- a/drivers/edac/ppc4xx_edac.c
+++ b/drivers/edac/ppc4xx_edac.c
@@ -1019,7 +1019,7 @@ ppc4xx_edac_mc_init(struct mem_ctl_info *mci,
 	struct ppc4xx_edac_pdata *pdata = NULL;
 	const struct device_node *np = op->dev.of_node;
 
-	if (op->dev.of_match == NULL)
+	if (of_match_device(ppc4xx_edac_match, &op->dev) == NULL)
 		return -EINVAL;
 
 	/* Initial driver pointers and private data */
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index 75b984c..107397a 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -560,15 +560,18 @@ static struct i2c_adapter mpc_ops = {
 	.timeout = HZ,
 };
 
+static const struct of_device_id mpc_i2c_of_match[];
 static int __devinit fsl_i2c_probe(struct platform_device *op)
 {
+	const struct of_device_id *match;
 	struct mpc_i2c *i2c;
 	const u32 *prop;
 	u32 clock = MPC_I2C_CLOCK_LEGACY;
 	int result = 0;
 	int plen;
 
-	if (!op->dev.of_match)
+	match = of_match_device(mpc_i2c_of_match, &op->dev);
+	if (!match)
 		return -EINVAL;
 
 	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
@@ -605,8 +608,8 @@ static int __devinit fsl_i2c_probe(struct platform_device *op)
 			clock = *prop;
 	}
 
-	if (op->dev.of_match->data) {
-		struct mpc_i2c_data *data = op->dev.of_match->data;
+	if (match->data) {
+		struct mpc_i2c_data *data = match->data;
 		data->setup(op->dev.of_node, i2c, clock, data->prescaler);
 	} else {
 		/* Backwards compatibility */
diff --git a/drivers/mmc/host/sdhci-of-core.c b/drivers/mmc/host/sdhci-of-core.c
index f9b611f..60e4186 100644
--- a/drivers/mmc/host/sdhci-of-core.c
+++ b/drivers/mmc/host/sdhci-of-core.c
@@ -124,8 +124,10 @@ static bool __devinit sdhci_of_wp_inverted(struct device_node *np)
 #endif
 }
 
+static const struct of_device_id sdhci_of_match[];
 static int __devinit sdhci_of_probe(struct platform_device *ofdev)
 {
+	const struct of_device_id *match;
 	struct device_node *np = ofdev->dev.of_node;
 	struct sdhci_of_data *sdhci_of_data;
 	struct sdhci_host *host;
@@ -134,9 +136,10 @@ static int __devinit sdhci_of_probe(struct platform_device *ofdev)
 	int size;
 	int ret;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(sdhci_of_match, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
-	sdhci_of_data = ofdev->dev.of_match->data;
+	sdhci_of_data = match->data;
 
 	if (!of_device_is_available(np))
 		return -ENODEV;
diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index bd483f0..c1d3346 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -214,11 +214,13 @@ static void __devinit of_free_probes(const char **probes)
 }
 #endif
 
+static struct of_device_id of_flash_match[];
 static int __devinit of_flash_probe(struct platform_device *dev)
 {
 #ifdef CONFIG_MTD_PARTITIONS
 	const char **part_probe_types;
 #endif
+	const struct of_device_id *match;
 	struct device_node *dp = dev->dev.of_node;
 	struct resource res;
 	struct of_flash *info;
@@ -232,9 +234,10 @@ static int __devinit of_flash_probe(struct platform_device *dev)
 	struct mtd_info **mtd_list = NULL;
 	resource_size_t res_size;
 
-	if (!dev->dev.of_match)
+	match = of_match_device(of_flash_match, &dev->dev);
+	if (!match)
 		return -EINVAL;
-	probe_type = dev->dev.of_match->data;
+	probe_type = match->data;
 
 	reg_tuple_size = (of_n_addr_cells(dp) + of_n_size_cells(dp)) * sizeof(u32);
 
diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index bd1d811..5fedc33 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -247,8 +247,10 @@ static u32 __devinit mpc512x_can_get_clock(struct platform_device *ofdev,
 }
 #endif /* CONFIG_PPC_MPC512x */
 
+static struct of_device_id mpc5xxx_can_table[];
 static int __devinit mpc5xxx_can_probe(struct platform_device *ofdev)
 {
+	const struct of_device_id *match;
 	struct mpc5xxx_can_data *data;
 	struct device_node *np = ofdev->dev.of_node;
 	struct net_device *dev;
@@ -258,9 +260,10 @@ static int __devinit mpc5xxx_can_probe(struct platform_device *ofdev)
 	int irq, mscan_clksrc = 0;
 	int err = -ENOMEM;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(mpc5xxx_can_table, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
-	data = (struct mpc5xxx_can_data *)ofdev->dev.of_match->data;
+	data = match->data;
 
 	base = of_iomap(np, 0);
 	if (!base) {
diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index 24cb953..5131e61 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -998,8 +998,10 @@ static const struct net_device_ops fs_enet_netdev_ops = {
 #endif
 };
 
+static struct of_device_id fs_enet_match[];
 static int __devinit fs_enet_probe(struct platform_device *ofdev)
 {
+	const struct of_device_id *match;
 	struct net_device *ndev;
 	struct fs_enet_private *fep;
 	struct fs_platform_info *fpi;
@@ -1007,14 +1009,15 @@ static int __devinit fs_enet_probe(struct platform_device *ofdev)
 	const u8 *mac_addr;
 	int privsize, len, ret = -ENODEV;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(fs_enet_match, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
 
 	fpi = kzalloc(sizeof(*fpi), GFP_KERNEL);
 	if (!fpi)
 		return -ENOMEM;
 
-	if (!IS_FEC(ofdev->dev.of_match)) {
+	if (!IS_FEC(match)) {
 		data = of_get_property(ofdev->dev.of_node, "fsl,cpm-command", &len);
 		if (!data || len != 4)
 			goto out_free_fpi;
@@ -1049,7 +1052,7 @@ static int __devinit fs_enet_probe(struct platform_device *ofdev)
 	fep->dev = &ofdev->dev;
 	fep->ndev = ndev;
 	fep->fpi = fpi;
-	fep->ops = ofdev->dev.of_match->data;
+	fep->ops = match->data;
 
 	ret = fep->ops->setup_data(ndev);
 	if (ret)
diff --git a/drivers/net/fs_enet/mii-fec.c b/drivers/net/fs_enet/mii-fec.c
index 7e840d3..6a2e150 100644
--- a/drivers/net/fs_enet/mii-fec.c
+++ b/drivers/net/fs_enet/mii-fec.c
@@ -101,17 +101,20 @@ static int fs_enet_fec_mii_reset(struct mii_bus *bus)
 	return 0;
 }
 
+static struct of_device_id fs_enet_mdio_fec_match[];
 static int __devinit fs_enet_mdio_probe(struct platform_device *ofdev)
 {
+	const struct of_device_id *match;
 	struct resource res;
 	struct mii_bus *new_bus;
 	struct fec_info *fec;
 	int (*get_bus_freq)(struct device_node *);
 	int ret = -ENOMEM, clock, speed;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(fs_enet_mdio_fec_match, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
-	get_bus_freq = ofdev->dev.of_match->data;
+	get_bus_freq = match->data;
 
 	new_bus = mdiobus_alloc();
 	if (!new_bus)
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index eb4f59f..bff2f79 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -3237,15 +3237,18 @@ static void happy_meal_pci_exit(void)
 #endif
 
 #ifdef CONFIG_SBUS
+static const struct of_device_id hme_sbus_match[];
 static int __devinit hme_sbus_probe(struct platform_device *op)
 {
+	const struct of_device_id *match;
 	struct device_node *dp = op->dev.of_node;
 	const char *model = of_get_property(dp, "model", NULL);
 	int is_qfe;
 
-	if (!op->dev.of_match)
+	match = of_match_device(hme_sbus_match, &op->dev);
+	if (!match)
 		return -EINVAL;
-	is_qfe = (op->dev.of_match->data != NULL);
+	is_qfe = (match->data != NULL);
 
 	if (!is_qfe && model && !strcmp(model, "SUNW,sbus-qfe"))
 		is_qfe = 1;
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index e2d45c9..9689d41c 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1292,8 +1292,10 @@ static struct scsi_host_template qpti_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
+static const struct of_device_id qpti_match[];
 static int __devinit qpti_sbus_probe(struct platform_device *op)
 {
+	const struct of_device_id *match;
 	struct scsi_host_template *tpnt;
 	struct device_node *dp = op->dev.of_node;
 	struct Scsi_Host *host;
@@ -1301,9 +1303,10 @@ static int __devinit qpti_sbus_probe(struct platform_device *op)
 	static int nqptis;
 	const char *fcode;
 
-	if (!op->dev.of_match)
+	match = of_match_device(qpti_match, &op->dev);
+	if (!match)
 		return -EINVAL;
-	tpnt = op->dev.of_match->data;
+	tpnt = match->data;
 
 	/* Sometimes Antares cards come up not completely
 	 * setup, and we get a report of a zero IRQ.
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 0e8eec5..c911b24 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -80,14 +80,17 @@ static int __devinit of_platform_serial_setup(struct platform_device *ofdev,
 /*
  * Try to register a serial port
  */
+static struct of_device_id of_platform_serial_table[];
 static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 {
+	const struct of_device_id *match;
 	struct of_serial_info *info;
 	struct uart_port port;
 	int port_type;
 	int ret;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(of_platform_serial_table, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
 
 	if (of_find_property(ofdev->dev.of_node, "used-by-rtas", NULL))
@@ -97,7 +100,7 @@ static int __devinit of_platform_serial_probe(struct platform_device *ofdev)
 	if (info == NULL)
 		return -ENOMEM;
 
-	port_type = (unsigned long)ofdev->dev.of_match->data;
+	port_type = (unsigned long)match->data;
 	ret = of_platform_serial_setup(ofdev, port_type, &port);
 	if (ret)
 		goto out;
diff --git a/drivers/usb/gadget/fsl_qe_udc.c b/drivers/usb/gadget/fsl_qe_udc.c
index 36613b3..3a68e09 100644
--- a/drivers/usb/gadget/fsl_qe_udc.c
+++ b/drivers/usb/gadget/fsl_qe_udc.c
@@ -2539,15 +2539,18 @@ static void qe_udc_release(struct device *dev)
 }
 
 /* Driver probe functions */
+static const struct of_device_id qe_udc_match[];
 static int __devinit qe_udc_probe(struct platform_device *ofdev)
 {
+	const struct of_device_id *match;
 	struct device_node *np = ofdev->dev.of_node;
 	struct qe_ep *ep;
 	unsigned int ret = 0;
 	unsigned int i;
 	const void *prop;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(qe_udc_match, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
 
 	prop = of_get_property(np, "mode", NULL);
@@ -2561,7 +2564,7 @@ static int __devinit qe_udc_probe(struct platform_device *ofdev)
 		return -ENOMEM;
 	}
 
-	udc_controller->soc_type = (unsigned long)ofdev->dev.of_match->data;
+	udc_controller->soc_type = (unsigned long)match->data;
 	udc_controller->usb_regs = of_iomap(np, 0);
 	if (!udc_controller->usb_regs) {
 		ret = -ENOMEM;
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 528bceb..eed5436 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -185,17 +185,20 @@ static struct miscdevice mpc8xxx_wdt_miscdev = {
 	.fops	= &mpc8xxx_wdt_fops,
 };
 
+static const struct of_device_id mpc8xxx_wdt_match[];
 static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev)
 {
 	int ret;
+	const struct of_device_id *match;
 	struct device_node *np = ofdev->dev.of_node;
 	struct mpc8xxx_wdt_type *wdt_type;
 	u32 freq = fsl_get_sys_freq();
 	bool enabled;
 
-	if (!ofdev->dev.of_match)
+	match = of_match_device(mpc8xxx_wdt_match, &ofdev->dev);
+	if (!match)
 		return -EINVAL;
-	wdt_type = ofdev->dev.of_match->data;
+	wdt_type = match->data;
 
 	if (!freq || freq == -1)
 		return -EINVAL;
diff --git a/include/linux/device.h b/include/linux/device.h
index ab8dfc0..d08399d 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -442,7 +442,6 @@ struct device {
 	struct dev_archdata	archdata;
 
 	struct device_node	*of_node; /* associated device tree node */
-	const struct of_device_id *of_match; /* matching of_device_id from driver */
 
 	dev_t			devt;	/* dev_t, creates the sysfs "dev" */
 
diff --git a/include/linux/of_device.h b/include/linux/of_device.h
index b33d688..ae56384 100644
--- a/include/linux/of_device.h
+++ b/include/linux/of_device.h
@@ -21,12 +21,7 @@ extern void of_device_make_bus_id(struct device *dev);
 static inline int of_driver_match_device(struct device *dev,
 					 const struct device_driver *drv)
 {
-	const struct of_device_id *match;
-
-	match = of_match_device(drv->of_match_table, dev);
-	if (match)
-		dev->of_match = match;
-	return match != NULL;
+	return of_match_device(drv->of_match_table, dev) != NULL;
 }
 
 extern struct platform_device *of_dev_get(struct platform_device *dev);
@@ -62,6 +57,11 @@ static inline int of_device_uevent(struct device *dev,
 
 static inline void of_device_node_put(struct device *dev) { }
 
+static inline const struct of_device_id *of_match_device(
+		const struct of_device_id *matches, const struct device *dev)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF_DEVICE */
 
 #endif /* _LINUX_OF_DEVICE_H */

