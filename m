Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1JLMZB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 08:25:01 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:47373 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab1JLMZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 08:25:00 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-netdev@vger.kernel.org, dhlii@dlasys.net,
        ville.sundell@digilent.ro, grant.likely@secretlab.ca
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCH] ll_temac: Add support for ethtool
Date: Wed, 12 Oct 2011 13:47:29 +0200
Message-Id: <1318420049-23019-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the ethtool interface. The implementation is done
using the libphy helper functions.

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/net/ll_temac_main.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ll_temac_main.c b/drivers/net/ll_temac_main.c
index 728fe41..91a9804 100644
--- a/drivers/net/ll_temac_main.c
+++ b/drivers/net/ll_temac_main.c
@@ -957,6 +957,32 @@ static const struct attribute_group temac_attr_group = {
 	.attrs = temac_device_attrs,
 };
 
+/* ethtool support */
+static int temac_get_settings(struct net_device *ndev, struct ethtool_cmd *cmd)
+{
+	struct temac_local *lp = netdev_priv(ndev);
+	return phy_ethtool_gset(lp->phy_dev, cmd);
+}
+
+static int temac_set_settings(struct net_device *ndev, struct ethtool_cmd *cmd)
+{
+	struct temac_local *lp = netdev_priv(ndev);
+	return phy_ethtool_sset(lp->phy_dev, cmd);
+}
+
+static int temac_nway_reset(struct net_device *ndev)
+{
+	struct temac_local *lp = netdev_priv(ndev);
+	return phy_start_aneg(lp->phy_dev);
+}
+
+static const struct ethtool_ops temac_ethtool_ops = {
+	.get_settings = temac_get_settings,
+	.set_settings = temac_set_settings,
+	.nway_reset = temac_nway_reset,
+	.get_link = ethtool_op_get_link,
+};
+
 static int __devinit temac_of_probe(struct platform_device *op)
 {
 	struct device_node *np;
@@ -978,6 +1004,7 @@ static int __devinit temac_of_probe(struct platform_device *op)
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
 	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
 	ndev->netdev_ops = &temac_netdev_ops;
+	ndev->ethtool_ops= &temac_ethtool_ops;
 #if 0
 	ndev->features |= NETIF_F_IP_CSUM; /* Can checksum TCP/UDP over IPv4. */
 	ndev->features |= NETIF_F_HW_CSUM; /* Can checksum all the packets. */
-- 
1.7.6.3

