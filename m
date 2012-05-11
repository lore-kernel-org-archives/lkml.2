Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760800Ab2EKQeu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 12:34:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38436 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab2EKQes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 12:34:48 -0400
From: Larry Finger <Larry.Finger@lwfinger.net>
To: gregkh@linuxfoundation.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, ben@decadent.org.uk
Subject: [PATCH] staging: r8712u: Remove needless test for NULL
Date: Fri, 11 May 2012 11:33:43 -0500
Message-Id: <1336754023-12150-1-git-send-email-Larry.Finger@lwfinger.net>
X-Mailer: git-send-email 1.7.10.130.g36e6c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In commit ee6aeff, a swatch warning was fixed by moving some code inside
an if block that is executed only when the pointer padapter is not NULL.
In fact, padapter can never be NULL and the corect fix should have been
the removal of the test of padapter.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/staging/rtl8712/usb_intf.c |   34 ++++++++++++++++------------------
 1 file changed, 16 insertions(+), 18 deletions(-)

diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index a0de043..9bd18e2 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -621,25 +621,23 @@ static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 	struct usb_device *udev = interface_to_usbdev(pusb_intf);
 
 	usb_set_intfdata(pusb_intf, NULL);
-	if (padapter) {
-		if (padapter->fw_found)
-			release_firmware(padapter->fw);
-		/* never exit with a firmware callback pending */
-		wait_for_completion(&padapter->rtl8712_fw_ready);
-		if (drvpriv.drv_registered == true)
-			padapter->bSurpriseRemoved = true;
-		if (pnetdev != NULL) {
-			/* will call netdev_close() */
-			unregister_netdev(pnetdev);
-		}
-		flush_scheduled_work();
-		udelay(1);
-		/*Stop driver mlme relation timer */
-		if (padapter->fw_found)
-			r8712_stop_drv_timers(padapter);
-		r871x_dev_unload(padapter);
-		r8712_free_drv_sw(padapter);
+	if (padapter->fw_found)
+		release_firmware(padapter->fw);
+	/* never exit with a firmware callback pending */
+	wait_for_completion(&padapter->rtl8712_fw_ready);
+	if (drvpriv.drv_registered == true)
+		padapter->bSurpriseRemoved = true;
+	if (pnetdev != NULL) {
+		/* will call netdev_close() */
+		unregister_netdev(pnetdev);
 	}
+	flush_scheduled_work();
+	udelay(1);
+	/*Stop driver mlme relation timer */
+	if (padapter->fw_found)
+		r8712_stop_drv_timers(padapter);
+	r871x_dev_unload(padapter);
+	r8712_free_drv_sw(padapter);
 	usb_set_intfdata(pusb_intf, NULL);
 	/* decrease the reference count of the usb device structure
 	 * when disconnect */
-- 
1.7.10.130.g36e6c

