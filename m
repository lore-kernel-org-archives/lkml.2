Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2E1D3c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 23:29:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52020 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753831Ab2E1D30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 23:29:26 -0400
Message-Id: <20120528031211.580118574@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 28 May 2012 04:13:05 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Oliver Neukum <oneukum@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [ 063/117] USB: fix resource leak in xhci power loss path
In-Reply-To: <20120528031202.829379252@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-mem.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 68eaa90..0b5ff26 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1791,6 +1791,14 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
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
@@ -1849,8 +1857,26 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
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


