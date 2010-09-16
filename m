Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab0IPDwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 23:52:51 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49628 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab0IPDwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 23:52:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=q/r+UDMjzdh6OM6RaOi3OwbFFGEuFgJCOym4VKdVvRAXxsxreGugnJIMChhTraiScL
         ZNFrjiQBr60XItRaKVRkMaSWMbHqbx+72+RpzwQiLH0iDSh6oeiPZHSKJ0mwjRODWQ+z
         upn3fz91e8osSHYDZP6orF6SIK5r6nUfoTAeg=
From: Al Cho <acho@novell.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        yiyingc@ene.com.tw, Al Cho <acho@novell.com>
Subject: [PATCH] staging/keucr: fix keucr lost disconnect
Date: Thu, 16 Sep 2010 11:51:48 +0800
Message-Id: <1284609108-11103-1-git-send-email-acho@novell.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

keucr lost the disconnect,
so keucr crash when plug-in and then plug-out SD-card quickly.

unmark the part of usb disconnect

Signed-off-by: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/usb.c |   23 +++++++++++------------
 1 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/keucr/usb.c b/drivers/staging/keucr/usb.c
index d7dab72..9d74722 100644
--- a/drivers/staging/keucr/usb.c
+++ b/drivers/staging/keucr/usb.c
@@ -21,6 +21,8 @@ MODULE_AUTHOR("Domao");
 MODULE_DESCRIPTION("ENE USB Mass Storage driver for Linux");
 MODULE_LICENSE("GPL");
 
+static unsigned int delay_use = 1;
+
 static struct usb_device_id eucr_usb_ids [] = {
 	{ USB_DEVICE(0x058f, 0x6366) },
 	{ USB_DEVICE(0x0cf2, 0x6230) },
@@ -172,11 +174,10 @@ static int usb_stor_control_thread(void * __us)
 		mutex_lock(&(us->dev_mutex));
 
 		/* if the device has disconnected, we are free to exit */
-/*		if (test_bit(US_FLIDX_DISCONNECTING, &us->flags))
-		{
+		if (test_bit(US_FLIDX_DISCONNECTING, &us->dflags)) {
 			mutex_unlock(&us->dev_mutex);
 			break;
-		}*/
+		}
 
 		/* lock access to the state */
 		scsi_lock(host);
@@ -542,15 +543,13 @@ static int usb_stor_scan_thread(void * __us)
       printk("usb --- usb_stor_scan_thread\n");
 	printk("EUCR : device found at %d\n", us->pusb_dev->devnum);
 
-// Have we to add this code ?
-//	set_freezable();
-//	/* Wait for the timeout to expire or for a disconnect */
-//	if (delay_use > 0)
-//	{
-//		wait_event_freezable_timeout(us->delay_wait,
-//				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
-//				delay_use * HZ);
-//	}
+	set_freezable();
+	/* Wait for the timeout to expire or for a disconnect */
+	if (delay_use > 0) {
+		wait_event_freezable_timeout(us->delay_wait,
+				test_bit(US_FLIDX_DONT_SCAN, &us->dflags),
+				delay_use * HZ);
+	}
 
 	/* If the device is still connected, perform the scanning */
 	if (!test_bit(US_FLIDX_DONT_SCAN, &us->dflags))
-- 
1.7.1

