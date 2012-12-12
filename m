Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2LLKWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 05:22:25 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:8916 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780Ab2LLKWW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 05:22:22 -0500
From: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zihan@huawei.com>, <Lin.Lei@huawei.com>,
        <greg@kroah.com>, <neil.yi@huawei.com>, <wangyuhua@huawei.com>,
        <huqiao36@huawei.com>
Message-ID: <fe8c905bb12.b12fe8c905b@huawei.com>
Date: Wed, 12 Dec 2012 18:20:33 +0800
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
MIME-Version: 1.0
Content-Language: zh-CN
Subject: [PATCH 1/1]linux-usb: optimize to match the Huawei USB storage
 devices and support new switch command
X-Accept-Language: zh-CN
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>

1. To optimize the match rules for the Huawei USB storage devices. Avoid to load USB storage driver for modem interface with Huawei devices.
2. Add to support new switch command for new Huawei USB dongles.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
-------------------------------------------------------------------------------------------------
diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.c linux-3.7/drivers/usb/storage/initializers.c
--- linux-3.7_bak/drivers/usb/storage/initializers.c	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/initializers.c	2012-12-12 16:26:53.000000000 +0800
@@ -92,8 +92,8 @@ int usb_stor_ucr61s2b_init(struct us_dat
 	return 0;
 }
 
