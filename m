Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932193Ab1CVOLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 10:11:17 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34736 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293Ab1CVOLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 10:11:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type;
        b=hpBBpOyvi86MpRocymawrs9PyChnyNFDocUVKiKN+rF4P1hMnPOVwzNcoR0PhM9gZT
         8POxsnbfgmdInSLJpj+k5afleLQBVASt1esp08x0SRkQc3/MQRokT3W9oKNaQAL5VKn6
         Hj2SnW9G3Fs8KeUxDREqesYQ4Oo/6t2hzxnb8=
MIME-Version: 1.0
From: "vooon341@gmail.com" <vooon341@gmail.com>
Date: Tue, 22 Mar 2011 17:10:46 +0300
Message-ID: <AANLkTimXn_ekXD5knEqAUCckdWWzRSKavWrvirKuT8DY@mail.gmail.com>
Subject: Re: [PATCH 3/3,v2] fs_enet: Add PHY interface selection for MPC5121 fs_enet.
To: linuxppc-dev@lists.ozlabs.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@gmail.com>,
        Vitaly Bordug <vbordug@ru.mvista.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add PHY interface selection for MPC5121 fs_enet.

Adds phy-connection-type optional property for ethernet node.
It should be rmii or mii.

Signed-off-by: Vladimir Ermakov <vooon341@gmail.com>
---
v2:
 - replace Kconfig to device tree
 - add phy-connection-type for mpc5121-fec nodes
---
 drivers/net/fs_enet/fec.h          |    6 ++++--
 drivers/net/fs_enet/fs_enet-main.c |   14 ++++++++++++--
 drivers/net/fs_enet/mac-fec.c      |    9 ++++++---
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/fs_enet/fec.h b/drivers/net/fs_enet/fec.h
index e980527..9fd1ff5 100644
--- a/drivers/net/fs_enet/fec.h
+++ b/drivers/net/fs_enet/fec.h
@@ -23,6 +23,10 @@
 #define FEC_ECNTRL_ETHER_EN	0x00000002
 #define FEC_ECNTRL_RESET	0x00000001

+/* RMII mode enabled only when MII_MODE bit is set too. */
+#define FEC_RCNTRL_RMII_MODE	(0x00000100 | \
+		FEC_RCNTRL_MII_MODE | FEC_RCNTRL_FCE)
+#define FEC_RCNTRL_FCE		0x00000020
 #define FEC_RCNTRL_BC_REJ	0x00000010
 #define FEC_RCNTRL_PROM		0x00000008
 #define FEC_RCNTRL_MII_MODE	0x00000004
@@ -33,8 +37,6 @@
 #define FEC_TCNTRL_HBC		0x00000002
 #define FEC_TCNTRL_GTS		0x00000001

-
-
 /*
  * Delay to wait for FEC reset command to complete (in us)
  */
diff --git a/drivers/net/fs_enet/fs_enet-main.c
b/drivers/net/fs_enet/fs_enet-main.c
index 24cb953..c424159 100644
--- a/drivers/net/fs_enet/fs_enet-main.c
+++ b/drivers/net/fs_enet/fs_enet-main.c
@@ -788,16 +788,20 @@ static int fs_init_phy(struct net_device *dev)
 {
 	struct fs_enet_private *fep = netdev_priv(dev);
 	struct phy_device *phydev;
+	phy_interface_t iface;

 	fep->oldlink = 0;
 	fep->oldspeed = 0;
 	fep->oldduplex = -1;

+	iface = (fep->fpi->use_rmii) ?
+		PHY_INTERFACE_MODE_RMII : PHY_INTERFACE_MODE_MII;
+
 	phydev = of_phy_connect(dev, fep->fpi->phy_node, &fs_adjust_link, 0,
-				PHY_INTERFACE_MODE_MII);
+				iface);
 	if (!phydev) {
 		phydev = of_phy_connect_fixed_link(dev, &fs_adjust_link,
-						   PHY_INTERFACE_MODE_MII);
+						   iface);
 	}
 	if (!phydev) {
 		dev_err(&dev->dev, "Could not attach to PHY\n");
@@ -1005,6 +1009,7 @@ static int __devinit fs_enet_probe(struct
platform_device *ofdev)
 	struct fs_platform_info *fpi;
 	const u32 *data;
 	const u8 *mac_addr;
+	char *phy_connection_type;
 	int privsize, len, ret = -ENODEV;

 	if (!ofdev->dev.of_match)
@@ -1032,6 +1037,11 @@ static int __devinit fs_enet_probe(struct
platform_device *ofdev)
 						  NULL)))
 		goto out_free_fpi;

+	phy_connection_type = of_get_property(ofdev->dev.of_node,
+			"phy-connection-type", NULL);
+	if (phy_connection_type && strcmp("rmii", phy_connection_type) == 0)
+		fpi->use_rmii = 1;
+
 	privsize = sizeof(*fep) +
 	           sizeof(struct sk_buff **) *
 	           (fpi->rx_ring + fpi->tx_ring);
diff --git a/drivers/net/fs_enet/mac-fec.c b/drivers/net/fs_enet/mac-fec.c
index 61035fc..7ba36c1 100644
--- a/drivers/net/fs_enet/mac-fec.c
+++ b/drivers/net/fs_enet/mac-fec.c
@@ -322,10 +322,11 @@ static void restart(struct net_device *dev)
 	FW(fecp, r_cntrl, FEC_RCNTRL_MII_MODE);	/* MII enable */
 #else
 	/*
-	 * Only set MII mode - do not touch maximum frame length
+	 * Only set MII/RMII mode - do not touch maximum frame length
 	 * configured before.
 	 */
-	FS(fecp, r_cntrl, FEC_RCNTRL_MII_MODE);
+	FS(fecp, r_cntrl, (fpi->use_rmii) ?
+			FEC_RCNTRL_RMII_MODE : FEC_RCNTRL_MII_MODE);
 #endif
 	/*
 	 * adjust to duplex mode
@@ -381,7 +382,9 @@ static void stop(struct net_device *dev)

 	/* shut down FEC1? that's where the mii bus is */
 	if (fpi->has_phy) {
-		FS(fecp, r_cntrl, FEC_RCNTRL_MII_MODE);	/* MII enable */
+		FS(fecp, r_cntrl, (fpi->use_rmii) ?
+				FEC_RCNTRL_RMII_MODE :
+				FEC_RCNTRL_MII_MODE);	/* MII/RMII enable */
 		FS(fecp, ecntrl, FEC_ECNTRL_PINMUX | FEC_ECNTRL_ETHER_EN);
 		FW(fecp, ievent, FEC_ENET_MII);
 		FW(fecp, mii_speed, feci->mii_speed);
-- 
1.7.1
