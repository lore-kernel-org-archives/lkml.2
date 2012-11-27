Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758287Ab2K0Hm7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 02:42:59 -0500
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:52111 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758047Ab2K0Hm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 02:42:57 -0500
Message-ID: <50B46F55.4000107@marvell.com>
Date: Tue, 27 Nov 2012 15:44:21 +0800
From: Qing Xu <qingx@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Chao Xie <cxie4@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH 1/7] mfd: max8925: add irqdomain for dt
References: <1352187429-9711-1-git-send-email-qingx@marvell.com> <CAN1soZwQ2bk_TteNvK=b0-CHBc=qs+EdbAHjtKA9gYD+p4XQUw@mail.gmail.com>
In-Reply-To: <CAN1soZwQ2bk_TteNvK=b0-CHBc=qs+EdbAHjtKA9gYD+p4XQUw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 27 Nov 2012 07:42:49.0634 (UTC) FILETIME=[CCB4A020:01CDCC72]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 05:05 PM, Haojian Zhuang wrote:
> On Tue, Nov 6, 2012 at 3:37 PM, Qing Xu <qingx@marvell.com> wrote:
>> From: Qing Xu <qingx@marvell.com>
>>
>> Add irqdomains for max8925's main irq, and touch irq.
>> Wrap irq register operations into irqdomain's map func.
>> it is necessary for dt support.
>> Also, add dt support for max8925 driver.
>>
>> Signed-off-by: Qing Xu <qingx@marvell.com>
>> ---
>>   drivers/mfd/max8925-core.c  |   87 ++++++++++++++++++++++++++++---------------
>>   drivers/mfd/max8925-i2c.c   |   32 +++++++++++++++-
>>   include/linux/mfd/max8925.h |   12 ++++-
>>   3 files changed, 96 insertions(+), 35 deletions(-)
>>
>> diff --git a/drivers/mfd/max8925-core.c b/drivers/mfd/max8925-core.c
>> index 1e0ab0a..dcc218a 100644
>> --- a/drivers/mfd/max8925-core.c
>> +++ b/drivers/mfd/max8925-core.c
>> @@ -14,10 +14,14 @@
>>   #include <linux/i2c.h>
>>   #include <linux/irq.h>
>>   #include <linux/interrupt.h>
>> +#include <linux/irqdomain.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/regulator/machine.h>
>>   #include <linux/mfd/core.h>
>>   #include <linux/mfd/max8925.h>
>> +#include <linux/of.h>
>> +#include <linux/of_platform.h>
>> +#include <linux/of_irq.h>
>>
>>   static struct resource bk_resources[] __devinitdata = {
>>          { 0x84, 0x84, "mode control", IORESOURCE_REG, },
>> @@ -639,17 +643,34 @@ static struct irq_chip max8925_irq_chip = {
>>          .irq_disable    = max8925_irq_disable,
>>   };
>>
>> +static int max8925_irq_domain_map(struct irq_domain *d, unsigned int virq,
>> +                                irq_hw_number_t hw)
>> +{
>> +       irq_set_chip_data(virq, d->host_data);
>> +       irq_set_chip_and_handler(virq, &max8925_irq_chip, handle_edge_irq);
>> +       irq_set_nested_thread(virq, 1);
>> +#ifdef CONFIG_ARM
>> +       set_irq_flags(virq, IRQF_VALID);
>> +#else
>> +       irq_set_noprobe(virq);
>> +#endif
>> +       return 0;
>> +}
>> +
>> +static struct irq_domain_ops max8925_irq_domain_ops = {
>> +       .map    = max8925_irq_domain_map,
>> +       .xlate  = irq_domain_xlate_onetwocell,
>> +};
>> +
>> +
>>   static int max8925_irq_init(struct max8925_chip *chip, int irq,
>>                              struct max8925_platform_data *pdata)
>>   {
>>          unsigned long flags = IRQF_TRIGGER_FALLING | IRQF_ONESHOT;
>> -       int i, ret;
>> -       int __irq;
>> +       int ret;
>> +       int tsc_irq;
>> +       struct device_node *node = chip->dev->of_node;
>>
>> -       if (!pdata || !pdata->irq_base) {
>> -               dev_warn(chip->dev, "No interrupt support on IRQ base\n");
>> -               return -EINVAL;
>> -       }
>>          /* clear all interrupts */
>>          max8925_reg_read(chip->i2c, MAX8925_CHG_IRQ1);
>>          max8925_reg_read(chip->i2c, MAX8925_CHG_IRQ2);
>> @@ -667,45 +688,51 @@ static int max8925_irq_init(struct max8925_chip *chip, int irq,
>>          max8925_reg_write(chip->rtc, MAX8925_RTC_IRQ_MASK, 0xff);
>>
>>          mutex_init(&chip->irq_lock);
>> -       chip->core_irq = irq;
>> -       chip->irq_base = pdata->irq_base;
>>
>> -       /* register with genirq */
>> -       for (i = 0; i < ARRAY_SIZE(max8925_irqs); i++) {
>> -               __irq = i + chip->irq_base;
>> -               irq_set_chip_data(__irq, chip);
>> -               irq_set_chip_and_handler(__irq, &max8925_irq_chip,
>> -                                        handle_edge_irq);
>> -               irq_set_nested_thread(__irq, 1);
>> -#ifdef CONFIG_ARM
>> -               set_irq_flags(__irq, IRQF_VALID);
>> -#else
>> -               irq_set_noprobe(__irq);
>> -#endif
>> -       }
>> -       if (!irq) {
>> -               dev_warn(chip->dev, "No interrupt support on core IRQ\n");
>> -               goto tsc_irq;
>> +       /* domain1: init charger/rtc/onkey irq domain*/
>> +       chip->irq_base = irq_alloc_descs(-1, 0, MAX8925_NR_IRQS, 0);
>> +       if (chip->irq_base < 0) {
>> +               dev_err(chip->dev, "Failed to allocate interrupts, ret:%d\n",
>> +                       chip->irq_base);
>> +               return -EBUSY;
>>          }
>>
>> +       irq_domain_add_legacy(node, MAX8925_NR_IRQS, chip->irq_base, 0,
>> +                             &max8925_irq_domain_ops, chip);
>> +       chip->core_irq = irq;
>> +       if (!chip->core_irq)
>> +               return -EBUSY;
>> +
>>          ret = request_threaded_irq(irq, NULL, max8925_irq, flags,
>>                                     "max8925", chip);
>>          if (ret) {
>>                  dev_err(chip->dev, "Failed to request core IRQ: %d\n", ret);
>>                  chip->core_irq = 0;
>> +               return -EBUSY;
>>          }
>>
>> -tsc_irq:
>> +       /* domain2: init touch irq domain*/
>>          /* mask TSC interrupt */
>>          max8925_reg_write(chip->adc, MAX8925_TSC_IRQ_MASK, 0x0f);
>>
>> -       if (!pdata->tsc_irq) {
>> +       chip->tsc_irq_base = irq_alloc_descs(-1, 0, MAX8925_NR_TSC_IRQS, 0);
>> +       if (chip->tsc_irq < 0) {
>> +               dev_err(chip->dev, "Failed to allocate interrupts, ret:%d\n",
>> +                       chip->tsc_irq_base);
>> +               return -EBUSY;
>> +       }
>> +
>> +       irq_domain_add_legacy(node, MAX8925_NR_TSC_IRQS, chip->tsc_irq_base, 0,
>> +                             &max8925_irq_domain_ops, chip);
>> +
>> +       tsc_irq = irq_of_parse_and_map(node, 1);
>> +
> I'm confused on this. Let's look at your definition in DTS.
>
> +                               pmic: max8925@3c {
> +                                       compatible = "marvell,max8925";
> +                                       reg = <0x3c>;
> +                                       interrupts = <1 0>;
> +                                       interrupt-parent = <&intcmux4>;
> +                                       interrupt-controller;
> +                                       #interrupt-cells = <1>;
> +
> pmic is defined as interrupt controller. So it could be referenced as
> interrupt-parent
> by other drivers.
>
> Now you split TSC_IRQS from original MAX8925_NR_IRQS. So TSC_IRQS are calculated
> from 0. How do you distinguish TSC_IRQS from normal MAX8925_IRQS? Only
> one phandle
> is defined in your DTS file.
>
> So either you keep TSC_IRQS in MAX8925_NR_IRQS, or you add a child
> node to define
> a new interrupt controller for tsc irqs.
>
>> +       if (!tsc_irq) {
>>                  dev_warn(chip->dev, "No interrupt support on TSC IRQ\n");
>>                  return 0;
>>          }
>> -       chip->tsc_irq = pdata->tsc_irq;
>> -
>> -       ret = request_threaded_irq(chip->tsc_irq, NULL, max8925_tsc_irq,
>> +       chip->tsc_irq = tsc_irq;
>> +       ret = request_threaded_irq(tsc_irq, NULL, max8925_tsc_irq,
>>                                     flags, "max8925-tsc", chip);
>>          if (ret) {
>>                  dev_err(chip->dev, "Failed to request TSC IRQ: %d\n", ret);
>> @@ -876,7 +903,7 @@ int __devinit max8925_device_init(struct max8925_chip *chip,
>>          if (pdata && pdata->power) {
>>                  ret = mfd_add_devices(chip->dev, 0, &power_devs[0],
>>                                          ARRAY_SIZE(power_devs),
>> -                                     &power_supply_resources[0], 0, NULL);
>> +                                       &power_supply_resources[0], 0, NULL);
>>                  if (ret < 0) {
>>                          dev_err(chip->dev, "Failed to add power supply "
>>                                  "subdev\n");
>> diff --git a/drivers/mfd/max8925-i2c.c b/drivers/mfd/max8925-i2c.c
>> index d9e4b36..b713be6 100644
>> --- a/drivers/mfd/max8925-i2c.c
>> +++ b/drivers/mfd/max8925-i2c.c
>> @@ -135,13 +135,35 @@ static const struct i2c_device_id max8925_id_table[] = {
>>   };
>>   MODULE_DEVICE_TABLE(i2c, max8925_id_table);
>>
>> +
>> +static int __devinit max8925_dt_init(struct device_node *np,
>> +                                   struct device *dev,
>> +                                   struct max8925_platform_data *pdata)
>> +{
>> +       return 0;
>> +}
>> +
> If you don't need this interface, you need define it.
>
>>   static int __devinit max8925_probe(struct i2c_client *client,
>>                                     const struct i2c_device_id *id)
>>   {
>>          struct max8925_platform_data *pdata = client->dev.platform_data;
>>          static struct max8925_chip *chip;
>> +       struct device_node *node = client->dev.of_node;
>> +       int ret;
>>
>> -       if (!pdata) {
>> +       if (node && !pdata) {
>> +               /* parse DT to get platform data */
>> +               pdata = devm_kzalloc(&client->dev,
>> +                                    sizeof(struct max8925_platform_data),
>> +                                    GFP_KERNEL);
>> +               if (!pdata)
>> +                       return -ENOMEM;
>> +               ret = max8925_dt_init(node, &client->dev, pdata);
>> +               if (ret) {
>> +                       pr_info("%s: failed to parse dt info\n", __func__);
>> +                       return -EINVAL;
>> +               }
>> +       } else if (!pdata) {
>>                  pr_info("%s: platform data is missing\n", __func__);
>>                  return -EINVAL;
>>          }
>> @@ -203,11 +225,18 @@ static int max8925_resume(struct device *dev)
>>
>>   static SIMPLE_DEV_PM_OPS(max8925_pm_ops, max8925_suspend, max8925_resume);
>>
>> +static const struct of_device_id max8925_dt_ids[] = {
>> +       { .compatible = "marvell,max8925", },
> max8925 isn't the product of Marvell. The vendor is maxium.
>> +       {},
>> +};
>> +MODULE_DEVICE_TABLE(of, max8925_dt_ids);
>> +
>>   static struct i2c_driver max8925_driver = {
>>          .driver = {
>>                  .name   = "max8925",
>>                  .owner  = THIS_MODULE,
>>                  .pm     = &max8925_pm_ops,
>> +               .of_match_table = of_match_ptr(max8925_dt_ids),
>>          },
>>          .probe          = max8925_probe,
>>          .remove         = __devexit_p(max8925_remove),
>> @@ -217,7 +246,6 @@ static struct i2c_driver max8925_driver = {
>>   static int __init max8925_i2c_init(void)
>>   {
>>          int ret;
>> -
>>          ret = i2c_add_driver(&max8925_driver);
>>          if (ret != 0)
>>                  pr_err("Failed to register MAX8925 I2C driver: %d\n", ret);
>> diff --git a/include/linux/mfd/max8925.h b/include/linux/mfd/max8925.h
>> index 74d8e29..67bc540 100644
>> --- a/include/linux/mfd/max8925.h
>> +++ b/include/linux/mfd/max8925.h
>> @@ -185,11 +185,18 @@ enum {
>>          MAX8925_IRQ_GPM_SYSCKEN_R,
>>          MAX8925_IRQ_RTC_ALARM1,
>>          MAX8925_IRQ_RTC_ALARM0,
>> +       MAX8925_NR_IRQS,
>> +};
>> +
>> +/**/
>> +enum {
>>          MAX8925_IRQ_TSC_STICK,
>>          MAX8925_IRQ_TSC_NSTICK,
>> -       MAX8925_NR_IRQS,
>> +       MAX8925_NR_TSC_IRQS,
>>   };
>>
>> +
>> +
>>   struct max8925_chip {
>>          struct device           *dev;
>>          struct i2c_client       *i2c;
>> @@ -201,7 +208,7 @@ struct max8925_chip {
>>          int                     irq_base;
>>          int                     core_irq;
>>          int                     tsc_irq;
>> -
>> +       int                     tsc_irq_base;
>>          unsigned int            wakeup_flag;
>>   };
>>
>> @@ -259,7 +266,6 @@ struct max8925_platform_data {
>>          struct regulator_init_data      *ldo20;
>>
>>          int             irq_base;
>> -       int             tsc_irq;
>>   };
>>
>>   extern int max8925_reg_read(struct i2c_client *, int);
>> --
>> 1.7.0.4
>>

update both dts and this patch in v2, please help me review again,
thank a lot!!

-Qing

