Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0JNOZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 10:25:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49006 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755032Ab0JNOZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 10:25:53 -0400
Date: Thu, 14 Oct 2010 10:25:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
In-Reply-To: <4CB635C1.6040308@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.1010141016540.1645-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Oct 2010, Stefan Richter wrote:

> Alan Stern wrote:
> > Stefan, is it possible for you to tell whether this really does work?
> 
> That will be hard.  So far I was unable to reproduce the oops; still running
> unmodified 2.6.36-rc7.

Was this on an SMP machine?  If yes, the untested patch below may help
trigger the oops.  To use it, insert (but don't mount) a memory card
into the card reader, and use dd to copy a large amount of data from
the card to /dev/null.  While that's running, unplug either the monitor
or the card reader.  You may want to do this at a VT console so you can
see directly when the delay occurs.

Alan Stern



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
+		if (status == -ECONNRESET) {
+			printk(KERN_ERR "Delaying for test\n");
+			mdelay(600);
+		}
 		complete(&io->complete);
+	}
 
 	spin_unlock(&io->lock);
 }

