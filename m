Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab2H0XXC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:23:02 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:57760 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754814Ab2H0XXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:23:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAJuYYwQu7OXQEWCumuMeSKJ2RZD7e==pLKDE1=bvPgfXtO=AUw@mail.gmail.com>
References: <1345060656-32201-1-git-send-email-thomas.abraham@linaro.org>
	<1345060656-32201-2-git-send-email-thomas.abraham@linaro.org>
	<CACRpkdYqPYesgE-YxPLZqROw1T2fsPWR6R+aDTTz2=XbP7oe9A@mail.gmail.com>
	<CAJuYYwQu7OXQEWCumuMeSKJ2RZD7e==pLKDE1=bvPgfXtO=AUw@mail.gmail.com>
Date: Mon, 27 Aug 2012 16:22:57 -0700
Message-ID: <CACRpkdbVY1mmzb9H4ZfmVScW1ZNf1FTMLdgo5UFgqTftycMyrQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] pinctrl: add samsung pinctrl and gpiolib driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Thomas Abraham <thomas.abraham@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, kgene.kim@samsung.com,
        Stephen Warren <swarren@wwwdotorg.org>,
        Dong Aisheng <dong.aisheng@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 9:22 PM, Thomas Abraham
<thomas.abraham@linaro.org> wrote:

>>> +  - samsung,pin-pud: Pull up/down configuration.
>>> +  - samsung,pin-drv: Drive strength configuration.
>>> +  - samsung,pin-pud-pdn: Pull up/down configuration in power down mode.
>>> +  - samsung,pin-drv-pdn: Drive strength configuration in power down mode.
>>
>> This looks a bit scary, as it seems to be orthogonal to the pin config
>> interface. I.e. this will be programmed "behind the back" of the
>> pin config system. However as long as the pin config implementation
>> reads back these things from the registers it will work, too.
>
> These properties are converted to a PIN_MAP_TYPE_CONFIGS_GROUP map
> type and stored in a instance of 'struct pinctrl_map'. These can be
> read back from the registers and reverse-mapped as well.

OK

> All the dt bindings defined and used in the Samsung pinctrl driver are
> first translated into pinctrl subystem defined data structures and
> then used. Hence, there are no register configurations done that skip
> over the pinctrl subsystem (except for the gpio/wakeup interrupts).

OK fine.

>> In the U300 and Ux500 I explicitly use pin config hogs to set up
>> the pin configuration, and when we enter a state such as
>> "default" the mux setting and config settings are set from the
>> framework separately.
>>
>> See for example:
>> arch/arm/mach-ux500/board-mop500-pins.c
>>
>> This example is using platform data but it should be trivial to do with
>> device tree.
>>
>> I think the Tegra also works this way. Can you elaborate on
>> why you need this static setup from the device tree instead
>> of using default states?
>
> Sorry, I did not understand this question.

You answered above, no problem.

