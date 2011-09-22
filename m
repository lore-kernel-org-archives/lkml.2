Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab1IVCz1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 22:55:27 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:56463 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab1IVCzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 22:55:24 -0400
Date: Wed, 21 Sep 2011 23:55:15 -0300
From: "Lucas C. Villa Real" <lucasvr@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Initialize pointer on request_firmware
Message-Id: <20110921235515.7476c5fe.lucasvr@gmail.com>
X-Mailer: Sylpheed 3.1.2 (GTK+ 2.12.8; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, folks,

I've seen some kernel oopses when suspending my machine. The problem comes from isight_firmware, which assumes that, on error, a call to request_firmware() will initialize the provided pointer to the firmware image to NULL.

The patch below fixes the isight_firmware side of the problem and also ensures that request_firmware() always sets the pointer to NULL on such cases (it currently does that for all except one situation).

Signed-off-by: Lucas C. Villa Real <lucasvr@gobolinux.org>

--- linux-3.0.4/drivers/base/firmware_class.c.orig	2011-09-21 21:03:01.000000000 -0300
+++ linux-3.0.4/drivers/base/firmware_class.c	2011-09-21 21:03:13.000000000 -0300
@@ -523,6 +523,7 @@ static int _request_firmware(const struc
 
 	if (WARN_ON(usermodehelper_is_disabled())) {
 		dev_err(device, "firmware: %s will not be loaded\n", name);
+		*firmware_p = NULL;
 		return -EBUSY;
 	}
 
--- linux-3.0.4/drivers/usb/misc/isight_firmware.c.orig	2011-09-21 20:47:39.000000000 -0300
+++ linux-3.0.4/drivers/usb/misc/isight_firmware.c	2011-09-21 20:47:46.000000000 -0300
@@ -39,7 +39,7 @@ static int isight_firmware_load(struct u
 {
 	struct usb_device *dev = interface_to_usbdev(intf);
 	int llen, len, req, ret = 0;
-	const struct firmware *firmware;
+	const struct firmware *firmware = NULL;
 	unsigned char *buf = kmalloc(50, GFP_KERNEL);
 	unsigned char data[4];
 	const u8 *ptr;
