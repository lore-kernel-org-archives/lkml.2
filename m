Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352Ab0KWM11 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 07:27:27 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55659 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753278Ab0KWM1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 07:27:23 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jsawbYhCef9pWiBVaXQpn1i4xbu4/xTBNemafxBmXAZcRaGwnHZOsLvSLajcZ8nxU5
         PUyPQ6CVZ5KdN7uypsAYvtMuDTDlqJnC4qRz+bOhJExCCAP2FYVPC7DKWwF1InyspcZB
         RFmlxJreoEDvR+nv98aBrltCNvMfGVLUKFUxg=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 2/6] staging: ft1000: Use misc device instead self created device.
Date: Tue, 23 Nov 2010 13:29:29 +0100
Message-Id: <1290515373-16145-3-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
References: <1290515373-16145-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use simple misc device for ioctl driver funtionality testing.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c |   90 ++++++++++++++++++---
 1 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 1aec926..d1784a3 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -32,6 +32,7 @@
 #include <linux/poll.h>
 #include <linux/netdevice.h>
 #include <linux/delay.h>
+#include <linux/miscdevice.h>
 
 #include <linux/fs.h>
 #include <linux/kmod.h>
@@ -78,6 +79,47 @@ static struct file_operations ft1000fops =
 	.llseek		= no_llseek,
 };
 
+struct ft1000_misc_device {
+	struct miscdevice dev;
+	int inf_id;
+};
+
+#define FREE_ID (0xFF)
+
+/* we support just 3 devices */
+#define MAX_DEVICE 3
+
+static struct ft1000_misc_device ft1000dev[MAX_DEVICE] = {
+	[0] = {
+		.dev = {
+			.minor = MISC_DYNAMIC_MINOR,
+			.name = "ft1000_1",
+			.nodename = "/net/ft1000_1",
+			.fops = &ft1000fops,
+		},
+		.inf_id = FREE_ID,
+	},
+	[1] = {
+		.dev = {
+			.minor = MISC_DYNAMIC_MINOR,
+			.name = "ft1000_2",
+			.nodename = "/net/ft1000_2",
+			.fops = &ft1000fops,
+		},
+		.inf_id = FREE_ID,
+	},
+	[2] = {
+		.dev = {
+			.minor = MISC_DYNAMIC_MINOR,
+			.name = "ft1000_3",
+			.nodename = "/net/ft1000_3",
+			.fops = &ft1000fops,
+		},
+		.inf_id = FREE_ID,
+	},
+};
+
+
 //---------------------------------------------------------------------------
 // Function:    ft1000_get_buffer
 //
@@ -157,8 +199,17 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
     int result;
     int i;
 
-    // make a new device name
-    sprintf(info->DeviceName, "%s%d", "FT100", info->CardNumber);
+	for (i = 0; i < MAX_DEVICE; i++) {
+		if (ft1000dev[i].inf_id == FREE_ID)
+			break;
+	}
+
+	if (i == MAX_DEVICE) {
+		DEBUG("Max number of devices reached.\n");
+		return -ENODEV;
+	}
+
+	ft1000dev[i].inf_id = info->CardNumber;
 
     DEBUG("ft1000_CreateDevice: number of instance = %d\n", ft1000_flarion_cnt);
     DEBUG("DeviceCreated = %x\n", info->DeviceCreated);
@@ -176,17 +227,17 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 
 
     // register the device
-    DEBUG("ft1000_CreateDevice: \"%s\" device registration\n", info->DeviceName);
+	DEBUG("ft1000_CreateDevice: \"%s\" device registration\n",
+		ft1000dev[i].dev.nodename);
     info->DeviceMajor = 0;
+	result = misc_register(&ft1000dev[i].dev);
+	if (result) {
+		DEBUG("%s: return:  %d\n", __func__, result);
+		return result;
+	}
 
-    result = register_chrdev(info->DeviceMajor, info->DeviceName, &ft1000fops);
-    if (result < 0)
-    {
-	DEBUG("ft1000_CreateDevice: unable to get major %d\n", info->DeviceMajor);
-	return result;
-    }
-
-    DEBUG("ft1000_CreateDevice: registered char device \"%s\"\n", info->DeviceName);
+	DEBUG("ft1000_CreateDevice: registered misc device \"%s\"\n",
+		ft1000dev[i].dev.nodename);
 
     // save a dynamic device major number
     if (info->DeviceMajor == 0)
@@ -271,9 +322,22 @@ void ft1000_DestroyDevice(struct net_device *dev)
     if (info->DeviceCreated)
 	{
         ft1000_flarion_cnt--;
-		unregister_chrdev(info->DeviceMajor, info->DeviceName);
+		for (i = 0; i < MAX_DEVICE; i++) {
+			if (info->CardNumber == ft1000dev[i].inf_id)
+				break;
+		}
+
+		if (i == MAX_DEVICE) {
+			DEBUG("Device couldn't be found\n");
+			return;
+		}
+
 		DEBUG("ft1000_DestroyDevice: unregistered device \"%s\", result = %d\n",
-					   info->DeviceName, result);
+			ft1000dev[i].dev.nodename, result);
+
+		misc_deregister(&ft1000dev[i].dev);
+		ft1000dev[i].inf_id = FREE_ID;
+
 
         // Make sure we free any memory reserve for slow Queue
         for (i=0; i<MAX_NUM_APP; i++) {
-- 
1.7.1

