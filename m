Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754920Ab1BWEeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:34:36 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49687 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754817Ab1BWEea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:34:30 -0500
Subject: [RFC PATCH 10/15] dt/net: Eliminate users of of_platform_{,
	un}register_driver
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net
From: Grant Likely <grant.likely@secretlab.ca>
Cc: sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Date: Tue, 22 Feb 2011 21:34:26 -0700
Message-ID: <20110223043426.20795.51068.stgit@localhost6.localdomain6>
In-Reply-To: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Get rid of users of of_platform_driver in drivers/net.  The
of_platform_{,un}register_driver functions are going away, so the
users need to be converted to using the platform_bus_type directly.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
---
 drivers/net/can/mscan/mpc5xxx_can.c           |   15 +++++++++------
 drivers/net/can/sja1000/sja1000_of_platform.c |    9 ++++-----
 drivers/net/fec_mpc52xx.c                     |   13 ++++++-------
 drivers/net/fec_mpc52xx.h                     |    2 +-
 drivers/net/fec_mpc52xx_phy.c                 |    5 ++---
 drivers/net/fs_enet/fs_enet-main.c            |   16 +++++++++-------
 drivers/net/fs_enet/mii-bitbang.c             |    9 ++++-----
 drivers/net/fs_enet/mii-fec.c                 |   15 +++++++++------
 drivers/net/fsl_pq_mdio.c                     |    9 ++++-----
 drivers/net/gianfar.c                         |   12 +++++-------
 drivers/net/greth.c                           |    8 ++++----
 drivers/net/ibm_newemac/core.c                |    9 ++++-----
 drivers/net/ibm_newemac/mal.c                 |    9 ++++-----
 drivers/net/ibm_newemac/rgmii.c               |    9 ++++-----
 drivers/net/ibm_newemac/tah.c                 |    9 ++++-----
 drivers/net/ibm_newemac/zmii.c                |    9 ++++-----
 drivers/net/ll_temac_main.c                   |    9 ++++-----
 drivers/net/myri_sbus.c                       |    8 ++++----
 drivers/net/niu.c                             |   11 +++++------
 drivers/net/phy/mdio-gpio.c                   |    9 ++++-----
 drivers/net/sunbmac.c                         |    9 ++++-----
 drivers/net/sunhme.c                          |   14 +++++++++-----
 drivers/net/sunlance.c                        |    8 ++++----
 drivers/net/sunqe.c                           |    8 ++++----
 drivers/net/ucc_geth.c                        |    8 ++++----
 drivers/net/xilinx_emaclite.c                 |    9 ++++-----
 26 files changed, 123 insertions(+), 128 deletions(-)

diff --git a/drivers/net/can/mscan/mpc5xxx_can.c b/drivers/net/can/mscan/mpc5xxx_can.c
index 312b9c8..c0a1bc5 100644
--- a/drivers/net/can/mscan/mpc5xxx_can.c
+++ b/drivers/net/can/mscan/mpc5xxx_can.c
@@ -247,10 +247,9 @@ static u32 __devinit mpc512x_can_get_clock(struct platform_device *ofdev,
 }
 #endif /* CONFIG_PPC_MPC512x */
 
