Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2JAXbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:31:04 -0400
Received: from 1wt.eu ([62.212.114.60]:35185 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932663Ab2JAXAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:35 -0400
Message-Id: <20121001225200.657200678@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:09 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 072/180] xhci: Dont write zeroed pointers to xHC registers.
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 159e1fcc9a60fc7daba23ee8fcdb99799de3fe84 upstream.

When xhci_mem_cleanup() is called, we can't be sure if the xHC is
actually halted.  We can ask the xHC to halt by writing to the RUN bit
in the command register, but that might timeout due to a HW hang.

If the host controller is still running, we should not write zeroed
values to the event ring dequeue pointers or base tables, the DCBAA
pointers, or the command ring pointers.  Eric Fu reports his VIA VL800
host accesses the event ring pointers after a failed register restore on
resume from suspend.  The hypothesis is that the host never actually
halted before the register write to change the event ring pointer to
zero.

Remove all writes of zeroed values to pointer registers in
xhci_mem_cleanup().  Instead, make all callers of the function reset the
host controller first, which will reset those registers to zero.
xhci_mem_init() is the only caller that doesn't first halt and reset the
host controller before calling xhci_mem_cleanup().

This should be backported to kernels as old as 2.6.32.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Tested-by: Elric Fu <elricfu1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 drivers/usb/host/xhci-mem.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 8c29073..d486bb8 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -934,11 +934,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	int i;
 
 	/* Free the Event Ring Segment Table and the actual Event Ring */
-	if (xhci->ir_set) {
-		xhci_writel(xhci, 0, &xhci->ir_set->erst_size);
-		xhci_write_64(xhci, 0, &xhci->ir_set->erst_base);
-		xhci_write_64(xhci, 0, &xhci->ir_set->erst_dequeue);
-	}
 	size = sizeof(struct xhci_erst_entry)*(xhci->erst.num_entries);
 	if (xhci->erst.entries)
 		pci_free_consistent(pdev, size,
@@ -950,7 +945,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->event_ring = NULL;
 	xhci_dbg(xhci, "Freed event ring\n");
 
-	xhci_write_64(xhci, 0, &xhci->op_regs->cmd_ring);
 	if (xhci->cmd_ring)
 		xhci_ring_free(xhci, xhci->cmd_ring);
 	xhci->cmd_ring = NULL;
@@ -969,7 +963,6 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	xhci->device_pool = NULL;
 	xhci_dbg(xhci, "Freed device context pool\n");
 
-	xhci_write_64(xhci, 0, &xhci->op_regs->dcbaa_ptr);
 	if (xhci->dcbaa)
 		pci_free_consistent(pdev, sizeof(*xhci->dcbaa),
 				xhci->dcbaa, xhci->dcbaa->dma);
@@ -1146,6 +1139,8 @@ int xhci_mem_init(struct xhci_hcd *xhci, gfp_t flags)
 
 fail:
 	xhci_warn(xhci, "Couldn't initialize memory\n");
+	xhci_halt(xhci);
+	xhci_reset(xhci);
 	xhci_mem_cleanup(xhci);
 	return -ENOMEM;
 }
-- 
1.7.2.1.45.g54fbc



