Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762333Ab2EQSVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:21:05 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:57277 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762279Ab2EQSUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:20:44 -0400
From: Ben Chan <benchan@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        benchan@chromium.org, Paul Stewart <pstew@chromium.org>,
        Sage Ahn <syahn@gctsemi.com>
Subject: [PATCH] staging: gdm72xx: Set up parent link in sysfs for gdm72xx devices
Date: Thu, 17 May 2012 11:15:10 -0700
Message-Id: <1337278510-24168-1-git-send-email-benchan@chromium.org>
X-Mailer: git-send-email 1.7.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Stewart <pstew@chromium.org>

This patch uses SET_NETDEV_DEV to set up a 'device' parent link in sysfs
(e.g. /sys/class/net/wm0/device) for a gdm72xx device.

Signed-off-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Ben Chan <benchan@chromium.org>
Cc: Sage Ahn <syahn@gctsemi.com>
---
 drivers/staging/gdm72xx/gdm_sdio.c  |    2 +-
 drivers/staging/gdm72xx/gdm_usb.c   |    2 +-
 drivers/staging/gdm72xx/gdm_wimax.c |    3 ++-
 drivers/staging/gdm72xx/gdm_wimax.h |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
index 1ef466e..e1a3dd2 100644
--- a/drivers/staging/gdm72xx/gdm_sdio.c
+++ b/drivers/staging/gdm72xx/gdm_sdio.c
@@ -618,7 +618,7 @@ end_io:
 done:
 	sdio_writeb(func, 0x00, 0x10, &ret);	/* PCRRT */
 	if (!phy_dev->netdev)
-		register_wimax_device(phy_dev);
+		register_wimax_device(phy_dev, &func->dev);
 }
 
 static int gdm_sdio_receive(void *priv_dev,
diff --git a/drivers/staging/gdm72xx/gdm_usb.c b/drivers/staging/gdm72xx/gdm_usb.c
index f60e890..1e9dc0d 100644
--- a/drivers/staging/gdm72xx/gdm_usb.c
+++ b/drivers/staging/gdm72xx/gdm_usb.c
@@ -624,7 +624,7 @@ static int gdm_usb_probe(struct usb_interface *intf,
 	INIT_WORK(&udev->pm_ws, do_pm_control);
 #endif /* CONFIG_WIMAX_GDM72XX_USB_PM */
 
-	ret = register_wimax_device(phy_dev);
+	ret = register_wimax_device(phy_dev, &intf->dev);
 
 out:
 	if (ret) {
diff --git a/drivers/staging/gdm72xx/gdm_wimax.c b/drivers/staging/gdm72xx/gdm_wimax.c
index 2787494..f1936b9 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.c
+++ b/drivers/staging/gdm72xx/gdm_wimax.c
@@ -943,7 +943,7 @@ static struct net_device_ops gdm_netdev_ops = {
 	.ndo_do_ioctl			= gdm_wimax_ioctl,
 };
 
-int register_wimax_device(struct phy_dev *phy_dev)
+int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev)
 {
 	struct nic *nic = NULL;
 	struct net_device *dev;
@@ -957,6 +957,7 @@ int register_wimax_device(struct phy_dev *phy_dev)
 		return -ENOMEM;
 	}
 
+	SET_NETDEV_DEV(dev, pdev);
 	dev->mtu = 1400;
 	dev->netdev_ops = &gdm_netdev_ops;
 	dev->flags &= ~IFF_MULTICAST;
diff --git a/drivers/staging/gdm72xx/gdm_wimax.h b/drivers/staging/gdm72xx/gdm_wimax.h
index a1cd71e..023e649 100644
--- a/drivers/staging/gdm72xx/gdm_wimax.h
+++ b/drivers/staging/gdm72xx/gdm_wimax.h
@@ -85,7 +85,7 @@ struct nic {
 
 /*#define LOOPBACK_TEST */
 
-extern int register_wimax_device(struct phy_dev *phy_dev);
+extern int register_wimax_device(struct phy_dev *phy_dev, struct device *pdev);
 extern int gdm_wimax_send_tx(struct sk_buff *skb, struct net_device *dev);
 extern void unregister_wimax_device(struct phy_dev *phy_dev);
 
-- 
1.7.7.3

