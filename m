Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759142Ab1EBOKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 10:10:03 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42008 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758573Ab1EBOKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 10:10:00 -0400
Date: Mon, 2 May 2011 10:09:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@kernel.org>,
        <hirofuchi@users.sourceforge.net>, <arjan.mels@gmx.net>, <rjw@sisk.pl>,
        Stanislav SCHATTKE <schattke@linuxbox.cz>
Subject: Re: [regression?] d199c96d41d80a567493e12b8e96ea056a1350c1 breaks
 usbip
In-Reply-To: <20110501192725.GA28466@kroah.com>
Message-ID: <Pine.LNX.4.44L0.1105021008491.2106-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 May 2011, Greg KH wrote:

> On Sun, May 01, 2011 at 08:10:30PM +0200, Nikola Ciprich wrote:
> > Hello,
> > we've hit regression introduced by d199c96d41d80a567493e12b8e96ea056a1350c1:
> > 
> > Author: Alan Stern <stern@rowland.harvard.edu>
> > Date:   Mon Jan 31 10:56:37 2011 -0500
> > 
> >     USB: prevent buggy hubs from crashing the USB stack
> >     
> >     If anyone comes across a high-speed hub that (by mistake or by design)
> >     claims to have no Transaction Translators, plugging a full- or
> >     low-speed device into it will cause the USB stack to crash.  This
> >     patch (as1446) prevents the problem by ignoring such devices, since
> >     the kernel has no way to communicate with them.
> >     
> >     Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> >     Tested-by: Perry Neben <neben@vmware.com>
> >     CC: <stable@kernel.org>
> >     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> > 
> > since this commit, trying to use staging/usbip spits message about missing TT:
> > 
> > [  388.893134] usbip_common_mod: module is from the staging directory, the quality is unknown, you have been warned.
> > [  388.898154] usbip_common_mod: usbip common driver1.0
> > [  388.905360] vhci_hcd: module is from the staging directory, the quality is unknown, you have been warned.
> > [  388.909991] vhci_hcd: vhci_hcd, 1.0
> > [  388.912370] usbip: proving...
> > [  388.912379] vhci_hcd vhci_hcd: USB/IP Virtual Host Contoroller
> > [  388.913052] vhci_hcd vhci_hcd: new USB bus registered, assigned bus number 2
> > [  388.932339] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
> > [  388.932344] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
> > [  388.932348] usb usb2: Product: USB/IP Virtual Host Contoroller
> > [  388.932351] usb usb2: Manufacturer: Linux 2.6.32lb.38 vhci_hcd
> > [  388.932354] usb usb2: SerialNumber: vhci_hcd
> > [  388.932531] usb usb2: configuration #1 chosen from 1 choice
> > [  388.932578] hub 2-0:1.0: USB hub found
> > [  388.932587] hub 2-0:1.0: 8 ports detected
> > [  478.379036] usbip: rhport(0) sockfd(3) devid(131075) speed(2)
> > [  478.379214] usbip: changed 1
> > [  478.500048] usbip: changed 0
> > [  478.608075] usb 2-1: new full speed USB device using vhci_hcd and address 2
> > [  478.608079] usb 2-1: parent hub has no TT
> > [  478.720074] usb 2-1: new full speed USB device using vhci_hcd and address 3
> > [  478.720078] usb 2-1: parent hub has no TT
> > [  478.832086] usb 2-1: new full speed USB device using vhci_hcd and address 4
> > [  478.832091] usb 2-1: parent hub has no TT
> > [  478.944076] usb 2-1: new full speed USB device using vhci_hcd and address 5
> > [  478.944080] usb 2-1: parent hub has no TT
> > [  478.944087] hub 2-0:1.0: unable to enumerate USB device on port 1
> > 
> > I'm not sure whether this is bug in
> > d199c96d41d80a567493e12b8e96ea056a1350c1, I guess it might be usbip
> > problem.
> > Since d199c96d41d80a567493e12b8e96ea056a1350c1 already got into
> > -stable, usbip stopped working in 2.6.32.x (and I guess also stable
> > and longterm kernels).
> 
> This is a usbip problem, we need to set the correct flag for it to work
> properly.  I'll look into it tomorrow when I get a chance.

Here's a patch which should fix the problem.  Nikola, can you test it?

Alan Stern



Index: usb-2.6/drivers/staging/usbip/vhci_hcd.c
===================================================================
--- usb-2.6.orig/drivers/staging/usbip/vhci_hcd.c
+++ usb-2.6/drivers/staging/usbip/vhci_hcd.c
@@ -1139,7 +1139,7 @@ static int vhci_hcd_probe(struct platfor
 		usbip_uerr("create hcd failed\n");
 		return -ENOMEM;
 	}
-
+	hcd->has_tt = 1;
 
 	/* this is private data for vhci_hcd */
 	the_controller = hcd_to_vhci(hcd);

