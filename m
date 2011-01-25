Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab1AYR7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:59:50 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:11958 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab1AYR7s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:59:48 -0500
From: David Daney <ddaney@caviumnetworks.com>
To: linux-usb@vger.kernel.org, gregkh@suse.de, dbrownell@users.sourceforge.net
Cc: linux-kernel@vger.kernel.org, David Daney <ddaney@caviumnetworks.com>
Subject: [PATCH 3/4] USB: EHCI: Rearrange EHCI_URB_TRACE code to avoid GCC-4.6 warnings.
Date: Tue, 25 Jan 2011 09:59:36 -0800
Message-Id: <1295978377-22930-3-git-send-email-ddaney@caviumnetworks.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 25 Jan 2011 17:59:48.0103 (UTC) FILETIME=[A7D6B970:01CBBCB9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With pre-release GCC-4.6, we get a 'set but not used' warning when
EHCI_URB_TRACE is not set because we set the qtd variable without
using it.

Rearrange the statements so that we only set qtd if it will be used.

Signed-off-by: David Daney <ddaney@caviumnetworks.com>
---
 drivers/usb/host/ehci-q.c |   18 ++++++++++--------
 1 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 233c288..fe99895 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1107,22 +1107,24 @@ submit_async (
 	struct list_head	*qtd_list,
 	gfp_t			mem_flags
 ) {
-	struct ehci_qtd		*qtd;
 	int			epnum;
 	unsigned long		flags;
 	struct ehci_qh		*qh = NULL;
 	int			rc;
 
-	qtd = list_entry (qtd_list->next, struct ehci_qtd, qtd_list);
 	epnum = urb->ep->desc.bEndpointAddress;
 
 #ifdef EHCI_URB_TRACE
-	ehci_dbg (ehci,
-		"%s %s urb %p ep%d%s len %d, qtd %p [qh %p]\n",
-		__func__, urb->dev->devpath, urb,
-		epnum & 0x0f, (epnum & USB_DIR_IN) ? "in" : "out",
-		urb->transfer_buffer_length,
-		qtd, urb->ep->hcpriv);
+	{
+		struct ehci_qtd *qtd;
+		qtd = list_entry(qtd_list->next, struct ehci_qtd, qtd_list);
+		ehci_dbg(ehci,
+			 "%s %s urb %p ep%d%s len %d, qtd %p [qh %p]\n",
+			 __func__, urb->dev->devpath, urb,
+			 epnum & 0x0f, (epnum & USB_DIR_IN) ? "in" : "out",
+			 urb->transfer_buffer_length,
+			 qtd, urb->ep->hcpriv);
+	}
 #endif
 
 	spin_lock_irqsave (&ehci->lock, flags);
-- 
1.7.2.3

