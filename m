Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772Ab1AQKIx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:08:53 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54738 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878Ab1AQKIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:08:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=airJ/WzOc/yVbw4WL+7IyVD1kROvN0DL+h2tNogjoIQkD4qxQIe1tU6IOcxHBajDmL
         dVpClwPoUTAzvu1/g4RtU8TL3qOLVh3yJiDNucSLI7/fDBJp6LuvBKxHdjsSkSXHhDq4
         pYmFg7vUg9+JeOZA+1uQmAF12G4ZkBVL/kXDk=
From: Vasiliy Kulikov <segoon@openwall.com>
To: kernel-janitors@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] hid: hid-roccat-koneplus: potential NULL dereference
Date: Mon, 17 Jan 2011 13:08:45 +0300
Message-Id: <1295258925-31288-1-git-send-email-segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kmalloc() may fail, if so return -ENOMEM.
Also koneplus_init_koneplus_device_struct() should check return code
of koneplus_get_startup_profile() and propagate its return code.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Compile tested only.

 drivers/hid/hid-roccat-koneplus.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 1608c8d..591a97c 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -220,6 +220,8 @@ static int koneplus_get_startup_profile(struct usb_device *usb_dev)
 	int retval;
 
 	buf = kmalloc(sizeof(struct koneplus_startup_profile), GFP_KERNEL);
+	if (buf == NULL)
+		return -ENOMEM;
 
 	retval = koneplus_receive(usb_dev, KONEPLUS_USB_COMMAND_STARTUP_PROFILE,
 			buf, sizeof(struct koneplus_startup_profile));
@@ -614,6 +616,8 @@ static int koneplus_init_koneplus_device_struct(struct usb_device *usb_dev,
 	mutex_init(&koneplus->koneplus_lock);
 
 	koneplus->startup_profile = koneplus_get_startup_profile(usb_dev);
+	if (koneplus->startup_profile < 0)
+		return koneplus->startup_profile;
 
 	msleep(wait);
 	retval = koneplus_get_info(usb_dev, &koneplus->info);
-- 
1.7.0.4

