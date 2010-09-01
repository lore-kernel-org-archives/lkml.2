Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754644Ab0IAJt2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 05:49:28 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:59477 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752767Ab0IAJt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 05:49:27 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: dmitry.torokhov@gmail.com, jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr, Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH] identify firmware version
Date: Wed,  1 Sep 2010 05:48:37 -0400
Message-Id: <1283334517-15121-1-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20100901020634.GD23585@core.coreip.homeip.net>
References: <20100901020634.GD23585@core.coreip.homeip.net>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-01_05:2010-09-01,2010-09-01,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009010021
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds firmware version polling to the end of probe and reports the
version both in the raw form and proccessed to match the formatting used
by ntrig in windows.

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---
 drivers/hid/hid-ntrig.c |   52 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 43e95de..c91ad4a 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -90,6 +90,26 @@ struct ntrig_data {
 };
 
 
+/*
+ * This function converts the 4 byte raw firmware code into
+ * a string containing 5 comma separated numbers.
+ */
+static int ntrig_version_string(unsigned char *raw, char *buf)
+{
+	__u8 a =  (raw[1] & 0b00001110) >> 1;
+	__u8 b =  (raw[0] & 0b00111100) >> 2;
+	__u8 c = ((raw[0] & 0b00000011) << 3) | ((raw[3] & 0b11100000) >> 5);
+	__u8 d = ((raw[3] & 0b00000111) << 3) | ((raw[2] & 0b11100000) >> 5);
+	__u8 e =   raw[2] & 0b00000111;
+
+	/*
+	 * As yet unmapped bits:
+	 * 0b11000000 0b11110001 0b00011000 0b00011000
+	 */
+
+	return sprintf(buf, "%u.%u.%u.%u.%u", a, b, c, d, e);
+}
+
 static ssize_t show_phys_width(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
@@ -776,6 +796,9 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	struct hid_input *hidinput;
 	struct input_dev *input;
 	struct hid_report *report;
+	unsigned char *data;
+	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
+	char *buf;
 
 	if (id->driver_data)
 		hdev->quirks |= HID_QUIRK_MULTI_INPUT;
@@ -848,10 +871,39 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (report)
 		usbhid_submit_report(hdev, report, USB_DIR_OUT);
 
+	data = kmalloc(8, GFP_KERNEL);
+	if (!data) {
+		ret = -ENOMEM;
+		goto err_free;
+	}
+
+	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			      USB_REQ_CLEAR_FEATURE,
+			      USB_TYPE_CLASS | USB_RECIP_INTERFACE |
+			      USB_DIR_IN,
+			      0x30c, 1, data, 8,
+			      USB_CTRL_SET_TIMEOUT);
+
+	if (ret == 8) {
+		buf = kmalloc(20, GFP_KERNEL);
+		if (!buf) {
+			ret = -ENOMEM;
+			goto err_free_data;
+		}
+
+		ret = ntrig_version_string(&data[2], buf);
+
+		dev_info(&hdev->dev,
+			 "Firmware version: %s (%02x%02x %02x%02x)\n",
+			 buf, data[2], data[3], data[4], data[5]);
+	}
+
 	ret = sysfs_create_group(&hdev->dev.kobj,
 			&ntrig_attribute_group);
 
 	return 0;
+err_free_data:
+	kfree(data);
 err_free:
 	kfree(nd);
 	return ret;
-- 
1.7.1

