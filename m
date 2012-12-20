Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab2LTVfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 16:35:51 -0500
Received: from mga03.intel.com ([143.182.124.21]:62265 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab2LTVfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 16:35:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,326,1355126400"; 
   d="scan'208";a="234822707"
Message-ID: <50D384AF.40002@intel.com>
Date: Thu, 20 Dec 2012 13:35:43 -0800
From: David Cohen <david.a.cohen@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: Re: [PATCH 1/3] gpio-langwell: cleanup driver
References: <1355881933-15182-1-git-send-email-david.a.cohen@intel.com> <1355881933-15182-2-git-send-email-david.a.cohen@intel.com> <20121220011812.98B003E0AD7@localhost>
In-Reply-To: <20121220011812.98B003E0AD7@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 05:18 PM, Grant Likely wrote:
> On Tue, 18 Dec 2012 17:52:11 -0800, David Cohen <david.a.cohen@intel.com> wrote:
>> This patch cleans up cosmetic issues, remove useless functions and add
>> to_lnw_priv() macro to replace many usages of container_of().
>>
>> Change-Id: I70a8fadd20a42493271d91633739bdddff19c8d8
>> Signed-off-by: David Cohen <david.a.cohen@intel.com>
> Hi David. Comments below...

Hi Grant,

Thanks for comments. Let me go through them.

>
>> ---
>>   drivers/gpio/gpio-langwell.c |   64 ++++++++++++++----------------------------
>>   1 file changed, 21 insertions(+), 43 deletions(-)
>>
>> diff --git a/drivers/gpio/gpio-langwell.c b/drivers/gpio/gpio-langwell.c
>> index 202a992..8220c04 100644
>> --- a/drivers/gpio/gpio-langwell.c
>> +++ b/drivers/gpio/gpio-langwell.c
>> @@ -71,10 +71,12 @@ struct lnw_gpio {
>>   	struct irq_domain		*domain;
>>   };
>>   
>> +#define to_lnw_priv(chip)	container_of(chip, struct lnw_gpio, chip)
>> +
>>   static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
>>   			enum GPIO_REG reg_type)
>>   {
>> -	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
>> +	struct lnw_gpio *lnw = to_lnw_priv(chip);
>>   	unsigned nreg = chip->ngpio / 32;
>>   	u8 reg = offset / 32;
>>   	void __iomem *ptr;
>> @@ -86,7 +88,7 @@ static void __iomem *gpio_reg(struct gpio_chip *chip, unsigned offset,
>>   static void __iomem *gpio_reg_2bit(struct gpio_chip *chip, unsigned offset,
>>   				   enum GPIO_REG reg_type)
>>   {
>> -	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
>> +	struct lnw_gpio *lnw = to_lnw_priv(chip);
>>   	unsigned nreg = chip->ngpio / 32;
>>   	u8 reg = offset / 16;
>>   	void __iomem *ptr;
>> @@ -130,7 +132,7 @@ static void lnw_gpio_set(struct gpio_chip *chip, unsigned offset, int value)
>>   
>>   static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>>   {
>> -	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
>> +	struct lnw_gpio *lnw = to_lnw_priv(chip);
>>   	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
>>   	u32 value;
>>   	unsigned long flags;
>> @@ -153,7 +155,7 @@ static int lnw_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
>>   static int lnw_gpio_direction_output(struct gpio_chip *chip,
>>   			unsigned offset, int value)
>>   {
>> -	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
>> +	struct lnw_gpio *lnw = to_lnw_priv(chip);
>>   	void __iomem *gpdr = gpio_reg(chip, offset, GPDR);
>>   	unsigned long flags;
>>   
>> @@ -176,7 +178,7 @@ static int lnw_gpio_direction_output(struct gpio_chip *chip,
>>   
>>   static int lnw_gpio_to_irq(struct gpio_chip *chip, unsigned offset)
>>   {
>> -	struct lnw_gpio *lnw = container_of(chip, struct lnw_gpio, chip);
>> +	struct lnw_gpio *lnw = to_lnw_priv(chip);
>>   	return irq_create_mapping(lnw->domain, offset);
>>   }
> Nice cleanup above.
>
>>   
>> @@ -215,19 +217,14 @@ static int lnw_irq_type(struct irq_data *d, unsigned type)
>>   	return 0;
>>   }
>>   
>> -static void lnw_irq_unmask(struct irq_data *d)
>> -{
>> -}
>> -
>> -static void lnw_irq_mask(struct irq_data *d)
>> -{
>> -}
>> +static void lnw_irq_noop(struct irq_data *d) {}
> Umm, this looks entirely wrong. There needs to be either mask/unmask or
> enable/disable ops for irq_chips. Yes I see that this patch is just
> consolidating two empty functions, but they are two empty functions that
> appear to be completely wrong.

I see your point. The solution does not belong to a clean up patch,
so I'll just remove it from here.

>
>>   
>>   static struct irq_chip lnw_irqchip = {
>>   	.name		= "LNW-GPIO",
>> -	.irq_mask	= lnw_irq_mask,
>> -	.irq_unmask	= lnw_irq_unmask,
>> +	.irq_mask	= lnw_irq_noop,
>> +	.irq_unmask	= lnw_irq_noop,
>>   	.irq_set_type	= lnw_irq_type,
>> +	.irq_ack	= lnw_irq_noop,
>>   };
>>   
>>   static DEFINE_PCI_DEVICE_TABLE(lnw_gpio_ids) = {   /* pin number */
>> @@ -299,17 +296,6 @@ static const struct irq_domain_ops lnw_gpio_irq_ops = {
>>   	.xlate = irq_domain_xlate_twocell,
>>   };
>>   
>> -#ifdef CONFIG_PM
>> -static int lnw_gpio_runtime_resume(struct device *dev)
>> -{
>> -	return 0;
>> -}
>> -
>> -static int lnw_gpio_runtime_suspend(struct device *dev)
>> -{
>> -	return 0;
>> -}
>> -
>>   static int lnw_gpio_runtime_idle(struct device *dev)
>>   {
>>   	int err = pm_schedule_suspend(dev, 500);
>> @@ -320,16 +306,8 @@ static int lnw_gpio_runtime_idle(struct device *dev)
>>   	return -EBUSY;
>>   }
>>   
>> -#else
>> -#define lnw_gpio_runtime_suspend	NULL
>> -#define lnw_gpio_runtime_resume		NULL
>> -#define lnw_gpio_runtime_idle		NULL
>> -#endif
>> -
>>   static const struct dev_pm_ops lnw_gpio_pm_ops = {
>> -	.runtime_suspend = lnw_gpio_runtime_suspend,
>> -	.runtime_resume = lnw_gpio_runtime_resume,
>> -	.runtime_idle = lnw_gpio_runtime_idle,
>> +	SET_RUNTIME_PM_OPS(NULL, NULL, lnw_gpio_runtime_idle)
>>   };
> Also good.
>
>>   
>>   static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>> @@ -349,7 +327,7 @@ static int __devinit lnw_gpio_probe(struct pci_dev *pdev,
>>   	retval = pci_request_regions(pdev, "langwell_gpio");
>>   	if (retval) {
>>   		dev_err(&pdev->dev, "error requesting resources\n");
>> -		goto err2;
>> +		goto err;
> Renaming the labels just increases the noise in the diff. I prefer to
> see labels in the form "err-what-i-just-tried-to-do:" so they don't need
> to get reshuffled every time the code logic changes.
>
> There is no good reason for this change. Please drop it.

Maybe instead of drop it I'd prefer to fix the labels. They
are wrong currently.

Br, David

>
> g.
> .
>

