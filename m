Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541Ab2ALCdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:33:50 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231Ab2ALCcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:32:51 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 3/6 v2] usb/gadget/pch_udc: Fix USB suspend issue
Date: Thu, 12 Jan 2012 11:27:07 +0900
Message-Id: <1326335230-32469-3-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
References: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE:
After USB Suspend, a system rarely freezes.

CAUSE:
When USB Suspend occurred, the driver is not notifying a gadget of the event.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V2: Divide into 6 patches
---
 drivers/usb/gadget/pch_udc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index 78a2fce..6cd9e21 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -2480,8 +2480,15 @@ static void pch_udc_dev_isr(struct pch_udc_dev *dev, u32 dev_intr)
 	if (dev_intr & UDC_DEVINT_SC)
 		pch_udc_svc_cfg_interrupt(dev);
 	/* USB Suspend interrupt */
-	if (dev_intr & UDC_DEVINT_US)
+	if (dev_intr & UDC_DEVINT_US) {
+		if (dev->driver
+			&& dev->driver->suspend) {
+			spin_unlock(&dev->lock);
+			dev->driver->suspend(&dev->gadget);
+			spin_lock(&dev->lock);
+		}
 		dev_dbg(&dev->pdev->dev, "USB_SUSPEND\n");
+	}
 	/* Clear the SOF interrupt, if enabled */
 	if (dev_intr & UDC_DEVINT_SOF)
 		dev_dbg(&dev->pdev->dev, "SOF\n");
-- 
1.7.4.4

