Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757393Ab2BYRRl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 12:17:41 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:57872 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757298Ab2BYRRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 12:17:36 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of larry.finger@gmail.com designates 10.42.138.133 as permitted sender) smtp.mail=larry.finger@gmail.com; dkim=pass header.i=larry.finger@gmail.com
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/2] staging: r8712u: Fix regression caused by commit 8c213fa
Date: Sat, 25 Feb 2012 11:17:15 -0600
Message-Id: <1330190235-511-3-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330190235-511-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1330190235-511-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 8c213fa, the command to release the firmware was placed
in the wrong routine. With NetworkManager, problems were rare, but
when using wicd as the network control, there is a problem as shown
in https://bugs.archlinux.org/task/27996#comment89833.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/os_intfs.c |    3 ---
 drivers/staging/rtl8712/usb_intf.c |    5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rtl8712/os_intfs.c b/drivers/staging/rtl8712/os_intfs.c
index 4cf175f..7bbd53a 100644
--- a/drivers/staging/rtl8712/os_intfs.c
+++ b/drivers/staging/rtl8712/os_intfs.c
@@ -475,9 +475,6 @@ static int netdev_close(struct net_device *pnetdev)
 	r8712_free_assoc_resources(padapter);
 	/*s2-4.*/
 	r8712_free_network_queue(padapter);
-	release_firmware(padapter->fw);
-	/* never exit with a firmware callback pending */
-	wait_for_completion(&padapter->rtl8712_fw_ready);
 	return 0;
 }
 
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index fe0e2ff..e01fe14 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -30,6 +30,7 @@
 
 #include <linux/usb.h>
 #include <linux/module.h>
+#include <linux/firmware.h>
 
 #include "osdep_service.h"
 #include "drv_types.h"
@@ -620,6 +621,10 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	struct _adapter *padapter = netdev_priv(pnetdev);
 	struct usb_device *udev = interface_to_usbdev(pusb_intf);
 
+	if (padapter->fw_found)
+		release_firmware(padapter->fw);
+	/* never exit with a firmware callback pending */
+	wait_for_completion(&padapter->rtl8712_fw_ready);
 	usb_set_intfdata(pusb_intf, NULL);
 	if (padapter) {
 		if (drvpriv.drv_registered == true)
-- 
1.7.7

