Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549Ab0EPWHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:07:15 -0400
Received: from core.signal11.us ([64.251.29.136]:40674 "EHLO core.signal11.us"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab0EPWHM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:07:12 -0400
Message-ID: <4BF06C8D.6060308@signal11.us>
Date: Sun, 16 May 2010 18:07:09 -0400
From: Alan Ott <alan@signal11.us>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>, Marcel Holtmann <marcel@holtmann.org>,
       Alan Stern <stern@rowland.harvard.edu>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       David Fries <david@fries.net>
Cc: linux-usb@vger.kernel.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] hidraw: Use Interrupt Endpoint for OUT Transfers if Available
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Sun May 16 18:07:11 2010
X-DSPAM-Confidence: 1.0000
X-DSPAM-Probability: 0.0023
X-DSPAM-Signature: 4bf06c8f155891242837057
X-DSPAM-Factors: 27,
	reports, 0.40000,
	reports, 0.40000,
	Received*26+177, 0.40000,
	bytes+transferred, 0.40000,
	1+USB_CTRL_SET_TIMEOUT), 0.40000,
	1+USB_CTRL_SET_TIMEOUT), 0.40000,
	usbhid_output_raw_report(struct, 0.40000,
	<<, 0.40000,
	<<, 0.40000,
	Date*May, 0.40000,
	or, 0.40000,
	actual_length+/, 0.40000,
	an, 0.40000,
	an, 0.40000,
	the+device, 0.40000,
	the+device, 0.40000,
	bInterfaceNumber, 0.40000,
	bInterfaceNumber, 0.40000,
	10, 0.40000,
	To*Fries+<david, 0.40000,
	HID+1, 0.40000,
	>desc, 0.40000,
	>desc, 0.40000,
	I'm+off, 0.40000,
	interface, 0.40000,
	interface, 0.40000,
	|+buf, 0.40000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Ott <alan@signal11.us>

This patch makes the hidraw driver use the first Interrupt OUT endpoint for
HID transfers to the device if such an endpoint exists. This is consistent
with the behavior of the hiddev driver, and the logic is similar.

Signed-off-by: Alan Ott <alan@signal11.us>
---
I believe this to be consistent with the section 4.4 of the HID 1.11
specification located at:
    http://www.usb.org/developers/devclass_docs/HID1_11.pdf

>From the specification (page numbered 10, the 20th page of the document
(xpdf page 20)):

   The Interrupt Out pipe is optional. If a device declares an Interrupt Out
   endpoint then Output reports are transmitted by the host to the device
   through the Interrupt Out endpoint. If no Interrupt Out endpoint is
   declared then Output reports are transmitted to a device through the
   Control endpoint, using Set_Report(Output) requests.

This is also consistent with the way the Windows HID library (hid.dll)
works.

Please let me know if I'm off-base here, or have misread the standard.

Alan.

diff --git a/drivers/hid/usbhid/hid-core.c b/drivers/hid/usbhid/hid-core.c
index 56d06cd..6fd833d 100644
--- a/drivers/hid/usbhid/hid-core.c
+++ b/drivers/hid/usbhid/hid-core.c
@@ -807,16 +807,36 @@ static int usbhid_output_raw_report(struct hid_device *hid, __u8 *buf, size_t co
 	struct usb_host_interface *interface = intf->cur_altsetting;
 	int ret;
 
-	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-		HID_REQ_SET_REPORT,
-		USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
-		((report_type + 1) << 8) | *buf,
-		interface->desc.bInterfaceNumber, buf + 1, count - 1,
-		USB_CTRL_SET_TIMEOUT);
-
-	/* count also the report id */
-	if (ret > 0)
-		ret++;
+	if (usbhid->urbout) {
+		int actual_length;
+		int skipped_report_id = 0;
+		if (buf[0] == 0x0) {
+			/* Don't send the Report ID */
+			buf++;
+			count--;
+			skipped_report_id = 1;
+		}
+		ret = usb_interrupt_msg(dev, usbhid->urbout->pipe,
+			buf, count, &actual_length,
+			USB_CTRL_SET_TIMEOUT);
+		/* return the number of bytes transferred */
+		if (ret == 0) {
+			ret = actual_length;
+			/* count also the report id */
+			if (skipped_report_id)
+				ret++;
+		}
+	} else {
+		ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			HID_REQ_SET_REPORT,
+			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
+			((report_type + 1) << 8) | *buf,
+			interface->desc.bInterfaceNumber, buf + 1, count - 1,
+			USB_CTRL_SET_TIMEOUT);
+		/* count also the report id */
+		if (ret > 0)
+			ret++;
+	}
 
 	return ret;
 }



