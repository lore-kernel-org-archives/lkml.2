Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757122Ab3AHSmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 13:42:17 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:39169 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab3AHSmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 13:42:15 -0500
Message-ID: <50EC7440.20203@mvista.com>
Date: Tue, 08 Jan 2013 22:32:16 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: balbi@ti.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        rob@landley.net, linux@arm.linux.org.uk, gregkh@linuxfoundation.org,
        b-cousson@ti.com, rnayak@ti.com, tony@atomide.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 3/3] usb: musb: omap: Add device tree support for omap
 musb glue
References: <1347354580-5895-1-git-send-email-kishon@ti.com> <1347354580-5895-4-git-send-email-kishon@ti.com>
In-Reply-To: <1347354580-5895-4-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/11/2012 01:09 PM, Kishon Vijay Abraham I wrote:

> Added device tree support for omap musb driver and updated the
> Documentation with device tree binding information.

> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

   Belated comments to the patch which didn't pass my message size filter in
time. :-)

> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index f4d9503..d96873b 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
[...]
> @@ -470,8 +471,11 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
>  static int __devinit omap2430_probe(struct platform_device *pdev)
>  {
>  	struct musb_hdrc_platform_data	*pdata = pdev->dev.platform_data;
> +	struct omap_musb_board_data	*data;
>  	struct platform_device		*musb;
>  	struct omap2430_glue		*glue;
> +	struct device_node		*np = pdev->dev.of_node;
> +	struct musb_hdrc_config		*config;
>  	struct resource			*res;
>  	int				ret = -ENOMEM;
>  
> @@ -501,6 +505,42 @@ static int __devinit omap2430_probe(struct platform_device *pdev)
>  	if (glue->control_otghs == NULL)
>  		dev_dbg(&pdev->dev, "Failed to obtain control memory\n");
>  
> +	if (np) {
> +		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			dev_err(&pdev->dev,
> +				"failed to allocate musb platfrom data\n");
> +			ret = -ENOMEM;

   'ret' is pre-initialized to -ENOMEM.

> +			goto err1;
> +		}
> +
> +		data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +		if (!data) {
> +			dev_err(&pdev->dev,
> +					"failed to allocate musb board data\n");

   Overindented this line.

> +			ret = -ENOMEM;

   Same comment about already pre-initialized variable.

> +			goto err1;
> +		}
> +
> +		config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
> +		if (!data) {

   You allocate 'config' but check 'data' again, so instead of exiting
gracefully we get an oops later on...

> +			dev_err(&pdev->dev,
> +				"failed to allocate musb hdrc config\n");

   No 'ret = -ENOMEM;' here -- kinda inconsistent. :-)

> +			goto err1;
> +		}
> +
> +		of_property_read_u32(np, "mode", (u32 *)&pdata->mode);
> +		of_property_read_u32(np, "interface_type",
> +						(u32 *)&data->interface_type);
> +		of_property_read_u32(np, "num_eps", (u32 *)&config->num_eps);
> +		of_property_read_u32(np, "ram_bits", (u32 *)&config->ram_bits);
> +		of_property_read_u32(np, "power", (u32 *)&pdata->power);
> +		config->multipoint = of_property_read_bool(np, "multipoint");
> +
> +		pdata->board_data	= data;
> +		pdata->config		= config;
> +	}
> +
>  	pdata->platform_ops		= &omap2430_ops;
>  
>  	platform_set_drvdata(pdev, glue);

   Don't worry now, I've just sent two patches to address these shortcomings.

WBR, Sergei


