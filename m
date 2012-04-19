Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932923Ab2DSVIb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:08:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932638Ab2DSVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:08:25 -0400
Message-Id: <20120419210308.743953015@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:04:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Tomoya MORINAGA <tomoya.rohm@gmail.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 66/75] usb: gadget: pch_udc: Reduce redundant interrupt
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomoya MORINAGA <tomoya.rohm@gmail.com>

commit 833310402c54ad9b676b465fc53ad276b13d36be upstream.

ISSUE:
USB Suspend interrupts occur frequently.

CAUSE:
When it is called pch_udc_reconnect() in USB Suspend, it repeats reset and
Suspend.

SOLUTION:
pch_udc_reconnect() does not enable all interrupts.  When an enumeration event
occurred the driver enables all interrupts.

Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/pch_udc.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/usb/gadget/pch_udc.c
+++ b/drivers/usb/gadget/pch_udc.c
@@ -568,9 +568,7 @@ static void pch_udc_reconnect(struct pch
 	/* enable device interrupts */
 	/* pch_udc_enable_interrupts() */
 	pch_udc_bit_clr(dev, UDC_DEVIRQMSK_ADDR,
-			UDC_DEVINT_UR | UDC_DEVINT_US |
-			UDC_DEVINT_ENUM |
-			UDC_DEVINT_SI | UDC_DEVINT_SC);
+			UDC_DEVINT_UR | UDC_DEVINT_ENUM);
 
 	/* Clear the disconnect */
 	pch_udc_bit_set(dev, UDC_DEVCTL_ADDR, UDC_DEVCTL_RES);
@@ -2420,6 +2418,11 @@ static void pch_udc_svc_enum_interrupt(s
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


