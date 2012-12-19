Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab2LSNpC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 08:45:02 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:64901 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2LSNoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 08:44:54 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iGTRpDRcES862hcXL59DcG=GPEZ6B6r2jtw575P-8kCPw@mail.gmail.com>
References: <1355810167-18425-2-git-send-email-gautam.vivek@samsung.com>
	<1355838966-11269-1-git-send-email-gautam.vivek@samsung.com>
	<50D0F9EA.9090002@gmail.com>
	<CAFp+6iGTRpDRcES862hcXL59DcG=GPEZ6B6r2jtw575P-8kCPw@mail.gmail.com>
Date: Wed, 19 Dec 2012 19:14:51 +0530
Message-ID: <CAFp+6iFHzARtKD6Off7h7_0fcxx52rFoT2V8ucy_a2kTd4bf1w@mail.gmail.com>
Subject: Re: [PATCH v2] usb: phy: samsung: Add support to set pmu isolation
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: linux-usb@vger.kernel.org, dianders@chromium.org, l.majewski@samsung.com,
        linux-samsung-soc@vger.kernel.org, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, kyungmin.park@samsung.com,
        kgene.kim@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Wed, Dec 19, 2012 at 11:05 AM, Vivek Gautam
<gautamvivek1987@gmail.com> wrote:
> CC: Doug Anderson
>
>
> On Wed, Dec 19, 2012 at 4:49 AM, Sylwester Nawrocki
> <sylvester.nawrocki@gmail.com> wrote:
>> Hi Vivek,
>>
>>
>> On 12/18/2012 02:56 PM, Vivek Gautam wrote:
>>>
>>> Adding support to parse device node data in order to get
>>> required properties to set pmu isolation for usb-phy.
>>>
>>> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
>>> ---
>>>
>>> Changes from v1:
>>>   - Changed the name of property for phy handler from'samsung,usb-phyctrl'
>>>     to 'samsung,usb-phyhandle' to make it look more generic.
>>>   - Similarly 'samsung,phyctrl-reg' is changed to 'samsung,phyhandle-reg'
>>>   - Added a check for 'samsung,usb-phyhandle' before getting node from
>>>     phandle.
>>>   - Putting the node using 'of_node_put()' which had been missed.
>>>   - Adding necessary check for the pointer in
>>> 'samsung_usbphy_set_isolation()'
>>>     to avoid any NULL pointer dereferencing.
>>>   - Unmapping the register ioremapped in
>>> 'samsung_usbphy_parse_dt_param()'.
>>>
>>>
>>>   .../devicetree/bindings/usb/samsung-usbphy.txt     |   12 +++
>>>   drivers/usb/phy/samsung-usbphy.c                   |   94
>>> ++++++++++++++++++--
>>>   2 files changed, 98 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>>> b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>>> index 7b26e2d..a7b28b2 100644
>>> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>>> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>>> @@ -9,3 +9,15 @@ Required properties:
>>>   - compatible : should be "samsung,exynos4210-usbphy"
>>>   - reg : base physical address of the phy registers and length of memory
>>> mapped
>>>         region.
>>> +
>>> +Optional properties:
>>> +- samsung,usb-phyhandle : should point to usb-phyhandle sub-node which
>>> provides
>>> +                       binding data to enable/disable device PHY handled
>>> by
>>> +                       PMU register.
>>> +
>>> +                       Required properties:
>>> +                       - compatible : should be "samsung,usbdev-phyctrl"
>>> for
>>> +                                       DEVICE type phy.
>>> +                       - samsung,phyhandle-reg: base physical address of
>>> +                                               PHY_CONTROL register in
>>> PMU.
>>> +- samsung,enable-mask : should be '1'
>>
>>
>> This should only be 1 for Exynos4210+ SoCs, right ?

Yes that's true Exynso4210+ SoCs have only single PHY for both host and device
which gets enabled by single bit.

>> S5PV210 uses bit 0 for OTG and bit1 for USB host, doesn't it ? And for
>> s3c64xx
>> it seems to be bit 16.
>>
True, S5PV210 uses two bits separately for OTG and HOST, so in that
case we would
require to set both these bits. Thanks for pointing out !!

I couldn't see device tree support for S5PV210 and S3C64xx so thought
of going for
4210+ SoCs. Better we make this more generic so that once these SoCs
are moved to
device tree we don't face any issue. Right ??

>> How about deriving this information from 'compatible' property instead ?
>>

It will definitely be good to use the compatible property to derive
such information,
Need to amend the current approach.

