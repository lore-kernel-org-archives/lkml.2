Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669Ab2L0MBI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 07:01:08 -0500
Received: from mail-la0-f52.google.com ([209.85.215.52]:49888 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752196Ab2L0MBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 07:01:05 -0500
MIME-Version: 1.0
In-Reply-To: <50DB7A83.3010508@gmail.com>
References: <1356524912-4736-1-git-send-email-gautam.vivek@samsung.com>
	<1356524912-4736-2-git-send-email-gautam.vivek@samsung.com>
	<50DB7A83.3010508@gmail.com>
Date: Thu, 27 Dec 2012 17:31:02 +0530
Message-ID: <CAFp+6iEUNjZewY1b3T-eCHeiZrouxYGPXtxHuNvJdi+UEKTNjg@mail.gmail.com>
Subject: Re: [PATCH v4] usb: phy: samsung: Add support to set pmu isolation
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, l.majewski@samsung.com,
        linux-samsung-soc@vger.kernel.org, p.paneri@samsung.com,
        gregkh@linuxfoundation.org, devicetree-discuss@lists.ozlabs.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, balbi@ti.com,
        kyungmin.park@samsung.com, kgene.kim@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Thu, Dec 27, 2012 at 4:00 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> On 12/26/2012 01:28 PM, Vivek Gautam wrote:
>>
>> Adding support to parse device node data in order to get
>> required properties to set pmu isolation for usb-phy.
>>
>> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
>> ---
>>   .../devicetree/bindings/usb/samsung-usbphy.txt     |   31 ++++
>>   drivers/usb/phy/samsung-usbphy.c                   |  145
>> +++++++++++++++++---
>>   2 files changed, 155 insertions(+), 21 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> index 7b26e2d..6b873fd 100644
>> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> @@ -9,3 +9,34 @@ Required properties:
>>   - compatible : should be "samsung,exynos4210-usbphy"
>>   - reg : base physical address of the phy registers and length of memory
>> mapped
>>         region.
>> +
>> +Optional properties:
>> +- #address-cells: should be '1' when usbphy node has a child node with
>> 'reg'
>> +                 property.
>> +- #size-cells: should be '1' when usbphy node has a child node with 'reg'
>> +              property.
>> +
>> +- The child node 'usbphy-pmu' to the node usbphy should provide the
>> following
>> +  information required by usb-phy controller to enable/disable the phy.
>> +   - reg : base physical address of PHY control register in PMU which
>> +           enables/disables the phy controller.
>> +           The size of this register is the total sum of size of all
>> phy-control
>> +           registers that the SoC has. For example, the size will be
>> +           '0x4' in case we have only one phy-control register (like in
>> S3C64XX) or
>> +           '0x8' in case we have two phy-control registers (like in
>> Exynos4210)
>> +           and so on.
>> +
>> +Example:
>> + - Exysno4210
>
>
> s/Exysno/Exynos
>
Sure will amend this.
>
>> +
>> +       usbphy@125B0000 {
>> +               #address-cells =<1>;
>> +               #size-cells =<1>;
>> +               compatible = "samsung,exynos4210-usbphy";
>> +               reg =<0x125B0000 0x100>;
>> +
>> +               usbphy-pmu {
>> +                       /* USB device and host PHY_CONTROL registers */
>> +                       reg =<0x10020704 0x8>;
>> +               };
>> +       };
>> diff --git a/drivers/usb/phy/samsung-usbphy.c
>> b/drivers/usb/phy/samsung-usbphy.c
>> index 5c5e1bb5..b9f4f42 100644
>> --- a/drivers/usb/phy/samsung-usbphy.c
>> +++ b/drivers/usb/phy/samsung-usbphy.c
>> @@ -60,20 +60,42 @@
>>   #define MHZ (1000*1000)
>>   #endif
>>
>> +#define S3C64XX_USBPHY_ENABLE                  (0x1<<  16)
>> +#define EXYNOS_USBPHY_ENABLE                   (0x1<<  0)
>> +
>>   enum samsung_cpu_type {
>>         TYPE_S3C64XX,
>>         TYPE_EXYNOS4210,
>>   };
>>
>>   /*
>> + * struct samsung_usbphy_drvdata - driver data for various SoC variants
>> + * @cpu_type: machine identifier
>> + * @devphy_en_mask: device phy enable mask for PHY CONTROL register
>> + *
>> + *     Here we have a separate mask for device type phy.
>> + *     Having different masks for host and device type phy helps
>> + *     in setting independent masks in case of SoCs like S5PV210,
>> + *     in which PHY0 and PHY1 enable bits belong to same register
>> + *     placed at [0] and [1] respectively.
>
>
> "and are placed at positions 0 and 1 respectively" ?
>
Ok, will change this.
>
>> + *     Although for newer SoCs like exynos these bits belong to
>> + *     different registers altogether placed at [0].
>> + */
>> +struct samsung_usbphy_drvdata {
>> +       int cpu_type;
>> +       int devphy_en_mask;
>> +};
>> +
>> +/*
>>    * struct samsung_usbphy - transceiver driver state
>>    * @phy: transceiver structure
>>    * @plat: platform data
>>    * @dev: The parent device supplied to the probe function
>>    * @clk: usb phy clock
>>    * @regs: usb phy register memory base
>> + * @phyctrl_pmureg: usb device phy-control pmu register memory base
>
>
> nit: Perhaps we could just call it "pmureg' ?
>
Sure we can use the name 'pmureg'.
>
>>    * @ref_clk_freq: reference clock frequency selection
>> - * @cpu_type: machine identifier
>> + * @drv_data: driver data available for different cpu types
>
>
> Actually it's for different SoCs, not CPUs, right ?
>
Right, will change this.

>
>>    */
>>   struct samsung_usbphy {
>>         struct usb_phy  phy;
>> @@ -81,12 +103,67 @@ struct samsung_usbphy {
>>         struct device   *dev;
>>         struct clk      *clk;
>>         void __iomem    *regs;
>> +       void __iomem    *phyctrl_pmureg;
>>         int             ref_clk_freq;
>> -       int             cpu_type;
>> +       const struct samsung_usbphy_drvdata *drv_data;
>>   };
>>
>>   #define phy_to_sphy(x)                container_of((x), struct
>> samsung_usbphy, phy)
>>
>> +static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
>
>
> nit: s/samsung_usbphy_parse_dt_param/samsung_usbphy_parse_dt ?
>
Ok, will change this.
>
>> +{
>> +       struct device_node *usbphy_pmu;
>> +       u32 reg[2];
>> +       int ret;
>> +
>> +       if (!sphy->dev->of_node) {
>> +               dev_err(sphy->dev, "Can't get usb-phy node\n");
>> +               return -ENODEV;
>
>
> The function is called only when dev->of_node is not NULL, so this path
> is never executed, AFAICS. I would just drop this redundant check.
>
Yes, thanks for pointing out. I missed that. Will remove this check.

>
>> +       }
>> +
>> +       usbphy_pmu = of_get_child_by_name(sphy->dev->of_node,
>> "usbphy-pmu");
>> +       if (!usbphy_pmu)
>> +               dev_warn(sphy->dev, "Can't get usb-phy pmu control
>> node\n");
>
>
>> +       ret = of_property_read_u32_array(usbphy_pmu, "reg", reg,
>>
>> +                                               ARRAY_SIZE(reg));
>> +       if (!ret)
>> +               sphy->phyctrl_pmureg = ioremap(reg[0], reg[1]);
>
>
> I don't think this is correct. reg is not really an array of u32 type,
> it's an array of address/size tuples. I thought you would use of_iomap()
> here. Any reason why you didn't do so ? It would also make it easier to
> handle multiple address/size pairs if required.
>
True we should in fact be using of_iomap. Will change this accordingly.

>
>> +
>> +       of_node_put(usbphy_pmu);
>> +
>> +       if (IS_ERR_OR_NULL(sphy->phyctrl_pmureg)) {
>
>
> When is sphy->phyctrl_pmureg assigned a ERR_PTR() value ? Wouldn't it
> be enough to simply check for NULL ?
>
Yes, true no error returned here, will check this against NULL.

>
>> +               dev_err(sphy->dev, "Can't get usb-phy pmu control
>> register\n");
>> +               return -ENODEV;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Set isolation here for phy.
>> + * SOCs control this by controlling corresponding PMU registers
>> + */
>> +static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int
>> on)
>> +{
>> +       u32 reg;
>> +       int en_mask;
>> +
>> +       if (!sphy->phyctrl_pmureg) {
>> +               dev_warn(sphy->dev, "Can't set pmu isolation\n");
>> +               return;
>> +       }
>> +
>> +       reg = readl(sphy->phyctrl_pmureg);
>
>
> To make it more generic maybe it's worth to store an offset to the actual
> register somewhere, e.g. in the driver_data struct ? This function is
> supposed to handle both device and host PHYs, isn't it ?
>
True we can make put an offset for host and device PHYs.
So we iomap the memory base address of the first register (i.e. device
PHY in exynos4210),
and then use an offset for other register (i.e.host PHY). Right?

>> +       en_mask = sphy->drv_data->devphy_en_mask;
>> +
>> +       if (on)
>> +               writel(reg&  ~en_mask, sphy->phyctrl_pmureg);
>>
>> +       else
>> +               writel(reg | en_mask, sphy->phyctrl_pmureg);
>
>
> nit: This could be also written as:
>
>         reg = on ? reg & ~mask : reg | mask;
>         writel(reg, sphy->phyctrl_pmureg);

Sure will amend this.


-- 
Thanks & Regards
Vivek
