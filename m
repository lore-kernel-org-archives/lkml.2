Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755334Ab2E1Dqz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:46:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52025 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753850Ab2E1D31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:27 -0400
Message-Id: <20120528031208.551705113@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:12:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        Paul Zimmerman <paulz@synopsys.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 041/117] usb: usbtest: two super speed fixes for usbtest
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/misc/usbtest.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 9dcb68f..055b84a 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -1028,7 +1028,10 @@ test_ctrl_queue(struct usbtest_dev *dev, struct usbtest_param *param)
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
@@ -1387,11 +1390,15 @@ static int test_halt(struct usbtest_dev *tdev, int ep, struct urb *urb)
 
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
 


