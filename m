Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992939Ab2KOI2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 03:28:51 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:45864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992587Ab2KOI2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 03:28:49 -0500
From: Harvey Yang <harvey.huawei.yang@gmail.com>
To: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Harvey Yang <harvey.huawei.yang@gmail.com>
Subject: [PATCH 1/1] usb: usbip: userspace: remove the port state file when detaching port.
Date: Thu, 15 Nov 2012 16:32:49 +0800
Message-Id: <1352968369-19776-1-git-send-email-harvey.huawei.yang@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

with the last detached port state file remaining , usbip reports error on attaching. So clean up the state files on detaching.

Signed-off-by: Harvey Yang <harvey.huawei.yang@gmail.com>
---
 drivers/staging/usbip/userspace/src/usbip_detach.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_detach.c b/drivers/staging/usbip/userspace/src/usbip_detach.c
index 89bf3c1..312745d 100644
--- a/drivers/staging/usbip/userspace/src/usbip_detach.c
+++ b/drivers/staging/usbip/userspace/src/usbip_detach.c
@@ -19,6 +19,7 @@
 #include <sysfs/libsysfs.h>
 
 #include <ctype.h>
+#include <limits.h>
 #include <stdint.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -46,6 +47,7 @@ static int detach_port(char *port)
 {
 	int ret;
 	uint8_t portnum;
+	char path[PATH_MAX+1];
 
 	for (unsigned int i=0; i < strlen(port); i++)
 		if (!isdigit(port[i])) {
@@ -56,6 +58,13 @@ static int detach_port(char *port)
 	/* check max port */
 
 	portnum = atoi(port);
+
+	/* remove the port state file */
+
+	snprintf(path, PATH_MAX, VHCI_STATE_PATH"/port%d", portnum);
+
+	remove(path);
+	rmdir(VHCI_STATE_PATH);
 
 	ret = usbip_vhci_driver_open();
 	if (ret < 0) {
-- 
1.7.1

