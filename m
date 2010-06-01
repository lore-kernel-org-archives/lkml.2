Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932298Ab0FAVE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 17:04:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64246 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab0FAVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 17:04:54 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       linux-usb@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 2/6] USB-BKL: Convert usb_driver ioctl to unlocked_ioctl
Date: Tue,  1 Jun 2010 23:04:41 +0200
Message-Id: <1275426285-9088-3-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1275426285-9088-1-git-send-email-arnd@arndb.de>
References: <1275426285-9088-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/U+zVTHwmEfX4OWpQg28p2Txf8o66dejOtOQr
 cRA33kGRYczEK8WOJoXAmTrttM/kjN0qlTP+tp4vI4QoA2ZoQI
 UnovyT4/ykMmO7ec1cd5Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

And audit all the users. None needed the BKL.  That was easy
because there was only very few around.

Tested with allmodconfig build on x86-64

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 drivers/usb/core/devio.c   |    7 ++-----
 drivers/usb/core/hub.c     |    3 ++-
 drivers/usb/misc/usbtest.c |    3 ++-
 include/linux/usb.h        |    2 +-
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index c2f62a3..f1aaff6 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1668,13 +1668,10 @@ static int proc_ioctl(struct dev_state *ps, struct usbdevfs_ioctl *ctl)
 	default:
 		if (intf->dev.driver)
 			driver = to_usb_driver(intf->dev.driver);
-		if (driver == NULL || driver->ioctl == NULL) {
+		if (driver == NULL || driver->unlocked_ioctl == NULL) {
 			retval = -ENOTTY;
 		} else {
-			/* keep API that guarantees BKL */
-			lock_kernel();
-			retval = driver->ioctl(intf, ctl->ioctl_code, buf);
-			unlock_kernel();
+			retval = driver->unlocked_ioctl(intf, ctl->ioctl_code, buf);
 			if (retval == -ENOIOCTLCMD)
 				retval = -ENOTTY;
 		}
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 83e7bbb..d0e77d4 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1294,6 +1294,7 @@ descriptor_error:
 	return -ENODEV;
 }
 
+/* No BKL needed */
 static int
 hub_ioctl(struct usb_interface *intf, unsigned int code, void *user_data)
 {
@@ -3461,7 +3462,7 @@ static struct usb_driver hub_driver = {
 	.reset_resume =	hub_reset_resume,
 	.pre_reset =	hub_pre_reset,
 	.post_reset =	hub_post_reset,
-	.ioctl =	hub_ioctl,
+	.unlocked_ioctl = hub_ioctl,
 	.id_table =	hub_id_table,
 	.supports_autosuspend =	1,
 };
diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 16dffe9..0cfbd78 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1548,6 +1548,7 @@ fail:
  * off just killing the userspace task and waiting for it to exit.
  */
 
+/* No BKL needed */
 static int
 usbtest_ioctl (struct usb_interface *intf, unsigned int code, void *buf)
 {
@@ -2170,7 +2171,7 @@ static struct usb_driver usbtest_driver = {
 	.name =		"usbtest",
 	.id_table =	id_table,
 	.probe =	usbtest_probe,
-	.ioctl =	usbtest_ioctl,
+	.unlocked_ioctl = usbtest_ioctl,
 	.disconnect =	usbtest_disconnect,
 	.suspend =	usbtest_suspend,
 	.resume =	usbtest_resume,
diff --git a/include/linux/usb.h b/include/linux/usb.h
index d5922a8..e6cbc34 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -843,7 +843,7 @@ struct usb_driver {
 
 	void (*disconnect) (struct usb_interface *intf);
 
-	int (*ioctl) (struct usb_interface *intf, unsigned int code,
+	int (*unlocked_ioctl) (struct usb_interface *intf, unsigned int code,
 			void *buf);
 
 	int (*suspend) (struct usb_interface *intf, pm_message_t message);
-- 
1.7.0.4

