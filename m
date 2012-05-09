Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2EIFws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38683 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032Ab2EIFwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:43 -0400
Message-Id: <20120509055034.318079643@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:03 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>
Subject: [ 034/167] [PATCH] usb: gadget: udc-core: stop UDC on device-initiated
 disconnect
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/udc-core.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index 56da49f..c261887 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -411,8 +411,12 @@ static ssize_t usb_udc_softconn_store(struct device *dev,
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
-- 
1.7.10



