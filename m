Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab1H3Lsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 07:48:42 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35886 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab1H3Lsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 07:48:41 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@suse.de
Cc: greg@kroah.com, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        o.hartmann@telovital.com, Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 1/3] staging: et131x: converting et131x_ioctl to use phy_mii_ioctl
Date: Tue, 30 Aug 2011 12:47:22 +0100
Message-Id: <1314704844-5643-1-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handing over ioctls handled by the driver to the phydev.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x_netdev.c |   56 ++-----------------------------
 1 files changed, 4 insertions(+), 52 deletions(-)

diff --git a/drivers/staging/et131x/et131x_netdev.c b/drivers/staging/et131x/et131x_netdev.c
index ce21433..d12e05e 100644
--- a/drivers/staging/et131x/et131x_netdev.c
+++ b/drivers/staging/et131x/et131x_netdev.c
@@ -208,47 +208,6 @@ int et131x_close(struct net_device *netdev)
 }
 
 /**
- * et131x_ioctl_mii - The function which handles MII IOCTLs
- * @netdev: device on which the query is being made
- * @reqbuf: the request-specific data buffer
- * @cmd: the command request code
- *
- * Returns 0 on success, errno on failure (as defined in errno.h)
- */
-int et131x_ioctl_mii(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
-{
-	int status = 0;
-	struct et131x_adapter *adapter = netdev_priv(netdev);
-	struct mii_ioctl_data *data = if_mii(reqbuf);
-
-	switch (cmd) {
-	case SIOCGMIIPHY:
-		data->phy_id = adapter->stats.xcvr_addr;
-		break;
-
-	case SIOCGMIIREG:
-		if (!capable(CAP_NET_ADMIN))
-			status = -EPERM;
-		else
-			status = et131x_mii_read(adapter,
-					data->reg_num, &data->val_out);
-		break;
-
-	case SIOCSMIIREG:
-		if (!capable(CAP_NET_ADMIN))
-			status = -EPERM;
-		else
-			status = et131x_mii_write(adapter, data->reg_num,
-					 data->val_in);
-		break;
-
-	default:
-		status = -EOPNOTSUPP;
-	}
-	return status;
-}
-
-/**
  * et131x_ioctl - The I/O Control handler for the driver
  * @netdev: device on which the control request is being made
  * @reqbuf: a pointer to the IOCTL request buffer
@@ -258,19 +217,12 @@ int et131x_ioctl_mii(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
  */
 int et131x_ioctl(struct net_device *netdev, struct ifreq *reqbuf, int cmd)
 {
-	int status = 0;
+	struct et131x_adapter *adapter = netdev_priv(netdev);
 
-	switch (cmd) {
-	case SIOCGMIIPHY:
-	case SIOCGMIIREG:
-	case SIOCSMIIREG:
-		status = et131x_ioctl_mii(netdev, reqbuf, cmd);
-		break;
+	if (!adapter->phydev)
+		return -EINVAL;
 
-	default:
-		status = -EOPNOTSUPP;
-	}
-	return status;
+	return phy_mii_ioctl(adapter->phydev, reqbuf, cmd);
 }
 
 /**
-- 
1.7.6

