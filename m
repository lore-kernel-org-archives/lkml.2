Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753266Ab0JMOXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 10:23:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53755 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752290Ab0JMOXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 10:23:09 -0400
Date: Wed, 13 Oct 2010 10:23:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
In-Reply-To: <tkrat.9f585ea47331a2a2@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.1010131011160.2311-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Oct 2010, Alan Stern wrote:

> On Mon, 11 Oct 2010, Stefan Richter wrote:
> 
> > Hi,
> > 
> > I have got a monitor with built-in hub to which a keyboard, mouse, and
> > card reader are connected.  At one occasion when I switched the monitor
> > off, the following oops happened.
> > 
> > I have updated from 2.6.36-rc4 to 2.6.36-rc7 on Saturday evening.  I.e.
> > it may be a regression after 2.6.36-rc4, but isn't necessarily so.
> 
> I don't think it's a regression.
> 
> > Oct 11 22:29:21 stein kernel: usb 1-1.2: USB disconnect, address 14
> > Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input0, status -71
> > Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -71
> > Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input1, status -71
> > Oct 11 22:29:21 stein kernel: hub 1-1:1.0: hub_port_status failed (err = -71)
> > Oct 11 22:29:21 stein kernel: hub 1-1:1.0: connect-debounce failed, port 2 disabled
> > Oct 11 22:29:21 stein kernel: usb 1-1: USB disconnect, address 12
> > Oct 11 22:29:21 stein kernel: usb 1-1.1: USB disconnect, address 13
> > Oct 11 22:29:21 stein kernel: usb 1-1.1.1: USB disconnect, address 16
> > Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -71
> > Oct 11 22:29:21 stein kernel: usb 1-1.3: USB disconnect, address 15
> > Oct 11 22:29:21 stein kernel: ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5
> > Oct 11 22:29:21 stein kernel: drivers/hid/usbhid/hid-core.c: can't reset device, 0000:00:12.2-1.3/input0, status -108
> > Oct 11 22:29:21 stein kernel: usb 1-1: clear tt 3 (00f0) error -19
> > Oct 11 22:29:21 stein kernel: BUG: unable to handle kernel NULL pointer dereference at 0000000000000060
> > Oct 11 22:29:21 stein kernel: IP: [<ffffffff8129dbd8>] ehci_clear_tt_buffer_complete+0x31/0x72
> 
> Is this reproducible?  I'd guess that it happens only a fraction of the
> times you turn off the monitor.  Maybe it will be more likely to happen 
> if you are moving the mouse while you turn off the monitor.
> 
> At any rate, I'm baffled.  This log entry:
> 
> 	ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5
> 
> indicates that the ehci-hcd data structures were seriously messed up.  
> It means the qh was not on the async list at a time when it should have
> been (an URB for that qh was completing).

Okay, I figured it out.  The trick is that a qh won't be on the async
list while one of its URBs is completing _if_ the URB was unlinked.  
Disabling the endpoint at that time triggers some bad logic, causing
the driver to think something is wrong even though it isn't.  Given
this insight, the patch below should fix the problem.

Stefan, is it possible for you to tell whether this really does work?
Dave, does this look right to you?

Alan Stern



Index: usb-2.6/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-2.6.orig/drivers/usb/host/ehci-hcd.c
+++ usb-2.6/drivers/usb/host/ehci-hcd.c
@@ -1063,10 +1063,11 @@ rescan:
 				tmp && tmp != qh;
 				tmp = tmp->qh_next.qh)
 			continue;
-		/* periodic qh self-unlinks on empty */
-		if (!tmp)
-			goto nogood;
-		unlink_async (ehci, qh);
+		/* periodic qh self-unlinks on empty, and a COMPLETING qh
+		 * may already be unlinked.
+		 */
+		if (tmp)
+			unlink_async(ehci, qh);
 		/* FALL THROUGH */
 	case QH_STATE_UNLINK:		/* wait for hw to finish? */
 	case QH_STATE_UNLINK_WAIT:
@@ -1083,7 +1084,6 @@ idle_timeout:
 		}
 		/* else FALL THROUGH */
 	default:
-nogood:
 		/* caller was supposed to have unlinked any requests;
 		 * that's not our job.  just leak this memory.
 		 */

