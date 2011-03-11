Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab1CKHiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 02:38:25 -0500
Received: from fox.seas.upenn.edu ([158.130.68.12]:54049 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab1CKHiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 02:38:23 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
To: jkosina@suse.cz, linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, micki@n-trig.com, rydberg@euromail.se,
        chatty@enac.fr, dmitry.torokhov@gmail.com,
        Rafi Rubin <rafi@seas.upenn.edu>
Subject: [PATCH 2/2] hid-ntrig: calibration
Date: Fri, 11 Mar 2011 02:37:52 -0500
Message-Id: <1299829072-19489-2-git-send-email-rafi@seas.upenn.edu>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu>
References: <1299829072-19489-1-git-send-email-rafi@seas.upenn.edu>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2011-03-11_02:2011-03-11,2011-03-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding a function to tell the device to run its calibration routine.
A number written to the sysfs specifies the duration of the calibration
in milliseconds

Signed-off-by: Rafi Rubin <rafi@seas.upenn.edu>
---

The output needs to stay disconnected for the duration for this to work,
otherwise I would have just used submit_report.  Please check to see
that I handled that correctly, I can say it works for me.

Is there a style problem with having wait and sleep in a sysfs call like
this?

Micki: would you care to comment on this?  The windows driver seems to
send extra messages to the device, but in testing they don't seem to
have an effect.  If they do matter, it would be no trouble to put them
back in.  Also can you comment on the difference between "trouble
shooting" and the calibration that your windows tool offers?  As far as
I can tell the actions look very similar.  Is it just a matter of
interpretting the feedback?
---
 drivers/hid/hid-ntrig.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 48 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 24ab6a5..ddf2c76 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -490,6 +490,53 @@ static ssize_t store_mode(struct device *dev,
 }
 static DEVICE_ATTR(mode, S_IWUSR | S_IRUGO, show_mode, store_mode);
 
+static ssize_t ntrig_calibrate(struct device *dev,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
+	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
+	struct usbhid_device *usbhid = hdev->driver_data;
+	int ret;
+	unsigned long t;
+	unsigned char *data;
+
+	if (strict_strtoul(buf, 0, &t))
+		return -EINVAL;
+
+	data = kmalloc(4, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	spin_lock(&usbhid->lock);
+	set_bit(HID_DISCONNECTED, &usbhid->iofl);
+	spin_unlock(&usbhid->lock);
+
+	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			      USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
+			      | USB_RECIP_INTERFACE | USB_DIR_IN,
+			      0x30b, 1, data, 4, USB_CTRL_GET_TIMEOUT);
+	if (ret < 0)
+		goto fail;
+
+	msleep(t);
+
+	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			      USB_REQ_CLEAR_FEATURE, USB_TYPE_CLASS
+			      | USB_RECIP_INTERFACE | USB_DIR_IN,
+			      0x311, 1, data, 4, USB_CTRL_GET_TIMEOUT);
+
+fail:
+	kfree(data);
+	spin_lock(&usbhid->lock);
+	clear_bit(HID_DISCONNECTED, &usbhid->iofl);
+	spin_unlock(&usbhid->lock);
+	schedule_work(&usbhid->reset_work);
+
+	return (ret < 0) ? ret : count;
+}
+static DEVICE_ATTR(calibrate, S_IWUSR, NULL, ntrig_calibrate);
+
 static struct attribute *sysfs_attrs[] = {
 	&dev_attr_sensor_physical_width.attr,
 	&dev_attr_sensor_physical_height.attr,
@@ -502,6 +549,7 @@ static struct attribute *sysfs_attrs[] = {
 	&dev_attr_activation_height.attr,
 	&dev_attr_deactivate_slack.attr,
 	&dev_attr_mode.attr,
+	&dev_attr_calibrate.attr,
 	NULL
 };
 
-- 
1.7.2.3

