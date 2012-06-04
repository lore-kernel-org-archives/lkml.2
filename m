Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960Ab2FDO3f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 10:29:35 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35846 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754662Ab2FDO3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 10:29:33 -0400
Date: Mon, 4 Jun 2012 10:29:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland Stigge <stigge@antcom.de>
cc: gregkh@linuxfoundation.org, <grant.likely@secretlab.ca>,
        <rob.herring@calxeda.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <kevin.wells@nxp.com>, <srinivas.bakki@nxp.com>
Subject: Re: [PATCH] ohci-nxp: Use ohci_finish_controller_resume()
In-Reply-To: <1338747893-29338-1-git-send-email-stigge@antcom.de>
Message-ID: <Pine.LNX.4.44L0.1206041027420.1555-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 3 Jun 2012, Roland Stigge wrote:

> OHCI drivers are supposed to use ohci_finish_controller_resume(). This patch
> adds respective suspend and resume code to ohci-nxp. The following compiler
> warning is fixed this way:
> 
> drivers/usb/host/ohci-hub.c:321: warning: 'ohci_finish_controller_resume'
> defined but not used

This is not a correct description of the patch.  A correct description 
would be something like:

	Add suspend/resume support to the ohci-nxp driver.

The compiler warning needs a completely different fix; 
ohci_finish_controller_resume should be given a __maybe_unused 
annotation.

Alan Stern

> Signed-off-by: Roland Stigge <stigge@antcom.de>
> 
> ---
> Applies to v3.5-rc1
> 
>  drivers/usb/host/ohci-nxp.c |   21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> --- linux-2.6.orig/drivers/usb/host/ohci-nxp.c
> +++ linux-2.6/drivers/usb/host/ohci-nxp.c
> @@ -432,6 +432,23 @@ static int usb_hcd_nxp_remove(struct pla
>  	return 0;
>  }
>  
> +#ifdef CONFIG_PM
> +static int usb_hcd_suspend(struct platform_device *pdev, pm_message_t message)
> +{
> +	clk_disable(usb_clk);
> +	return 0;
> +}
> +
> +static int usb_hcd_resume(struct platform_device *pdev)
> +{
> +	struct usb_hcd *hcd = platform_get_drvdata(pdev);
> +
> +	clk_enable(usb_clk);
> +	ohci_finish_controller_resume(hcd);
> +	return 0;
> +}
> +#endif
> +
>  /* work with hotplug and coldplug */
>  MODULE_ALIAS("platform:usb-ohci");
>  
> @@ -451,5 +468,9 @@ static struct platform_driver usb_hcd_nx
>  	},
>  	.probe = usb_hcd_nxp_probe,
>  	.remove = usb_hcd_nxp_remove,
> +#ifdef CONFIG_PM
> +	.suspend = usb_hcd_suspend,
> +	.resume = usb_hcd_resume,
> +#endif
>  };

