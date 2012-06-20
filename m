Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab2FTSW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 14:22:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45916 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757708Ab2FTSWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 14:22:23 -0400
Message-Id: <20120620173023.426251194@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Date: Wed, 20 Jun 2012 10:30:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Oliver Neukum <oneukum@suse.de>
Subject: [ 29/61] xhci: Fix invalid loop check in xhci_free_tt_info()
In-Reply-To: <20120620173033.GA5634@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

commit 46ed8f00d8982e49f8fe2c1a9cea192f640cb3ba upstream.

xhci_free_tt_info() may access the invalid memory when it removes the
last entry but the list is not empty.  Then tt_next reaches to the
list head but it still tries to check the tt_info of that entry.

This patch fixes the bug and cleans up the messy code by rewriting
with a simple list_for_each_entry_safe().

This patch should be backported to kernels as old as 3.2, that contain
the commit 839c817ce67178ca3c7c7ad534c571bba1e69ebe "xhci: Store
information about roothubs and TTs."

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Reviewed-by: Oliver Neukum <oneukum@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/xhci-mem.c |   39 ++++++++++-----------------------------
 1 file changed, 10 insertions(+), 29 deletions(-)

--- a/drivers/usb/host/xhci-mem.c
+++ b/drivers/usb/host/xhci-mem.c
@@ -793,10 +793,9 @@ static void xhci_free_tt_info(struct xhc
 		struct xhci_virt_device *virt_dev,
 		int slot_id)
 {
-	struct list_head *tt;
 	struct list_head *tt_list_head;
-	struct list_head *tt_next;
-	struct xhci_tt_bw_info *tt_info;
+	struct xhci_tt_bw_info *tt_info, *next;
+	bool slot_found = false;
 
 	/* If the device never made it past the Set Address stage,
 	 * it may not have the real_port set correctly.
@@ -808,34 +807,16 @@ static void xhci_free_tt_info(struct xhc
 	}
 
 	tt_list_head = &(xhci->rh_bw[virt_dev->real_port - 1].tts);
-	if (list_empty(tt_list_head))
-		return;
-
-	list_for_each(tt, tt_list_head) {
-		tt_info = list_entry(tt, struct xhci_tt_bw_info, tt_list);
-		if (tt_info->slot_id == slot_id)
+	list_for_each_entry_safe(tt_info, next, tt_list_head, tt_list) {
+		/* Multi-TT hubs will have more than one entry */
+		if (tt_info->slot_id == slot_id) {
+			slot_found = true;
+			list_del(&tt_info->tt_list);
+			kfree(tt_info);
+		} else if (slot_found) {
 			break;
+		}
 	}
-	/* Cautionary measure in case the hub was disconnected before we
-	 * stored the TT information.
-	 */
-	if (tt_info->slot_id != slot_id)
-		return;
-
-	tt_next = tt->next;
-	tt_info = list_entry(tt, struct xhci_tt_bw_info,
-			tt_list);
-	/* Multi-TT hubs will have more than one entry */
-	do {
-		list_del(tt);
-		kfree(tt_info);
-		tt = tt_next;
-		if (list_empty(tt_list_head))
-			break;
-		tt_next = tt->next;
-		tt_info = list_entry(tt, struct xhci_tt_bw_info,
-				tt_list);
-	} while (tt_info->slot_id == slot_id);
 }
 
 int xhci_alloc_tt_info(struct xhci_hcd *xhci,


