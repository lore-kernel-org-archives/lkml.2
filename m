Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758143Ab2DXWwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 18:52:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49279 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758062Ab2DXWgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 18:36:07 -0400
Message-Id: <20120424223245.670329887@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Tue, 24 Apr 2012 15:33:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Partha Basak <p-basak2@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 43/62] usb: gadget: udc-core: fix asymmetric calls in remove_driver
In-Reply-To: <20120424223305.GA7748@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kishon Vijay Abraham I <kishon@ti.com>

commit 8ae8090c82eb407267001f75b3d256b3bd4ae691 upstream.

During modprobe of gadget driver, pullup is called after
udc_start. In order to make the exit path symmetric when
removing a gadget driver, call pullup before ->udc_stop.

This is needed to avoid issues with PM where udc_stop
disables the module completely (put IP in reset state,
cut functional and interface clocks, and so on), which
prevents us from accessing the IP's address space,
thus creating the possibility of an abort exception
when we try to access IP's address space after clocks
are off.

Signed-off-by: Partha Basak <p-basak2@ti.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/udc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -212,8 +212,8 @@ static void usb_gadget_remove_driver(str
 	if (udc_is_newstyle(udc)) {
 		udc->driver->disconnect(udc->gadget);
 		udc->driver->unbind(udc->gadget);
-		usb_gadget_udc_stop(udc->gadget, udc->driver);
 		usb_gadget_disconnect(udc->gadget);
+		usb_gadget_udc_stop(udc->gadget, udc->driver);
 	} else {
 		usb_gadget_stop(udc->gadget, udc->driver);
 	}


