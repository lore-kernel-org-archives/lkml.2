Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab2LUKoM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 05:44:12 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:37138 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab2LUKoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 05:44:08 -0500
MIME-Version: 1.0
In-Reply-To: <20121219075550.GD5228@arwen.pp.htv.fi>
References: <1355843426-13613-1-git-send-email-gautam.vivek@samsung.com>
	<1355843426-13613-2-git-send-email-gautam.vivek@samsung.com>
	<20121218151349.GC32437@arwen.pp.htv.fi>
	<CAFp+6iHQMDuwPd08KwPyxE_eXyofv_31-Azr0F9+LS2E9aY52w@mail.gmail.com>
	<CAFp+6iFk_eXaJidfL-PBhB6haJnmovVw3AwG5p6kJ-U+R2jFzA@mail.gmail.com>
	<20121219075550.GD5228@arwen.pp.htv.fi>
Date: Fri, 21 Dec 2012 16:14:05 +0530
Message-ID: <CAFp+6iEE8=Zv2FUrLZfwn1XpBygaQRZX=XJ13fq5a0uOhRF8-w@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung: Add support for USB 3.0 phy for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, dianders@chromium.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        kgene.kim@samsung.com, thomas.abraham@linaro.org,
        rob.herring@calxeda.com, grant.likely@secretlab.ca,
        sylvester.nawrocki@gmail.com, av.tikhomirov@samsung.com,
        yulgon.kim@samsung.com, kishon@ti.com, p.paneri@samsung.com,
        Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Wed, Dec 19, 2012 at 1:25 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Dec 19, 2012 at 11:52:01AM +0530, Vivek Gautam wrote:
>> >>> @@ -736,7 +1035,41 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
>> >>>
>> >>>       sphy->clk = clk;
>> >>>
>> >>> -     return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
>> >>> +     sphy->has_usb3 = (sphy->cpu_type == TYPE_EXYNOS5250);
>> >>> +
>> >>> +     if (sphy->has_usb3) {
>> >>> +             struct resource *usb3phy_mem;
>> >>> +             void __iomem    *usb3phy_base;
>> >>> +
>> >>> +             usb3phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> >>> +             if (!usb3phy_mem) {
>> >>> +                     dev_err(dev, "%s: missing mem resource\n", __func__);
>> >>> +                     return -ENODEV;
>> >>> +             }
>> >>> +
>> >>> +             usb3phy_base = devm_request_and_ioremap(dev, usb3phy_mem);
>> >>> +             if (!usb3phy_base) {
>> >>> +                     dev_err(dev, "%s: register mapping failed\n", __func__);
>> >>> +                     return -ENXIO;
>> >>> +             }
>> >>> +
>> >>> +             sphy->usb3phy.regs_phy          = usb3phy_base;
>> >>> +             sphy->usb3phy.phy.dev           = sphy->dev;
>> >>> +             sphy->usb3phy.phy.label         = "samsung-usb3phy";
>> >>> +             sphy->usb3phy.phy.init          = samsung_usb3phy_init;
>> >>> +             sphy->usb3phy.phy.shutdown      = samsung_usb3phy_shutdown;
>> >>> +     }
>> >>> +
>> >>> +     ret = usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
>> >>> +     if (ret)
>> >>> +             return ret;
>> >>
>> >> is this realy how your HW behaves ? USB2 and USB3 phys are a single HW
>> >> entity ? I kinda doubt that :-s
>> >>
>>
>> They are separate HW in fact.
>> So, do you expect to see a separate driver interface for USB 3.0 type phy ?
>
> yes. Just as we did on OMAP. One driver for the USB2 part and one driver
> for USB3 part (which are actually two, but you can only talk to them as
> one) :-)
>
Sure as you suggest, we will pull out the USB 3.0 code from here and put
a new driver in place for the same.

>> That will be quite similar architecturally to current samsung-usbphy
>> driver for USB 2.0 type phy,
>> and may require some code duplication too.
>
> If it duplicates code, then perhaps it's best to keep it as is but I'm
> actually surprised you guys have similar programming model on both
> parts. I mean, the differences at HW behavior are huge: on one side you
> use ULPI/UTMI+ on the other PIPE3, on one side you have 480Mbps
> half-duplex signalling, on the other you have 5Gbps dual simplex
> signalling, the differences go on and on.
>
The programming model for USB phy is just about setting up the phy registers
for example to provide proper clocks to PHY controller, setting up setting up
the UTMI block etc, under a sequence.

> Also, what you say about duplicating, it seems to me that it will
> duplicate only the boilerplate part (allocating memory, having a
> platform_driver, and so on), because you _do_ have completely separate
> functions to handle usb3 part.
>
Yes, the duplication was in fact just the boilerplate part ;-)
apart from having separate functions for USB 3.0 type phy.

> One more comment below:
>
>> +static u32 exynos5_usb3phy_set_clock(struct samsung_usbphy *sphy)
>> +{
>> +     u32 reg;
>> +     u32 refclk;
>> +
>> +     refclk = sphy->ref_clk_freq;
>> +
>> +     reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
>> +             PHYCLKRST_FSEL(refclk);
>> +
>> +     switch (refclk) {
>> +     case HOST_CTRL0_FSEL_CLKSEL_50M:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x00));
>> +             break;
>> +     case HOST_CTRL0_FSEL_CLKSEL_20M:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x00));
>> +             break;
>> +     case HOST_CTRL0_FSEL_CLKSEL_19200K:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x88));
>> +             break;
>> +     case HOST_CTRL0_FSEL_CLKSEL_24M:
>> +     default:
>> +             reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
>> +                     PHYCLKRST_SSC_REFCLKSEL(0x88));
>> +             break;
>> +     }
>> +
>> +     return reg;
>> +}
>
> looks like this should be done by commong clock framework by clock
> reparenting perhaps ?
>
Need to check on this one.

> --
> balbi



-- 
Thanks & Regards
Vivek
