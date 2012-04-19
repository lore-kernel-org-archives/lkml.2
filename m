Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796Ab2DSVHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:07:40 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41537 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771Ab2DSVHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:07:35 -0400
Message-Id: <20120419210307.399382955@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Felipe Balbi <balbi@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 50/75] xhci: dont re-enable IE constantly
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felipe Balbi <balbi@ti.com>

commit 4e833c0b87a30798e67f06120cecebef6ee9644c upstream.

While we're at that, define IMAN bitfield to aid readability.

The interrupt enable bit should be set once on driver init, and we
shouldn't need to continually re-enable it.  Commit c21599a3 introduced
a read of the irq_pending register, and that allows us to preserve the
state of the IE bit.  Before that commit, we were blindly writing 0x3 to
the register.

This patch should be backported to kernels as old as 2.6.36, or ones
that contain the commit c21599a36165dbc78b380846b254017a548b9de5 "USB:
xhci: Reduce reads and writes of interrupter registers".

Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-ring.c |    2 +-
 drivers/usb/host/xhci.h      |    4 ++++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci-ring.c
+++ b/drivers/usb/host/xhci-ring.c
@@ -2350,7 +2350,7 @@ hw_died:
 		u32 irq_pending;
 		/* Acknowledge the PCI interrupt */
 		irq_pending = xhci_readl(xhci, &xhci->ir_set->irq_pending);
-		irq_pending |= 0x3;
+		irq_pending |= IMAN_IP;
 		xhci_writel(xhci, irq_pending, &xhci->ir_set->irq_pending);
 	}
 
--- a/drivers/usb/host/xhci.h
+++ b/drivers/usb/host/xhci.h
@@ -205,6 +205,10 @@ struct xhci_op_regs {
 #define CMD_PM_INDEX	(1 << 11)
 /* bits 12:31 are reserved (and should be preserved on writes). */
 
+/* IMAN - Interrupt Management Register */
+#define IMAN_IP		(1 << 1)
+#define IMAN_IE		(1 << 0)
+
 /* USBSTS - USB status - status bitmasks */
 /* HC not running - set to 1 when run/stop bit is cleared. */
 #define STS_HALT	XHCI_STS_HALT


