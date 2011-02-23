Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab1BWEey (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49687 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab1BWEev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:51 -0500
Subject: [RFC PATCH 14/15] dt: Eliminate of_platform_{,un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:47 -0700
Message-ID: <20110223043447.20795.80653.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Final step to eliminate of_platform_bus_type.  They're all just
platform drivers now.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/ata/pata_mpc52xx.c       |    8 ++++----
 drivers/ata/pata_of_platform.c   |    9 ++++-----
 drivers/ata/sata_dwc_460ex.c     |    9 ++++-----
 drivers/ata/sata_fsl.c           |    9 ++++-----
 drivers/atm/fore200e.c           |   17 ++++++++++-------
 drivers/block/xsysace.c          |   11 ++++-------
 drivers/char/ipmi/ipmi_si_intf.c |   18 ++++++++++--------
 drivers/crypto/talitos.c         |    9 ++++-----
 drivers/i2c/busses/i2c-cpm.c     |    9 ++++-----
 drivers/i2c/busses/i2c-ibm_iic.c |    9 ++++-----
 drivers/i2c/busses/i2c-mpc.c     |   22 +++++++++-------------
 drivers/input/serio/xilinx_ps2.c |    9 ++++-----
 drivers/media/video/fsl-viu.c    |    9 ++++-----
 drivers/mmc/host/sdhci-of-core.c |   12 ++++++++----
 drivers/mtd/maps/physmap_of.c    |   15 +++++++++------
 drivers/mtd/maps/sun_uflash.c    |    8 ++++----
 drivers/mtd/nand/fsl_upm.c       |    9 ++++-----
 drivers/mtd/nand/mpc5121_nfc.c   |    9 ++++-----
 drivers/mtd/nand/ndfc.c          |    9 ++++-----
 drivers/mtd/nand/pasemi_nand.c   |    9 ++++-----
 drivers/mtd/nand/socrates_nand.c |    9 ++++-----
 drivers/pcmcia/electra_cf.c      |    9 ++++-----
 drivers/pcmcia/m8xx_pcmcia.c     |    9 ++++-----
 drivers/rtc/rtc-mpc5121.c        |    9 ++++-----
 drivers/watchdog/cpwd.c          |    9 ++++-----
 drivers/watchdog/gef_wdt.c       |    9 ++++-----
 drivers/watchdog/mpc8xxx_wdt.c   |   15 +++++++++------
 drivers/watchdog/riowd.c         |    9 ++++-----
 28 files changed, 143 insertions(+), 154 deletions(-)

diff --git a/drivers/ata/pata_mpc52xx.c b/drivers/ata/pata_mpc52xx.c
index d7d8026..2fcac51 100644
--- a/drivers/ata/pata_mpc52xx.c
+++ b/drivers/ata/pata_mpc52xx.c
@@ -680,7 +680,7 @@ mpc52xx_ata_remove_one(struct device *dev)
 /* ======================================================================== */
 
 static int __devinit
-mpc52xx_ata_probe(struct platform_device *op, const struct of_device_id *match)
+mpc52xx_ata_probe(struct platform_device *op)
 {
 	unsigned int ipb_freq;
 	struct resource res_mem;
@@ -883,7 +883,7 @@ static struct of_device_id mpc52xx_ata_of_match[] = {
 };
 
 
-static struct of_platform_driver mpc52xx_ata_of_platform_driver = {
+static struct platform_driver mpc52xx_ata_of_platform_driver = {
 	.probe		= mpc52xx_ata_probe,
 	.remove		= mpc52xx_ata_remove,
 #ifdef CONFIG_PM
@@ -906,13 +906,13 @@ static int __init
 mpc52xx_ata_init(void)
 {
 	printk(KERN_INFO "ata: MPC52xx IDE/ATA libata driver\n");
-	return of_register_platform_driver(&mpc52xx_ata_of_platform_driver);
+	return platform_driver_register(&mpc52xx_ata_of_platform_driver);
 }
 
 static void __exit
 mpc52xx_ata_exit(void)
 {
-	of_unregister_platform_driver(&mpc52xx_ata_of_platform_driver);
+	platform_driver_unregister(&mpc52xx_ata_of_platform_driver);
 }
 
 module_init(mpc52xx_ata_init);
diff --git a/drivers/ata/pata_of_platform.c b/drivers/ata/pata_of_platform.c
index 480e043..f305400 100644
--- a/drivers/ata/pata_of_platform.c
+++ b/drivers/ata/pata_of_platform.c
@@ -14,8 +14,7 @@
 #include <linux/of_platform.h>
 #include <linux/ata_platform.h>
 
-static int __devinit pata_of_platform_probe(struct platform_device *ofdev,
-					    const struct of_device_id *match)
+static int __devinit pata_of_platform_probe(struct platform_device *ofdev)
 {
 	int ret;
 	struct device_node *dn = ofdev->dev.of_node;
@@ -90,7 +89,7 @@ static struct of_device_id pata_of_platform_match[] = {
 };
 MODULE_DEVICE_TABLE(of, pata_of_platform_match);
 
-static struct of_platform_driver pata_of_platform_driver = {
+static struct platform_driver pata_of_platform_driver = {
 	.driver = {
 		.name = "pata_of_platform",
 		.owner = THIS_MODULE,
@@ -102,13 +101,13 @@ static struct of_platform_driver pata_of_platform_driver = {
 
 static int __init pata_of_platform_init(void)
 {
-	return of_register_platform_driver(&pata_of_platform_driver);
+	return platform_driver_register(&pata_of_platform_driver);
 }
 module_init(pata_of_platform_init);
 
 static void __exit pata_of_platform_exit(void)
 {
-	of_unregister_platform_driver(&pata_of_platform_driver);
+	platform_driver_unregister(&pata_of_platform_driver);
 }
 module_exit(pata_of_platform_exit);
 
diff --git a/drivers/ata/sata_dwc_460ex.c b/drivers/ata/sata_dwc_460ex.c
index 6cf57c5..685a3a4 100644
--- a/drivers/ata/sata_dwc_460ex.c
+++ b/drivers/ata/sata_dwc_460ex.c
@@ -1588,8 +1588,7 @@ static const struct ata_port_info sata_dwc_port_info[] = {
 	},
 };
 
-static int sata_dwc_probe(struct platform_device *ofdev,
-			const struct of_device_id *match)
+static int sata_dwc_probe(struct platform_device *ofdev)
 {
 	struct sata_dwc_device *hsdev;
 	u32 idr, versionr;
@@ -1727,7 +1726,7 @@ static const struct of_device_id sata_dwc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sata_dwc_match);
 
-static struct of_platform_driver sata_dwc_driver = {
+static struct platform_driver sata_dwc_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
@@ -1739,12 +1738,12 @@ static struct of_platform_driver sata_dwc_driver = {
 
 static int __init sata_dwc_init(void)
 {
-	return	of_register_platform_driver(&sata_dwc_driver);
+	return platform_driver_register(&sata_dwc_driver);
 }
 
 static void __exit sata_dwc_exit(void)
 {
-	of_unregister_platform_driver(&sata_dwc_driver);
+	platform_driver_unregister(&sata_dwc_driver);
 }
 
 module_init(sata_dwc_init);
diff --git a/drivers/ata/sata_fsl.c b/drivers/ata/sata_fsl.c
index b0214d0..b843e8e 100644
--- a/drivers/ata/sata_fsl.c
+++ b/drivers/ata/sata_fsl.c
@@ -1293,8 +1293,7 @@ static const struct ata_port_info sata_fsl_port_info[] = {
 	 },
 };
 
-static int sata_fsl_probe(struct platform_device *ofdev,
-			const struct of_device_id *match)
+static int sata_fsl_probe(struct platform_device *ofdev)
 {
 	int retval = -ENXIO;
 	void __iomem *hcr_base = NULL;
@@ -1423,7 +1422,7 @@ static struct of_device_id fsl_sata_match[] = {
 
 MODULE_DEVICE_TABLE(of, fsl_sata_match);
 
-static struct of_platform_driver fsl_sata_driver = {
+static struct platform_driver fsl_sata_driver = {
 	.driver = {
 		.name = "fsl-sata",
 		.owner = THIS_MODULE,
@@ -1439,13 +1438,13 @@ static struct of_platform_driver fsl_sata_driver = {
 
 static int __init sata_fsl_init(void)
 {
-	of_register_platform_driver(&fsl_sata_driver);
+	platform_driver_register(&fsl_sata_driver);
 	return 0;
 }
 
 static void __exit sata_fsl_exit(void)
 {
-	of_unregister_platform_driver(&fsl_sata_driver);
+	platform_driver_unregister(&fsl_sata_driver);
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 44f7785..bdd2719 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -2643,14 +2643,17 @@ fore200e_init(struct fore200e* fore200e, struct device *parent)
 }
 
 #ifdef CONFIG_SBUS
-static int __devinit fore200e_sba_probe(struct platform_device *op,
-					const struct of_device_id *match)
+static int __devinit fore200e_sba_probe(struct platform_device *op)
 {
-	const struct fore200e_bus *bus = match->data;
+	const struct fore200e_bus *bus;
 	struct fore200e *fore200e;
 	static int index = 0;
 	int err;
 
+	if (!op->dev.of_match)
+		return -EINVAL;
+	bus = op->dev.of_match->data;
+
 	fore200e = kzalloc(sizeof(struct fore200e), GFP_KERNEL);
 	if (!fore200e)
 		return -ENOMEM;
@@ -2694,7 +2697,7 @@ static const struct of_device_id fore200e_sba_match[] = {
 };
 MODULE_DEVICE_TABLE(of, fore200e_sba_match);
 
-static struct of_platform_driver fore200e_sba_driver = {
+static struct platform_driver fore200e_sba_driver = {
 	.driver = {
 		.name = "fore_200e",
 		.owner = THIS_MODULE,
@@ -2795,7 +2798,7 @@ static int __init fore200e_module_init(void)
 	printk(FORE200E "FORE Systems 200E-series ATM driver - version " FORE200E_VERSION "\n");
 
 #ifdef CONFIG_SBUS
-	err = of_register_platform_driver(&fore200e_sba_driver);
+	err = platform_driver_register(&fore200e_sba_driver);
 	if (err)
 		return err;
 #endif
@@ -2806,7 +2809,7 @@ static int __init fore200e_module_init(void)
 
 #ifdef CONFIG_SBUS
 	if (err)
-		of_unregister_platform_driver(&fore200e_sba_driver);
+		platform_driver_unregister(&fore200e_sba_driver);
 #endif
 
 	return err;
@@ -2818,7 +2821,7 @@ static void __exit fore200e_module_cleanup(void)
 	pci_unregister_driver(&fore200e_pca_driver);
 #endif
 #ifdef CONFIG_SBUS
-	of_unregister_platform_driver(&fore200e_sba_driver);
+	platform_driver_unregister(&fore200e_sba_driver);
 #endif
 }
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 829161e..2c590a7 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -1195,16 +1195,13 @@ static struct platform_driver ace_platform_driver = {
  */
 
 #if defined(CONFIG_OF)
-static int __devinit
-ace_of_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit ace_of_probe(struct platform_device *op)
 {
 	struct resource res;
 	resource_size_t physaddr;
 	const u32 *id;
 	int irq, bus_width, rc;
 
-	dev_dbg(&op->dev, "ace_of_probe(%p, %p)\n", op, match);
-
 	/* device id */
 	id = of_get_property(op->dev.of_node, "port-number", NULL);
 
@@ -1245,7 +1242,7 @@ static const struct of_device_id ace_of_match[] __devinitconst = {
 };
 MODULE_DEVICE_TABLE(of, ace_of_match);
 
-static struct of_platform_driver ace_of_driver = {
+static struct platform_driver ace_of_driver = {
 	.probe = ace_of_probe,
 	.remove = __devexit_p(ace_of_remove),
 	.driver = {
@@ -1259,12 +1256,12 @@ static struct of_platform_driver ace_of_driver = {
 static inline int __init ace_of_register(void)
 {
 	pr_debug("xsysace: registering OF binding\n");
-	return of_register_platform_driver(&ace_of_driver);
+	return platform_driver_register(&ace_of_driver);
 }
 
 static inline void __exit ace_of_unregister(void)
 {
-	of_unregister_platform_driver(&ace_of_driver);
+	platform_driver_unregister(&ace_of_driver);
 }
 #else /* CONFIG_OF */
 /* CONFIG_OF not enabled; do nothing helpers */
diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index b6ae6e9..132951d 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -2556,8 +2556,7 @@ static struct pci_driver ipmi_pci_driver = {
 
 
 #ifdef CONFIG_PPC_OF
-static int __devinit ipmi_of_probe(struct platform_device *dev,
-			 const struct of_device_id *match)
+static int __devinit ipmi_of_probe(struct platform_device *dev)
 {
 	struct smi_info *info;
 	struct resource resource;
@@ -2568,6 +2567,9 @@ static int __devinit ipmi_of_probe(struct platform_device *dev,
 
 	dev_info(&dev->dev, "probing via device tree\n");
 
+	if (!dev->dev.of_match)
+		return -EINVAL;
+
 	ret = of_address_to_resource(np, 0, &resource);
 	if (ret) {
 		dev_warn(&dev->dev, PFX "invalid address from OF\n");
@@ -2600,7 +2602,7 @@ static int __devinit ipmi_of_probe(struct platform_device *dev,
 		return -ENOMEM;
 	}
 
-	info->si_type		= (enum si_type) match->data;
+	info->si_type		= (enum si_type) dev->dev.of_match->data;
 	info->addr_source	= SI_DEVICETREE;
 	info->irq_setup		= std_irq_setup;
 
@@ -2652,9 +2654,9 @@ static struct of_device_id ipmi_match[] =
 	{},
 };
 
-static struct of_platform_driver ipmi_of_platform_driver = {
+static struct platform_driver ipmi_of_platform_driver = {
 	.driver = {
-		.name = "ipmi",
+		.name = "of-ipmi",
 		.owner = THIS_MODULE,
 		.of_match_table = ipmi_match,
 	},
@@ -3396,7 +3398,7 @@ static int __devinit init_ipmi_si(void)
 #endif
 
 #ifdef CONFIG_PPC_OF
-	of_register_platform_driver(&ipmi_of_platform_driver);
+	platform_driver_register(&ipmi_of_platform_driver);
 	of_registered = 1;
 #endif
 
@@ -3457,7 +3459,7 @@ static int __devinit init_ipmi_si(void)
 
 #ifdef CONFIG_PPC_OF
 		if (of_registered)
-			of_unregister_platform_driver(&ipmi_of_platform_driver);
+			platform_driver_unregister(&ipmi_of_platform_driver);
 #endif
 		driver_unregister(&ipmi_driver.driver);
 		printk(KERN_WARNING PFX
@@ -3558,7 +3560,7 @@ static void __exit cleanup_ipmi_si(void)
 
 #ifdef CONFIG_PPC_OF
 	if (of_registered)
-		of_unregister_platform_driver(&ipmi_of_platform_driver);
+		platform_driver_unregister(&ipmi_of_platform_driver);
 #endif
 
 	mutex_lock(&smi_infos_lock);
diff --git a/drivers/crypto/talitos.c b/drivers/crypto/talitos.c
index b879c3f..854e263 100644
--- a/drivers/crypto/talitos.c
+++ b/drivers/crypto/talitos.c
@@ -2402,8 +2402,7 @@ static struct talitos_crypto_alg *talitos_alg_alloc(struct device *dev,
 	return t_alg;
 }
 
-static int talitos_probe(struct platform_device *ofdev,
-			 const struct of_device_id *match)
+static int talitos_probe(struct platform_device *ofdev)
 {
 	struct device *dev = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
@@ -2580,7 +2579,7 @@ static const struct of_device_id talitos_match[] = {
 };
 MODULE_DEVICE_TABLE(of, talitos_match);
 
-static struct of_platform_driver talitos_driver = {
+static struct platform_driver talitos_driver = {
 	.driver = {
 		.name = "talitos",
 		.owner = THIS_MODULE,
@@ -2592,13 +2591,13 @@ static struct of_platform_driver talitos_driver = {
 
 static int __init talitos_init(void)
 {
-	return of_register_platform_driver(&talitos_driver);
+	return platform_driver_register(&talitos_driver);
 }
 module_init(talitos_init);
 
 static void __exit talitos_exit(void)
 {
-	of_unregister_platform_driver(&talitos_driver);
+	platform_driver_unregister(&talitos_driver);
 }
 module_exit(talitos_exit);
 
diff --git a/drivers/i2c/busses/i2c-cpm.c b/drivers/i2c/busses/i2c-cpm.c
index f2de3be..3a20961 100644
--- a/drivers/i2c/busses/i2c-cpm.c
+++ b/drivers/i2c/busses/i2c-cpm.c
@@ -634,8 +634,7 @@ static void cpm_i2c_shutdown(struct cpm_i2c *cpm)
 		cpm_muram_free(cpm->i2c_addr);
 }
 
-static int __devinit cpm_i2c_probe(struct platform_device *ofdev,
-			 const struct of_device_id *match)
+static int __devinit cpm_i2c_probe(struct platform_device *ofdev)
 {
 	int result, len;
 	struct cpm_i2c *cpm;
@@ -718,7 +717,7 @@ static const struct of_device_id cpm_i2c_match[] = {
 
 MODULE_DEVICE_TABLE(of, cpm_i2c_match);
 
-static struct of_platform_driver cpm_i2c_driver = {
+static struct platform_driver cpm_i2c_driver = {
 	.probe		= cpm_i2c_probe,
 	.remove		= __devexit_p(cpm_i2c_remove),
 	.driver = {
@@ -730,12 +729,12 @@ static struct of_platform_driver cpm_i2c_driver = {
 
 static int __init cpm_i2c_init(void)
 {
-	return of_register_platform_driver(&cpm_i2c_driver);
+	return platform_driver_register(&cpm_i2c_driver);
 }
 
 static void __exit cpm_i2c_exit(void)
 {
-	of_unregister_platform_driver(&cpm_i2c_driver);
+	platform_driver_unregister(&cpm_i2c_driver);
 }
 
 module_init(cpm_i2c_init);
diff --git a/drivers/i2c/busses/i2c-ibm_iic.c b/drivers/i2c/busses/i2c-ibm_iic.c
index 6e3c382..e4f88dc 100644
--- a/drivers/i2c/busses/i2c-ibm_iic.c
+++ b/drivers/i2c/busses/i2c-ibm_iic.c
@@ -691,8 +691,7 @@ static int __devinit iic_request_irq(struct platform_device *ofdev,
 /*
  * Register single IIC interface
  */
-static int __devinit iic_probe(struct platform_device *ofdev,
-			       const struct of_device_id *match)
+static int __devinit iic_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct ibm_iic_private *dev;
@@ -806,7 +805,7 @@ static const struct of_device_id ibm_iic_match[] = {
 	{}
 };
 
-static struct of_platform_driver ibm_iic_driver = {
+static struct platform_driver ibm_iic_driver = {
 	.driver = {
 		.name = "ibm-iic",
 		.owner = THIS_MODULE,
@@ -818,12 +817,12 @@ static struct of_platform_driver ibm_iic_driver = {
 
 static int __init iic_init(void)
 {
-	return of_register_platform_driver(&ibm_iic_driver);
+	return platform_driver_register(&ibm_iic_driver);
 }
 
 static void __exit iic_exit(void)
 {
-	of_unregister_platform_driver(&ibm_iic_driver);
+	platform_driver_unregister(&ibm_iic_driver);
 }
 
 module_init(iic_init);
diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
index b74e6dc..75b984c 100644
--- a/drivers/i2c/busses/i2c-mpc.c
+++ b/drivers/i2c/busses/i2c-mpc.c
@@ -560,8 +560,7 @@ static struct i2c_adapter mpc_ops = {
 	.timeout = HZ,
 };
 
-static int __devinit fsl_i2c_probe(struct platform_device *op,
-				   const struct of_device_id *match)
+static int __devinit fsl_i2c_probe(struct platform_device *op)
 {
 	struct mpc_i2c *i2c;
 	const u32 *prop;
@@ -569,6 +568,9 @@ static int __devinit fsl_i2c_probe(struct platform_device *op,
 	int result = 0;
 	int plen;
 
+	if (!op->dev.of_match)
+		return -EINVAL;
+
 	i2c = kzalloc(sizeof(*i2c), GFP_KERNEL);
 	if (!i2c)
 		return -ENOMEM;
@@ -603,8 +605,8 @@ static int __devinit fsl_i2c_probe(struct platform_device *op,
 			clock = *prop;
 	}
 
-	if (match->data) {
-		struct mpc_i2c_data *data = match->data;
+	if (op->dev.of_match->data) {
+		struct mpc_i2c_data *data = op->dev.of_match->data;
 		data->setup(op->dev.of_node, i2c, clock, data->prescaler);
 	} else {
 		/* Backwards compatibility */
@@ -700,7 +702,7 @@ static const struct of_device_id mpc_i2c_of_match[] = {
 MODULE_DEVICE_TABLE(of, mpc_i2c_of_match);
 
 /* Structure for a device driver */
-static struct of_platform_driver mpc_i2c_driver = {
+static struct platform_driver mpc_i2c_driver = {
 	.probe		= fsl_i2c_probe,
 	.remove		= __devexit_p(fsl_i2c_remove),
 	.driver = {
@@ -712,18 +714,12 @@ static struct of_platform_driver mpc_i2c_driver = {
 
 static int __init fsl_i2c_init(void)
 {
-	int rv;
-
-	rv = of_register_platform_driver(&mpc_i2c_driver);
-	if (rv)
-		printk(KERN_ERR DRV_NAME
-		       " of_register_platform_driver failed (%i)\n", rv);
-	return rv;
+	return platform_driver_register(&mpc_i2c_driver);
 }
 
 static void __exit fsl_i2c_exit(void)
 {
-	of_unregister_platform_driver(&mpc_i2c_driver);
+	platform_driver_unregister(&mpc_i2c_driver);
 }
 
 module_init(fsl_i2c_init);
diff --git a/drivers/input/serio/xilinx_ps2.c b/drivers/input/serio/xilinx_ps2.c
index bb14449..7540baf 100644
--- a/drivers/input/serio/xilinx_ps2.c
+++ b/drivers/input/serio/xilinx_ps2.c
@@ -232,8 +232,7 @@ static void sxps2_close(struct serio *pserio)
  * It returns 0, if the driver is bound to the PS/2 device, or a negative
  * value if there is an error.
  */
-static int __devinit xps2_of_probe(struct platform_device *ofdev,
-				   const struct of_device_id *match)
+static int __devinit xps2_of_probe(struct platform_device *ofdev)
 {
 	struct resource r_irq; /* Interrupt resources */
 	struct resource r_mem; /* IO mem resources */
@@ -361,7 +360,7 @@ static const struct of_device_id xps2_of_match[] __devinitconst = {
 };
 MODULE_DEVICE_TABLE(of, xps2_of_match);
 
-static struct of_platform_driver xps2_of_driver = {
+static struct platform_driver xps2_of_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -373,12 +372,12 @@ static struct of_platform_driver xps2_of_driver = {
 
 static int __init xps2_init(void)
 {
-	return of_register_platform_driver(&xps2_of_driver);
+	return platform_driver_register(&xps2_of_driver);
 }
 
 static void __exit xps2_cleanup(void)
 {
-	of_unregister_platform_driver(&xps2_of_driver);
+	platform_driver_unregister(&xps2_of_driver);
 }
 
 module_init(xps2_init);
diff --git a/drivers/media/video/fsl-viu.c b/drivers/media/video/fsl-viu.c
index e4bba88..031af16 100644
--- a/drivers/media/video/fsl-viu.c
+++ b/drivers/media/video/fsl-viu.c
@@ -1445,8 +1445,7 @@ static struct video_device viu_template = {
 	.current_norm   = V4L2_STD_NTSC_M,
 };
 
-static int __devinit viu_of_probe(struct platform_device *op,
-				  const struct of_device_id *match)
+static int __devinit viu_of_probe(struct platform_device *op)
 {
 	struct viu_dev *viu_dev;
 	struct video_device *vdev;
@@ -1627,7 +1626,7 @@ static struct of_device_id mpc512x_viu_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mpc512x_viu_of_match);
 
-static struct of_platform_driver viu_of_platform_driver = {
+static struct platform_driver viu_of_platform_driver = {
 	.probe = viu_of_probe,
 	.remove = __devexit_p(viu_of_remove),
 #ifdef CONFIG_PM
@@ -1643,12 +1642,12 @@ static struct of_platform_driver viu_of_platform_driver = {
 
 static int __init viu_init(void)
 {
-	return of_register_platform_driver(&viu_of_platform_driver);
+	return platform_driver_register(&viu_of_platform_driver);
 }
 
 static void __exit viu_exit(void)
 {
-	of_unregister_platform_driver(&viu_of_platform_driver);
+	platform_driver_unregister(&viu_of_platform_driver);
 }
 
 module_init(viu_init);
diff --git a/drivers/mmc/host/sdhci-of-core.c b/drivers/mmc/host/sdhci-of-core.c
index dd84124..7c250e3 100644
--- a/drivers/mmc/host/sdhci-of-core.c
+++ b/drivers/mmc/host/sdhci-of-core.c
@@ -128,13 +128,17 @@ static int __devinit sdhci_of_probe(struct platform_device *ofdev,
 				 const struct of_device_id *match)
 {
 	struct device_node *np = ofdev->dev.of_node;
-	struct sdhci_of_data *sdhci_of_data = match->data;
+	struct sdhci_of_data *sdhci_of_data;
 	struct sdhci_host *host;
 	struct sdhci_of_host *of_host;
 	const __be32 *clk;
 	int size;
 	int ret;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+	sdhci_of_data = ofdev->dev.of_match->data;
+
 	if (!of_device_is_available(np))
 		return -ENODEV;
 
@@ -217,7 +221,7 @@ static const struct of_device_id sdhci_of_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sdhci_of_match);
 
-static struct of_platform_driver sdhci_of_driver = {
+static struct platform_driver sdhci_of_driver = {
 	.driver = {
 		.name = "sdhci-of",
 		.owner = THIS_MODULE,
@@ -231,13 +235,13 @@ static struct of_platform_driver sdhci_of_driver = {
 
 static int __init sdhci_of_init(void)
 {
-	return of_register_platform_driver(&sdhci_of_driver);
+	return platform_driver_register(&sdhci_of_driver);
 }
 module_init(sdhci_of_init);
 
 static void __exit sdhci_of_exit(void)
 {
-	of_unregister_platform_driver(&sdhci_of_driver);
+	platform_driver_unregister(&sdhci_of_driver);
 }
 module_exit(sdhci_of_exit);
 
diff --git a/drivers/mtd/maps/physmap_of.c b/drivers/mtd/maps/physmap_of.c
index 8506578..3db0cb0 100644
--- a/drivers/mtd/maps/physmap_of.c
+++ b/drivers/mtd/maps/physmap_of.c
@@ -216,8 +216,7 @@ static void __devinit of_free_probes(const char **probes)
 }
 #endif
 
-static int __devinit of_flash_probe(struct platform_device *dev,
-				    const struct of_device_id *match)
+static int __devinit of_flash_probe(struct platform_device *dev)
 {
 #ifdef CONFIG_MTD_PARTITIONS
 	const char **part_probe_types;
@@ -225,7 +224,7 @@ static int __devinit of_flash_probe(struct platform_device *dev,
 	struct device_node *dp = dev->dev.of_node;
 	struct resource res;
 	struct of_flash *info;
-	const char *probe_type = match->data;
+	const char *probe_type;
 	const __be32 *width;
 	int err;
 	int i;
@@ -235,6 +234,10 @@ static int __devinit of_flash_probe(struct platform_device *dev,
 	struct mtd_info **mtd_list = NULL;
 	resource_size_t res_size;
 
+	if (!dev->dev.of_match)
+		return -EINVAL;
+	probe_type = dev->dev.of_match->data;
+
 	reg_tuple_size = (of_n_addr_cells(dp) + of_n_size_cells(dp)) * sizeof(u32);
 
 	/*
@@ -418,7 +421,7 @@ static struct of_device_id of_flash_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_flash_match);
 
-static struct of_platform_driver of_flash_driver = {
+static struct platform_driver of_flash_driver = {
 	.driver = {
 		.name = "of-flash",
 		.owner = THIS_MODULE,
@@ -430,12 +433,12 @@ static struct of_platform_driver of_flash_driver = {
 
 static int __init of_flash_init(void)
 {
-	return of_register_platform_driver(&of_flash_driver);
+	return platform_driver_register(&of_flash_driver);
 }
 
 static void __exit of_flash_exit(void)
 {
-	of_unregister_platform_driver(&of_flash_driver);
+	platform_driver_unregister(&of_flash_driver);
 }
 
 module_init(of_flash_init);
diff --git a/drivers/mtd/maps/sun_uflash.c b/drivers/mtd/maps/sun_uflash.c
index 3582ba1..3f1cb32 100644
--- a/drivers/mtd/maps/sun_uflash.c
+++ b/drivers/mtd/maps/sun_uflash.c
@@ -108,7 +108,7 @@ int uflash_devinit(struct platform_device *op, struct device_node *dp)
 	return 0;
 }
 
-static int __devinit uflash_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit uflash_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 
@@ -148,7 +148,7 @@ static const struct of_device_id uflash_match[] = {
 
 MODULE_DEVICE_TABLE(of, uflash_match);
 
-static struct of_platform_driver uflash_driver = {
+static struct platform_driver uflash_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -160,12 +160,12 @@ static struct of_platform_driver uflash_driver = {
 
 static int __init uflash_init(void)
 {
-	return of_register_platform_driver(&uflash_driver);
+	return platform_driver_register(&uflash_driver);
 }
 
 static void __exit uflash_exit(void)
 {
-	of_unregister_platform_driver(&uflash_driver);
+	platform_driver_unregister(&uflash_driver);
 }
 
 module_init(uflash_init);
diff --git a/drivers/mtd/nand/fsl_upm.c b/drivers/mtd/nand/fsl_upm.c
index efdcca9..073ee02 100644
--- a/drivers/mtd/nand/fsl_upm.c
+++ b/drivers/mtd/nand/fsl_upm.c
@@ -217,8 +217,7 @@ err:
 	return ret;
 }
 
-static int __devinit fun_probe(struct platform_device *ofdev,
-			       const struct of_device_id *ofid)
+static int __devinit fun_probe(struct platform_device *ofdev)
 {
 	struct fsl_upm_nand *fun;
 	struct resource io_res;
@@ -360,7 +359,7 @@ static const struct of_device_id of_fun_match[] = {
 };
 MODULE_DEVICE_TABLE(of, of_fun_match);
 
-static struct of_platform_driver of_fun_driver = {
+static struct platform_driver of_fun_driver = {
 	.driver = {
 		.name = "fsl,upm-nand",
 		.owner = THIS_MODULE,
@@ -372,13 +371,13 @@ static struct of_platform_driver of_fun_driver = {
 
 static int __init fun_module_init(void)
 {
-	return of_register_platform_driver(&of_fun_driver);
+	return platform_driver_register(&of_fun_driver);
 }
 module_init(fun_module_init);
 
 static void __exit fun_module_exit(void)
 {
-	of_unregister_platform_driver(&of_fun_driver);
+	platform_driver_unregister(&of_fun_driver);
 }
 module_exit(fun_module_exit);
 
diff --git a/drivers/mtd/nand/mpc5121_nfc.c b/drivers/mtd/nand/mpc5121_nfc.c
index 469e649..c2f9543 100644
--- a/drivers/mtd/nand/mpc5121_nfc.c
+++ b/drivers/mtd/nand/mpc5121_nfc.c
@@ -650,8 +650,7 @@ static void mpc5121_nfc_free(struct device *dev, struct mtd_info *mtd)
 		iounmap(prv->csreg);
 }
 
-static int __devinit mpc5121_nfc_probe(struct platform_device *op,
-					const struct of_device_id *match)
+static int __devinit mpc5121_nfc_probe(struct platform_device *op)
 {
 	struct device_node *rootnode, *dn = op->dev.of_node;
 	struct device *dev = &op->dev;
@@ -891,7 +890,7 @@ static struct of_device_id mpc5121_nfc_match[] __devinitdata = {
 	{},
 };
 
-static struct of_platform_driver mpc5121_nfc_driver = {
+static struct platform_driver mpc5121_nfc_driver = {
 	.probe		= mpc5121_nfc_probe,
 	.remove		= __devexit_p(mpc5121_nfc_remove),
 	.driver		= {
@@ -903,14 +902,14 @@ static struct of_platform_driver mpc5121_nfc_driver = {
 
 static int __init mpc5121_nfc_init(void)
 {
-	return of_register_platform_driver(&mpc5121_nfc_driver);
+	return platform_driver_register(&mpc5121_nfc_driver);
 }
 
 module_init(mpc5121_nfc_init);
 
 static void __exit mpc5121_nfc_cleanup(void)
 {
-	of_unregister_platform_driver(&mpc5121_nfc_driver);
+	platform_driver_unregister(&mpc5121_nfc_driver);
 }
 
 module_exit(mpc5121_nfc_cleanup);
diff --git a/drivers/mtd/nand/ndfc.c b/drivers/mtd/nand/ndfc.c
index c9ae0a5..bbe6d45 100644
--- a/drivers/mtd/nand/ndfc.c
+++ b/drivers/mtd/nand/ndfc.c
@@ -225,8 +225,7 @@ err:
 	return ret;
 }
 
-static int __devinit ndfc_probe(struct platform_device *ofdev,
-				const struct of_device_id *match)
+static int __devinit ndfc_probe(struct platform_device *ofdev)
 {
 	struct ndfc_controller *ndfc = &ndfc_ctrl;
 	const __be32 *reg;
@@ -292,7 +291,7 @@ static const struct of_device_id ndfc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, ndfc_match);
 
-static struct of_platform_driver ndfc_driver = {
+static struct platform_driver ndfc_driver = {
 	.driver = {
 		.name = "ndfc",
 		.owner = THIS_MODULE,
@@ -304,12 +303,12 @@ static struct of_platform_driver ndfc_driver = {
 
 static int __init ndfc_nand_init(void)
 {
-	return of_register_platform_driver(&ndfc_driver);
+	return platform_driver_register(&ndfc_driver);
 }
 
 static void __exit ndfc_nand_exit(void)
 {
-	of_unregister_platform_driver(&ndfc_driver);
+	platform_driver_unregister(&ndfc_driver);
 }
 
 module_init(ndfc_nand_init);
diff --git a/drivers/mtd/nand/pasemi_nand.c b/drivers/mtd/nand/pasemi_nand.c
index bb277a5..5a0f1cf 100644
--- a/drivers/mtd/nand/pasemi_nand.c
+++ b/drivers/mtd/nand/pasemi_nand.c
@@ -89,8 +89,7 @@ int pasemi_device_ready(struct mtd_info *mtd)
 	return !!(inl(lpcctl) & LBICTRL_LPCCTL_NR);
 }
 
-static int __devinit pasemi_nand_probe(struct platform_device *ofdev,
-				      const struct of_device_id *match)
+static int __devinit pasemi_nand_probe(struct platform_device *ofdev)
 {
 	struct pci_dev *pdev;
 	struct device_node *np = ofdev->dev.of_node;
@@ -219,7 +218,7 @@ static const struct of_device_id pasemi_nand_match[] =
 
 MODULE_DEVICE_TABLE(of, pasemi_nand_match);
 
-static struct of_platform_driver pasemi_nand_driver =
+static struct latform_driver pasemi_nand_driver =
 {
 	.driver = {
 		.name = (char*)driver_name,
@@ -232,13 +231,13 @@ static struct of_platform_driver pasemi_nand_driver =
 
 static int __init pasemi_nand_init(void)
 {
-	return of_register_platform_driver(&pasemi_nand_driver);
+	return platform_driver_register(&pasemi_nand_driver);
 }
 module_init(pasemi_nand_init);
 
 static void __exit pasemi_nand_exit(void)
 {
-	of_unregister_platform_driver(&pasemi_nand_driver);
+	platform_driver_unregister(&pasemi_nand_driver);
 }
 module_exit(pasemi_nand_exit);
 
diff --git a/drivers/mtd/nand/socrates_nand.c b/drivers/mtd/nand/socrates_nand.c
index a8e403e..a853548 100644
--- a/drivers/mtd/nand/socrates_nand.c
+++ b/drivers/mtd/nand/socrates_nand.c
@@ -162,8 +162,7 @@ static const char *part_probes[] = { "cmdlinepart", NULL };
 /*
  * Probe for the NAND device.
  */
-static int __devinit socrates_nand_probe(struct platform_device *ofdev,
-					 const struct of_device_id *ofid)
+static int __devinit socrates_nand_probe(struct platform_device *ofdev)
 {
 	struct socrates_nand_host *host;
 	struct mtd_info *mtd;
@@ -300,7 +299,7 @@ static const struct of_device_id socrates_nand_match[] =
 
 MODULE_DEVICE_TABLE(of, socrates_nand_match);
 
-static struct of_platform_driver socrates_nand_driver = {
+static struct platform_driver socrates_nand_driver = {
 	.driver = {
 		.name = "socrates_nand",
 		.owner = THIS_MODULE,
@@ -312,12 +311,12 @@ static struct of_platform_driver socrates_nand_driver = {
 
 static int __init socrates_nand_init(void)
 {
-	return of_register_platform_driver(&socrates_nand_driver);
+	return platform_driver_register(&socrates_nand_driver);
 }
 
 static void __exit socrates_nand_exit(void)
 {
-	of_unregister_platform_driver(&socrates_nand_driver);
+	platform_driver_unregister(&socrates_nand_driver);
 }
 
 module_init(socrates_nand_init);
diff --git a/drivers/pcmcia/electra_cf.c b/drivers/pcmcia/electra_cf.c
index 546d302..6defd4a 100644
--- a/drivers/pcmcia/electra_cf.c
+++ b/drivers/pcmcia/electra_cf.c
@@ -181,8 +181,7 @@ static struct pccard_operations electra_cf_ops = {
 	.set_mem_map		= electra_cf_set_mem_map,
 };
 
-static int __devinit electra_cf_probe(struct platform_device *ofdev,
-				      const struct of_device_id *match)
+static int __devinit electra_cf_probe(struct platform_device *ofdev)
 {
 	struct device *device = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
@@ -356,7 +355,7 @@ static const struct of_device_id electra_cf_match[] = {
 };
 MODULE_DEVICE_TABLE(of, electra_cf_match);
 
-static struct of_platform_driver electra_cf_driver = {
+static struct platform_driver electra_cf_driver = {
 	.driver = {
 		.name = (char *)driver_name,
 		.owner = THIS_MODULE,
@@ -368,13 +367,13 @@ static struct of_platform_driver electra_cf_driver = {
 
 static int __init electra_cf_init(void)
 {
-	return of_register_platform_driver(&electra_cf_driver);
+	return platform_driver_register(&electra_cf_driver);
 }
 module_init(electra_cf_init);
 
 static void __exit electra_cf_exit(void)
 {
-	of_unregister_platform_driver(&electra_cf_driver);
+	platform_driver_unregister(&electra_cf_driver);
 }
 module_exit(electra_cf_exit);
 
diff --git a/drivers/pcmcia/m8xx_pcmcia.c b/drivers/pcmcia/m8xx_pcmcia.c
index 0db4827..271a590 100644
--- a/drivers/pcmcia/m8xx_pcmcia.c
+++ b/drivers/pcmcia/m8xx_pcmcia.c
@@ -1148,8 +1148,7 @@ static struct pccard_operations m8xx_services = {
 	.set_mem_map = m8xx_set_mem_map,
 };
 
-static int __init m8xx_probe(struct platform_device *ofdev,
-			     const struct of_device_id *match)
+static int __init m8xx_probe(struct platform_device *ofdev)
 {
 	struct pcmcia_win *w;
 	unsigned int i, m, hwirq;
@@ -1295,7 +1294,7 @@ static const struct of_device_id m8xx_pcmcia_match[] = {
 
 MODULE_DEVICE_TABLE(of, m8xx_pcmcia_match);
 
-static struct of_platform_driver m8xx_pcmcia_driver = {
+static struct platform_driver m8xx_pcmcia_driver = {
 	.driver = {
 		.name = driver_name,
 		.owner = THIS_MODULE,
@@ -1307,12 +1306,12 @@ static struct of_platform_driver m8xx_pcmcia_driver = {
 
 static int __init m8xx_init(void)
 {
-	return of_register_platform_driver(&m8xx_pcmcia_driver);
+	return platform_driver_register(&m8xx_pcmcia_driver);
 }
 
 static void __exit m8xx_exit(void)
 {
-	of_unregister_platform_driver(&m8xx_pcmcia_driver);
+	platform_driver_unregister(&m8xx_pcmcia_driver);
 }
 
 module_init(m8xx_init);
diff --git a/drivers/rtc/rtc-mpc5121.c b/drivers/rtc/rtc-mpc5121.c
index dfcdf09..2b952c6 100644
--- a/drivers/rtc/rtc-mpc5121.c
+++ b/drivers/rtc/rtc-mpc5121.c
@@ -268,8 +268,7 @@ static const struct rtc_class_ops mpc5121_rtc_ops = {
 	.update_irq_enable = mpc5121_rtc_update_irq_enable,
 };
 
-static int __devinit mpc5121_rtc_probe(struct platform_device *op,
-					const struct of_device_id *match)
+static int __devinit mpc5121_rtc_probe(struct platform_device *op)
 {
 	struct mpc5121_rtc_data *rtc;
 	int err = 0;
@@ -364,7 +363,7 @@ static struct of_device_id mpc5121_rtc_match[] __devinitdata = {
 	{},
 };
 
-static struct of_platform_driver mpc5121_rtc_driver = {
+static struct platform_driver mpc5121_rtc_driver = {
 	.driver = {
 		.name = "mpc5121-rtc",
 		.owner = THIS_MODULE,
@@ -376,13 +375,13 @@ static struct of_platform_driver mpc5121_rtc_driver = {
 
 static int __init mpc5121_rtc_init(void)
 {
-	return of_register_platform_driver(&mpc5121_rtc_driver);
+	return platform_driver_register(&mpc5121_rtc_driver);
 }
 module_init(mpc5121_rtc_init);
 
 static void __exit mpc5121_rtc_exit(void)
 {
-	of_unregister_platform_driver(&mpc5121_rtc_driver);
+	platform_driver_unregister(&mpc5121_rtc_driver);
 }
 module_exit(mpc5121_rtc_exit);
 
diff --git a/drivers/watchdog/cpwd.c b/drivers/watchdog/cpwd.c
index eca855a..45db1d5 100644
--- a/drivers/watchdog/cpwd.c
+++ b/drivers/watchdog/cpwd.c
@@ -528,8 +528,7 @@ static const struct file_operations cpwd_fops = {
 	.llseek =		no_llseek,
 };
 
-static int __devinit cpwd_probe(struct platform_device *op,
-				const struct of_device_id *match)
+static int __devinit cpwd_probe(struct platform_device *op)
 {
 	struct device_node *options;
 	const char *str_prop;
@@ -678,7 +677,7 @@ static const struct of_device_id cpwd_match[] = {
 };
 MODULE_DEVICE_TABLE(of, cpwd_match);
 
-static struct of_platform_driver cpwd_driver = {
+static struct platform_driver cpwd_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -690,12 +689,12 @@ static struct of_platform_driver cpwd_driver = {
 
 static int __init cpwd_init(void)
 {
-	return of_register_platform_driver(&cpwd_driver);
+	return platform_driver_register(&cpwd_driver);
 }
 
 static void __exit cpwd_exit(void)
 {
-	of_unregister_platform_driver(&cpwd_driver);
+	platform_driver_unregister(&cpwd_driver);
 }
 
 module_init(cpwd_init);
diff --git a/drivers/watchdog/gef_wdt.c b/drivers/watchdog/gef_wdt.c
index f6bd6f1..29a7cd4 100644
--- a/drivers/watchdog/gef_wdt.c
+++ b/drivers/watchdog/gef_wdt.c
@@ -261,8 +261,7 @@ static struct miscdevice gef_wdt_miscdev = {
 };
 
 
-static int __devinit gef_wdt_probe(struct platform_device *dev,
-	const struct of_device_id *match)
+static int __devinit gef_wdt_probe(struct platform_device *dev)
 {
 	int timeout = 10;
 	u32 freq;
@@ -303,7 +302,7 @@ static const struct of_device_id gef_wdt_ids[] = {
 	{},
 };
 
-static struct of_platform_driver gef_wdt_driver = {
+static struct platform_driver gef_wdt_driver = {
 	.driver = {
 		.name = "gef_wdt",
 		.owner = THIS_MODULE,
@@ -315,12 +314,12 @@ static struct of_platform_driver gef_wdt_driver = {
 static int __init gef_wdt_init(void)
 {
 	printk(KERN_INFO "GE watchdog driver\n");
-	return of_register_platform_driver(&gef_wdt_driver);
+	return platform_driver_register(&gef_wdt_driver);
 }
 
 static void __exit gef_wdt_exit(void)
 {
-	of_unregister_platform_driver(&gef_wdt_driver);
+	platform_driver_unregister(&gef_wdt_driver);
 }
 
 module_init(gef_wdt_init);
diff --git a/drivers/watchdog/mpc8xxx_wdt.c b/drivers/watchdog/mpc8xxx_wdt.c
index 8fa213c..ea438ad 100644
--- a/drivers/watchdog/mpc8xxx_wdt.c
+++ b/drivers/watchdog/mpc8xxx_wdt.c
@@ -185,15 +185,18 @@ static struct miscdevice mpc8xxx_wdt_miscdev = {
 	.fops	= &mpc8xxx_wdt_fops,
 };
 
-static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev,
-				       const struct of_device_id *match)
+static int __devinit mpc8xxx_wdt_probe(struct platform_device *ofdev)
 {
 	int ret;
 	struct device_node *np = ofdev->dev.of_node;
-	struct mpc8xxx_wdt_type *wdt_type = match->data;
+	struct mpc8xxx_wdt_type *wdt_type;
 	u32 freq = fsl_get_sys_freq();
 	bool enabled;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+	wdt_type = match->data;
+
 	if (!freq || freq == -1)
 		return -EINVAL;
 
@@ -272,7 +275,7 @@ static const struct of_device_id mpc8xxx_wdt_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mpc8xxx_wdt_match);
 
-static struct of_platform_driver mpc8xxx_wdt_driver = {
+static struct platform_driver mpc8xxx_wdt_driver = {
 	.probe		= mpc8xxx_wdt_probe,
 	.remove		= __devexit_p(mpc8xxx_wdt_remove),
 	.driver = {
@@ -308,13 +311,13 @@ module_init(mpc8xxx_wdt_init_late);
 
 static int __init mpc8xxx_wdt_init(void)
 {
-	return of_register_platform_driver(&mpc8xxx_wdt_driver);
+	return platform_driver_register(&mpc8xxx_wdt_driver);
 }
 arch_initcall(mpc8xxx_wdt_init);
 
 static void __exit mpc8xxx_wdt_exit(void)
 {
-	of_unregister_platform_driver(&mpc8xxx_wdt_driver);
+	platform_driver_unregister(&mpc8xxx_wdt_driver);
 }
 module_exit(mpc8xxx_wdt_exit);
 
diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 3faee1a..109b533 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -172,8 +172,7 @@ static struct miscdevice riowd_miscdev = {
 	.fops	= &riowd_fops
 };
 
-static int __devinit riowd_probe(struct platform_device *op,
-				 const struct of_device_id *match)
+static int __devinit riowd_probe(struct platform_device *op)
 {
 	struct riowd *p;
 	int err = -EINVAL;
@@ -238,7 +237,7 @@ static const struct of_device_id riowd_match[] = {
 };
 MODULE_DEVICE_TABLE(of, riowd_match);
 
-static struct of_platform_driver riowd_driver = {
+static struct platform_driver riowd_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -250,12 +249,12 @@ static struct of_platform_driver riowd_driver = {
 
 static int __init riowd_init(void)
 {
-	return of_register_platform_driver(&riowd_driver);
+	return platform_driver_register(&riowd_driver);
 }
 
 static void __exit riowd_exit(void)
 {
-	of_unregister_platform_driver(&riowd_driver);
+	platform_driver_unregister(&riowd_driver);
 }
 
 module_init(riowd_init);

