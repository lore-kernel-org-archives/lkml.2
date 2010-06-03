Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab0FCWYY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 18:24:24 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:20054 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755683Ab0FCWYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 18:24:20 -0400
Subject: [PATCH] staging/wlan-ng: Switch from wext to cfg80211
From: Karl Relton <karllinuxtest.relton@ntlworld.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 23:04:06 +0100
Message-ID: <1275602646.2005.13.camel@dellpc>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=ZtHxNT4mZm3rCuM0SmWmgWxeBwJsziC8EqOrwwVkrhA= c=1 sm=0 a=zbtMyLmj2mUA:10 a=hO-oPbc3tlwA:10 a=IkcTkHD0fZMA:10 a=NLZqzBF-AAAA:8 a=hMrpyb_uAAAA:8 a=pQs5aej7AAAA:8 a=uP6skFhOeLYTQF4-PpEA:9 a=B7WNS5DzdWgVuxosbRUA:7 a=mBLrWIWRFdpNvg9i6dFTzrwc9H4A:4 a=QEXdDO2ut3YA:10 a=_dQi-Dcv4p4A:10 a=UqU2K24a38kA:10 a=7BtmIzTBHdUA:10 a=KDFcD2eL8-v2EnUn:21 a=9h1nSavmzmXdoLzp:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch driver over from wext to cfg80211 interface.

Signed-off-by: Karl Relton <karllinuxtest.relton@ntlworld.com>

---

Some Notes:

- Applies against linux-next (as of 20100602), tested on my system

- This patch moves the driver wholesale from wext to cfg80211. Wext
support is still provided through the cfg80211 provided wext
compatability layer.

- Currently only infrastructure mode is implemented. Ad hoc mode is not
yet implemented, but can be added.

- It does not support connecting to a specified bssid, instead roaming
is handled by the card itself. This matches the behaviour of the
existing driver.

- It has been tested using NetworkManager (via wpa_supplicant)
configured to use the wext compatability layer, and then again with the
native nl80211 layer.

--- old/drivers/staging/wlan-ng/Makefile	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/Makefile	2010-06-03 18:34:27.000000000 +0100
@@ -4,5 +4,4 @@ prism2_usb-objs := prism2usb.o \
 		p80211conv.o \
 		p80211req.o \
 		p80211wep.o \
-		p80211wext.o \
 		p80211netdev.o