-/* This places the HUAWEI E220 devices in multi-port mode */
-int usb_stor_huawei_e220_init(struct us_data *us)
+/* This places the HUAWEI usb dongles in multi-port mode */
+static int usb_stor_huawei_feature_init(struct us_data *us)
 {
 	int result;
 
@@ -104,3 +104,60 @@ int usb_stor_huawei_e220_init(struct us_
 	US_DEBUGP("Huawei mode set result is %d\n", result);
 	return 0;
 }
+
+/*Find the supported Huawei USB dongles*/
+static int usb_stor_huawei_dongles_pid(struct us_data *us)
+{
+	int ret = 0;
+	struct usb_interface_descriptor *idesc = NULL;
+	idesc = &us->pusb_intf->cur_altsetting->desc;
+	if (idesc != NULL && idesc->bInterfaceNumber == 0) {
+			if ((us->pusb_dev->descriptor.idProduct >= 0x1401 && us->pusb_dev->descriptor.idProduct <= 0x1600)
+					|| (us->pusb_dev->descriptor.idProduct >= 0x1c02 && us->pusb_dev->descriptor.idProduct <= 0x2202)
+					|| (us->pusb_dev->descriptor.idProduct == 0x1001)
+					|| (us->pusb_dev->descriptor.idProduct == 0x1003)
+					|| (us->pusb_dev->descriptor.idProduct == 0x1004)) {
+
+				if (us->pusb_dev->descriptor.idProduct >= 0x1501 
+					&& us->pusb_dev->descriptor.idProduct <= 0x1504) {
+					ret = 0;
+				} else {
+					ret = 1;
+				}
+			}
+		}
+	return ret;
+}
+
+static int usb_stor_huawei_scsi_init(struct us_data *us)
+{
+	int result = 0;
+	int act_len = 0;
+	unsigned char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x00, 0x00, 
+				      0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct bulk_cb_wrap bcbw = {0};
+	bcbw.Signature = cpu_to_le32(US_BULK_CB_SIGN);
+	bcbw.Tag = 0;
+	bcbw.DataTransferLength = cpu_to_le32(0);
+	bcbw.Flags = bcbw.Lun = 0;
+	bcbw.Length = sizeof(rewind_cmd);
+	memset(bcbw.CDB, 0, sizeof(bcbw.CDB));
+	memcpy(bcbw.CDB, rewind_cmd, sizeof(rewind_cmd));
+
+	result = usb_stor_bulk_transfer_buf (us, us->send_bulk_pipe, &bcbw, 31, &act_len);
+	US_DEBUGP("usb_stor_bulk_transfer_buf performing result is %d, transfer the actual length=%d\n", result, act_len);
+	return result;
+}
+
+int usb_stor_huawei_init(struct us_data *us)
+{
+	int result = 0;
+	if(usb_stor_huawei_dongles_pid(us)) {
+		if ((us->pusb_dev->descriptor.idProduct >= 0x1446)) {
+			result = usb_stor_huawei_scsi_init(us);
+		} else {
+			result = usb_stor_huawei_feature_init(us);
+		}
+	}
+	return result;
+}
diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.h linux-3.7/drivers/usb/storage/initializers.h
--- linux-3.7_bak/drivers/usb/storage/initializers.h	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/initializers.h	2012-12-12 11:43:58.000000000 +0800
@@ -46,5 +46,5 @@ int usb_stor_euscsi_init(struct us_data 
  * flash reader */
 int usb_stor_ucr61s2b_init(struct us_data *us);
 
-/* This places the HUAWEI E220 devices in multi-port mode */
-int usb_stor_huawei_e220_init(struct us_data *us);
+/* This places the HUAWEI usb dongles in multi-port mode */
+int usb_stor_huawei_init(struct us_data *us);
diff -uprN linux-3.7_bak/drivers/usb/storage/unusual_devs.h linux-3.7/drivers/usb/storage/unusual_devs.h
--- linux-3.7_bak/drivers/usb/storage/unusual_devs.h	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/unusual_devs.h	2012-12-12 11:47:34.000000000 +0800
@@ -1527,335 +1527,10 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100, 0x
 /* Reported by fangxiaozhi <huananhu@huawei.com>
  * This brings the HUAWEI data card devices into multi-port mode
  */
-UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x0000,
+UNUSUAL_VENDOR_INTF(  0x12d1, 0x08, 0x06, 0x50,
 		"HUAWEI MOBILE",
 		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1003, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1004, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1401, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1402, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1403, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1404, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1405, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1406, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1407, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1408, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1409, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x140F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1410, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1411, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1412, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1413, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1414, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1415, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1416, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1417, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1418, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1419, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x141F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1420, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1421, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1422, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1423, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1424, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1425, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1426, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1427, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1428, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1429, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x142F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1430, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1431, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1432, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1433, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1434, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1435, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1436, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1437, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1438, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x1439, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143A, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143B, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143C, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143D, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143E, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
-		0),
-UNUSUAL_DEV(  0x12d1, 0x143F, 0x0000, 0x0000,
-		"HUAWEI MOBILE",
-		"Mass Storage",
-		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_e220_init,
+		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_huawei_init,
 		0),
 
 /* Reported by Vilius Bilinkevicius <vilisas AT xxx DOT lt) */
diff -uprN linux-3.7_bak/drivers/usb/storage/usb.c linux-3.7/drivers/usb/storage/usb.c
--- linux-3.7_bak/drivers/usb/storage/usb.c	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/usb.c	2012-12-12 11:46:06.000000000 +0800
@@ -120,6 +120,17 @@ MODULE_PARM_DESC(quirks, "supplemental l
 	.useTransport = use_transport,	\
 }
 
+#define UNUSUAL_VENDOR_INTF(idVendor, cl, sc, pr, \
+		    vendor_name, product_name, use_protocol, use_transport, \
+		    init_function, Flags) \
+{ \
+	.vendorName = vendor_name,	\
+	.productName = product_name,	\
+	.useProtocol = use_protocol,	\
+	.useTransport = use_transport,	\
+	.initFunction = init_function,	\
+}
+
 static struct us_unusual_dev us_unusual_dev_list[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -131,6 +142,7 @@ static struct us_unusual_dev for_dynamic
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 #ifdef CONFIG_LOCKDEP
 
diff -uprN linux-3.7_bak/drivers/usb/storage/usual-tables.c linux-3.7/drivers/usb/storage/usual-tables.c
--- linux-3.7_bak/drivers/usb/storage/usual-tables.c	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/usual-tables.c	2012-12-12 11:47:18.000000000 +0800
@@ -41,6 +41,18 @@
 #define USUAL_DEV(useProto, useTrans) \
 { USB_INTERFACE_INFO(USB_CLASS_MASS_STORAGE, useProto, useTrans) }
 
+/*Define the device is matched with Vendor ID and interface descriptors*/
+#define UNUSUAL_VENDOR_INTF(id_vendor, cl, sc, pr, \
+                    vendorName, productName,useProtocol, useTransport, \
+                    initFunction, flags) \
+{ \
+  .match_flags = USB_DEVICE_ID_MATCH_INT_INFO | USB_DEVICE_ID_MATCH_VENDOR, \
+  .idVendor    = (id_vendor), \
+  .bInterfaceClass = (cl), \
+  .bInterfaceSubClass = (sc), \
+  .bInterfaceProtocol = (pr), \
+  .driver_info = (flags)}
+
 struct usb_device_id usb_storage_usb_ids[] = {
 #	include "unusual_devs.h"
 	{ }		/* Terminating entry */
@@ -50,6 +62,7 @@ MODULE_DEVICE_TABLE(usb, usb_storage_usb
 #undef UNUSUAL_DEV
 #undef COMPLIANT_DEV
 #undef USUAL_DEV
+#undef UNUSUAL_VENDOR_INTF
 
 /*
  * The table of devices to ignore
 


******************************************************************************************
 This email and its attachments contain confidential information from HUAWEI, which is intended only for the person or entity whose address is listed above. Any use of the information contained here in any way (including, but not limited to, total or partial disclosure, reproduction, or dissemination) by persons other than the intended recipient(s) is prohibited. If you receive this email in error, please notify the sender by phone or email
 immediately and delete it!
 *****************************************************************************************
