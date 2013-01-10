Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609Ab3AJIsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 03:48:19 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47595 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab3AJIsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 03:48:18 -0500
MIME-Version: 1.0
In-Reply-To: <50EDE438.6040805@gmail.com>
References: <CAFp+6iEUNjZewY1b3T-eCHeiZrouxYGPXtxHuNvJdi+UEKTNjg@mail.gmail.com>
	<1356686018-18586-1-git-send-email-gautam.vivek@samsung.com>
	<50EDE438.6040805@gmail.com>
Date: Thu, 10 Jan 2013 14:18:15 +0530
Message-ID: <CAFp+6iEdYTt155BXDj2pZjgnD5PQBhz=nnT54QbuvfuHq2CyKQ@mail.gmail.com>
Subject: Re: [PATCH v5] usb: phy: samsung: Add support to set pmu isolation
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Thu, Jan 10, 2013 at 3:12 AM, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> Hi,
>
>
> On 12/28/2012 10:13 AM, Vivek Gautam wrote:
>>
>> Adding support to parse device node data in order to get
>> required properties to set pmu isolation for usb-phy.
>>
>> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
>
> ...
>
>> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
>> @@ -9,3 +9,38 @@ Required properties:
>>   - compatible : should be "samsung,exynos4210-usbphy"
>>   - reg : base physical address of the phy registers and length of memory
>> mapped
>>   region.
>> +
>> +Optional properties:
>> +- #address-cells: should be '1' when usbphy node has a child node with
>> 'reg'
>> +  property.
>> +- #size-cells: should be '1' when usbphy node has a child node with 'reg'
>> +       property.
>> +- ranges: allows valid translation between child's address space and
>> parent's
>> +  address space.
>> +
>> +- The child node 'usbphy-sys' to the node 'usbphy' is for the system
>> controller
>> +  interface for usb-phy. It should provide the following information
>> required by
>> +  usb-phy controller to control phy.
>> +   - reg : base physical address of PHY control register in PMU which
>> +           enables/disables the phy controller.
>
>
> On some SoCs USB_PHY_CONTROL registers don't belong to PMU. So maybe you
> should
> drop references to PMU, or list all SoC entities where USB_PHY_CONTROL
> appears:
> PMU, "MISC REGISTER", etc.
>

On S3C64XX "USB_SIG_MASK" bit is in "OTHERS" register, which is actually part of
system controller register map (clock controller + PM controller), and
then S5P64XX onward
this falls under PM controller's memory map. So, i thought of using
reference to PMU.
May be i am missing something here ?
Will change this if you suggest.

> I would just rephrase this to:
>
>     - reg : base physical address of PHY_CONTROL registers
>
> "phy controller" might be confusing, since PHY CONTROLLER is an entity
> separate
> from PHY 0 and PHY 1 ?
>
Ok, will change this as suggested.

>
>> +           The size of this register is the total sum of size of all
>> phy-control
>
>
> And what about using PHY_CONTROL name as per the User Manuals ? That would
> perhaps make it a bit easier to follow.
>
Sure this is better. We can use PHY_CONTROL to align with user manuals and avoid
any confusions.

