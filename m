Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752995Ab1L1XTD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 18:19:03 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62125 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818Ab1L1XTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 18:19:00 -0500
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: [PATCH 7/7] staging: vt6656: iwctl.c: Rewrite siwrts funciton
Date: Wed, 28 Dec 2011 21:18:31 +0000
Message-Id: <1325107111-3197-1-git-send-email-marcos.mage@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function has the following issues:
	Parameter info and extra are not used
	Wrong error handling(the function not return -EINVAL when it
happens)

This patch simplifies this funtion, remove the not used parameters and
fix the error handilng.

Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
---
 drivers/staging/vt6656/iwctl.c    |   26 +++++++++-----------------
 drivers/staging/vt6656/iwctl.h    |    5 +----
 drivers/staging/vt6656/main_usb.c |    2 +-
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/vt6656/iwctl.c b/drivers/staging/vt6656/iwctl.c
index 2ad7428..3ddda65 100644
--- a/drivers/staging/vt6656/iwctl.c
+++ b/drivers/staging/vt6656/iwctl.c
@@ -1010,27 +1010,19 @@ void iwctl_giwrate(struct net_device *dev,
 /*
  * Wireless Handler : set rts threshold
  */
-
 int iwctl_siwrts(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra)
+		 struct iw_param *wrq)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-	int rc = 0;
+	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+
+	if ((wrq->value < 0 || wrq->value > 2312) && !wrq->disabled)
+		return -EINVAL;
 
-    DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " SIOCSIWRTS \n");
+	else if (wrq->disabled)
+		pDevice->wRTSThreshold = 2312;
 
-	{
-	    int rthr = wrq->value;
-	    if(wrq->disabled)
-			rthr = 2312;
-	    if((rthr < 0) || (rthr > 2312)) {
-			rc = -EINVAL;
-    	}else {
-		    pDevice->wRTSThreshold = rthr;
-	    }
-    }
+	else
+		pDevice->wRTSThreshold = wrq->value;
 
 	return 0;
 }
diff --git a/drivers/staging/vt6656/iwctl.h b/drivers/staging/vt6656/iwctl.h
index bd38e9d..0c6e049 100644
--- a/drivers/staging/vt6656/iwctl.h
+++ b/drivers/staging/vt6656/iwctl.h
@@ -113,10 +113,7 @@ void iwctl_giwrate(struct net_device *dev,
              char *extra);
 
 int iwctl_siwrts(struct net_device *dev,
-             struct iw_request_info *info,
-			 struct iw_param *wrq,
-             char *extra);
-
+		 struct iw_param *wrq);
 
 int iwctl_giwrts(struct net_device *dev,
              struct iw_request_info *info,
diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index 64d0653..1db9f5b 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -1704,7 +1704,7 @@ static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd) {
 	// Set the desired RTS threshold
 	case SIOCSIWRTS:
 
-		rc = iwctl_siwrts(dev, NULL, &(wrq->u.rts), NULL);
+		rc = iwctl_siwrts(dev, &(wrq->u.rts));
 		break;
 
 	// Get the current RTS threshold
-- 
1.7.4.4

