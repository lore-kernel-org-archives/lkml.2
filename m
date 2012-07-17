Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949Ab2GQEyg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 00:54:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:60939 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2GQEye (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 00:54:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="167237366"
Date: Mon, 16 Jul 2012 21:54:16 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Denis Turischev <denis@compulab.co.il>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] xhci: EHCI/xHCI ports switching on Intense-PC.
Message-ID: <20120717045416.GJ7599@xanatos>
References: <5004454E.9030903@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5004454E.9030903@compulab.co.il>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 07:46:06PM +0300, Denis Turischev wrote:
> Intense-PC is Compulab's mini-desktop with Intel Panther Point
> chipset.
> 
> Unconditional ports switching provided by function
> usb_enable_xhci_ports() leads to surprising results, after shutdown
> system powered-on again after a few seconds. On Windows power
> related problems were not observed.

Do you have wake on lan enabled in the BIOS?  I have heard reports from
other users that this is a BIOS bug triggered by WOL.

> The patch avoids ports switching for Intense-PC.
> 
> Signed-off-by: Denis Turischev <denis@compulab.co.il>
> ---
>  drivers/usb/host/pci-quirks.c |    7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
> index df0828c..6f72593 100644
> --- a/drivers/usb/host/pci-quirks.c
> +++ b/drivers/usb/host/pci-quirks.c
> @@ -759,6 +759,13 @@ void usb_enable_xhci_ports(struct pci_dev *xhci_pdev)
>  {
>  	u32		ports_available;
> 
> +	const char *brd_name;
> +	brd_name = dmi_get_system_info(DMI_BOARD_NAME);
> +
> +	/* quirk for Compulab's Intense-PC board */
> +	if (brd_name && strstr(brd_name, "Intense-PC"))
> +		return;
> +

No, this fix is not acceptable.  You won't get USB 3.0 speeds if the
ports are not switched over.  Now, we can add a quirk to the xHCI
shutdown function to switch the ports back to EHCI on shutdown.  That
might not trigger the BIOS bug.

Sarah Sharp
