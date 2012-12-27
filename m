Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab2L0D4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 22:56:38 -0500
Received: from netrider.rowland.org ([192.131.102.5]:48872 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751876Ab2L0D4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 22:56:37 -0500
Date: Wed, 26 Dec 2012 22:56:35 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Larry Finger <Larry.Finger@lwfinger.net>
cc: LKML <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: Regression in kernel 3.8-rc1 bisected to commit adfa79d: I now
 get many "unable to enumerate USB device" messages
In-Reply-To: <50DB4C27.8040007@lwfinger.net>
Message-ID: <Pine.LNX.4.44L0.1212262251280.25450-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Dec 2012, Larry Finger wrote:

> On 12/26/2012 10:45 AM, Alan Stern wrote:
> >
> > I see.  Do you happen to have CONFIG_USB_EHCI_HCD=y and
> > CONFIG_USB_EHCI_PCI=m in your .config?  If you do, try changing
> > EHCI_PCI to y.
> 
> One additional data point: When the EHCI and HCD parameters are set to y rather 
> than m as in the list that follows, the enumerate messages do not occur.
> 
> CONFIG_USB_ARCH_HAS_HCD=y
> CONFIG_USB_ARCH_HAS_EHCI=y
> CONFIG_USB_XHCI_HCD=y
> CONFIG_USB_EHCI_HCD=y
> CONFIG_USB_OHCI_HCD=y
> CONFIG_USB_EHCI_PCI=y
> # CONFIG_USB_OHCI_HCD_PLATFORM is not set
> # CONFIG_USB_EHCI_HCD_PLATFORM is not set
> CONFIG_USB_UHCI_HCD=y

This looks like a matter of getting modules to load in the right order.  
Apparently your OHCI controller doesn't work right if the EHCI driver
isn't present.  Before the troublesome commit, this meant ehci-hcd had
to be loaded before ohci-hcd.  Now it means ehci-hcd and ehci-pci both
have to be loaded before ohci-hcd.

In the dmesg log you provided, ehci-hcd was loaded before ohci-hcd but 
ehci-pci was loaded after.  Of course, when everything is built into 
the kernel (not as modules) then questions of loading order don't 
arise.

You can test this hypothesis by booting a kernel without that commit
and blacklisting ehci-hcd, so that it doesn't get loaded automatically.  
See if the errors start to come, and see if they stop when you load
ehci-hcd manually.

Alan Stern

