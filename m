Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828Ab0IFXc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 19:32:26 -0400
Received: from fox.seas.upenn.edu ([158.130.68.12]:47641 "EHLO
	fox.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751219Ab0IFXcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 19:32:19 -0400
Date: Mon, 6 Sep 2010 19:32:03 -0400
From: Rafi Rubin <rafi@seas.upenn.edu>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, jkosina@suse.cz,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
Message-ID: <20100906233203.GA18048@seas.upenn.edu>
References: <4C7EB3A3.7050402@gmail.com>
 <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu>
 <20100906194838.GB31384@core.coreip.homeip.net>
 <4C855BAA.4000900@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C855BAA.4000900@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.0.10011,1.0.148,0.0.0000
 definitions=2010-09-06_13:2010-09-06,2010-09-06,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 ipscore=0 phishscore=0
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 engine=5.0.0-1005130000 definitions=main-1009060193
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 06, 2010 at 11:22:50PM +0200, Jiri Slaby wrote:
> On 09/06/2010 09:48 PM, Dmitry Torokhov wrote:
> >> @@ -848,10 +871,43 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
> >>  	if (report)
> >>  		usbhid_submit_report(hdev, report, USB_DIR_OUT);
> >>  
> >> +	data = kmalloc(8, GFP_KERNEL);
> >> +	if (!data) {
> >> +		ret = -ENOMEM;
> >> +		goto err_free;
> >> +	}
> >> +
> >> +	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
> >> +			      USB_REQ_CLEAR_FEATURE,
> >> +			      USB_TYPE_CLASS | USB_RECIP_INTERFACE |
> >> +			      USB_DIR_IN,
> >> +			      0x30c, 1, data, 8,
> >> +			      USB_CTRL_SET_TIMEOUT);
> >> +
> >> +	if (ret == 8) {
> >> +		buf = kmalloc(20, GFP_KERNEL);
> >> +		if (!buf) {
> >> +			ret = -ENOMEM;
> >> +			goto err_free_data;
> >> +		}
> > 
> > Why do you allocate this from heap? Surely we can spare 20 bytes on
> > stack (you aren't doing DMA into it).
> 
> Hi, yeah, I think so too.

No arguments from me, that was just sloppy.

> > I'd also split all this code into ntrig_report_version() to simplifu
> > error handling here.
> > 
> >> +
> >> +		ret = ntrig_version_string(&data[2], buf);
> >> +
> >> +		dev_info(&hdev->dev,
> >> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
> >> +			 buf, data[2], data[3], data[4], data[5]);
> >> +
> >> +		kfree(buff);
> 
> In any case, this doesn't compile...
> 
> >> +	}

Jiri, I moved the code to a separate function as Dmitry suggested, and compiled a kernel from a clean tree using 
gcc-3.4 (I think).

If this version fails for you, would you mind being a bit more verbose about the failure.

Rafi

---
 drivers/hid/hid-ntrig.c |   51 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/drivers/hid/hid-ntrig.c b/drivers/hid/hid-ntrig.c
index 43e95de..69169ef 100644
--- a/drivers/hid/hid-ntrig.c
+++ b/drivers/hid/hid-ntrig.c
@@ -90,6 +90,55 @@ struct ntrig_data {
 };
 
 
+/*
+ * This function converts the 4 byte raw firmware code into
+ * a string containing 5 comma separated numbers.
+ */
+static int ntrig_version_string(unsigned char *raw, char *buf)
+{
+	__u8 a =  (raw[1] & 0x0e) >> 1;
+	__u8 b =  (raw[0] & 0x3c) >> 2;
+	__u8 c = ((raw[0] & 0x03) << 3) | ((raw[3] & 0xe0) >> 5);
+	__u8 d = ((raw[3] & 0x07) << 3) | ((raw[2] & 0xe0) >> 5);
+	__u8 e =   raw[2] & 0x07;
+
+	/*
+	 * As yet unmapped bits:
+	 * 0b11000000 0b11110001 0b00011000 0b00011000
+	 */
+
+	return sprintf(buf, "%u.%u.%u.%u.%u", a, b, c, d, e);
+}
+
+static void ntrig_report_version(struct hid_device *hdev)
+{
+	int ret;
+	char buf[20];
+	struct usb_device *usb_dev = hid_to_usb_dev(hdev);
+	unsigned char *data = kmalloc(8, GFP_KERNEL);
+
+	if (!data)
+		goto err_free;
+
+	ret = usb_control_msg(usb_dev, usb_rcvctrlpipe(usb_dev, 0),
+			      USB_REQ_CLEAR_FEATURE,
+			      USB_TYPE_CLASS | USB_RECIP_INTERFACE |
+			      USB_DIR_IN,
+			      0x30c, 1, data, 8,
+			      USB_CTRL_SET_TIMEOUT);
+
+	if (ret == 8) {
+		ret = ntrig_version_string(&data[2], buf);
+
+		dev_info(&hdev->dev,
+			 "Firmware version: %s (%02x%02x %02x%02x)\n",
+			 buf, data[2], data[3], data[4], data[5]);
+	}
+
+err_free:
+	kfree(data);
+}
+
 static ssize_t show_phys_width(struct device *dev,
 			       struct device_attribute *attr,
 			       char *buf)
@@ -848,6 +897,8 @@ static int ntrig_probe(struct hid_device *hdev, const struct hid_device_id *id)
 	if (report)
 		usbhid_submit_report(hdev, report, USB_DIR_OUT);
 
+	ntrig_report_version(hdev);
+
 	ret = sysfs_create_group(&hdev->dev.kobj,
 			&ntrig_attribute_group);
 
-- 
1.7.1


