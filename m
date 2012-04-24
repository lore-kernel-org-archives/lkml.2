Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758110Ab2DXWgc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:36:32 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:49931 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095Ab2DXWg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:28 -0400
Message-Id: <20120424223245.581203740@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>
Subject: [ 42/62] usb: gadget: udc-core: stop UDC on device-initiated disconnect
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 6d258a4c42089229b855fd706622029decf316d6 upstream.

When we want to do device-initiated disconnect,
let's make sure we stop the UDC in order to
e.g. allow lower power states to be achieved by
turning off unnecessary clocks and/or stoping
PHYs.

When reconnecting, call ->udc_start() again to
make sure UDC is reinitialized.

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -359,8 +359,12 @@ static ssize_t usb_udc_softconn_store(st
 	struct usb_udc		*udc = container_of(dev, struct usb_udc, dev);
 
 	if (sysfs_streq(buf, "connect")) {
+		if (udc_is_newstyle(udc))
+			usb_gadget_udc_start(udc->gadget, udc->driver);
 		usb_gadget_connect(udc->gadget);
 	} else if (sysfs_streq(buf, "disconnect")) {
+		if (udc_is_newstyle(udc))
+			usb_gadget_udc_stop(udc->gadget, udc->driver);
 		usb_gadget_disconnect(udc->gadget);
 	} else {
 		dev_err(dev, "unsupported command '%s'\n", buf);


