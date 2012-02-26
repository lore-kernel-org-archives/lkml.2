Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2BZAKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 19:10:54 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:61615 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2BZAKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 19:10:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of larry.finger@gmail.com designates 10.42.80.3 as permitted sender) smtp.mail=larry.finger@gmail.com; dkim=pass header.i=larry.finger@gmail.com
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/2 V2] staging: r8712u: Fix regression caused by commit 8c213fa
Date: Sat, 25 Feb 2012 18:10:21 -0600
Message-Id: <1330215021-7968-3-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1330215021-7968-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1330215021-7968-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit 8c213fa "staging: r8712u: Use asynchronous firmware loading",
the command to release the firmware was placed in the wrong routine.

In combination with the bug introduced in commit a5ee652 "staging: r8712u:
Interface-state not fully tracked", the driver attempts to upload firmware
that had already been released. This bug is the source of one of the
problems in https://bugs.archlinux.org/task/27996#comment89833.


Tested-by: Alberto Lago Ballesteros <saniukeokusainaya@gmail.com>
Tested-by: Adrian <agib@gmx.de>
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

