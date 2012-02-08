Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2BHLJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 06:09:22 -0500
Received: from ns.pmeerw.net ([87.118.82.44]:34190 "EHLO pmeerw.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756794Ab2BHLJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 06:09:20 -0500
From: Peter Meerwald <pmeerw@pmeerw.net>
To: linux-kernel@vger.kernel.org
Cc: davem@davemloft.net, steve.glendinning@smsc.com,
        Peter Meerwald <p.meerwald@bct-electronic.com>
Subject: [PATCH 1/2] smsc95xx: add module parameter to turn off NIC status leds
Date: Wed,  8 Feb 2012 12:08:51 +0100
Message-Id: <1328699332-9024-1-git-send-email-pmeerw@pmeerw.net>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Meerwald <p.meerwald@bct-electronic.com>

add module parameter to allow to turn off NIC status leds (link, 
speed, activity); blinking LEDs are annoying outside the server room :)

default behaviour is not changed, tested on beagleboard-xm

Signed-off-by: Peter Meerwald <p.meerwald@bct-electronic.com>

---
 drivers/net/usb/smsc95xx.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index d45520e..b7b2326 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -63,6 +63,10 @@ static bool turbo_mode = true;
 module_param(turbo_mode, bool, 0644);
 MODULE_PARM_DESC(turbo_mode, "Enable multiple frames per Rx transaction");
 
+static bool leds_off = false;
+module_param(leds_off, bool, 0644);
+MODULE_PARM_DESC(leds_off, "Turn off NIC LEDs");
+
 static int smsc95xx_read_reg(struct usbnet *dev, u32 index, u32 *data)
 {
 	u32 *buf = kmalloc(4, GFP_KERNEL);
@@ -894,8 +898,11 @@ static int smsc95xx_reset(struct usbnet *dev)
 	netif_dbg(dev, ifup, dev->net, "ID_REV = 0x%08x\n", read_buf);
 
 	/* Configure GPIO pins as LED outputs */
-	write_buf = LED_GPIO_CFG_SPD_LED | LED_GPIO_CFG_LNK_LED |
-		LED_GPIO_CFG_FDX_LED;
+	if (!leds_off)
+		write_buf = LED_GPIO_CFG_SPD_LED | LED_GPIO_CFG_LNK_LED |
+			LED_GPIO_CFG_FDX_LED;
+	else
+		write_buf = 0;
 	ret = smsc95xx_write_reg(dev, LED_GPIO_CFG, write_buf);
 	if (ret < 0) {
 		netdev_warn(dev->net, "Failed to write LED_GPIO_CFG register, ret=%d\n",
-- 
1.7.4.1

