Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab0IXQjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 12:39:14 -0400
Received: from kroah.org ([198.145.64.141]:37404 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933116Ab0IXQfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 12:35:47 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Sep 24 09:33:48 2010
Message-Id: <20100924163348.746979538@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 24 Sep 2010 09:32:17 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
        David Hollis <dhollis@davehollis.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [53/68] asix: fix setting mac address for AX88772
In-Reply-To: <20100924163357.GA15741@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>

commit 7f29a3baa825725d29db399663790d15c78cddcf upstream.

Setting new MAC address only worked when device was set to promiscuous mode.
Fix MAC address by writing new address to device using undocumented command
AX_CMD_READ_NODE_ID+1. Patch is tested with AX88772 device.

Signed-off-by: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Acked-by: David Hollis <dhollis@davehollis.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/usb/asix.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -54,6 +54,7 @@ static const char driver_name [] = "asix
 #define AX_CMD_WRITE_IPG0		0x12
 #define AX_CMD_WRITE_IPG1		0x13
 #define AX_CMD_READ_NODE_ID		0x13
+#define AX_CMD_WRITE_NODE_ID		0x14
 #define AX_CMD_WRITE_IPG2		0x14
 #define AX_CMD_WRITE_MULTI_FILTER	0x16
 #define AX88172_CMD_READ_NODE_ID	0x17
@@ -165,6 +166,7 @@ static const char driver_name [] = "asix
 /* This structure cannot exceed sizeof(unsigned long [5]) AKA 20 bytes */
 struct asix_data {
 	u8 multi_filter[AX_MCAST_FILTER_SIZE];
+	u8 mac_addr[ETH_ALEN];
 	u8 phymode;
 	u8 ledmode;
 	u8 eeprom_len;
@@ -728,6 +730,30 @@ static int asix_ioctl (struct net_device
 	return generic_mii_ioctl(&dev->mii, if_mii(rq), cmd, NULL);
 }
 
+static int asix_set_mac_address(struct net_device *net, void *p)
+{
+	struct usbnet *dev = netdev_priv(net);
+	struct asix_data *data = (struct asix_data *)&dev->data;
+	struct sockaddr *addr = p;
+
+	if (netif_running(net))
+		return -EBUSY;
+	if (!is_valid_ether_addr(addr->sa_data))
+		return -EADDRNOTAVAIL;
+
+	memcpy(net->dev_addr, addr->sa_data, ETH_ALEN);
+
+	/* We use the 20 byte dev->data
+	 * for our 6 byte mac buffer
+	 * to avoid allocating memory that
+	 * is tricky to free later */
+	memcpy(data->mac_addr, addr->sa_data, ETH_ALEN);
+	asix_write_cmd_async(dev, AX_CMD_WRITE_NODE_ID, 0, 0, ETH_ALEN,
+							data->mac_addr);
+
+	return 0;
+}
+
 /* We need to override some ethtool_ops so we require our
    own structure so we don't interfere with other usbnet
    devices that may be connected at the same time. */
@@ -915,7 +941,7 @@ static const struct net_device_ops ax887
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
 	.ndo_change_mtu		= usbnet_change_mtu,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_do_ioctl		= asix_ioctl,
 	.ndo_set_multicast_list = asix_set_multicast,
@@ -1208,7 +1234,7 @@ static const struct net_device_ops ax881
 	.ndo_stop		= usbnet_stop,
 	.ndo_start_xmit		= usbnet_start_xmit,
 	.ndo_tx_timeout		= usbnet_tx_timeout,
-	.ndo_set_mac_address 	= eth_mac_addr,
+	.ndo_set_mac_address 	= asix_set_mac_address,
 	.ndo_validate_addr	= eth_validate_addr,
 	.ndo_set_multicast_list = asix_set_multicast,
 	.ndo_do_ioctl 		= asix_ioctl,


