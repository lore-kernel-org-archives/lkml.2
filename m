Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab2EIFwu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 01:52:50 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38684 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755105Ab2EIFwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 01:52:43 -0400
Message-Id: <20120509055034.468801255@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Wed, 09 May 2012 06:51:04 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kishon Vijay Abraham I <kishon@ti.com>,
        Partha Basak <p-basak2@ti.com>, Felipe Balbi <balbi@ti.com>
Subject: [ 035/167] [PATCH] usb: gadget: udc-core: fix asymmetric calls in remove_driver
In-Reply-To: <20120509055029.588587017@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/udc-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc-core.c b/drivers/usb/gadget/udc-core.c
index c261887..2fa9865 100644
--- a/drivers/usb/gadget/udc-core.c
+++ b/drivers/usb/gadget/udc-core.c
@@ -264,8 +264,8 @@ static void usb_gadget_remove_driver(struct usb_udc *udc)
 	if (udc_is_newstyle(udc)) {
 		udc->driver->disconnect(udc->gadget);
 		udc->driver->unbind(udc->gadget);
-		usb_gadget_udc_stop(udc->gadget, udc->driver);
 		usb_gadget_disconnect(udc->gadget);
+		usb_gadget_udc_stop(udc->gadget, udc->driver);
 	} else {
 		usb_gadget_stop(udc->gadget, udc->driver);
 	}
-- 
1.7.10



