Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932704Ab0J2OG3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 10:06:29 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49528 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1761497Ab0J2OG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 10:06:28 -0400
Date: Fri, 29 Oct 2010 10:06:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: Greg KH <gregkh@suse.de>, <matthieu.castet@parrot.com>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Nguyen Dinh-R00091 <R00091@freescale.com>
Subject: Re: [PATCH] USB: ehci/mxc: compile fix
In-Reply-To: <1288337869-378-1-git-send-email-u.kleine-koenig@pengutronix.de>
Message-ID: <Pine.LNX.4.44L0.1010290956490.1588-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010, [UTF-8] Uwe Kleine-König wrote:

> 65fd42724aee31018b0bb53f4cb04971423be664 broke the build using
> ARM's mx51_defconfig:
> 
>  	  CC      drivers/usb/host/ehci-hcd.o
>  	In file included from drivers/usb/host/ehci-hcd.c:1166:
>  	drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
>  	drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first use in this function)
>  	drivers/usb/host/ehci-mxc.c:192: error: (Each undeclared identifier is reported only once
>  	drivers/usb/host/ehci-mxc.c:192: error: for each function it appears in.)
>  	drivers/usb/host/ehci-mxc.c:117: warning: unused variable 'temp'
>  	make[3]: *** [drivers/usb/host/ehci-hcd.o] Error 1
>  	make[2]: *** [drivers/usb/host/ehci-hcd.o] Error 2
>  	make[1]: *** [sub-make] Error 2
>  	make: *** [all] Error 2
> 
> Fix it together with the warnung about the unused variable.
> 
> Tested-by: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/usb/host/ehci-mxc.c |   13 ++++++++-----
>  1 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
> index ac9c4d7..70edb11 100644
> --- a/drivers/usb/host/ehci-mxc.c
> +++ b/drivers/usb/host/ehci-mxc.c
> @@ -36,6 +36,8 @@ struct ehci_mxc_priv {
>  static int ehci_mxc_setup(struct usb_hcd *hcd)
>  {
>  	struct ehci_hcd *ehci = hcd_to_ehci(hcd);
> +	struct device *dev = hcd->self.controller;
> +	struct mxc_usbh_platform_data *pdata = dev_get_platdata(dev);
>  	int retval;
>  
>  	/* EHCI registers start at offset 0x100 */
> @@ -64,6 +66,11 @@ static int ehci_mxc_setup(struct usb_hcd *hcd)
>  	ehci_reset(ehci);
>  
>  	ehci_port_power(ehci, 0);
> +
> +	/* set up the PORTSCx register */
> +	ehci_writel(ehci, pdata->portsc, &ehci->regs->port_status[0]);
> +	mdelay(10);

This mdelay really should be changed to msleep.  Also according to 
Matthieu, in ehci-fsl this is done before the ehci_port_power() call, 
not after, and there is no delay.  I don't know if this makes any 
difference.

Alan Stern

