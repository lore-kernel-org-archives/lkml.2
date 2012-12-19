Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392Ab2LSFoP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 00:44:15 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:38153 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779Ab2LSFoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 00:44:09 -0500
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Dec 2012 00:44:08 EST
MIME-Version: 1.0
In-Reply-To: <20121218151349.GC32437@arwen.pp.htv.fi>
References: <1355843426-13613-1-git-send-email-gautam.vivek@samsung.com>
	<1355843426-13613-2-git-send-email-gautam.vivek@samsung.com>
	<20121218151349.GC32437@arwen.pp.htv.fi>
Date: Wed, 19 Dec 2012 11:14:06 +0530
Message-ID: <CAFp+6iHQMDuwPd08KwPyxE_eXyofv_31-Azr0F9+LS2E9aY52w@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung: Add support for USB 3.0 phy for exynos5250
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: linux-usb@vger.kernel.org
Cc: dianders@chromium.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, balbi@ti.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, rob.herring@calxeda.com,
        grant.likely@secretlab.ca, sylvester.nawrocki@gmail.com,
        av.tikhomirov@samsung.com, yulgon.kim@samsung.com, kishon@ti.com,
        p.paneri@samsung.com, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: Doug Anderson


On Tue, Dec 18, 2012 at 8:43 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Tue, Dec 18, 2012 at 08:40:26PM +0530, Vivek Gautam wrote:
>> Adding support for USB3.0 phy for dwc3 controller on
>> exynos5250 SOC.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/usb/phy/samsung-usbphy.c |  339 +++++++++++++++++++++++++++++++++++++-
>
> let's make the phy names standard from now on and call this
> phy-samsung.c :-)
>
>>  1 files changed, 337 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/usb/phy/samsung-usbphy.c b/drivers/usb/phy/samsung-usbphy.c
>> index 621348a..246eb28 100644
>> --- a/drivers/usb/phy/samsung-usbphy.c
>> +++ b/drivers/usb/phy/samsung-usbphy.c
>> @@ -154,6 +154,86 @@
>>
>>  #define EXYNOS5_PHY_OTG_TUNE                 (0x40)
>>
>> +/* EXYNOS5: USB 3.0 DRD */
>> +#define EXYNOS5_DRD_LINKSYSTEM                       (0x04)
>> +
>> +#define LINKSYSTEM_FLADJ_MASK                        (0x3f << 1)
>> +#define LINKSYSTEM_FLADJ(_x)                 ((_x) << 1)
>> +#define LINKSYSTEM_XHCI_VERSION_CONTROL              (0x1 << 27)
>> +
>> +#define EXYNOS5_DRD_PHYUTMI                  (0x08)
>> +
>> +#define PHYUTMI_OTGDISABLE                   (0x1 << 6)
>> +#define PHYUTMI_FORCESUSPEND                 (0x1 << 1)
>> +#define PHYUTMI_FORCESLEEP                   (0x1 << 0)
>> +
>> +#define EXYNOS5_DRD_PHYPIPE                  (0x0c)
>> +
>> +#define EXYNOS5_DRD_PHYCLKRST                        (0x10)
>> +
>> +#define PHYCLKRST_SSC_REFCLKSEL_MASK         (0xff << 23)
>> +#define PHYCLKRST_SSC_REFCLKSEL(_x)          ((_x) << 23)
>> +
>> +#define PHYCLKRST_SSC_RANGE_MASK             (0x03 << 21)
>> +#define PHYCLKRST_SSC_RANGE(_x)                      ((_x) << 21)
>> +
>> +#define PHYCLKRST_SSC_EN                     (0x1 << 20)
>> +#define PHYCLKRST_REF_SSP_EN                 (0x1 << 19)
>> +#define PHYCLKRST_REF_CLKDIV2                        (0x1 << 18)
>> +
>> +#define PHYCLKRST_MPLL_MULTIPLIER_MASK               (0x7f << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF (0x19 << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF    (0x02 << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF  (0x68 << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF  (0x7d << 11)
>> +#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF       (0x02 << 11)
>> +
>> +#define PHYCLKRST_FSEL_MASK                  (0x3f << 5)
>> +#define PHYCLKRST_FSEL(_x)                   ((_x) << 5)
>> +#define PHYCLKRST_FSEL_PAD_100MHZ            (0x27 << 5)
>> +#define PHYCLKRST_FSEL_PAD_24MHZ             (0x2a << 5)
>> +#define PHYCLKRST_FSEL_PAD_20MHZ             (0x31 << 5)
>> +#define PHYCLKRST_FSEL_PAD_19_2MHZ           (0x38 << 5)
>> +
>> +#define PHYCLKRST_RETENABLEN                 (0x1 << 4)
>> +
>> +#define PHYCLKRST_REFCLKSEL_MASK             (0x03 << 2)
>> +#define PHYCLKRST_REFCLKSEL_PAD_REFCLK               (0x2 << 2)
>> +#define PHYCLKRST_REFCLKSEL_EXT_REFCLK               (0x3 << 2)
>> +
>> +#define PHYCLKRST_PORTRESET                  (0x1 << 1)
>> +#define PHYCLKRST_COMMONONN                  (0x1 << 0)
>> +
>> +#define EXYNOS5_DRD_PHYREG0                  (0x14)
>> +#define EXYNOS5_DRD_PHYREG1                  (0x18)
>> +
>> +#define EXYNOS5_DRD_PHYPARAM0                        (0x1c)
>> +
>> +#define PHYPARAM0_REF_USE_PAD                        (0x1 << 31)
>> +#define PHYPARAM0_REF_LOSLEVEL_MASK          (0x1f << 26)
>> +#define PHYPARAM0_REF_LOSLEVEL                       (0x9 << 26)
>> +
>> +#define EXYNOS5_DRD_PHYPARAM1                        (0x20)
>> +
>> +#define PHYPARAM1_PCS_TXDEEMPH_MASK          (0x1f << 0)
>> +#define PHYPARAM1_PCS_TXDEEMPH                       (0x1c)
>> +
>> +#define EXYNOS5_DRD_PHYTERM                  (0x24)
>> +
>> +#define EXYNOS5_DRD_PHYTEST                  (0x28)
>> +
>> +#define PHYTEST_POWERDOWN_SSP                        (0x1 << 3)
>> +#define PHYTEST_POWERDOWN_HSP                        (0x1 << 2)
>> +
>> +#define EXYNOS5_DRD_PHYADP                   (0x2c)
>> +
>> +#define EXYNOS5_DRD_PHYBATCHG                        (0x30)
>> +
>> +#define PHYBATCHG_UTMI_CLKSEL                        (0x1 << 2)
>> +
>> +#define EXYNOS5_DRD_PHYRESUME                        (0x34)
>> +#define EXYNOS5_DRD_LINKPORT                 (0x44)
>> +
>>  #ifndef MHZ
>>  #define MHZ (1000*1000)
>>  #endif
>> @@ -164,6 +244,15 @@ enum samsung_cpu_type {
>>       TYPE_EXYNOS5250,
>>  };
>>
>> +/* structure usb3 - usb3.0 phy trasceiver state
>> + * @phy: transceiver structure for USB 3.0
>> + * @regs_phy: usb 3.0 phy register memory base
>> + */
>> +struct usb3 {
>> +     struct usb_phy  phy;
>> +     void __iomem    *regs_phy;
>> +};
>> +
>>  /*
>>   * struct samsung_usbphy - transceiver driver state
>>   * @phy: transceiver structure
>> @@ -192,11 +281,15 @@ struct samsung_usbphy {
>>       u32             en_mask;
>>       int             ref_clk_freq;
>>       int             cpu_type;
>> +     struct usb3     usb3phy;
>> +     int             has_usb3;
>>       enum samsung_usb_phy_type phy_type;
>>       atomic_t        host_usage;
>>  };
>>
>>  #define phy_to_sphy(x)               container_of((x), struct samsung_usbphy, phy)
>> +#define phy_to_usb3phy(x)    container_of((x), struct usb3, phy);
>> +#define usb3phy_to_sphy(x)   container_of((x), struct samsung_usbphy, usb3phy)
>>
>>  static int samsung_usbphy_parse_dt_param(struct samsung_usbphy *sphy)
>>  {
>> @@ -394,6 +487,42 @@ static int samsung_usbphy_get_refclk_freq(struct samsung_usbphy *sphy)
>>       return refclk_freq;
>>  }
>>
>> +/*
>> + * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock form clock core.
>> + */
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
>> +
>>  static int exynos5_phyhost_is_on(void *regs)
>>  {
>>       u32 reg;
>> @@ -403,6 +532,78 @@ static int exynos5_phyhost_is_on(void *regs)
>>       return !(reg & HOST_CTRL0_SIDDQ);
>>  }
>>
>> +static int samsung_exynos5_usb3phy_enable(struct samsung_usbphy *sphy)
>> +{
>> +     void __iomem *regs = sphy->usb3phy.regs_phy;
>> +     u32 phyparam0;
>> +     u32 phyparam1;
>> +     u32 linksystem;
>> +     u32 phybatchg;
>> +     u32 phytest;
>> +     u32 phyclkrst;
>> +
>> +     /* Reset USB 3.0 PHY */
>> +     writel(0x0, regs + EXYNOS5_DRD_PHYREG0);
>> +
>> +     phyparam0 = readl(regs + EXYNOS5_DRD_PHYPARAM0);
>> +     /* Select PHY CLK source */
>> +     phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
>> +     /* Set Loss-of-Signal Detector sensitivity */
>> +     phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
>> +     phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
>> +     writel(phyparam0, regs + EXYNOS5_DRD_PHYPARAM0);
>> +
>> +     writel(0x0, regs + EXYNOS5_DRD_PHYRESUME);
>> +
>> +     /*
>> +      * Setting the Frame length Adj value[6:1] to default 0x20
>> +      * See xHCI 1.0 spec, 5.2.4
>> +      */
>> +     linksystem = LINKSYSTEM_XHCI_VERSION_CONTROL |
>> +                     LINKSYSTEM_FLADJ(0x20);
>> +     writel(linksystem, regs + EXYNOS5_DRD_LINKSYSTEM);
>> +
>> +     phyparam1 = readl(regs + EXYNOS5_DRD_PHYPARAM1);
>> +     /* Set Tx De-Emphasis level */
>> +     phyparam1 &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
>> +     phyparam1 |= PHYPARAM1_PCS_TXDEEMPH;
>> +     writel(phyparam1, regs + EXYNOS5_DRD_PHYPARAM1);
>> +
>> +     phybatchg = readl(regs + EXYNOS5_DRD_PHYBATCHG);
>> +     phybatchg |= PHYBATCHG_UTMI_CLKSEL;
>> +     writel(phybatchg, regs + EXYNOS5_DRD_PHYBATCHG);
>> +
>> +     /* PHYTEST POWERDOWN Control */
>> +     phytest = readl(regs + EXYNOS5_DRD_PHYTEST);
>> +     phytest &= ~(PHYTEST_POWERDOWN_SSP |
>> +                     PHYTEST_POWERDOWN_HSP);
>> +     writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
>> +
>> +     /* UTMI Power Control */
>> +     writel(PHYUTMI_OTGDISABLE, regs + EXYNOS5_DRD_PHYUTMI);
>> +
>> +     phyclkrst = exynos5_usb3phy_set_clock(sphy);
>> +
>> +     phyclkrst |= PHYCLKRST_PORTRESET |
>> +                     /* Digital power supply in normal operating mode */
>> +                     PHYCLKRST_RETENABLEN |
>> +                     /* Enable ref clock for SS function */
>> +                     PHYCLKRST_REF_SSP_EN |
>> +                     /* Enable spread spectrum */
>> +                     PHYCLKRST_SSC_EN |
>> +                     /* Power down HS Bias and PLL blocks in suspend mode */
>> +                     PHYCLKRST_COMMONONN;
>> +
>> +     writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
>> +
>> +     udelay(10);
>> +
>> +     phyclkrst &= ~(PHYCLKRST_PORTRESET);
>> +     writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
>> +
>> +     return 0;
>> +}
>> +
>>  static void samsung_exynos5_usbphy_enable(struct samsung_usbphy *sphy)
>>  {
>>       void __iomem *regs = sphy->regs;
>> @@ -541,6 +742,32 @@ static void samsung_usbphy_enable(struct samsung_usbphy *sphy)
>>       writel(rstcon, regs + SAMSUNG_RSTCON);
>>  }
>>
>> +static void samsung_exynos5_usb3phy_disable(struct samsung_usbphy *sphy)
>> +{
>> +     u32 phyutmi;
>> +     u32 phyclkrst;
>> +     u32 phytest;
>> +     void __iomem *regs = sphy->usb3phy.regs_phy;
>> +
>> +     phyutmi = PHYUTMI_OTGDISABLE |
>> +                     PHYUTMI_FORCESUSPEND |
>> +                     PHYUTMI_FORCESLEEP;
>> +     writel(phyutmi, regs + EXYNOS5_DRD_PHYUTMI);
>> +
>> +     /* Resetting the PHYCLKRST enable bits to reduce leakage current */
>> +     phyclkrst = readl(regs + EXYNOS5_DRD_PHYCLKRST);
>> +     phyclkrst &= ~(PHYCLKRST_REF_SSP_EN |
>> +                     PHYCLKRST_SSC_EN |
>> +                     PHYCLKRST_COMMONONN);
>> +     writel(phyclkrst, regs + EXYNOS5_DRD_PHYCLKRST);
>> +
>> +     /* Control PHYTEST to remove leakage current */
>> +     phytest = readl(regs + EXYNOS5_DRD_PHYTEST);
>> +     phytest |= (PHYTEST_POWERDOWN_SSP |
>> +                     PHYTEST_POWERDOWN_HSP);
>> +     writel(phytest, regs + EXYNOS5_DRD_PHYTEST);
>> +}
>> +
>>  static void samsung_exynos5_usbphy_disable(struct samsung_usbphy *sphy)
>>  {
>>       void __iomem *regs = sphy->regs;
>> @@ -600,6 +827,78 @@ static void samsung_usbphy_disable(struct samsung_usbphy *sphy)
>>  /*
>>   * The function passed to the usb driver for phy initialization
>>   */
>> +static int samsung_usb3phy_init(struct usb_phy *phy)
>> +{
>> +     struct usb3 *usb3phy;
>> +     struct samsung_usbphy *sphy;
>> +     int ret = 0;
>> +
>> +     usb3phy = phy_to_usb3phy(phy);
>> +     sphy = usb3phy_to_sphy(usb3phy);
>> +
>> +     if (!sphy->has_usb3) {
>> +             dev_err(sphy->dev, "Not a valid cpu_type for USB 3.0\n");
>> +             return -ENODEV;
>> +     }
>> +
>> +     /* setting default phy-type for USB 3.0 */
>> +     samsung_usbphy_set_type(&sphy->usb3phy.phy, USB_PHY_TYPE_DEVICE);
>> +
>> +     /* Enable the phy clock */
>> +     ret = clk_prepare_enable(sphy->clk);
>> +     if (ret) {
>> +             dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
>> +             return ret;
>> +     }
>> +
>> +     /* Disable phy isolation */
>> +     samsung_usbphy_set_isolation(sphy, false, sphy->phy_type);
>> +
>> +     /* Initialize usb phy registers */
>> +     samsung_exynos5_usb3phy_enable(sphy);
>> +
>> +     /* Disable the phy clock */
>> +     clk_disable_unprepare(sphy->clk);
>> +
>> +     return ret;
>> +}
>> +
>> +/*
>> + * The function passed to the usb driver for phy shutdown
>> + */
>> +static void samsung_usb3phy_shutdown(struct usb_phy *phy)
>> +{
>> +     struct usb3 *usb3phy;
>> +     struct samsung_usbphy *sphy;
>> +
>> +     usb3phy = phy_to_usb3phy(phy);
>> +     sphy = usb3phy_to_sphy(usb3phy);
>> +
>> +     if (!sphy->has_usb3) {
>> +             dev_err(sphy->dev, "Not a valid cpu_type for USB 3.0\n");
>> +             return;
>> +     }
>> +
>> +     /* setting default phy-type for USB 3.0 */
>> +     samsung_usbphy_set_type(&sphy->usb3phy.phy, USB_PHY_TYPE_DEVICE);
>> +
>> +     if (clk_prepare_enable(sphy->clk)) {
>> +             dev_err(sphy->dev, "%s: clk_prepare_enable failed\n", __func__);
>> +             return;
>> +     }
>> +
>> +     /* De-initialize usb phy registers */
>> +     samsung_exynos5_usb3phy_disable(sphy);
>> +
>> +     /* Enable phy isolation */
>> +     samsung_usbphy_set_isolation(sphy, true, sphy->phy_type);
>> +
>> +     clk_disable_unprepare(sphy->clk);
>> +}
>> +
>> +/*
>> + * The function passed to the usb driver for phy initialization
>> + */
>>  static int samsung_usbphy_init(struct usb_phy *phy)
>>  {
>>       struct samsung_usbphy *sphy;
>> @@ -682,7 +981,7 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
>>       struct resource *phy_mem;
>>       void __iomem    *phy_base;
>>       struct clk *clk;
>> -     int ret;
>> +     int ret = 0;
>>
>>       phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>>       if (!phy_mem) {
>> @@ -736,7 +1035,41 @@ static int __devinit samsung_usbphy_probe(struct platform_device *pdev)
>>
>>       sphy->clk = clk;
>>
>> -     return usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
>> +     sphy->has_usb3 = (sphy->cpu_type == TYPE_EXYNOS5250);
>> +
>> +     if (sphy->has_usb3) {
>> +             struct resource *usb3phy_mem;
>> +             void __iomem    *usb3phy_base;
>> +
>> +             usb3phy_mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
>> +             if (!usb3phy_mem) {
>> +                     dev_err(dev, "%s: missing mem resource\n", __func__);
>> +                     return -ENODEV;
>> +             }
>> +
>> +             usb3phy_base = devm_request_and_ioremap(dev, usb3phy_mem);
>> +             if (!usb3phy_base) {
>> +                     dev_err(dev, "%s: register mapping failed\n", __func__);
>> +                     return -ENXIO;
>> +             }
>> +
>> +             sphy->usb3phy.regs_phy          = usb3phy_base;
>> +             sphy->usb3phy.phy.dev           = sphy->dev;
>> +             sphy->usb3phy.phy.label         = "samsung-usb3phy";
>> +             sphy->usb3phy.phy.init          = samsung_usb3phy_init;
>> +             sphy->usb3phy.phy.shutdown      = samsung_usb3phy_shutdown;
>> +     }
>> +
>> +     ret = usb_add_phy(&sphy->phy, USB_PHY_TYPE_USB2);
>> +     if (ret)
>> +             return ret;
>
> is this realy how your HW behaves ? USB2 and USB3 phys are a single HW
> entity ? I kinda doubt that :-s
>
> --
> balbi



-- 
Thanks & Regards
Vivek
