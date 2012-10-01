Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965368Ab2JAXlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:41:45 -0400
Received: from 1wt.eu ([62.212.114.60]:34948 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932328Ab2JAW7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 18:59:23 -0400
Message-Id: <20121001225157.653359202@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:51:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sony Chacko <sony.chacko@qlogic.com>,
        Amit Kumar Salecha <amit.salecha@qlogic.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Willy Tarreau <w@1wt.eu>
Subject: [ 001/180] netxen: support for GbE port settings
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sony Chacko <sony.chacko@qlogic.com>

commit bfd823bd74333615783d8108889814c6d82f2ab0 upstream.

o Enable setting speed and auto negotiation parameters for GbE ports.
o Hardware do not support half duplex setting currently.

David Miller:
	Amit please update your patch to silently reject link setting
	attempts that are unsupported by the device.

[jn: backported for 2.6.32.y by Ana Guerrero]

Signed-off-by: Sony Chacko <sony.chacko@qlogic.com>
Signed-off-by: Amit Kumar Salecha <amit.salecha@qlogic.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Tested-by: Ana Guerrero <ana@debian.org> # HP NC375i
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/net/netxen/netxen_nic.h         |    7 +++-
 drivers/net/netxen/netxen_nic_ctx.c     |   15 +++++++
 drivers/net/netxen/netxen_nic_ethtool.c |   62 ++++++++-----------------------
 3 files changed, 37 insertions(+), 47 deletions(-)

diff --git a/drivers/net/netxen/netxen_nic.h b/drivers/net/netxen/netxen_nic.h
index e52af5b..50d2af8 100644
--- a/drivers/net/netxen/netxen_nic.h
+++ b/drivers/net/netxen/netxen_nic.h
@@ -700,7 +700,8 @@ struct netxen_recv_context {
 #define NX_CDRP_CMD_READ_PEXQ_PARAMETERS	0x0000001c
 #define NX_CDRP_CMD_GET_LIC_CAPABILITIES	0x0000001d
 #define NX_CDRP_CMD_READ_MAX_LRO_PER_BOARD	0x0000001e
-#define NX_CDRP_CMD_MAX				0x0000001f
+#define NX_CDRP_CMD_CONFIG_GBE_PORT		0x0000001f
+#define NX_CDRP_CMD_MAX				0x00000020
 
 #define NX_RCODE_SUCCESS		0
 #define NX_RCODE_NO_HOST_MEM		1
@@ -1015,6 +1016,7 @@ typedef struct {
 #define NX_FW_CAPABILITY_BDG			(1 << 8)
 #define NX_FW_CAPABILITY_FVLANTX		(1 << 9)
 #define NX_FW_CAPABILITY_HW_LRO			(1 << 10)
+#define NX_FW_CAPABILITY_GBE_LINK_CFG		(1 << 11)
 
 /* module types */
 #define LINKEVENT_MODULE_NOT_PRESENT			1
@@ -1323,6 +1325,9 @@ int netxen_config_ipaddr(struct netxen_adapter *adapter, u32 ip, int cmd);
 int netxen_linkevent_request(struct netxen_adapter *adapter, int enable);
 void netxen_advert_link_change(struct netxen_adapter *adapter, int linkup);
 
+int nx_fw_cmd_set_gbe_port(struct netxen_adapter *adapter,
+		u32 speed, u32 duplex, u32 autoneg);
+
 int nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, int mtu);
 int netxen_nic_change_mtu(struct net_device *netdev, int new_mtu);
 int netxen_config_hw_lro(struct netxen_adapter *adapter, int enable);
diff --git a/drivers/net/netxen/netxen_nic_ctx.c b/drivers/net/netxen/netxen_nic_ctx.c
index 9cb8f68..f48cdb2 100644
--- a/drivers/net/netxen/netxen_nic_ctx.c
+++ b/drivers/net/netxen/netxen_nic_ctx.c
@@ -112,6 +112,21 @@ nx_fw_cmd_set_mtu(struct netxen_adapter *adapter, int mtu)
 	return 0;
 }
 
+int
+nx_fw_cmd_set_gbe_port(struct netxen_adapter *adapter,
+	u32 speed, u32 duplex, u32 autoneg)
+{
+
+	return netxen_issue_cmd(adapter,
+		adapter->ahw.pci_func,
+		NXHAL_VERSION,
+		speed,
+		duplex,
+		autoneg,
+		NX_CDRP_CMD_CONFIG_GBE_PORT);
+
+}
+
 static int
 nx_fw_cmd_create_rx_ctx(struct netxen_adapter *adapter)
 {
diff --git a/drivers/net/netxen/netxen_nic_ethtool.c b/drivers/net/netxen/netxen_nic_ethtool.c
index 714f387..7e34840 100644
--- a/drivers/net/netxen/netxen_nic_ethtool.c
+++ b/drivers/net/netxen/netxen_nic_ethtool.c
@@ -216,7 +216,6 @@ skip:
 			check_sfp_module = netif_running(dev) &&
 				adapter->has_link_events;
 		} else {
-			ecmd->autoneg = AUTONEG_ENABLE;
 			ecmd->supported |= (SUPPORTED_TP |SUPPORTED_Autoneg);
 			ecmd->advertising |=
 				(ADVERTISED_TP | ADVERTISED_Autoneg);
@@ -254,53 +253,24 @@ static int
 netxen_nic_set_settings(struct net_device *dev, struct ethtool_cmd *ecmd)
 {
 	struct netxen_adapter *adapter = netdev_priv(dev);
-	__u32 status;
+	int ret;
 
-	/* read which mode */
-	if (adapter->ahw.port_type == NETXEN_NIC_GBE) {
-		/* autonegotiation */
-		if (adapter->phy_write
-		    && adapter->phy_write(adapter,
-					  NETXEN_NIU_GB_MII_MGMT_ADDR_AUTONEG,
-					  ecmd->autoneg) != 0)
-			return -EIO;
-		else
-			adapter->link_autoneg = ecmd->autoneg;
+	if (adapter->ahw.port_type != NETXEN_NIC_GBE)
+		return -EOPNOTSUPP;
 
-		if (adapter->phy_read
-		    && adapter->phy_read(adapter,
-					 NETXEN_NIU_GB_MII_MGMT_ADDR_PHY_STATUS,
-					 &status) != 0)
-			return -EIO;
+	if (!(adapter->capabilities & NX_FW_CAPABILITY_GBE_LINK_CFG))
+		return -EOPNOTSUPP;
 
-		/* speed */
-		switch (ecmd->speed) {
-		case SPEED_10:
-			netxen_set_phy_speed(status, 0);
-			break;
-		case SPEED_100:
-			netxen_set_phy_speed(status, 1);
-			break;
-		case SPEED_1000:
-			netxen_set_phy_speed(status, 2);
-			break;
-		}
-		/* set duplex mode */
-		if (ecmd->duplex == DUPLEX_HALF)
-			netxen_clear_phy_duplex(status);
-		if (ecmd->duplex == DUPLEX_FULL)
-			netxen_set_phy_duplex(status);
-		if (adapter->phy_write
-		    && adapter->phy_write(adapter,
-					  NETXEN_NIU_GB_MII_MGMT_ADDR_PHY_STATUS,
-					  *((int *)&status)) != 0)
-			return -EIO;
-		else {
-			adapter->link_speed = ecmd->speed;
-			adapter->link_duplex = ecmd->duplex;
-		}
-	} else
+	ret = nx_fw_cmd_set_gbe_port(adapter, ecmd->speed, ecmd->duplex,
+				     ecmd->autoneg);
+	if (ret == NX_RCODE_NOT_SUPPORTED)
 		return -EOPNOTSUPP;
+	else if (ret)
+		return -EIO;
+
+	adapter->link_speed = ecmd->speed;
+	adapter->link_duplex = ecmd->duplex;
+	adapter->link_autoneg = ecmd->autoneg;
 
 	if (!netif_running(dev))
 		return 0;
-- 
1.7.2.1.45.g54fbc



