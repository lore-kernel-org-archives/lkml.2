Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab0JSOyo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:54:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33552 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752229Ab0JSOyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:54:43 -0400
Date: Tue, 19 Oct 2010 10:54:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
In-Reply-To: <Pine.LNX.4.44L0.1010170944300.2318-100000@netrider.rowland.org>
Message-ID: <Pine.LNX.4.44L0.1010191049440.1786-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 17 Oct 2010, Alan Stern wrote:

> On Sat, 16 Oct 2010, Stefan Richter wrote:
> 
> > > What I said above wasn't quite right.  This won't help trigger the 
> > > oops, but it should trigger the line saying something like
> > > 
> > > 	ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5
> > > 
> > > That's the real bug.
> > 
> > # grep ' qh ' /var/log/messages
> > Oct 11 22:29:21 stein kernel: ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00)
> > state 5
> > 
> > I.e. there was none anymore since the one which I reported on Monday.
> 
> Evidently this bug is pretty difficult to get hold of.  There has to be 
> an URB that is unlinked at the time the endpoint gets disabled, and 
> ideally it should have failed with a communications error (because the 
> device was unplugged).  Going to the trouble to arrange all that 
> doesn't seem worthwhile.

Okay, here's a patch which definitely causes the problem to surface.  
It contains some extra debugging printouts but you can ignore them.  Or 
you can edit out the hunks that affect ehci-q.c.

Ideally, you would test this while forcing the card reader to run at
full speed, by putting a USB-1.1 hub between the monitor and the card
reader.  But if you don't have one available, don't worry -- the error
message should still appear even though it won't lead to an oops.

And of course, when you run this along with the proposed fix, the error 
message should go away.  :-)

Alan Stern



Index: usb-2.6/drivers/usb/core/hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/hcd.c
+++ usb-2.6/drivers/usb/core/hcd.c
@@ -1627,6 +1627,11 @@ rescan:
 	}
 	spin_unlock_irq(&hcd_urb_list_lock);
 
+	printk(KERN_INFO "flush delay %02x\n", ep->desc.bEndpointAddress);
+	local_irq_disable();
+	mdelay(10);
+	local_irq_enable();
+
 	/* Wait until the endpoint queue is completely empty */
 	while (!list_empty (&ep->urb_list)) {
 		spin_lock_irq(&hcd_urb_list_lock);
Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -74,7 +74,7 @@ static const char	hcd_name [] = "ehci_hc
 #endif
 
 /* magic numbers that can affect system performance */
-#define	EHCI_TUNE_CERR		3	/* 0-3 qtd retries; 0 == don't stop */
+#define	EHCI_TUNE_CERR		0	/* 0-3 qtd retries; 0 == don't stop */
 #define	EHCI_TUNE_RL_HS		4	/* nak throttle; see 4.9 */
 #define	EHCI_TUNE_RL_TT		0
 #define	EHCI_TUNE_MULT_HS	1	/* 1-3 transactions/uframe; 4.10.3 */
Index: usb-2.6/drivers/usb/host/ehci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-q.c
+++ usb-2.6/drivers/usb/host/ehci-q.c
@@ -272,6 +272,9 @@ __acquires(ehci->lock)
 
 	if (unlikely(urb->unlinked)) {
 		COUNT(ehci->stats.unlink);
+		if (urb->unlinked == -ESHUTDOWN)
+		printk(KERN_INFO "give back SHUTDOWN URB %02x\n",
+urb->ep->desc.bEndpointAddress);
 	} else {
 		/* report non-error and short read status as zero */
 		if (status == -EINPROGRESS || status == -EREMOTEIO)
@@ -334,6 +337,8 @@ qh_completions (struct ehci_hcd *ehci, s
 	state = qh->qh_state;
 	qh->qh_state = QH_STATE_COMPLETING;
 	stopped = (state == QH_STATE_IDLE);
+	if (stopped)
+		printk(KERN_INFO "Scan stopped qh\n");
 
  rescan:
 	last = NULL;
@@ -1231,6 +1236,7 @@ static void start_unlink_async (struct e
 	qh->qh_state = QH_STATE_UNLINK;
 	ehci->reclaim = qh = qh_get (qh);
 
+	printk(KERN_INFO "Start async unlink\n");
 	prev = ehci->async;
 	while (prev->qh_next.qh != qh)
 		prev = prev->qh_next.qh;
Index: usb-2.6/drivers/usb/core/message.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/message.c
+++ usb-2.6/drivers/usb/core/message.c
@@ -323,8 +323,13 @@ static void sg_complete(struct urb *urb)
 	/* on the last completion, signal usb_sg_wait() */
 	io->bytes += urb->actual_length;
 	io->count--;
-	if (!io->count)
+	if (!io->count) {
+		if (status == -ESHUTDOWN) {
+			printk(KERN_INFO "sg completion delay\n");
+			mdelay(50);
+		}
 		complete(&io->complete);
+	}
 
 	spin_unlock(&io->lock);
 }

