Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754079Ab0C3Rk7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 13:40:59 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45548 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751588Ab0C3Rk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 13:40:57 -0400
Date: Tue, 30 Mar 2010 13:40:56 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003300848430.20258@p34.internal.lan>
Message-ID: <Pine.LNX.4.44L0.1003301329160.1634-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Justin Piszcz wrote:

> Hello!
> 
> I have all the data you asked for:
> 
> 1. # cat 0u > /tmp/0u.mon.out
> 2. The kernel log file.

I prefer to get dmesg output rather than log files.  Logging programs
sometimes drop or skip lines.  But this was okay.

Also, I'd like to see the contents of your /proc/interrupts.  It looks 
like the OHCI controller shares an IRQ line with some other device.

> Also 3.
> # date; cat 0u > /tmp/0u_after_disconnect_usb.mon.out
> Tue Mar 30 08:50:45 EDT 2010
> 
> Here, I ran this, disconnected the mouse and re-connected it.
> 
> All files are here:
> 
> http://home.comcast.net/~jpiszcz/20100330/0u.mon.out.bz2
> http://home.comcast.net/~jpiszcz/20100330/0u_after_disconnect_usb.mon.out.bz2
> http://home.comcast.net/~jpiszcz/20100330/kern.log.bz2
> 
> Hopefully something can be found!

Well, I'm making progress.  Below is a new debugging patch to try in
place of the first one.  This time the dmesg log alone will be
sufficient, no need for a usbmon trace.  And the output should be a lot
smaller, since the new patch doesn't print something every time an
interrupt occurs, but rather only when you unplug the mouse.

In fact, you might try unplugging the mouse while it still works and
then plugging it back in.  The difference between the debugging
messages while everything is working and the same thing after the mouse
fails should be informative.

(By the way, these tests are meant to find out why your Xorg and khubd
processes hang when the mouse fails, not for finding the original cause
behind the mouse failure.  That can be addressed later.)

> It has happened again, in addition, this is a LONG outstanding bug since
> 2006 or 2007, see below research:
...

Some of those reports indicate that a BIOS update could fix the
problem.  Have you checked your BIOS version?

Alan Stern



Index: usb-2.6/drivers/usb/host/ohci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-hcd.c
+++ usb-2.6/drivers/usb/host/ohci-hcd.c
@@ -292,6 +292,8 @@ static int ohci_urb_dequeue(struct usb_h
 		if (urb_priv) {
 			if (urb_priv->ed->state == ED_OPER)
 				start_ed_unlink (ohci, urb_priv->ed);
+			ohci_info(ohci, "start unlink urb %p, ed %p tick %u\n",
+					urb, urb_priv->ed, urb_priv->ed->tick);
 		}
 	} else {
 		/*
@@ -324,6 +326,9 @@ ohci_endpoint_disable (struct usb_hcd *h
 
 	if (!ed)
 		return;
+	ohci_info(ohci, "disable ed %p (#%02x) state %d%s\n",
+			ed, ep->desc.bEndpointAddress, ed->state,
+			list_empty(&ed->td_list) ? "" : " (has tds)");
 
 rescan:
 	spin_lock_irqsave (&ohci->lock, flags);
Index: usb-2.6/drivers/usb/host/ohci-q.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ohci-q.c
+++ usb-2.6/drivers/usb/host/ohci-q.c
@@ -912,6 +912,9 @@ rescan_all:
 		 * frame counter wraps and EDs with partially retired TDs
 		 */
 		if (likely (HC_IS_RUNNING(ohci_to_hcd(ohci)->state))) {
+			ohci_info(ohci, "finish_unlinks: tick %u, ed %p %u, %d\n",
+					tick, ed, ed->tick,
+					tick_before(tick, ed->tick));
 			if (tick_before (tick, ed->tick)) {
 skip_ed:
 				last = &ed->ed_next;
@@ -928,6 +931,8 @@ skip_ed:
 								TD_MASK;
 
 				/* INTR_WDH may need to clean up first */
+				ohci_info(ohci, "dma %llx head %x\n",
+					(unsigned long long) td->td_dma, head);
 				if (td->td_dma != head) {
 					if (ed == ohci->ed_to_check)
 						ohci->ed_to_check = NULL;
@@ -990,6 +995,8 @@ rescan_this:
 			/* HC may have partly processed this TD */
 			td_done (ohci, urb, td);
 			urb_priv->td_cnt++;
+			ohci_info(ohci, "td_cnt %d length %d\n",
+					urb_priv->td_cnt, urb_priv->length);
 
 			/* if URB is done, clean up */
 			if (urb_priv->td_cnt == urb_priv->length) {

