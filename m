Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933350Ab3AIVmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:42:25 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:55781 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159Ab3AIVmW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:42:22 -0500
Message-ID: <50EDE438.6040805@gmail.com>
Date: Wed, 09 Jan 2013 22:42:16 +0100
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux@arm.linux.org.uk,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, t.figa@samsung.com, ben-linux@fluff.org,
        broonie@opensource.wolfsonmicro.com, l.majewski@samsung.com,
        kyungmin.park@samsung.com, grant.likely@secretlab.ca, heiko@sntech.de,
        dianders@chromium.org, p.paneri@samsung.com
Subject: Re: [PATCH v5] usb: phy: samsung: Add support to set pmu isolation
References: <CAFp+6iEUNjZewY1b3T-eCHeiZrouxYGPXtxHuNvJdi+UEKTNjg@mail.gmail.com> <1356686018-18586-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1356686018-18586-1-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 12/28/2012 10:13 AM, Vivek Gautam wrote:
> Adding support to parse device node data in order to get
> required properties to set pmu isolation for usb-phy.
>
> Signed-off-by: Vivek Gautam<gautam.vivek@samsung.com>
...
> --- a/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/usb/samsung-usbphy.txt
> @@ -9,3 +9,38 @@ Required properties:
>   - compatible : should be "samsung,exynos4210-usbphy"
>   - reg : base physical address of the phy registers and length of memory mapped
>   region.
> +
> +Optional properties:
> +- #address-cells: should be '1' when usbphy node has a child node with 'reg'
> +  property.
> +- #size-cells: should be '1' when usbphy node has a child node with 'reg'
> +       property.
> +- ranges: allows valid translation between child's address space and parent's
> +  address space.
> +
> +- The child node 'usbphy-sys' to the node 'usbphy' is for the system controller
> +  interface for usb-phy. It should provide the following information required by
> +  usb-phy controller to control phy.
> +   - reg : base physical address of PHY control register in PMU which
> +           enables/disables the phy controller.

On some SoCs USB_PHY_CONTROL registers don't belong to PMU. So maybe you 
should
drop references to PMU, or list all SoC entities where USB_PHY_CONTROL 
appears:
PMU, "MISC REGISTER", etc.

I would just rephrase this to:

     - reg : base physical address of PHY_CONTROL registers

"phy controller" might be confusing, since PHY CONTROLLER is an entity 
separate
from PHY 0 and PHY 1 ?

> +           The size of this register is the total sum of size of all phy-control

And what about using PHY_CONTROL name as per the User Manuals ? That would
perhaps make it a bit easier to follow.

> +           registers that the SoC has. For example, the size will be
> +           '0x4' in case we have only one phy-control register (like in S3C64XX) or
> +           '0x8' in case we have two phy-control registers (like in Exynos4210)
> +           and so on.
> +
> +Example:
> + - Exynos4210
> +
> + usbphy@125B0000 {
> + #address-cells =<1>;
> + #size-cells =<1>;
> + compatible = "samsung,exynos4210-usbphy";
> + reg =<0x125B0000 0x100>;
> + ranges;
> +
> + usbphy-sys {
> + /* USB device and host PHY_CONTROL registers */
> + reg =<0x10020704 0x8>;
> + };
> + };
...
>   /*
> + * struct samsung_usbphy_drvdata - driver data for various SoC variants
> + * @cpu_type: machine identifier
> + * @devphy_en_mask: device phy enable mask for PHY CONTROL register
> + * @pmureg_devphy_offset: offset to DEVICE PHY CONTROL register from
> + *  mapped address of system controller.
> + *
> + * Here we have a separate mask for device type phy.
> + * Having different masks for host and device type phy helps
> + * in setting independent masks in case of SoCs like S5PV210,
> + * in which PHY0 and PHY1 enable bits belong to same register
> + * placed at position 0 and 1 respectively.
> + * Although for newer SoCs like exynos these bits belong to
> + * different registers altogether placed at position 0.
> + */
> +struct samsung_usbphy_drvdata {
> + int cpu_type;
> + int devphy_en_mask;
> + u32 pmureg_devphy_offset;

Perhaps just "devphy_reg_offset" would do ?

> +};
> +
> +/*
>    * struct samsung_usbphy - transceiver driver state
>    * @phy: transceiver structure
>    * @plat: platform data
>    * @dev: The parent device supplied to the probe function
>    * @clk: usb phy clock
>    * @regs: usb phy register memory base

Is this more precisely:

       * @regs: usb phy controller registers memory base
?
> + * @pmureg: usb device phy-control pmu register memory base

Maybe something like this would be more clear:

@pmureg: USB device PHY_CONTROL registers memory region base

Note, that not on all SoCs USB_PHY_CONTROL registers belong to PMU.
Haven't you considered changing "pmureg" to ctrl_regs or something
else more generic ?

>    * @ref_clk_freq: reference clock frequency selection
> - * @cpu_type: machine identifier
> + * @drv_data: driver data available for different SoCs
>    */
>   struct samsung_usbphy {
>   struct usb_phy phy;
> @@ -81,12 +107,63 @@ struct samsung_usbphy {
>   struct device *dev;
>   struct clk *clk;
>   void __iomem *regs;
> + void __iomem *pmureg;
>   int ref_clk_freq;
> - int cpu_type;
> + const struct samsung_usbphy_drvdata *drv_data;
>   };
...
> +/*
> + * Set isolation here for phy.
> + * SOCs control this by controlling corresponding PMU registers

Hmm, it's not always PMU registers. I would remove this sentence and
instead explain what's the meaning of 'on' argument, so it is clear
the PHY is deactivated when on != 0.

> + */
> +static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int on)
> +{
> + static DEFINE_SPINLOCK(lock);

You probably don't need a global spinlock. Couldn't the spinlock be added
as struct samsung_usbhy field instead ?

> + unsigned long flags;
> + void __iomem *reg;
> + u32 reg_val;
> + u32 en_mask;
> +
> + if (!sphy->pmureg) {
> + dev_warn(sphy->dev, "Can't set pmu isolation\n");
> + return;
> + }
> +
> + reg = sphy->pmureg + sphy->drv_data->pmureg_devphy_offset;
> + en_mask = sphy->drv_data->devphy_en_mask;
> +
> + spin_lock_irqsave(&lock, flags);
> +
> + reg_val = readl(reg);
> + reg_val = on ? (reg_val&  ~en_mask) : (reg_val | en_mask);

Might be a good idea to use in this case plain if/else instead..

> + writel(reg_val, reg);
> +
> + spin_unlock_irqrestore(&lock, flags);
> +}

Thanks,
Sylwester
