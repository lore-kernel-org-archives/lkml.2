Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab2LJODs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 09:03:48 -0500
Received: from mga14.intel.com ([143.182.124.37]:60876 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab2LJODq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 09:03:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,252,1355126400"; 
   d="scan'208";a="178920776"
Message-ID: <50C5EC4D.4070102@linux.intel.com>
Date: Mon, 10 Dec 2012 16:06:05 +0200
From: Mathias Nyman <mathias.nyman@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: grant.likely@secretlab.ca, mika.westerberg@linux.intel.com,
        rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 1/1] gpio: add Lynxpoint chipset gpio driver.
References: <1354888899-21907-1-git-send-email-mathias.nyman@linux.intel.com> <1354888899-21907-2-git-send-email-mathias.nyman@linux.intel.com> <CACRpkdYG641KYR05jtu3OS7BDGcFpJ-pzu+gTM+RHJnMqytfEQ@mail.gmail.com>
In-Reply-To: <CACRpkdYG641KYR05jtu3OS7BDGcFpJ-pzu+gTM+RHJnMqytfEQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 11:48 AM, Linus Walleij wrote:
> On Fri, Dec 7, 2012 at 3:01 PM, Mathias Nyman
> <mathias.nyman@linux.intel.com>  wrote:
>
>> Add gpio support for Intel Lynxpoint chipset.
>> Lynxpoint supports 94 gpio pins which can generate interrupts.
>> Driver will fail requests for pins that are marked as owned by ACPI, or
>> set in an alternate mode (non-gpio).
>>
>> Signed-off-by: Mathias Nyman<mathias.nyman@linux.intel.com>
>
> Nice shape on this patch, makes it easy to focus the review on the
> important stuff, thanks Magnus!
>
>> +config GPIO_LYNXPOINT
>> +       bool "Intel Lynxpoint GPIO support"
>
> So you don't want to be able to build it as module?
> (OK just odd on Intel systems.)

Reason for having it as bool was the subsys_initcall() got degraded
to something like module_init() if built as module. This was not good 
because the IO port ranges used for gpios were specified in ACPI tables 
both in the gpio device, and as a part of a motherboard device. Pnpacpi 
code would then reserve all the IO port ranges in the motherboard device 
before this gpio driver had a chance to take reserve them.

I have to re-check if this is still the case.

>> +struct lp_gpio {
>> +       struct gpio_chip        chip;
>> +       struct irq_domain       *domain;
>> +       struct platform_device  *pdev;
>> +       spinlock_t              lock;
>> +       unsigned                hwirq;
>
> This struct member is only used in probe() so make it a local variable there
> and cut it from the struct.
>
>> +       unsigned long           reg_base;
>> +       unsigned long           reg_len;
>
> Same comment for reg_len.

Will fix

>
>> +};
>> +
>> +static unsigned long gpio_reg(struct gpio_chip *chip, unsigned gpio, int reg)
>
> Rename lp_gpio_reg() so as to match the family.
>
> Rename the argument "gpio" to "offset" since it's a local number,
> not in the global GPIO numberspace. (Please change this everywhere
> a local index is used.)

Sure.

>
>> +{
>> +       struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
>> +       int offset;
>> +
>> +       if (reg == LP_CONFIG1 || reg == LP_CONFIG2)
>> +               offset = gpio * 8;
>> +       else
>> +               offset = (gpio / 32) * 4;
>
> Put in some comment above this explaining the layout of the offsets
> for these two cases so we understand what's happening here.
>
>> +       return lg->reg_base + reg + offset;
>> +}
>> +
>> +static int lp_gpio_request(struct gpio_chip *chip, unsigned gpio)
>> +{
>> +       struct lp_gpio *lg = container_of(chip, struct lp_gpio, chip);
>> +       unsigned long reg = gpio_reg(chip, gpio, LP_CONFIG1);
>> +       unsigned long conf2 = gpio_reg(chip, gpio, LP_CONFIG2);
>> +       unsigned long acpi_use = gpio_reg(chip, gpio, LP_ACPI_OWNED);
>> +
>> +       /* Fail if BIOS reserved pin for ACPI use */
>> +       if (!(inl(acpi_use)&  BIT(gpio % 32))) {
>> +               dev_err(&lg->pdev->dev, "gpio %d reserved for ACPI\n", gpio);
>> +               return -EBUSY;
>> +       }
>
> This %32 magic only seems to consider the latter part of the if()
> statement in the gpio_reg() function. It's like you assume only the
> (gpio / 32) * 4 path to be taken. It seems that for the two models
> handled there this should be %8 or something. Or I'm getting it
> wrong, which is an indication that something is pretty unclear here...
>

I should document the register layout better. It's a bit messy because 
in some cases a register represents a functionality where each bit 
stands for a gpio (bitmapped) (each register is 32 bit, so to cover all 
94 gpios three 32bit registers are needed).

In other cases a register represent a gpio, and each bit a 
functionality. This is the case with LP_CONFIGx registers. So we got
94 LP_CONFIG1 registers and 94 LP_CONFIG2 registers.

In the case of acpi_use & BIT(gpio % 32) I know that acpi_used is 
pointing to one of the three LP_ACPI_OWNED bitmapped registers, and the 
(gpio / 32 * 4) path is taken, and % 32 will work.

I'll add better description of the register layout as a comment

>> +static void lp_irq_enable(struct irq_data *d)
>> +{
>> +       struct lp_gpio *lg = irq_data_get_irq_chip_data(d);
>> +       u32 gpio = irqd_to_hwirq(d);
>
> That variable is confusingly named. It's not a global gpio number,
> it's a local offset, so please rename it "offset".

sure, (is "pin" ok?  "offset" is already used in may places)

>> +#ifdef CONFIG_ACPI
>> +static const struct acpi_device_id lynxpoint_gpio_acpi_match[] = {
>> +       { "INT33C7", 0 },
>> +       { }
>> +};
>> +MODULE_DEVICE_TABLE(acpi, lynxpoint_gpio_acpi_match);
>> +#endif
>
> Aha so how many users are there of this driver which are not
> using ACPI?
>
> If zero, why not just depend on ACPI in Kconfig?
>

Only ACPI support for now.
Will remove ifdefs and add dependency.

>> +static int __devexit lp_gpio_remove(struct platform_device *pdev)
>
> All __devinit/__devexit macros are going away in v3.8 so delete them
> everywhere.

Ah, Ok.

>
> Yours,
> Linus Walleij

Thanks for taking the time to review this, I'll make the suggested changes.

I also got some offline comments about adding runtime pm/system suspend 
code to this driver.

-Mathias
