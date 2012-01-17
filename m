Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab2AQMxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 07:53:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:48688 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab2AQMxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 07:53:20 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH 3/3] smsc95xx: use usleep_range(), get rid out of jiffies
Date: Tue, 17 Jan 2012 16:54:12 +0400
Message-Id: <1326804852-17742-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use usleep_range() with return value to implement time-bounded
wait-for hardware loop where delay is applicable; use ktime
instead of jiffies for a busy-wait loop.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 drivers/net/usb/smsc95xx.c |   52 ++++++++++++++++++++-----------------------
 1 files changed, 24 insertions(+), 28 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index d45520e..7264090 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -114,19 +114,18 @@ static int smsc95xx_write_reg(struct usbnet *dev, u32 index, u32 data)
 	return ret;
 }
 
-/* Loop until the read is completed with timeout
- * called with phy_mutex held */
+/* Busy-wait loop until the read is completed, but
+   no longer than 10ms. Called with phy_mutex held. */
 static int smsc95xx_phy_wait_not_busy(struct usbnet *dev)
 {
-	unsigned long start_time = jiffies;
+	ktime_t start = ktime_get();
 	u32 val;
 
-	do {
+	while (ktime_us_delta(ktime_get(), start) < 10000) {
 		smsc95xx_read_reg(dev, MII_ADDR, &val);
 		if (!(val & MII_BUSY_))
 			return 0;
-	} while (!time_after(jiffies, start_time + HZ));
-
+	}
 	return -EIO;
 }
 
@@ -195,15 +194,15 @@ static void smsc95xx_mdio_write(struct net_device *netdev, int phy_id, int idx,
 
 static int smsc95xx_wait_eeprom(struct usbnet *dev)
 {
-	unsigned long start_time = jiffies;
+	unsigned long timeout = 0;
 	u32 val;
 
 	do {
 		smsc95xx_read_reg(dev, E2P_CMD, &val);
 		if (!(val & E2P_CMD_BUSY_) || (val & E2P_CMD_TIMEOUT_))
 			break;
-		udelay(40);
-	} while (!time_after(jiffies, start_time + HZ));
+		timeout += usleep_range(40, 50);
+	} while (timeout < USEC_PER_MSEC * 10);
 
 	if (val & (E2P_CMD_TIMEOUT_ | E2P_CMD_BUSY_)) {
 		netdev_warn(dev->net, "EEPROM read operation timeout\n");
@@ -215,17 +214,15 @@ static int smsc95xx_wait_eeprom(struct usbnet *dev)
 
 static int smsc95xx_eeprom_confirm_not_busy(struct usbnet *dev)
 {
-	unsigned long start_time = jiffies;
+	unsigned long timeout = 0;
 	u32 val;
 
 	do {
 		smsc95xx_read_reg(dev, E2P_CMD, &val);
-
 		if (!(val & E2P_CMD_BUSY_))
 			return 0;
-
-		udelay(40);
-	} while (!time_after(jiffies, start_time + HZ));
+		timeout += usleep_range(40, 50);
+	} while (timeout < USEC_PER_MSEC * 10);
 
 	netdev_warn(dev->net, "EEPROM is busy\n");
 	return -EIO;
@@ -674,7 +671,8 @@ static void smsc95xx_start_rx_path(struct usbnet *dev)
 
 static int smsc95xx_phy_initialize(struct usbnet *dev)
 {
-	int bmcr, timeout = 0;
+	int bmcr;
+	unsigned long timeout = 0;
 
 	/* Initialize MII structure */
 	dev->mii.dev = dev->net;
@@ -688,12 +686,11 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 	smsc95xx_mdio_write(dev->net, dev->mii.phy_id, MII_BMCR, BMCR_RESET);
 
 	do {
-		msleep(10);
+		timeout += usleep_range(10000, 15000);
 		bmcr = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, MII_BMCR);
-		timeout++;
-	} while ((bmcr & BMCR_RESET) && (timeout < 100));
+	} while ((bmcr & BMCR_RESET) && (timeout < USEC_PER_SEC));
 
-	if (timeout >= 100) {
+	if (timeout >= USEC_PER_SEC) {
 		netdev_warn(dev->net, "timeout on PHY Reset");
 		return -EIO;
 	}
@@ -717,7 +714,8 @@ static int smsc95xx_reset(struct usbnet *dev)
 {
 	struct smsc95xx_priv *pdata = (struct smsc95xx_priv *)(dev->data[0]);
 	u32 read_buf, write_buf, burst_cap;
-	int ret = 0, timeout;
+	unsigned long timeout;
+	int ret = 0;
 
 	netif_dbg(dev, ifup, dev->net, "entering smsc95xx_reset\n");
 
@@ -736,11 +734,10 @@ static int smsc95xx_reset(struct usbnet *dev)
 			netdev_warn(dev->net, "Failed to read HW_CFG: %d\n", ret);
 			return ret;
 		}
-		msleep(10);
-		timeout++;
-	} while ((read_buf & HW_CFG_LRST_) && (timeout < 100));
+		timeout += usleep_range(10000, 15000);
+	} while ((read_buf & HW_CFG_LRST_) && (timeout < USEC_PER_SEC));
 
-	if (timeout >= 100) {
+	if (timeout >= USEC_PER_SEC) {
 		netdev_warn(dev->net, "timeout waiting for completion of Lite Reset\n");
 		return ret;
 	}
@@ -759,11 +756,10 @@ static int smsc95xx_reset(struct usbnet *dev)
 			netdev_warn(dev->net, "Failed to read PM_CTRL: %d\n", ret);
 			return ret;
 		}
-		msleep(10);
-		timeout++;
-	} while ((read_buf & PM_CTL_PHY_RST_) && (timeout < 100));
+		timeout += usleep_range(10000, 15000);
+	} while ((read_buf & PM_CTL_PHY_RST_) && (timeout < USEC_PER_SEC));
 
-	if (timeout >= 100) {
+	if (timeout >= USEC_PER_SEC) {
 		netdev_warn(dev->net, "timeout waiting for PHY Reset\n");
 		return ret;
 	}
-- 
1.7.7.5

