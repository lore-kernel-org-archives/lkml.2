Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2GEOG0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:06:26 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40881 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182Ab2GEOGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:06:24 -0400
Message-ID: <4FF59F5C.8050002@linaro.org>
Date: Thu, 05 Jul 2012 15:06:20 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, sameo@linux.intel.com
Subject: Re: [PATCH 1/1] mfd: Fix runtime warning caused by duplicate device
 registration
References: <20120703132447.GN29030@opensource.wolfsonmicro.com> <4FF58B68.5000703@linaro.org> <20120705124549.GD4111@opensource.wolfsonmicro.com> <201207051357.07195.arnd@arndb.de>
In-Reply-To: <201207051357.07195.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/07/12 14:57, Arnd Bergmann wrote:
> On Thursday 05 July 2012, Mark Brown wrote:
>> On Thu, Jul 05, 2012 at 01:41:12PM +0100, Lee Jones wrote:
>>> On 05/07/12 13:29, Mark Brown wrote:
>>
>>> If DT is not enabled, we do:
>>
>>>    From platform code:
>>>     - Register the DB8500-PRCMU
>>>     - Register the AB8500
>>
>>> So you see the registration is separate.
>>
>> Right, so what I'm saying is that what I'd expect unless there's
>> something unusual going on is that you wouldn't be doing the separate
>> registration of the AB8500 here and would instead be passing the
>> platform data for the AB8500 through in the same way you pass the DT
>> data through.
>>
>> DT and non-DT do have a very similar model for this stuff.
>
> The non-DT path for this is a huge mess, I'd rather focus on making
> it obsolete than trying to fix it. Other than that, I agree that
> we should be registering the ab8500 from the prcmu from both the
> DT and the non-DT case.

Ah, is that what you were saying Mark?

If so, I apologise. I thought you meant register both from platform 
code. I'm happy to register the AB8500 from the DB8500 for _both_ DT and 
!DT.

> Right now, for non-DT, we register ab8500 as a platform device
> with board specific platform_data from arch/arm/mach-ux500/board-mop500.c
> and the device just accesses the prcmu driver through its exported
> functions.
>
> Making it registered through the prcmu sounds like the right thing
> to do, but it requires funneling the board specific ab8500 platform
> data through to the prcmu device registration, something like the
> patch below, which is not really making things nicer overall.

The patch doesn't look awful. There are more '-' than '+', and it's only 
a temporary solution, as the plan is to go solely DT once it's been 
proven viable and ST-Ericsson's delta has been DT:ed and upstreamed anyway.

