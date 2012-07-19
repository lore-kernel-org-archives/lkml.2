Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab2GSNVp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 09:21:45 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58427 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991Ab2GSNVn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 09:21:43 -0400
From: "Gupta, Ajay Kumar" <ajay.gupta@ti.com>
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "rob@landley.net" <rob@landley.net>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Balbi, Felipe" <balbi@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH v4 09/11] drivers: usb: musb: Add device tree support
 for omap musb glue
Thread-Topic: [PATCH v4 09/11] drivers: usb: musb: Add device tree support
 for omap musb glue
Thread-Index: AQHNZNJnbvWBgnigMUa6eJ0iyXL7N5cwmHFQ
Date: Thu, 19 Jul 2012 13:21:12 +0000
Message-ID: <47CEF8C4B26E8C44B22B028A650E0EA93EADE11A@DBDE01.ent.ti.com>
References: <1342607922-11554-1-git-send-email-kishon@ti.com>
 <1342607922-11554-10-git-send-email-kishon@ti.com>
In-Reply-To: <1342607922-11554-10-git-send-email-kishon@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.227]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/omap-usb.txt |   34 ++++++++++++-
>  drivers/usb/musb/omap2430.c                        |   55
> ++++++++++++++++++++
>  2 files changed, 88 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/usb/omap-usb.txt
> b/Documentation/devicetree/bindings/usb/omap-usb.txt
> index 80a28c9..39cdffb 100644
> --- a/Documentation/devicetree/bindings/usb/omap-usb.txt
> +++ b/Documentation/devicetree/bindings/usb/omap-usb.txt
> @@ -1,4 +1,4 @@
> -OMAP USB PHY
> +OMAP USB PHY AND GLUE
> 
>  OMAP USB2 PHY
> 
> @@ -14,3 +14,35 @@ usb2phy@0x4a0ad080 {
>  	compatible = "ti,omap-usb2";
>  	reg = <0x4a0ad080 0x58>;
>  };
> +
> +OMAP MUSB GLUE
> + - compatible : Should be "ti,musb-omap2430"
> + - ti,hwmods : must be "usb_otg_hs"
> + - multipoint : Should be "1" indicating the musb controller supports
> +   multipoint. This is a MUSB configuration-specific setting.
> + - num_eps : Specifies the number of endpoints. This is also a
> +   MUSB configuration-specific setting. Should be set to "16"
> + - ram_bits : Specifies the ram address size. Should be set to "12"
> + - interface_type : This is a board specific setting to describe the type
> of
> +   interface between the controller and the phy. It should be "0" or "1"
> +   specifying ULPI and UTMI respectively.
> + - mode : Should be "3" to represent OTG. "1" signifies HOST and "2"
> +   represents PERIPHERAL.
> + - power : Should be "50". This signifies the controller can supply upto
> +   100mA when operating in host mode.
> +
> +SOC specific device node entry
> +usb_otg_hs: usb_otg_hs@4a0ab000 {
> +	compatible = "ti,musb-omap2430";
> +	ti,hwmods = "usb_otg_hs";
> +	multipoint = <1>;
> +	num_eps = <16>;
> +	ram_bits = <12>;
> +};
> +
> +Board specific device node entry
> +&usb_otg_hs {
> +	interface_type = <1>;
> +	mode = <3>;
> +	power = <50>;
> +};
> diff --git a/drivers/usb/musb/omap2430.c b/drivers/usb/musb/omap2430.c
> index addbebf..331e477 100644
> --- a/drivers/usb/musb/omap2430.c
> +++ b/drivers/usb/musb/omap2430.c
> @@ -30,6 +30,7 @@
>  #include <linux/init.h>
>  #include <linux/list.h>
>  #include <linux/io.h>
> +#include <linux/of.h>
>  #include <linux/platform_device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/pm_runtime.h>
> @@ -469,8 +470,11 @@ static u64 omap2430_dmamask = DMA_BIT_MASK(32);
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
> @@ -500,6 +504,43 @@ static int __devinit omap2430_probe(struct
> platform_device *pdev)
>  	if (glue->control_otghs == NULL)
>  		dev_dbg(&pdev->dev, "Failed to obtain control memory\n");
> 
> +	if (np) {
> +		pdata = devm_kzalloc(&pdev->dev, sizeof(*pdata), GFP_KERNEL);
> +		if (!pdata) {
> +			dev_err(&pdev->dev,
> +				"failed to allocate musb platfrom data\n");
> +			ret = -ENOMEM;
> +			goto err1;
> +		}
> +
> +		data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
> +		if (!data) {
> +			dev_err(&pdev->dev,
> +					"failed to allocate musb board data\n");
> +			ret = -ENOMEM;
> +			goto err1;
> +		}
> +
> +		config = devm_kzalloc(&pdev->dev, sizeof(*config), GFP_KERNEL);
> +		if (!data) {
> +			dev_err(&pdev->dev,
> +				"failed to allocate musb hdrc config\n");
> +			goto err1;
> +		}
> +
> +		of_property_read_u32(np, "mode", (u32 *)&pdata->mode);
> +		of_property_read_u32(np, "interface_type",
> +						(u32 *)&data->interface_type);
> +		of_property_read_u32(np, "num_eps", (u32 *)&config->num_eps);
> +		of_property_read_u32(np, "ram_bits", (u32 *)&config->ram_bits);
> +		of_property_read_u32(np, "mode", (u32 *)&pdata->mode);

pdata->mode is already read so above should be removed.

Ajay
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
> @@ -597,12 +638,26 @@ static struct dev_pm_ops omap2430_pm_ops = {
>  #define DEV_PM_OPS	NULL
>  #endif
> 
> +#ifdef CONFIG_OF
> +static const struct of_device_id omap2430_id_table[] = {
> +	{
> +		.compatible = "ti,omap4-musb"
> +	},
> +	{
> +		.compatible = "ti,omap3-musb"
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, omap2430_id_table);
> +#endif
> +
>  static struct platform_driver omap2430_driver = {
>  	.probe		= omap2430_probe,
>  	.remove		= __devexit_p(omap2430_remove),
>  	.driver		= {
>  		.name	= "musb-omap2430",
>  		.pm	= DEV_PM_OPS,
> +		.of_match_table = of_match_ptr(omap2430_id_table),
>  	},
>  };
> 
> --
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
