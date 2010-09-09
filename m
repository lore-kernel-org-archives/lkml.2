Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab0IIVbq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 17:31:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55859 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196Ab0IIVbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 17:31:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=NLB/j7gqNfIE37ImExBn0w4BJF4Y8v9VBorurmLfNQs8dg3eHUigmrvCqIE4WdEY1J
         DWSQoXsaDCIH3BGGwCFPSF3WpjlBfYippIU5qTzC+y8M0sV/6CXpGZN9NbdgbbSjd9Qn
         NbW36UWH+M2tUa8SWHwCWFYVCUeHWnNc0XeAM=
Subject: [PATCH] USB: isp1362-hcd: Removes CONFIG_USB_OTG dependent code,
 fix build breakage
From: Javier Martinez Canillas <martinez.javier@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>, Julia Lawall <julia@diku.dk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 09 Sep 2010 17:31:29 -0400
Message-ID: <1284067889.4583.3.camel@lenovo>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In today linux-next I got a compile error on usb/host/isp1362-hcd:

drivers/usb/host/isp1362-hcd.c: In function ‘isp1362_hub_control’:
drivers/usb/host/isp1362-hcd.c:1680: error: ‘ohci’ undeclared (first use in this function)

The problem is when the CONFIG_USB_OTG option is enabled. 

ohci variable is never declared and there isn't any CONFIG_USB_OTG dependent code 
besides the portion defined in isp1362_hub_control. 

So I think that maybe USB OTG support is not needed/supported.

This patch removes the CONFIG_USB_OTG dependent block so the driver can compile cleanly.

Thanks a lot.

Signed-off-by: Javier Martinez Canillas <martinez.javier@gmail.com>
---
 drivers/usb/host/isp1362-hcd.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 0587ad4..ae30440 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -1676,13 +1676,6 @@ static int isp1362_hub_control(struct usb_hcd *hcd, u16 typeReq, u16 wValue,
 		switch (wValue) {
 		case USB_PORT_FEAT_SUSPEND:
 			_DBG(0, "USB_PORT_FEAT_SUSPEND\n");
-#ifdef	CONFIG_USB_OTG
-			if (ohci->hcd.self.otg_port == (wIndex + 1) &&
-			    ohci->hcd.self.b_hnp_enable) {
-				start_hnp(ohci);
-				break;
-			}
-#endif
 			spin_lock_irqsave(&isp1362_hcd->lock, flags);
 			isp1362_write_reg32(isp1362_hcd, HCRHPORT1 + wIndex, RH_PS_PSS);
 			isp1362_hcd->rhport[wIndex] =
-- 
1.7.0.4



