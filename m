Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab2FQSiY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:38:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50199 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757849Ab2FQSWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:22:36 -0400
Message-Id: <20120617175950.625370983@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 17 Jun 2012 19:00:45 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Geoff Levand <geoff@infradead.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 64/69] usb: PS3 EHCI QH read work-around
In-Reply-To: <20120617175941.281333656@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoff Levand <geoff@infradead.org>

commit aaa0ef289afe9186f81e2340114ea413eef0492a upstream.

PS3 EHCI HC errata fix 244.  The SCC EHCI HC will not correctly perform QH
reads that occur near or span a micro-frame boundry.  This is due to a problem
in the Nak Count Reload Control logic (EHCI Specification 1.0 Section 4.9.1).

The work-around for this problem is for the HC driver to set I=1 (inactive) for
QHs with H=1 (list head).

Signed-off-by: Geoff Levand <geoff@infradead.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-hcd.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/ehci-hcd.c b/drivers/usb/host/ehci-hcd.c
index e0ca995..9496b7d 100644
--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -670,6 +670,7 @@ static int ehci_init(struct usb_hcd *hcd)
 	hw = ehci->async->hw;
 	hw->hw_next = QH_NEXT(ehci, ehci->async->qh_dma);
 	hw->hw_info1 = cpu_to_hc32(ehci, QH_HEAD);
+	hw->hw_info1 |= cpu_to_hc32(ehci, (1 << 7));	/* I = 1 */
 	hw->hw_token = cpu_to_hc32(ehci, QTD_STS_HALT);
 	hw->hw_qtd_next = EHCI_LIST_END(ehci);
 	ehci->async->qh_state = QH_STATE_LINKED;


