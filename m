Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758602Ab2J2LD4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 07:03:56 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61272 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758559Ab2J2LDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 07:03:55 -0400
From: YAMANE Toshiaki <yamanetoshi@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, YAMANE Toshiaki <yamanetoshi@gmail.com>
Subject: [PATCH 1/7] staging/gdm72xx: Use netdev_ or pr_ printks in gdm_wimax.c
Date: Mon, 29 Oct 2012 20:03:47 +0900
Message-Id: <1351508627-1713-1-git-send-email-yamanetoshi@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixed below checkpatch warnings.
- WARNING: Prefer netdev_err(netdev, ... then dev_err(dev, ... then pr_err(...  to printk(KERN_ERR ...
- WARNING: Prefer netdev_emerg(netdev, ... then dev_emerg(dev, ... then pr_emerg(...  to printk(KERN_EMERG ...
- WARNING: Prefer netdev_info(netdev, ... then dev_info(dev, ... then pr_info(...  to printk(KERN_INFO ...

and add pr_fmt.

Signed-off-by: YAMANE Toshiaki <yamanetoshi@gmail.com>
---
 drivers/staging/gdm72xx/gdm_wimax.c |   60 ++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index dad6fd3..c302769 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -11,6 +11,8 @@
  * GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/etherdevice.h>
 #include <asm/byteorder.h>
 #include <linux/ip.h>
@@ -274,7 +276,7 @@ static int gdm_wimax_event_init(void)
 		return 0;
 	}
 
-	printk(KERN_ERR "Creating WiMax Event netlink is failed\n");
+	pr_err("Creating WiMax Event netlink is failed\n");
 	return -1;
 }
 
@@ -370,7 +372,7 @@ static int gdm_wimax_event_send(struct net_device *dev, char *buf, int size)
 
 	e = get_event_entry();
 	if (!e) {
-		printk(KERN_ERR "%s: No memory for event\n", __func__);
+		netdev_err(dev, "%s: No memory for event\n", __func__);
 		spin_unlock_irqrestore(&wm_event.evt_lock, flags);
 		return -ENOMEM;
 	}
@@ -436,10 +438,10 @@ static int gdm_wimax_tx(struct sk_buff *skb, struct net_device *dev)
 
 	#if !defined(LOOPBACK_TEST)
 	if (!fsm)
-		printk(KERN_ERR "ASSERTION ERROR: fsm is NULL!!\n");
+		netdev_err(dev, "ASSERTION ERROR: fsm is NULL!!\n");
 	else if (fsm->m_status != M_CONNECTED) {
-		printk(KERN_EMERG "ASSERTION ERROR: Device is NOT ready. status=%d\n",
-			fsm->m_status);
+		netdev_emerg(dev, "ASSERTION ERROR: Device is NOT ready. status=%d\n",
+			     fsm->m_status);
 		kfree_skb(skb);
 		return 0;
 	}
@@ -625,9 +627,8 @@ static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 	case SIOCG_DATA:
 	case SIOCS_DATA:
 		if (req->data_id >= SIOC_DATA_MAX) {
-			printk(KERN_ERR
-				"%s error: data-index(%d) is invalid!!\n",
-				__func__, req->data_id);
+			netdev_err(dev, "%s error: data-index(%d) is invalid!!\n",
+				   __func__, req->data_id);
 			return -EOPNOTSUPP;
 		}
 		if (req->cmd == SIOCG_DATA) {
@@ -649,7 +650,7 @@ static int gdm_wimax_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 		}
 		break;
 	default:
-		printk(KERN_ERR "%s: %x unknown ioctl\n", __func__, cmd);
+		netdev_err(dev, "%s: %x unknown ioctl\n", __func__, cmd);
 		return -EOPNOTSUPP;
 	}
 
@@ -695,7 +696,7 @@ static void gdm_wimax_prepare_device(struct net_device *dev)
 	hci->length = H2B(len);
 	gdm_wimax_send(nic, hci, HCI_HEADER_SIZE+len);
 
-	printk(KERN_INFO "GDM WiMax Set CAPABILITY: 0x%08X\n", DB2H(val));
+	netdev_info(dev, "GDM WiMax Set CAPABILITY: 0x%08X\n", DB2H(val));
 }
 
 static int gdm_wimax_hci_get_tlv(u8 *buf, u8 *T, u16 *L, u8 **V)
@@ -729,28 +730,28 @@ static int gdm_wimax_get_prepared_info(struct net_device *dev, char *buf,
 	cmd_len = B2H(*(u16 *)&buf[2]);
 
 	if (len < cmd_len + HCI_HEADER_SIZE) {
-		printk(KERN_ERR "%s: invalid length [%d/%d]\n", __func__,
-			cmd_len + HCI_HEADER_SIZE, len);
+		netdev_err(dev, "%s: invalid length [%d/%d]\n", __func__,
+			   cmd_len + HCI_HEADER_SIZE, len);
 		return -1;
 	}
 
 	if (cmd_evt == WIMAX_GET_INFO_RESULT) {
 		if (cmd_len < 2) {
-			printk(KERN_ERR "%s: len is too short [%x/%d]\n",
-				__func__, cmd_evt, len);
+			netdev_err(dev, "%s: len is too short [%x/%d]\n",
+				   __func__, cmd_evt, len);
 			return -1;
 		}
 
 		pos += gdm_wimax_hci_get_tlv(&buf[pos], &T, &L, &V);
 		if (T == TLV_T(T_MAC_ADDRESS)) {
 			if (L != dev->addr_len) {
-				printk(KERN_ERR
-					"%s Invalid inofrmation result T/L "
-					"[%x/%d]\n", __func__, T, L);
+				netdev_err(dev,
+					   "%s Invalid inofrmation result T/L [%x/%d]\n",
+					   __func__, T, L);
 				return -1;
 			}
-			printk(KERN_INFO "MAC change [%pM]->[%pM]\n",
-				dev->dev_addr, V);
+			netdev_info(dev, "MAC change [%pM]->[%pM]\n",
+				    dev->dev_addr, V);
 			memcpy(dev->dev_addr, V, dev->addr_len);
 			return 1;
 		}
@@ -772,7 +773,7 @@ static void gdm_wimax_netif_rx(struct net_device *dev, char *buf, int len)
 
 	skb = dev_alloc_skb(len + 2);
 	if (!skb) {
-		printk(KERN_ERR "%s: dev_alloc_skb failed!\n", __func__);
+		netdev_err(dev, "%s: dev_alloc_skb failed!\n", __func__);
 		return;
 	}
 	skb_reserve(skb, 2);
@@ -787,7 +788,7 @@ static void gdm_wimax_netif_rx(struct net_device *dev, char *buf, int len)
 
 	ret = in_interrupt() ? netif_rx(skb) : netif_rx_ni(skb);
 	if (ret == NET_RX_DROP)
-		printk(KERN_ERR "%s skb dropped\n", __func__);
+		netdev_err(dev, "%s skb dropped\n", __func__);
 }
 
 static void gdm_wimax_transmit_aggr_pkt(struct net_device *dev, char *buf,
@@ -802,8 +803,8 @@ static void gdm_wimax_transmit_aggr_pkt(struct net_device *dev, char *buf,
 		hci = (struct hci_s *) buf;
 
 		if (B2H(hci->cmd_evt) != WIMAX_RX_SDU) {
-			printk(KERN_ERR "Wrong cmd_evt(0x%04X)\n",
-				B2H(hci->cmd_evt));
+			netdev_err(dev, "Wrong cmd_evt(0x%04X)\n",
+				   B2H(hci->cmd_evt));
 			break;
 		}
 
@@ -837,8 +838,8 @@ static void gdm_wimax_transmit_pkt(struct net_device *dev, char *buf, int len)
 
 	if (len < cmd_len + HCI_HEADER_SIZE) {
 		if (len)
-			printk(KERN_ERR "%s: invalid length [%d/%d]\n",
-				__func__, cmd_len + HCI_HEADER_SIZE, len);
+			netdev_err(dev, "%s: invalid length [%d/%d]\n",
+				   __func__, cmd_len + HCI_HEADER_SIZE, len);
 		return;
 	}
 
@@ -918,7 +919,8 @@ static void prepare_rx_complete(void *arg, void *data, int len)
 		gdm_wimax_rcv_with_cb(nic, rx_complete, nic);
 	else {
 		if (ret < 0)
-			printk(KERN_ERR "get_prepared_info failed(%d)\n", ret);
+			netdev_err(nic->netdev,
+				   "get_prepared_info failed(%d)\n", ret);
 		gdm_wimax_rcv_with_cb(nic, prepare_rx_complete, nic);
 		#if 0
 		/* Re-prepare WiMax device */
@@ -952,7 +954,7 @@ int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev)
 						"wm%d", ether_setup);
 
 	if (dev == NULL) {
-		printk(KERN_ERR "alloc_etherdev failed\n");
+		pr_err("alloc_etherdev failed\n");
 		return -ENOMEM;
 	}
 
@@ -972,7 +974,7 @@ int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev)
 	/* event socket init */
 	ret = gdm_wimax_event_init();
 	if (ret < 0) {
-		printk(KERN_ERR "Cannot create event.\n");
+		pr_err("Cannot create event.\n");
 		goto cleanup;
 	}
 
@@ -999,7 +1001,7 @@ int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev)
 	return 0;
 
 cleanup:
-	printk(KERN_ERR "register_netdev failed\n");
+	pr_err("register_netdev failed\n");
 	free_netdev(dev);
 	return ret;
 }
-- 
1.7.9.5

