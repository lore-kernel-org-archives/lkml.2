Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab0DSMpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 08:45:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5876 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165Ab0DSMpl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 08:45:41 -0400
Message-ID: <4BCC5071.4010509@redhat.com>
Date: Mon, 19 Apr 2010 14:45:37 +0200
From: Stefan Assmann <sassmann@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: linux-usb@vger.kernel.org
Subject: [PATCH] USB: expose Huawei E1550 3G modem
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefan Assmann <sassmann@redhat.com>

The Huawei E1550 3G modem is hidden by default and can be exposed by sending
some magic initialization code. This patch takes care of that.

Signed-off-by: Stefan Assmann <sassmann@redhat.com>
---
 drivers/usb/storage/initializers.c |   21 +++++++++++++++++++++
 drivers/usb/storage/initializers.h |    3 +++
 drivers/usb/storage/unusual_devs.h |    5 +++++
 3 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/storage/initializers.c b/drivers/usb/storage/initializers.c
index 105d900..6f2d3be 100644
--- a/drivers/usb/storage/initializers.c
+++ b/drivers/usb/storage/initializers.c
@@ -102,5 +102,26 @@ int usb_stor_huawei_e220_init(struct us_data *us)
 				      USB_TYPE_STANDARD | USB_RECIP_DEVICE,
 				      0x01, 0x0, NULL, 0x0, 1000);
 	US_DEBUGP("Huawei mode set result is %d\n", result);
+
+	return 0;
+}
+
+/* This exposes the HUAWEI E1550 3G modem */
+int usb_stor_huawei_e1550_init(struct us_data *us)
+{
+	int result;
+	static char init_string[] =
+		"\x55\x53\x42\x43\x00\x00\x00\x00"
+		"\x00\x00\x00\x00\x00\x00\x00\x11"
+		"\x06\x00\x00\x00\x00\x00\x00\x00"
+		"\x00\x00\x00\x00\x00\x00\x00";
+
+	memcpy(us->iobuf, init_string, sizeof(init_string) - 1);
+	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe,
+			us->iobuf,
+			US_BULK_CB_WRAP_LEN,
+			NULL);
+	US_DEBUGP("Huawei mode set result is %d\n", result);
+
 	return 0;
 }
diff --git a/drivers/usb/storage/initializers.h b/drivers/usb/storage/initializers.h
index 529327f..5de8c86 100644
--- a/drivers/usb/storage/initializers.h
+++ b/drivers/usb/storage/initializers.h
@@ -48,3 +48,6 @@ int usb_stor_ucr61s2b_init(struct us_data *us);

 /* This places the HUAWEI E220 devices in multi-port mode */
 int usb_stor_huawei_e220_init(struct us_data *us);
+
+/* This exposes the HUAWEI E1550 3G modem */
+int usb_stor_huawei_e1550_init(struct us_data *us);
diff --git a/drivers/usb/storage/unusual_devs.h b/drivers/usb/storage/unusual_devs.h
index ccf1dbb..907a480 100644
--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -1814,6 +1814,11 @@ UNUSUAL_DEV(  0x12d1, 0x143F, 0x0000, 0x0000,
 		"Mass Storage",
 		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e220_init,
 		0),
+UNUSUAL_DEV(  0x12d1, 0x1446, 0x0000, 0x0000,
+		"HUAWEI MOBILE",
+		"Mass Storage",
+		US_SC_DEVICE, US_PR_DEVICE, usb_stor_huawei_e1550_init,
+		0),

 /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
 UNUSUAL_DEV(  0x132b, 0x000b, 0x0001, 0x0001,
-- 
1.7.0.1

