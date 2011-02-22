Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753496Ab1BVU7d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:59:33 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:14023 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1BVU61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:58:27 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Cc: David Daney <ddaney@caviumnetworks.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: [RFC PATCH 08/10] netdev: mdio-octeon.c: Convert to use device tree.
Date: Tue, 22 Feb 2011 12:57:52 -0800
Message-Id: <1298408274-20856-9-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com>
X-OriginalArrivalTime: 22 Feb 2011 20:58:27.0457 (UTC) FILETIME=[40A35710:01CBD2D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get the MDIO bus controller addresses from the device tree.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
---
 arch/mips/cavium-octeon/octeon-platform.c |   30 ------------
 drivers/net/phy/mdio-octeon.c             |   73 +++++++++++++++++------------
 2 files changed, 43 insertions(+), 60 deletions(-)

diff --git a/arch/mips/cavium-octeon/octeon-platform.c b/arch/mips/cavium-octeon/octeon-platform.c
index f148324..a33dcf9 100644
--- a/arch/mips/cavium-octeon/octeon-platform.c
+++ b/arch/mips/cavium-octeon/octeon-platform.c
@@ -166,36 +166,6 @@ out:
 }
 device_initcall(octeon_rng_device_init);
 
-/* Octeon SMI/MDIO interface.  */
-static int __init octeon_mdiobus_device_init(void)
-{
-	struct platform_device *pd;
-	int ret = 0;
-
-	if (octeon_is_simulation())
-		return 0; /* No mdio in the simulator. */
-
-	/* The bus number is the platform_device id.  */
-	pd = platform_device_alloc("mdio-octeon", 0);
-	if (!pd) {
-		ret = -ENOMEM;
-		goto out;
-	}
-
-	ret = platform_device_add(pd);
-	if (ret)
-		goto fail;
-
-	return ret;
-fail:
-	platform_device_put(pd);
-
-out:
-	return ret;
-
-}
-device_initcall(octeon_mdiobus_device_init);
-
 /* Octeon mgmt port Ethernet interface.  */
 static int __init octeon_mgmt_device_init(void)
 {
diff --git a/drivers/net/phy/mdio-octeon.c b/drivers/net/phy/mdio-octeon.c
index bd12ba9..b04c18c 100644
--- a/drivers/net/phy/mdio-octeon.c
+++ b/drivers/net/phy/mdio-octeon.c
@@ -6,10 +6,14 @@
  * Copyright (C) 2009 Cavium Networks
  */
 
-#include <linux/gfp.h>
-#include <linux/init.h>
-#include <linux/module.h>
 #include <linux/platform_device.h>
+#include <linux/of_platform.h>
+#include <linux/of_address.h>
+#include <linux/of_mdio.h>
+#include <linux/delay.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/gfp.h>
 #include <linux/phy.h>
 
 #include <asm/octeon/octeon.h>
@@ -18,9 +22,15 @@
 #define DRV_VERSION "1.0"
 #define DRV_DESCRIPTION "Cavium Networks Octeon SMI/MDIO driver"
 
+#define SMI_CMD		0x0
+#define SMI_WR_DAT	0x8
+#define SMI_RD_DAT	0x10
+#define SMI_CLK		0x18
+#define SMI_EN		0x20
+
 struct octeon_mdiobus {
 	struct mii_bus *mii_bus;
-	int unit;
+	u64 register_base;
 	int phy_irq[PHY_MAX_ADDR];
 };
 
@@ -35,15 +45,15 @@ static int octeon_mdiobus_read(struct mii_bus *bus, int phy_id, int regnum)
 	smi_cmd.s.phy_op = 1; /* MDIO_CLAUSE_22_READ */
 	smi_cmd.s.phy_adr = phy_id;
 	smi_cmd.s.reg_adr = regnum;
-	cvmx_write_csr(CVMX_SMIX_CMD(p->unit), smi_cmd.u64);
+	cvmx_write_csr(p->register_base + SMI_CMD, smi_cmd.u64);
 
 	do {
 		/*
 		 * Wait 1000 clocks so we don't saturate the RSL bus
 		 * doing reads.
 		 */
-		cvmx_wait(1000);
-		smi_rd.u64 = cvmx_read_csr(CVMX_SMIX_RD_DAT(p->unit));
+		__delay(1000);
+		smi_rd.u64 = cvmx_read_csr(p->register_base + SMI_RD_DAT);
 	} while (smi_rd.s.pending && --timeout);
 
 	if (smi_rd.s.val)
@@ -62,21 +72,21 @@ static int octeon_mdiobus_write(struct mii_bus *bus, int phy_id,
 
 	smi_wr.u64 = 0;
 	smi_wr.s.dat = val;
-	cvmx_write_csr(CVMX_SMIX_WR_DAT(p->unit), smi_wr.u64);
+	cvmx_write_csr(p->register_base + SMI_WR_DAT, smi_wr.u64);
 
 	smi_cmd.u64 = 0;
 	smi_cmd.s.phy_op = 0; /* MDIO_CLAUSE_22_WRITE */
 	smi_cmd.s.phy_adr = phy_id;
 	smi_cmd.s.reg_adr = regnum;
-	cvmx_write_csr(CVMX_SMIX_CMD(p->unit), smi_cmd.u64);
+	cvmx_write_csr(p->register_base + SMI_CMD, smi_cmd.u64);
 
 	do {
 		/*
 		 * Wait 1000 clocks so we don't saturate the RSL bus
 		 * doing reads.
 		 */
-		cvmx_wait(1000);
-		smi_wr.u64 = cvmx_read_csr(CVMX_SMIX_WR_DAT(p->unit));
+		__delay(1000);
+		smi_wr.u64 = cvmx_read_csr(p->register_base + SMI_WR_DAT);
 	} while (smi_wr.s.pending && --timeout);
 
 	if (timeout <= 0)
@@ -85,11 +95,11 @@ static int octeon_mdiobus_write(struct mii_bus *bus, int phy_id,
 	return 0;
 }
 
-static int __devinit octeon_mdiobus_probe(struct platform_device *pdev)
+static int __devinit octeon_mdiobus_probe(struct platform_device *pdev,
+					  const struct of_device_id *match)
 {
 	struct octeon_mdiobus *bus;
 	union cvmx_smix_en smi_en;
-	int i;
 	int err = -ENOENT;
 
 	bus = devm_kzalloc(&pdev->dev, sizeof(*bus), GFP_KERNEL);
@@ -97,8 +107,7 @@ static int __devinit octeon_mdiobus_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	/* The platform_device id is our unit number.  */
-	bus->unit = pdev->id;
-
+	bus->register_base = (u64)of_iomap(pdev->dev.of_node, 0);
 	bus->mii_bus = mdiobus_alloc();
 
 	if (!bus->mii_bus)
@@ -106,19 +115,13 @@ static int __devinit octeon_mdiobus_probe(struct platform_device *pdev)
 
 	smi_en.u64 = 0;
 	smi_en.s.en = 1;
-	cvmx_write_csr(CVMX_SMIX_EN(bus->unit), smi_en.u64);
+	cvmx_write_csr(bus->register_base + SMI_EN, smi_en.u64);
 
-	/*
-	 * Standard Octeon evaluation boards don't support phy
-	 * interrupts, we need to poll.
-	 */
-	for (i = 0; i < PHY_MAX_ADDR; i++)
-		bus->phy_irq[i] = PHY_POLL;
 
 	bus->mii_bus->priv = bus;
 	bus->mii_bus->irq = bus->phy_irq;
 	bus->mii_bus->name = "mdio-octeon";
-	snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%x", bus->unit);
+	snprintf(bus->mii_bus->id, MII_BUS_ID_SIZE, "%llx", bus->register_base);
 	bus->mii_bus->parent = &pdev->dev;
 
 	bus->mii_bus->read = octeon_mdiobus_read;
@@ -126,7 +129,7 @@ static int __devinit octeon_mdiobus_probe(struct platform_device *pdev)
 
 	dev_set_drvdata(&pdev->dev, bus);
 
-	err = mdiobus_register(bus->mii_bus);
+	err = of_mdiobus_register(bus->mii_bus, pdev->dev.of_node);
 	if (err)
 		goto err_register;
 
@@ -137,9 +140,9 @@ err_register:
 	mdiobus_free(bus->mii_bus);
 
 err:
-	devm_kfree(&pdev->dev, bus);
 	smi_en.u64 = 0;
-	cvmx_write_csr(CVMX_SMIX_EN(bus->unit), smi_en.u64);
+	cvmx_write_csr(bus->register_base + SMI_EN, smi_en.u64);
+	devm_kfree(&pdev->dev, bus);
 	return err;
 }
 
@@ -153,14 +156,24 @@ static int __devexit octeon_mdiobus_remove(struct platform_device *pdev)
 	mdiobus_unregister(bus->mii_bus);
 	mdiobus_free(bus->mii_bus);
 	smi_en.u64 = 0;
-	cvmx_write_csr(CVMX_SMIX_EN(bus->unit), smi_en.u64);
+	cvmx_write_csr(bus->register_base + SMI_EN, smi_en.u64);
+	devm_kfree(&pdev->dev, bus);
 	return 0;
 }
 
-static struct platform_driver octeon_mdiobus_driver = {
+static struct of_device_id octeon_mdiobus_match[] = {
+	{
+		.compatible = "octeon,mdio",
+	},
+	{},
+};
+MODULE_DEVICE_TABLE(of, octeon_mdiobus_match);
+
+static struct of_platform_driver octeon_mdiobus_driver = {
 	.driver = {
 		.name		= "mdio-octeon",
 		.owner		= THIS_MODULE,
+		.of_match_table = octeon_mdiobus_match,
 	},
 	.probe		= octeon_mdiobus_probe,
 	.remove		= __devexit_p(octeon_mdiobus_remove),
@@ -174,12 +187,12 @@ EXPORT_SYMBOL(octeon_mdiobus_force_mod_depencency);
 
 static int __init octeon_mdiobus_mod_init(void)
 {
-	return platform_driver_register(&octeon_mdiobus_driver);
+	return of_register_platform_driver(&octeon_mdiobus_driver);
 }
 
 static void __exit octeon_mdiobus_mod_exit(void)
 {
-	platform_driver_unregister(&octeon_mdiobus_driver);
+	of_unregister_platform_driver(&octeon_mdiobus_driver);
 }
 
 module_init(octeon_mdiobus_mod_init);
-- 
1.7.2.3

