Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2LJKUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 05:20:42 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:62141 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821Ab2LJKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 05:20:41 -0500
MIME-Version: 1.0
In-Reply-To: <CAPDyKFo8NjiYdcyx3pk8byc1N2f7r+erQj74A1zhOaNK_WbkZA@mail.gmail.com>
References: <1355129761-8088-1-git-send-email-lee.jones@linaro.org>
	<1355129761-8088-12-git-send-email-lee.jones@linaro.org>
	<CAPDyKFo8NjiYdcyx3pk8byc1N2f7r+erQj74A1zhOaNK_WbkZA@mail.gmail.com>
Date: Mon, 10 Dec 2012 11:20:39 +0100
Message-ID: <CAPDyKFr9cNO1V+AiN=xwFLLCLvmBWn9_7DcU3EL5bkjEUPGRtQ@mail.gmail.com>
Subject: Re: [PATCH 11/12] ARM: ux500: Use the GPIO regulator framework for
 SDI0's 'en' and 'vsel'
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 December 2012 11:18, Ulf Hansson <ulf.hansson@linaro.org> wrote:
> On 10 December 2012 09:56, Lee Jones <lee.jones@linaro.org> wrote:
>> To prevent lots of unnecessary call-backs into platform code, we're
>> now using the GPIO regulator framework to control the 'enable' (en)
>> and 'voltage select' (vsel) GPIO pins which in turn control the
>> MMCI's secondary regulator settings. This already works with Device
>> Tree, but when booting with ATAGs we need to register it as a
>> platform device.
>>
>> Signed-off-by: Lee Jones <lee.jones@linaro.org>
>> ---
>>  arch/arm/mach-ux500/board-mop500.c |   61 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 61 insertions(+)
>>
>> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
>> index daa4237..9f9fe7f 100644
>> --- a/arch/arm/mach-ux500/board-mop500.c
>> +++ b/arch/arm/mach-ux500/board-mop500.c
>> @@ -24,6 +24,8 @@
>>  #include <linux/mfd/abx500/ab8500.h>
>>  #include <linux/regulator/ab8500.h>
>>  #include <linux/regulator/fixed.h>
>> +#include <linux/regulator/driver.h>
>> +#include <linux/regulator/gpio-regulator.h>
>>  #include <linux/mfd/tc3589x.h>
>>  #include <linux/mfd/tps6105x.h>
>>  #include <linux/mfd/abx500/ab8500-gpio.h>
>> @@ -91,6 +93,54 @@ static struct platform_device snowball_gpio_en_3v3_regulator_dev = {
>>         },
>>  };
>>
>> +static struct regulator_consumer_supply sdi0_reg_consumers[] = {
>> +        REGULATOR_SUPPLY("vqmmc", NULL),
>
> REGULATOR_SUPPLY("vqmmc", "sdi0"),
>
>> +};
>> +
>> +static struct regulator_init_data sdi0_reg_init_data = {
>
> The levelshifter uses the ab8500-ext-supply3. Reflect that here.
>
> .supply_regulator = "ab8500-ext-supply3"
>
>
>> +        .constraints = {
>> +                .min_uV         = 1800000,
>
> 2.9V, not 3.3V
>
>> +                .max_uV         = 3300000,
>> +                .valid_ops_mask = REGULATOR_CHANGE_VOLTAGE|REGULATOR_CHANGE_STATUS,
>> +        },
>> +        .num_consumer_supplies  = ARRAY_SIZE(sdi0_reg_consumers),
>> +        .consumer_supplies      = sdi0_reg_consumers,
>> +};
>> +
>> +/* Dynamically populated. */
>> +static struct gpio sdi0_reg_gpios[] = {
>> +        { 0, GPIOF_OUT_INIT_LOW, "mmci_vsel" },
>> +};
>> +
>> +static struct gpio_regulator_state sdi0_reg_states[] = {
>> +        { .value = 3300000, .gpios = (0 << 0) },
>
> 2.9V, not 3.3V
>
>> +        { .value = 1800000, .gpios = (1 << 0) },
>> +};
>> +
>> +static struct gpio_regulator_config sdi0_reg_info = {
>> +        .supply_name = "mmci-reg",
>> +
>> +        .enable_high = 1,
>> +        .enabled_at_boot = 0,
>> +
>> +        .gpios = sdi0_reg_gpios,
>> +        .nr_gpios = ARRAY_SIZE(sdi0_reg_gpios),
>> +

I think the "settling time" is missing here. 100us according to
levelshifter spec.

>> +        .states = sdi0_reg_states,
>> +        .nr_states = ARRAY_SIZE(sdi0_reg_states),
>> +
>> +        .type = REGULATOR_VOLTAGE,
>> +        .init_data = &sdi0_reg_init_data,
>> +};
>> +
>> +static struct platform_device sdi0_regulator = {
>> +        .name = "gpio-regulator",
>> +        .id   = -1,
>> +        .dev  = {
>> +                .platform_data = &sdi0_reg_info,
>> +        },
>> +};
>> +
>>  static struct ab8500_gpio_platform_data ab8500_gpio_pdata = {
>>         .gpio_base              = MOP500_AB8500_PIN_GPIO(1),
>>         .irq_base               = MOP500_AB8500_VIR_GPIO_IRQ_BASE,
>> @@ -440,6 +490,7 @@ static struct hash_platform_data u8500_hash1_platform_data = {
>>  /* add any platform devices here - TODO */
>>  static struct platform_device *mop500_platform_devs[] __initdata = {
>>         &mop500_gpio_keys_device,
>> +       &sdi0_regulator,
>>  };
>>
>>  #ifdef CONFIG_STE_DMA40
>> @@ -581,6 +632,7 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
>>         &snowball_key_dev,
>>         &snowball_sbnet_dev,
>>         &snowball_gpio_en_3v3_regulator_dev,
>> +       &sdi0_regulator,
>>  };
>>
>>  static void __init mop500_init_machine(void)
>> @@ -591,6 +643,9 @@ static void __init mop500_init_machine(void)
>>
>>         mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
>>
>> +       sdi0_reg_info.enable_gpio = GPIO_SDMMC_EN;
>> +       sdi0_reg_info.gpios[0].gpio = GPIO_SDMMC_1V8_3V_SEL;
>> +
>>         mop500_pinmaps_init();
>>         parent = u8500_init_devices(&ab8500_platdata);
>>
>> @@ -623,6 +678,9 @@ static void __init snowball_init_machine(void)
>>         struct device *parent = NULL;
>>         int i;
>>
>> +       sdi0_reg_info.enable_gpio = SNOWBALL_SDMMC_EN_GPIO;
>> +       sdi0_reg_info.gpios[0].gpio = SNOWBALL_SDMMC_1V8_3V_GPIO;
>> +
>>         snowball_pinmaps_init();
>>         parent = u8500_init_devices(&ab8500_platdata);
>>
>> @@ -655,6 +713,9 @@ static void __init hrefv60_init_machine(void)
>>          */
>>         mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
>>
>> +       sdi0_reg_info.enable_gpio = HREFV60_SDMMC_EN_GPIO;
>> +       sdi0_reg_info.gpios[0].gpio = HREFV60_SDMMC_1V8_3V_GPIO;
>> +
>>         hrefv60_pinmaps_init();
>>         parent = u8500_init_devices(&ab8500_platdata);
>>
>> --
>> 1.7.9.5
>>
>
> Finally, I suppose regulator inits i located in
> board-mop500-regulators.c, so I would suggest to move most of this
> code in there instead.
>
> Kind regards
> Ulf Hansson
