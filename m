Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2DQSLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 14:11:54 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:62312 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752824Ab2DQSLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 14:11:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120330220619.334AC3E054E@localhost>
References: <1332582590-16382-1-git-send-email-thomas.abraham@linaro.org>
	<1332582590-16382-2-git-send-email-thomas.abraham@linaro.org>
	<20120330220619.334AC3E054E@localhost>
Date: Tue, 17 Apr 2012 23:41:51 +0530
Message-ID: <CAJuYYwRa-_0HWeSuOgAT20dCCDdg=NBruQ9_m28TFZkXMRJhaw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] mfd: add irq domain support for max8997 interrupts
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 31 March 2012 03:36, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Sat, 24 Mar 2012 15:19:49 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> Add irq domain support for max8997 interrupts. The reverse mapping method
>> used is linear mapping since the sub-drivers of max8997 such as regulator
>> and charger drivers can use the max8997 irq_domain to get the linux irq
>> number for max8997 interrupts. All uses of irq_base in platform data and
>> max8997 driver private data are removed.
>>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> Acked-by: Grant Likely <grant.likely@secretlab.ca>
>> ---
>>  arch/arm/mach-exynos/mach-nuri.c    |    4 --
>>  arch/arm/mach-exynos/mach-origen.c  |    1 -
>>  drivers/mfd/max8997-irq.c           |   61 ++++++++++++++++++++--------------
>>  drivers/mfd/max8997.c               |    1 -
>>  include/linux/mfd/max8997-private.h |    4 ++-
>>  include/linux/mfd/max8997.h         |    1 -
>>  6 files changed, 39 insertions(+), 33 deletions(-)
>>
>> diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
>> index 7ac81ce..b21d85d 100644
>> --- a/arch/arm/mach-exynos/mach-nuri.c
>> +++ b/arch/arm/mach-exynos/mach-nuri.c
>> @@ -1077,12 +1077,8 @@ static struct platform_device nuri_max8903_device = {
>>  static void __init nuri_power_init(void)
>>  {
>>       int gpio;
>> -     int irq_base = IRQ_GPIO_END + 1;
>>       int ta_en = 0;
>>
>> -     nuri_max8997_pdata.irq_base = irq_base;
>> -     irq_base += MAX8997_IRQ_NR;
>> -
>>       gpio = EXYNOS4_GPX0(7);
>>       gpio_request(gpio, "AP_PMIC_IRQ");
>>       s3c_gpio_cfgpin(gpio, S3C_GPIO_SFN(0xf));
>> diff --git a/arch/arm/mach-exynos/mach-origen.c b/arch/arm/mach-exynos/mach-origen.c
>> index 827cb99..d3b2e9d 100644
>> --- a/arch/arm/mach-exynos/mach-origen.c
>> +++ b/arch/arm/mach-exynos/mach-origen.c
>> @@ -424,7 +424,6 @@ static struct max8997_platform_data __initdata origen_max8997_pdata = {
>>       .buck1_gpiodvs  = false,
>>       .buck2_gpiodvs  = false,
>>       .buck5_gpiodvs  = false,
>> -     .irq_base       = IRQ_GPIO_END + 1,
>>
>>       .ignore_gpiodvs_side_effect = true,
>>       .buck125_default_idx = 0x0,
>> diff --git a/drivers/mfd/max8997-irq.c b/drivers/mfd/max8997-irq.c
>> index 09274cf..00390a1 100644
>> --- a/drivers/mfd/max8997-irq.c
>> +++ b/drivers/mfd/max8997-irq.c
>> @@ -142,7 +142,8 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
>>  static const inline struct max8997_irq_data *
>>  irq_to_max8997_irq(struct max8997_dev *max8997, int irq)
>>  {
>> -     return &max8997_irqs[irq - max8997->irq_base];
>> +     struct irq_data *data = irq_get_irq_data(irq);
>> +     return &max8997_irqs[data->hwirq];
>>  }
>
> Haha, this is kind of bogus now.  There are only two users of this
> function, and *both* of them already have the irq_data pointer.
> Instead of this, delete this function entirely and make each caller
> derefernce max8997_irqs directly:
>
>        const struct max8997_irq_data *irq_data = &max8997_irqs[data->hwirq];
>
> Otherwise, looks good.  After fixing you can add my:
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Hi Grant,

Thanks for the suggestion. I have modified the code accordingly and
included your ack.

Regards,
Thomas.
