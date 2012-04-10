Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758923Ab2DJO5i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:57:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35559 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758806Ab2DJO5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:57:36 -0400
Date: Tue, 10 Apr 2012 10:57:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <qi.wang@intel.com>, <yong.y.wang@intel.com>, <joel.clark@intel.com>,
        <kok.howg.ewe@intel.com>
Subject: Re: [PATCH 1/2] usb/ehci-hub: Add workaround for EG20T/ML7213/ML7223/ML7831
In-Reply-To: <1334030835-4681-1-git-send-email-tomoya.rohm@gmail.com>
Message-ID: <Pine.LNX.4.44L0.1204101044490.1605-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012, Tomoya MORINAGA wrote:

> ISSUE: When a bit of EHCI status register (USBSTS) is set
> as 1, if the corresponded bit of EHCI interrupt enable
> register(USBINTR) is set as 1, an interrupt occurs.
> After that, even if the bit of USBINTR is set as 0, the
> interrupt continues occurring.
> Workaround: Clear the bit 3 of USBSTS before enabling the
> interrupt, at resume process.

These two patches do a lot more than is necessary.  At the same time, 
they also seem to do a lot less.

You don't have to check for the faulty product IDs; clearing the
STS_FLR bit (bit 3 of USBSTS) is always okay because the driver doesn't 
use it.

On the other hand, the STS_FLR bit will get set once every second (at
least) whenever the controller is running.  According to your
description above, this means the controller will cause an interrupt
storm as soon as its first interrupt occurs.  What you really need to
do is clear STS_FLR in ehci_irq().

Does the patch below fix your problem?

Alan Stern



 drivers/usb/host/ehci-hcd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: usb-3.4/drivers/usb/host/ehci-hcd.c
===================================================================
--- usb-3.4.orig/drivers/usb/host/ehci-hcd.c
+++ usb-3.4/drivers/usb/host/ehci-hcd.c
@@ -860,8 +860,13 @@ static irqreturn_t ehci_irq (struct usb_
 		goto dead;
 	}
 
+	/*
+	 * We don't use STS_FLR, but some controllers don't like it to
+	 * remain on, so mask it out along with the other status bits.
+	 */
+	masked_status = status & (INTR_MASK | STS_FLR);
+
 	/* Shared IRQ? */
-	masked_status = status & INTR_MASK;
 	if (!masked_status || unlikely(ehci->rh_state == EHCI_RH_HALTED)) {
 		spin_unlock(&ehci->lock);
 		return IRQ_NONE;

