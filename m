Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab2GRQ7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:59:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:36198 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754996Ab2GRQ7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:59:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="173788735"
Date: Wed, 18 Jul 2012 09:59:16 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xhci: EHCI/xHCI ports switching on Intense-PC.
Message-ID: <20120718165916.GA30828@xanatos>
References: <5004454E.9030903@compulab.co.il>
 <20120717045416.GJ7599@xanatos>
 <50065E5A.2040103@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50065E5A.2040103@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 09:57:30AM +0300, Denis Turischev wrote:
> On 07/17/2012 07:54 AM, Sarah Sharp wrote:
> > On Mon, Jul 16, 2012 at 07:46:06PM +0300, Denis Turischev wrote:
> >> Intense-PC is Compulab's mini-desktop with Intel Panther Point
> >> chipset.
> >>
> >> Unconditional ports switching provided by function
> >> usb_enable_xhci_ports() leads to surprising results, after shutdown
> >> system powered-on again after a few seconds. On Windows power
> >> related problems were not observed.
> > 
> > Do you have wake on lan enabled in the BIOS?  I have heard reports from
> > other users that this is a BIOS bug triggered by WOL.
> 
> Bug appears with WOL disabled too, moreover, it appears with PCH LAN
> disabled at all in the BIOS.

Hmm, ok, not the same bug then.

> > No, this fix is not acceptable.  You won't get USB 3.0 speeds if the
> > ports are not switched over.  Now, we can add a quirk to the xHCI
> > shutdown function to switch the ports back to EHCI on shutdown.  That
> > might not trigger the BIOS bug.
> 
> Yes, switching back to EHCI in xhci_shutdown() solves the problem.

Ok, good to know.

The other thing to try would be to turn off all "wake on" bits in the
port status registers in xhci_shutdown().  That might cause the xHCI
host to stop generating spurious PMEs.

It would actually be good to check that the xHCI host is the cause of
the PME that reboots the system.  I'm pretty sure there's a sysfs or
proc file that shows where the PMEs are coming from, but I can't
remember where it is off the top of my head.

> I suppose to do something like this in xhci_shutdown:
> 	pdev = to_pci_dev(hcd->self.controller);
> 
> 	if (usb_is_intel_switchable_xhci(pdev)){
> 		brd_name = dmi_get_system_info(DMI_BOARD_NAME);
> 
> 		/* quirk for Compulab's Intense-PC board */
> 		if (brd_name && strstr(brd_name, "Intense-PC"))
> 			usb_disable_xhci_ports(pdev);
> 	}
> 
> Is it ok?
> 
> May be it worth to disable xhci ports for all intel switchable
> devices, not only for Intense-PC?

I'm not sure.  I'm still talking with our hardware and BIOS team to
determine which boards have this issue.  I suspect it's more than just
your board.

The only thing I wonder is if the PCI quirks will run when the xHCI
driver is reloaded.  If not, the ports will never be switched back to
xHCI.

We might need to add a port switch back to xHCI in the xhci_init
function.  That means if someone unloads the xHCI driver and reloads it,
their devices will appear under EHCI, and then disconnect and switch
over to xHCI.

However, I suppose that's the same as what happens if you unload the
EHCI driver on a system with an OHCI or UHCI companion controller.  So I
think it should be OK to attempt to switchover the ports in xhci_init.

Sarah Sharp
