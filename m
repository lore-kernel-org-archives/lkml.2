Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757956Ab2AML4g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 06:56:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33854 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751683Ab2AML4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 06:56:32 -0500
From: Dmitry Antipov <dmitry.antipov@linaro.org>
To: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Dmitry Antipov <dmitry.antipov@linaro.org>
Subject: [PATCH] drivers/net/usb/smsc95xx.c: change msleep() to usleep_range()
Date: Fri, 13 Jan 2012 15:57:04 +0400
Message-Id: <1326455824-8685-1-git-send-email-dmitry.antipov@linaro.org>
X-Mailer: git-send-email 1.7.7.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The resolution of msleep is related to HZ, so 10ms msleep() causes
~23ms sleep with OMAP's default CONFIG_HZ=128 timer configuration.
This looks too much, and usleep_range() with some slack gives more
control of what is happening here.

Signed-off-by: Dmitry Antipov <dmitry.antipov@linaro.org>
---
 drivers/net/usb/smsc95xx.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
index d45520e..5d406d4 100644
--- a/drivers/net/usb/smsc95xx.c
+++ b/drivers/net/usb/smsc95xx.c
@@ -688,7 +688,7 @@ static int smsc95xx_phy_initialize(struct usbnet *dev)
 	smsc95xx_mdio_write(dev->net, dev->mii.phy_id, MII_BMCR, BMCR_RESET);
 
 	do {
-		msleep(10);
+		usleep_range(10000, 15000);
 		bmcr = smsc95xx_mdio_read(dev->net, dev->mii.phy_id, MII_BMCR);
 		timeout++;
 	} while ((bmcr & BMCR_RESET) && (timeout < 100));
@@ -736,7 +736,7 @@ static int smsc95xx_reset(struct usbnet *dev)
 			netdev_warn(dev->net, "Failed to read HW_CFG: %d\n", ret);
 			return ret;
 		}
-		msleep(10);
+		usleep_range(10000, 15000);
 		timeout++;
 	} while ((read_buf & HW_CFG_LRST_) && (timeout < 100));
 
@@ -759,7 +759,7 @@ static int smsc95xx_reset(struct usbnet *dev)
 			netdev_warn(dev->net, "Failed to read PM_CTRL: %d\n", ret);
 			return ret;
 		}
-		msleep(10);
+		usleep_range(10000, 15000);
 		timeout++;
 	} while ((read_buf & PM_CTL_PHY_RST_) && (timeout < 100));
 
-- 
1.7.7.5

