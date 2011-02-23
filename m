Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755495Ab1BWEgd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:36:33 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:52621 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753687Ab1BWEeA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:00 -0500
Subject: [RFC PATCH 04/15] dt/sparc: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:33:55 -0700
Message-ID: <20110223043355.20795.4924.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of old users of of_platform_driver in arch/sparc.  Most
of_platform_driver users can be converted to use the platform_bus
directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 arch/sparc/include/asm/parport.h    |    6 +++---
 arch/sparc/kernel/apc.c             |    7 +++----
 arch/sparc/kernel/auxio_64.c        |    7 +++----
 arch/sparc/kernel/central.c         |   14 ++++++--------
 arch/sparc/kernel/chmc.c            |   19 ++++++++-----------
 arch/sparc/kernel/pci_fire.c        |    7 +++----
 arch/sparc/kernel/pci_psycho.c      |    7 +++----
 arch/sparc/kernel/pci_sabre.c       |    9 ++++-----
 arch/sparc/kernel/pci_schizo.c      |   11 ++++++-----
 arch/sparc/kernel/pci_sun4v.c       |    7 +++----
 arch/sparc/kernel/pmc.c             |    7 +++----
 arch/sparc/kernel/power.c           |    6 +++---
 arch/sparc/kernel/time_32.c         |    6 +++---
 arch/sparc/kernel/time_64.c         |   18 +++++++++---------
 drivers/char/hw_random/n2-drv.c     |   16 +++++++++-------
 drivers/crypto/n2_core.c            |   20 +++++++++-----------
 drivers/hwmon/ultra45_env.c         |    9 ++++-----
 drivers/input/misc/sparcspkr.c      |   22 ++++++++++------------
 drivers/input/serio/i8042-sparcio.h |    8 ++++----
 drivers/parport/parport_sunbpp.c    |    8 ++++----
 drivers/sbus/char/bbc_i2c.c         |    9 ++++-----
 drivers/sbus/char/display7seg.c     |    9 ++++-----
 drivers/sbus/char/envctrl.c         |    9 ++++-----
 drivers/sbus/char/flash.c           |    9 ++++-----
 drivers/sbus/char/uctrl.c           |    9 ++++-----
 drivers/scsi/qlogicpti.c            |   14 +++++++++-----
 drivers/scsi/sun_esp.c              |    8 ++++----
 27 files changed, 133 insertions(+), 148 deletions(-)

diff --git a/arch/sparc/include/asm/parport.h b/arch/sparc/include/asm/parport.h
index aa4c826..cb33608 100644
--- a/arch/sparc/include/asm/parport.h
+++ b/arch/sparc/include/asm/parport.h
@@ -103,7 +103,7 @@ static inline unsigned int get_dma_residue(unsigned int dmanr)
 	return ebus_dma_residue(&sparc_ebus_dmas[dmanr].info);
 }
 
