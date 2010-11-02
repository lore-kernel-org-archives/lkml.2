Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab0KBOFC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Nov 2010 10:05:02 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:20667 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751977Ab0KBOE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Nov 2010 10:04:56 -0400
X-SpamScore: -19
X-BigFish: VS-19(zz542N1432N9371Pzz1202hzz8275bh1497iz2dh2a8h61h)
X-Spam-TCS-SCL: 0:0
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Subject: RE: [PATCH] USB: ehci/mxc: compile fix
Date: Tue, 2 Nov 2010 07:05:27 -0700
Message-ID: <86A0E76937111F4C92FABEC0A20988510523CBC9@az33exm21>
In-Reply-To: <1288690257-16801-1-git-send-email-u.kleine-koenig@pengutronix.de>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] USB: ehci/mxc: compile fix
Thread-Index: Act6cNJpdfdJmKJlRhuGckQ2rNFLhgAJh1KA
References: <Pine.LNX.4.44L0.1010290956490.1588-100000@iolanthe.rowland.org> <1288690257-16801-1-git-send-email-u.kleine-koenig@pengutronix.de>
From: Nguyen Dinh-R00091 <R00091@freescale.com>
To: =?utf-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg KH <gregkh@suse.de>
CC: <kernel@pengutronix.de>, Sergei Shtylyov <sshtylyov@mvista.com>,
        <matthieu.castet@parrot.com>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>
X-Reverse-DNS: de01egw02.freescale.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oA2E5IIk018138

Hi Uwe,

> -----Original Message-----
> From: Uwe Kleine-KÃ¶nig [mailto:u.kleine-koenig@pengutronix.de]
> Sent: Tuesday, November 02, 2010 4:31 AM
> To: Greg KH
> Cc: kernel@pengutronix.de; Sergei Shtylyov; matthieu.castet@parrot.com;
> linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org; Nguyen Dinh-
> R00091; Nguyen Dinh-R00091; Alan Stern
> Subject: [PATCH] USB: ehci/mxc: compile fix
> 
> Commit
> 	65fd427 (USB: ehci tdi : let's tdi_reset set host mode)
> 
> broke the build using ARM's mx51_defconfig:
> 
>  	  CC      drivers/usb/host/ehci-hcd.o
>  	In file included from drivers/usb/host/ehci-hcd.c:1166:
>  	drivers/usb/host/ehci-mxc.c: In function 'ehci_mxc_drv_probe':
>  	drivers/usb/host/ehci-mxc.c:192: error: 'ehci' undeclared (first
> use in this function)
>  	drivers/usb/host/ehci-mxc.c:192: error: (Each undeclared identifier
> is reported only once
>  	drivers/usb/host/ehci-mxc.c:192: error: for each function it
> appears in.)
>  	drivers/usb/host/ehci-mxc.c:117: warning: unused variable 'temp'
>  	make[3]: *** [drivers/usb/host/ehci-hcd.o] Error 1
>  	make[2]: *** [drivers/usb/host/ehci-hcd.o] Error 2
>  	make[1]: *** [sub-make] Error 2
>  	make: *** [all] Error 2
> 
> Fix it together with the warning about the unused variable and use
> msleep instead of mdelay as requested by Alan Stern.
> 
> Cc: Dinh Nguyen <Dinh.Nguyen@freescale.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Signed-off-by: Uwe Kleine-KÃ¶nig <u.kleine-koenig@pengutronix.de>
> ---
> Hello,
> 
> I currently have no hardware to test it, so I only verified it to
> compile.
> 
> Dinh: I changed your Tested-by to Cc for the new patch, do you care to
> retest?

Retested - check!

> 
> Best regards
> Uwe
> ---
>  drivers/usb/host/ehci-mxc.c |   14 +++++++++-----
>  1 files changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
> index ac9c4d7..bce8505 100644
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
> @@ -63,6 +65,12 @@ static int ehci_mxc_setup(struct usb_hcd *hcd)
> 
>  	ehci_reset(ehci);
> 
> +	/* set up the PORTSCx register */
> +	ehci_writel(ehci, pdata->portsc, &ehci->regs->port_status[0]);
> +
> +	/* is this really needed? */
> +	msleep(10);
> +
>  	ehci_port_power(ehci, 0);
>  	return 0;
>  }
> @@ -114,7 +122,7 @@ static int ehci_mxc_drv_probe(struct platform_device
> *pdev)
>  	struct mxc_usbh_platform_data *pdata = pdev->dev.platform_data;
>  	struct usb_hcd *hcd;
>  	struct resource *res;
> -	int irq, ret, temp;
> +	int irq, ret;
>  	struct ehci_mxc_priv *priv;
>  	struct device *dev = &pdev->dev;
> 
> @@ -188,10 +196,6 @@ static int ehci_mxc_drv_probe(struct platform_device
> *pdev)
>  		clk_enable(priv->ahbclk);
>  	}
> 
> -	/* set up the PORTSCx register */
> -	ehci_writel(ehci, pdata->portsc, &ehci->regs->port_status[0]);
> -	mdelay(10);
> -
>  	/* setup specific usb hw */
>  	ret = mxc_initialize_usb_hw(pdev->id, pdata->flags);
>  	if (ret < 0)
> --
> 1.7.2.3
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
