Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142Ab1H2Uyi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 16:54:38 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:53731 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755019Ab1H2Uyd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 16:54:33 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jarod Wilson <jarod@wilsonet.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] staging: lirc_sasem: fix NULL pointer dereference in sasem_probe
Date: Tue, 30 Aug 2011 00:54:21 +0400
Message-Id: <1314651261-31850-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If any memory allocation failed, goto alloc_status_switch
leads to mutex_unlock(&context->ctx_lock) while context is NULL.
The patch moves alloc_status_switch to handle error conditions
in correct way.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/staging/lirc/lirc_sasem.c |   46 ++++++++++++++++++------------------
 1 files changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/lirc/lirc_sasem.c b/drivers/staging/lirc/lirc_sasem.c
index 7080cde..a2d18b0 100644
--- a/drivers/staging/lirc/lirc_sasem.c
+++ b/drivers/staging/lirc/lirc_sasem.c
@@ -814,29 +814,6 @@ static int sasem_probe(struct usb_interface *interface,
 		printk(KERN_INFO "%s: Registered Sasem driver (minor:%d)\n",
 			__func__, lirc_minor);
 
-alloc_status_switch:
-
-	switch (alloc_status) {
-
-	case 7:
-		if (vfd_ep_found)
-			usb_free_urb(tx_urb);
-	case 6:
-		usb_free_urb(rx_urb);
-	case 5:
-		lirc_buffer_free(rbuf);
-	case 4:
-		kfree(rbuf);
-	case 3:
-		kfree(driver);
-	case 2:
-		kfree(context);
-		context = NULL;
-	case 1:
-		retval = -ENOMEM;
-		goto unlock;
-	}
-
 	/* Needed while unregistering! */
 	driver->minor = lirc_minor;
 
@@ -867,6 +844,29 @@ alloc_status_switch:
 			__func__, dev->bus->busnum, dev->devnum);
 unlock:
 	mutex_unlock(&context->ctx_lock);
+
+alloc_status_switch:
+	switch (alloc_status) {
+
+	case 7:
+		if (vfd_ep_found)
+			usb_free_urb(tx_urb);
+	case 6:
+		usb_free_urb(rx_urb);
+	case 5:
+		lirc_buffer_free(rbuf);
+	case 4:
+		kfree(rbuf);
+	case 3:
+		kfree(driver);
+	case 2:
+		kfree(context);
+		context = NULL;
+	case 1:
+		if (retval == 0)
+			retval = -ENOMEM;
+	}
+
 exit:
 	return retval;
 }
-- 
1.7.4.1

