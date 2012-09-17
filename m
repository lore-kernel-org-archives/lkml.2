Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab2IQBVo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 21:21:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33585 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304Ab2IQAuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 20:50:04 -0400
Message-Id: <20120917003643.356037114@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 17 Sep 2012 01:38:29 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 124/135] EHCI: Update qTD next pointer in QH overlay region during unlink
In-Reply-To: <20120917003625.784119135@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavankumar Kondeti <pkondeti@codeaurora.org>

commit 3d037774b42ed677f699b1dce7d548d55f4e4c2b upstream.

There is a possibility of QH overlay region having reference to a stale
qTD pointer during unlink.

Consider an endpoint having two pending qTD before unlink process begins.
The endpoint's QH queue looks like this.

qTD1 --> qTD2 --> Dummy

To unlink qTD2, QH is removed from asynchronous list and Asynchronous
Advance Doorbell is programmed.  The qTD1's next qTD pointer is set to
qTD2'2 next qTD pointer and qTD2 is retired upon controller's doorbell
interrupt.  If QH's current qTD pointer points to qTD1, transfer overlay
region still have reference to qTD2. But qtD2 is just unlinked and freed.
This may cause EHCI system error.  Fix this by updating qTD next pointer
in QH overlay region with the qTD next pointer of the current qTD.

Signed-off-by: Pavankumar Kondeti <pkondeti@codeaurora.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-q.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ehci-q.c b/drivers/usb/host/ehci-q.c
index 9bc39ca..4b66374 100644
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -128,9 +128,17 @@ qh_refresh (struct ehci_hcd *ehci, struct ehci_qh *qh)
 	else {
 		qtd = list_entry (qh->qtd_list.next,
 				struct ehci_qtd, qtd_list);
-		/* first qtd may already be partially processed */
-		if (cpu_to_hc32(ehci, qtd->qtd_dma) == qh->hw->hw_current)
+		/*
+		 * first qtd may already be partially processed.
+		 * If we come here during unlink, the QH overlay region
+		 * might have reference to the just unlinked qtd. The
+		 * qtd is updated in qh_completions(). Update the QH
+		 * overlay here.
+		 */
+		if (cpu_to_hc32(ehci, qtd->qtd_dma) == qh->hw->hw_current) {
+			qh->hw->hw_qtd_next = qtd->hw_next;
 			qtd = NULL;
+		}
 	}
 
 	if (qtd)