-static int __devinit ecpp_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit ecpp_probe(struct platform_device *op)
 {
 	unsigned long base = op->resource[0].start;
 	unsigned long config = op->resource[1].start;
@@ -235,7 +235,7 @@ static const struct of_device_id ecpp_match[] = {
 	{},
 };
 
-static struct of_platform_driver ecpp_driver = {
+static struct platform_driver ecpp_driver = {
 	.driver = {
 		.name = "ecpp",
 		.owner = THIS_MODULE,
@@ -247,7 +247,7 @@ static struct of_platform_driver ecpp_driver = {
 
 static int parport_pc_find_nonpci_ports(int autoirq, int autodma)
 {
-	return of_register_platform_driver(&ecpp_driver);
+	return platform_driver_register(&ecpp_driver);
 }
 
 #endif /* !(_ASM_SPARC64_PARPORT_H */
diff --git a/arch/sparc/kernel/apc.c b/arch/sparc/kernel/apc.c
index 52de4a9..f679c57 100644
--- a/arch/sparc/kernel/apc.c
+++ b/arch/sparc/kernel/apc.c
@@ -137,8 +137,7 @@ static const struct file_operations apc_fops = {
 
 static struct miscdevice apc_miscdev = { APC_MINOR, APC_DEVNAME, &apc_fops };
 
-static int __devinit apc_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit apc_probe(struct platform_device *op)
 {
 	int err;
 
@@ -174,7 +173,7 @@ static struct of_device_id __initdata apc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, apc_match);
 
-static struct of_platform_driver apc_driver = {
+static struct platform_driver apc_driver = {
 	.driver = {
 		.name = "apc",
 		.owner = THIS_MODULE,
@@ -185,7 +184,7 @@ static struct of_platform_driver apc_driver = {
 
 static int __init apc_init(void)
 {
-	return of_register_platform_driver(&apc_driver);
+	return platform_driver_register(&apc_driver);
 }
 
 /* This driver is not critical to the boot process
diff --git a/arch/sparc/kernel/auxio_64.c b/arch/sparc/kernel/auxio_64.c
index 3efd3c5..2abace0 100644
--- a/arch/sparc/kernel/auxio_64.c
+++ b/arch/sparc/kernel/auxio_64.c
@@ -102,8 +102,7 @@ static struct of_device_id __initdata auxio_match[] = {
 
 MODULE_DEVICE_TABLE(of, auxio_match);
 
-static int __devinit auxio_probe(struct platform_device *dev,
-				 const struct of_device_id *match)
+static int __devinit auxio_probe(struct platform_device *dev)
 {
 	struct device_node *dp = dev->dev.of_node;
 	unsigned long size;
@@ -132,7 +131,7 @@ static int __devinit auxio_probe(struct platform_device *dev,
 	return 0;
 }
 
-static struct of_platform_driver auxio_driver = {
+static struct platform_driver auxio_driver = {
 	.probe		= auxio_probe,
 	.driver = {
 		.name = "auxio",
@@ -143,7 +142,7 @@ static struct of_platform_driver auxio_driver = {
 
 static int __init auxio_init(void)
 {
-	return of_register_platform_driver(&auxio_driver);
+	return platform_driver_register(&auxio_driver);
 }
 
 /* Must be after subsys_initcall() so that busses are probed.  Must
diff --git a/arch/sparc/kernel/central.c b/arch/sparc/kernel/central.c
index cfa2624..136d371 100644
--- a/arch/sparc/kernel/central.c
+++ b/arch/sparc/kernel/central.c
@@ -59,8 +59,7 @@ static int __devinit clock_board_calc_nslots(struct clock_board *p)
 	}
 }
 
-static int __devinit clock_board_probe(struct platform_device *op,
-				       const struct of_device_id *match)
+static int __devinit clock_board_probe(struct platform_device *op)
 {
 	struct clock_board *p = kzalloc(sizeof(*p), GFP_KERNEL);
 	int err = -ENOMEM;
@@ -148,7 +147,7 @@ static struct of_device_id __initdata clock_board_match[] = {
 	{},
 };
 
-static struct of_platform_driver clock_board_driver = {
+static struct platform_driver clock_board_driver = {
 	.probe		= clock_board_probe,
 	.driver = {
 		.name = "clock_board",
@@ -157,8 +156,7 @@ static struct of_platform_driver clock_board_driver = {
 	},
 };
 
-static int __devinit fhc_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit fhc_probe(struct platform_device *op)
 {
 	struct fhc *p = kzalloc(sizeof(*p), GFP_KERNEL);
 	int err = -ENOMEM;
@@ -254,7 +252,7 @@ static struct of_device_id __initdata fhc_match[] = {
 	{},
 };
 
-static struct of_platform_driver fhc_driver = {
+static struct platform_driver fhc_driver = {
 	.probe		= fhc_probe,
 	.driver = {
 		.name = "fhc",
@@ -265,8 +263,8 @@ static struct of_platform_driver fhc_driver = {
 
 static int __init sunfire_init(void)
 {
-	(void) of_register_platform_driver(&fhc_driver);
-	(void) of_register_platform_driver(&clock_board_driver);
+	(void) platform_driver_register(&fhc_driver);
+	(void) platform_driver_register(&clock_board_driver);
 	return 0;
 }
 
diff --git a/arch/sparc/kernel/chmc.c b/arch/sparc/kernel/chmc.c
index 08c466e..668c7be 100644
--- a/arch/sparc/kernel/chmc.c
+++ b/arch/sparc/kernel/chmc.c
@@ -392,8 +392,7 @@ static void __devinit jbusmc_construct_dimm_groups(struct jbusmc *p,
 	}
 }
 
-static int __devinit jbusmc_probe(struct platform_device *op,
-				  const struct of_device_id *match)
+static int __devinit jbusmc_probe(struct platform_device *op)
 {
 	const struct linux_prom64_registers *mem_regs;
 	struct device_node *mem_node;
@@ -690,8 +689,7 @@ static void chmc_fetch_decode_regs(struct chmc *p)
 				      chmc_read_mcreg(p, CHMCTRL_DECODE4));
 }
 
-static int __devinit chmc_probe(struct platform_device *op,
-				const struct of_device_id *match)
+static int __devinit chmc_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	unsigned long ver;
@@ -765,13 +763,12 @@ out_free:
 	goto out;
 }
 
-static int __devinit us3mc_probe(struct platform_device *op,
-				const struct of_device_id *match)
+static int __devinit us3mc_probe(struct platform_device *op)
 {
 	if (mc_type == MC_TYPE_SAFARI)
-		return chmc_probe(op, match);
+		return chmc_probe(op);
 	else if (mc_type == MC_TYPE_JBUS)
-		return jbusmc_probe(op, match);
+		return jbusmc_probe(op);
 	return -ENODEV;
 }
 
@@ -810,7 +807,7 @@ static const struct of_device_id us3mc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, us3mc_match);
 
-static struct of_platform_driver us3mc_driver = {
+static struct platform_driver us3mc_driver = {
 	.driver = {
 		.name = "us3mc",
 		.owner = THIS_MODULE,
@@ -848,7 +845,7 @@ static int __init us3mc_init(void)
 	ret = register_dimm_printer(us3mc_dimm_printer);
 
 	if (!ret) {
-		ret = of_register_platform_driver(&us3mc_driver);
+		ret = platform_driver_register(&us3mc_driver);
 		if (ret)
 			unregister_dimm_printer(us3mc_dimm_printer);
 	}
@@ -859,7 +856,7 @@ static void __exit us3mc_cleanup(void)
 {
 	if (us3mc_platform()) {
 		unregister_dimm_printer(us3mc_dimm_printer);
-		of_unregister_platform_driver(&us3mc_driver);
+		platform_driver_unregister(&us3mc_driver);
 	}
 }
 
diff --git a/arch/sparc/kernel/pci_fire.c b/arch/sparc/kernel/pci_fire.c
index efb896d..be5e244 100644
--- a/arch/sparc/kernel/pci_fire.c
+++ b/arch/sparc/kernel/pci_fire.c
@@ -455,8 +455,7 @@ static int __devinit pci_fire_pbm_init(struct pci_pbm_info *pbm,
 	return 0;
 }
 
-static int __devinit fire_probe(struct platform_device *op,
-				const struct of_device_id *match)
+static int __devinit fire_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct pci_pbm_info *pbm;
@@ -507,7 +506,7 @@ static struct of_device_id __initdata fire_match[] = {
 	{},
 };
 
-static struct of_platform_driver fire_driver = {
+static struct platform_driver fire_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -518,7 +517,7 @@ static struct of_platform_driver fire_driver = {
 
 static int __init fire_init(void)
 {
-	return of_register_platform_driver(&fire_driver);
+	return platform_driver_register(&fire_driver);
 }
 
 subsys_initcall(fire_init);
diff --git a/arch/sparc/kernel/pci_psycho.c b/arch/sparc/kernel/pci_psycho.c
index 22eab7c..56ee745 100644
--- a/arch/sparc/kernel/pci_psycho.c
+++ b/arch/sparc/kernel/pci_psycho.c
@@ -503,8 +503,7 @@ static struct pci_pbm_info * __devinit psycho_find_sibling(u32 upa_portid)
 
 #define PSYCHO_CONFIGSPACE	0x001000000UL
 
-static int __devinit psycho_probe(struct platform_device *op,
-				  const struct of_device_id *match)
+static int __devinit psycho_probe(struct platform_device *op)
 {
 	const struct linux_prom64_registers *pr_regs;
 	struct device_node *dp = op->dev.of_node;
@@ -601,7 +600,7 @@ static struct of_device_id __initdata psycho_match[] = {
 	{},
 };
 
-static struct of_platform_driver psycho_driver = {
+static struct platform_driver psycho_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -612,7 +611,7 @@ static struct of_platform_driver psycho_driver = {
 
 static int __init psycho_init(void)
 {
-	return of_register_platform_driver(&psycho_driver);
+	return platform_driver_register(&psycho_driver);
 }
 
 subsys_initcall(psycho_init);
diff --git a/arch/sparc/kernel/pci_sabre.c b/arch/sparc/kernel/pci_sabre.c
index 5c3f5ec..2857073 100644
--- a/arch/sparc/kernel/pci_sabre.c
+++ b/arch/sparc/kernel/pci_sabre.c
@@ -452,8 +452,7 @@ static void __devinit sabre_pbm_init(struct pci_pbm_info *pbm,
 	sabre_scan_bus(pbm, &op->dev);
 }
 
-static int __devinit sabre_probe(struct platform_device *op,
-				 const struct of_device_id *match)
+static int __devinit sabre_probe(struct platform_device *op)
 {
 	const struct linux_prom64_registers *pr_regs;
 	struct device_node *dp = op->dev.of_node;
@@ -464,7 +463,7 @@ static int __devinit sabre_probe(struct platform_device *op,
 	const u32 *vdma;
 	u64 clear_irq;
 
-	hummingbird_p = (match->data != NULL);
+	hummingbird_p = op->dev.of_match && (op->dev.of_match->data != NULL);
 	if (!hummingbird_p) {
 		struct device_node *cpu_dp;
 
@@ -595,7 +594,7 @@ static struct of_device_id __initdata sabre_match[] = {
 	{},
 };
 
-static struct of_platform_driver sabre_driver = {
+static struct platform_driver sabre_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -606,7 +605,7 @@ static struct of_platform_driver sabre_driver = {
 
 static int __init sabre_init(void)
 {
-	return of_register_platform_driver(&sabre_driver);
+	return platform_driver_register(&sabre_driver);
 }
 
 subsys_initcall(sabre_init);
diff --git a/arch/sparc/kernel/pci_schizo.c b/arch/sparc/kernel/pci_schizo.c
index 445a47a..6783410 100644
--- a/arch/sparc/kernel/pci_schizo.c
+++ b/arch/sparc/kernel/pci_schizo.c
@@ -1460,10 +1460,11 @@ out_err:
 	return err;
 }
 
-static int __devinit schizo_probe(struct platform_device *op,
-				  const struct of_device_id *match)
+static int __devinit schizo_probe(struct platform_device *op)
 {
-	return __schizo_init(op, (unsigned long) match->data);
+	if (!op->dev.of_match)
+		return -EINVAL;
+	return __schizo_init(op, (unsigned long) op->dev.of_match->data);
 }
 
 /* The ordering of this table is very important.  Some Tomatillo
@@ -1490,7 +1491,7 @@ static struct of_device_id __initdata schizo_match[] = {
 	{},
 };
 
-static struct of_platform_driver schizo_driver = {
+static struct platform_driver schizo_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -1501,7 +1502,7 @@ static struct of_platform_driver schizo_driver = {
 
 static int __init schizo_init(void)
 {
-	return of_register_platform_driver(&schizo_driver);
+	return platform_driver_register(&schizo_driver);
 }
 
 subsys_initcall(schizo_init);
diff --git a/arch/sparc/kernel/pci_sun4v.c b/arch/sparc/kernel/pci_sun4v.c
index 743344a..158cd73 100644
--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -918,8 +918,7 @@ static int __devinit pci_sun4v_pbm_init(struct pci_pbm_info *pbm,
 	return 0;
 }
 
-static int __devinit pci_sun4v_probe(struct platform_device *op,
-				     const struct of_device_id *match)
+static int __devinit pci_sun4v_probe(struct platform_device *op)
 {
 	const struct linux_prom64_registers *regs;
 	static int hvapi_negotiated = 0;
@@ -1008,7 +1007,7 @@ static struct of_device_id __initdata pci_sun4v_match[] = {
 	{},
 };
 
-static struct of_platform_driver pci_sun4v_driver = {
+static struct platform_driver pci_sun4v_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -1019,7 +1018,7 @@ static struct of_platform_driver pci_sun4v_driver = {
 
 static int __init pci_sun4v_init(void)
 {
-	return of_register_platform_driver(&pci_sun4v_driver);
+	return platform_driver_register(&pci_sun4v_driver);
 }
 
 subsys_initcall(pci_sun4v_init);
diff --git a/arch/sparc/kernel/pmc.c b/arch/sparc/kernel/pmc.c
index 94536a8..93d7b44 100644
--- a/arch/sparc/kernel/pmc.c
+++ b/arch/sparc/kernel/pmc.c
@@ -51,8 +51,7 @@ static void pmc_swift_idle(void)
 #endif
 }
 
-static int __devinit pmc_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit pmc_probe(struct platform_device *op)
 {
 	regs = of_ioremap(&op->resource[0], 0,
 			  resource_size(&op->resource[0]), PMC_OBPNAME);
@@ -78,7 +77,7 @@ static struct of_device_id __initdata pmc_match[] = {
 };
 MODULE_DEVICE_TABLE(of, pmc_match);
 
-static struct of_platform_driver pmc_driver = {
+static struct platform_driver pmc_driver = {
 	.driver = {
 		.name = "pmc",
 		.owner = THIS_MODULE,
@@ -89,7 +88,7 @@ static struct of_platform_driver pmc_driver = {
 
 static int __init pmc_init(void)
 {
-	return of_register_platform_driver(&pmc_driver);
+	return platform_driver_register(&pmc_driver);
 }
 
 /* This driver is not critical to the boot process
diff --git a/arch/sparc/kernel/power.c b/arch/sparc/kernel/power.c
index 2c59f4d..cd725fe 100644
--- a/arch/sparc/kernel/power.c
+++ b/arch/sparc/kernel/power.c
@@ -33,7 +33,7 @@ static int __devinit has_button_interrupt(unsigned int irq, struct device_node *
 	return 1;
 }
 
-static int __devinit power_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit power_probe(struct platform_device *op)
 {
 	struct resource *res = &op->resource[0];
 	unsigned int irq = op->archdata.irqs[0];
@@ -59,7 +59,7 @@ static struct of_device_id __initdata power_match[] = {
 	{},
 };
 
-static struct of_platform_driver power_driver = {
+static struct platform_driver power_driver = {
 	.probe		= power_probe,
 	.driver = {
 		.name = "power",
@@ -70,7 +70,7 @@ static struct of_platform_driver power_driver = {
 
 static int __init power_init(void)
 {
-	return of_register_platform_driver(&power_driver);
+	return platform_driver_register(&power_driver);
 }
 
 device_initcall(power_init);
diff --git a/arch/sparc/kernel/time_32.c b/arch/sparc/kernel/time_32.c
index 9c743b1..23ccd73 100644
--- a/arch/sparc/kernel/time_32.c
+++ b/arch/sparc/kernel/time_32.c
@@ -142,7 +142,7 @@ static struct platform_device m48t59_rtc = {
 	},
 };
 
-static int __devinit clock_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit clock_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	const char *model = of_get_property(dp, "model", NULL);
@@ -176,7 +176,7 @@ static struct of_device_id __initdata clock_match[] = {
 	{},
 };
 
-static struct of_platform_driver clock_driver = {
+static struct platform_driver clock_driver = {
 	.probe		= clock_probe,
 	.driver = {
 		.name = "rtc",
@@ -189,7 +189,7 @@ static struct of_platform_driver clock_driver = {
 /* Probe for the mostek real time clock chip. */
 static int __init clock_init(void)
 {
-	return of_register_platform_driver(&clock_driver);
+	return platform_driver_register(&clock_driver);
 }
 /* Must be after subsys_initcall() so that busses are probed.  Must
  * be before device_initcall() because things like the RTC driver
diff --git a/arch/sparc/kernel/time_64.c b/arch/sparc/kernel/time_64.c
index 3bc9c99..e186279 100644
--- a/arch/sparc/kernel/time_64.c
+++ b/arch/sparc/kernel/time_64.c
@@ -419,7 +419,7 @@ static struct platform_device rtc_cmos_device = {
 	.num_resources	= 1,
 };
 
-static int __devinit rtc_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit rtc_probe(struct platform_device *op)
 {
 	struct resource *r;
 
@@ -462,7 +462,7 @@ static struct of_device_id __initdata rtc_match[] = {
 	{},
 };
 
-static struct of_platform_driver rtc_driver = {
+static struct platform_driver rtc_driver = {
 	.probe		= rtc_probe,
 	.driver = {
 		.name = "rtc",
@@ -477,7 +477,7 @@ static struct platform_device rtc_bq4802_device = {
 	.num_resources	= 1,
 };
 
-static int __devinit bq4802_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit bq4802_probe(struct platform_device *op)
 {
 
 	printk(KERN_INFO "%s: BQ4802 regs at 0x%llx\n",
@@ -495,7 +495,7 @@ static struct of_device_id __initdata bq4802_match[] = {
 	{},
 };
 
-static struct of_platform_driver bq4802_driver = {
+static struct platform_driver bq4802_driver = {
 	.probe		= bq4802_probe,
 	.driver = {
 		.name = "bq4802",
@@ -534,7 +534,7 @@ static struct platform_device m48t59_rtc = {
 	},
 };
 
-static int __devinit mostek_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit mostek_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 
@@ -559,7 +559,7 @@ static struct of_device_id __initdata mostek_match[] = {
 	{},
 };
 
-static struct of_platform_driver mostek_driver = {
+static struct platform_driver mostek_driver = {
 	.probe		= mostek_probe,
 	.driver = {
 		.name = "mostek",
@@ -586,9 +586,9 @@ static int __init clock_init(void)
 	if (tlb_type == hypervisor)
 		return platform_device_register(&rtc_sun4v_device);
 
-	(void) of_register_platform_driver(&rtc_driver);
-	(void) of_register_platform_driver(&mostek_driver);
-	(void) of_register_platform_driver(&bq4802_driver);
+	(void) platform_driver_register(&rtc_driver);
+	(void) platform_driver_register(&mostek_driver);
+	(void) platform_driver_register(&bq4802_driver);
 
 	return 0;
 }
diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index a3f5e38..43ac619 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -619,15 +619,17 @@ static void __devinit n2rng_driver_version(void)
 		pr_info("%s", version);
 }
 
-static int __devinit n2rng_probe(struct platform_device *op,
-				 const struct of_device_id *match)
+static int __devinit n2rng_probe(struct platform_device *op)
 {
-	int victoria_falls = (match->data != NULL);
+	int victoria_falls;
 	int err = -ENOMEM;
 	struct n2rng *np;
 
-	n2rng_driver_version();
+	if (!op->dev.of_match)
+		return -EINVAL;
+	victoria_falls = (op->dev.of_match->data != NULL);
 
+	n2rng_driver_version();
 	np = kzalloc(sizeof(*np), GFP_KERNEL);
 	if (!np)
 		goto out;
@@ -750,7 +752,7 @@ static const struct of_device_id n2rng_match[] = {
 };
 MODULE_DEVICE_TABLE(of, n2rng_match);
 
-static struct of_platform_driver n2rng_driver = {
+static struct platform_driver n2rng_driver = {
 	.driver = {
 		.name = "n2rng",
 		.owner = THIS_MODULE,
@@ -762,12 +764,12 @@ static struct of_platform_driver n2rng_driver = {
 
 static int __init n2rng_init(void)
 {
-	return of_register_platform_driver(&n2rng_driver);
+	return platform_driver_register(&n2rng_driver);
 }
 
 static void __exit n2rng_exit(void)
 {
-	of_unregister_platform_driver(&n2rng_driver);
+	platform_driver_unregister(&n2rng_driver);
 }
 
 module_init(n2rng_init);
diff --git a/drivers/crypto/n2_core.c b/drivers/crypto/n2_core.c
index 80dc094..2e5b204 100644
--- a/drivers/crypto/n2_core.c
+++ b/drivers/crypto/n2_core.c
@@ -2004,8 +2004,7 @@ static void __devinit n2_spu_driver_version(void)
 		pr_info("%s", version);
 }
 
-static int __devinit n2_crypto_probe(struct platform_device *dev,
-				     const struct of_device_id *match)
+static int __devinit n2_crypto_probe(struct platform_device *dev)
 {
 	struct mdesc_handle *mdesc;
 	const char *full_name;
@@ -2116,8 +2115,7 @@ static void free_ncp(struct n2_mau *mp)
 	kfree(mp);
 }
 
-static int __devinit n2_mau_probe(struct platform_device *dev,
-				     const struct of_device_id *match)
+static int __devinit n2_mau_probe(struct platform_device *dev)
 {
 	struct mdesc_handle *mdesc;
 	const char *full_name;
@@ -2211,7 +2209,7 @@ static struct of_device_id n2_crypto_match[] = {
 
 MODULE_DEVICE_TABLE(of, n2_crypto_match);
 
-static struct of_platform_driver n2_crypto_driver = {
+static struct platform_driver n2_crypto_driver = {
 	.driver = {
 		.name		=	"n2cp",
 		.owner		=	THIS_MODULE,
@@ -2235,7 +2233,7 @@ static struct of_device_id n2_mau_match[] = {
 
 MODULE_DEVICE_TABLE(of, n2_mau_match);
 
-static struct of_platform_driver n2_mau_driver = {
+static struct platform_driver n2_mau_driver = {
 	.driver = {
 		.name		=	"ncp",
 		.owner		=	THIS_MODULE,
@@ -2247,20 +2245,20 @@ static struct of_platform_driver n2_mau_driver = {
 
 static int __init n2_init(void)
 {
-	int err = of_register_platform_driver(&n2_crypto_driver);
+	int err = platform_driver_register(&n2_crypto_driver);
 
 	if (!err) {
-		err = of_register_platform_driver(&n2_mau_driver);
+		err = platform_driver_register(&n2_mau_driver);
 		if (err)
-			of_unregister_platform_driver(&n2_crypto_driver);
+			platform_driver_unregister(&n2_crypto_driver);
 	}
 	return err;
 }
 
 static void __exit n2_exit(void)
 {
-	of_unregister_platform_driver(&n2_mau_driver);
-	of_unregister_platform_driver(&n2_crypto_driver);
+	platform_driver_unregister(&n2_mau_driver);
+	platform_driver_unregister(&n2_crypto_driver);
 }
 
 module_init(n2_init);
diff --git a/drivers/hwmon/ultra45_env.c b/drivers/hwmon/ultra45_env.c
index d863e13..1f36c63 100644
--- a/drivers/hwmon/ultra45_env.c
+++ b/drivers/hwmon/ultra45_env.c
@@ -234,8 +234,7 @@ static const struct attribute_group env_group = {
 	.attrs = env_attributes,
 };
 
-static int __devinit env_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit env_probe(struct platform_device *op)
 {
 	struct env *p = kzalloc(sizeof(*p), GFP_KERNEL);
 	int err = -ENOMEM;
@@ -299,7 +298,7 @@ static const struct of_device_id env_match[] = {
 };
 MODULE_DEVICE_TABLE(of, env_match);
 
-static struct of_platform_driver env_driver = {
+static struct platform_driver env_driver = {
 	.driver = {
 		.name = "ultra45_env",
 		.owner = THIS_MODULE,
@@ -311,12 +310,12 @@ static struct of_platform_driver env_driver = {
 
 static int __init env_init(void)
 {
-	return of_register_platform_driver(&env_driver);
+	return platform_driver_register(&env_driver);
 }
 
 static void __exit env_exit(void)
 {
-	of_unregister_platform_driver(&env_driver);
+	platform_driver_unregister(&env_driver);
 }
 
 module_init(env_init);
diff --git a/drivers/input/misc/sparcspkr.c b/drivers/input/misc/sparcspkr.c
index 8e130bf..0122f53 100644
--- a/drivers/input/misc/sparcspkr.c
+++ b/drivers/input/misc/sparcspkr.c
@@ -173,18 +173,16 @@ static int __devinit sparcspkr_probe(struct device *dev)
 	return 0;
 }
 
-static int sparcspkr_shutdown(struct platform_device *dev)
+static void sparcspkr_shutdown(struct platform_device *dev)
 {
 	struct sparcspkr_state *state = dev_get_drvdata(&dev->dev);
 	struct input_dev *input_dev = state->input_dev;
 
 	/* turn off the speaker */
 	state->event(input_dev, EV_SND, SND_BELL, 0);
-
-	return 0;
 }
 
-static int __devinit bbc_beep_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit bbc_beep_probe(struct platform_device *op)
 {
 	struct sparcspkr_state *state;
 	struct bbc_beep_info *info;
@@ -258,7 +256,7 @@ static const struct of_device_id bbc_beep_match[] = {
 	{},
 };
 
-static struct of_platform_driver bbc_beep_driver = {
+static struct platform_driver bbc_beep_driver = {
 	.driver = {
 		.name = "bbcbeep",
 		.owner = THIS_MODULE,
@@ -269,7 +267,7 @@ static struct of_platform_driver bbc_beep_driver = {
 	.shutdown	= sparcspkr_shutdown,
 };
 
-static int __devinit grover_beep_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit grover_beep_probe(struct platform_device *op)
 {
 	struct sparcspkr_state *state;
 	struct grover_beep_info *info;
@@ -340,7 +338,7 @@ static const struct of_device_id grover_beep_match[] = {
 	{},
 };
 
-static struct of_platform_driver grover_beep_driver = {
+static struct platform_driver grover_beep_driver = {
 	.driver = {
 		.name = "groverbeep",
 		.owner = THIS_MODULE,
@@ -353,12 +351,12 @@ static struct of_platform_driver grover_beep_driver = {
 
 static int __init sparcspkr_init(void)
 {
-	int err = of_register_platform_driver(&bbc_beep_driver);
+	int err = platform_driver_register(&bbc_beep_driver);
 
 	if (!err) {
-		err = of_register_platform_driver(&grover_beep_driver);
+		err = platform_driver_register(&grover_beep_driver);
 		if (err)
-			of_unregister_platform_driver(&bbc_beep_driver);
+			platform_driver_unregister(&bbc_beep_driver);
 	}
 
 	return err;
@@ -366,8 +364,8 @@ static int __init sparcspkr_init(void)
 
 static void __exit sparcspkr_exit(void)
 {
-	of_unregister_platform_driver(&bbc_beep_driver);
-	of_unregister_platform_driver(&grover_beep_driver);
+	platform_driver_unregister(&bbc_beep_driver);
+	platform_driver_unregister(&grover_beep_driver);
 }
 
 module_init(sparcspkr_init);
diff --git a/drivers/input/serio/i8042-sparcio.h b/drivers/input/serio/i8042-sparcio.h
index c5cc450..395a9af 100644
--- a/drivers/input/serio/i8042-sparcio.h
+++ b/drivers/input/serio/i8042-sparcio.h
@@ -49,7 +49,7 @@ static inline void i8042_write_command(int val)
 #define OBP_PS2MS_NAME1		"kdmouse"
 #define OBP_PS2MS_NAME2		"mouse"
 
-static int __devinit sparc_i8042_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit sparc_i8042_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 
@@ -95,7 +95,7 @@ static const struct of_device_id sparc_i8042_match[] = {
 };
 MODULE_DEVICE_TABLE(of, sparc_i8042_match);
 
-static struct of_platform_driver sparc_i8042_driver = {
+static struct platform_driver sparc_i8042_driver = {
 	.driver = {
 		.name = "i8042",
 		.owner = THIS_MODULE,
@@ -116,7 +116,7 @@ static int __init i8042_platform_init(void)
 		if (!kbd_iobase)
 			return -ENODEV;
 	} else {
-		int err = of_register_platform_driver(&sparc_i8042_driver);
+		int err = platform_driver_register(&sparc_i8042_driver);
 		if (err)
 			return err;
 
@@ -140,7 +140,7 @@ static inline void i8042_platform_exit(void)
 	struct device_node *root = of_find_node_by_path("/");
 
 	if (strcmp(root->name, "SUNW,JavaStation-1"))
-		of_unregister_platform_driver(&sparc_i8042_driver);
+		platform_driver_unregister(&sparc_i8042_driver);
 }
 
 #else /* !CONFIG_PCI */
diff --git a/drivers/parport/parport_sunbpp.c b/drivers/parport/parport_sunbpp.c
index 55ba118..910c5a2 100644
--- a/drivers/parport/parport_sunbpp.c
+++ b/drivers/parport/parport_sunbpp.c
@@ -286,7 +286,7 @@ static struct parport_operations parport_sunbpp_ops =
 	.owner		= THIS_MODULE,
 };
 
-static int __devinit bpp_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit bpp_probe(struct platform_device *op)
 {
 	struct parport_operations *ops;
 	struct bpp_regs __iomem *regs;
@@ -381,7 +381,7 @@ static const struct of_device_id bpp_match[] = {
 
 MODULE_DEVICE_TABLE(of, bpp_match);
 
-static struct of_platform_driver bpp_sbus_driver = {
+static struct platform_driver bpp_sbus_driver = {
 	.driver = {
 		.name = "bpp",
 		.owner = THIS_MODULE,
@@ -393,12 +393,12 @@ static struct of_platform_driver bpp_sbus_driver = {
 
 static int __init parport_sunbpp_init(void)
 {
-	return of_register_platform_driver(&bpp_sbus_driver);
+	return platform_driver_register(&bpp_sbus_driver);
 }
 
 static void __exit parport_sunbpp_exit(void)
 {
-	of_unregister_platform_driver(&bpp_sbus_driver);
+	platform_driver_unregister(&bpp_sbus_driver);
 }
 
 MODULE_AUTHOR("Derrick J Brashear");
diff --git a/drivers/sbus/char/bbc_i2c.c b/drivers/sbus/char/bbc_i2c.c
index 614a5e1..5f94d22 100644
--- a/drivers/sbus/char/bbc_i2c.c
+++ b/drivers/sbus/char/bbc_i2c.c
@@ -361,8 +361,7 @@ fail:
 extern int bbc_envctrl_init(struct bbc_i2c_bus *bp);
 extern void bbc_envctrl_cleanup(struct bbc_i2c_bus *bp);
 
-static int __devinit bbc_i2c_probe(struct platform_device *op,
-				   const struct of_device_id *match)
+static int __devinit bbc_i2c_probe(struct platform_device *op)
 {
 	struct bbc_i2c_bus *bp;
 	int err, index = 0;
@@ -413,7 +412,7 @@ static const struct of_device_id bbc_i2c_match[] = {
 };
 MODULE_DEVICE_TABLE(of, bbc_i2c_match);
 
-static struct of_platform_driver bbc_i2c_driver = {
+static struct platform_driver bbc_i2c_driver = {
 	.driver = {
 		.name = "bbc_i2c",
 		.owner = THIS_MODULE,
@@ -425,12 +424,12 @@ static struct of_platform_driver bbc_i2c_driver = {
 
 static int __init bbc_i2c_init(void)
 {
-	return of_register_platform_driver(&bbc_i2c_driver);
+	return platform_driver_register(&bbc_i2c_driver);
 }
 
 static void __exit bbc_i2c_exit(void)
 {
-	of_unregister_platform_driver(&bbc_i2c_driver);
+	platform_driver_unregister(&bbc_i2c_driver);
 }
 
 module_init(bbc_i2c_init);
diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 55f71ea..740da44 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -171,8 +171,7 @@ static struct miscdevice d7s_miscdev = {
 	.fops		= &d7s_fops
 };
 
-static int __devinit d7s_probe(struct platform_device *op,
-			       const struct of_device_id *match)
+static int __devinit d7s_probe(struct platform_device *op)
 {
 	struct device_node *opts;
 	int err = -EINVAL;
@@ -266,7 +265,7 @@ static const struct of_device_id d7s_match[] = {
 };
 MODULE_DEVICE_TABLE(of, d7s_match);
 
-static struct of_platform_driver d7s_driver = {
+static struct platform_driver d7s_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -278,12 +277,12 @@ static struct of_platform_driver d7s_driver = {
 
 static int __init d7s_init(void)
 {
-	return of_register_platform_driver(&d7s_driver);
+	return platform_driver_register(&d7s_driver);
 }
 
 static void __exit d7s_exit(void)
 {
-	of_unregister_platform_driver(&d7s_driver);
+	platform_driver_unregister(&d7s_driver);
 }
 
 module_init(d7s_init);
diff --git a/drivers/sbus/char/envctrl.c b/drivers/sbus/char/envctrl.c
index 8ce414e..be7b4e5 100644
--- a/drivers/sbus/char/envctrl.c
+++ b/drivers/sbus/char/envctrl.c
@@ -1028,8 +1028,7 @@ static int kenvctrld(void *__unused)
 	return 0;
 }
 
-static int __devinit envctrl_probe(struct platform_device *op,
-				   const struct of_device_id *match)
+static int __devinit envctrl_probe(struct platform_device *op)
 {
 	struct device_node *dp;
 	int index, err;
@@ -1129,7 +1128,7 @@ static const struct of_device_id envctrl_match[] = {
 };
 MODULE_DEVICE_TABLE(of, envctrl_match);
 
-static struct of_platform_driver envctrl_driver = {
+static struct platform_driver envctrl_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -1141,12 +1140,12 @@ static struct of_platform_driver envctrl_driver = {
 
 static int __init envctrl_init(void)
 {
-	return of_register_platform_driver(&envctrl_driver);
+	return platform_driver_register(&envctrl_driver);
 }
 
 static void __exit envctrl_exit(void)
 {
-	of_unregister_platform_driver(&envctrl_driver);
+	platform_driver_unregister(&envctrl_driver);
 }
 
 module_init(envctrl_init);
diff --git a/drivers/sbus/char/flash.c b/drivers/sbus/char/flash.c
index 2b4b4b6..73dd4e7 100644
--- a/drivers/sbus/char/flash.c
+++ b/drivers/sbus/char/flash.c
@@ -160,8 +160,7 @@ static const struct file_operations flash_fops = {
 
 static struct miscdevice flash_dev = { FLASH_MINOR, "flash", &flash_fops };
 
-static int __devinit flash_probe(struct platform_device *op,
-				 const struct of_device_id *match)
+static int __devinit flash_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	struct device_node *parent;
@@ -207,7 +206,7 @@ static const struct of_device_id flash_match[] = {
 };
 MODULE_DEVICE_TABLE(of, flash_match);
 
-static struct of_platform_driver flash_driver = {
+static struct platform_driver flash_driver = {
 	.driver = {
 		.name = "flash",
 		.owner = THIS_MODULE,
@@ -219,12 +218,12 @@ static struct of_platform_driver flash_driver = {
 
 static int __init flash_init(void)
 {
-	return of_register_platform_driver(&flash_driver);
+	return platform_driver_register(&flash_driver);
 }
 
 static void __exit flash_cleanup(void)
 {
-	of_unregister_platform_driver(&flash_driver);
+	platform_driver_unregister(&flash_driver);
 }
 
 module_init(flash_init);
diff --git a/drivers/sbus/char/uctrl.c b/drivers/sbus/char/uctrl.c
index 1b345be..ebce963 100644
--- a/drivers/sbus/char/uctrl.c
+++ b/drivers/sbus/char/uctrl.c
@@ -348,8 +348,7 @@ static void uctrl_get_external_status(struct uctrl_driver *driver)
 	
 }
 
-static int __devinit uctrl_probe(struct platform_device *op,
-				 const struct of_device_id *match)
+static int __devinit uctrl_probe(struct platform_device *op)
 {
 	struct uctrl_driver *p;
 	int err = -ENOMEM;
@@ -425,7 +424,7 @@ static const struct of_device_id uctrl_match[] = {
 };
 MODULE_DEVICE_TABLE(of, uctrl_match);
 
-static struct of_platform_driver uctrl_driver = {
+static struct platform_driver uctrl_driver = {
 	.driver = {
 		.name = "uctrl",
 		.owner = THIS_MODULE,
@@ -438,12 +437,12 @@ static struct of_platform_driver uctrl_driver = {
 
 static int __init uctrl_init(void)
 {
-	return of_register_platform_driver(&uctrl_driver);
+	return platform_driver_register(&uctrl_driver);
 }
 
 static void __exit uctrl_exit(void)
 {
-	of_unregister_platform_driver(&uctrl_driver);
+	platform_driver_unregister(&uctrl_driver);
 }
 
 module_init(uctrl_init);
diff --git a/drivers/scsi/qlogicpti.c b/drivers/scsi/qlogicpti.c
index 664c957..e2d45c9 100644
--- a/drivers/scsi/qlogicpti.c
+++ b/drivers/scsi/qlogicpti.c
@@ -1292,15 +1292,19 @@ static struct scsi_host_template qpti_template = {
 	.use_clustering		= ENABLE_CLUSTERING,
 };
 
-static int __devinit qpti_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit qpti_sbus_probe(struct platform_device *op)
 {
-	struct scsi_host_template *tpnt = match->data;
+	struct scsi_host_template *tpnt;
 	struct device_node *dp = op->dev.of_node;
 	struct Scsi_Host *host;
 	struct qlogicpti *qpti;
 	static int nqptis;
 	const char *fcode;
 
+	if (!op->dev.of_match)
+		return -EINVAL;
+	tpnt = op->dev.of_match->data;
+
 	/* Sometimes Antares cards come up not completely
 	 * setup, and we get a report of a zero IRQ.
 	 */
@@ -1457,7 +1461,7 @@ static const struct of_device_id qpti_match[] = {
 };
 MODULE_DEVICE_TABLE(of, qpti_match);
 
-static struct of_platform_driver qpti_sbus_driver = {
+static struct platform_driver qpti_sbus_driver = {
 	.driver = {
 		.name = "qpti",
 		.owner = THIS_MODULE,
@@ -1469,12 +1473,12 @@ static struct of_platform_driver qpti_sbus_driver = {
 
 static int __init qpti_init(void)
 {
-	return of_register_platform_driver(&qpti_sbus_driver);
+	return platform_driver_register(&qpti_sbus_driver);
 }
 
 static void __exit qpti_exit(void)
 {
-	of_unregister_platform_driver(&qpti_sbus_driver);
+	platform_driver_unregister(&qpti_sbus_driver);
 }
 
 MODULE_DESCRIPTION("QlogicISP SBUS driver");
diff --git a/drivers/scsi/sun_esp.c b/drivers/scsi/sun_esp.c
index 193b37b..676fe9a 100644
--- a/drivers/scsi/sun_esp.c
+++ b/drivers/scsi/sun_esp.c
@@ -562,7 +562,7 @@ fail:
 	return err;
 }
 
-static int __devinit esp_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit esp_sbus_probe(struct platform_device *op)
 {
 	struct device_node *dma_node = NULL;
 	struct device_node *dp = op->dev.of_node;
@@ -632,7 +632,7 @@ static const struct of_device_id esp_match[] = {
 };
 MODULE_DEVICE_TABLE(of, esp_match);
 
-static struct of_platform_driver esp_sbus_driver = {
+static struct platform_driver esp_sbus_driver = {
 	.driver = {
 		.name = "esp",
 		.owner = THIS_MODULE,
@@ -644,12 +644,12 @@ static struct of_platform_driver esp_sbus_driver = {
 
 static int __init sunesp_init(void)
 {
-	return of_register_platform_driver(&esp_sbus_driver);
+	return platform_driver_register(&esp_sbus_driver);
 }
 
 static void __exit sunesp_exit(void)
 {
-	of_unregister_platform_driver(&esp_sbus_driver);
+	platform_driver_unregister(&esp_sbus_driver);
 }
 
 MODULE_DESCRIPTION("Sun ESP SCSI driver");

