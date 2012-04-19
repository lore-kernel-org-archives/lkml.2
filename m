Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab2DSVNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:13:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65069 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933402Ab2DSVNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:13:15 -0400
Message-Id: <20120419210613.916929473@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:06:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Elric Fu <elricfu1@gmail.com>, Andiry Xu <andiry.xu@amd.com>
Subject: [ 33/59] xhci: Fix register save/restore order.
In-Reply-To: <20120419210623.GA12156@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit c7713e736526d8c9f6f87716fb90562a8ffaff2c upstream.

The xHCI 1.0 spec errata released on June 13, 2011, changes the ordering
that the xHCI registers are saved and restored in.  It moves the
interrupt pending (IMAN) and interrupt control (IMOD) registers to be
saved and restored last.  I believe that's because the host controller
may attempt to fetch the event ring table when interrupts are
re-enabled.  Therefore we need to restore the event ring registers
before we re-enable interrupts.

This should be backported to kernels as old as 2.6.37, that contain the
commit 5535b1d5f8885695c6ded783c692e3c0d0eda8ca "USB: xHCI: PCI power
management implementation"

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Elric Fu <elricfu1@gmail.com>
Cc: Andiry Xu <andiry.xu@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -610,11 +610,11 @@ static void xhci_save_registers(struct x
 	xhci->s3.dev_nt = xhci_readl(xhci, &xhci->op_regs->dev_notification);
 	xhci->s3.dcbaa_ptr = xhci_read_64(xhci, &xhci->op_regs->dcbaa_ptr);
 	xhci->s3.config_reg = xhci_readl(xhci, &xhci->op_regs->config_reg);
-	xhci->s3.irq_pending = xhci_readl(xhci, &xhci->ir_set->irq_pending);
-	xhci->s3.irq_control = xhci_readl(xhci, &xhci->ir_set->irq_control);
 	xhci->s3.erst_size = xhci_readl(xhci, &xhci->ir_set->erst_size);
 	xhci->s3.erst_base = xhci_read_64(xhci, &xhci->ir_set->erst_base);
 	xhci->s3.erst_dequeue = xhci_read_64(xhci, &xhci->ir_set->erst_dequeue);
+	xhci->s3.irq_pending = xhci_readl(xhci, &xhci->ir_set->irq_pending);
+	xhci->s3.irq_control = xhci_readl(xhci, &xhci->ir_set->irq_control);
 }
 
 static void xhci_restore_registers(struct xhci_hcd *xhci)
@@ -623,11 +623,11 @@ static void xhci_restore_registers(struc
 	xhci_writel(xhci, xhci->s3.dev_nt, &xhci->op_regs->dev_notification);
 	xhci_write_64(xhci, xhci->s3.dcbaa_ptr, &xhci->op_regs->dcbaa_ptr);
 	xhci_writel(xhci, xhci->s3.config_reg, &xhci->op_regs->config_reg);
-	xhci_writel(xhci, xhci->s3.irq_pending, &xhci->ir_set->irq_pending);
-	xhci_writel(xhci, xhci->s3.irq_control, &xhci->ir_set->irq_control);
 	xhci_writel(xhci, xhci->s3.erst_size, &xhci->ir_set->erst_size);
 	xhci_write_64(xhci, xhci->s3.erst_base, &xhci->ir_set->erst_base);
 	xhci_write_64(xhci, xhci->s3.erst_dequeue, &xhci->ir_set->erst_dequeue);
+	xhci_writel(xhci, xhci->s3.irq_pending, &xhci->ir_set->irq_pending);
+	xhci_writel(xhci, xhci->s3.irq_control, &xhci->ir_set->irq_control);
 }
 
 static void xhci_set_cmd_ring_deq(struct xhci_hcd *xhci)


