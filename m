Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756904Ab2BHLJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:09:22 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:34189 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755332Ab2BHLJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:09:20 -0500
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, steve.glendinning@smsc.com,
        Peter Meerwald <p.meerwald@bct-electronic.com>
Subject: [PATCH 2/2] smsc95xx: allow to re-use MAC address already programmed
Date: Wed,  8 Feb 2012 12:08:52 +0100
Message-Id: <1328699332-9024-2-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1328699332-9024-1-git-send-email-pmeerw@pmeerw.net>
References: <1328699332-9024-1-git-send-email-pmeerw@pmeerw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <p.meerwald@bct-electronic.com>

patch adds a module parameter which allows to keep the MAC address already 
set (e.g. by the boot loader) if it is valid (otherwise the MAC address is read 
from an optional EEPROM or randomly generated)

tested on beagleboard-xm

Signed-off-by: Peter Meerwald <p.meerwald@bct-electronic.com>

---
 drivers/net/usb/smsc95xx.c |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index b7b2326..5545a60 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -67,6 +67,10 @@ static bool leds_off = false;
 module_param(leds_off, bool, 0644);
 MODULE_PARM_DESC(leds_off, "Turn off NIC LEDs");
 
+static bool keep_mac = false;
+module_param(keep_mac, bool, 0644);
+MODULE_PARM_DESC(keep_mac, "Keep MAC address set by boot loader if available");
+
 static int smsc95xx_read_reg(struct usbnet *dev, u32 index, u32 *data)
 {
 	u32 *buf = kmalloc(4, GFP_KERNEL);
@@ -607,6 +611,21 @@ static int smsc95xx_ioctl(struct net_device *netdev, struct ifreq *rq, int cmd)
 
 static void smsc95xx_init_mac_address(struct usbnet *dev)
 {
+	if (keep_mac) {
+		u32 addr_lo, addr_hi;
+		int ret = smsc95xx_read_reg(dev, ADDRL, &addr_lo);
+		if (ret < 0) {
+			netdev_warn(dev->net, "Failed to read ADDRL: %d\n", ret);
+		}
+		ret = smsc95xx_read_reg(dev, ADDRH, &addr_hi);
+
+		if (is_valid_ether_addr(dev->net->dev_addr)) {
+			/* MAC values are valid so use them */
+			netif_dbg(dev, ifup, dev->net, "MAC address already configured\n");
+			return;
+		}
+	}
+
 	/* try reading mac address from EEPROM */
 	if (smsc95xx_read_eeprom(dev, EEPROM_MAC_OFFSET, ETH_ALEN,
 			dev->net->dev_addr) == 0) {
-- 
1.7.4.1

