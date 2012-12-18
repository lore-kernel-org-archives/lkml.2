Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab2LRCoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 21:44:34 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:14521 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754291Ab2LRCoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 21:44:32 -0500
From: fangxiaozhi 00110321 <fangxiaozhi@huawei.com>
To: <linux-usb@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>, <zihan@huawei.com>, <Lin.Lei@huawei.com>,
        <greg@kroah.com>, <neil.yi@huawei.com>, <wangyuhua@huawei.com>,
        <huqiao36@huawei.com>, <balbi@ti.com>
Message-ID: <fdcdb3e12b55.2b55fdcdb3e1@huawei.com>
Date: Tue, 18 Dec 2012 10:44:19 +0800
X-Mailer: iPlanet Messenger Express 5.2 HotFix 2.14 (built Aug  8 2006)
MIME-Version: 1.0
Content-Language: zh-CN
Subject: [PATCH 2/2]linux-usb:optimize to match the Huawei USB storage
 devices and support new switch command
X-Accept-Language: zh-CN
In-Reply-To: <fdcd8d23149d.149dfdcd8d23@huawei.com>
References: <fdcd8d23149d.149dfdcd8d23@huawei.com>
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: fangxiaozhi <huananhu@huawei.com>

1. Optimize the match rules with new macro for Huawei USB storage devices, 
   to avoid to load USB storage driver for the modem interface 
   with Huawei devices.
2. Add to support new switch command for new Huawei USB dongles.

Signed-off-by: fangxiaozhi <huananhu@huawei.com>
--------------------------------------------------------------------

diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.c linux-3.7/drivers/usb/storage/initializers.c
--- linux-3.7_bak/drivers/usb/storage/initializers.c	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/initializers.c	2012-12-17 11:12:12.000000000 +0800
@@ -92,8 +92,8 @@ int usb_stor_ucr61s2b_init(struct us_dat
 	return 0;
 }
 
-/* This places the HUAWEI E220 devices in multi-port mode */
-int usb_stor_huawei_e220_init(struct us_data *us)
+/* This places the HUAWEI usb dongles in multi-port mode */
+static int usb_stor_huawei_feature_init(struct us_data *us)
 {
 	int result;
 
@@ -104,3 +104,59 @@ int usb_stor_huawei_e220_init(struct us_
 	US_DEBUGP("Huawei mode set result is %d\n", result);
 	return 0;
 }
+
+/* Find the supported Huawei USB dongles */
+static int usb_stor_huawei_dongles_pid(struct us_data *us)
+{
+	struct usb_interface_descriptor *idesc;
+	int idProduct;
+	
+	idesc = &us->pusb_intf->cur_altsetting->desc;
+	idProduct = us->pusb_dev->descriptor.idProduct;
+	if (idesc && idesc->bInterfaceNumber == 0) {
+		if ((idProduct == 0x1001)
+			|| (idProduct == 0x1003)
+			|| (idProduct == 0x1004)
+			|| (idProduct >= 0x1401 && idProduct < 0x1501)
+			|| (idProduct > 0x1504 && idProduct <= 0x1600)
+			|| (idProduct >= 0x1c02 && idProduct <= 0x2202)) {
+			return 1;
+		}
+	}
+	return 0;
+}
+
+static int usb_stor_huawei_scsi_init(struct us_data *us)
+{
+	int result = 0;
+	int act_len = 0;
+	char rewind_cmd[] = {0x11, 0x06, 0x20, 0x00, 0x00, 0x01, 0x01, 0x00,
+			0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00};
+	struct bulk_cb_wrap *bcbw = (struct bulk_cb_wrap *) us->iobuf;
+	
+	memset(bcbw, 0, sizeof(struct bulk_cb_wrap));
+	bcbw->Signature = cpu_to_le32(US_BULK_CB_SIGN);
+	bcbw->Tag = 0;
+	bcbw->DataTransferLength = 0;
+	bcbw->Flags = bcbw->Lun = 0;
+	bcbw->Length = sizeof(rewind_cmd);
+	memcpy(bcbw->CDB, rewind_cmd, sizeof(rewind_cmd));
+
+	result = usb_stor_bulk_transfer_buf(us, us->send_bulk_pipe, &bcbw,
+					US_BULK_CS_WRAP_LEN, &act_len);
+	US_DEBUGP("transfer actual length=%d, result=%d\n", act_len, result);
+	return result;
+}
+
+int usb_stor_huawei_init(struct us_data *us)
+{
+	int result = 0;
+	
+	if (usb_stor_huawei_dongles_pid(us)) {
+		if (us->pusb_dev->descriptor.idProduct >= 0x1446)
+			result = usb_stor_huawei_scsi_init(us);
+		else
+			result = usb_stor_huawei_feature_init(us);
+	}
+	return result;
+}
diff -uprN linux-3.7_bak/drivers/usb/storage/initializers.h linux-3.7/drivers/usb/storage/initializers.h
--- linux-3.7_bak/drivers/usb/storage/initializers.h	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/initializers.h	2012-12-17 10:39:55.000000000 +0800
@@ -46,5 +46,5 @@ int usb_stor_euscsi_init(struct us_data 
  * flash reader */
 int usb_stor_ucr61s2b_init(struct us_data *us);
 
-/* This places the HUAWEI E220 devices in multi-port mode */
-int usb_stor_huawei_e220_init(struct us_data *us);
+/* This places the HUAWEI usb dongles in multi-port mode */
+int usb_stor_huawei_init(struct us_data *us);
Binary files linux-3.7_bak/drivers/usb/storage/initializers.o and linux-3.7/drivers/usb/storage/initializers.o differ
diff -uprN linux-3.7_bak/drivers/usb/storage/unusual_devs.h linux-3.7/drivers/usb/storage/unusual_devs.h
--- linux-3.7_bak/drivers/usb/storage/unusual_devs.h	2012-12-11 09:56:11.000000000 +0800
+++ linux-3.7/drivers/usb/storage/unusual_devs.h	2012-12-17 10:40:10.000000000 +0800
@@ -1527,335 +1527,10 @@ UNUSUAL_DEV(  0x1210, 0x0003, 0x0100, 0x
 /* Reported by fangxiaozhi <huananhu@huawei.com>
  * This brings the HUAWEI data card devices into multi-port mode
  */
-UNUSUAL_DEV(  0x12d1, 0x1001, 0x0000, 0x0000,
+UNUSUAL_VENDOR_INTF(0x12d1, 0x08, 0x06, 0x50,
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

