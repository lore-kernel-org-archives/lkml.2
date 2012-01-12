Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab2ALCdC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 21:33:02 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2ALCc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 21:32:58 -0500
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com, Tomoya MORINAGA <tomoya.rohm@gmail.com>
Subject: [PATCH 5/6 v2] usb/gadget/pch_udc: Reduce redundant interrupt
Date: Thu, 12 Jan 2012 11:27:09 +0900
Message-Id: <1326335230-32469-5-git-send-email-tomoya.rohm@gmail.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
References: <1326335230-32469-1-git-send-email-tomoya.rohm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ISSUE:
USB Suspend interrupts occur frequently.

CAUSE:
When it is called pch_udc_reconnect() in USB Suspend, it repeats reset and Suspend.

SOLUTION:
pch_udc_reconnect() does not enable all interrupts.
When an enumeration event occurred the driver enables all interrupts.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
---
V2: Divide into 6 patches
---
 drivers/usb/gadget/pch_udc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/pch_udc.c b/drivers/usb/gadget/pch_udc.c
index e81196d..5a8ba41 100644
--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -577,9 +577,7 @@ static void pch_udc_reconnect(struct pch_udc_dev *dev)
 	/* enable device interrupts */
 	/* pch_udc_enable_interrupts() */
 	pch_udc_bit_clr(dev, UDC_DEVIRQMSK_ADDR,
-			UDC_DEVINT_UR | UDC_DEVINT_US |
-			UDC_DEVINT_ENUM |
-			UDC_DEVINT_SI | UDC_DEVINT_SC);
+			UDC_DEVINT_UR | UDC_DEVINT_ENUM);
 
 	/* Clear the disconnect */
 	pch_udc_bit_set(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_RES);
@@ -2424,6 +2422,11 @@ static void pch_udc_svc_enum_interrupt(struct pch_udc_dev *dev)
 	pch_udc_set_dma(dev, DMA_DIR_TX);
 	pch_udc_set_dma(dev, DMA_DIR_RX);
 	pch_udc_ep_set_rrdy(&(dev->ep[UDC_EP0OUT_IDX]));
+
+	/* enable device interrupts */
+	pch_udc_enable_interrupts(dev, UDC_DEVINT_UR | UDC_DEVINT_US |
+					UDC_DEVINT_ES | UDC_DEVINT_ENUM |
+					UDC_DEVINT_SI | UDC_DEVINT_SC);
 }
 
 /**
-- 
1.7.4.4

