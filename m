Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966Ab0ILTdK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 15:33:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43199 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753457Ab0ILTdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 15:33:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GzcgcvOuGssmtj3Uo+YEF39pypQST4/SIf54UfvqsDp34MzElCjXRGkyqEP6Zm9Ntg
         b+NgHNVVKAvAfQNnlBqle/fEmx+F5yX0ZS1T5xVBSKny+wPMJaDiMjT54wRtW0JWdfRU
         8uYO2L+344KZuDf/KOhGWYUqNEbdxX06Lmw1Y=
From: Guillaume Chazarain <guichaz@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>, Jiri Kosina <jkosina@suse.cz>,
        "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Guillaume Chazarain <guichaz@gmail.com>
Subject: [PATCH] Fix hiddev's use of usb_find_interface
Date: Sun, 12 Sep 2010 21:32:35 +0200
Message-Id: <1284319955-6014-1-git-send-email-guichaz@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My macbook infrared remote control was broken by commit
bd25f4dd6972755579d0ea50d1a5ace2e9b00d1a:
HID: hiddev: use usb_find_interface, get rid of BKL

This device appears in dmesg as:
apple 0003:05AC:8242.0001: hiddev0,hidraw0: USB HID v1.11 Device
[Apple Computer, Inc. IR Receiver] on usb-0000:00:1d.2-1/input0

It stopped working as lircd was getting ENODEV when opening /dev/usb/hiddev0.

AFAICS hiddev_driver is a dummy driver so usb_find_interface(&hiddev_driver)
does not find anything.

The device is associated with the usbhid driver, so let's do
usb_find_interface(&hid_driver) instead.

$ ls -l /sys/devices/pci0000:00/0000:00:1d.2/usb7/7-1/7-1:1.0/usb/hiddev0/device/driver
lrwxrwxrwx 1 root root 0 2010-09-12 16:28 /sys/devices/pci0000:00/0000:00:1d.2/usb7/7-1/7-1:1.0/usb/hiddev0/device/driver -> ../../../../../../bus/usb/drivers/usbhid

Signed-off-by: Guillaume Chazarain <guichaz@gmail.com>
---
 drivers/hid/usbhid/hid-core.c |    5 +++++
 drivers/hid/usbhid/hiddev.c   |    2 +-
 drivers/hid/usbhid/usbhid.h   |    1 +
 3 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index b729c02..7b2f7f6 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -1445,6 +1445,11 @@ static const struct hid_device_id hid_usb_table[] = {
 	{ }
 };
 
+struct usb_interface *usbhid_find_interface(int minor)
+{
+	return usb_find_interface(&hid_driver, minor);
+}
+
 static struct hid_driver hid_usb_driver = {
 	.name = "generic-usb",
 	.id_table = hid_usb_table,
diff --git a/drivers/hid/usbhid/hiddev.c b/drivers/hid/usbhid/hiddev.c
index 0a29c51..681e620 100644
--- a/drivers/hid/usbhid/hiddev.c
+++ b/drivers/hid/usbhid/hiddev.c
@@ -270,7 +270,7 @@ static int hiddev_open(struct inode *inode, struct file *file)
 	struct hiddev *hiddev;
 	int res;
 
-	intf = usb_find_interface(&hiddev_driver, iminor(inode));
+	intf = usbhid_find_interface(iminor(inode));
 	if (!intf)
 		return -ENODEV;
 	hid = usb_get_intfdata(intf);
diff --git a/drivers/hid/usbhid/usbhid.h b/drivers/hid/usbhid/usbhid.h
index 693fd3e..89d2e84 100644
--- a/drivers/hid/usbhid/usbhid.h
+++ b/drivers/hid/usbhid/usbhid.h
@@ -42,6 +42,7 @@ void usbhid_submit_report
 (struct hid_device *hid, struct hid_report *report, unsigned char dir);
 int usbhid_get_power(struct hid_device *hid);
 void usbhid_put_power(struct hid_device *hid);
+struct usb_interface *usbhid_find_interface(int minor);
 
 /* iofl flags */
 #define HID_CTRL_RUNNING	1
-- 
1.7.0.4

