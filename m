Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab1GFGwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 02:52:05 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60598 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523Ab1GFGwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 02:52:03 -0400
From: David Chang <dchang@novell.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>
Cc: David Chang <dchang@novell.com>, Joe Perches <joe@perches.com>,
        linux-usb@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, usbip-devel@lists.sourceforge.net
Subject: [PATCH 1/1] staging: usbip: userspace: usbipd.c: fix userspace build error
Date: Wed,  6 Jul 2011 14:52:19 +0800
Message-Id: <1309935139-14746-1-git-send-email-dchang@novell.com>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When build userspace code, got the following error message:
make[2]: Entering directory `/usr/src/staging-2.6/drivers/staging/usbip/userspace/src'
  CC     usbip.o
...
  CCLD   usbip
  CC     usbipd.o
usbipd.c:30:25: fatal error: stub_driver.h: No such file or directory
compilation terminated.
make[2]: *** [usbipd.o] Error 1
make[2]: Leaving directory `/usr/src/staging-2.6/drivers/staging/usbip/userspace/src'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/usr/src/staging-2.6/drivers/staging/usbip/userspace'
make: *** [all] Error 2

Due to commit 756d6726 and a16941ae, stub_driver had been changed
into host_driver, so update header filename and functions name to
fix these build errors

Signed-off-by: David Chang <dchang@novell.com>
CC: Joe Perches <joe@perches.com>
CC: linux-usb@vger.kernel.org
CC: devel@driverdev.osuosl.org
CC: linux-kernel@vger.kernel.org
CC: usbip-devel@lists.sourceforge.net
---
 drivers/staging/usbip/userspace/src/usbipd.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbipd.c b/drivers/staging/usbip/userspace/src/usbipd.c
index 521b44e..ef92f3b 100644
--- a/drivers/staging/usbip/userspace/src/usbipd.c
+++ b/drivers/staging/usbip/userspace/src/usbipd.c
@@ -27,7 +27,7 @@
 #include <glib.h>
 #include <signal.h>
 
-#include "stub_driver.h"
+#include "usbip_host_driver.h"
 #include "usbip_common.h"
 #include "usbip_network.h"
 
@@ -43,7 +43,7 @@ static int send_reply_devlist(int sockfd)
 	reply.ndev = 0;
 
 	/* how many devices are exported ? */
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
+	dlist_for_each_data(host_driver->edev_list, edev, struct usbip_exported_device) {
 		reply.ndev += 1;
 	}
 
@@ -63,7 +63,7 @@ static int send_reply_devlist(int sockfd)
 		return ret;
 	}
 
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
+	dlist_for_each_data(host_driver->edev_list, edev, struct usbip_exported_device) {
 		struct usbip_usb_device pdu_udev;
 
 		dump_usb_device(&edev->udev);
@@ -138,7 +138,7 @@ static int recv_request_import(int sockfd)
 
 	PACK_OP_IMPORT_REQUEST(0, &req);
 
-	dlist_for_each_data(stub_driver->edev_list, edev, struct usbip_exported_device) {
+	dlist_for_each_data(host_driver->edev_list, edev, struct usbip_exported_device) {
 		if (!strncmp(req.busid, edev->udev.busid, SYSFS_BUS_ID_SIZE)) {
 			dbg("found requested device %s", req.busid);
 			found = 1;
@@ -151,7 +151,7 @@ static int recv_request_import(int sockfd)
 		usbip_set_nodelay(sockfd);
 
 		/* export_device needs a TCP/IP socket descriptor */
-		ret = usbip_stub_export_device(edev, sockfd);
+		ret = usbip_host_export_device(edev, sockfd);
 		if (ret < 0)
 			error = 1;
 	} else {
@@ -197,7 +197,7 @@ static int recv_pdu(int sockfd)
 	}
 
 
-	ret = usbip_stub_refresh_device_list();
+	ret = usbip_host_refresh_device_list();
 	if (ret < 0)
 		return -1;
 
@@ -431,7 +431,7 @@ static void do_standalone_mode(gboolean daemonize)
 	if (ret)
 		err("open usb.ids");
 
-	ret = usbip_stub_driver_open();
+	ret = usbip_host_driver_open();
 	if (ret < 0)
 		g_error("driver open failed");
 
@@ -471,7 +471,7 @@ static void do_standalone_mode(gboolean daemonize)
 
 	freeaddrinfo(ai_head);
 	usbip_names_free();
-	usbip_stub_driver_close();
+	usbip_host_driver_close();
 
 	return;
 }
-- 
1.7.3.4

