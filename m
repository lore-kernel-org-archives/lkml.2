Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752146Ab2L0JUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 04:20:52 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:52549 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751389Ab2L0JUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 04:20:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121227002646.GC24604@n2100.arm.linux.org.uk>
References: <1356524912-4736-1-git-send-email-gautam.vivek@samsung.com>
	<1356524912-4736-2-git-send-email-gautam.vivek@samsung.com>
	<20121227002646.GC24604@n2100.arm.linux.org.uk>
Date: Thu, 27 Dec 2012 14:50:47 +0530
Message-ID: <CAFp+6iHWnXzkTgGkacHM7fQ6mC61N-0JFjoH_p-PzkGDNZCHNA@mail.gmail.com>
Subject: Re: [PATCH v4] usb: phy: samsung: Add support to set pmu isolation
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        l.majewski@samsung.com, linux-samsung-soc@vger.kernel.org,
        heiko@sntech.de, p.paneri@samsung.com, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org,
        broonie@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        balbi@ti.com, dianders@chromium.org, grant.likely@secretlab.ca,
        kyungmin.park@samsung.com, kgene.kim@samsung.com,
        thomas.abraham@linaro.org, ben-linux@fluff.org,
        sylvester.nawrocki@gmail.com, t.figa@samsung.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,


On Thu, Dec 27, 2012 at 5:56 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Dec 26, 2012 at 05:58:32PM +0530, Vivek Gautam wrote:
>> +     if (!ret)
>> +             sphy->phyctrl_pmureg = ioremap(reg[0], reg[1]);
>> +
>> +     of_node_put(usbphy_pmu);
>> +
>> +     if (IS_ERR_OR_NULL(sphy->phyctrl_pmureg)) {
>
> No.  Learn what the error return values are from functions.  Using the
> wrong ones is buggy.  ioremap() only ever returns NULL on error.  You
> must check against NULL, and not use the IS_ERR stuff.
>
True, i should have checked the things. :-(
ioremap() won't return error. Will amend this to check against NULL.

>> +/*
>> + * Set isolation here for phy.
>> + * SOCs control this by controlling corresponding PMU registers
>> + */
>> +static void samsung_usbphy_set_isolation(struct samsung_usbphy *sphy, int on)
>> +{
>> +     u32 reg;
>> +     int en_mask;
>> +
>> +     if (!sphy->phyctrl_pmureg) {
>> +             dev_warn(sphy->dev, "Can't set pmu isolation\n");
>> +             return;
>> +     }
>> +
>> +     reg = readl(sphy->phyctrl_pmureg);
>> +
>> +     en_mask = sphy->drv_data->devphy_en_mask;
>> +
>> +     if (on)
>> +             writel(reg & ~en_mask, sphy->phyctrl_pmureg);
>> +     else
>> +             writel(reg | en_mask, sphy->phyctrl_pmureg);
>
> What guarantees that this read-modify-write sequence of this register safe?
> And, btw, this can't be optimised very well because of the barrier inside
> writel().  This would be better:
>
>         if (on)
>                 reg &= ~en_mask;
>         else
>                 reg |= en_mask;
>
>         writel(reg, sphy->phyctrl_pmureg);
>
Sure will amend this.
A similar way suggested by Sylwester in the earlier mail in this thread:

reg = on ? reg & ~mask : reg | mask;
writel(reg, sphy->phyctrl_pmureg);

Does this look fine ?

>> +static inline struct samsung_usbphy_drvdata
>> +*samsung_usbphy_get_driver_data(struct platform_device *pdev)
>>  {
>>       if (pdev->dev.of_node) {
>>               const struct of_device_id *match;
>>               match = of_match_node(samsung_usbphy_dt_match,
>>                                                       pdev->dev.of_node);
>> -             return (int) match->data;
>> +             return (struct samsung_usbphy_drvdata *) match->data;
>
> match->data is a const void pointer.  Is there a reason you need this
> cast here?  What if you made the returned pointer from this function
> also const and fixed up all its users (no user should modify this
> data.)
>
Right, we won't need this cast since match->data is a void pointer.
Will also make the returned pointer const.

>>  #ifdef CONFIG_OF
>>  static const struct of_device_id samsung_usbphy_dt_match[] = {
>>       {
>>               .compatible = "samsung,s3c64xx-usbphy",
>> -             .data = (void *)TYPE_S3C64XX,
>> +             .data = (void *)&usbphy_s3c64xx,
>
> Why do you need this cast?
>
True we don't need this cast. Will remove this one.

>>       }, {
>>               .compatible = "samsung,exynos4210-usbphy",
>> -             .data = (void *)TYPE_EXYNOS4210,
>> +             .data = (void *)&usbphy_exynos4,
>
> Ditto.

True we don't need this cast. Will remove this one.

Thanks for the review :-)


-- 
Regards
Vivek
