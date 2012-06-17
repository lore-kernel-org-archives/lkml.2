Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277Ab2FQSij (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:38:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50185 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758034Ab2FQSWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:35 -0400
Message-Id: <20120617175950.313110534@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:43 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: [ 62/69] xhci: Dont free endpoints in xhci_mem_cleanup()
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 32f1d2c536d0c26c5814cb0e6a0606c42d02fac1 upstream.

This patch fixes a few issues introduced in the recent fix
[f8a9e72d: USB: fix resource leak in xhci power loss path]

- The endpoints listed in bw table are just links and each entry is an
 array member of dev->eps[].  But the commit above adds a kfree() call
 to these instances, and thus it results in memory corruption.

- It clears only the first entry of rh_bw[], but there can be multiple
  ports.

- It'd be safer to clear the list_head of ep as well, not only
  removing from the list, as it's checked in
  xhci_discover_or_reset_device().

This patch should be backported to kernels as old as 3.2, that contain
the commit 839c817ce67178ca3c7c7ad534c571bba1e69ebe "xhci: Store
information about roothubs and TTs."

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reviewed-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci-mem.c |   35 ++++++++++++++---------------------
 1 file changed, 14 insertions(+), 21 deletions(-)

diff --git a/drivers/usb/host/xhci-mem.c b/drivers/usb/host/xhci-mem.c
index 898dfc8..77689bd 100644
--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -1772,17 +1772,9 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 {
 	struct pci_dev	*pdev = to_pci_dev(xhci_to_hcd(xhci)->self.controller);
 	struct dev_info	*dev_info, *next;
-	struct list_head *tt_list_head;
-	struct list_head *tt;
-	struct list_head *endpoints;
-	struct list_head *ep, *q;
-	struct xhci_tt_bw_info *tt_info;
-	struct xhci_interval_bw_table *bwt;
-	struct xhci_virt_ep *virt_ep;
-
 	unsigned long	flags;
 	int size;
-	int i;
+	int i, j, num_ports;
 
 	/* Free the Event Ring Segment Table and the actual Event Ring */
 	size = sizeof(struct xhci_erst_entry)*(xhci->erst.num_entries);
@@ -1841,21 +1833,22 @@ void xhci_mem_cleanup(struct xhci_hcd *xhci)
 	}
 	spin_unlock_irqrestore(&xhci->lock, flags);
 
-	bwt = &xhci->rh_bw->bw_table;
-	for (i = 0; i < XHCI_MAX_INTERVAL; i++) {
-		endpoints = &bwt->interval_bw[i].endpoints;
-		list_for_each_safe(ep, q, endpoints) {
-			virt_ep = list_entry(ep, struct xhci_virt_ep, bw_endpoint_list);
-			list_del(&virt_ep->bw_endpoint_list);
-			kfree(virt_ep);
+	num_ports = HCS_MAX_PORTS(xhci->hcs_params1);
+	for (i = 0; i < num_ports; i++) {
+		struct xhci_interval_bw_table *bwt = &xhci->rh_bw[i].bw_table;
+		for (j = 0; j < XHCI_MAX_INTERVAL; j++) {
+			struct list_head *ep = &bwt->interval_bw[j].endpoints;
+			while (!list_empty(ep))
+				list_del_init(ep->next);
 		}
 	}
 
-	tt_list_head = &xhci->rh_bw->tts;
-	list_for_each_safe(tt, q, tt_list_head) {
-		tt_info = list_entry(tt, struct xhci_tt_bw_info, tt_list);
-		list_del(tt);
-		kfree(tt_info);
+	for (i = 0; i < num_ports; i++) {
+		struct xhci_tt_bw_info *tt, *n;
+		list_for_each_entry_safe(tt, n, &xhci->rh_bw[i].tts, tt_list) {
+			list_del(&tt->tt_list);
+			kfree(tt);
+		}
 	}
 
 	xhci->num_usb2_ports = 0;


