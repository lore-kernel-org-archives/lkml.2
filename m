Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702Ab2GJF63 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 01:58:29 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:51846 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753420Ab2GJF61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 01:58:27 -0400
Message-ID: <4FFBC478.4060308@ti.com>
Date: Tue, 10 Jul 2012 11:28:16 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Subject: Re: [PATCH v1 05/11] drivers: usb: twl6030: Add dt support for twl6030
 usb
References: <1340884267-28908-1-git-send-email-kishon@ti.com> <1340884267-28908-6-git-send-email-kishon@ti.com>
In-Reply-To: <1340884267-28908-6-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 28 June 2012 05:21 PM, Kishon Vijay Abraham I wrote:
> Add device tree support for twl6030 usb driver.
> Update the Documentation with device tree binding information.
>
> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
> ---
>   .../devicetree/bindings/usb/twlxxxx-usb.txt        |   18 ++++++++
>   drivers/usb/otg/twl6030-usb.c                      |   45 ++++++++++++++------
>   2 files changed, 50 insertions(+), 13 deletions(-)
>   create mode 100644 Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
>
> diff --git a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
> new file mode 100644
> index 0000000..f293271
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
> @@ -0,0 +1,18 @@
> +USB COMPARATOR OF TWL CHIPS
> +
> +TWL6030 USB COMPARATOR
> + - compatible : Should be "ti,twl6030-usb"
> + - interrupts : Two interrupt numbers to the cpu should be specified. First
> +   interrupt number is the otg interrupt number that raises ID interrupts when
> +   the controller has to act as host and the second interrupt number is the
> +   usb interrupt number that raises VBUS interrupts when the controller has to
> +   act as device
> + - regulator :<supply-name>  can be "vusb" or "ldousb"
> + -<supply-name>-supply : phandle to the regulator device tree node
> +
> +twl6030-usb {
> +	compatible = "ti,twl6030-usb";
> +	interrupts =<  4 10>;
> +	regulator = "vusb";
> +	vusb-supply =<&vusb>;

This doesn't seem right. Why do you ned a 'regulator' string along
with the phandle?

> +};
> diff --git a/drivers/usb/otg/twl6030-usb.c b/drivers/usb/otg/twl6030-usb.c
> index 6a361d2..20b7abe 100644
> --- a/drivers/usb/otg/twl6030-usb.c
> +++ b/drivers/usb/otg/twl6030-usb.c
> @@ -105,7 +105,7 @@ struct twl6030_usb {
>   	u8			asleep;
>   	bool			irq_enabled;
>   	bool			vbus_enable;
> -	unsigned long		features;
> +	const char		*regulator;
>   };
>
>   #define	comparator_to_twl(x) container_of((x), struct twl6030_usb, comparator)
> @@ -153,13 +153,6 @@ static int twl6030_start_srp(struct phy_companion *comparator)
>
>   static int twl6030_usb_ldo_init(struct twl6030_usb *twl)
>   {
> -	char *regulator_name;
> -
> -	if (twl->features&  TWL6025_SUBCLASS)
> -		regulator_name = "ldousb";
> -	else
> -		regulator_name = "vusb";
> -
>   	/* Set to OTG_REV 1.3 and turn on the ID_WAKEUP_COMP */
>   	twl6030_writeb(twl, TWL6030_MODULE_ID0 , 0x1, TWL6030_BACKUP_REG);
>
> @@ -169,7 +162,7 @@ static int twl6030_usb_ldo_init(struct twl6030_usb *twl)
>   	/* Program MISC2 register and set bit VUSB_IN_VBAT */
>   	twl6030_writeb(twl, TWL6030_MODULE_ID0 , 0x10, TWL6030_MISC2);
>
> -	twl->usb3v3 = regulator_get(twl->dev, regulator_name);
> +	twl->usb3v3 = regulator_get(twl->dev, twl->regulator);
>   	if (IS_ERR(twl->usb3v3))
>   		return -ENODEV;
>
> @@ -324,9 +317,9 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
>   {
>   	struct twl6030_usb	*twl;
>   	int			status, err;
> -	struct twl4030_usb_data *pdata;
> -	struct device *dev =&pdev->dev;
> -	pdata = dev->platform_data;
> +	struct device_node	*np = pdev->dev.of_node;
> +	struct device		*dev =&pdev->dev;
> +	struct twl4030_usb_data	*pdata = dev->platform_data;
>
>   	twl = devm_kzalloc(dev, sizeof *twl, GFP_KERNEL);
>   	if (!twl)
> @@ -335,13 +328,28 @@ static int __devinit twl6030_usb_probe(struct platform_device *pdev)
>   	twl->dev		=&pdev->dev;
>   	twl->irq1		= platform_get_irq(pdev, 0);
>   	twl->irq2		= platform_get_irq(pdev, 1);
> -	twl->features		= pdata->features;
>   	twl->linkstat		= OMAP_MUSB_UNKNOWN;
>
>   	twl->comparator.set_vbus	= twl6030_set_vbus;
>   	twl->comparator.start_srp	= twl6030_start_srp;
>   	omap_usb2_set_comparator(&twl->comparator);
>
> +	if (np) {
> +		err = of_property_read_string(np, "regulator",&twl->regulator);
> +		if (err<  0) {
> +			dev_err(&pdev->dev, "unable to get regulator\n");
> +			return err;
> +		}

Isn't there a better way for the driver to know which supply to use 
instead of DT passing the supply name?

regards,
Rajendra

> +	} else if (pdata) {
> +		if (pdata->features&  TWL6025_SUBCLASS)
> +			twl->regulator = "ldousb";
> +		else
> +			twl->regulator = "vusb";
> +	} else {
> +		dev_err(&pdev->dev, "twl6030 initialized without pdata\n");
> +		return -EINVAL;
> +	}
> +
>   	/* init spinlock for workqueue */
>   	spin_lock_init(&twl->lock);
>
> @@ -403,12 +411,23 @@ static int __exit twl6030_usb_remove(struct platform_device *pdev)
>   	return 0;
>   }
>
> +#ifdef CONFIG_OF
> +static const struct of_device_id twl6030_usb_id_table[] = {
> +	{ .compatible = "ti,twl6030-usb" },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, twl6030_usb_id_table);
> +#else
> +#define twl6030_usb_id_table NULL
> +#endif
> +
>   static struct platform_driver twl6030_usb_driver = {
>   	.probe		= twl6030_usb_probe,
>   	.remove		= __exit_p(twl6030_usb_remove),
>   	.driver		= {
>   		.name	= "twl6030_usb",
>   		.owner	= THIS_MODULE,
> +		.of_match_table = twl6030_usb_id_table,
>   	},
>   };
>

