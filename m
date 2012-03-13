Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757347Ab2CMGF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 02:05:56 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:34919 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755873Ab2CMGFy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 02:05:54 -0400
MIME-Version: 1.0
In-Reply-To: <20120313032832.655983E07E4@localhost>
References: <1330000688-11226-1-git-send-email-thomas.abraham@linaro.org>
	<1330000688-11226-2-git-send-email-thomas.abraham@linaro.org>
	<20120313032832.655983E07E4@localhost>
Date: Tue, 13 Mar 2012 11:35:53 +0530
Message-ID: <CAJuYYwTKMWgits6xd0UUvRPwr40NwJfO2HncUOW9J=EZbFs8=Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] mfd: add irq domain support for max8997 interrupts
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-kernel@vger.kernel.org, k.lewandowsk@samsung.com,
        devicetree-discuss@lists.ozlabs.org, rob.herring@calxeda.com,
        kgene.kim@samsung.com, broonie@opensource.wolfsonmicro.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        dg77.kim@samsung.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2012 08:58, Grant Likely <grant.likely@secretlab.ca> wrote:
> On Thu, 23 Feb 2012 18:08:07 +0530, Thomas Abraham <thomas.abraham@linaro.org> wrote:
>> Add irq domain support for max8997 interrupts. The reverse mapping method
>> used is linear mapping since the sub-drivers of max8997 such as regulator
>> and charger drivers can use the max8997 irq_domain to get the linux irq
>> number for max8997 interrupts. All uses of irq_base in platform data and
>> max8997 driver private data are removed.
>>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>> Cc: MyungJoo Ham <myungjoo.ham@samsung.com>
>> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
>> ---
>>  arch/arm/mach-exynos/mach-nuri.c    |    4 --
>>  arch/arm/mach-exynos/mach-origen.c  |    1 -
>>  drivers/mfd/max8997-irq.c           |   60 ++++++++++++++++++++--------------
>>  drivers/mfd/max8997.c               |    1 -
>>  include/linux/mfd/max8997-private.h |    4 ++-
>>  include/linux/mfd/max8997.h         |    1 -
>>  6 files changed, 38 insertions(+), 33 deletions(-)
>
> Nice patch.  Nice diffstat too.  Some comments below, but I'm happy with where
> this is at.
>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>

Thank you Grant for reviewing this patch.

>
>>
>> diff --git a/arch/arm/mach-exynos/mach-nuri.c b/arch/arm/mach-exynos/mach-nuri.c
>> index a6b9162..1e9ba12 100644
>> --- a/arch/arm/mach-exynos/mach-nuri.c
>> +++ b/arch/arm/mach-exynos/mach-nuri.c
>> @@ -1078,12 +1078,8 @@ static struct platform_device nuri_max8903_device = {
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
>> index 02c242e..328dadb 100644
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
>> index 09274cf..3d8c9d1 100644
>> --- a/drivers/mfd/max8997-irq.c
>> +++ b/drivers/mfd/max8997-irq.c
>> @@ -142,7 +142,8 @@ static void max8997_irq_sync_unlock(struct irq_data *data)
>>  static const inline struct max8997_irq_data *
>>  irq_to_max8997_irq(struct max8997_dev *max8997, int irq)
>>  {
>> -     return &max8997_irqs[irq - max8997->irq_base];
>> +     struct irq_data *data = irq_get_irq_data(irq);
>> +     return &max8997_irqs[data->hwirq];
>
> Hahaha.  The max8997_irqs table is kind of overdone when the group and mask values
> can be arithmetically derived from the hwirq number..

Yes, I agree. Each group could have maximum of 8 interrupts. Then,
data->hwirq % 8 will be the group number and data->hwirq & 7 would be
the mask. The enum max8997_irq can then be adjusted to accommodate
unused irq numbers.

>
> This change is fine, but the driver could use some refactoring.  :-)

Ok.

>
>>  }
>>
>>  static void max8997_irq_mask(struct irq_data *data)
>> @@ -182,7 +183,7 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>>       u8 irq_reg[MAX8997_IRQ_GROUP_NR] = {};
>>       u8 irq_src;
>>       int ret;
>> -     int i;
>> +     int i, cur_irq;
>>
>>       ret = max8997_read_reg(max8997->i2c, MAX8997_REG_INTSRC, &irq_src);
>>       if (ret < 0) {
>> @@ -269,8 +270,10 @@ static irqreturn_t max8997_irq_thread(int irq, void *data)
>>
>>       /* Report */
>>       for (i = 0; i < MAX8997_IRQ_NR; i++) {
>> -             if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask)
>> -                     handle_nested_irq(max8997->irq_base + i);
>> +             if (irq_reg[max8997_irqs[i].group] & max8997_irqs[i].mask) {
>> +                     cur_irq = irq_find_mapping(max8997->irq_domain, i);
>> +                     handle_nested_irq(cur_irq);
>> +             }
>
> Well, if you're using the linear mapping, then only actually allocated irqs will
> have a mapping set up.  So the driver could simply do:
>
>        for (i = 0; i < MAX8997_IRQ_NR; i++) {
>                cur_irq = irq_find_mapping(max8997->irq_domain, i);
>                if (cur_irq)
>                        handle_nested_irq(cur_irq);
>        }

Thanks for the suggestion. I will include this change and repost this patch.

Regards,
Thomas.

[...]
