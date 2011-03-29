Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab1C2KIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 06:08:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:53972 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786Ab1C2KIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 06:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=UwTWM8WH5ACMUqxl4fjE4XFG0ROvwTabmuoUGuiTEHWISZjOFFICVqkD7s2Nt3QC7o
         HF62+j+O2kotAJ10tXs3fcpsjd1u6d8Xo4euyfKaIm8oJ1m+VV3Yns7PgDNHoGMR9NSp
         Ak7ZYQVu1cAO6FdgQQYG9o7wBVtfXv8U7P5X4=
Subject: [PATCH] mfd: Fix usbhs_enable error handling
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Keshava Munegowda <keshava_mgowda@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Mar 2011 18:07:55 +0800
Message-ID: <1301393275.2253.7.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the case of missing platform_data we do not hold a spin_lock,
thus we should not call spin_unlock_irqrestore in the error path.

Also simplify the error handling by separating the successful path
from error path. I think this change improves readability.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/mfd/omap-usb-host.c |    8 +++-----
 1 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/mfd/omap-usb-host.c b/drivers/mfd/omap-usb-host.c
index cb01209..4157d76 100644
--- a/drivers/mfd/omap-usb-host.c
+++ b/drivers/mfd/omap-usb-host.c
@@ -700,8 +700,7 @@ static int usbhs_enable(struct device *dev)
 	dev_dbg(dev, "starting TI HSUSB Controller\n");
 	if (!pdata) {
 		dev_dbg(dev, "missing platform_data\n");
-		ret =  -ENODEV;
-		goto end_enable;
+		return  -ENODEV;
 	}
 
 	spin_lock_irqsave(&omap->lock, flags);
@@ -915,7 +914,8 @@ static int usbhs_enable(struct device *dev)
 
 end_count:
 	omap->count++;
-	goto end_enable;
+	spin_unlock_irqrestore(&omap->lock, flags);
+	return 0;
 
 err_tll:
 	if (pdata->ehci_data->phy_reset) {
@@ -931,8 +931,6 @@ err_tll:
 	clk_disable(omap->usbhost_fs_fck);
 	clk_disable(omap->usbhost_hs_fck);
 	clk_disable(omap->usbhost_ick);
-
-end_enable:
 	spin_unlock_irqrestore(&omap->lock, flags);
 	return ret;
 }
-- 
1.7.1



