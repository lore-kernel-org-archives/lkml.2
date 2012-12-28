Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932455Ab2L1TTt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:19:49 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55593 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932357Ab2L1TTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:34 -0500
Message-Id: <20121228190340.769212228@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:21 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Alan Stern <stern@rowland.harvard.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Christof Meerwald <cmeerw@cmeerw.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 051/173] USB: EHCI: bugfix: urb->hcpriv should not be NULL
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 2656a9abcf1ec8dd5fee6a75d6997a0f2fa0094e upstream.

This patch (as1632b) fixes a bug in ehci-hcd.  The USB core uses
urb->hcpriv to determine whether or not an URB is active; host
controller drivers are supposed to set this pointer to a non-NULL
value when an URB is queued.  However ehci-hcd sets it to NULL for
isochronous URBs, which defeats the check in usbcore.

In itself this isn't a big deal.  But people have recently found that
certain sequences of actions will cause the snd-usb-audio driver to
reuse URBs without waiting for them to complete.  In the absence of
proper checking by usbcore, the URBs get added to their endpoint list
twice.  This leads to list corruption and a system freeze.

The patch makes ehci-hcd assign a meaningful value to urb->hcpriv for
isochronous URBs.  Improving robustness always helps.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Artem S. Tashkinov <t.artem@lycos.com>
Reported-by: Christof Meerwald <cmeerw@cmeerw.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - Also use usb_pipetype() to work out whether we should call qh_put()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ehci-q.c     |   12 +++---------
 drivers/usb/host/ehci-sched.c |    4 ++--
 2 files changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -264,18 +264,14 @@ ehci_urb_done(struct ehci_hcd *ehci, str
 __releases(ehci->lock)
 __acquires(ehci->lock)
 {
-	if (likely (urb->hcpriv != NULL)) {
-		struct ehci_qh	*qh = (struct ehci_qh *) urb->hcpriv;
-
-		/* S-mask in a QH means it's an interrupt urb */
-		if ((qh->hw->hw_info2 & cpu_to_hc32(ehci, QH_SMASK)) != 0) {
-
-			/* ... update hc-wide periodic stats (for usbfs) */
-			ehci_to_hcd(ehci)->self.bandwidth_int_reqs--;
-		}
-		qh_put (qh);
+	if (usb_pipetype(urb->pipe) == PIPE_INTERRUPT) {
+		/* ... update hc-wide periodic stats */
+		ehci_to_hcd(ehci)->self.bandwidth_int_reqs--;
 	}
 
+	if (usb_pipetype(urb->pipe) != PIPE_ISOCHRONOUS)
+		qh_put((struct ehci_qh *) urb->hcpriv);
+
 	if (unlikely(urb->unlinked)) {
 		COUNT(ehci->stats.unlink);
 	} else {
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1684,7 +1684,7 @@ itd_link_urb (
 
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, iso_sched);
-	urb->hcpriv = NULL;
+	urb->hcpriv = stream;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
 	return enable_periodic(ehci);
@@ -2094,7 +2094,7 @@ sitd_link_urb (
 
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, sched);
-	urb->hcpriv = NULL;
+	urb->hcpriv = stream;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
 	return enable_periodic(ehci);