> diff --git a/arch/arm/mach-ux500/board-mop500.c b/arch/arm/mach-ux500/board-mop500.c
> index 1509a3c..f8fae8c 100644
> --- a/arch/arm/mach-ux500/board-mop500.c
> +++ b/arch/arm/mach-ux500/board-mop500.c
> @@ -197,24 +197,6 @@ static struct ab8500_platform_data ab8500_platdata = {
>   	.gpio		= &ab8500_gpio_pdata,
>   };
>
> -static struct resource ab8500_resources[] = {
> -	[0] = {
> -		.start	= IRQ_DB8500_AB8500,
> -		.end	= IRQ_DB8500_AB8500,
> -		.flags	= IORESOURCE_IRQ
> -	}
> -};
> -
> -struct platform_device ab8500_device = {
> -	.name = "ab8500-core",
> -	.id = 0,
> -	.dev = {
> -		.platform_data = &ab8500_platdata,
> -	},
> -	.num_resources = 1,
> -	.resource = ab8500_resources,
> -};
> -
>   /*
>    * TPS61052
>    */
> @@ -460,7 +442,6 @@ static struct hash_platform_data u8500_hash1_platform_data = {
>   /* add any platform devices here - TODO */
>   static struct platform_device *mop500_platform_devs[] __initdata = {
>   	&mop500_gpio_keys_device,
> -	&ab8500_device,
>   };
>
>   #ifdef CONFIG_STE_DMA40
> @@ -622,7 +603,6 @@ static struct platform_device *snowball_platform_devs[] __initdata = {
>   	&snowball_led_dev,
>   	&snowball_key_dev,
>   	&snowball_sbnet_dev,
> -	&ab8500_device,
>   };
>
>   static struct platform_device *snowball_of_platform_devs[] __initdata = {
> @@ -639,9 +619,8 @@ static void __init mop500_init_machine(void)
>   	mop500_gpio_keys[0].gpio = GPIO_PROX_SENSOR;
>
>   	mop500_pinmaps_init();
> -	parent = u8500_init_devices();
> +	parent = u8500_init_devices(&ab8500_platform_data);
>
> -	/* FIXME: parent of ab8500 should be prcmu */
>   	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
>   		mop500_platform_devs[i]->dev.parent = parent;
>
> @@ -674,7 +653,8 @@ static void __init snowball_init_machine(void)
>   	int i;
>
>   	snowball_pinmaps_init();
> -	parent = u8500_init_devices();
> +
> +	parent = u8500_init_devices(&ab8500_platform_data);
>
>   	for (i = 0; i < ARRAY_SIZE(snowball_platform_devs); i++)
>   		snowball_platform_devs[i]->dev.parent = parent;
> @@ -706,7 +686,7 @@ static void __init hrefv60_init_machine(void)
>   	mop500_gpio_keys[0].gpio = HREFV60_PROX_SENSE_GPIO;
>
>   	hrefv60_pinmaps_init();
> -	parent = u8500_init_devices();
> +	parent = u8500_init_devices(&ab8500_platform_data);
>
>   	for (i = 0; i < ARRAY_SIZE(mop500_platform_devs); i++)
>   		mop500_platform_devs[i]->dev.parent = parent;
> diff --git a/arch/arm/mach-ux500/cpu-db8500.c b/arch/arm/mach-ux500/cpu-db8500.c
> index 33275eb..6cc247c 100644
> --- a/arch/arm/mach-ux500/cpu-db8500.c
> +++ b/arch/arm/mach-ux500/cpu-db8500.c
> @@ -207,7 +207,7 @@ static struct device * __init db8500_soc_device_init(void)
>   /*
>    * This function is called from the board init
>    */
> -struct device * __init u8500_init_devices(void)
> +struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500)
>   {
>   	struct device *parent;
>   	int i;
> @@ -224,6 +224,8 @@ struct device * __init u8500_init_devices(void)
>   	for (i = 0; i < ARRAY_SIZE(platform_devs); i++)
>   		platform_devs[i]->dev.parent = parent;
>
> +	db8500_prcmu_device.dev.platform_data = ab8500;
> +
>   	platform_add_devices(platform_devs, ARRAY_SIZE(platform_devs));
>
>   	return parent;
> diff --git a/arch/arm/mach-ux500/include/mach/setup.h b/arch/arm/mach-ux500/include/mach/setup.h
> index 8b7ed82..7940615 100644
> --- a/arch/arm/mach-ux500/include/mach/setup.h
> +++ b/arch/arm/mach-ux500/include/mach/setup.h
> @@ -17,7 +17,7 @@
>   void __init ux500_map_io(void);
>   extern void __init u8500_map_io(void);
>
> -extern struct device * __init u8500_init_devices(void);
> +extern struct device * __init u8500_init_devices(struct ab8500_platform_data *ab8500);
>
>   extern void __init ux500_init_irq(void);
>   extern void __init ux500_init_late(void);
> diff --git a/drivers/mfd/db8500-prcmu.c b/drivers/mfd/db8500-prcmu.c
> index 50e83dc5..fc0bd4e 100644
> --- a/drivers/mfd/db8500-prcmu.c
> +++ b/drivers/mfd/db8500-prcmu.c
> @@ -2987,6 +2987,8 @@ static int __devinit db8500_prcmu_probe(struct platform_device *pdev)
>   		goto no_irq_return;
>   	}
>
> +	db8500_prcmu_devs[AB8500].platform_data = pdev->dev.platform_data;
> +
>   	if (cpu_is_u8500v20_or_later())
>   		prcmu_config_esram0_deep_sleep(ESRAM0_DEEP_SLEEP_STATE_RET);
>
>


-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog


