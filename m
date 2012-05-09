Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760617Ab2EIRpi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:45:38 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35046 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758551Ab2EIRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:45:36 -0400
Date: Wed, 9 May 2012 13:45:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: linux-usb@vger.kernel.org, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <plagnioj@jcrosoft.com>,
        <gregkh@linuxfoundation.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH] USB: ohci-at91: add a reset function to fix race condition
In-Reply-To: <1336553334-31058-1-git-send-email-nicolas.ferre@atmel.com>
Message-ID: <Pine.LNX.4.44L0.1205091344550.1658-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 May 2012, Nicolas Ferre wrote:

> A possible race condition appears because we are not initializing
> the ohci->regs before calling usb_hcd_request_irqs().
> We move the call to ohci_init() in hcd->driver->reset() instead of
> hcd->driver->start() to fix this.
> This was experienced when we share the same IRQ line between OHCI and EHCI
> controllers.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> Tested-by: Christian Eggers <christian.eggers@kathrein.de>
> Cc: stable <stable@vger.kernel.org>

Acked-by: Alan Stern <stern@rowland.harvard.edu>

> ---
>  drivers/usb/host/ohci-at91.c |   11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/usb/host/ohci-at91.c b/drivers/usb/host/ohci-at91.c
> index 13ebeca..55d3d64 100644
> --- a/drivers/usb/host/ohci-at91.c
> +++ b/drivers/usb/host/ohci-at91.c
> @@ -223,7 +223,7 @@ static void __devexit usb_hcd_at91_remove(struct usb_hcd *hcd,
>  /*-------------------------------------------------------------------------*/
>  
>  static int __devinit
> -ohci_at91_start (struct usb_hcd *hcd)
> +ohci_at91_reset (struct usb_hcd *hcd)
>  {
>  	struct at91_usbh_data	*board = hcd->self.controller->platform_data;
>  	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
> @@ -233,6 +233,14 @@ ohci_at91_start (struct usb_hcd *hcd)
>  		return ret;
>  
>  	ohci->num_ports = board->ports;
> +	return 0;
> +}
> +
> +static int __devinit
> +ohci_at91_start (struct usb_hcd *hcd)
> +{
> +	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
> +	int			ret;
>  
>  	if ((ret = ohci_run(ohci)) < 0) {
>  		err("can't start %s", hcd->self.bus_name);
> @@ -418,6 +426,7 @@ static const struct hc_driver ohci_at91_hc_driver = {
>  	/*
>  	 * basic lifecycle operations
>  	 */
> +	.reset =		ohci_at91_reset,
>  	.start =		ohci_at91_start,
>  	.stop =			ohci_stop,
>  	.shutdown =		ohci_shutdown,

