Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423320Ab2I1Vb3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:31:29 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422707Ab2I1U2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:28:12 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 123/218] EHCI: Update qTD next pointer in QH overlay region during unlink
Date: Fri, 28 Sep 2012 13:15:40 -0700
Message-Id: <20120928201515.608906426@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ehci-q.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -128,9 +128,17 @@ qh_refresh (struct ehci_hcd *ehci, struc
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


