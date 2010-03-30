Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab0CaAi1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:38:27 -0400
Received: from kroah.org ([198.145.64.141]:48520 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755619Ab0C3XJJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:09 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:57 2010
Message-Id: <20100330224956.791949431@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Reinoud Koornstra <koornstra@hp.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [25/45] USB: EHCI: fix counting of transaction error retries
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit ef4638f955f2c4a667c8af20769d03f5ed3781ca upstream.

This patch (as1274) simplifies the counting of transaction-error
retries.  Now we will count up from 0 to QH_XACTERR_MAX instead of
down from QH_XACTERR_MAX to 0.

The patch also fixes a small bug: qh->xacterr was not getting
initialized for interrupt endpoints.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Reinoud Koornstra <koornstra@hp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-q.c     |   11 +++++------
 drivers/usb/host/ehci-sched.c |    1 +
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -346,12 +346,11 @@ qh_completions (struct ehci_hcd *ehci, s
 				 */
 				if ((token & QTD_STS_XACT) &&
 						QTD_CERR(token) == 0 &&
-						--qh->xacterrs > 0 &&
+						++qh->xacterrs < QH_XACTERR_MAX &&
 						!urb->unlinked) {
 					ehci_dbg(ehci,
-	"detected XactErr len %d/%d retry %d\n",
-	qtd->length - QTD_LENGTH(token), qtd->length,
-	QH_XACTERR_MAX - qh->xacterrs);
+	"detected XactErr len %zu/%zu retry %d\n",
+	qtd->length - QTD_LENGTH(token), qtd->length, qh->xacterrs);
 
 					/* reset the token in the qtd and the
 					 * qh overlay (which still contains
@@ -451,7 +450,7 @@ halt:
 		last = qtd;
 
 		/* reinit the xacterr counter for the next qtd */
-		qh->xacterrs = QH_XACTERR_MAX;
+		qh->xacterrs = 0;
 	}
 
 	/* last urb's completion might still need calling */
@@ -898,7 +897,7 @@ static void qh_link_async (struct ehci_h
 	head->qh_next.qh = qh;
 	head->hw_next = dma;
 
-	qh->xacterrs = QH_XACTERR_MAX;
+	qh->xacterrs = 0;
 	qh->qh_state = QH_STATE_LINKED;
 	/* qtd completions reported later by interrupt */
 }
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -542,6 +542,7 @@ static int qh_link_periodic (struct ehci
 		}
 	}
 	qh->qh_state = QH_STATE_LINKED;
+	qh->xacterrs = 0;
 	qh_get (qh);
 
 	/* update per-qh bandwidth for usbfs */


