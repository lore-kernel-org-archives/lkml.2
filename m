Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754356Ab0F1OVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 10:21:34 -0400
Received: from trinity.develer.com ([83.149.158.210]:45931 "EHLO
	trinity.develer.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752142Ab0F1OVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 10:21:33 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jun 2010 10:21:33 EDT
Date: Mon, 28 Jun 2010 16:14:06 +0200
From: Andrea Righi <arighi@develer.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Rodolfo Giometti <giometti@enneenne.com>,
       Amit Walambe <amit.walambe@eurotech.com>,
       Chris Leahy <leahycm@gmail.com>, Giovanni Bajo <rasky@develer.com>,
       linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] USB: EHCI: fix NULL pointer dererence in HCDs that use
 HCD_LOCAL_MEM
Message-ID: <20100628141355.GA3807@linux.develer.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we use the HCD_LOCAL_MEM flag and dma_declare_coherent_memory() to
enforce the host controller's local memory utilization we also need to
disable native scatter-gather support, otherwise hcd_alloc_coherent() in
map_urb_for_dma() is called with urb->transfer_buffer == NULL, that
triggers a NULL pointer dereference.

We can also consider to add a WARN_ON() and return an error code to
better catch this problem in the future.

Signed-off-by: Andrea Righi <arighi@develer.com>
---
 drivers/usb/core/hcd.c      |    5 +++++
 drivers/usb/host/ehci-hcd.c |    3 ++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 12742f1..161c757 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -1219,6 +1219,11 @@ static int hcd_alloc_coherent(struct usb_bus *bus,
 {
 	unsigned char *vaddr;
 
+	if (*vaddr_handle == NULL) {
+		WARN_ON_ONCE(1);
+		return -EFAULT;
+	}
+
 	vaddr = hcd_buffer_alloc(bus, size + sizeof(vaddr),
 				 mem_flags, dma_handle);
 	if (!vaddr)
diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index a3ef2a9..27e0351 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -606,7 +606,8 @@ static int ehci_init(struct usb_hcd *hcd)
 	ehci->command = temp;
 
 	/* Accept arbitrarily long scatter-gather lists */
-	hcd->self.sg_tablesize = ~0;
+	if (!(hcd->driver->flags & HCD_LOCAL_MEM))
+		hcd->self.sg_tablesize = ~0;
 	return 0;
 }
 