>>> +       pinctrl_0: pinctrl@11400000 {
>>> +               compatible = "samsung,pinctrl-exynos4210";
>>> +               reg = <0x11400000 0x1000>;
>>> +               interrupts = <0 47 0>;
>>> +
>>> +               uart0_data: uart0-data {
>>> +                       samsung,pins = "gpa0-0", "gpa0-1";
>>> +                       samsung,pin-function = <2>;
>>> +                       samsung,pin-pud = <0>;
>>> +                       samsung,pin-drv = <0>;
>>> +               };
>>
>> This setup needs to be associated with a certain state, it's possible to
>> do in the code or directly in the device tree.
>>
>> I.e. these settings for pin-pud and pin-drv needs to belong to a
>> certain pin config state, typically the state named "default"
>
> Yes, I agree. So, for example, the uart device node would have
>
>                     uart@13800000 {
>                                compatilble = " .... ";
>                                <rest of the properties here>
>
>                                pinctrl-names = "default";
>                                pinctrl-0 - <&uart0_data>;
>                     };
>
> The uart driver during probe can then call
>
>                    devm_pinctrl_get_select_default(&pdev->dev);
>
> For the example above, this call will set the 'mux', 'pud' and 'drv'
> values to gpa-0 and gpa-1 pins.

OK perfect, that's how it should work.

>>> +/* list of all possible config options supported */
>>> +struct pin_config {
>>> +       char            *prop_cfg;
>>> +       unsigned int    cfg_type;
>>> +} pcfgs[] = {
>>> +       { "samsung,pin-pud", PINCFG_TYPE_PUD },
>>> +       { "samsung,pin-drv", PINCFG_TYPE_DRV },
>>> +       { "samsung,pin-pud-pdn", PINCFG_TYPE_CON_PND },
>>> +       { "samsung,pin-drv-pdn", PINCFG_TYPE_PUD_PND },
>>> +};
>>
>> Hmmmmm it looks very much like this controller could make use of
>> the generic pinconf library, but it's not mandatory so just a suggestion.
>
> Ok. The last two entries in the above table are Samsung specific and
> not covered by generic-pinconf. So, I am not sure if it can be added
> to generic-pinconf.

What is so Samsung-specific about them?

If you tell us the electrical property of setting them we can figure out
if they should be generic or not...

> For now, since you are not enforcing the use of
> generic-pinconf, I will keep it the way it is now.

Sure that's OK.

>>> +       /* Allocate memory for pin group name. The pin group name is derived
>>> +        * from the node name from which these map entries are be created.
>>> +        */
>>> +       gname = kzalloc(strlen(np->name) + 4, GFP_KERNEL);
>>
>> Why +4? I would have suspected +1 for the null terminator...
>
> The name of the pin group is derived from the node name and hence
> strlen(np->name). To this name, "-grp" is appended to imply that this
> is a group. Hence +4 is used. I will replace +4 with probably
> strlen(PINGRP_SUFFIX) where PINGRP_SUFFIX is defined as "-grp".

Aha OK I get it.

>>> +/* reading pin pull up/down and driver strength settings not implemented */
>>
>> OK why not? It seems very simple and straight-forward.
>> Just read the same registers and switch() then return...
>
> Ok, I will do that. I did not see how those would be used and hence skipped it.

One good usecase is to look at the state of pins in debugfs.

>>> +static int __devinit samsung_pinctrl_probe(struct platform_device *pdev)
>> (...)
>>> +       if (ctrl->eint_gpio_init)
>>> +               ctrl->eint_gpio_init(drvdata);
>>> +       if (ctrl->eint_wkup_init)
>>> +               ctrl->eint_wkup_init(drvdata);
>>
>> So this stuff I'm doing in the default states instead.
>
> These callbacks setup the irq domain and irq_chip for gpio and wakeup
> interrupts. These are Samsung specific and are dealt with outside of
> the pinctrl subsystem framework.

Aha I get it, OK.

>>> +       unsigned int            eint_type;
>>
>> Shouldn't this be some kund of enum if it denotes a type?
>
> It was done to reduce adding new data types.

Oh I like new data types if they make the code easier to read
and reduce the risk for errors so just go ahead :-)

>>> +/**
>>> + * struct samsung_pin_ctrl: represent a pin controller.
>>> + * @pin_banks: list of pin banks included in this controller.
>>> + * @nr_banks: number of pin banks.
>>> + * @base: starting system wide pin number.
>>> + * @nr_pins: number of pins supported by the controller.
>>> + * @nr_gint: number of external gpio interrupts supported.
>>> + * @nr_wint: number of external wakeup interrupts supported.
>>> + * @geint_con: offset of the ext-gpio controller registers.
>>
>> If it's an offset why not name it geint_con_offset?
>
> I wanted to keep the lines within 80 columns. Splitting a line into
> two lines started making the code look unreadable.

OK no big deal.

>>> +       int                     (*eint_gpio_init)(struct samsung_pinctrl_drv_data *);
>>> +       int                     (*eint_wkup_init)(struct samsung_pinctrl_drv_data *);
>>
>> I guess you need to set up these using auxdata?
>
> No, these are populated by the platform (SoC) specific data that the
> Samsung pinctrl driver gets during probe. Due to the differences in
> the gpio and wakeup interrupt controllers on Samsung SoC's, the setup
> and implementations of these  interrupts have been made SoC specific.
> The pinctrl driver is responsible only for initiating the setup of the
> gpio/wakeup interrupts.

I see, OK.

>>> +/**
>>> + * struct samsung_pinctrl_drv_data: wrapper for holding driver data together.
>>> + * @virt_base: register base address of the controller.
>>> + * @dev: device instance representing the controller.
>>> + * @irq: interrpt number used by the controller to notify gpio interrupts.
>>> + * @ctrl: pin controller instance managed by the driver.
>>> + * @pctl: pin controller descriptor registered with the pinctrl subsystem.
>>
>> Maybe name this pctl_desc then?
>
> This name is used to in multiple places in the code and the longer the
> name, there is always the case of the line spilling over 80
> characters.

OK whatever... looking formward to next iteration!

Yours,
Linus Walleij
