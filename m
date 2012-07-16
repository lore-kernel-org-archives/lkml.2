Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab2GPOKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:10:07 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41512 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753772Ab2GPOKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:10:03 -0400
Date: Mon, 16 Jul 2012 10:10:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Vivek Gautam <gautam.vivek@samsung.com>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <l.majewski@samsung.com>,
        <a.kesavan@samsung.com>, <prashanth.g@samsung.com>,
        <kmpark@infradead.org>, <joshi@samsung.com>, <olofj@google.com>,
        <jg1.han@samsung.com>, <jy0922.shim@samsung.com>,
        <thomas.abraham@linaro.org>, <sshtylyov@mvista.com>
Subject: Re: [PATCH 3/3 v3] USB: ehci-s5p: Add vbus setup function to the
 s5p ehci glue layer
In-Reply-To: <1342418138-6192-4-git-send-email-gautam.vivek@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1207161008520.1660-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Vivek Gautam wrote:

> This patch retrieves and configures the vbus control gpio via
> the device tree. The suspend/resume callbacks will be later
> modified for vbus control.
> 
> Signed-off-by: Abhilash Kesavan <a.kesavan@samsung.com>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> 
> diff --git a/drivers/usb/host/ehci-s5p.c b/drivers/usb/host/ehci-s5p.c
> index 37d84cf..4037878 100644
> --- a/drivers/usb/host/ehci-s5p.c
> +++ b/drivers/usb/host/ehci-s5p.c
> @@ -15,6 +15,7 @@
>  #include <linux/clk.h>
>  #include <linux/of.h>
>  #include <linux/platform_device.h>
> +#include <linux/of_gpio.h>
>  #include <plat/ehci.h>
>  #include <plat/usb-phy.h>
>  
> @@ -64,6 +65,28 @@ static const struct hc_driver s5p_ehci_hc_driver = {
>  	.clear_tt_buffer_complete	= ehci_clear_tt_buffer_complete,
>  };
>  
> +static int s5p_ehci_setup_gpio(struct platform_device *pdev)
> +{
> +	int err;
> +	int gpio;
> +
> +	if (!pdev->dev.of_node)
> +		return 0;
> +
> +	gpio = of_get_named_gpio(pdev->dev.of_node,
> +			"samsung,vbus-gpio", 0);
> +	if (!gpio_is_valid(gpio))
> +		return 0;
> +
> +	err = gpio_request_one(gpio, GPIOF_OUT_INIT_HIGH, "ehci_vbus_gpio");
> +	if (err) {
> +		dev_err(&pdev->dev, "can't request ehci vbus gpio %d", gpio);
> +		return err;

This "return" statement is unnecessary.

> +	}
> +
> +	return err;
> +}
> +
>  static u64 ehci_s5p_dma_mask = DMA_BIT_MASK(32);
>  
>  static int __devinit s5p_ehci_probe(struct platform_device *pdev)
> @@ -92,6 +115,8 @@ static int __devinit s5p_ehci_probe(struct platform_device *pdev)
>  	if (!pdev->dev.coherent_dma_mask)
>  		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
>  
> +	s5p_ehci_setup_gpio(pdev);

Why does the function return an error code if that error code is just 
going to be ignored?

Alan Stern

