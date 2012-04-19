Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab2DSVmT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:42:19 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44862 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933467Ab2DSVNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:32 -0400
Message-Id: <20120419210614.359521773@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 38/59] usb: gadget: pch_udc: Fix disconnect issue
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit c50a3bff0edb0acd49d8033a12ea4668e09a31ad upstream.

ISSUE:
When the driver notifies a gadget of a disconnect event, a system
rarely freezes.

CAUSE:
When the driver calls dev->driver->disconnect(), it is not calling
spin_unlock().

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/pch_udc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2338,8 +2338,11 @@ static void pch_udc_svc_ur_interrupt(str
 		/* Complete request queue */
 		empty_req_queue(ep);
 	}
-	if (dev->driver && dev->driver->disconnect)
+	if (dev->driver && dev->driver->disconnect) {
+		spin_unlock(&dev->lock);
 		dev->driver->disconnect(&dev->gadget);
+		spin_lock(&dev->lock);
+	}
 }
 
 /**


