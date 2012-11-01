Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762152Ab2KAScV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 14:32:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49186 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762114Ab2KAScR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 14:32:17 -0400
Date: Thu, 1 Nov 2012 14:32:15 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vincent Palatin <vpalatin@chromium.org>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Olof Johansson <olofj@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        "Arjun.K.V" <arjun.kv@samsung.com>,
        Vikas Sajjan <vikas.sajjan@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>
Subject: Re: [PATCH] USB: ohci-exynos: initialize registers pointer earlier
In-Reply-To: <1351793128-19564-1-git-send-email-vpalatin@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1211011431050.1762-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Nov 2012, Vincent Palatin wrote:

> In the former code, we have a race condition between the first interrupt
> and the regs field initilization in the usb_hcd structure.
> If the OHCI irq fires before hcd->regs is set, we are getting a null
> pointer dereference in ohci_irq.
> 
> When calling usb_add_hcd(), it first executes the reset() callback,
> then enables the ohci interrupt, and finally executes the start()
> callback. So moving the ohci_init() call which actually initializes the
> reg field from start() to reset() should remove the race.
> 
> Tested by enabling the external HSIC hub in the bootloader on an exynos5
> machine and booting. With the former code, this triggers an early interrupt
> about 50% of the boots and a subsequent kernel panic in ohci_irq when trying
> to access the registers.
> 
> Cc: Olof Johansson <olofj@chromium.org>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Arjun.K.V <arjun.kv@samsung.com>
> Cc: Vikas Sajjan <vikas.sajjan@samsung.com>
> Cc: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vincent Palatin <vpalatin@chromium.org>
> ---
>  drivers/usb/host/ohci-exynos.c |   10 ++++++----
>  1 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-exynos.c
> index 20a5008..f04cfde 100644
> --- a/drivers/usb/host/ohci-exynos.c
> +++ b/drivers/usb/host/ohci-exynos.c
> @@ -23,6 +23,11 @@ struct exynos_ohci_hcd {
>  	struct clk *clk;
>  };
>  
> +static int ohci_exynos_reset(struct usb_hcd *hcd)
> +{
> +	return ohci_init(hcd_to_ohci(hcd));
> +}
> +
>  static int ohci_exynos_start(struct usb_hcd *hcd)
>  {
>  	struct ohci_hcd *ohci = hcd_to_ohci(hcd);
> @@ -30,10 +35,6 @@ static int ohci_exynos_start(struct usb_hcd *hcd)
>  
>  	ohci_dbg(ohci, "ohci_exynos_start, ohci:%p", ohci);
>  
> -	ret = ohci_init(ohci);
> -	if (ret < 0)
> -		return ret;
> -
>  	ret = ohci_run(ohci);
>  	if (ret < 0) {
>  		dev_err(hcd->self.controller, "can't start %s\n",
> @@ -53,6 +54,7 @@ static const struct hc_driver exynos_ohci_hc_driver = {
>  	.irq			= ohci_irq,
>  	.flags			= HCD_MEMORY|HCD_USB11,
>  
> +	.reset			= ohci_exynos_reset,
>  	.start			= ohci_exynos_start,
>  	.stop			= ohci_stop,
>  	.shutdown		= ohci_shutdown,

Quite right; every host controller driver must have a .reset routine.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

