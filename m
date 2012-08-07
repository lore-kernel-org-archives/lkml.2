Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab2HGRfh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 13:35:37 -0400
Received: from mga11.intel.com ([192.55.52.93]:45924 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755499Ab2HGRfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 13:35:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="204234916"
Date: Tue, 7 Aug 2012 10:35:32 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] xhci: EHCI/XHCI ports switching on Intense-PC.
Message-ID: <20120807173532.GD10298@xanatos>
References: <5004454E.9030903@compulab.co.il>
 <20120717045416.GJ7599@xanatos>
 <50065E5A.2040103@compulab.co.il>
 <20120718165916.GA30828@xanatos>
 <500D3998.7010705@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500D3998.7010705@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Denis,

I found a couple issues with your second patch.  There are non-PCI xHCI
host controllers, so we can't assume the xHCI host is a PCI host.  So
this code can't run in the generic xHCI shutdown method:

>  void xhci_shutdown(struct usb_hcd *hcd)
>  {
> +	struct pci_dev *pdev;
> +	const char *brd_name;
>  	struct xhci_hcd *xhci = hcd_to_xhci(hcd);
> 
> +	pdev = to_pci_dev(hcd->self.controller);
> +
> +	if (usb_is_intel_switchable_xhci(pdev)) {
> +		brd_name = dmi_get_system_info(DMI_BOARD_NAME);
> +
> +		/* quirk for Compulab's Intense-PC board */
> +		if (brd_name && strstr(brd_name, "Intense-PC"))
> +			usb_disable_xhci_ports(pdev);
> +	}
> +
>  	spin_lock_irq(&xhci->lock);
>  	xhci_halt(xhci);
>  	spin_unlock_irq(&xhci->lock);

I think the to_pci_dev call will oops if this isn't a PCI host.  Plus,
I've found out from the BIOS and chipset folks that this quirk needs to
be more broadly applied.  I'll send you a revised patch.  Can you test
it and make sure it works for you?

Sarah Sharp