>> Maybe you could just encode the USB PMU registers (I assume those aren't
>> touched by anything but the usb drivers) in a regular 'reg' property in
>> an usbphy subnode. Then the driver could interpret it also with help
>> of 'compatible' property. And you could just use of_iomap(). E.g.
>>
>>  usbphy@12130000 {
>>         compatible = "samsung,exynos5250-usbphy";
>>         reg = <0x12130000 0x100>, <0x12100000 0x100>;
>>         usbphy-pmu {
>>                 /* USB device and host PHY_CONTROL registers */
>>                 reg = <0x10040704 8>;
>>         };
>>  };
>>

This approach seems nice.

>> Your "samsung,usb-phyhandle" approach seems over-engineered to me.
>> I might be missing something though.
>>

The idea behind using phandles for usb-phy was to get the multiple
registers (2 in PMU
and 1 in SYSREG) and program them separately as required.

>>
>>> diff --git a/drivers/usb/phy/samsung-usbphy.c
>>> b/drivers/usb/phy/samsung-usbphy.c
>>> index 5c5e1bb5..4ceabe3 100644
>>> --- a/drivers/usb/phy/samsung-usbphy.c
>>> +++ b/drivers/usb/phy/samsung-usbphy.c
>>> @@ -72,6 +72,8 @@ enum samsung_cpu_type {
>>>    * @dev: The parent device supplied to the probe function
>>>    * @clk: usb phy clock
>>>    * @regs: usb phy register memory base
>>> + * @devctrl_reg: usb device phy-control pmu register memory base
>>
>>
>> hum, this name is not really helpful in understanding what's going
>> on here.
>>
>> Looking at arch/arm/mach-s5pv210/setup-usb-phy.c, there is only one
>> PHY_CONTROL (Power Management Unit) register for both OTG and USB host
>> PHYs. So are you really taking care of that case as well ?
>>
This doesn't take care of s3pv210. Will  amend this to ensure that.

>>
>>> + * @en_mask: enable mask
>>>    * @ref_clk_freq: reference clock frequency selection
>>>    * @cpu_type: machine identifier
>>>    */
>>> @@ -81,12 +83,73 @@ struct samsung_usbphy {
>>>         struct device   *dev;
>>>         struct clk      *clk;
>>>         void __iomem    *regs;
>>> +       void __iomem    *devctrl_reg;
>>> +       u32             en_mask;
>>>         int             ref_clk_freq;
>>>         int             cpu_type;
>>>   };
>>>
>>>   #define phy_to_sphy(x)                container_of((x), struct
>>> samsung_usbphy, phy)
>>>
>>> +static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
>>> +{
>>> +       struct device_node *usb_phyctrl;
>>> +       u32 reg;
>>> +       int lenp;
>>> +
>>> +       if (!sphy->dev->of_node) {
>>> +               sphy->devctrl_reg = NULL;
>>> +               return -ENODEV;
>>> +       }
>>> +
>>> +       if (of_get_property(sphy->dev->of_node,
>>> "samsung,usb-phyhandle",&lenp)) {
>>> +               usb_phyctrl = of_parse_phandle(sphy->dev->of_node,
>>> +                                               "samsung,usb-phyhandle",
>>> 0);
>>> +               if (!usb_phyctrl) {
>>> +                       dev_warn(sphy->dev, "Can't get usb-phy handle\n");
>>> +                       sphy->devctrl_reg = NULL;
>>> +               }
>>> +
>>> +               of_property_read_u32(usb_phyctrl,
>>> "samsung,phyhandle-reg",&reg);
>>> +
>>> +               sphy->devctrl_reg = ioremap(reg, SZ_4);
>>
>>
>> What happens if invalid address value is assigned to 'samsung,phyhandle-reg'
>> ?

Oops!! need to add an pointer check here.

>>
>>> +               of_property_read_u32(sphy->dev->of_node,
>>> "samsung,enable-mask",
>>> +                                                       &sphy->en_mask);
>>> +               of_node_put(usb_phyctrl);
>>> +       } else {
>>> +               dev_warn(sphy->dev, "Can't get usb-phy handle\n");
>>> +               sphy->devctrl_reg = NULL;
>>> +       }
>>> +
>>> +       return 0;
>>> +}
>>> +
>>> +/*
>>> + * Set isolation here for phy.
>>> + * SOCs control this by controlling corresponding PMU registers
>>> + */
>>> +static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int
>>> on)
>>> +{
>>> +       void __iomem *usb_phyctrl_reg;
>>> +       u32 en_mask = sphy->en_mask;
>>> +       u32 reg;
>>> +
>>> +       usb_phyctrl_reg = sphy->devctrl_reg;
>>> +
>>> +       if (!usb_phyctrl_reg) {
>>> +               dev_warn(sphy->dev, "Can't set pmu isolation\n");
>>> +               return;
>>> +       }
>>> +
>>> +       reg = readl(usb_phyctrl_reg);
>>> +
>>> +       if (on)
>>> +               writel(reg&  ~en_mask, usb_phyctrl_reg);
>>>
>>> +       else
>>> +               writel(reg | en_mask, usb_phyctrl_reg);
>>> +}
>>> +
>>>   /*
>>>    * Returns reference clock frequency selection value
>>>    */
>>> @@ -199,6 +262,8 @@ static int samsung_usbphy_init(struct usb_phy *phy)
>>>         /* Disable phy isolation */
>>>         if (sphy->plat&&  sphy->plat->pmu_isolation)
>>>
>>>                 sphy->plat->pmu_isolation(false);
>>> +       else
>>> +               samsung_usbphy_set_isolation(sphy, false);
>>>
>>>         /* Initialize usb phy registers */
>>>         samsung_usbphy_enable(sphy);
>>> @@ -228,6 +293,8 @@ static void samsung_usbphy_shutdown(struct usb_phy
>>> *phy)
>>>         /* Enable phy isolation */
>>>         if (sphy->plat&&  sphy->plat->pmu_isolation)
>>>
>>>                 sphy->plat->pmu_isolation(true);
>>> +       else
>>> +               samsung_usbphy_set_isolation(sphy, true);
>>>
>>>         clk_disable_unprepare(sphy->clk);
>>>   }
>>> @@ -249,17 +316,12 @@ static inline int
>>> samsung_usbphy_get_driver_data(struct platform_device *pdev)
>>>   static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
>>>   {
>>>         struct samsung_usbphy *sphy;
>>> -       struct samsung_usbphy_data *pdata;
>>> +       struct samsung_usbphy_data *pdata = pdev->dev.platform_data;
>>>         struct device *dev =&pdev->dev;
>>>
>>>         struct resource *phy_mem;
>>>         void __iomem    *phy_base;
>>>         struct clk *clk;
>>> -
>>> -       pdata = pdev->dev.platform_data;
>>> -       if (!pdata) {
>>> -               dev_err(&pdev->dev, "%s: no platform data defined\n",
>>> __func__);
>>> -               return -EINVAL;
>>> -       }
>>> +       int ret;
>>>
>>>         phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>>         if (!phy_mem) {
>>> @@ -283,7 +345,20 @@ static int __devinit samsung_usbphy_probe(struct
>>> platform_device *pdev)
>>>                 return PTR_ERR(clk);
>>>         }
>>>
>>> -       sphy->dev               =&pdev->dev;
>>> +       sphy->dev =&pdev->dev;
>>
>>
>>         sphy->dev = dev;
>>
Right, will amend this.

>>
>>> +
>>> +       ret = samsung_usbphy_parse_dt_param(sphy);
>>> +       if (ret) {
>>> +               /* fallback to pdata */
>>> +               if (!pdata) {
>>> +                       dev_err(&pdev->dev,
>>> +                               "%s: no device data found\n", __func__);
>>
>>
>> I find term "device data" a bit confusing here.
>>
>>> +                       return -ENODEV;
>>
>>
>> In the original code -EINVAL was returned when platform_data was not set.
>>
>>
>>> +               } else {
>>> +                       sphy->plat = pdata;
>>> +               }
>>> +       }
>>> +
>>
>>
>> How about rewriting this to:
>>
>>         if (dev->of_node) {
>>                 ret = samsung_usbphy_parse_dt_param(sphy);
>>                 if (ret < 0)
>>                         return ret;
>>         } else {
>>                 if (!pdata) {
>>                         dev_err(dev, "no platform data specified\n");
>>                         return -EINVAL;
>>                 }
>>         }
>>
>> This way we won't be obfuscating any error code returned from the
>> OF parsing function.
>>
Sure, will amend this.

>>
>>>         sphy->plat              = pdata;
>>>         sphy->regs              = phy_base;
>>>         sphy->clk               = clk;
>>> @@ -305,6 +380,9 @@ static int __exit samsung_usbphy_remove(struct
>>> platform_device *pdev)
>>>
>>>         usb_remove_phy(&sphy->phy);
>>>
>>> +       if (sphy->devctrl_reg)
>>> +               iounmap(sphy->devctrl_reg);
>>> +
>>>         return 0;
>>>   }
>>
>>
>> --
>>
>> Regards,
>> Sylwester
>>
>> _______________________________________________
>> devicetree-discuss mailing list
>> devicetree-discuss@lists.ozlabs.org
>> https://lists.ozlabs.org/listinfo/devicetree-discuss
>
>
>
> --
> Thanks & Regards
> Vivek



-- 
Thanks & Regards
Vivek
