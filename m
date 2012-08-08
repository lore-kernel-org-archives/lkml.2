Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab2HHMvA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 08:51:00 -0400
Received: from mail.ispras.ru ([83.149.199.43]:43451 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753590Ab2HHMu6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 08:50:58 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH] wusb: Fix potential memory leak in wusb_dev_sec_add()
Date: Wed,  8 Aug 2012 16:49:48 +0400
Message-Id: <1344430188-23921-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not leak memory by updating pointer with potentially NULL realloc return value.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/usb/wusbcore/security.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/wusbcore/security.c b/drivers/usb/wusbcore/security.c
index fa810a8..dd88441 100644
--- a/drivers/usb/wusbcore/security.c
+++ b/drivers/usb/wusbcore/security.c
@@ -202,7 +202,7 @@ int wusb_dev_sec_add(struct wusbhc *wusbhc,
 {
 	int result, bytes, secd_size;
 	struct device *dev = &usb_dev->dev;
-	struct usb_security_descriptor *secd;
+	struct usb_security_descriptor *secd, *new_secd;
 	const struct usb_encryption_descriptor *etd, *ccm1_etd = NULL;
 	const void *itr, *top;
 	char buf[64];
@@ -221,11 +221,12 @@ int wusb_dev_sec_add(struct wusbhc *wusbhc,
 		goto out;
 	}
 	secd_size = le16_to_cpu(secd->wTotalLength);
-	secd = krealloc(secd, secd_size, GFP_KERNEL);
-	if (secd == NULL) {
+	new_secd = krealloc(secd, secd_size, GFP_KERNEL);
+	if (new_secd == NULL) {
 		dev_err(dev, "Can't allocate space for security descriptors\n");
 		goto out;
 	}
+	secd = new_secd;
 	result = usb_get_descriptor(usb_dev, USB_DT_SECURITY,
 				    0, secd, secd_size);
 	if (result < secd_size) {
-- 
1.7.9.5

