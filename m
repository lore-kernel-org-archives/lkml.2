Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754015Ab2GJGxA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 02:53:00 -0400
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:36231 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753558Ab2GJGw6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 02:52:58 -0400
MIME-Version: 1.0
In-Reply-To: <4FFBC56F.7080007@ti.com>
References: <1340884267-28908-1-git-send-email-kishon@ti.com>
	<1340884267-28908-8-git-send-email-kishon@ti.com>
	<4FFBC56F.7080007@ti.com>
Date: Tue, 10 Jul 2012 12:22:57 +0530
Message-ID: <CAAe_U6JhMWzsZ_XZzO0gt=g9fufL-urCLEC0nWfa8vk-9x6F_w@mail.gmail.com>
Subject: Re: [PATCH v1 07/11] drivers: usb: twl4030: Add device tree support
 for twl4030 usb
From: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
To: Rajendra Nayak <rnayak@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org, hvaibhav@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 10, 2012 at 11:32 AM, Rajendra Nayak <rnayak@ti.com> wrote:
> On Thursday 28 June 2012 05:21 PM, Kishon Vijay Abraham I wrote:
>>
>> Add device tree support for twl6030 usb driver.
>
>
> twl4030?
My bad. Will fix it.
>
>
>> Update the Documentation with device tree binding information.
>>
>> Signed-off-by: Kishon Vijay Abraham I<kishon@ti.com>
>> ---
>>   .../devicetree/bindings/usb/twlxxxx-usb.txt        |   19 +++++++++++++
>>   drivers/usb/otg/twl4030-usb.c                      |   28
>> +++++++++++++++----
>>   2 files changed, 41 insertions(+), 6 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
>> b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
>> index f293271..2d069e4 100644
>> --- a/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
>> +++ b/Documentation/devicetree/bindings/usb/twlxxxx-usb.txt
>> @@ -16,3 +16,22 @@ twl6030-usb {
>>         regulator = "vusb";
>>         vusb-supply =<&vusb>;
>>   };
>> +
>> +TWL4030 USB PHY AND COMPARATOR
>> + - compatible : Should be "ti,twl4030-usb"
>> + - interrupts : The interrupt numbers to the cpu should be specified.
>> First
>> +   interrupt number is the otg interrupt number that raises ID interrupts
>> +   and VBUS interrupts. The second interrupt number is optional.
>> + -<supply-name>-supply : phandle to the regulator device tree node.
>> +<supply-name>  should be vusb1v5, vusb1v8 and vusb3v1
>> + - usb_mode : The mode used by the phy to connect to the controller. "1"
>> +   specifies "ULPI" mode and "2" specifies "CEA2011_3PIN" mode.
>
>
> Are these standard usb phy modes or something specific to the twl4030
> usb phy?

These are standard modes used to connect the phy to the controller. I
think it's used by other chips other than twl4030 (Something in
am35xx??).
>
>> +
>> +twl4030-usb {
>> +       compatible = "ti,twl4030-usb";
>> +       interrupts =<  10 4>;
>> +       vusb1v5-supply =<&vusb1v5>;
>> +       vusb1v8-supply =<&vusb1v8>;
>> +       vusb3v1-supply =<&vusb3v1>;
>> +       usb_mode =<1>;
>> +};
>> diff --git a/drivers/usb/otg/twl4030-usb.c b/drivers/usb/otg/twl4030-usb.c
>> index 523cad5..a4e7434 100644
>> --- a/drivers/usb/otg/twl4030-usb.c
>> +++ b/drivers/usb/otg/twl4030-usb.c
>> @@ -585,23 +585,28 @@ static int __devinit twl4030_usb_probe(struct
>> platform_device *pdev)
>>         struct twl4030_usb      *twl;
>>         int                     status, err;
>>         struct usb_otg          *otg;
>> -
>> -       if (!pdata) {
>> -               dev_dbg(&pdev->dev, "platform_data not available\n");
>> -               return -EINVAL;
>> -       }
>> +       struct device_node      *np = pdev->dev.of_node;
>>
>>         twl = devm_kzalloc(&pdev->dev, sizeof *twl, GFP_KERNEL);
>>         if (!twl)
>>                 return -ENOMEM;
>>
>> +       if (np)
>> +               of_property_read_u32(np, "usb_mode",
>> +                               (enum twl4030_usb_mode *)&twl->usb_mode);
>> +       else if (pdata)
>> +               twl->usb_mode = pdata->usb_mode;
>> +       else {
>> +               dev_err(&pdev->dev, "twl4030 initialized without
>> pdata\n");
>> +               return -EINVAL;
>> +       }
>> +
>>         otg = devm_kzalloc(&pdev->dev, sizeof *otg, GFP_KERNEL);
>>         if (!otg)
>>                 return -ENOMEM;
>>
>>         twl->dev                =&pdev->dev;
>>
>>         twl->irq                = platform_get_irq(pdev, 0);
>> -       twl->usb_mode           = pdata->usb_mode;
>>         twl->vbus_supplied      = false;
>>         twl->asleep             = 1;
>>         twl->linkstat           = OMAP_MUSB_UNKNOWN;
>> @@ -690,12 +695,23 @@ static int __exit twl4030_usb_remove(struct
>> platform_device *pdev)
>>         return 0;
>>   }
>>
>> +#ifdef CONFIG_OF
>> +static const struct of_device_id twl4030_usb_id_table[] = {
>> +       { .compatible = "ti,twl4030-usb" },
>> +       {}
>> +};
>> +MODULE_DEVICE_TABLE(of, twl4030_usb_id_table);
>> +#else
>> +#define twl4030_usb_id_table NULL
>> +#endif
>> +
>>   static struct platform_driver twl4030_usb_driver = {
>>         .probe          = twl4030_usb_probe,
>>         .remove         = __exit_p(twl4030_usb_remove),
>>         .driver         = {
>>                 .name   = "twl4030_usb",
>>                 .owner  = THIS_MODULE,
>> +               .of_match_table = twl4030_usb_id_table,
>
>
> use of_match_ptr().

Ok. Will change it that way.

Thanks
Kishon
