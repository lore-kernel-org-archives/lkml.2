Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758562Ab1LOCKL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:10:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62749 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1LOCKJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:10:09 -0500
MIME-Version: 1.0
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF1751860B1F@HQMAIL01.nvidia.com>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
	<1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com>
	<74CDBE0F657A3D45AFBB94109FB122FF1751860B1F@HQMAIL01.nvidia.com>
Date: Thu, 15 Dec 2011 10:10:08 +0800
Message-ID: <CAN1soZxKMcFniW7wbOA6Bb2ZwNsAmypZmwmo1KdEhJBbx21wdA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Stephen Warren <swarren@nvidia.com>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 2:28 AM, Stephen Warren <swarren@nvidia.com> wrote:
> Haojian Zhuang wrote at Tuesday, December 13, 2011 2:41 AM:
>> Support pxa3xx/pxa168/pxa910/mmp2. Support to switch pin configuration.
>
>>  drivers/pinctrl/Kconfig          |   15 +
>>  drivers/pinctrl/Makefile         |    3 +
>>  drivers/pinctrl/pinctrl-pxa3xx.c |  193 +++++++++++
>>  drivers/pinctrl/pinmux-pxa168.c  |  170 ++++++++++
>>  drivers/pinctrl/pinmux-pxa300.c  |  647 ++++++++++++++++++++++++++++++++++++++
>>  drivers/pinctrl/pinmux-pxa910.c  |  373 ++++++++++++++++++++++
>
>
>
>> +static int pxa3xx_pmx_request_gpio(struct pinctrl_dev *pctrldev,
>> +                            struct pinctrl_gpio_range *range,
>> +                            unsigned pin)
>> +{
> ...
>> +     /* write gpio function into mfpr register */
>> +     data = readl_relaxed(info->virt_base + mfpr) & MFPR_FUNC_MASK;
>
> FOO_MASK is usually the mask for the field, so you'd want to and with
> ~MFPR_FUNC_MASK here. Still, I see that MFPR_FUNC_MASK==~MFPR_FUNC, so
> the code is correct as written, albeit confusing.
>
> I'd suggest:
> * Delete MFPR_FUNC_MASK define.
> * Rename MFPR_FUNC to MFPR_FUNC_MASK.
> * and with ~MFPR_FUNC_MASK instead of MFPR_FUNC_MASK here.
>
OK.

>> +static int pxa3xx_pmx_enable(struct pinctrl_dev *pctrldev, unsigned func,
>> +                          unsigned group)
>> +{
>> +     struct pxa3xx_pinmux_info *info = pinctrl_dev_get_drvdata(pctrldev);
>> +     struct pxa3xx_pin_group *pin_grp = &info->grp[group];
>> +     unsigned int data, pin_func;
>> +     int i, mfpr;
>> +
>> +     for (i = 0; i < pin_grp->num_pins; i++) {
>> +             mfpr = pxa3xx_get_mfpr(info, pin_grp->pins[i]);
>> +             if (mfpr < 0) {
>> +                     dev_err(info->dev, "error pin:%d mfpr offset:%x\n",
>> +                             pin_grp->pins[i], mfpr);
>> +                     goto out;
>> +             }
>> +             pin_func = pin_grp->func[i];
>> +             data = readl_relaxed(info->virt_base + mfpr);
>> +             data &= MFPR_FUNC_MASK;
>> +             data |= pin_func;
>
> There's an indentation problem here.
>
>> +             writel_relaxed(data, info->virt_base + mfpr);
>> +     }
>> +     return 0;
>> +out:
>> +     return -EINVAL;
>> +}
>
> I don't see "func" used anywhere in this function. How does this code
> know /which/ function to activate on the pins, or is there only a single
> supported function for each pin? If so, I think you should at least
> validate the "func" is the expected function for the pin.
>
> Related, if the HW supports configuring the mux function at a per-pin
> Level (as appears to be the case, since you're looping over pins above),
> I'd expect that each group definition in your driver to contain a single
> pin, rather than an array of pins. The set of pins/groups/functions
> exposed by your driver should represent the raw HW capabilities, and not
> any logical grouping of pins into e.g. a whole UART or SD port.
>
There's multiple function on one pin. In my patch, I force to define
multiple pins into one group with same function. It seems not good.
I'll a groupe only on single pin.
> ----------==========----------==========----------==========----------==========
> Yes, looking at e.g. pinmux-pxa168.c, I believe you are creating
> artificial groups, when you should be creating a group for each pin.
> I wonder if the pinctrl core should grow the ability to synthesize a
> group for each pin, in the case where the HW doesn't use groups. That
> would remove the need for you to type out all those group definitions.
> Alternatively, the mapping table lookups could first search for a group,
> and if one isn't found, search for a pin of that name. Then, groups
> would not be needed at all if the HW didn't use them.
>
>> diff --git a/drivers/pinctrl/pinmux-pxa168.c b/drivers/pinctrl/pinmux-pxa168.c
>
>> +static struct pinctrl_desc pxa168_pctrl_desc = {
>> +     .name           = "pxa168-pinctrl",
> ...
>> +static struct platform_driver pxa168_pinmux_driver = {
>> +     .driver = {
>> +             .name = "pxa168-pinmux",
>
> Shouldn't those two names match?
>
>> diff --git a/drivers/pinctrl/pinmux-pxa300.c b/drivers/pinctrl/pinmux-pxa300.c
>
> This file appears to contain 4 sets of data without any commonality.
> Shouldn't this be 4 separate files to keep the different CPUs separate?
> you could still share probe() etc. by putting that in a common file, and
> having that file call out to the per-CPU file to get a structure containing
> the CPU-specific data. That way, I think you can probably share probe()
> etc. across all 3 of the files you have now too, thus reducing the total
> amount of code even if increasing the file count.
>
> See the Tegra patches I posted for example.
>
>> +++ b/drivers/pinctrl/pinmux-pxa300.c
> ...
>> + *  linux/drivers/pinctrl/pinmux-pxa3xx.c
>
> The comment doesn't match the filename.
>
>> diff --git a/drivers/pinctrl/pinmux-pxa910.c b/drivers/pinctrl/pinmux-pxa910.c
>
> Same comment for this file; it appears to contain the data for two
> different CPUs, and there's no commonality.
>
> --
> nvpublic
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
