Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810Ab2GOPfp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 11:35:45 -0400
Received: from netrider.rowland.org ([192.131.102.5]:39739 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752083Ab2GOPfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 11:35:36 -0400
Date: Sun, 15 Jul 2012 11:35:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Udo van den Heuvel <udovdh@xs4all.nl>
cc: linux-usb@vger.kernel.org, Jan Ceuleers <jan.ceuleers@computer.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Simon Jones <sijones2010@gmail.com>, <linux-kernel@vger.kernel.org>
Subject: Re: 3.4.4: disabling irq
In-Reply-To: <5002D378.8030800@xs4all.nl>
Message-ID: <Pine.LNX.4.44L0.1207151122050.25880-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 15 Jul 2012, Udo van den Heuvel wrote:

> > The conclusion is that ohci-hcd is the only driver using IRQ 18.  If 
> > you build a kernel with CONFIG_USB_DEBUG enabled, it will be possible 
> > to see if the OHCI hardware is responsible for the IRQ problem.
> > 
> > When the IRQ line gets disabled again, make a copy of the
> > 
> > 	/sys/kernel/debug/usb/ohci/*/registers
> > 
> > files and post them, along with a copy of 
> > /sys/kernel/debug/usb/devices.

> After disabling:

This indicates the controller at 0000:00:13.1 has an outstanding 
interrupt request:

> bus pci, device 0000:00:13.1
> OHCI Host Controller
> ohci_hcd
> OHCI 1.0, NO legacy support registers, rh state running
> control 0x08f HCFS=operational IE PLE CBSR=3
> cmdstatus 0x00000 SOC=0
> intrstatus 0x00000026 FNO SF WDH
> intrenable 0x8000005a MIE RHSC UE RD WDH

The WDH bit is set in both intrstatus and intrenable.  None of the 
other controllers show anything similar.  Therefore, in the absence of 
hardware bugs, this controller must be the one causing your problem.

You can test this by unbinding that controller from the ohci-hcd 
driver:

	echo 0000:00:13.1 >/sys/bus/pci/drivers/ohci_hcd/unbind

Do this before the IRQ error occurs, and see if you get another error.
If you do, get another copy of those "register" files as quickly
afterwards as you can.

That's the controller for bus 4, which has one of the webcams.  If you 
prefer, you could simply unplug the webcam from bus 4 instead; the end 
result should be the same.  (Or even unplug both webcams...)

Alan Stern