--- old/drivers/staging/wlan-ng/hfa384x.h	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/hfa384x.h	2010-06-03 18:34:27.000000000 +0100
@@ -1284,6 +1284,8 @@ typedef struct hfa384x {
 	u16 link_status_new;
 	struct sk_buff_head authq;
 
+	u32 txrate;
+
 	/* And here we have stuff that used to be in priv */
 
 	/* State variables */
--- old/drivers/staging/wlan-ng/p80211metastruct.h	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/p80211metastruct.h	2010-06-03 18:34:27.000000000 +0100
@@ -113,6 +113,7 @@ typedef struct p80211msg_dot11req_scan_r
 	p80211item_uint32_t cfpollable;
 	p80211item_uint32_t cfpollreq;
 	p80211item_uint32_t privacy;
+	p80211item_uint32_t capinfo;
 	p80211item_uint32_t basicrate1;
 	p80211item_uint32_t basicrate2;
 	p80211item_uint32_t basicrate3;
@@ -209,6 +210,7 @@ typedef struct p80211msg_lnxreq_commsqua
 	p80211item_uint32_t link;
 	p80211item_uint32_t level;
 	p80211item_uint32_t noise;
+	p80211item_uint32_t txrate;
 } __attribute__ ((packed)) p80211msg_lnxreq_commsquality_t;
 
 typedef struct p80211msg_lnxreq_autojoin {
--- old/drivers/staging/wlan-ng/p80211netdev.c	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/p80211netdev.c	2010-06-03 18:34:27.000000000 +0100
@@ -75,6 +75,7 @@
 
 #include <net/iw_handler.h>
 #include <net/net_namespace.h>
+#include <net/cfg80211.h>
 
 #include "p80211types.h"
 #include "p80211hdr.h"
@@ -87,6 +88,8 @@
 #include "p80211metastruct.h"
 #include "p80211metadef.h"
 
+#include "cfg80211.c"
+
 /* Support functions */
 static void p80211netdev_rx_bh(unsigned long arg);
 
@@ -732,6 +735,7 @@ static const struct net_device_ops p8021
 * Arguments:
 *	wlandev		ptr to the wlandev structure for the
 *			interface.
+*	physdev		ptr to usb device
 * Returns:
 *	zero on success, non-zero otherwise.
 * Call Context:
@@ -740,10 +744,12 @@ static const struct net_device_ops p8021
 *	compiled drivers, this function will be called in the
 *	context of the kernel startup code.
 ----------------------------------------------------------------*/
-int wlan_setup(wlandevice_t *wlandev)
+int wlan_setup(wlandevice_t *wlandev, struct device *physdev)
 {
 	int result = 0;
-	netdevice_t *dev;
+	netdevice_t *netdev;
+	struct wiphy *wiphy;
+	struct wireless_dev *wdev;
 
 	/* Set up the wlandev */
 	wlandev->state = WLAN_DEVICE_CLOSED;
@@ -755,20 +761,30 @@ int wlan_setup(wlandevice_t *wlandev)
 	tasklet_init(&wlandev->rx_bh,
 		     p80211netdev_rx_bh, (unsigned long)wlandev);
 
+	/* Allocate and initialize the wiphy struct */
+	wiphy = wlan_create_wiphy(physdev, wlandev);
+	if (wiphy == NULL) {
+		printk(KERN_ERR "Failed to alloc wiphy.\n");
+		return 1;
+	}
+
 	/* Allocate and initialize the struct device */
-	dev = alloc_netdev(0, "wlan%d", ether_setup);
-	if (dev == NULL) {
+	netdev = alloc_netdev(sizeof(struct wireless_dev), "wlan%d", ether_setup);
+	if (netdev == NULL) {
 		printk(KERN_ERR "Failed to alloc netdev.\n");
+		wlan_free_wiphy(wiphy);
 		result = 1;
 	} else {
-		wlandev->netdev = dev;
-		dev->ml_priv = wlandev;
-		dev->netdev_ops = &p80211_netdev_ops;
-
-		dev->wireless_handlers = &p80211wext_handler_def;
+		wlandev->netdev = netdev;
+		netdev->ml_priv = wlandev;
+		netdev->netdev_ops = &p80211_netdev_ops;
+		wdev = netdev_priv(netdev);
+		wdev->wiphy = wiphy;
+		wdev->iftype = NL80211_IFTYPE_STATION;
+		netdev->ieee80211_ptr = wdev;
 
-		netif_stop_queue(dev);
-		netif_carrier_off(dev);
+		netif_stop_queue(netdev);
+		netif_carrier_off(netdev);
 	}
 
 	return result;
@@ -797,14 +813,13 @@ int wlan_setup(wlandevice_t *wlandev)
 ----------------------------------------------------------------*/
 int wlan_unsetup(wlandevice_t *wlandev)
 {
-	int result = 0;
+	struct wireless_dev *wdev;
 
 	tasklet_kill(&wlandev->rx_bh);
 
-	if (wlandev->netdev == NULL) {
-		printk(KERN_ERR "called without wlandev->netdev set.\n");
-		result = 1;
-	} else {
+	if (wlandev->netdev) {
+		wdev = netdev_priv(wlandev->netdev);
+		if(wdev->wiphy) wlan_free_wiphy(wdev->wiphy);
 		free_netdev(wlandev->netdev);
 		wlandev->netdev = NULL;
 	}
--- old/drivers/staging/wlan-ng/p80211netdev.h	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/p80211netdev.h	2010-06-03 18:34:27.000000000 +0100
@@ -148,6 +148,7 @@ int p80211wext_event_associated(struct w
 #define MAX_KEYLEN 32
 
 #define HOSTWEP_DEFAULTKEY_MASK (BIT(1)|BIT(0))
+#define HOSTWEP_SHAREDKEY BIT(3)
 #define HOSTWEP_DECRYPT  BIT(4)
 #define HOSTWEP_ENCRYPT  BIT(5)
 #define HOSTWEP_PRIVACYINVOKED BIT(6)
@@ -233,7 +234,7 @@ int wep_decrypt(wlandevice_t *wlandev, u
 int wep_encrypt(wlandevice_t *wlandev, u8 *buf, u8 *dst, u32 len, int keynum,
 		u8 *iv, u8 *icv);
 
-int wlan_setup(wlandevice_t *wlandev);
+int wlan_setup(wlandevice_t *wlandev, struct device *physdev);
 int wlan_unsetup(wlandevice_t *wlandev);
 int register_wlandev(wlandevice_t *wlandev);
 int unregister_wlandev(wlandevice_t *wlandev);
--- old/drivers/staging/wlan-ng/prism2mgmt.c	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/prism2mgmt.c	2010-06-03 18:34:27.000000000 +0100
@@ -463,6 +463,8 @@ int prism2mgmt_scan_results(wlandevice_t
 
 	/* capinfo bits */
 	count = le16_to_cpu(item->capinfo);
+	req->capinfo.status = P80211ENUM_msgitem_status_data_ok;
+	req->capinfo.data = count;
 
 	/* privacy flag */
 	req->privacy.status = P80211ENUM_msgitem_status_data_ok;
--- old/drivers/staging/wlan-ng/prism2sta.c	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/prism2sta.c	2010-06-03 18:34:27.000000000 +0100
@@ -124,6 +124,10 @@ MODULE_PARM_DESC(prism2_reset_settletime
 
 MODULE_LICENSE("Dual MPL/GPL");
 
+void prism2_connect_result(wlandevice_t *wlandev, u8 failed);
+void prism2_disconnected(wlandevice_t *wlandev);
+void prism2_roamed(wlandevice_t *wlandev);
+
 static int prism2sta_open(wlandevice_t *wlandev);
 static int prism2sta_close(wlandevice_t *wlandev);
 static void prism2sta_reset(wlandevice_t *wlandev);
@@ -401,6 +405,7 @@ static int prism2sta_mlmerequest(wlandev
 			qualmsg->link.data = le16_to_cpu(hw->qual.CQ_currBSS);
 			qualmsg->level.data = le16_to_cpu(hw->qual.ASL_currBSS);
 			qualmsg->noise.data = le16_to_cpu(hw->qual.ANL_currFC);
+			qualmsg->txrate.data = hw->txrate;
 
 			break;
 		}
@@ -1300,6 +1305,9 @@ void prism2sta_processing_defer(struct w
 			    (portstatus == HFA384x_PSTATUS_CONN_IBSS) ?
 			    WLAN_MACMODE_IBSS_STA : WLAN_MACMODE_ESS_STA;
 
+			/* signal back up to cfg80211 layer */
+			prism2_connect_result(wlandev, P80211ENUM_truth_false);
+
 			/* Get the ball rolling on the comms quality stuff */
 			prism2sta_commsqual_defer(&hw->commsqual_bh);
 		}
@@ -1315,25 +1323,16 @@ void prism2sta_processing_defer(struct w
 		 * Indicate Deauthentication
 		 * Block Transmits, Ignore receives of data frames
 		 */
-		if (hw->join_ap == 2) {
-			hfa384x_JoinRequest_data_t joinreq;
-			joinreq = hw->joinreq;
-			/* Send the join request */
-			hfa384x_drvr_setconfig(hw,
-					       HFA384x_RID_JOINREQUEST,
-					       &joinreq,
-					       HFA384x_RID_JOINREQUEST_LEN);
+		if (wlandev->netdev->type == ARPHRD_ETHER)
 			printk(KERN_INFO
-			    "linkstatus=DISCONNECTED (re-submitting join)\n");
-		} else {
-			if (wlandev->netdev->type == ARPHRD_ETHER)
-				printk(KERN_INFO
-				       "linkstatus=DISCONNECTED (unhandled)\n");
-		}
+			       "linkstatus=DISCONNECTED (unhandled)\n");
 		wlandev->macmode = WLAN_MACMODE_NONE;
 
 		netif_carrier_off(wlandev->netdev);
 
+		/* signal back up to cfg80211 layer */
+		prism2_disconnected(wlandev);
+
 		break;
 
 	case HFA384x_LINK_AP_CHANGE:
@@ -1376,6 +1375,9 @@ void prism2sta_processing_defer(struct w
 		hw->link_status = HFA384x_LINK_CONNECTED;
 		netif_carrier_on(wlandev->netdev);
 
+		/* signal back up to cfg80211 layer */
+		prism2_roamed(wlandev);
+
 		break;
 
 	case HFA384x_LINK_AP_OUTOFRANGE:
@@ -1435,6 +1437,9 @@ void prism2sta_processing_defer(struct w
 
 		netif_carrier_off(wlandev->netdev);
 
+		/* signal back up to cfg80211 layer */
+		prism2_connect_result(wlandev, P80211ENUM_truth_true);
+
 		break;
 
 	default:
@@ -1446,7 +1451,6 @@ void prism2sta_processing_defer(struct w
 	}
 
 	wlandev->linkstatus = (hw->link_status == HFA384x_LINK_CONNECTED);
-	p80211wext_event_associated(wlandev, wlandev->linkstatus);
 
 failed:
 	return;
@@ -1985,6 +1989,8 @@ void prism2sta_commsqual_defer(struct wo
 	hfa384x_t *hw = container_of(data, struct hfa384x, commsqual_bh);
 	wlandevice_t *wlandev = hw->wlandev;
 	hfa384x_bytestr32_t ssid;
+	p80211msg_dot11req_mibget_t msg;
+	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
 	int result = 0;
 
 	if (hw->wlandev->hwremoved)
@@ -2013,6 +2019,34 @@ void prism2sta_commsqual_defer(struct wo
 			 le16_to_cpu(hw->qual.ANL_currFC));
 	}
 
+	/* Get the signal rate */
+	msg.msgcode = DIDmsg_dot11req_mibget;
+	mibitem->did = DIDmib_p2_p2MAC_p2CurrentTxRate;
+	result = p80211req_dorequest(wlandev, (u8 *) & msg);
+
+	if (result) {
+		pr_debug("get signal rate failed, result = %d\n",
+			 result);
+		goto done;
+	}
+
+	switch (mibitem->data) {
+	case HFA384x_RATEBIT_1:
+		hw->txrate = 10;
+		break;
+	case HFA384x_RATEBIT_2:
+		hw->txrate = 20;
+		break;
+	case HFA384x_RATEBIT_5dot5:
+		hw->txrate = 55;
+		break;
+	case HFA384x_RATEBIT_11:
+		hw->txrate = 110;
+		break;
+	default:
+		pr_debug("Bad ratebit (%d)\n", mibitem->data);
+	}
+
 	/* Lastly, we need to make sure the BSSID didn't change on us */
 	result = hfa384x_drvr_getconfig(hw,
 					HFA384x_RID_CURRENTBSSID,
--- old/drivers/staging/wlan-ng/prism2usb.c	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/prism2usb.c	2010-06-03 18:34:28.000000000 +0100
@@ -119,7 +119,7 @@ static int prism2sta_probe_usb(struct us
 	}
 	hw = wlandev->priv;
 
-	if (wlan_setup(wlandev) != 0) {
+	if (wlan_setup(wlandev, &(interface->dev)) != 0) {
 		printk(KERN_ERR "%s: wlan_setup() failed.\n", dev_info);
 		result = -EIO;
 		goto failed;
--- old/drivers/staging/wlan-ng/cfg80211.c	1970-01-01 01:00:00.000000000 +0100
+++ new/drivers/staging/wlan-ng/cfg80211.c	2010-06-03 22:48:06.000000000 +0100
@@ -0,0 +1,735 @@
+/* cfg80211 Interface for prism2_usb module */
+
+
+/* Prism2 channell/frequency/bitrate declarations */
+static const struct ieee80211_channel prism2_channels[] = {
+	{ .center_freq = 2412 },
+	{ .center_freq = 2417 },
+	{ .center_freq = 2422 },
+	{ .center_freq = 2427 },
+	{ .center_freq = 2432 },
+	{ .center_freq = 2437 },
+	{ .center_freq = 2442 },
+	{ .center_freq = 2447 },
+	{ .center_freq = 2452 },
+	{ .center_freq = 2457 },
+	{ .center_freq = 2462 },
+	{ .center_freq = 2467 },
+	{ .center_freq = 2472 },
+	{ .center_freq = 2484 },
+};
+
+static const struct ieee80211_rate prism2_rates[] = {
+	{ .bitrate = 10 },
+	{ .bitrate = 20 },
+	{ .bitrate = 55 },
+	{ .bitrate = 110 }
+};
+
+#define PRISM2_NUM_CIPHER_SUITES 2
+static const u32 prism2_cipher_suites[PRISM2_NUM_CIPHER_SUITES] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104
+};
+
+
+/* prism2 device private data */
+struct prism2_wiphy_private {
+	wlandevice_t *wlandev;
+
+	struct ieee80211_supported_band band;
+	struct ieee80211_channel channels[ARRAY_SIZE(prism2_channels)];
+	struct ieee80211_rate rates[ARRAY_SIZE(prism2_rates)];
+
+	struct cfg80211_scan_request *scan_request;
+};
+
+static const void * const prism2_wiphy_privid = &prism2_wiphy_privid;
+
+
+/* Helper Functions */
+static int prism2_result2err(int prism2_result)
+{
+	int err = 0;
+
+	switch (prism2_result) {
+	case P80211ENUM_resultcode_invalid_parameters:
+		err = -EINVAL;
+		break;
+	case P80211ENUM_resultcode_implementation_failure:
+		err = -EIO;
+		break;
+	case P80211ENUM_resultcode_not_supported:
+		err = -EOPNOTSUPP;
+		break;
+	default:
+		err = 0;
+		break;
+	}
+
+	return err;
+}
+
+static int prism2_domibset_uint32(wlandevice_t *wlandev, u32 did, u32 data)
+{
+	p80211msg_dot11req_mibset_t msg;
+	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
+
+	msg.msgcode = DIDmsg_dot11req_mibset;
+	mibitem->did = did;
+	mibitem->data = data;
+
+	return p80211req_dorequest(wlandev, (u8 *) & msg);
+}
+
+static int prism2_domibset_pstr32(wlandevice_t *wlandev,
+				  u32 did, u8 len, u8 *data)
+{
+	p80211msg_dot11req_mibset_t msg;
+	p80211item_pstr32_t *mibitem = (p80211item_pstr32_t *) &msg.mibattribute.data;
+
+	msg.msgcode = DIDmsg_dot11req_mibset;
+	mibitem->did = did;
+	mibitem->data.len = len;
+	memcpy(mibitem->data.data, data, len);
+
+	return p80211req_dorequest(wlandev, (u8 *) & msg);
+}
+
+
+/* The interface functions, called by the cfg80211 layer */
+int prism2_change_virtual_intf(struct wiphy *wiphy,
+			       struct net_device *dev,
+			       enum nl80211_iftype type, u32 *flags,
+			       struct vif_params *params)
+{
+	wlandevice_t *wlandev = dev->ml_priv;
+	u32 data;
+	int result;
+	int err = 0;
+
+	switch (type) {
+	case NL80211_IFTYPE_ADHOC:
+		if (wlandev->macmode == WLAN_MACMODE_IBSS_STA) goto exit;
+		wlandev->macmode = WLAN_MACMODE_IBSS_STA;
+		data = 0;
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (wlandev->macmode == WLAN_MACMODE_ESS_STA) goto exit;
+		wlandev->macmode = WLAN_MACMODE_ESS_STA;
+		data = 1;
+		break;
+	default:
+		printk(KERN_WARNING "Operation mode: %d not support\n", type);
+		return -EOPNOTSUPP;
+	}
+
+	/* Set Operation mode to the PORT TYPE RID */
+	result = prism2_domibset_uint32(wlandev, DIDmib_p2_p2Static_p2CnfPortType, data);
+
+	if (result)
+		err = -EFAULT;
+    
+	dev->ieee80211_ptr->iftype = type;
+
+exit:
+	return err;
+}
+
+int prism2_add_key(struct wiphy *wiphy, struct net_device *dev,
+		   u8 key_index, const u8 *mac_addr,
+		   struct key_params *params) {
+	wlandevice_t *wlandev = dev->ml_priv;
+	u32 did;
+
+	int err = 0;
+	int result = 0;
+
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		result = prism2_domibset_uint32(wlandev,
+			DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
+			key_index);
+		if (result) goto exit;
+
+		/* send key to driver */
+		switch (key_index) {
+		case 0:
+			did =
+			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
+			break;
+
+		case 1:
+			did =
+			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
+			break;
+
+		case 2:
+			did =
+			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
+			break;
+
+		case 3:
+			did =
+			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
+			break;
+
+		default:
+			err = -EINVAL;
+			goto exit;
+		}
+
+		result = prism2_domibset_pstr32(wlandev, did, params->key_len, params->key);
+		if (result) goto exit;
+		break;
+
+	default:
+		pr_debug("Unsupported cipher suite\n");
+		result = 1;
+	}
+
+exit:
+	if (result) err = -EFAULT;
+
+	return err;
+}
+
+int prism2_get_key(struct wiphy *wiphy, struct net_device *dev,
+		   u8 key_index, const u8 *mac_addr, void *cookie,
+		   void (*callback)(void *cookie, struct key_params*)) {
+	wlandevice_t *wlandev = dev->ml_priv;
+	struct key_params params;
+	int len;
+
+	if(key_index >= NUM_WEPKEYS) return -EINVAL;
+
+	len = wlandev->wep_keylens[key_index];
+	memset(&params, 0, sizeof(params));
+
+	if (len == 13) {
+		params.cipher = WLAN_CIPHER_SUITE_WEP104;
+	} else if (len == 5) {
+		params.cipher = WLAN_CIPHER_SUITE_WEP104;
+	} else return -ENOENT;
+	params.key_len = len;
+	params.key = wlandev->wep_keys[key_index];
+
+	callback(cookie, &params);
+	return 0;
+}
+
+int prism2_del_key(struct wiphy *wiphy, struct net_device *dev,
+		   u8 key_index, const u8 *mac_addr) {
+	wlandevice_t *wlandev = dev->ml_priv;
+	u32 did;
+	int err = 0;
+	int result = 0;
+
+	/* There is no direct way in the hardware (AFAIK) of removing
+	   a key, so we will cheat by setting the key to a bogus value */
+	/* send key to driver */
+	switch (key_index) {
+	case 0:
+		did =
+		    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
+		break;
+
+	case 1:
+		did =
+		    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
+		break;
+
+	case 2:
+		did =
+		    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
+		break;
+
+	case 3:
+		did =
+		    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
+		break;
+
+	default:
+		err = -EINVAL;
+		goto exit;
+	}
+
+	result = prism2_domibset_pstr32(wlandev, did, 13, "0000000000000");
+
+exit:
+	if (result) err = -EFAULT;
+
+	return err;
+}
+
+int prism2_set_default_key(struct wiphy *wiphy, struct net_device *dev,
+			   u8 key_index) {
+	wlandevice_t *wlandev = dev->ml_priv;
+
+	int err = 0;
+	int result = 0;
+
+	result = prism2_domibset_uint32(wlandev,
+		DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
+		key_index);
+
+	if (result) err = -EFAULT;
+
+	return err;
+}
+
+
+int prism2_get_station(struct wiphy *wiphy, struct net_device *dev,
+		       u8 *mac, struct station_info *sinfo) {
+	wlandevice_t *wlandev = dev->ml_priv;
+	p80211msg_lnxreq_commsquality_t quality;
+	int result;
+
+	memset(sinfo, 0, sizeof(*sinfo));
+
+	if ((wlandev == NULL) || (wlandev->msdstate != WLAN_MSD_RUNNING))
+		return -EOPNOTSUPP;
+
+	/* build request message */
+	quality.msgcode = DIDmsg_lnxreq_commsquality;
+	quality.dbm.data = P80211ENUM_truth_true;
+	quality.dbm.status = P80211ENUM_msgitem_status_data_ok;
+
+	/* send message to nsd */
+	if (wlandev->mlmerequest == NULL)
+		return -EOPNOTSUPP;
+
+	result = wlandev->mlmerequest(wlandev, (p80211msg_t *) & quality);
+
+
+	if (result == 0) {
+		sinfo->txrate.legacy = quality.txrate.data;
+		sinfo->filled |= STATION_INFO_TX_BITRATE;
+		sinfo->signal = quality.level.data;
+		sinfo->filled |= STATION_INFO_SIGNAL;
+	}
+
+	return result;
+}
+
+int prism2_scan(struct wiphy *wiphy, struct net_device *dev,
+	       struct cfg80211_scan_request *request)
+{
+	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
+	wlandevice_t *wlandev = dev->ml_priv;
+	p80211msg_dot11req_scan_t msg1;
+	p80211msg_dot11req_scan_results_t msg2;
+	int result;
+	int err = 0;
+	int numbss = 0;
+	int i = 0;
+	u8 ie_buf[46];
+	int ie_len;
+
+	if (!request)
+		return -EINVAL;
+
+	if (priv->scan_request && priv->scan_request != request)
+		return -EBUSY;
+
+	if (wlandev->macmode == WLAN_MACMODE_ESS_AP) {
+		printk(KERN_ERR "Can't scan in AP mode\n");
+		return -EOPNOTSUPP;
+	}
+
+	priv->scan_request = request;
+
+	memset(&msg1, 0x00, sizeof(p80211msg_dot11req_scan_t));
+	msg1.msgcode = DIDmsg_dot11req_scan;
+	msg1.bsstype.data = P80211ENUM_bsstype_any;
+
+	memset(&(msg1.bssid.data), 0xFF, sizeof(p80211item_pstr6_t));
+	msg1.bssid.data.len = 6;
+
+	if (request->n_ssids > 0) {
+		msg1.scantype.data = P80211ENUM_scantype_active;
+		msg1.ssid.data.len = request->ssids->ssid_len;
+		memcpy(msg1.ssid.data.data, request->ssids->ssid, request->ssids->ssid_len);
+	} else {
+		msg1.scantype.data = 0;
+	}
+	msg1.probedelay.data = 0;
+
+	for (i = 0;
+		(i < request->n_channels) && i < ARRAY_SIZE(prism2_channels);
+		i++)
+		msg1.channellist.data.data[i] =
+			ieee80211_frequency_to_channel(request->channels[i]->center_freq);
+	msg1.channellist.data.len = request->n_channels;
+
+	msg1.maxchanneltime.data = 250;
+	msg1.minchanneltime.data = 200;
+
+	result = p80211req_dorequest(wlandev, (u8 *) &msg1);
+	if (result) {
+		err = prism2_result2err(msg1.resultcode.data);
+		goto exit;
+	}
+	/* Now retrieve scan results */
+	numbss = msg1.numbss.data;
+
+	for (i = 0; i < numbss; i++) {
+		memset(&msg2, 0, sizeof(msg2));
+		msg2.msgcode = DIDmsg_dot11req_scan_results;
+		msg2.bssindex.data = i;
+
+		result = p80211req_dorequest(wlandev, (u8 *) &msg2);
+		if ((result != 0) ||
+		    (msg2.resultcode.data != P80211ENUM_resultcode_success)) {
+			break;
+		}
+
+		ie_buf[0] = WLAN_EID_SSID;
+		ie_buf[1] = msg2.ssid.data.len;
+		ie_len = ie_buf[1] + 2;
+		memcpy(&ie_buf[2], &(msg2.ssid.data.data), msg2.ssid.data.len);
+		cfg80211_inform_bss(wiphy,
+			ieee80211_get_channel(wiphy, ieee80211_dsss_chan_to_freq(msg2.dschannel.data)),
+			(const u8 *) &(msg2.bssid.data.data),
+			msg2.timestamp.data, msg2.capinfo.data,
+			msg2.beaconperiod.data,
+			ie_buf,
+			ie_len,
+			(msg2.signal.data - 65536) * 100, /* Conversion to signed type */
+			GFP_KERNEL
+		);
+	}
+
+	if (result) {
+		err = prism2_result2err(msg2.resultcode.data);
+	}
+
+exit:
+	cfg80211_scan_done(request, err ? 1 : 0);
+	priv->scan_request = NULL;
+	return err;
+}
+
+int prism2_set_wiphy_params(struct wiphy *wiphy, u32 changed) {
+	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
+	wlandevice_t *wlandev = priv->wlandev;
+	u32 data;
+	int result;
+	int err = 0;
+
+	if (changed & WIPHY_PARAM_RTS_THRESHOLD) {
+		if (wiphy->rts_threshold == -1)
+			data = 2347;
+		else
+			data = wiphy->rts_threshold;
+
+		result =
+			prism2_domibset_uint32(wlandev,
+				DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold,
+				data);
+		if (result) {
+			err = -EFAULT;
+			goto exit;
+		}
+	}
+
+	if (changed & WIPHY_PARAM_FRAG_THRESHOLD) {
+			
+		if (wiphy->frag_threshold == -1)
+			data = 2346;
+		else
+			data = wiphy->frag_threshold;
+
+		result =
+			prism2_domibset_uint32(wlandev,
+				DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
+				data);
+		if (result) {
+			err = -EFAULT;
+			goto exit;
+		}
+	}
+
+exit:
+	return err;
+}
+
+int prism2_connect(struct wiphy *wiphy, struct net_device *dev,
+		   struct cfg80211_connect_params *sme) {
+	wlandevice_t *wlandev = dev->ml_priv;
+	struct ieee80211_channel *channel = sme->channel;
+	p80211msg_lnxreq_autojoin_t msg_join;
+	u32 did;
+	int length = sme->ssid_len;
+	int chan = -1;
+	int is_wep = (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP40) ||
+	    (sme->crypto.cipher_group == WLAN_CIPHER_SUITE_WEP104);
+	int result;
+	int err = 0;
+
+	/* Set the channel */
+	if (channel) {
+		chan = ieee80211_frequency_to_channel(channel->center_freq);
+		
+		result =
+			prism2_domibset_uint32(wlandev,
+				DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel,
+				chan);
+
+		if (result) goto exit;
+	}
+
+	/* Set the authorisation */
+	if ((sme->auth_type == NL80211_AUTHTYPE_OPEN_SYSTEM) ||
+		((sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC) && !is_wep))
+			msg_join.authtype.data = P80211ENUM_authalg_opensystem;
+	else if ((sme->auth_type == NL80211_AUTHTYPE_SHARED_KEY) ||
+		((sme->auth_type == NL80211_AUTHTYPE_AUTOMATIC) && is_wep))
+			msg_join.authtype.data = P80211ENUM_authalg_sharedkey;
+	else printk(KERN_WARNING "Unhandled authorisation type for connect (%d)\n", sme->auth_type);
+
+	/* Set the encryption - we only support wep */
+	if (is_wep) {
+
+		if (sme->key) {
+			result = prism2_domibset_uint32(wlandev,
+				DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
+				sme->key_idx);
+			if (result) goto exit;
+
+			/* send key to driver */
+			switch (sme->key_idx) {
+			case 0:
+				did =
+				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
+				break;
+
+			case 1:
+				did =
+				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
+				break;
+
+			case 2:
+				did =
+				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
+				break;
+
+			case 3:
+				did =
+				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
+				break;
+
+			default:
+				err = -EINVAL;
+				goto exit;
+			}
+
+			result = prism2_domibset_pstr32(wlandev, did, sme->key_len, (u8 *) sme->key);
+			if (result) goto exit;
+
+		}
+
+		/* Assume we should set privacy invoked and exclude unencrypted
+		   We could possibly use sme->privacy here, but the assumption
+		   seems reasonable anyway */
+		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
+			 P80211ENUM_truth_true);
+		if (result) goto exit;
+		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
+			 P80211ENUM_truth_true);
+		if (result) goto exit;
+
+	} else {
+		/* Assume we should unset privacy invoked and exclude unencrypted */
+		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
+			 P80211ENUM_truth_false);
+		if (result) goto exit;
+		result = prism2_domibset_uint32(wlandev, DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
+			 P80211ENUM_truth_false);
+		if (result) goto exit;
+
+	}
+
+	/* Now do the actual join. Note there is no way that I can
+	   see to request a specific bssid */
+	msg_join.msgcode = DIDmsg_lnxreq_autojoin;
+
+	memcpy(msg_join.ssid.data.data, sme->ssid, length);
+	msg_join.ssid.data.len = length;
+
+	result = p80211req_dorequest(wlandev, (u8 *) & msg_join);
+
+exit:
+	if (result) err = -EFAULT;
+
+	return err;
+}
+
+int prism2_disconnect(struct wiphy *wiphy, struct net_device *dev,
+		      u16 reason_code) {
+	wlandevice_t *wlandev = dev->ml_priv;
+	p80211msg_lnxreq_autojoin_t msg_join;
+	int result;
+	int err = 0;
+
+
+	/* Do a join, with a bogus ssid. Thats the only way I can think of */
+	msg_join.msgcode = DIDmsg_lnxreq_autojoin;
+
+	memcpy(msg_join.ssid.data.data, "---", 3);
+	msg_join.ssid.data.len = 3;
+
+	result = p80211req_dorequest(wlandev, (u8 *) & msg_join);
+
+	if (result) err = -EFAULT;
+
+	return err;
+}
+
+
+int prism2_join_ibss(struct wiphy *wiphy, struct net_device *dev,
+		     struct cfg80211_ibss_params *params) {
+	return -EOPNOTSUPP;
+}
+
+int prism2_leave_ibss(struct wiphy *wiphy, struct net_device *dev) {
+	return -EOPNOTSUPP;
+}
+
+
+int prism2_set_tx_power(struct wiphy *wiphy,
+			enum tx_power_setting type, int dbm) {
+	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
+	wlandevice_t *wlandev = priv->wlandev;
+	u32 data;
+	int result;
+	int err = 0;
+
+	if (type == TX_POWER_AUTOMATIC)
+		data = 30;
+	else
+		data = dbm;
+
+	result = prism2_domibset_uint32(wlandev,
+		DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel,
+		data);
+
+	if (result) {
+		err = -EFAULT;
+		goto exit;
+	}
+
+exit:
+	return err;
+}
+
+int prism2_get_tx_power(struct wiphy *wiphy, int *dbm) {
+	struct prism2_wiphy_private *priv = wiphy_priv(wiphy);
+	wlandevice_t *wlandev = priv->wlandev;
+	p80211msg_dot11req_mibget_t msg;
+	p80211item_uint32_t *mibitem = (p80211item_uint32_t *) &msg.mibattribute.data;
+	int result;
+	int err = 0;
+
+	msg.msgcode = DIDmsg_dot11req_mibget;
+	mibitem->did =
+	    DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel;
+
+	result = p80211req_dorequest(wlandev, (u8 *) & msg);
+
+	if (result) {
+		err = -EFAULT;
+		goto exit;
+	}
+
+	*dbm = mibitem->data;
+
+exit:
+	return err;
+}
+
+
+
+
+/* Interface callback functions, passing data back up to the cfg80211 layer */
+void	prism2_connect_result(wlandevice_t *wlandev, u8 failed) {
+
+	cfg80211_connect_result(wlandev->netdev, wlandev->bssid,
+		NULL, 0, NULL, 0,
+		failed ? WLAN_STATUS_UNSPECIFIED_FAILURE : WLAN_STATUS_SUCCESS, GFP_KERNEL);
+}
+
+void	prism2_disconnected(wlandevice_t *wlandev) {
+
+	cfg80211_disconnected(wlandev->netdev, 0, NULL,
+		0, GFP_KERNEL);
+}
+
+void	prism2_roamed(wlandevice_t *wlandev) {
+
+	cfg80211_roamed(wlandev->netdev, wlandev->bssid,
+		NULL, 0, NULL, 0, GFP_KERNEL);
+}
+
+
+/* Structures for declaring wiphy interface */
+static const struct cfg80211_ops prism2_usb_cfg_ops = {
+	.change_virtual_intf = prism2_change_virtual_intf,
+	.add_key = prism2_add_key,
+	.get_key = prism2_get_key,
+	.del_key = prism2_del_key,
+	.set_default_key = prism2_set_default_key,
+	.get_station = prism2_get_station,
+	.scan = prism2_scan,
+	.set_wiphy_params = prism2_set_wiphy_params,
+	.connect = prism2_connect,
+	.disconnect = prism2_disconnect,
+	.join_ibss = prism2_join_ibss,
+	.leave_ibss = prism2_leave_ibss,
+	.set_tx_power = prism2_set_tx_power,
+	.get_tx_power = prism2_get_tx_power,
+};
+
+
+/* Functions to create/free wiphy interface */
+struct wiphy *wlan_create_wiphy(struct device *dev, wlandevice_t *wlandev)
+{
+	struct wiphy *wiphy;
+	struct prism2_wiphy_private *priv;
+	wiphy = wiphy_new(&prism2_usb_cfg_ops, sizeof(struct prism2_wiphy_private));
+	if (!wiphy)
+		return NULL;
+
+	priv = wiphy_priv(wiphy);
+	priv->wlandev = wlandev;
+	memcpy(priv->channels, prism2_channels, sizeof(prism2_channels));
+	memcpy(priv->rates, prism2_rates, sizeof(prism2_rates));
+	priv->band.channels = priv->channels;
+	priv->band.n_channels = ARRAY_SIZE(prism2_channels);
+	priv->band.bitrates = priv->rates;
+	priv->band.n_bitrates = ARRAY_SIZE(prism2_rates);
+	wiphy->bands[IEEE80211_BAND_2GHZ] = &priv->band;
+
+	set_wiphy_dev(wiphy, dev);
+	wiphy->privid = prism2_wiphy_privid;
+	wiphy->max_scan_ssids = 1;
+	wiphy->interface_modes =
+		BIT(NL80211_IFTYPE_STATION) |
+		BIT(NL80211_IFTYPE_ADHOC);
+	wiphy->signal_type = CFG80211_SIGNAL_TYPE_MBM;
+	wiphy->n_cipher_suites = PRISM2_NUM_CIPHER_SUITES;
+	wiphy->cipher_suites = prism2_cipher_suites;
+
+	if (wiphy_register(wiphy) < 0)
+		return NULL;
+
+	return wiphy;
+}
+
+
+void wlan_free_wiphy(struct wiphy *wiphy)
+{
+	wiphy_unregister(wiphy);
+	wiphy_free(wiphy);
+}
--- old/drivers/staging/wlan-ng/p80211wext.c	2010-05-30 21:21:02.000000000 +0100
+++ new/drivers/staging/wlan-ng/p80211wext.c	1970-01-01 01:00:00.000000000 +0100
@@ -1,1690 +0,0 @@
-/* src/p80211/p80211wext.c
-*
-* Glue code to make linux-wlan-ng a happy wireless extension camper.
-*
-* original author:  Reyk Floeter <reyk@synack.de>
-* Completely re-written by Solomon Peachy <solomon@linux-wlan.com>
-*
-* Copyright (C) 2002 AbsoluteValue Systems, Inc.  All Rights Reserved.
-* --------------------------------------------------------------------
-*
-* linux-wlan
-*
-*   The contents of this file are subject to the Mozilla Public
-*   License Version 1.1 (the "License"); you may not use this file
-*   except in compliance with the License. You may obtain a copy of
-*   the License at http://www.mozilla.org/MPL/
-*
-*   Software distributed under the License is distributed on an "AS
-*   IS" basis, WITHOUT WARRANTY OF ANY KIND, either express or
-*   implied. See the License for the specific language governing
-*   rights and limitations under the License.
-*
-*   Alternatively, the contents of this file may be used under the
-*   terms of the GNU Public License version 2 (the "GPL"), in which
-*   case the provisions of the GPL are applicable instead of the
-*   above.  If you wish to allow the use of your version of this file
-*   only under the terms of the GPL and not to allow others to use
-*   your version of this file under the MPL, indicate your decision
-*   by deleting the provisions above and replace them with the notice
-*   and other provisions required by the GPL.  If you do not delete
-*   the provisions above, a recipient may use your version of this
-*   file under either the MPL or the GPL.
-*
-* --------------------------------------------------------------------
-*/
-
-/*================================================================*/
-/* System Includes */
-
-#include <linux/kernel.h>
-#include <linux/sched.h>
-#include <linux/types.h>
-#include <linux/netdevice.h>
-#include <linux/etherdevice.h>
-#include <linux/wireless.h>
-#include <net/iw_handler.h>
-#include <linux/if_arp.h>
-#include <linux/bitops.h>
-#include <linux/uaccess.h>
-#include <asm/byteorder.h>
-#include <linux/if_ether.h>
-
-#include "p80211types.h"
-#include "p80211hdr.h"
-#include "p80211conv.h"
-#include "p80211mgmt.h"
-#include "p80211msg.h"
-#include "p80211metastruct.h"
-#include "p80211metadef.h"
-#include "p80211netdev.h"
-#include "p80211ioctl.h"
-#include "p80211req.h"
-
-static int p80211wext_giwrate(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_param *rrq, char *extra);
-static int p80211wext_giwessid(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *data, char *essid);
-
-static u8 p80211_mhz_to_channel(u16 mhz)
-{
-	if (mhz >= 5000)
-		return (mhz - 5000) / 5;
-
-	if (mhz == 2484)
-		return 14;
-
-	if (mhz >= 2407)
-		return (mhz - 2407) / 5;
-
-	return 0;
-}
-
-static u16 p80211_channel_to_mhz(u8 ch, int dot11a)
-{
-
-	if (ch == 0)
-		return 0;
-	if (ch > 200)
-		return 0;
-
-	/* 5G */
-	if (dot11a)
-		return 5000 + (5 * ch);
-
-	/* 2.4G */
-	if (ch == 14)
-		return 2484;
-
-	if ((ch < 14) && (ch > 0))
-		return 2407 + (5 * ch);
-
-	return 0;
-}
-
-/* taken from orinoco.c ;-) */
-static const long p80211wext_channel_freq[] = {
-	2412, 2417, 2422, 2427, 2432, 2437, 2442,
-	2447, 2452, 2457, 2462, 2467, 2472, 2484
-};
-
-#define NUM_CHANNELS ARRAY_SIZE(p80211wext_channel_freq)
-
-/* steal a spare bit to store the shared/opensystems state.
-   should default to open if not set */
-#define HOSTWEP_SHAREDKEY BIT(3)
-
-static int qual_as_percent(int snr)
-{
-	if (snr <= 0)
-		return 0;
-	if (snr <= 40)
-		return snr * 5 / 2;
-	return 100;
-}
-
-static int p80211wext_setmib(wlandevice_t *wlandev, u32 did, u32 data)
-{
-	p80211msg_dot11req_mibset_t msg;
-	p80211item_uint32_t *mibitem =
-		(p80211item_uint32_t *)&msg.mibattribute.data;
-	int result;
-
-	msg.msgcode = DIDmsg_dot11req_mibset;
-	memset(mibitem, 0, sizeof(*mibitem));
-	mibitem->did = did;
-	mibitem->data = data;
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
-	return result;
-}
-
-/*
- * get a 32 bit mib value
- */
-static int p80211wext_getmib(wlandevice_t *wlandev, u32 did, u32 *data)
-{
-	p80211msg_dot11req_mibset_t msg;
-	p80211item_uint32_t *mibitem =
-		(p80211item_uint32_t *)&msg.mibattribute.data;
-	int result;
-
-	msg.msgcode = DIDmsg_dot11req_mibget;
-	memset(mibitem, 0, sizeof(*mibitem));
-	mibitem->did = did;
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-	if (!result)
-		*data = mibitem->data;
-
-	return result;
-}
-
-static int p80211wext_autojoin(wlandevice_t *wlandev)
-{
-	p80211msg_lnxreq_autojoin_t msg;
-	struct iw_point data;
-	char ssid[IW_ESSID_MAX_SIZE];
-
-	int result;
-	int err = 0;
-
-	/* Get ESSID */
-	result = p80211wext_giwessid(wlandev->netdev, NULL, &data, ssid);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	if (wlandev->hostwep & HOSTWEP_SHAREDKEY)
-		msg.authtype.data = P80211ENUM_authalg_sharedkey;
-	else
-		msg.authtype.data = P80211ENUM_authalg_opensystem;
-
-	msg.msgcode = DIDmsg_lnxreq_autojoin;
-
-	/* Trim the last '\0' to fit the SSID format */
-
-	if (data.length && ssid[data.length - 1] == '\0')
-		data.length = data.length - 1;
-
-	memcpy(msg.ssid.data.data, ssid, data.length);
-	msg.ssid.data.len = data.length;
-
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-exit:
-
-	return err;
-
-}
-
-/* called by /proc/net/wireless */
-struct iw_statistics *p80211wext_get_wireless_stats(netdevice_t *dev)
-{
-	p80211msg_lnxreq_commsquality_t quality;
-	wlandevice_t *wlandev = dev->ml_priv;
-	struct iw_statistics *wstats = &wlandev->wstats;
-	int retval;
-
-	/* Check */
-	if ((wlandev == NULL) || (wlandev->msdstate != WLAN_MSD_RUNNING))
-		return NULL;
-
-	/* XXX Only valid in station mode */
-	wstats->status = 0;
-
-	/* build request message */
-	quality.msgcode = DIDmsg_lnxreq_commsquality;
-	quality.dbm.data = P80211ENUM_truth_true;
-	quality.dbm.status = P80211ENUM_msgitem_status_data_ok;
-
-	/* send message to nsd */
-	if (wlandev->mlmerequest == NULL)
-		return NULL;
-
-	retval = wlandev->mlmerequest(wlandev, (p80211msg_t *) &quality);
-
-	wstats->qual.qual = qual_as_percent(quality.link.data);	/* overall link quality */
-	wstats->qual.level = quality.level.data;	/* instant signal level */
-	wstats->qual.noise = quality.noise.data;	/* instant noise level */
-
-	wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
-	wstats->discard.code = wlandev->rx.decrypt_err;
-	wstats->discard.nwid = 0;
-	wstats->discard.misc = 0;
-
-	wstats->discard.fragment = 0;	/* incomplete fragments */
-	wstats->discard.retries = 0;	/* tx retries. */
-	wstats->miss.beacon = 0;
-
-	return wstats;
-}
-
-static int p80211wext_giwname(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      char *name, char *extra)
-{
-	struct iw_param rate;
-	int result;
-	int err = 0;
-
-	result = p80211wext_giwrate(dev, NULL, &rate, NULL);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	switch (rate.value) {
-	case 1000000:
-	case 2000000:
-		strcpy(name, "IEEE 802.11-DS");
-		break;
-	case 5500000:
-	case 11000000:
-		strcpy(name, "IEEE 802.11-b");
-		break;
-	}
-exit:
-	return err;
-}
-
-static int p80211wext_giwfreq(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_freq *freq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	result = p80211wext_getmib(wlandev,
-				   DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel,
-				   &value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	if (value > NUM_CHANNELS) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	/* convert into frequency instead of a channel */
-	freq->e = 1;
-	freq->m = p80211_channel_to_mhz(value, 0) * 100000;
-
-exit:
-	return err;
-}
-
-static int p80211wext_siwfreq(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_freq *freq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	if (!wlan_wext_write) {
-		err = -EOPNOTSUPP;
-		goto exit;
-	}
-
-	if ((freq->e == 0) && (freq->m <= 1000))
-		value = freq->m;
-	else
-		value = p80211_mhz_to_channel(freq->m);
-
-	result = p80211wext_setmib(wlandev,
-			     DIDmib_dot11phy_dot11PhyDSSSTable_dot11CurrentChannel,
-			     value);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-exit:
-	return err;
-}
-
-static int p80211wext_giwmode(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      __u32 *mode, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-
-	switch (wlandev->macmode) {
-	case WLAN_MACMODE_IBSS_STA:
-		*mode = IW_MODE_ADHOC;
-		break;
-	case WLAN_MACMODE_ESS_STA:
-		*mode = IW_MODE_INFRA;
-		break;
-	case WLAN_MACMODE_ESS_AP:
-		*mode = IW_MODE_MASTER;
-		break;
-	default:
-		/* Not set yet. */
-		*mode = IW_MODE_AUTO;
-	}
-
-	return 0;
-}
-
-static int p80211wext_siwmode(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      __u32 *mode, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-
-	if (!wlan_wext_write) {
-		err = -EOPNOTSUPP;
-		goto exit;
-	}
-
-	if (*mode != IW_MODE_ADHOC && *mode != IW_MODE_INFRA &&
-	    *mode != IW_MODE_MASTER) {
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	/* Operation mode is the same with current mode */
-	if (*mode == wlandev->macmode)
-		goto exit;
-
-	switch (*mode) {
-	case IW_MODE_ADHOC:
-		wlandev->macmode = WLAN_MACMODE_IBSS_STA;
-		break;
-	case IW_MODE_INFRA:
-		wlandev->macmode = WLAN_MACMODE_ESS_STA;
-		break;
-	case IW_MODE_MASTER:
-		wlandev->macmode = WLAN_MACMODE_ESS_AP;
-		break;
-	default:
-		/* Not set yet. */
-		printk(KERN_INFO "Operation mode: %d not support\n", *mode);
-		return -EOPNOTSUPP;
-	}
-
-	/* Set Operation mode to the PORT TYPE RID */
-	result = p80211wext_setmib(wlandev,
-				DIDmib_p2_p2Static_p2CnfPortType,
-				(*mode == IW_MODE_ADHOC) ? 0 : 1);
-	if (result)
-		err = -EFAULT;
-exit:
-	return err;
-}
-
-static int p80211wext_giwrange(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *data, char *extra)
-{
-	struct iw_range *range = (struct iw_range *)extra;
-	int i, val;
-
-	/* for backward compatability set size and zero everything we don't understand */
-	data->length = sizeof(*range);
-	memset(range, 0, sizeof(*range));
-
-	range->txpower_capa = IW_TXPOW_DBM;
-	/* XXX what about min/max_pmp, min/max_pmt, etc. */
-
-	range->we_version_compiled = WIRELESS_EXT;
-	range->we_version_source = 13;
-
-	range->retry_capa = IW_RETRY_LIMIT;
-	range->retry_flags = IW_RETRY_LIMIT;
-	range->min_retry = 0;
-	range->max_retry = 255;
-
-	range->event_capa[0] = (IW_EVENT_CAPA_K_0 |	/* mode/freq/ssid */
-				IW_EVENT_CAPA_MASK(SIOCGIWAP) |
-				IW_EVENT_CAPA_MASK(SIOCGIWSCAN));
-	range->event_capa[1] = IW_EVENT_CAPA_K_1;	/* encode */
-	range->event_capa[4] = (IW_EVENT_CAPA_MASK(IWEVQUAL) |
-				IW_EVENT_CAPA_MASK(IWEVCUSTOM));
-
-	range->num_channels = NUM_CHANNELS;
-
-	/* XXX need to filter against the regulatory domain &| active set */
-	val = 0;
-	for (i = 0; i < NUM_CHANNELS; i++) {
-		range->freq[val].i = i + 1;
-		range->freq[val].m = p80211wext_channel_freq[i] * 100000;
-		range->freq[val].e = 1;
-		val++;
-	}
-
-	range->num_frequency = val;
-
-	/* Max of /proc/net/wireless */
-	range->max_qual.qual = 100;
-	range->max_qual.level = 0;
-	range->max_qual.noise = 0;
-	range->sensitivity = 3;
-	/* XXX these need to be nsd-specific! */
-
-	range->min_rts = 0;
-	range->max_rts = 2347;
-	range->min_frag = 256;
-	range->max_frag = 2346;
-
-	range->max_encoding_tokens = NUM_WEPKEYS;
-	range->num_encoding_sizes = 2;
-	range->encoding_size[0] = 5;
-	range->encoding_size[1] = 13;
-
-	/* XXX what about num_bitrates/throughput? */
-	range->num_bitrates = 0;
-
-	/* estimated max throughput */
-	/* XXX need to cap it if we're running at ~2Mbps.. */
-	range->throughput = 5500000;
-
-	return 0;
-}
-
-static int p80211wext_giwap(netdevice_t *dev,
-			    struct iw_request_info *info,
-			    struct sockaddr *ap_addr, char *extra)
-{
-
-	wlandevice_t *wlandev = dev->ml_priv;
-
-	memcpy(ap_addr->sa_data, wlandev->bssid, WLAN_BSSID_LEN);
-	ap_addr->sa_family = ARPHRD_ETHER;
-
-	return 0;
-}
-
-static int p80211wext_giwencode(netdevice_t *dev,
-				struct iw_request_info *info,
-				struct iw_point *erq, char *key)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int err = 0;
-	int i;
-
-	i = (erq->flags & IW_ENCODE_INDEX) - 1;
-	erq->flags = 0;
-
-	if (wlandev->hostwep & HOSTWEP_PRIVACYINVOKED)
-		erq->flags |= IW_ENCODE_ENABLED;
-	else
-		erq->flags |= IW_ENCODE_DISABLED;
-
-	if (wlandev->hostwep & HOSTWEP_EXCLUDEUNENCRYPTED)
-		erq->flags |= IW_ENCODE_RESTRICTED;
-	else
-		erq->flags |= IW_ENCODE_OPEN;
-
-	i = (erq->flags & IW_ENCODE_INDEX) - 1;
-
-	if (i == -1)
-		i = wlandev->hostwep & HOSTWEP_DEFAULTKEY_MASK;
-
-	if ((i < 0) || (i >= NUM_WEPKEYS)) {
-		err = -EINVAL;
-		goto exit;
-	}
-
-	erq->flags |= i + 1;
-
-	/* copy the key from the driver cache as the keys are read-only MIBs */
-	erq->length = wlandev->wep_keylens[i];
-	memcpy(key, wlandev->wep_keys[i], erq->length);
-
-exit:
-	return err;
-}
-
-static int p80211wext_siwencode(netdevice_t *dev,
-				struct iw_request_info *info,
-				struct iw_point *erq, char *key)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	p80211msg_dot11req_mibset_t msg;
-	p80211item_pstr32_t pstr;
-
-	int err = 0;
-	int result = 0;
-	int i;
-
-	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	/* Check the Key index first. */
-	i = (erq->flags & IW_ENCODE_INDEX);
-	if (i) {
-		if ((i < 1) || (i > NUM_WEPKEYS)) {
-			err = -EINVAL;
-			goto exit;
-		} else {
-			i--;
-		}
-		/* Set current key number only if no keys are given */
-		if (erq->flags & IW_ENCODE_NOKEY) {
-			result =
-				p80211wext_setmib(wlandev,
-						  DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
-						  i);
-
-			if (result) {
-				err = -EFAULT;
-				goto exit;
-			}
-		}
-
-	} else {
-		/* Use defaultkey if no Key Index */
-		i = wlandev->hostwep & HOSTWEP_DEFAULTKEY_MASK;
-	}
-
-	/* Check if there is no key information in the iwconfig request */
-	if ((erq->flags & IW_ENCODE_NOKEY) == 0) {
-
-		/*------------------------------------------------------------
-		 * If there is WEP Key for setting, check the Key Information
-		 * and then set it to the firmware.
-		 -------------------------------------------------------------*/
-
-		if (erq->length > 0) {
-			/* copy the key from the driver cache as the keys are read-only MIBs */
-			wlandev->wep_keylens[i] = erq->length;
-			memcpy(wlandev->wep_keys[i], key, erq->length);
-
-			/* Prepare data struture for p80211req_dorequest. */
-			memcpy(pstr.data.data, key, erq->length);
-			pstr.data.len = erq->length;
-
-			switch (i) {
-			case 0:
-				pstr.did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
-				break;
-
-			case 1:
-				pstr.did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
-				break;
-
-			case 2:
-				pstr.did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
-				break;
-
-			case 3:
-				pstr.did =
-				    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
-				break;
-
-			default:
-				err = -EINVAL;
-				goto exit;
-			}
-
-			msg.msgcode = DIDmsg_dot11req_mibset;
-			memcpy(&msg.mibattribute.data, &pstr, sizeof(pstr));
-			result = p80211req_dorequest(wlandev, (u8 *) &msg);
-
-			if (result) {
-				err = -EFAULT;
-				goto exit;
-			}
-		}
-
-	}
-
-	/* Check the PrivacyInvoked flag */
-	if (erq->flags & IW_ENCODE_DISABLED) {
-		result =
-		    p80211wext_setmib(wlandev,
-					 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
-					 P80211ENUM_truth_false);
-	} else {
-		result =
-		    p80211wext_setmib(wlandev,
-					 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
-					 P80211ENUM_truth_true);
-	}
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	/*  The  security  mode  may  be open or restricted, and its meaning
-	   depends on the card used. With  most  cards,  in  open  mode  no
-	   authentication  is  used  and  the  card  may  also  accept non-
-	   encrypted sessions, whereas in restricted  mode  only  encrypted
-	   sessions  are  accepted  and the card will use authentication if
-	   available.
-	 */
-	if (erq->flags & IW_ENCODE_RESTRICTED) {
-		result =
-		    p80211wext_setmib(wlandev,
-					 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
-					 P80211ENUM_truth_true);
-	} else if (erq->flags & IW_ENCODE_OPEN) {
-		result =
-		    p80211wext_setmib(wlandev,
-					 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
-					 P80211ENUM_truth_false);
-	}
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-exit:
-
-	return err;
-}
-
-static int p80211wext_giwessid(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *data, char *essid)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-
-	if (wlandev->ssid.len) {
-		data->length = wlandev->ssid.len;
-		data->flags = 1;
-		memcpy(essid, wlandev->ssid.data, data->length);
-		essid[data->length] = 0;
-	} else {
-		memset(essid, 0, sizeof(wlandev->ssid.data));
-		data->length = 0;
-		data->flags = 0;
-	}
-
-	return 0;
-}
-
-static int p80211wext_siwessid(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_point *data, char *essid)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	p80211msg_lnxreq_autojoin_t msg;
-
-	int result;
-	int err = 0;
-	int length = data->length;
-
-	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	if (wlandev->hostwep & HOSTWEP_SHAREDKEY)
-		msg.authtype.data = P80211ENUM_authalg_sharedkey;
-	else
-		msg.authtype.data = P80211ENUM_authalg_opensystem;
-
-	msg.msgcode = DIDmsg_lnxreq_autojoin;
-
-	/* Trim the last '\0' to fit the SSID format */
-	if (length && essid[length - 1] == '\0')
-		length--;
-
-	memcpy(msg.ssid.data.data, essid, length);
-	msg.ssid.data.len = length;
-
-	pr_debug("autojoin_ssid for %s \n", essid);
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-	pr_debug("autojoin_ssid %d\n", result);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-exit:
-	return err;
-}
-
-static int p80211wext_siwcommit(netdevice_t *dev,
-				struct iw_request_info *info,
-				struct iw_point *data, char *essid)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int err = 0;
-
-	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	/* Auto Join */
-	err = p80211wext_autojoin(wlandev);
-
-exit:
-	return err;
-}
-
-static int p80211wext_giwrate(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_param *rrq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	result = p80211wext_getmib(wlandev, DIDmib_p2_p2MAC_p2CurrentTxRate, &value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	rrq->fixed = 0;		/* can it change? */
-	rrq->disabled = 0;
-	rrq->value = 0;
-
-#define		HFA384x_RATEBIT_1			((u16)1)
-#define		HFA384x_RATEBIT_2			((u16)2)
-#define		HFA384x_RATEBIT_5dot5			((u16)4)
-#define		HFA384x_RATEBIT_11			((u16)8)
-
-	switch (value) {
-	case HFA384x_RATEBIT_1:
-		rrq->value = 1000000;
-		break;
-	case HFA384x_RATEBIT_2:
-		rrq->value = 2000000;
-		break;
-	case HFA384x_RATEBIT_5dot5:
-		rrq->value = 5500000;
-		break;
-	case HFA384x_RATEBIT_11:
-		rrq->value = 11000000;
-		break;
-	default:
-		err = -EINVAL;
-	}
-exit:
-	return err;
-}
-
-static int p80211wext_giwrts(netdevice_t *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *rts, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	result = p80211wext_getmib(wlandev,
-				   DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold,
-				   &value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	rts->value = value;
-	rts->disabled = (rts->value == 2347);
-	rts->fixed = 1;
-
-exit:
-	return err;
-}
-
-static int p80211wext_siwrts(netdevice_t *dev,
-			     struct iw_request_info *info,
-			     struct iw_param *rts, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	if (!wlan_wext_write) {
-		err = -EOPNOTSUPP;
-		goto exit;
-	}
-
-	if (rts->disabled)
-		value = 2347;
-	else
-		value = rts->value;
-
-	result = p80211wext_setmib(wlandev,
-				   DIDmib_dot11mac_dot11OperationTable_dot11RTSThreshold,
-				   value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-exit:
-	return err;
-}
-
-static int p80211wext_giwfrag(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_param *frag, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	result = p80211wext_getmib(wlandev,
-				   DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
-				   &value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	frag->value = value;
-	frag->disabled = (frag->value == 2346);
-	frag->fixed = 1;
-
-exit:
-	return err;
-}
-
-static int p80211wext_siwfrag(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_param *frag, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	int value;
-
-	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	if (frag->disabled)
-		value = 2346;
-	else
-		value = frag->value;
-
-	result = p80211wext_setmib(wlandev,
-		   DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
-				      value);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-exit:
-	return err;
-}
-
-#ifndef IW_RETRY_LONG
-#define IW_RETRY_LONG IW_RETRY_MAX
-#endif
-
-#ifndef IW_RETRY_SHORT
-#define IW_RETRY_SHORT IW_RETRY_MIN
-#endif
-
-static int p80211wext_giwretry(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_param *rrq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	u16 shortretry, longretry, lifetime;
-	unsigned int value;
-
-	result = p80211wext_getmib(wlandev,
-				   DIDmib_dot11mac_dot11OperationTable_dot11ShortRetryLimit,
-				   &value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	shortretry = value;
-
-	result = p80211wext_getmib(wlandev,
-				   DIDmib_dot11mac_dot11OperationTable_dot11LongRetryLimit,
-				   &value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	longretry = value;
-
-	result = p80211wext_getmib(wlandev,
-				   DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
-				   &value);
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	lifetime = value;
-
-	rrq->disabled = 0;
-
-	if ((rrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
-		rrq->flags = IW_RETRY_LIFETIME;
-		rrq->value = lifetime * 1024;
-	} else {
-		if (rrq->flags & IW_RETRY_LONG) {
-			rrq->flags = IW_RETRY_LIMIT | IW_RETRY_LONG;
-			rrq->value = longretry;
-		} else {
-			rrq->flags = IW_RETRY_LIMIT;
-			rrq->value = shortretry;
-			if (shortretry != longretry)
-				rrq->flags |= IW_RETRY_SHORT;
-		}
-	}
-
-exit:
-	return err;
-
-}
-
-static int p80211wext_siwretry(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_param *rrq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	if (rrq->disabled) {
-		err = -EINVAL;
-		goto exit;
-	}
-
-	msg.msgcode = DIDmsg_dot11req_mibset;
-
-	if ((rrq->flags & IW_RETRY_TYPE) == IW_RETRY_LIFETIME) {
-
-		value = rrq->value /= 1024;
-		result = p80211wext_setmib(wlandev,
-					   DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
-					   value);
-		if (result) {
-			err = -EFAULT;
-			goto exit;
-		}
-	} else {
-		if (rrq->flags & IW_RETRY_LONG) {
-			result = p80211wext_setmib(wlandev,
-						   DIDmib_dot11mac_dot11OperationTable_dot11LongRetryLimit,
-						   rrq->value);
-
-			if (result) {
-				err = -EFAULT;
-				goto exit;
-			}
-		}
-
-		if (rrq->flags & IW_RETRY_SHORT) {
-			result = p80211wext_setmib(wlandev,
-						   DIDmib_dot11mac_dot11OperationTable_dot11ShortRetryLimit,
-						   rrq->value);
-
-			if (result) {
-				err = -EFAULT;
-				goto exit;
-			}
-		}
-	}
-
-exit:
-	return err;
-
-}
-
-static int p80211wext_siwtxpow(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_param *rrq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	p80211item_uint32_t mibitem;
-	p80211msg_dot11req_mibset_t msg;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	if (!wlan_wext_write) {
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	if (rrq->fixed == 0)
-		value = 30;
-	else
-		value = rrq->value;
-	result = p80211wext_setmib(wlandev,
-				   DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel,
-				   value);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-exit:
-	return err;
-}
-
-static int p80211wext_giwtxpow(netdevice_t *dev,
-			       struct iw_request_info *info,
-			       struct iw_param *rrq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	int result;
-	int err = 0;
-	unsigned int value;
-
-	result = p80211wext_getmib(wlandev,
-				   DIDmib_dot11phy_dot11PhyTxPowerTable_dot11CurrentTxPowerLevel,
-				   &value);
-
-	if (result) {
-		err = -EFAULT;
-		goto exit;
-	}
-
-	/* XXX handle OFF by setting disabled = 1; */
-
-	rrq->flags = 0;		/* IW_TXPOW_DBM; */
-	rrq->disabled = 0;
-	rrq->fixed = 0;
-	rrq->value = value;
-
-exit:
-	return err;
-}
-
-static int p80211wext_siwspy(netdevice_t *dev,
-			     struct iw_request_info *info,
-			     struct iw_point *srq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	struct sockaddr address[IW_MAX_SPY];
-	int number = srq->length;
-	int i;
-
-	/* Copy the data from the input buffer */
-	memcpy(address, extra, sizeof(struct sockaddr) * number);
-
-	wlandev->spy_number = 0;
-
-	if (number > 0) {
-
-		/* extract the addresses */
-		for (i = 0; i < number; i++) {
-
-			memcpy(wlandev->spy_address[i], address[i].sa_data,
-			       ETH_ALEN);
-		}
-
-		/* reset stats */
-		memset(wlandev->spy_stat, 0,
-		       sizeof(struct iw_quality) * IW_MAX_SPY);
-
-		/* set number of addresses */
-		wlandev->spy_number = number;
-	}
-
-	return 0;
-}
-
-/* jkriegl: from orinoco, modified */
-static int p80211wext_giwspy(netdevice_t *dev,
-			     struct iw_request_info *info,
-			     struct iw_point *srq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-
-	struct sockaddr address[IW_MAX_SPY];
-	struct iw_quality spy_stat[IW_MAX_SPY];
-	int number;
-	int i;
-
-	number = wlandev->spy_number;
-
-	if (number > 0) {
-
-		/* populate address and spy struct's */
-		for (i = 0; i < number; i++) {
-			memcpy(address[i].sa_data, wlandev->spy_address[i],
-			       ETH_ALEN);
-			address[i].sa_family = AF_UNIX;
-			memcpy(&spy_stat[i], &wlandev->spy_stat[i],
-			       sizeof(struct iw_quality));
-		}
-
-		/* reset update flag */
-		for (i = 0; i < number; i++)
-			wlandev->spy_stat[i].updated = 0;
-	}
-
-	/* push stuff to user space */
-	srq->length = number;
-	memcpy(extra, address, sizeof(struct sockaddr) * number);
-	memcpy(extra + sizeof(struct sockaddr) * number, spy_stat,
-	       sizeof(struct iw_quality) * number);
-
-	return 0;
-}
-
-static int prism2_result2err(int prism2_result)
-{
-	int err = 0;
-
-	switch (prism2_result) {
-	case P80211ENUM_resultcode_invalid_parameters:
-		err = -EINVAL;
-		break;
-	case P80211ENUM_resultcode_implementation_failure:
-		err = -EIO;
-		break;
-	case P80211ENUM_resultcode_not_supported:
-		err = -EOPNOTSUPP;
-		break;
-	default:
-		err = 0;
-		break;
-	}
-
-	return err;
-}
-
-static int p80211wext_siwscan(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *srq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	p80211msg_dot11req_scan_t msg;
-	int result;
-	int err = 0;
-	int i = 0;
-
-	if (wlandev->macmode == WLAN_MACMODE_ESS_AP) {
-		printk(KERN_ERR "Can't scan in AP mode\n");
-		err = (-EOPNOTSUPP);
-		goto exit;
-	}
-
-	memset(&msg, 0x00, sizeof(p80211msg_dot11req_scan_t));
-	msg.msgcode = DIDmsg_dot11req_scan;
-	msg.bsstype.data = P80211ENUM_bsstype_any;
-
-	memset(&(msg.bssid.data), 0xFF, sizeof(p80211item_pstr6_t));
-	msg.bssid.data.len = 6;
-
-	msg.scantype.data = P80211ENUM_scantype_active;
-	msg.probedelay.data = 0;
-
-	for (i = 1; i <= 14; i++)
-		msg.channellist.data.data[i - 1] = i;
-	msg.channellist.data.len = 14;
-
-	msg.maxchanneltime.data = 250;
-	msg.minchanneltime.data = 200;
-
-	result = p80211req_dorequest(wlandev, (u8 *) &msg);
-	if (result)
-		err = prism2_result2err(msg.resultcode.data);
-
-exit:
-	return err;
-}
-
-/* Helper to translate scan into Wireless Extensions scan results.
- * Inspired by the prism54 code, which was in turn inspired by the
- * airo driver code.
- */
-static char *wext_translate_bss(struct iw_request_info *info, char *current_ev,
-				char *end_buf,
-				p80211msg_dot11req_scan_results_t *bss)
-{
-	struct iw_event iwe;	/* Temporary buffer */
-
-	/* The first entry must be the MAC address */
-	memcpy(iwe.u.ap_addr.sa_data, bss->bssid.data.data, WLAN_BSSID_LEN);
-	iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
-	iwe.cmd = SIOCGIWAP;
-	current_ev =
-	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-				 IW_EV_ADDR_LEN);
-
-	/* The following entries will be displayed in the same order we give them */
-
-	/* The ESSID. */
-	if (bss->ssid.data.len > 0) {
-		char essid[IW_ESSID_MAX_SIZE + 1];
-		int size;
-
-		size =
-		    min_t(unsigned short, IW_ESSID_MAX_SIZE,
-			  bss->ssid.data.len);
-		memset(&essid, 0, sizeof(essid));
-		memcpy(&essid, bss->ssid.data.data, size);
-		pr_debug(" essid size = %d\n", size);
-		iwe.u.data.length = size;
-		iwe.u.data.flags = 1;
-		iwe.cmd = SIOCGIWESSID;
-		current_ev =
-		    iwe_stream_add_point(info, current_ev, end_buf, &iwe,
-					 &essid[0]);
-		pr_debug(" essid size OK.\n");
-	}
-
-	switch (bss->bsstype.data) {
-	case P80211ENUM_bsstype_infrastructure:
-		iwe.u.mode = IW_MODE_MASTER;
-		break;
-
-	case P80211ENUM_bsstype_independent:
-		iwe.u.mode = IW_MODE_ADHOC;
-		break;
-
-	default:
-		iwe.u.mode = 0;
-		break;
-	}
-	iwe.cmd = SIOCGIWMODE;
-	if (iwe.u.mode)
-		current_ev =
-		    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-					 IW_EV_UINT_LEN);
-
-	/* Encryption capability */
-	if (bss->privacy.data == P80211ENUM_truth_true)
-		iwe.u.data.flags = IW_ENCODE_ENABLED | IW_ENCODE_NOKEY;
-	else
-		iwe.u.data.flags = IW_ENCODE_DISABLED;
-	iwe.u.data.length = 0;
-	iwe.cmd = SIOCGIWENCODE;
-	current_ev =
-	    iwe_stream_add_point(info, current_ev, end_buf, &iwe, NULL);
-
-	/* Add frequency. (short) bss->channel is the frequency in MHz */
-	iwe.u.freq.m = bss->dschannel.data;
-	iwe.u.freq.e = 0;
-	iwe.cmd = SIOCGIWFREQ;
-	current_ev =
-	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-				 IW_EV_FREQ_LEN);
-
-	/* Add quality statistics */
-	iwe.u.qual.level = bss->signal.data;
-	iwe.u.qual.noise = bss->noise.data;
-	/* do a simple SNR for quality */
-	iwe.u.qual.qual = qual_as_percent(bss->signal.data - bss->noise.data);
-	iwe.cmd = IWEVQUAL;
-	current_ev =
-	    iwe_stream_add_event(info, current_ev, end_buf, &iwe,
-				 IW_EV_QUAL_LEN);
-
-	return current_ev;
-}
-
-static int p80211wext_giwscan(netdevice_t *dev,
-			      struct iw_request_info *info,
-			      struct iw_point *srq, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	p80211msg_dot11req_scan_results_t msg;
-	int result = 0;
-	int err = 0;
-	int i = 0;
-	int scan_good = 0;
-	char *current_ev = extra;
-
-	/* Since wireless tools doesn't really have a way of passing how
-	 * many scan results results there were back here, keep grabbing them
-	 * until we fail.
-	 */
-	do {
-		memset(&msg, 0, sizeof(msg));
-		msg.msgcode = DIDmsg_dot11req_scan_results;
-		msg.bssindex.data = i;
-
-		result = p80211req_dorequest(wlandev, (u8 *) &msg);
-		if ((result != 0) ||
-		    (msg.resultcode.data != P80211ENUM_resultcode_success)) {
-			break;
-		}
-
-		current_ev =
-		    wext_translate_bss(info, current_ev,
-				       extra + IW_SCAN_MAX_DATA, &msg);
-		scan_good = 1;
-		i++;
-	} while (i < IW_MAX_AP);
-
-	srq->length = (current_ev - extra);
-	srq->flags = 0;		/* todo */
-
-	if (result && !scan_good)
-		err = prism2_result2err(msg.resultcode.data);
-
-	return err;
-}
-
-/* extra wireless extensions stuff to support NetworkManager (I hope) */
-
-/* SIOCSIWENCODEEXT */
-static int p80211wext_set_encodeext(struct net_device *dev,
-				    struct iw_request_info *info,
-				    union iwreq_data *wrqu, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	p80211msg_dot11req_mibset_t msg;
-	p80211item_pstr32_t *pstr;
-
-	int result = 0;
-	struct iw_point *encoding = &wrqu->encoding;
-	int idx = encoding->flags & IW_ENCODE_INDEX;
-
-	pr_debug("set_encode_ext flags[%d] alg[%d] keylen[%d]\n",
-		 ext->ext_flags, (int)ext->alg, (int)ext->key_len);
-
-	if (ext->ext_flags & IW_ENCODE_EXT_GROUP_KEY) {
-		/* set default key ? I'm not sure if this the the correct thing to do here */
-
-		if (idx) {
-			if (idx < 1 || idx > NUM_WEPKEYS)
-				return -EINVAL;
-			else
-				idx--;
-		}
-		pr_debug("setting default key (%d)\n", idx);
-		result =
-		    p80211wext_setmib(wlandev,
-					 DIDmib_dot11smt_dot11PrivacyTable_dot11WEPDefaultKeyID,
-					 idx);
-		if (result)
-			return -EFAULT;
-	}
-
-	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-		if (ext->alg != IW_ENCODE_ALG_WEP) {
-			pr_debug("asked to set a non wep key :(\n");
-			return -EINVAL;
-		}
-		if (idx) {
-			if (idx < 1 || idx > NUM_WEPKEYS)
-				return -EINVAL;
-			else
-				idx--;
-		}
-		pr_debug("Set WEP key (%d)\n", idx);
-		wlandev->wep_keylens[idx] = ext->key_len;
-		memcpy(wlandev->wep_keys[idx], ext->key, ext->key_len);
-
-		memset(&msg, 0, sizeof(msg));
-		pstr = (p80211item_pstr32_t *) &msg.mibattribute.data;
-		memcpy(pstr->data.data, ext->key, ext->key_len);
-		pstr->data.len = ext->key_len;
-		switch (idx) {
-		case 0:
-			pstr->did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey0;
-			break;
-		case 1:
-			pstr->did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey1;
-			break;
-		case 2:
-			pstr->did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey2;
-			break;
-		case 3:
-			pstr->did =
-			    DIDmib_dot11smt_dot11WEPDefaultKeysTable_dot11WEPDefaultKey3;
-			break;
-		default:
-			break;
-		}
-		msg.msgcode = DIDmsg_dot11req_mibset;
-		result = p80211req_dorequest(wlandev, (u8 *) &msg);
-		pr_debug("result (%d)\n", result);
-	}
-	return result;
-}
-
-/* SIOCGIWENCODEEXT */
-static int p80211wext_get_encodeext(struct net_device *dev,
-				    struct iw_request_info *info,
-				    union iwreq_data *wrqu, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-
-	struct iw_point *encoding = &wrqu->encoding;
-	int result = 0;
-	int max_len;
-	int idx;
-
-	pr_debug("get_encode_ext flags[%d] alg[%d] keylen[%d]\n",
-		 ext->ext_flags, (int)ext->alg, (int)ext->key_len);
-
-	max_len = encoding->length - sizeof(*ext);
-	if (max_len <= 0) {
-		pr_debug("get_encodeext max_len [%d] invalid\n", max_len);
-		result = -EINVAL;
-		goto exit;
-	}
-	idx = encoding->flags & IW_ENCODE_INDEX;
-
-	pr_debug("get_encode_ext index [%d]\n", idx);
-
-	if (idx) {
-		if (idx < 1 || idx > NUM_WEPKEYS) {
-			pr_debug("get_encode_ext invalid key index [%d]\n",
-				 idx);
-			result = -EINVAL;
-			goto exit;
-		}
-		idx--;
-	} else {
-		/* default key ? not sure what to do */
-		/* will just use key[0] for now ! FIX ME */
-	}
-
-	encoding->flags = idx + 1;
-	memset(ext, 0, sizeof(*ext));
-
-	ext->alg = IW_ENCODE_ALG_WEP;
-	ext->key_len = wlandev->wep_keylens[idx];
-	memcpy(ext->key, wlandev->wep_keys[idx], ext->key_len);
-
-	encoding->flags |= IW_ENCODE_ENABLED;
-exit:
-	return result;
-}
-
-/* SIOCSIWAUTH */
-static int p80211_wext_set_iwauth(struct net_device *dev,
-				  struct iw_request_info *info,
-				  union iwreq_data *wrqu, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	struct iw_param *param = &wrqu->param;
-	int result = 0;
-
-	pr_debug("set_iwauth flags[%d]\n", (int)param->flags & IW_AUTH_INDEX);
-
-	switch (param->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_DROP_UNENCRYPTED:
-		pr_debug("drop_unencrypted %d\n", param->value);
-		if (param->value)
-			result =
-			    p80211wext_setmib(wlandev,
-						 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
-						 P80211ENUM_truth_true);
-		else
-			result =
-			    p80211wext_setmib(wlandev,
-						 DIDmib_dot11smt_dot11PrivacyTable_dot11ExcludeUnencrypted,
-						 P80211ENUM_truth_false);
-		break;
-
-	case IW_AUTH_PRIVACY_INVOKED:
-		pr_debug("privacy invoked %d\n", param->value);
-		if (param->value)
-			result =
-			    p80211wext_setmib(wlandev,
-						 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
-						 P80211ENUM_truth_true);
-		else
-			result =
-			    p80211wext_setmib(wlandev,
-						 DIDmib_dot11smt_dot11PrivacyTable_dot11PrivacyInvoked,
-						 P80211ENUM_truth_false);
-
-		break;
-
-	case IW_AUTH_80211_AUTH_ALG:
-		if (param->value & IW_AUTH_ALG_OPEN_SYSTEM) {
-			pr_debug("set open_system\n");
-			wlandev->hostwep &= ~HOSTWEP_SHAREDKEY;
-		} else if (param->value & IW_AUTH_ALG_SHARED_KEY) {
-			pr_debug("set shared key\n");
-			wlandev->hostwep |= HOSTWEP_SHAREDKEY;
-		} else {
-			/* don't know what to do know  */
-			pr_debug("unknown AUTH_ALG (%d)\n", param->value);
-			result = -EINVAL;
-		}
-		break;
-
-	default:
-		break;
-	}
-
-	return result;
-}
-
-/* SIOCSIWAUTH */
-static int p80211_wext_get_iwauth(struct net_device *dev,
-				  struct iw_request_info *info,
-				  union iwreq_data *wrqu, char *extra)
-{
-	wlandevice_t *wlandev = dev->ml_priv;
-	struct iw_param *param = &wrqu->param;
-	int result = 0;
-
-	pr_debug("get_iwauth flags[%d]\n", (int)param->flags & IW_AUTH_INDEX);
-
-	switch (param->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_DROP_UNENCRYPTED:
-		param->value =
-		    wlandev->hostwep & HOSTWEP_EXCLUDEUNENCRYPTED ? 1 : 0;
-		break;
-
-	case IW_AUTH_PRIVACY_INVOKED:
-		param->value =
-		    wlandev->hostwep & HOSTWEP_PRIVACYINVOKED ? 1 : 0;
-		break;
-
-	case IW_AUTH_80211_AUTH_ALG:
-		param->value =
-		    wlandev->hostwep & HOSTWEP_SHAREDKEY ?
-		    IW_AUTH_ALG_SHARED_KEY : IW_AUTH_ALG_OPEN_SYSTEM;
-		break;
-
-	default:
-		break;
-	}
-
-	return result;
-}
-
-#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]
-
-static iw_handler p80211wext_handlers[] = {
-	IW_IOCTL(SIOCSIWCOMMIT) = (iw_handler) p80211wext_siwcommit,
-	IW_IOCTL(SIOCGIWNAME) = (iw_handler) p80211wext_giwname,
-/* SIOCSIWNWID,SIOCGIWNWID */
-	IW_IOCTL(SIOCSIWFREQ) = (iw_handler) p80211wext_siwfreq,
-	IW_IOCTL(SIOCGIWFREQ) = (iw_handler) p80211wext_giwfreq,
-	IW_IOCTL(SIOCSIWMODE) = (iw_handler) p80211wext_siwmode,
-	IW_IOCTL(SIOCGIWMODE) = (iw_handler) p80211wext_giwmode,
-/* SIOCSIWSENS,SIOCGIWSENS,SIOCSIWRANGE */
-	IW_IOCTL(SIOCGIWRANGE) = (iw_handler) p80211wext_giwrange,
-/* SIOCSIWPRIV,SIOCGIWPRIV,SIOCSIWSTATS,SIOCGIWSTATS */
-	IW_IOCTL(SIOCSIWSPY) = (iw_handler) p80211wext_siwspy,
-	IW_IOCTL(SIOCGIWSPY) = (iw_handler) p80211wext_giwspy,
-/* SIOCSIWAP */
-	IW_IOCTL(SIOCGIWAP) = (iw_handler) p80211wext_giwap,
-/* SIOCGIWAPLIST */
-	IW_IOCTL(SIOCSIWSCAN) = (iw_handler) p80211wext_siwscan,
-	IW_IOCTL(SIOCGIWSCAN) = (iw_handler) p80211wext_giwscan,
-	IW_IOCTL(SIOCSIWESSID) = (iw_handler) p80211wext_siwessid,
-	IW_IOCTL(SIOCGIWESSID) = (iw_handler) p80211wext_giwessid,
-/* SIOCSIWNICKN */
-	IW_IOCTL(SIOCGIWNICKN) = (iw_handler) p80211wext_giwessid,
-/* SIOCSIWRATE */
-	IW_IOCTL(SIOCGIWRATE) = (iw_handler) p80211wext_giwrate,
-	IW_IOCTL(SIOCSIWRTS) = (iw_handler) p80211wext_siwrts,
-	IW_IOCTL(SIOCGIWRTS) = (iw_handler) p80211wext_giwrts,
-	IW_IOCTL(SIOCSIWFRAG) = (iw_handler) p80211wext_siwfrag,
-	IW_IOCTL(SIOCGIWFRAG) = (iw_handler) p80211wext_giwfrag,
-	IW_IOCTL(SIOCSIWTXPOW) = (iw_handler) p80211wext_siwtxpow,
-	IW_IOCTL(SIOCGIWTXPOW) = (iw_handler) p80211wext_giwtxpow,
-	IW_IOCTL(SIOCSIWRETRY) = (iw_handler) p80211wext_siwretry,
-	IW_IOCTL(SIOCGIWRETRY) = (iw_handler) p80211wext_giwretry,
-	IW_IOCTL(SIOCSIWENCODE) = (iw_handler) p80211wext_siwencode,
-	IW_IOCTL(SIOCGIWENCODE) = (iw_handler) p80211wext_giwencode,
-/* SIOCSIWPOWER,SIOCGIWPOWER */
-/* WPA operations */
-/* SIOCSIWGENIE,SIOCGIWGENIE generic IE */
-	IW_IOCTL(SIOCSIWAUTH) = (iw_handler) p80211_wext_set_iwauth, /*set authentication mode params */
-	IW_IOCTL(SIOCGIWAUTH) = (iw_handler) p80211_wext_get_iwauth, /*get authentication mode params */
-	IW_IOCTL(SIOCSIWENCODEEXT) = (iw_handler) p80211wext_set_encodeext, /*set encoding token & mode */
-	IW_IOCTL(SIOCGIWENCODEEXT) = (iw_handler) p80211wext_get_encodeext, /*get encoding token & mode */
-/* SIOCSIWPMKSA      PMKSA cache operation */
-};
-
-struct iw_handler_def p80211wext_handler_def = {
-	.num_standard = ARRAY_SIZE(p80211wext_handlers),
-	.standard = p80211wext_handlers,
-	.get_wireless_stats = p80211wext_get_wireless_stats
-};
-
-int p80211wext_event_associated(wlandevice_t *wlandev, int assoc)
-{
-	union iwreq_data data;
-
-	/* Send the association state first */
-	data.ap_addr.sa_family = ARPHRD_ETHER;
-	if (assoc)
-		memcpy(data.ap_addr.sa_data, wlandev->bssid, ETH_ALEN);
-	else
-		memset(data.ap_addr.sa_data, 0, ETH_ALEN);
-
-	if (wlan_wext_write)
-		wireless_send_event(wlandev->netdev, SIOCGIWAP, &data, NULL);
-
-	if (!assoc)
-		goto done;
-
-	/* XXX send association data, like IEs, etc etc. */
-
-done:
-	return 0;
-}


