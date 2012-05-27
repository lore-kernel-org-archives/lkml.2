Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945925Ab2E0BS5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 21:18:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:36809 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934144Ab2E0BSt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 21:18:49 -0400
Message-Id: <20120527002520.466397889@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Sun, 27 May 2012 09:26:08 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 62/91] USB: fix resource leak in xhci power loss path
In-Reply-To: <20120527010903.GA18244@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.de>

commit f8a9e72d125f4e00ec529ba67b674321a1f3bf31 upstream.

Some more data structures must be freed and counters
reset if an XHCI controller has lost power. The failure
to do so renders some chips inoperative after a certain number
of S4 cycles.

This patch should be backported to kernels as old as 3.2,
that contain the commits c29eea621900f18287d50519f72cb9113746d75a
"xhci: Implement HS/FS/LS bandwidth checking." and
commit 839c817ce67178ca3c7c7ad534c571bba1e69ebe
"xhci: Implement HS/FS/LS bandwidth checking."

Signed-off-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1791,6 +1791,14 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 {
 	struct pci_dev	*pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
 	struct dev_info	*dev_info, *next;
+	struct list_head *tt_list_head;
+	struct list_head *tt;
+	struct list_head *endpoints;
+	struct list_head *ep, *q;
+	struct xhci_tt_bw_info *tt_info;
+	struct xhci_interval_bw_table *bwt;
+	struct xhci_virt_ep *virt_ep;
+
 	unsigned long	flags;
 	int size;
 	int i;
@@ -1850,8 +1858,26 @@ void xhci_mem_cleanup(struct xhci_hcd *x
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
+	bwt = &xhci->rh_bw->bw_table;
+	for (i = 0; i < XHCI_MAX_INTERVAL; i++) {
+		endpoints = &bwt->interval_bw[i].endpoints;
+		list_for_each_safe(ep, q, endpoints) {
+			virt_ep = list_entry(ep, struct xhci_virt_ep, bw_endpoint_list);
+			list_del(&virt_ep->bw_endpoint_list);
+			kfree(virt_ep);
+		}
+	}
+
+	tt_list_head = &xhci->rh_bw->tts;
+	list_for_each_safe(tt, q, tt_list_head) {
+		tt_info = list_entry(tt, struct xhci_tt_bw_info, tt_list);
+		list_del(tt);
+		kfree(tt_info);
+	}
+
 	xhci->num_usb2_ports = 0;
 	xhci->num_usb3_ports = 0;
+	xhci->num_active_eps = 0;
 	kfree(xhci->usb2_ports);
 	kfree(xhci->usb3_ports);
 	kfree(xhci->port_array);


