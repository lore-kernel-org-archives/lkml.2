Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932083Ab2E0A7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 20:59:49 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37624 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755572Ab2E0A7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 20:59:41 -0400
Message-Id: <20120527002619.020280498@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:47 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Zimmerman <paulz@synopsys.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 34/55] usb: usbtest: two super speed fixes for usbtest
In-Reply-To: <20120527005203.GA2146@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Zimmerman <Paul.Zimmerman@synopsys.com>

commit 6a23ccd216b6a8ba2c67a9f9d8969b4431ad2920 upstream.

bMaxPacketSize0 field for super speed is a power of 2, not a count.
The size itself is always 512.

Max packet size for a super speed bulk endpoint is 1024, so
allocate the urb size in halt_simple() accordingly.

Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
Acked-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/misc/usbtest.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1023,7 +1023,10 @@ test_ctrl_queue(struct usbtest_dev *dev,
 		case 13:	/* short read, resembling case 10 */
 			req.wValue = cpu_to_le16((USB_DT_CONFIG << 8) | 0);
 			/* last data packet "should" be DATA1, not DATA0 */
-			len = 1024 - udev->descriptor.bMaxPacketSize0;
+			if (udev->speed == USB_SPEED_SUPER)
+				len = 1024 - 512;
+			else
+				len = 1024 - udev->descriptor.bMaxPacketSize0;
 			expected = -EREMOTEIO;
 			break;
 		case 14:	/* short read; try to fill the last packet */
@@ -1382,11 +1385,15 @@ static int test_halt(struct usbtest_dev
 
 static int halt_simple(struct usbtest_dev *dev)
 {
-	int		ep;
-	int		retval = 0;
-	struct urb	*urb;
+	int			ep;
+	int			retval = 0;
+	struct urb		*urb;
+	struct usb_device	*udev = testdev_to_usbdev(dev);
 
-	urb = simple_alloc_urb(testdev_to_usbdev(dev), 0, 512);
+	if (udev->speed == USB_SPEED_SUPER)
+		urb = simple_alloc_urb(udev, 0, 1024);
+	else
+		urb = simple_alloc_urb(udev, 0, 512);
 	if (urb == NULL)
 		return -ENOMEM;
 