-static int __devinit mpc5xxx_can_probe(struct platform_device *ofdev,
-				       const struct of_device_id *id)
+static int __devinit mpc5xxx_can_probe(struct platform_device *ofdev)
 {
-	struct mpc5xxx_can_data *data = (struct mpc5xxx_can_data *)id->data;
+	struct mpc5xxx_can_data *data;
 	struct device_node *np = ofdev->dev.of_node;
 	struct net_device *dev;
 	struct mscan_priv *priv;
@@ -259,6 +258,10 @@ static int __devinit mpc5xxx_can_probe(struct platform_device *ofdev,
 	int irq, mscan_clksrc = 0;
 	int err = -ENOMEM;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+	data = (struct mpc5xxx_can_data *)of_dev->dev.of_match->data;
+
 	base = of_iomap(np, 0);
 	if (!base) {
 		dev_err(&ofdev->dev, "couldn't ioremap\n");
@@ -391,7 +394,7 @@ static struct of_device_id __devinitdata mpc5xxx_can_table[] = {
 	{},
 };
 
-static struct of_platform_driver mpc5xxx_can_driver = {
+static struct platform_driver mpc5xxx_can_driver = {
 	.driver = {
 		.name = "mpc5xxx_can",
 		.owner = THIS_MODULE,
@@ -407,13 +410,13 @@ static struct of_platform_driver mpc5xxx_can_driver = {
 
 static int __init mpc5xxx_can_init(void)
 {
-	return of_register_platform_driver(&mpc5xxx_can_driver);
+	return platform_driver_register(&mpc5xxx_can_driver);
 }
 module_init(mpc5xxx_can_init);
 
 static void __exit mpc5xxx_can_exit(void)
 {
-	return of_unregister_platform_driver(&mpc5xxx_can_driver);
+	platform_driver_unregister(&mpc5xxx_can_driver);
 };
 module_exit(mpc5xxx_can_exit);
 
diff --git a/drivers/net/can/sja1000/sja1000_of_platform.c b/drivers/net/can/sja1000/sja1000_of_platform.c
index 09c3e9d..9793df6 100644
--- a/drivers/net/can/sja1000/sja1000_of_platform.c
+++ b/drivers/net/can/sja1000/sja1000_of_platform.c
@@ -87,8 +87,7 @@ static int __devexit sja1000_ofp_remove(struct platform_device *ofdev)
 	return 0;
 }
 
-static int __devinit sja1000_ofp_probe(struct platform_device *ofdev,
-				       const struct of_device_id *id)
+static int __devinit sja1000_ofp_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct net_device *dev;
@@ -210,7 +209,7 @@ static struct of_device_id __devinitdata sja1000_ofp_table[] = {
 };
 MODULE_DEVICE_TABLE(of, sja1000_ofp_table);
 
-static struct of_platform_driver sja1000_ofp_driver = {
+static struct platform_driver sja1000_ofp_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = DRV_NAME,
@@ -222,12 +221,12 @@ static struct of_platform_driver sja1000_ofp_driver = {
 
 static int __init sja1000_ofp_init(void)
 {
-	return of_register_platform_driver(&sja1000_ofp_driver);
+	return platform_driver_register(&sja1000_ofp_driver);
 }
 module_init(sja1000_ofp_init);
 
 static void __exit sja1000_ofp_exit(void)
 {
-	return of_unregister_platform_driver(&sja1000_ofp_driver);
+	return platform_driver_unregister(&sja1000_ofp_driver);
 };
 module_exit(sja1000_ofp_exit);
diff --git a/drivers/net/fec_mpc52xx.c b/drivers/net/fec_mpc52xx.c
index 50c1213..9f81b1a 100644
--- a/drivers/net/fec_mpc52xx.c
+++ b/drivers/net/fec_mpc52xx.c
@@ -840,8 +840,7 @@ static const struct net_device_ops mpc52xx_fec_netdev_ops = {
 /* OF Driver                                                                */
 /* ======================================================================== */
 
-static int __devinit
-mpc52xx_fec_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit mpc52xx_fec_probe(struct platform_device *op)
 {
 	int rv;
 	struct net_device *ndev;
@@ -1049,7 +1048,7 @@ static struct of_device_id mpc52xx_fec_match[] = {
 
 MODULE_DEVICE_TABLE(of, mpc52xx_fec_match);
 
-static struct of_platform_driver mpc52xx_fec_driver = {
+static struct platform_driver mpc52xx_fec_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -1073,21 +1072,21 @@ mpc52xx_fec_init(void)
 {
 #ifdef CONFIG_FEC_MPC52xx_MDIO
 	int ret;
-	ret = of_register_platform_driver(&mpc52xx_fec_mdio_driver);
+	ret = platform_driver_register(&mpc52xx_fec_mdio_driver);
 	if (ret) {
 		printk(KERN_ERR DRIVER_NAME ": failed to register mdio driver\n");
 		return ret;
 	}
 #endif
-	return of_register_platform_driver(&mpc52xx_fec_driver);
+	return platform_driver_register(&mpc52xx_fec_driver);
 }
 
 static void __exit
 mpc52xx_fec_exit(void)
 {
-	of_unregister_platform_driver(&mpc52xx_fec_driver);
+	platform_driver_unregister(&mpc52xx_fec_driver);
 #ifdef CONFIG_FEC_MPC52xx_MDIO
-	of_unregister_platform_driver(&mpc52xx_fec_mdio_driver);
+	platform_driver_unregister(&mpc52xx_fec_mdio_driver);
 #endif
 }
 
diff --git a/drivers/net/fec_mpc52xx.h b/drivers/net/fec_mpc52xx.h
index a227a52..41d2dff 100644
--- a/drivers/net/fec_mpc52xx.h
+++ b/drivers/net/fec_mpc52xx.h
@@ -289,6 +289,6 @@ struct mpc52xx_fec {
 #define FEC_XMIT_FSM_ENABLE_CRC		0x01000000
 
 
-extern struct of_platform_driver mpc52xx_fec_mdio_driver;
+extern struct platform_driver mpc52xx_fec_mdio_driver;
 
 #endif	/* __DRIVERS_NET_MPC52XX_FEC_H__ */
diff --git a/drivers/net/fec_mpc52xx_phy.c b/drivers/net/fec_mpc52xx_phy.c
index 0b4cb6f..360a578 100644
--- a/drivers/net/fec_mpc52xx_phy.c
+++ b/drivers/net/fec_mpc52xx_phy.c
@@ -61,8 +61,7 @@ static int mpc52xx_fec_mdio_write(struct mii_bus *bus, int phy_id, int reg,
 		data | FEC_MII_WRITE_FRAME);
 }
 
-static int mpc52xx_fec_mdio_probe(struct platform_device *of,
-		const struct of_device_id *match)
+static int mpc52xx_fec_mdio_probe(struct platform_device *of)
 {
 	struct device *dev = &of->dev;
 	struct device_node *np = of->dev.of_node;
@@ -145,7 +144,7 @@ static struct of_device_id mpc52xx_fec_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mpc52xx_fec_mdio_match);
 
-struct of_platform_driver mpc52xx_fec_mdio_driver = {
+struct platform_driver mpc52xx_fec_mdio_driver = {
 	.driver = {
 		.name = "mpc5200b-fec-phy",
 		.owner = THIS_MODULE,
diff --git a/drivers/net/fs_enet/fs_enet-main.c b/drivers/net/fs_enet/fs_enet-main.c
index 7a1f3d0..24cb953 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -998,8 +998,7 @@ static const struct net_device_ops fs_enet_netdev_ops = {
 #endif
 };
 
-static int __devinit fs_enet_probe(struct platform_device *ofdev,
-                                   const struct of_device_id *match)
+static int __devinit fs_enet_probe(struct platform_device *ofdev)
 {
 	struct net_device *ndev;
 	struct fs_enet_private *fep;
@@ -1008,11 +1007,14 @@ static int __devinit fs_enet_probe(struct platform_device *ofdev,
 	const u8 *mac_addr;
 	int privsize, len, ret = -ENODEV;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+
 	fpi = kzalloc(sizeof(*fpi), GFP_KERNEL);
 	if (!fpi)
 		return -ENOMEM;
 
-	if (!IS_FEC(match)) {
+	if (!IS_FEC(ofdev->dev.of_match)) {
 		data = of_get_property(ofdev->dev.of_node, "fsl,cpm-command", &len);
 		if (!data || len != 4)
 			goto out_free_fpi;
@@ -1047,7 +1049,7 @@ static int __devinit fs_enet_probe(struct platform_device *ofdev,
 	fep->dev = &ofdev->dev;
 	fep->ndev = ndev;
 	fep->fpi = fpi;
-	fep->ops = match->data;
+	fep->ops = ofdev->dev.of_match->data;
 
 	ret = fep->ops->setup_data(ndev);
 	if (ret)
@@ -1156,7 +1158,7 @@ static struct of_device_id fs_enet_match[] = {
 };
 MODULE_DEVICE_TABLE(of, fs_enet_match);
 
-static struct of_platform_driver fs_enet_driver = {
+static struct platform_driver fs_enet_driver = {
 	.driver = {
 		.owner = THIS_MODULE,
 		.name = "fs_enet",
@@ -1168,12 +1170,12 @@ static struct of_platform_driver fs_enet_driver = {
 
 static int __init fs_init(void)
 {
-	return of_register_platform_driver(&fs_enet_driver);
+	return platform_driver_register(&fs_enet_driver);
 }
 
 static void __exit fs_cleanup(void)
 {
-	of_unregister_platform_driver(&fs_enet_driver);
+	platform_driver_unregister(&fs_enet_driver);
 }
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
diff --git a/drivers/net/fs_enet/mii-bitbang.c b/drivers/net/fs_enet/mii-bitbang.c
index 3cda2b5..ad29754 100644
--- a/drivers/net/fs_enet/mii-bitbang.c
+++ b/drivers/net/fs_enet/mii-bitbang.c
@@ -150,8 +150,7 @@ static int __devinit fs_mii_bitbang_init(struct mii_bus *bus,
 	return 0;
 }
 
-static int __devinit fs_enet_mdio_probe(struct platform_device *ofdev,
-                                        const struct of_device_id *match)
+static int __devinit fs_enet_mdio_probe(struct platform_device *ofdev)
 {
 	struct mii_bus *new_bus;
 	struct bb_info *bitbang;
@@ -223,7 +222,7 @@ static struct of_device_id fs_enet_mdio_bb_match[] = {
 };
 MODULE_DEVICE_TABLE(of, fs_enet_mdio_bb_match);
 
-static struct of_platform_driver fs_enet_bb_mdio_driver = {
+static struct platform_driver fs_enet_bb_mdio_driver = {
 	.driver = {
 		.name = "fsl-bb-mdio",
 		.owner = THIS_MODULE,
@@ -235,12 +234,12 @@ static struct of_platform_driver fs_enet_bb_mdio_driver = {
 
 static int fs_enet_mdio_bb_init(void)
 {
-	return of_register_platform_driver(&fs_enet_bb_mdio_driver);
+	return platform_driver_register(&fs_enet_bb_mdio_driver);
 }
 
 static void fs_enet_mdio_bb_exit(void)
 {
-	of_unregister_platform_driver(&fs_enet_bb_mdio_driver);
+	platform_driver_unregister(&fs_enet_bb_mdio_driver);
 }
 
 module_init(fs_enet_mdio_bb_init);
diff --git a/drivers/net/fs_enet/mii-fec.c b/drivers/net/fs_enet/mii-fec.c
index dbb9c48..7e840d3 100644
--- a/drivers/net/fs_enet/mii-fec.c
+++ b/drivers/net/fs_enet/mii-fec.c
@@ -101,15 +101,18 @@ static int fs_enet_fec_mii_reset(struct mii_bus *bus)
 	return 0;
 }
 
-static int __devinit fs_enet_mdio_probe(struct platform_device *ofdev,
-                                        const struct of_device_id *match)
+static int __devinit fs_enet_mdio_probe(struct platform_device *ofdev)
 {
 	struct resource res;
 	struct mii_bus *new_bus;
 	struct fec_info *fec;
-	int (*get_bus_freq)(struct device_node *) = match->data;
+	int (*get_bus_freq)(struct device_node *);
 	int ret = -ENOMEM, clock, speed;
 
+	if (!ofdev->dev.of_match)
+		return -EINVAL;
+	get_bus_freq = ofdev->dev.of_match->data;
+
 	new_bus = mdiobus_alloc();
 	if (!new_bus)
 		goto out;
@@ -221,7 +224,7 @@ static struct of_device_id fs_enet_mdio_fec_match[] = {
 };
 MODULE_DEVICE_TABLE(of, fs_enet_mdio_fec_match);
 
-static struct of_platform_driver fs_enet_fec_mdio_driver = {
+static struct platform_driver fs_enet_fec_mdio_driver = {
 	.driver = {
 		.name = "fsl-fec-mdio",
 		.owner = THIS_MODULE,
@@ -233,12 +236,12 @@ static struct of_platform_driver fs_enet_fec_mdio_driver = {
 
 static int fs_enet_mdio_fec_init(void)
 {
-	return of_register_platform_driver(&fs_enet_fec_mdio_driver);
+	return platform_driver_register(&fs_enet_fec_mdio_driver);
 }
 
 static void fs_enet_mdio_fec_exit(void)
 {
-	of_unregister_platform_driver(&fs_enet_fec_mdio_driver);
+	platform_driver_unregister(&fs_enet_fec_mdio_driver);
 }
 
 module_init(fs_enet_mdio_fec_init);
diff --git a/drivers/net/fsl_pq_mdio.c b/drivers/net/fsl_pq_mdio.c
index 8d3a2cc..52f4e8a 100644
--- a/drivers/net/fsl_pq_mdio.c
+++ b/drivers/net/fsl_pq_mdio.c
@@ -265,8 +265,7 @@ static int get_ucc_id_for_range(u64 start, u64 end, u32 *ucc_id)
 #endif
 
 
-static int fsl_pq_mdio_probe(struct platform_device *ofdev,
-		const struct of_device_id *match)
+static int fsl_pq_mdio_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct device_node *tbi;
@@ -471,7 +470,7 @@ static struct of_device_id fsl_pq_mdio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, fsl_pq_mdio_match);
 
-static struct of_platform_driver fsl_pq_mdio_driver = {
+static struct platform_driver fsl_pq_mdio_driver = {
 	.driver = {
 		.name = "fsl-pq_mdio",
 		.owner = THIS_MODULE,
@@ -483,13 +482,13 @@ static struct of_platform_driver fsl_pq_mdio_driver = {
 
 int __init fsl_pq_mdio_init(void)
 {
-	return of_register_platform_driver(&fsl_pq_mdio_driver);
+	return platform_driver_register(&fsl_pq_mdio_driver);
 }
 module_init(fsl_pq_mdio_init);
 
 void fsl_pq_mdio_exit(void)
 {
-	of_unregister_platform_driver(&fsl_pq_mdio_driver);
+	platform_driver_unregister(&fsl_pq_mdio_driver);
 }
 module_exit(fsl_pq_mdio_exit);
 MODULE_LICENSE("GPL");
diff --git a/drivers/net/gianfar.c b/drivers/net/gianfar.c
index 5ed8f9f..ccb231c 100644
--- a/drivers/net/gianfar.c
+++ b/drivers/net/gianfar.c
@@ -123,8 +123,7 @@ static irqreturn_t gfar_interrupt(int irq, void *dev_id);
 static void adjust_link(struct net_device *dev);
 static void init_registers(struct net_device *dev);
 static int init_phy(struct net_device *dev);
-static int gfar_probe(struct platform_device *ofdev,
-		const struct of_device_id *match);
+static int gfar_probe(struct platform_device *ofdev);
 static int gfar_remove(struct platform_device *ofdev);
 static void free_skb_resources(struct gfar_private *priv);
 static void gfar_set_multi(struct net_device *dev);
@@ -957,8 +956,7 @@ static void gfar_detect_errata(struct gfar_private *priv)
 
 /* Set up the ethernet device structure, private data,
  * and anything else we need before we start */
-static int gfar_probe(struct platform_device *ofdev,
-		const struct of_device_id *match)
+static int gfar_probe(struct platform_device *ofdev)
 {
 	u32 tempval;
 	struct net_device *dev = NULL;
@@ -3256,7 +3254,7 @@ static struct of_device_id gfar_match[] =
 MODULE_DEVICE_TABLE(of, gfar_match);
 
 /* Structure for a device driver */
-static struct of_platform_driver gfar_driver = {
+static struct platform_driver gfar_driver = {
 	.driver = {
 		.name = "fsl-gianfar",
 		.owner = THIS_MODULE,
@@ -3269,12 +3267,12 @@ static struct of_platform_driver gfar_driver = {
 
 static int __init gfar_init(void)
 {
-	return of_register_platform_driver(&gfar_driver);
+	return platform_driver_register(&gfar_driver);
 }
 
 static void __exit gfar_exit(void)
 {
-	of_unregister_platform_driver(&gfar_driver);
+	platform_driver_unregister(&gfar_driver);
 }
 
 module_init(gfar_init);
diff --git a/drivers/net/greth.c b/drivers/net/greth.c
index fdb0333..396ff7d 100644
--- a/drivers/net/greth.c
+++ b/drivers/net/greth.c
@@ -1411,7 +1411,7 @@ error:
 }
 
 /* Initialize the GRETH MAC */
-static int __devinit greth_of_probe(struct platform_device *ofdev, const struct of_device_id *match)
+static int __devinit greth_of_probe(struct platform_device *ofdev)
 {
 	struct net_device *dev;
 	struct greth_private *greth;
@@ -1646,7 +1646,7 @@ static struct of_device_id greth_of_match[] = {
 
 MODULE_DEVICE_TABLE(of, greth_of_match);
 
-static struct of_platform_driver greth_of_driver = {
+static struct platform_driver greth_of_driver = {
 	.driver = {
 		.name = "grlib-greth",
 		.owner = THIS_MODULE,
@@ -1658,12 +1658,12 @@ static struct of_platform_driver greth_of_driver = {
 
 static int __init greth_init(void)
 {
-	return of_register_platform_driver(&greth_of_driver);
+	return platform_driver_register(&greth_of_driver);
 }
 
 static void __exit greth_cleanup(void)
 {
-	of_unregister_platform_driver(&greth_of_driver);
+	platform_driver_unregister(&greth_of_driver);
 }
 
 module_init(greth_init);
diff --git a/drivers/net/ibm_newemac/core.c b/drivers/net/ibm_newemac/core.c
index 6d9275c..3bb990b 100644
--- a/drivers/net/ibm_newemac/core.c
+++ b/drivers/net/ibm_newemac/core.c
@@ -2719,8 +2719,7 @@ static const struct net_device_ops emac_gige_netdev_ops = {
 	.ndo_change_mtu		= emac_change_mtu,
 };
 
-static int __devinit emac_probe(struct platform_device *ofdev,
-				const struct of_device_id *match)
+static int __devinit emac_probe(struct platform_device *ofdev)
 {
 	struct net_device *ndev;
 	struct emac_instance *dev;
@@ -2994,7 +2993,7 @@ static struct of_device_id emac_match[] =
 };
 MODULE_DEVICE_TABLE(of, emac_match);
 
-static struct of_platform_driver emac_driver = {
+static struct platform_driver emac_driver = {
 	.driver = {
 		.name = "emac",
 		.owner = THIS_MODULE,
@@ -3069,7 +3068,7 @@ static int __init emac_init(void)
 	rc = tah_init();
 	if (rc)
 		goto err_rgmii;
-	rc = of_register_platform_driver(&emac_driver);
+	rc = platform_driver_register(&emac_driver);
 	if (rc)
 		goto err_tah;
 
@@ -3091,7 +3090,7 @@ static void __exit emac_exit(void)
 {
 	int i;
 
-	of_unregister_platform_driver(&emac_driver);
+	platform_driver_unregister(&emac_driver);
 
 	tah_exit();
 	rgmii_exit();
diff --git a/drivers/net/ibm_newemac/mal.c b/drivers/net/ibm_newemac/mal.c
index d5717e2..d268f40 100644
--- a/drivers/net/ibm_newemac/mal.c
+++ b/drivers/net/ibm_newemac/mal.c
@@ -517,8 +517,7 @@ void *mal_dump_regs(struct mal_instance *mal, void *buf)
 	return regs + 1;
 }
 
-static int __devinit mal_probe(struct platform_device *ofdev,
-			       const struct of_device_id *match)
+static int __devinit mal_probe(struct platform_device *ofdev)
 {
 	struct mal_instance *mal;
 	int err = 0, i, bd_size;
@@ -789,7 +788,7 @@ static struct of_device_id mal_platform_match[] =
 	{},
 };
 
-static struct of_platform_driver mal_of_driver = {
+static struct platform_driver mal_of_driver = {
 	.driver = {
 		.name = "mcmal",
 		.owner = THIS_MODULE,
@@ -801,10 +800,10 @@ static struct of_platform_driver mal_of_driver = {
 
 int __init mal_init(void)
 {
-	return of_register_platform_driver(&mal_of_driver);
+	return platform_driver_register(&mal_of_driver);
 }
 
 void mal_exit(void)
 {
-	of_unregister_platform_driver(&mal_of_driver);
+	platform_driver_unregister(&mal_of_driver);
 }
diff --git a/drivers/net/ibm_newemac/rgmii.c b/drivers/net/ibm_newemac/rgmii.c
index dd61798..4fa53f3 100644
--- a/drivers/net/ibm_newemac/rgmii.c
+++ b/drivers/net/ibm_newemac/rgmii.c
@@ -228,8 +228,7 @@ void *rgmii_dump_regs(struct platform_device *ofdev, void *buf)
 }
 
 
-static int __devinit rgmii_probe(struct platform_device *ofdev,
-				 const struct of_device_id *match)
+static int __devinit rgmii_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct rgmii_instance *dev;
@@ -318,7 +317,7 @@ static struct of_device_id rgmii_match[] =
 	{},
 };
 
-static struct of_platform_driver rgmii_driver = {
+static struct platform_driver rgmii_driver = {
 	.driver = {
 		.name = "emac-rgmii",
 		.owner = THIS_MODULE,
@@ -330,10 +329,10 @@ static struct of_platform_driver rgmii_driver = {
 
 int __init rgmii_init(void)
 {
-	return of_register_platform_driver(&rgmii_driver);
+	return platform_driver_register(&rgmii_driver);
 }
 
 void rgmii_exit(void)
 {
-	of_unregister_platform_driver(&rgmii_driver);
+	platform_driver_unregister(&rgmii_driver);
 }
diff --git a/drivers/net/ibm_newemac/tah.c b/drivers/net/ibm_newemac/tah.c
index 299aa49..8ead6a9 100644
--- a/drivers/net/ibm_newemac/tah.c
+++ b/drivers/net/ibm_newemac/tah.c
@@ -87,8 +87,7 @@ void *tah_dump_regs(struct platform_device *ofdev, void *buf)
 	return regs + 1;
 }
 
-static int __devinit tah_probe(struct platform_device *ofdev,
-			       const struct of_device_id *match)
+static int __devinit tah_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct tah_instance *dev;
@@ -165,7 +164,7 @@ static struct of_device_id tah_match[] =
 	{},
 };
 
-static struct of_platform_driver tah_driver = {
+static struct platform_driver tah_driver = {
 	.driver = {
 		.name = "emac-tah",
 		.owner = THIS_MODULE,
@@ -177,10 +176,10 @@ static struct of_platform_driver tah_driver = {
 
 int __init tah_init(void)
 {
-	return of_register_platform_driver(&tah_driver);
+	return platform_driver_register(&tah_driver);
 }
 
 void tah_exit(void)
 {
-	of_unregister_platform_driver(&tah_driver);
+	platform_driver_unregister(&tah_driver);
 }
diff --git a/drivers/net/ibm_newemac/zmii.c b/drivers/net/ibm_newemac/zmii.c
index 34ed6ee..97449e7 100644
--- a/drivers/net/ibm_newemac/zmii.c
+++ b/drivers/net/ibm_newemac/zmii.c
@@ -231,8 +231,7 @@ void *zmii_dump_regs(struct platform_device *ofdev, void *buf)
 	return regs + 1;
 }
 
-static int __devinit zmii_probe(struct platform_device *ofdev,
-				const struct of_device_id *match)
+static int __devinit zmii_probe(struct platform_device *ofdev)
 {
 	struct device_node *np = ofdev->dev.of_node;
 	struct zmii_instance *dev;
@@ -312,7 +311,7 @@ static struct of_device_id zmii_match[] =
 	{},
 };
 
-static struct of_platform_driver zmii_driver = {
+static struct platform_driver zmii_driver = {
 	.driver = {
 		.name = "emac-zmii",
 		.owner = THIS_MODULE,
@@ -324,10 +323,10 @@ static struct of_platform_driver zmii_driver = {
 
 int __init zmii_init(void)
 {
-	return of_register_platform_driver(&zmii_driver);
+	return platform_driver_register(&zmii_driver);
 }
 
 void zmii_exit(void)
 {
-	of_unregister_platform_driver(&zmii_driver);
+	platform_driver_unregister(&zmii_driver);
 }
diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index f35554d..b7948cc 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -952,8 +952,7 @@ static const struct attribute_group temac_attr_group = {
 	.attrs = temac_device_attrs,
 };
 
-static int __devinit
-temac_of_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit temac_of_probe(struct platform_device *op)
 {
 	struct device_node *np;
 	struct temac_local *lp;
@@ -1123,7 +1122,7 @@ static struct of_device_id temac_of_match[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(of, temac_of_match);
 
-static struct of_platform_driver temac_of_driver = {
+static struct platform_driver temac_of_driver = {
 	.probe = temac_of_probe,
 	.remove = __devexit_p(temac_of_remove),
 	.driver = {
@@ -1135,13 +1134,13 @@ static struct of_platform_driver temac_of_driver = {
 
 static int __init temac_init(void)
 {
-	return of_register_platform_driver(&temac_of_driver);
+	return platform_driver_register(&temac_of_driver);
 }
 module_init(temac_init);
 
 static void __exit temac_exit(void)
 {
-	of_unregister_platform_driver(&temac_of_driver);
+	platform_driver_unregister(&temac_of_driver);
 }
 module_exit(temac_exit);
 
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 4846e13..a761076 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -926,7 +926,7 @@ static const struct net_device_ops myri_ops = {
 	.ndo_validate_addr	= eth_validate_addr,
 };
 
-static int __devinit myri_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit myri_sbus_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	static unsigned version_printed;
@@ -1160,7 +1160,7 @@ static const struct of_device_id myri_sbus_match[] = {
 
 MODULE_DEVICE_TABLE(of, myri_sbus_match);
 
-static struct of_platform_driver myri_sbus_driver = {
+static struct platform_driver myri_sbus_driver = {
 	.driver = {
 		.name = "myri",
 		.owner = THIS_MODULE,
@@ -1172,12 +1172,12 @@ static struct of_platform_driver myri_sbus_driver = {
 
 static int __init myri_sbus_init(void)
 {
-	return of_register_platform_driver(&myri_sbus_driver);
+	return platform_driver_register(&myri_sbus_driver);
 }
 
 static void __exit myri_sbus_exit(void)
 {
-	of_unregister_platform_driver(&myri_sbus_driver);
+	platform_driver_unregister(&myri_sbus_driver);
 }
 
 module_init(myri_sbus_init);
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 2541321..54cb250 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -10033,8 +10033,7 @@ static const struct niu_ops niu_phys_ops = {
 	.unmap_single	= niu_phys_unmap_single,
 };
 
-static int __devinit niu_of_probe(struct platform_device *op,
-				  const struct of_device_id *match)
+static int __devinit niu_of_probe(struct platform_device *op)
 {
 	union niu_parent_id parent_id;
 	struct net_device *dev;
@@ -10194,7 +10193,7 @@ static const struct of_device_id niu_match[] = {
 };
 MODULE_DEVICE_TABLE(of, niu_match);
 
-static struct of_platform_driver niu_of_driver = {
+static struct platform_driver niu_of_driver = {
 	.driver = {
 		.name = "niu",
 		.owner = THIS_MODULE,
@@ -10215,14 +10214,14 @@ static int __init niu_init(void)
 	niu_debug = netif_msg_init(debug, NIU_MSG_DEFAULT);
 
 #ifdef CONFIG_SPARC64
-	err = of_register_platform_driver(&niu_of_driver);
+	err = platform_driver_register(&niu_of_driver);
 #endif
 
 	if (!err) {
 		err = pci_register_driver(&niu_pci_driver);
 #ifdef CONFIG_SPARC64
 		if (err)
-			of_unregister_platform_driver(&niu_of_driver);
+			platform_driver_unregister(&niu_of_driver);
 #endif
 	}
 
@@ -10233,7 +10232,7 @@ static void __exit niu_exit(void)
 {
 	pci_unregister_driver(&niu_pci_driver);
 #ifdef CONFIG_SPARC64
-	of_unregister_platform_driver(&niu_of_driver);
+	platform_driver_unregister(&niu_of_driver);
 #endif
 }
 
diff --git a/drivers/net/phy/mdio-gpio.c b/drivers/net/phy/mdio-gpio.c
index f62c7b7..47c8339 100644
--- a/drivers/net/phy/mdio-gpio.c
+++ b/drivers/net/phy/mdio-gpio.c
@@ -188,8 +188,7 @@ static int __devexit mdio_gpio_remove(struct platform_device *pdev)
 
 #ifdef CONFIG_OF_GPIO
 
-static int __devinit mdio_ofgpio_probe(struct platform_device *ofdev,
-                                        const struct of_device_id *match)
+static int __devinit mdio_ofgpio_probe(struct platform_device *ofdev)
 {
 	struct mdio_gpio_platform_data *pdata;
 	struct mii_bus *new_bus;
@@ -240,7 +239,7 @@ static struct of_device_id mdio_ofgpio_match[] = {
 };
 MODULE_DEVICE_TABLE(of, mdio_ofgpio_match);
 
-static struct of_platform_driver mdio_ofgpio_driver = {
+static struct platform_driver mdio_ofgpio_driver = {
 	.driver = {
 		.name = "mdio-gpio",
 		.owner = THIS_MODULE,
@@ -252,12 +251,12 @@ static struct of_platform_driver mdio_ofgpio_driver = {
 
 static inline int __init mdio_ofgpio_init(void)
 {
-	return of_register_platform_driver(&mdio_ofgpio_driver);
+	return platform_driver_register(&mdio_ofgpio_driver);
 }
 
 static inline void __exit mdio_ofgpio_exit(void)
 {
-	of_unregister_platform_driver(&mdio_ofgpio_driver);
+	platform_driver_unregister(&mdio_ofgpio_driver);
 }
 #else
 static inline int __init mdio_ofgpio_init(void) { return 0; }
diff --git a/drivers/net/sunbmac.c b/drivers/net/sunbmac.c
index 0a6a5ce..aa47658 100644
--- a/drivers/net/sunbmac.c
+++ b/drivers/net/sunbmac.c
@@ -1242,8 +1242,7 @@ fail_and_cleanup:
 /* QEC can be the parent of either QuadEthernet or a BigMAC.  We want
  * the latter.
  */
-static int __devinit bigmac_sbus_probe(struct platform_device *op,
-				       const struct of_device_id *match)
+static int __devinit bigmac_sbus_probe(struct platform_device *op)
 {
 	struct device *parent = op->dev.parent;
 	struct platform_device *qec_op;
@@ -1289,7 +1288,7 @@ static const struct of_device_id bigmac_sbus_match[] = {
 
 MODULE_DEVICE_TABLE(of, bigmac_sbus_match);
 
-static struct of_platform_driver bigmac_sbus_driver = {
+static struct platform_driver bigmac_sbus_driver = {
 	.driver = {
 		.name = "sunbmac",
 		.owner = THIS_MODULE,
@@ -1301,12 +1300,12 @@ static struct of_platform_driver bigmac_sbus_driver = {
 
 static int __init bigmac_init(void)
 {
-	return of_register_platform_driver(&bigmac_sbus_driver);
+	return platform_driver_register(&bigmac_sbus_driver);
 }
 
 static void __exit bigmac_exit(void)
 {
-	of_unregister_platform_driver(&bigmac_sbus_driver);
+	platform_driver_unregister(&bigmac_sbus_driver);
 }
 
 module_init(bigmac_init);
diff --git a/drivers/net/sunhme.c b/drivers/net/sunhme.c
index 55bbb9c..eb4f59f 100644
--- a/drivers/net/sunhme.c
+++ b/drivers/net/sunhme.c
@@ -3237,11 +3237,15 @@ static void happy_meal_pci_exit(void)
 #endif
 
 #ifdef CONFIG_SBUS
-static int __devinit hme_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit hme_sbus_probe(struct platform_device *op)
 {
 	struct device_node *dp = op->dev.of_node;
 	const char *model = of_get_property(dp, "model", NULL);
-	int is_qfe = (match->data != NULL);
+	int is_qfe;
+
+	if (!op->dev.of_match)
+		return -EINVAL;
+	is_qfe = (op->dev.of_match->data != NULL);
 
 	if (!is_qfe && model && !strcmp(model, "SUNW,sbus-qfe"))
 		is_qfe = 1;
@@ -3292,7 +3296,7 @@ static const struct of_device_id hme_sbus_match[] = {
 
 MODULE_DEVICE_TABLE(of, hme_sbus_match);
 
-static struct of_platform_driver hme_sbus_driver = {
+static struct platform_driver hme_sbus_driver = {
 	.driver = {
 		.name = "hme",
 		.owner = THIS_MODULE,
@@ -3306,7 +3310,7 @@ static int __init happy_meal_sbus_init(void)
 {
 	int err;
 
-	err = of_register_platform_driver(&hme_sbus_driver);
+	err = platform_driver_register(&hme_sbus_driver);
 	if (!err)
 		err = quattro_sbus_register_irqs();
 
@@ -3315,7 +3319,7 @@ static int __init happy_meal_sbus_init(void)
 
 static void happy_meal_sbus_exit(void)
 {
-	of_unregister_platform_driver(&hme_sbus_driver);
+	platform_driver_unregister(&hme_sbus_driver);
 	quattro_sbus_free_irqs();
 
 	while (qfe_sbus_list) {
diff --git a/drivers/net/sunlance.c b/drivers/net/sunlance.c
index 767e1e2..32a5c7f 100644
--- a/drivers/net/sunlance.c
+++ b/drivers/net/sunlance.c
@@ -1495,7 +1495,7 @@ fail:
 	return -ENODEV;
 }
 
-static int __devinit sunlance_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit sunlance_sbus_probe(struct platform_device *op)
 {
 	struct platform_device *parent = to_platform_device(op->dev.parent);
 	struct device_node *parent_dp = parent->dev.of_node;
@@ -1536,7 +1536,7 @@ static const struct of_device_id sunlance_sbus_match[] = {
 
 MODULE_DEVICE_TABLE(of, sunlance_sbus_match);
 
-static struct of_platform_driver sunlance_sbus_driver = {
+static struct platform_driver sunlance_sbus_driver = {
 	.driver = {
 		.name = "sunlance",
 		.owner = THIS_MODULE,
@@ -1550,12 +1550,12 @@ static struct of_platform_driver sunlance_sbus_driver = {
 /* Find all the lance cards on the system and initialize them */
 static int __init sparc_lance_init(void)
 {
-	return of_register_platform_driver(&sunlance_sbus_driver);
+	return platform_driver_register(&sunlance_sbus_driver);
 }
 
 static void __exit sparc_lance_exit(void)
 {
-	of_unregister_platform_driver(&sunlance_sbus_driver);
+	platform_driver_unregister(&sunlance_sbus_driver);
 }
 
 module_init(sparc_lance_init);
diff --git a/drivers/net/sunqe.c b/drivers/net/sunqe.c
index 9536b2f..18ecdc3 100644
--- a/drivers/net/sunqe.c
+++ b/drivers/net/sunqe.c
@@ -941,7 +941,7 @@ fail:
 	return res;
 }
 
-static int __devinit qec_sbus_probe(struct platform_device *op, const struct of_device_id *match)
+static int __devinit qec_sbus_probe(struct platform_device *op)
 {
 	return qec_ether_init(op);
 }
@@ -976,7 +976,7 @@ static const struct of_device_id qec_sbus_match[] = {
 
 MODULE_DEVICE_TABLE(of, qec_sbus_match);
 
-static struct of_platform_driver qec_sbus_driver = {
+static struct platform_driver qec_sbus_driver = {
 	.driver = {
 		.name = "qec",
 		.owner = THIS_MODULE,
@@ -988,12 +988,12 @@ static struct of_platform_driver qec_sbus_driver = {
 
 static int __init qec_init(void)
 {
-	return of_register_platform_driver(&qec_sbus_driver);
+	return platform_driver_register(&qec_sbus_driver);
 }
 
 static void __exit qec_exit(void)
 {
-	of_unregister_platform_driver(&qec_sbus_driver);
+	platform_driver_unregister(&qec_sbus_driver);
 
 	while (root_qec_dev) {
 		struct sunqec *next = root_qec_dev->next_module;
diff --git a/drivers/net/ucc_geth.c b/drivers/net/ucc_geth.c
index 715e7b4..ef04105 100644
--- a/drivers/net/ucc_geth.c
+++ b/drivers/net/ucc_geth.c
@@ -3740,7 +3740,7 @@ static const struct net_device_ops ucc_geth_netdev_ops = {
 #endif
 };
 
-static int ucc_geth_probe(struct platform_device* ofdev, const struct of_device_id *match)
+static int ucc_geth_probe(struct platform_device* ofdev)
 {
 	struct device *device = &ofdev->dev;
 	struct device_node *np = ofdev->dev.of_node;
@@ -3986,7 +3986,7 @@ static struct of_device_id ucc_geth_match[] = {
 
 MODULE_DEVICE_TABLE(of, ucc_geth_match);
 
-static struct of_platform_driver ucc_geth_driver = {
+static struct platform_driver ucc_geth_driver = {
 	.driver = {
 		.name = DRV_NAME,
 		.owner = THIS_MODULE,
@@ -4008,14 +4008,14 @@ static int __init ucc_geth_init(void)
 		memcpy(&(ugeth_info[i]), &ugeth_primary_info,
 		       sizeof(ugeth_primary_info));
 
-	ret = of_register_platform_driver(&ucc_geth_driver);
+	ret = platform_driver_register(&ucc_geth_driver);
 
 	return ret;
 }
 
 static void __exit ucc_geth_exit(void)
 {
-	of_unregister_platform_driver(&ucc_geth_driver);
+	platform_driver_unregister(&ucc_geth_driver);
 }
 
 module_init(ucc_geth_init);
diff --git a/drivers/net/xilinx_emaclite.c b/drivers/net/xilinx_emaclite.c
index cad66ce..2642af4 100644
--- a/drivers/net/xilinx_emaclite.c
+++ b/drivers/net/xilinx_emaclite.c
@@ -1101,8 +1101,7 @@ static struct net_device_ops xemaclite_netdev_ops;
  * Return:	0, if the driver is bound to the Emaclite device, or
  *		a negative error if there is failure.
  */
-static int __devinit xemaclite_of_probe(struct platform_device *ofdev,
-					const struct of_device_id *match)
+static int __devinit xemaclite_of_probe(struct platform_device *ofdev)
 {
 	struct resource r_irq; /* Interrupt resources */
 	struct resource r_mem; /* IO mem resources */
@@ -1288,7 +1287,7 @@ static struct of_device_id xemaclite_of_match[] __devinitdata = {
 };
 MODULE_DEVICE_TABLE(of, xemaclite_of_match);
 
-static struct of_platform_driver xemaclite_of_driver = {
+static struct platform_driver xemaclite_of_driver = {
 	.driver = {
 		.name = DRIVER_NAME,
 		.owner = THIS_MODULE,
@@ -1306,7 +1305,7 @@ static struct of_platform_driver xemaclite_of_driver = {
 static int __init xemaclite_init(void)
 {
 	/* No kernel boot options used, we just need to register the driver */
-	return of_register_platform_driver(&xemaclite_of_driver);
+	return platform_driver_register(&xemaclite_of_driver);
 }
 
 /**
@@ -1314,7 +1313,7 @@ static int __init xemaclite_init(void)
  */
 static void __exit xemaclite_cleanup(void)
 {
-	of_unregister_platform_driver(&xemaclite_of_driver);
+	platform_driver_unregister(&xemaclite_of_driver);
 }
 
 module_init(xemaclite_init);

