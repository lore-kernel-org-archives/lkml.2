Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755Ab1JSHfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:35:37 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:61252 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1JSHfe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:35:34 -0400
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: davem@davemloft.net, ian.campbell@citrix.com, jeffrey.t.kirsher@intel.com,
        grant.likely@secretlab.ca, jpirko@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Subject: [PATCHv2] ll_temac: Add support for ethtool
Date: Wed, 19 Oct 2011 09:35:25 +0200
Message-Id: <1319009725-7869-1-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 1.7.7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch enables the ethtool interface. The implementation is done
using the libphy helper functions.

---
v2: Fixed propossed by Ben Hutchings
	- Rebase to net/next
	- Code Style

v1: Add reviewed by

Reviewed-by: Grant Likely <grant.likely@secretlab.ca>
Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/net/ethernet/xilinx/ll_temac_main.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 66e3c36..2e90c01 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -955,6 +955,32 @@ static const struct attribute_group temac_attr_group = {
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
@@ -976,6 +1002,7 @@ static int __devinit temac_of_probe(struct platform_device *op)
 	ndev->flags &= ~IFF_MULTICAST;  /* clear multicast */
 	ndev->features = NETIF_F_SG | NETIF_F_FRAGLIST;
 	ndev->netdev_ops = &temac_netdev_ops;
+	ndev->ethtool_ops = &temac_ethtool_ops;
 #if 0
 	ndev->features |= NETIF_F_IP_CSUM; /* Can checksum TCP/UDP over IPv4. */
 	ndev->features |= NETIF_F_HW_CSUM; /* Can checksum all the packets. */
-- 
1.7.7