>
>> +           registers that the SoC has. For example, the size will be
>> +           '0x4' in case we have only one phy-control register (like in
>> S3C64XX) or
>> +           '0x8' in case we have two phy-control registers (like in
>> Exynos4210)
>> +           and so on.
>> +
>> +Example:
>> + - Exynos4210
>> +
>> + usbphy@125B0000 {
>> + #address-cells =<1>;
>> + #size-cells =<1>;
>> + compatible = "samsung,exynos4210-usbphy";
>> + reg =<0x125B0000 0x100>;
>> + ranges;
>> +
>> + usbphy-sys {
>> + /* USB device and host PHY_CONTROL registers */
>> + reg =<0x10020704 0x8>;
>> + };
>> + };
>
> ...
>
>>   /*
>> + * struct samsung_usbphy_drvdata - driver data for various SoC variants
>> + * @cpu_type: machine identifier
>> + * @devphy_en_mask: device phy enable mask for PHY CONTROL register
>> + * @pmureg_devphy_offset: offset to DEVICE PHY CONTROL register from
>> + *  mapped address of system controller.
>> + *
>> + * Here we have a separate mask for device type phy.
>> + * Having different masks for host and device type phy helps
>> + * in setting independent masks in case of SoCs like S5PV210,
>> + * in which PHY0 and PHY1 enable bits belong to same register
>> + * placed at position 0 and 1 respectively.
>> + * Although for newer SoCs like exynos these bits belong to
>> + * different registers altogether placed at position 0.
>> + */
>> +struct samsung_usbphy_drvdata {
>> + int cpu_type;
>> + int devphy_en_mask;
>> + u32 pmureg_devphy_offset;
>
>
> Perhaps just "devphy_reg_offset" would do ?
>
Sure, will amend this as suggested.

>
>> +};
>> +
>> +/*
>>    * struct samsung_usbphy - transceiver driver state
>>    * @phy: transceiver structure
>>    * @plat: platform data
>>    * @dev: The parent device supplied to the probe function
>>    * @clk: usb phy clock
>>    * @regs: usb phy register memory base
>
>
> Is this more precisely:
>
>       * @regs: usb phy controller registers memory base
>
> ?
this had been a part of Praveen's work submitted for initial
samsung-usbphy driver,
so didn't change anything in that. ;-)
Will amend this as suggested.

>>
>> + * @pmureg: usb device phy-control pmu register memory base
>
>
> Maybe something like this would be more clear:
>
> @pmureg: USB device PHY_CONTROL registers memory region base
>
Sure, will amend this.

> Note, that not on all SoCs USB_PHY_CONTROL registers belong to PMU.
> Haven't you considered changing "pmureg" to ctrl_regs or something
> else more generic ?
>
Same as mentioned in above comment in this context  for PMU register.
Thought this could be self-explanatory for pmu interface to control phy.
Will change this if you suggest.

>
>>    * @ref_clk_freq: reference clock frequency selection
>> - * @cpu_type: machine identifier
>> + * @drv_data: driver data available for different SoCs
>>    */
>>   struct samsung_usbphy {
>>   struct usb_phy phy;
>> @@ -81,12 +107,63 @@ struct samsung_usbphy {
>>   struct device *dev;
>>   struct clk *clk;
>>   void __iomem *regs;
>> + void __iomem *pmureg;
>>   int ref_clk_freq;
>> - int cpu_type;
>> + const struct samsung_usbphy_drvdata *drv_data;
>>   };
>
> ...
>
>> +/*
>> + * Set isolation here for phy.
>> + * SOCs control this by controlling corresponding PMU registers
>
>
> Hmm, it's not always PMU registers. I would remove this sentence and
> instead explain what's the meaning of 'on' argument, so it is clear
> the PHY is deactivated when on != 0.
>

Ditto for PMU register comment,
Will put an explanation for 'on' argument.

>
>> + */
>> +static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int
>> on)
>> +{
>> + static DEFINE_SPINLOCK(lock);
>
>
> You probably don't need a global spinlock. Couldn't the spinlock be added
> as struct samsung_usbhy field instead ?
>
True, will add a spinlock in the samsung_usbphy structure.

>
>> + unsigned long flags;
>> + void __iomem *reg;
>> + u32 reg_val;
>> + u32 en_mask;
>> +
>> + if (!sphy->pmureg) {
>> + dev_warn(sphy->dev, "Can't set pmu isolation\n");
>> + return;
>> + }
>> +
>> + reg = sphy->pmureg + sphy->drv_data->pmureg_devphy_offset;
>> + en_mask = sphy->drv_data->devphy_en_mask;
>> +
>> + spin_lock_irqsave(&lock, flags);
>> +
>> + reg_val = readl(reg);
>> + reg_val = on ? (reg_val&  ~en_mask) : (reg_val | en_mask);
>
>
> Might be a good idea to use in this case plain if/else instead..
>
ok, will amend this.


-- 
Thanks & Regards
Vivek
